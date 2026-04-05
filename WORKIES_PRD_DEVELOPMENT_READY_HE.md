# WORKIES AIO — PRD Development-Ready v3 (Merged)

## 1) מטרת המסמך
מסמך זה הוא גרסת מיזוג PRD v3 המאחדת:
1. את מסמך ה-PRD שהוכן על ידי Claude (`prd_workies.pdf`)
2. את מסמך ה-PRD הקיים בריפו (מותאם Mockup v2 + 8 Popups)

המטרה: לאפשר תחילת פיתוח עם מפרט אחד מאושר, כולל סימון החלטות שדורשות אישור ניהולי לפני Dev Freeze.

---

## 2) מקורות קלט מחייבים
1. `workies_mockup_vector.pdf`
2. `workies_mockup_full.pdf`
3. `prd_workies.pdf`
4. Workbench Spec קיים
5. REST APIs:
   - Pickspace: `https://workies.pickspace.com/api-v2/swagger#/`
   - Sumit: `https://app.sumit.co.il/help/developers/swagger/index.html`
   - Zoho CRM v8: `https://www.zoho.com/crm/developer/docs/api/v8/get-records.html`

---

## 3) תיאור מערכת וגבולות אחריות
Workies AIO היא פלטפורמת עבודה אחודה. המשתמש עובד רק ב-AIO, ומערכות חיצוניות פועלות כמנועי רקע.

| מערכת | סטטוס במודל היעד | תפקיד ב-AIO |
|---|---|---|
| Pickspace | ממשיכה לפעול | מקור תפעולי מרכזי ללקוחות/חוזים/משרדים/חלק מפיננסים |
| Zoho CRM | ממשיכה לפעול | מקור/סנכרון לידים ועסקאות לפי החלטת SoT |
| Sumit (+UPAY) | ממשיכה לפעול | מקור חשבונאי למסמכים/תשלומים + Webhooks |
| SAP | ממשיכה לפעול | Phase 1: Adapter/Export + סטטוס קליטה |
| Monday | מוחלף | מודול משימות פנימי ב-AIO |
| Google Sheets | מוחלף בהדרגה | דוחות/מעקבים בתוך AIO |

---

## 4) Roles + הרשאות עקרוניות
Roles:
1. הנהלה / Admin
2. כספים / גבייה
3. מכירות
4. שיווק
5. תפעול
6. Admin טכני

כללי גישה:
- Least Privilege לכל משתמש
- פעולות High Risk מחייבות 4-eyes (מנהל תחום + הנהלה)
- כל פעולה קריטית מתועדת ב-Audit

> פירוט מלא בטבלת RBAC: `WORKIES_RBAC_PERMISSION_MATRIX_HE.md`

---

## 5) קטלוג מסכים (Mockup v2)
| Screen ID | מסך |
|---|---|
| SCR-01 | Workbench |
| SCR-02 | Alerts |
| SCR-03 | Collections |
| SCR-04 | Pipeline |
| SCR-05 | Contracts & Renewals |
| SCR-06 | KPI Report |
| SCR-07 | Aging Report |
| SCR-08 | Weekly Report |
| SCR-09 | Monthly P&L |

## 5.1 קטלוג Popups (8)
| Popup ID | שם Popup | מסך אם | CTA ראשי |
|---|---|---|---|
| POP-01 | שליחת תזכורת תשלום | Collections | שלח תזכורת |
| POP-02 | חשבונית חדשה | Collections | הפק חשבונית |
| POP-03 | עדכון הסדר תשלום | Collections | שמור הסדר |
| POP-04 | שליחת הצעת מחיר לחתימה דיגיטלית | Pipeline | שלח להצעה וחתימה |
| POP-05 | עדכון מצב חידוש חוזה | Contracts & Renewals | שמור עדכון / שלח הצעה |
| POP-06 | עדכון הסכם שנחתם | Contracts & Renewals | עדכן ובצע פעולות נלוות |
| POP-07 | עדכון סיום הסכם/עזיבה | Contracts & Renewals | עדכן סיום הסכם |
| POP-08 | אישור דוח P&L חודשי | Monthly P&L | P&L אשר |

> פירוט מלא בטבלת Popups: `WORKIES_POPUP_TABLE_HE.md`

---

## 6) חוקי לוגיקה עסקית מחייבים (Merged Rules)

### BR-001 — ביטול מסמך חיוב
- ביטול מסמך חיוב מותר רק אם לא קיימת חשבונית SAP מקושרת.
- אם קיימת חשבונית SAP: חסימה מיידית + הודעה ברורה למשתמש.
- הפעולה מותרת רק לבעלי הרשאה מתאימה (כספים/הנהלה/Admin).

### BR-002 — כשל בעדכון תשלום
- במקרה כשל בעדכון תשלום (Pickspace/Sumit):
  1. הצגת שגיאה עם קוד תקלה
  2. פתיחת משימה אוטומטית לכספים בעדיפות גבוהה
  3. שליחת Alert פנימי
- אין Retry עיוור לפעולה פיננסית כותבת.

### BR-003 — חזרת תשלום (Chargeback/Return)
- אירוע `payment.returned` מ-Sumit גורם ל:
  1. עדכון חוב לסטטוס פתוח
  2. יצירת משימת טיפול לכספים
  3. SLA טיפול: 3 ימי עסקים
  4. Alert לכספים + הנהלה

### BR-004 — Aging והסלמות
- יום 30: תזכורת אוטומטית (Email)
- יום 60: הסלמה לכספים + הנהלה (Email/SMS/In-App)
- יום 90+: פתיחת משימה להסלמה משפטית + התראות

### BR-005 — חתימת חוזה (Signed Contract)
בעת סימון "נחתם" (POP-06), יש להפעיל רצף נלווה:
1. Pipeline -> Closed Won
2. פתיחת/עדכון לקוח
3. יצירת חיוב ראשוני
4. יצירת Onboarding 30/60/90
5. עדכון תפוסת משרד
6. מייל ברוכים הבאים

### BR-006 — סיום הסכם / עזיבה
בעת POP-07:
1. בדיקת חוב פתוח כתנאי סף
2. עדכון חוזה ל-"מסתיים"
3. שחרור משרד
4. עצירת חיובים עתידיים
5. יצירת משימת גבייה
6. יצירת משימת שיווק לאכלוס מחדש

### BR-007 — אישור P&L חודשי
- אישור P&L (POP-08) מחייב הרשאת אישור הנהלה.
- לאחר אישור: נעילת הדוח לעריכה רגילה + Audit חתום.

### BR-008 — קונפליקט סנכרון
- Sync חיצוני לא דורס נתון פנימי מאושר ללא Conflict Flow.

### BR-009 — Traceability
- לכל פעולה קריטית: `correlation_id` אחיד ב-Audit וב-Integration Jobs.

### BR-010 — מדיניות Retry (הכרעת מיזוג)
- קריאות קריאה/סנכרון (read/pull/transient): עד 3 נסיונות Exponential Backoff.
- פעולות פיננסיות כותבות (cancel/charge/update payment): ללא retry אוטומטי עיוור; נדרש מסלול טיפול מבוקר.

---

## 7) דרישות פונקציונליות (User Stories מרכזיים)

### הנהלה
- US-MGT-001: דשבורד KPI מאוחד עם drill-down
- US-MGT-002: דוח שבועי אוטומטי ראשון 08:00 + PDF/Email
- US-MGT-003: אישור P&L חודשי ונעילת דוח

### כספים/גבייה
- US-FIN-001: Aging Report עם 4 buckets ו-KPI עליון
- US-FIN-002: ביטול מסמך בכפוף לבדיקת SAP
- US-FIN-003: תזכורות תשלום ידניות/אוטומטיות לפי גיל חוב
- US-FIN-004: מסך Collections מלא + popups POP-01/02/03

### מכירות
- US-SAL-001: Pipeline Kanban + drag/drop
- US-SAL-002: שליחת הצעה לחתימה דיגיטלית (POP-04)
- US-SAL-003: עדכון הסכם חתום + פעולות נלוות (POP-06)
- US-SAL-004: עדכון סיום הסכם/עזיבה (POP-07)

### שיווק
- US-MKT-001: CPL לפי מקור ליד + מגמות
- US-MKT-002: Onboarding Tracker 30/60/90

### תפעול
- US-OPS-001: עדכון תפוסה ומפת שולחנות מתוך תהליכי חוזה
- US-OPS-002: משימות אוטומטיות מאירועי חידוש/עזיבה

> פירוט מסך-מסך ופופאפים מופיע בגרסאות המסמכים התומכים שכבר קיימים בריפו.

---

## 8) Acceptance Criteria גלובליים
1. 9 מסכים מהמוקאפ ממומשים.
2. 8 פופאפים (POP-01..POP-08) ממומשים.
3. RBAC נאכף ברמת מסך ופעולה.
4. כל פעולה קריטית נרשמת ב-Audit.
5. אינטגרציות Pickspace/Zoho/Sumit פעילות למסכי ליבה.
6. ל-P&L קיים מסלול אישור ונעילה.
7. תרחישי כשל קריטיים (payment failure/chargeback/offboarding block) מכוסים E2E.

---

## 9) NFR
1. Availability: 99.5% חודשי
2. טעינת מסך Workbench: עד 3 שניות (P95)
3. אבטחה: JWT + RBAC + TLS + Secret Manager
4. תצפיות: Audit + Integration Monitoring + Alerts
5. Logs ללא חשיפת סודות/PII מלא

---

## 10) Sprint Plan (ממוזג)
| Sprint | מיקוד עיקרי |
|---|---|
| S0 | אישורי PRD, גיוס Lead Dev, Tech Stack, CI/CD |
| S1 | יסודות מערכת: Auth/RBAC/Audit/Core API |
| S2 | Workbench + KPI + Weekly + Alert Engine |
| S3 | Collections + Aging + חוקי SAP/Sumit פיננסיים |
| S4 | Pipeline + חוזים + חתימה דיגיטלית + פעולות נלוות |
| S5 | שיווק + CPL + Onboarding Tracker |
| S6 | אינטגרציה מלאה + QA + UAT |
| S7 | Go-Live + הדרכות + ניתוק מערכות מוחלפות |

הערה: תאריכי יעד מדויקים יאושרו אחרי סגירת סעיף החלטות ניהוליות.

---

## 11) מטריצת החלטות שדורשות אישור ניהולי (חובה לפני Dev Freeze)
| ID | החלטה | אופציות | המלצה מקצועית | Owner מאשר | תאריך יעד לאישור | סטטוס |
|---|---|---|---|---|---|---|
| DEC-001 | Lead Source of Truth | Zoho / Pickspace / Hybrid | Hybrid עם כלל הכרעה פר ישות | נדב + Lead Dev | 2026-03-20 | דורש אישור ניהולי |
| DEC-002 | מנגנון חתימה דיגיטלית | DocuSign / HelloSign / אחר | DocuSign (time-to-market) | קובי + נדב | 2026-03-20 | דורש אישור ניהולי |
| DEC-003 | SAP Phase-1 Scope | Export-only / API דו-כיווני | Export-only + status callback | דרור + נדב | 2026-03-22 | דורש אישור ניהולי |
| DEC-004 | ספי Medium/High לאישור כספי | לפי סכום / אחוז / משולב | משולב (סכום+אחוז) | דרור + נדב | 2026-03-20 | דורש אישור ניהולי |
| DEC-005 | מדיניות Retry לפעולות פיננסיות כותבות | retry אוטומטי / ללא retry / מבוקר | ללא retry עיוור; טיפול מבוקר | דרור + Lead Dev | 2026-03-18 | דורש אישור ניהולי |
| DEC-006 | מערכת שליחת מייל/תזכורות | דרך AIO / דרך Pickspace / דרך ספק חיצוני | שירות הודעות פנימי ב-AIO | Lead Dev + קובי | 2026-03-21 | דורש אישור ניהולי |
| DEC-007 | החלפת Google Sheets בשלב ראשון | מלאה מיידית / הדרגתית | הדרגתית עם read-only מעבר | קובי + נדב | 2026-03-24 | דורש אישור ניהולי |
| DEC-008 | תפקידי משתמש חסרים (Sales/Ops שמיים) | אישור רשימת משתמשים | לסגור לפני S1 | נדב | 2026-03-18 | דורש אישור ניהולי |

---

## 12) מסירת אחריות ואישור מסמך
חתימה על מסמך זה פותחת רשמית את Sprint S0.

| שם | תפקיד | חתימה | תאריך |
|---|---|---|---|
| קובי | בעל העסק | __________ | __________ |
| נדב בנג'ו | מנכ"ל | __________ | __________ |
| דרור | מנהל כספים | __________ | __________ |
| Lead Developer | מוביל פיתוח | __________ | __________ |

---

## 13) Definition of Done
- קוד + Unit Tests
- בדיקות אינטגרציה
- בדיקות RBAC
- Audit Events תקינים
- AC לכל Story עבר QA
- עדכון תיעוד API/Schema
- אין החלטות ניהוליות פתוחות שמסומנות "דורש אישור ניהולי"

