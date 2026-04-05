# WORKIES AIO — Backlog & Sprint Plan (S0-S7)

## 1. עקרונות תכנון ספרינטים
- משך ספרינט: 2 שבועות
- גודל צוות הנחה: 1 Lead Dev + 2 Fullstack + 1 QA + 1 PM (חלקי)
- הערכות ראשוניות ביחידות Story Points (SP)
- טווח המרה גס: 1 SP ~ 0.5-1 יום פיתוח (תלוי מורכבות)

---

## 2. יעדי מאקרו לפי שלבים
- S0: Foundations / Environments / Architecture skeleton
- S1-S2: Core app + Dashboard + Auth + RBAC
- S3-S4: Sales Pipeline + Leads + partial integrations
- S5-S6: Finance/Collections + Approvals + Monthly report
- S7: Stabilization / Hardening / Go-live readiness

---

## 3. Sprint S0 — Setup & Foundation
## מטרות
- להעמיד סביבת פיתוח וסטנדרטים
- להגדיר חוזי API פנימיים
- להקים שלד מערכת

## Stories
| ID | Story | SP | תלות | Output |
|---|---|---:|---|---|
| US-001 | Repo structure + mono setup | 5 | - | בסיס פרויקט |
| US-002 | Auth skeleton + JWT | 5 | - | התחברות בסיסית |
| US-003 | Role model + RBAC middleware | 8 | US-002 | שכבת הרשאות |
| US-004 | Audit logging foundation | 5 | US-001 | טבלת audit + logger |
| US-005 | Error handling framework + retry utility | 5 | US-001 | מודול תקלות |
| US-006 | CI/CD + environments (dev/stage) | 8 | US-001 | pipeline פעיל |

סה"כ S0: **36 SP**

---

## 4. Sprint S1 — Dashboard & Core UI
## מטרות
- לייצר מעטפת אפליקציה פעילה
- מסך ראשי עם KPI placeholders

## Stories
| ID | Story | SP | תלות | Output |
|---|---|---:|---|---|
| US-007 | App shell + navigation | 5 | S0 | Layout מלא |
| US-008 | Dashboard KPI cards (mock data) | 8 | US-007 | Dashboard v1 |
| US-009 | Alerts feed component | 5 | US-007 | Alerts UI |
| US-010 | Global filters (date/department/site) | 5 | US-008 | פילטרים גלובליים |
| US-011 | Role-based view guards | 8 | S0 RBAC | הסתרת מסכים לפי role |
| US-012 | Dashboard API contracts | 5 | US-008 | schema ו-contracts |

סה"כ S1: **36 SP**

---

## 5. Sprint S2 — Data Backbone & Read APIs
## מטרות
- יישום Data model ראשוני
- חיבור נתונים לקריאה ממקורות

## Stories
| ID | Story | SP | תלות | Output |
|---|---|---:|---|---|
| US-013 | Core entities tables + migrations | 8 | S0 | DB בסיסי |
| US-014 | Customer/Office/Contract read APIs | 8 | US-013 | read endpoints |
| US-015 | Lead/Task read APIs | 5 | US-013 | read endpoints |
| US-016 | Invoice/Payment read APIs | 8 | US-013 | read endpoints |
| US-017 | Unified search endpoint | 5 | US-014-16 | חיפוש גלובלי |
| US-018 | Data validation + schema guards | 5 | US-013 | ולידציות |

סה"כ S2: **39 SP**

---

## 6. Sprint S3 — Sales Pipeline MVP
## מטרות
- משפך לידים פעיל
- CRUD לידים + מעבר שלבים

## Stories
| ID | Story | SP | תלות | Output |
|---|---|---:|---|---|
| US-019 | Pipeline board UI | 8 | S1 | Kanban פעיל |
| US-020 | Lead create/update/delete | 8 | S2 | CRUD מלא |
| US-021 | Lead stage transition flow | 8 | US-019/020 | מעבר שלבים |
| US-022 | Duplicate detection (email/phone) | 5 | US-020 | מניעת כפילויות |
| US-023 | Convert lead to customer | 8 | US-020 | המרה ללקוח |
| US-024 | Sales activity audit events | 3 | S0 audit | אירועי Audit |

סה"כ S3: **40 SP**

---

## 7. Sprint S4 — CRM Integrations (Pickspace + Zoho)
## מטרות
- סנכרון נתוני לידים/לקוחות
- ניטור תקלות אינטגרציה

## Stories
| ID | Story | SP | תלות | Output |
|---|---|---:|---|---|
| US-025 | Pickspace leads sync job | 8 | S3 | job פעיל |
| US-026 | Pickspace members/offices sync | 8 | S2 | job פעיל |
| US-027 | Zoho Leads pull + mapping | 8 | S3 | job פעיל |
| US-028 | Zoho Accounts/Contacts sync | 8 | S2 | job פעיל |
| US-029 | Reconciliation screen for sync conflicts | 8 | US-025-028 | מסך פערים |
| US-030 | Integration failure queue + retry UI | 8 | S0 error framework | מרכז תקלות |

סה"כ S4: **48 SP**

---

## 8. Sprint S5 — Finance & Collections MVP
## מטרות
- מודול גבייה חי
- חשבוניות/תשלומים/Aging

## Stories
| ID | Story | SP | תלות | Output |
|---|---|---:|---|---|
| US-031 | Invoice list + filters + status | 8 | S2 | מסך חשבוניות |
| US-032 | Payment list + allocation display | 8 | S2 | מסך תשלומים |
| US-033 | Aging 30/60/90 widget + table | 8 | US-031 | Aging פעיל |
| US-034 | Debt and delinquency dashboard | 5 | US-031/033 | דשבורד חובות |
| US-035 | Sumit customer sync integration | 8 | S2 | sync לקוחות |
| US-036 | Sumit documents list/create/get integration | 13 | US-031 | אינטגרציית מסמכים |
| US-037 | Sumit payments list/get integration | 8 | US-032 | אינטגרציית תשלום |

סה"כ S5: **58 SP**

---

## 9. Sprint S6 — Approvals, Monthly Report, SAP Adapter
## מטרות
- הטמעת approval flow רוחבי
- הפקת דוח חודשי
- שכבת SAP handoff

## Stories
| ID | Story | SP | תלות | Output |
|---|---|---:|---|---|
| US-038 | Approval center (queue + actions) | 13 | S1/S5 | מרכז אישורים |
| US-039 | Risk rules engine (Low/Medium/High) | 8 | US-038 | engine בסיסי |
| US-040 | Financial exception flow (credit/cancel/edit) | 13 | US-038/S5 | flow פעיל |
| US-041 | Monthly report generator | 8 | S5 | דוח חודשי |
| US-042 | Export PDF/CSV | 5 | US-041 | ייצוא |
| US-043 | SAP adapter v1 (export feed + status) | 8 | S5 data | handoff ל-SAP |
| US-044 | Approval + Audit linkage hardening | 5 | US-038 | traceability מלאה |

סה"כ S6: **60 SP**

---

## 10. Sprint S7 — Stabilization & Go-Live Readiness
## מטרות
- ייצוב ביצועים ואמינות
- QA/UAT מלא
- מוכנות השקה

## Stories
| ID | Story | SP | תלות | Output |
|---|---|---:|---|---|
| US-045 | End-to-end test suite critical flows | 13 | all | בדיקות E2E |
| US-046 | NFR hardening (timeouts/retries/alerts) | 8 | all | אמינות משופרת |
| US-047 | Security hardening + permission audit | 8 | S1 RBAC | סקר הרשאות |
| US-048 | Data migration scripts + validation | 8 | S2 data | מוכנות נתונים |
| US-049 | UAT fixes batch | 13 | UAT | תיקוני משתמשים |
| US-050 | Go-live checklist + runbook | 5 | all | Runbook מלא |

סה"כ S7: **55 SP**

---

## 11. סיכום עומסים
| Sprint | SP |
|---|---:|
| S0 | 36 |
| S1 | 36 |
| S2 | 39 |
| S3 | 40 |
| S4 | 48 |
| S5 | 58 |
| S6 | 60 |
| S7 | 55 |
| **Total** | **372 SP** |

---

## 12. Milestones
1. End S2: Platform + data backbone מוכנים
2. End S4: Sales flow + CRM sync פעילים
3. End S6: Finance + Approvals + Reports פעילים
4. End S7: Go-live readiness

---

## 13. ניהול סיכונים בתכנון הספרינטים
- סיכון: תלות באותנטיקציה/API צד שלישי  
  מיתון: מימוש mock connectors ב-S0
- סיכון: אי בהירות Source of Truth  
  מיתון: החלטה ניהולית נעולה לפני S2
- סיכון: עומס אינטגרציות בספרינט אחד  
  מיתון: פיצול Pickspace/Zoho/Sumit לפי S4/S5
