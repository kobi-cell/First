# WORKIES AIO — Integration Specification (Aligned to Mockup v2)

## 1) מטרה
להגדיר מפרט אינטגרציות ברמת פיתוח למסכי המוקאפ:
- Workbench
- Alerts
- Pipeline
- Contracts & Renewals
- Collections
- KPI Report
- Aging Report
- Weekly Report
- Monthly P&L

אינטגרציות:
- Pickspace REST API
- Zoho CRM API v8
- Sumit API
- SAP Adapter (Phase 1)

---

## 2) ארכיטקטורת אינטגרציה מוצעת
1. כל חיבור חיצוני ניגש דרך `Integration Service` פנימי (Backend בלבד)
2. אין קריאות ישירות מה-frontend למערכות חיצוניות
3. כל סנכרון נרשם ב-`integration_jobs` + `audit_events`
4. עדכון מסכים בזמן אמת מתבצע דרך:
   - poll מחזורי קצר למסכי תפעול
   - refresh יזום אחרי פעולות משתמש

---

## 3) Connector A — Pickspace
מקור: `https://workies.pickspace.com/api-v2/swagger#/`

### 3.1 מסך Pipeline
| מטרה | Endpoint | תדירות | הערות מימוש |
|---|---|---|---|
| שליפת Pipelines | `GET /api-v2/pipelines` | כל 6 שעות | cache |
| שליפת Pipeline Stages | `GET /api-v2/pipeline-stages/{pipelineId}` | כל 6 שעות | cache |
| שליפת לידים | `GET /api-v2/leads` | כל 5 דק' | מקור תפעולי למשפך |
| עדכון ליד | `PATCH /api-v2/leads/{id}` | בזמן אמת | שינוי שלב/סטטוס |
| המרת ליד ללקוח | `POST /api-v2/leads/convert-lead-to-member/{id}` | לפי פעולה | כפתור "המרה" |

### 3.2 מסך חוזים וחידושים
| מטרה | Endpoint | תדירות | הערות |
|---|---|---|---|
| שליפת חוזים | `GET /api-v2/contracts` | כל שעה | כולל תאריכי סיום |
| שליפת חוזה ספציפי | `GET /api-v2/contracts/{id}` | on-demand | חלון פרטים |
| אישור/דחיית חוזה | `PATCH /api-v2/contracts/{id}/approve` / `decline` | לפי פעולה | לשלב חידוש |
| עדכון חוזה | `PUT /api-v2/contracts/{id}` | לפי פעולה | לאחר אישור |

### 3.3 מסך גבייה + Aging + KPI
| מטרה | Endpoint | תדירות | הערות |
|---|---|---|---|
| שליפת חשבוניות | `GET /api-v2/invoices` | כל 15 דק' | בסיס רשימת גבייה |
| חשבוניות פתוחות חודשי | `GET /api-v2/invoices/getAllUnpaidInvoicesForCurrentMonth` | יומי | widget גבייה |
| דלינקוונסי | `GET /api-v2/invoices/delinquency` | יומי | Aging/KPI |
| Tenant ledger | `GET /api-v2/invoices/tenant-ledger` | יומי | דוחות |
| שליפת תשלומים | `GET /api-v2/payments` | כל 15 דק' | reconciliation |
| יצירת תשלום | `POST /api-v2/payments` | בזמן אמת | "עדכן תשלום" |

### 3.4 מסך תפעול/תפוסה
| מטרה | Endpoint | תדירות | הערות |
|---|---|---|---|
| שליפת משרדים | `GET /api-v2/offices` | כל שעה | תפוסה |
| זמינות משרדים | `GET /api-v2/offices/location/{id}/available` | כל שעה | KPI תפוסה |
| דו"ח תפוסה/turnover | `GET /api-v2/offices-history/occupied-offices` | יומי | KPI |
| analytics occupancy | `GET /api-v2/analytics/occupancy/general` | יומי | widget תפוסה |

---

## 4) Connector B — Zoho CRM (v8)
מקורות:
- `https://www.zoho.com/crm/developer/docs/api/v8/modules-api.html`
- `https://www.zoho.com/crm/developer/docs/api/v8/get-records.html`

### 4.1 שימושים במסכים
| מסך | שימוש | Endpoint |
|---|---|---|
| Pipeline | מקור/העשרת לידים | `GET /crm/v8/Leads` |
| Pipeline | פרטי הזדמנויות | `GET /crm/v8/Deals` |
| Workbench | KPI משפך | `GET /crm/v8/Leads`, `Deals` |
| חוזים וחידושים | תיאום הזדמנויות חידוש | `GET /crm/v8/Deals` (תלויות) |

### 4.2 כללים
1. יש להגדיר `fields` מפורש בכל קריאת records
2. pagination:
   - עד 200 לרשימה
   - page_token מעל 2000
3. token refresh בצד backend בלבד

---

## 5) Connector C — Sumit
מקורות:
- `https://app.sumit.co.il/help/developers/swagger/index.html`
- `https://app.sumit.co.il/swagger/v1/swagger.json`

### 5.1 לקוחות
| מטרה | Endpoint | תדירות | הערות |
|---|---|---|---|
| יצירה/איתור לקוח | `POST /accounting/customers/create/` | בזמן אמת | SearchMode |
| עדכון לקוח | `POST /accounting/customers/update/` | לפי שינוי | sync פרטים |

### 5.2 מסמכים (חשבוניות/קבלות)
| מטרה | Endpoint | תדירות | הערות |
|---|---|---|---|
| יצירת מסמך | `POST /accounting/documents/create/` | בזמן אמת | לפי פעולה בגבייה |
| שליחת מסמך | `POST /accounting/documents/send/` | בזמן אמת | "שלח חשבונית" |
| פרטי מסמך | `POST /accounting/documents/getdetails/` | on-demand | חלון פרטים |
| רשימת מסמכים | `POST /accounting/documents/list/` | כל 30 דק' | reconciliation |
| ביטול מסמך | `POST /accounting/documents/cancel/` | לפי אישור | High Risk flow |
| חוב לקוח | `POST /accounting/documents/getdebt/` | יומי | Aging |
| דוח חובות | `POST /accounting/documents/getdebtreport/` | יומי | KPI/דוחות |

### 5.3 תשלומים וחיובים
| מטרה | Endpoint | תדירות | הערות |
|---|---|---|---|
| חיוב תשלום | `POST /billing/payments/charge/` | בזמן אמת | עדכון תשלום |
| פרטי תשלום | `POST /billing/payments/get/` | on-demand | reconciliation |
| רשימת תשלומים | `POST /billing/payments/list/` | כל 30 דק' | גבייה |
| אמצעי תשלום ללקוח | `POST /billing/paymentmethods/getforcustomer/` | לפי צורך | גבייה |
| חיובים מחזוריים | `POST /billing/recurring/listforcustomer/` | יומי | לקוחות קבועים |

---

## 6) Connector D — SAP (Phase 1)
בשלב ראשון: Adapter בלבד (לא קריאה ישירה מה-UI)

| מטרה | כיוון | פורמט | תדירות |
|---|---|---|---|
| יצוא חשבוניות מאושרות | Workies -> SAP Adapter | JSON/CSV | יומי |
| יצוא תשלומים | Workies -> SAP Adapter | JSON/CSV | יומי |
| קבלת סטטוס קליטה | SAP Adapter -> Workies | JSON callback/file | יומי |

---

## 6.1) Digital Signature Provider (DocuSign) — עבור POP-04
רכיב זה נדרש למסך הקופץ "שליחת הצעת מחיר לחתימה דיגיטלית".

| מטרה | כיוון | תדירות |
|---|---|---|
| יצירת בקשת חתימה | Workies -> Signature Provider | בזמן אמת |
| קבלת סטטוס חתימה (sent/viewed/signed/declined) | Signature Provider -> Workies (webhook/poll) | near real-time |

כלל מימוש: מצב חתימה מעדכן Pipeline + Alert feed + Audit.

---

## 7) Screen-to-Integration Mapping (חד-חד ערכי)
| מסך מוקאפ | Pickspace | Zoho | Sumit | SAP |
|---|---|---|---|---|
| Workbench | כן | כן | כן | לא ישיר |
| Alerts | כן (events) | כן (events) | כן (events) | כן (קליטה נכשלה) |
| Pipeline | כן | כן | לא | לא |
| חוזים וחידושים | כן | כן (Deals renewals) | לא | לא |
| גבייה | כן | לא | כן | לא ישיר |
| KPI | כן | כן | כן | כן |
| Aging | כן | לא | כן | לא |
| דוח שבועי | כן | כן | כן | לא |
| P&L חודשי | כן | לא | כן | כן |

---

## 7.1) Popup-to-Integration Mapping (8 Popups)
| Popup | פעולה | אינטגרציות עיקריות |
|---|---|---|
| POP-01 שליחת תזכורת תשלום | שליחה ללקוח (SMS/Email) | Workies Notification Service (פנימי), Log ל-Audit |
| POP-02 חשבונית חדשה | הפקת חשבונית | Sumit `documents/create`, Pickspace invoices sync |
| POP-03 עדכון הסדר תשלום | יצירת/עדכון תוכנית תשלומים | Workies DB (PaymentPlan), Sumit recurring list/check לפי צורך |
| POP-04 שליחת הצעת מחיר לחתימה | שליחת מסמך לחתימה דיגיטלית | ספק חתימה דיגיטלית (DocuSign), עדכון Lead/Deal ב-Zoho/Pickspace |
| POP-05 עדכון מצב חידוש חוזה | שמירת סטטוס מו\"מ ושליחת הצעה | Pickspace contracts update, Zoho deals update (אם SoT ב-Zoho) |
| POP-06 עדכון הסכם שנחתם | update + אוטומציות נלוות | Pickspace contract status, Sumit first invoice, Office occupancy update, onboarding task create |
| POP-07 עדכון סיום הסכם/עזיבה | סגירת חוזה ושחרור משרד | Pickspace contract end + office release, Sumit stop future billing, create collection task |
| POP-08 אישור P&L חודשי | אישור ונעילת דוח | Workies approval/audit, SAP export eligibility update |

---

## 7.2) Orchestration Requirements for Critical Popups
Critical popups: POP-06, POP-07, POP-08

1. כל פעולה תרוץ עם correlation ID אחיד לכל תתי-השלבים.
2. יש ליישם Saga/compensation כאשר חלק מהשלבים נכשל:
   - POP-06: אם הפקת חשבונית נכשלה אחרי עדכון חוזה -> סימון partial + משימת טיפול.
   - POP-07: אם עצירת חיובים נכשלה -> אין סימון offboarding כ-completed.
   - POP-08: אם approval נשמר אך export ל-SAP נכשל -> דוח נשאר Approved עם sync_status=failed.
3. חובה להציג למשתמש סטטוס תהליך (success/partial/failed) בסיום popup action.

---

## 8) Error Handling Policy
### קטגוריות
1. Auth (401/403)
2. Validation (400/422)
3. Transient (5xx/timeout/network)
4. Business errors (לדוגמה document already cancelled)

### כללים
1. Transient -> Retry 3 פעמים (30s, 2m, 10m)
2. לאחר כישלון -> DLQ + Alert
3. Business error -> אין retry אוטומטי; נדרש טיפול ידני
4. כל כשל נרשם ב-`integration_jobs.last_error`

---

## 9) Idempotency Rules
יש ליישם idempotency key לפחות עבור:
- יצירת לקוח
- יצירת מסמך/חשבונית
- רישום תשלום
- המרת ליד ללקוח

key מומלץ:
`{connector}:{operation}:{external_or_business_key}:{date_bucket}`

---

## 10) Observability & Monitoring
מדדים חובה:
1. Success rate לכל Connector
2. P95 latency לכל endpoint קריטי
3. Queue backlog
4. Failed jobs/day
5. זמן התאוששות מתקלת אינטגרציה

Dashboards:
- Integration health
- Finance sync health
- Lead sync health

---

## 11) Acceptance Criteria
1. כל מסך מוקאפ מקבל נתונים מלפחות מקור API אחד פעיל
2. כל פעולה כותבת (create/update/cancel/approve) מתועדת ב-Audit
3. כשל אינטגרציה מופיע במסך Alerts תוך <= 2 דקות
4. אין כפילויות רשומות בביצוע חוזר של אותה בקשה
5. קיימת יכולת rerun ידני ל-job שנכשל
6. כל POP-01..POP-08 ממופה לאינטגרציה/אורקסטרציה עם תרחיש כשל מוגדר

---

## 12) החלטות פתוחות לפני Dev Freeze
1. Source of Truth סופי ל-Leads: Zoho או Pickspace
2. ספי אישור כספיים (High/Medium) במספרים מדויקים
3. אילו דוחות KPI יחושבו ב-Workies ואילו ייקראו ישירות ממקור
4. תזמון יומי מדויק לייצוא SAP
