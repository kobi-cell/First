# WORKIES AIO — PRD Development-Ready

## 1. מטרת המסמך
מסמך זה מגדיר דרישות מוצר ברמת פיתוח (Developer-Ready) למערכת Workies AIO, כולל:
- User Stories
- לוגיקה עסקית
- Acceptance Criteria
- Edge Cases
- מסכי ליבה והזרימות המרכזיות

המסמך נועד לאפשר תחילת פיתוח ללא שאלות פתוחות קריטיות.

---

## 2. חזון מוצר
Workies AIO היא מערכת תפעול אחודה שמרכזת:
1. מכירות (Leads + Pipeline)
2. גבייה ופיננסים (חשבוניות, חיובים, תשלומים, חובות)
3. תפעול לקוחות/משרדים
4. דוחות הנהלה חודשיים
5. בקרות ואישורים (Human-in-the-Loop)

### בעיות שהמוצר פותר
- ריבוי מערכות וניווט מפוזר
- כפילות נתונים
- תהליכים ידניים
- חוסר בקרה/אישור על פעולות רגישות
- קושי בקבלת תמונת מצב ניהולית אחודה

---

## 3. Scope
## In Scope (MVP עד Release 1)
- מסך ראשי (Dashboard)
- משפך מכירות (Pipeline + Leads)
- מודול גבייה/פיננסים (Invoices/Payments/Debt)
- דוח חודשי ניהולי
- RBAC לפי תפקידים
- אינטגרציות REST:
  - Pickspace
  - Zoho CRM
  - Sumit
  - SAP (שלב ראשון: מתאם / שכבת הכנה)

## Out of Scope (שלבים מתקדמים)
- Mobile App Native
- AI המלצות אוטומטיות מתקדמות
- Workflow Designer ויזואלי למשתמש קצה

---

## 4. משתמשים (Personas)
1. הנהלה (נדב)
2. מכירות
3. שיווק
4. כספים/גבייה
5. תפעול
6. מנהל מערכת

---

## 5. KPI מוצר
1. צמצום מערכות מגע למשתמש (ממוצע לתהליך)
2. ירידה בכפילויות נתונים
3. זמן מחזור תהליך (Lead-to-Cash)
4. שיעור טעויות פיננסיות
5. שיעור פעולות רגישות עם אישור + Audit
6. Adoption (שימוש שבועי פעיל למשתמש תפקידי)

---

## 6. דרישות פונקציונליות לפי מודולים

## 6.1 Dashboard ראשי
### User Story
כ-[הנהלה/מנהל תחום] אני רוצה לראות תמונת מצב מאוחדת כדי לקבל החלטות מהירות.

### דרישות
- KPI cards: מכירות, גבייה, תפעול, חריגות
- Alerts feed: פעולות חריגות/חסרות אישור
- Shortcuts למסכים תפעוליים
- פילטרים: טווח תאריכים, מחלקה, אתר/לוקיישן

### Acceptance Criteria
- מוצגים לפחות 8 מדדים מרכזיים בזמן טעינה < 3 שניות
- כל KPI ניתן ל-drill-down למסך מקור
- Alerts מציגים חומרה (Low/Medium/High)

### Edge Cases
- מקור נתונים לא זמין -> KPI מוצג כ-"Data unavailable" + לוג שגיאה
- משתמש ללא הרשאת מודול -> KPI המודול מוסתר

---

## 6.2 מכירות — Pipeline + Leads
### User Story 1
כ-[איש מכירות] אני רוצה לראות לידים לפי שלבי משפך כדי לנהל מעקב והמרות.

### User Story 2
כ-[מנהל מכירות] אני רוצה לעדכן שלב ליד ולנטר צווארי בקבוק.

### דרישות
- תצוגת Kanban לפי Pipeline Stages
- יצירה/עדכון ליד
- המרת ליד ללקוח
- Sync דו-כיווני עם Pickspace / Zoho (לפי כללי מקור אמת)
- SLA התראה לליד ללא מגע מעל X שעות

### לוגיקה עסקית
- שינוי שלב ליד נרשם ב-Audit
- המרה ללקוח יוצרת ישות Customer פנימית ומקשרת ל-ID חיצוני
- ליד בדופליקט (טלפון/אימייל זהה) -> לא נוצר חדש, מוצג Merge flow

### Acceptance Criteria
- ניתן לגרור ליד בין שלבים ולשמור שינויים
- המרת ליד מצליחה מחזירה מזהה לקוח אחיד
- התראת SLA נוצרת אוטומטית לפי כלל מוגדר

### Edge Cases
- ליד חסר אימייל אך קיים טלפון: allowed עם סימון חסר
- התנגשות עדכון בין משתמשים: optimistic locking + הודעת רענון

---

## 6.3 גבייה ופיננסים
### User Story 1
כ-[איש כספים] אני רוצה לראות חשבוניות פתוחות כדי לנהל גבייה.

### User Story 2
כ-[מנהל כספים] אני רוצה לאשר פעולות חריגות לפני ביצוע.

### דרישות
- רשימת חשבוניות (Open/Overdue/Paid/Cancelled)
- מסך תשלום/חיוב
- Aging 30/60/90
- פעולות חריגות: זיכוי, ביטול, שינוי סכום
- תיעוד אישור חובה לפעולות High Risk
- Sync עם Sumit ו-Pickspace

### לוגיקה עסקית
- חשבונית שנפרעה -> סטטוס Paid + תאריך פירעון + מקור תשלום
- שינוי סכום מעל סף -> עובר ל-Pending Approval
- ביטול מסמך פיננסי מחייב Audit + סיבת ביטול

### Acceptance Criteria
- חיפוש חשבוניות לפי לקוח/תאריך/סטטוס
- פעולה חריגה לא מבוצעת ללא אישור
- Aging מתעדכן אוטומטית יומי

### Edge Cases
- תשלום חלקי -> סטטוס Partially Paid + יתרה
- כשל API ל-Sumit -> queue retry + alert למשתמש

---

## 6.4 דוח חודשי ניהולי
### User Story
כ-[מנכ"ל] אני רוצה דוח חודשי מאוחד כדי לעקוב אחרי יעדים.

### דרישות
- סיכום מכירות/גבייה/תפעול
- השוואה לחודש קודם + יעד
- רשימת חריגות עיקריות
- Export: PDF/CSV

### Acceptance Criteria
- דוח מופק עד 60 שניות
- המספרים עקביים מול מודולי מקור
- ניתן לייצא ולהוריד

### Edge Cases
- נתונים חסרים ממערכת חיצונית -> הדוח מסמן section as partial

---

## 7. לוגיקת אישורים (Human-in-the-Loop)
## רמות סיכון
- Low: פעולה שוטפת לא כספית
- Medium: פעולה תפעולית/כספית מוגבלת
- High: פעולה כספית חריגה/שינוי מהותי

## כללים
1. High תמיד דורש אישור כפול (מנהל תחום + הנהלה)
2. Medium דורש אישור מנהל תחום
3. Low לפי מדיניות תפקיד
4. כל אישור נרשם Audit (מי/מתי/מה/לפני/אחרי)

---

## 8. Audit ו-Observability
- Audit trail לכל CRUD רגיש
- Correlation ID לכל קריאה בין מערכות
- Failure log לכל אינטגרציה
- Dashboard תקלות אינטגרציה

---

## 9. דרישות לא-פונקציונליות (NFR)
1. Availability: 99.5% בחודש
2. API timeout: 10 שניות ברירת מחדל
3. Retry policy: עד 3 ניסיונות (Exponential Backoff)
4. Security:
   - JWT/RBAC
   - הצפנת נתונים במעבר (TLS)
   - שמירת סודות ב-Secret Manager
5. Logging:
   - ללא חשיפת API keys בלוג
6. Data freshness:
   - מסכי תפעול: עד 5 דקות איחור
   - דוחות חודשיים: snapshot יומי

---

## 10. רשימת User Stories (Development List)
להלן רשימה ראשונית (מספור לצורכי backlog):

1. US-001 Login + role resolution
2. US-002 Dashboard KPI cards
3. US-003 Alerts feed
4. US-004 Lead list + filters
5. US-005 Lead create/update
6. US-006 Lead stage transition
7. US-007 Lead conversion to customer
8. US-008 Duplicate detection
9. US-009 Invoice list + filters
10. US-010 Payment registration
11. US-011 Aging 30/60/90
12. US-012 Exception approval flow
13. US-013 Monthly report generation
14. US-014 Report export PDF/CSV
15. US-015 Audit log viewer
16. US-016 Pickspace sync jobs
17. US-017 Zoho sync jobs
18. US-018 Sumit sync jobs
19. US-019 SAP handoff adapter
20. US-020 Error handling + retry center

---

## 11. Open Questions (להכרעה לפני Dev Freeze)
1. מי מקור אמת סופי עבור Leads: Zoho או Pickspace?
2. האם SAP אינטגרציה פעילה ב-MVP או רק export feed?
3. ספי אישור כספיים מדויקים (סכום/אחוז) לכל רמת סיכון
4. אילו שדות חובה בכל ישות עבור Go-Live

---

## 12. Definition of Done (DoD) לכל Story
- קוד + בדיקות יחידה
- בדיקות אינטגרציה בסיסיות
- Audit events מחוברים
- הרשאות RBAC ממומשות
- תיעוד API/Schema מעודכן
- Acceptance Criteria עברו QA
