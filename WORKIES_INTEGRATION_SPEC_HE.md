# WORKIES AIO — Integration Specification (REST APIs)

## 1. מטרת המסמך
להגדיר מפרט אינטגרציות פיתוחי עבור:
- Pickspace API (OAS3)
- Sumit API (OpenAPI)
- Zoho CRM API v8
- SAP (adapter/export phase)

כולל:
- Endpoints
- Data contracts
- Sync frequency
- Error handling
- Ownership

---

## 2. עקרונות אינטגרציה
1. API-first בלבד (ללא Make)
2. כל אינטגרציה דרך Integration Service פנימי (BFF/Orchestrator)
3. שימוש ב-Idempotency keys לפעולות create/update קריטיות
4. Retry policy אחיד (3 ניסיונות Exponential Backoff)
5. DLQ עבור כשלונות מתמשכים
6. Audit לכל פעולה עסקית משמעותית

---

## 3. Authentication & Secrets
## Pickspace
- Auth: Bearer token (לפי swagger security bearer)
- Secret storage: Vault/Secret Manager בלבד

## Sumit
- Credentials בגוף הבקשה (CompanyID + APIKey) לפי ה-API
- יש לעטוף דרך service backend בלבד (לא מה-frontend)

## Zoho CRM
- OAuth2 (Zoho-oauthtoken)
- Token refresh אוטומטי בצד שרת

## SAP
- שלב 1: export adapter / batch feed
- שלב 2: REST/ODATA ישיר (בהתאם למימוש צד SAP)

---

## 4. Canonical Models (שכבת מיפוי פנימית)
האינטגרציות לא עובדות ישירות מול UI אלא דרך מודלים אחידים:
- LeadCanonical
- CustomerCanonical
- ContractCanonical
- InvoiceCanonical
- PaymentCanonical
- OfficeCanonical
- TaskCanonical

כל Connector ממפה:
- External -> Canonical
- Canonical -> External

---

## 5. Pickspace Integration Spec
מקור: `https://workies.pickspace.com/api-v2/swagger#/`

## 5.1 Sales/Leads
| מטרה | Method + Endpoint | כיוון | תדירות |
|---|---|---|---|
| שליפת לידים | GET `/api-v2/leads` | Pull -> Workies | כל 5 דק' |
| יצירת ליד | POST `/api-v2/leads` | Workies -> Push | בזמן אמת |
| עדכון ליד | PATCH `/api-v2/leads/{id}` | דו-כיווני | בזמן אמת |
| המרת ליד ללקוח | POST `/api-v2/leads/convert-lead-to-member/{id}` | Workies -> Push | ידני/אירוע |

## 5.2 Pipeline
| מטרה | Method + Endpoint | כיוון | תדירות |
|---|---|---|---|
| שליפת pipelines | GET `/api-v2/pipelines` | Pull | יומי + cache |
| שליפת שלבי משפך | GET `/api-v2/pipeline-stages/{pipelineId}` | Pull | יומי |
| עדכון שלב | PATCH `/api-v2/pipeline-stages/{pipelineStageId}` | Push | בזמן אמת |

## 5.3 Members/Contracts/Offices
| מטרה | Method + Endpoint | כיוון | תדירות |
|---|---|---|---|
| שליפת לקוחות | GET `/api-v2/members` | Pull | כל שעה |
| שליפת חוזים | GET `/api-v2/contracts` | Pull | כל שעה |
| שליפת חוזה לפי מזהה | GET `/api-v2/contracts/{id}` | Pull | לפי צורך |
| שליפת משרדים | GET `/api-v2/offices` | Pull | כל 4 שעות |
| שליפת זמינות משרד | GET `/api-v2/offices/location/{id}/available` | Pull | כל שעה |

## 5.4 Finance/Collections
| מטרה | Method + Endpoint | כיוון | תדירות |
|---|---|---|---|
| שליפת חשבוניות | GET `/api-v2/invoices` | Pull | כל 15 דק' |
| שליפת unpaid current month | GET `/api-v2/invoices/getAllUnpaidInvoicesForCurrentMonth` | Pull | יומי |
| שליפת דלינקוונסי | GET `/api-v2/invoices/delinquency` | Pull | יומי |
| יצירת תשלום | POST `/api-v2/payments` | Push | בזמן אמת |
| שליפת תשלומים | GET `/api-v2/payments` | Pull | כל 15 דק' |

## 5.5 Error handling (Pickspace)
- 401/403: refresh token / permission alert
- 409: optimistic conflict -> reload + retry
- 5xx/timeout: retry x3 -> DLQ -> alert ops

---

## 6. Sumit Integration Spec
מקור Swagger UI: `https://app.sumit.co.il/help/developers/swagger/index.html`  
OpenAPI: `https://app.sumit.co.il/swagger/v1/swagger.json`

## 6.1 Customers
| מטרה | Method + Endpoint | כיוון | תדירות |
|---|---|---|---|
| יצירה/איתור לקוח | POST `/accounting/customers/create/` | Workies -> Sumit | בזמן אמת |
| עדכון לקוח | POST `/accounting/customers/update/` | Workies -> Sumit | בזמן אמת |
| יצירת הערה לקוח | POST `/accounting/customers/createremark/` | Workies -> Sumit | לפי צורך |

## 6.2 Documents (Invoices/Receipts)
| מטרה | Method + Endpoint | כיוון | תדירות |
|---|---|---|---|
| יצירת מסמך חשבונאי | POST `/accounting/documents/create/` | Workies -> Sumit | בזמן אמת |
| שליחת מסמך במייל | POST `/accounting/documents/send/` | Workies -> Sumit | בזמן אמת |
| שליפת פרטי מסמך | POST `/accounting/documents/getdetails/` | Pull | לפי צורך |
| שליפת PDF מסמך | POST `/accounting/documents/getpdf/` | Pull | לפי צורך |
| ביטול מסמך | POST `/accounting/documents/cancel/` | Workies -> Sumit | באישור בלבד |
| רשימת מסמכים | POST `/accounting/documents/list/` | Pull | כל 30 דק' |
| חוב לקוח | POST `/accounting/documents/getdebt/` | Pull | יומי |
| דוח חובות | POST `/accounting/documents/getdebtreport/` | Pull | יומי |

## 6.3 Billing/Payments
| מטרה | Method + Endpoint | כיוון | תדירות |
|---|---|---|---|
| חיוב תשלום | POST `/billing/payments/charge/` | Workies -> Sumit | בזמן אמת |
| שליפת תשלום | POST `/billing/payments/get/` | Pull | לפי צורך |
| רשימת תשלומים | POST `/billing/payments/list/` | Pull | כל 30 דק' |
| אמצעי תשלום ללקוח | POST `/billing/paymentmethods/getforcustomer/` | Pull | לפי צורך |
| עדכון אמצעי תשלום | POST `/billing/paymentmethods/setforcustomer/` | Push | באישור |
| חיובים מחזוריים ללקוח | POST `/billing/recurring/listforcustomer/` | Pull | יומי |

## 6.4 Error handling (Sumit)
- API returns business errors בגוף תשובה: חייבים parser אחיד
- כשל create document: לא לבצע retry אוטומטי ללא idempotency check
- כשל charge: retry רק אם מוגדר transient; אחרת מסלול חריגה ידני

---

## 7. Zoho CRM Integration Spec (v8)
מקור:
- Modules API: `GET /settings/modules`
- Records API: `GET /{module_api_name}`, `GET /{module_api_name}/{record_id}`

## 7.1 Core Modules for Workies
- Leads
- Accounts
- Contacts
- Deals
- Tasks

## 7.2 Endpoints שימושיים
| מטרה | Endpoint | כיוון | תדירות |
|---|---|---|---|
| שליפת מודולים | GET `/crm/v8/settings/modules` | Pull | יומי |
| שליפת Leads | GET `/crm/v8/Leads` | Pull | כל 5 דק' |
| שליפת Deal | GET `/crm/v8/Deals/{id}` | Pull | לפי צורך |
| שליפת Contact | GET `/crm/v8/Contacts/{id}` | Pull | לפי צורך |

## 7.3 Pagination & Limits
- max 200 records per call
- עד 2000 עם page רגיל
- מעבר לכך: page_token flow
- tokens תקפים לזמן מוגבל (יש לבדוק expiry)

## 7.4 Error handling (Zoho)
- 401 OAuth scope/token mismatch -> refresh token flow
- 400 required params / pagination mismatch -> fail fast + alert
- 429/limit -> backoff & retry window

---

## 8. SAP Integration Spec (Phase 1)
## שלב 1 — Adapter Feed
| מטרה | פורמט | כיוון | תדירות |
|---|---|---|---|
| יצוא חשבוניות מאושרות | CSV/JSON batch | Workies -> SAP Adapter | יומי |
| יצוא תשלומים | CSV/JSON batch | Workies -> SAP Adapter | יומי |
| סטטוס קליטה | callback/report | SAP Adapter -> Workies | יומי |

## שלב 2 — API Direct (עתידי)
- REST/OData endpoints לפי זמינות SAP team
- replace batch with near real-time sync

---

## 9. Sync Matrix (מי מקור אמת)
| Entity | SoT | Mirror Systems |
|---|---|---|
| Lead | Zoho/Pickspace (להכרעה) | Workies |
| Customer | Pickspace/Sumit (לפי תחום) | Workies |
| Contract | Pickspace | Workies |
| Invoice | Sumit/Pickspace Finance | Workies |
| Payment | Sumit + Pickspace payments | Workies |
| Office | Pickspace | Workies |
| Task | Workies/Monday (transition) | CRM/ops |

---

## 10. Webhooks & Eventing
מומלץ:
- inbound webhook endpoint ב-Workies לכל מערכת תומכת
- חתימת webhook validation
- dead-letter table לאירועים כושלים

Events קריטיים:
1. Lead created/updated
2. Invoice created/sent/paid
3. Payment failed/chargeback
4. Contract approved/declined

---

## 11. Retry, Idempotency, Dead-letter
1. Retry:
   - 1st: 30s
   - 2nd: 2m
   - 3rd: 10m
2. Idempotency:
   - create invoice/payment/customer חייב מפתח ייחודי
3. DLQ:
   - אחרי 3 כשלונות -> DLQ + alert + manual action

---

## 12. Monitoring & Alerts
- Integration success rate by connector
- Avg latency per endpoint
- 4xx / 5xx counters
- queue backlog size
- failed jobs > threshold alert

---

## 13. Acceptance Criteria (Integration)
1. כל connector מריץ health check תקופתי
2. כל פעולה עסקית קריטית ניתנת למעקב ב-Audit + correlationId
3. כשלונות transient מטופלים אוטומטית עד 3 ניסיונות
4. אין כפילות רשומות ביצירה חוזרת (idempotent)
5. ניתן להפיק Failure Report יומי לכל אינטגרציה

---

## 14. Open Decisions Before Implementation
1. Lead SoT final decision: Zoho vs Pickspace
2. SAP phase-1 data contract approval
3. Thresholds לאישור פעולות כספיות חריגות
4. Schedule windows לסנכרונים כבדים (nightly vs near-real-time)
