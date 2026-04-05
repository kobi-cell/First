# WORKIES AIO — PRD Development-Ready (Aligned to Mockup v2)

## 1) מטרת המסמך
מסמך PRD זה מגדיר דרישות מוצר ברמת פיתוח עבור מערכת Workies AIO, בהתאמה ישירה למוקאפ שהועלה (`workies_mockup_vector.pdf`), כך שמפתח יכול להתחיל פיתוח ללא שאלות פתוחות מהותיות.

---

## 2) מקורות קלט מחייבים
1. מוקאפ וקטורי: `workies_mockup_vector.pdf`  
2. אפיון קיים (Workbench Spec)
3. REST APIs:
   - Pickspace: `https://workies.pickspace.com/api-v2/swagger#/`
   - Sumit: `https://app.sumit.co.il/help/developers/swagger/index.html`
   - Zoho CRM v8: `https://www.zoho.com/crm/developer/docs/api/v8/get-records.html`

---

## 3) Vision + Scope
Workies AIO היא מערכת עבודה אחודה לניהול תפעול עסקי יומיומי על פני תחומים:
- Workbench (מסך ראשי)
- Alerts (התראות)
- Sales Pipeline
- Contracts & Renewals
- Collections
- KPI Report
- Aging Report
- Weekly Report
- Monthly P&L

### In Scope (Release 1)
- 9 מסכים לפי המוקאפ
- ניווט צד מלא עם badge counts
- מנגנון אישורים לפעולות חריגות
- אינטגרציות REST עם Pickspace + Zoho + Sumit
- SAP כ-adapter phase (export/status)

### Out of Scope (Release 1)
- Mobile native
- Workflow builder ויזואלי
- מנוע AI מתקדם

---

## 4) Roles (לשימוש במסמך)
1. הנהלה (CEO)
2. מכירות
3. שיווק
4. כספים/גבייה
5. תפעול
6. Admin

---

## 5) מסכים נדרשים (Screen Catalog)
| Screen ID | שם מסך | מקור במוקאפ |
|---|---|---|
| SCR-01 | Workbench | עמוד 1 |
| SCR-02 | Alerts | עמוד 2 |
| SCR-03 | Collections | עמוד 3 |
| SCR-04 | Pipeline | עמוד 4 |
| SCR-05 | Contracts & Renewals | עמוד 5 |
| SCR-06 | KPI Report | עמוד 6 |
| SCR-07 | Aging Report | עמוד 7 |
| SCR-08 | Weekly Report | עמוד 8 |
| SCR-09 | Monthly P&L Report | עמוד 9 |

---

## 6) דרישות פונקציונליות מפורטות לפי מסך

## SCR-01 Workbench
### User Stories
- כ-מנכ"ל אני רוצה לראות KPI cards ופעולות דחופות כדי לתעדף עבודה.
- כ-מנהל תחום אני רוצה לראות "משימות באיחור/דחוף/רגיל" כדי לסגור פערים בזמן.

### Business Logic
1. Workbench מציג summary cards:
   - רווח תפעולי
   - שיעור גבייה
   - תפוסה
   - חריגות פתוחות
2. בלוק "פעולות דחופות" מסווג ל:
   - באיחור (אדום)
   - דחוף (צהוב)
   - רגיל (כחול)
3. לכל שורה מוצגת פעולה מהירה (CTA):
   - "אשר", "שלח תזכורת", "עדכן", "פתוח"

### Acceptance Criteria
- מוצגים לפחות 4 KPI cards + 3 רמות דחיפות משימות.
- כל פעולה מהירה מפנה למסך היעד הרלוונטי.
- שינוי סטטוס משימה מעדכן את badge הניווט תוך <=10 שניות.

### Edge Cases
- KPI חסר ממערכת חיצונית -> הצגת "לא זמין" + warning icon.
- משימה ללא assignee -> עולה לראש הרשימה בדחיפות.

---

## SCR-02 Alerts
### User Stories
- כ-מנכ"ל אני רוצה פיד התראות אחוד עם חומרה כדי להגיב מהר.
- כ-מנהל כספים אני רוצה לבצע פעולה ישירה מהתראה (למשל תזכורת חוב).

### Business Logic
1. כל התראה כוללת:
   - severity (red/yellow/blue)
   - title + context
   - מקור (מודול)
   - timestamp
   - CTA
2. רשימת סינון:
   - כל ההתראות
   - דחוף בלבד
3. כפתור "סמן הכל כנקרא"

### Acceptance Criteria
- כל התראה כוללת CTA לחיצה למסך יעד.
- ניתן לסמן התראה כנקראה מבלי לעזוב מסך.
- פילטר "דחוף בלבד" מציג רק red severity.

### Edge Cases
- התראה כפולה (אותו correlation key) -> merge במקום כפילות.
- פעולה מתוך התראה נכשלת -> retry + toast error.

---

## SCR-03 Collections (גבייה)
### User Stories
- כ-איש גבייה אני רוצה רשימת חשבוניות פתוחות עם יתרה כדי לבצע גבייה.
- כ-מנהל כספים אני רוצה Aging summary + פעולות הסלמה.

### Business Logic
1. הצגת counters:
   - חשבוניות פתוחות
   - לקוחות פעילים
   - יתרה לגבייה
2. טבלת חשבוניות:
   - invoice #, לקוח, משרד, לתשלום, שולם, יתרה, מועד, סטטוס
3. CTA לשורה:
   - תזכורת
   - עדכן תשלום
4. בלוק פעולות גבייה נדרשות:
   - הסלמה 60+ ימים
   - דחופים

### Acceptance Criteria
- ניתן לסנן לפי סטטוס: פתוח/חלקי/שולם.
- עדכון תשלום משנה סטטוס invoice בזמן אמת.
- חשבוניות overdue מסומנות ויזואלית.

### Edge Cases
- תשלום חלקי > יתרה -> חסימה + הודעת שגיאה.
- כפילות invoice number -> חסימה בשמירה + audit event.

---

## SCR-04 Pipeline
### User Stories
- כ-איש מכירות אני רוצה Kanban לפי שלבים כדי לנהל לידים.
- כ-מנהל מכירות אני רוצה לראות ARR פוטנציאלי ומדדי המרה.

### Business Logic
1. שלבים: פנייה -> הצעה נשלחה -> מו"מ -> סגירה
2. כל כרטיס מציג:
   - שם ליד/חברה
   - תאריך עדכון
   - MRR/ARR
3. Drag & Drop בין שלבים
4. CTA:
   - שלח הצעת מחיר
   - עדכן הסכם חתום
   - ליד חדש

### Acceptance Criteria
- מעבר שלב מתועד ב-Audit כולל old/new stage.
- שינוי שלב מעדכן חישוב conversion rate.
- ניתן להמיר ליד סגור ללקוח.

### Edge Cases
- הזזת ליד לשלב סגירה ללא סכום -> חסימה.
- התנגשות עריכה מקבילה -> optimistic locking.

---

## SCR-05 Contracts & Renewals
### User Stories
- כ-מנהל תפעול/מכירות אני רוצה לראות חוזים מתקרבים לסיום כדי למנוע churn.

### Business Logic
1. טבלה מציגה:
   - contract #, לקוח, משרד, סכום חודשי, תאריך התחלה/סיום, סטטוס
2. סטטוסים:
   - דחוף לחידוש
   - הצעה נשלחה
   - חתום
   - פעיל
3. CTA:
   - עדכן חידוש
   - עדכן מו"מ
   - עדכן מערכת
   - עזיבה

### Acceptance Criteria
- חוזים עם פחות מ-30 יום לסיום מסומנים warning.
- חוזים עם פחות מ-14 יום מסומנים critical.
- שינוי סטטוס חוזה מייצר Alert אוטומטי.

### Edge Cases
- חוזה שנגמר ללא סטטוס חידוש -> escalation.
- לקוח עם מספר חוזים פעילים -> הצגה מאוחדת + פילטר.

---

## SCR-06 KPI Report
### User Stories
- כ-מנכ"ל אני רוצה דוח KPI חודשי מול יעד כדי למדוד ביצועים.

### Business Logic
1. KPI table:
   - KPI name
   - target
   - actual
   - status (met/near/missed)
2. KPIs לדוגמה מהמוקאפ:
   - רווח תפעולי
   - שיעור גבייה
   - תפוסה
   - Conversion
   - Churn
   - CPL
3. Export PDF + send to manager

### Acceptance Criteria
- כל KPI מוצג עם חיווי סטטוס.
- ניתן לייצא את הדוח ל-PDF.
- יש drill-down לנתון מקור.

### Edge Cases
- KPI ללא target -> מסומן "לא הוגדר יעד".
- נתון partial -> מסומן with warning.

---

## SCR-07 Aging Report
### User Stories
- כ-כספים אני רוצה פילוח חוב 0-30/31-60/61-90/90+ כדי לנהל גבייה מדורגת.

### Business Logic
1. summary cards לפי buckets
2. טבלת חוב לפי לקוח + buckets + total
3. CTA לתזכורת דחופה

### Acceptance Criteria
- סכום כולל ב-buckets תואם לסך החוב.
- ניתן להפיק רשימת לקוחות 90+ ל-escalation.

### Edge Cases
- לקוח עם credit note פתוח -> נטו חוב מחושב נכון.

---

## SCR-08 Weekly Report
### User Stories
- כ-מנכ"ל אני רוצה דוח שבועי אוטומטי עם מגמות כדי לעקוב שוטף.

### Business Logic
1. טבלת השוואה:
   - השבוע vs שבוע קודם vs שינוי
2. נקודות טיפול לשבוע הקרוב
3. שליחה אוטומטית בימי ראשון בבוקר

### Acceptance Criteria
- הדוח נוצר אוטומטית לפי cron.
- ניתן "שלח מחדש" ו"הורד PDF".

### Edge Cases
- cron נכשל -> התראת מערכת + אפשרות trigger ידני.

---

## SCR-09 Monthly P&L
### User Stories
- כ-הנהלה אני רוצה דוח הכנסות/הוצאות/רווחיות חודשי כדי לנהל ביצועים פיננסיים.

### Business Logic
1. הכנסות לפי קטגוריה (% מסה"כ)
2. השוואת הכנסות מול הוצאות
3. KPI summary:
   - הכנסות
   - הוצאות
   - רווח גולמי
   - מרווח רווחיות

### Acceptance Criteria
- ניתן לבחור חודש בדוח.
- הסכומים עקביים עם נתוני פיננסים.
- export PDF זמין.

### Edge Cases
- קטגוריה ללא שיוך -> נכנסת ל-"Other" ומסומנת לבדיקה.

---

## 7) User Stories Cross-Screen (Core)
1. כ-משתמש מורשה אני רוצה ניווט צד אחיד עם badges כדי לדעת עומסים.
2. כ-מנהל אני רוצה actions מהירות מכל מסך כדי לקצר זמן טיפול.
3. כ-מערכת אני רוצה Audit לכל שינוי סטטוס/סכום כדי לשמור עקיבות.
4. כ-מנהל כספים אני רוצה אישור לפעולות חריגות כדי לצמצם סיכון.

---

## 8) Business Rules גלובליים
1. פעולה כספית חריגה לא מתבצעת ללא אישור.
2. כל שינוי בסטטוס קריטי מייצר Alert.
3. Sync חיצוני לעולם לא דורס נתון פנימי מאושר בלי Conflict flow.
4. Badges מחושבים מנתוני אמת ולא cache בלבד.

---

## 9) Acceptance Criteria גלובליים
1. 9 מסכים מהמוקאפ ממומשים.
2. RBAC ממומש לפי תפקיד.
3. Export PDF לפחות ל-KPI/Weekly/P&L.
4. אינטגרציות REST פעילות לנתוני ליבה.
5. Audit + Alerting עובדים מקצה לקצה.

---

## 10) NFR
1. זמינות: 99.5%
2. זמן טעינת מסך: עד 3 שניות ל-dashboard
3. Retry policy אינטגרציות: 3 נסיונות
4. TLS בכל תקשורת
5. לוגים ללא סודות/PII מלא

---

## 11) Open Decisions לפני Dev Freeze
1. Lead SoT final: Zoho vs Pickspace
2. ספי Medium/High כספיים מדויקים
3. SAP Phase-1 contract schema
4. SLA לכל סוג Alert

---

## 12) Definition of Done (לכל Story)
- פיתוח + unit tests
- בדיקות אינטגרציה בסיסיות
- RBAC pass
- Audit events pass
- Acceptance criteria pass
- תיעוד API מעודכן
