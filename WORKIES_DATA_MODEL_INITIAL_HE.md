# WORKIES AIO — Data Model (Initial)

## 1. מטרת המסמך
הגדרת מודל נתונים ראשוני לפיתוח.  
לא ERD מלא, אלא פירוט ישויות, שדות, טיפוסים, קשרים ומפת מקור אמת.

---

## 2. עקרונות
1. לכל ישות יש `id` פנימי (UUID) + `external_id` לפי מערכת חיצונית אם קיים.
2. כל טבלה כוללת `created_at`, `updated_at`, `created_by`, `updated_by`.
3. סטטוסים מוגדרים כ-enum.
4. פעולות רגישות נרשמות ב-AuditEvent.

---

## 3. ישויות ליבה

## 3.1 Customer (לקוח)
תיאור: ישות מאוחדת ללקוח עסקי/פרטי.

שדות:
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- external_id_zoho (string, nullable)
- external_id_sumit_customer (string, nullable)
- customer_type (enum: company, individual)
- name (string, required)
- company_number (string, nullable)
- email (string, nullable)
- phone (string, nullable)
- status (enum: active, inactive, blocked)
- billing_address (json, nullable)
- notes (text, nullable)
- created_at, updated_at

קשרים:
- Customer 1:N Contract
- Customer 1:N Invoice
- Customer 1:N Payment
- Customer 1:N Lead (אחרי המרה, optional)

---

## 3.2 Lead (ליד)
תיאור: הזדמנות מכירה לפני המרה ללקוח.

שדות:
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- external_id_zoho (string, nullable)
- source (string)
- first_name (string)
- last_name (string)
- company_name (string, nullable)
- email (string, nullable)
- phone (string, nullable)
- pipeline_id (uuid, fk)
- pipeline_stage_id (uuid, fk)
- owner_user_id (uuid, fk User)
- score (int, nullable)
- status (enum: open, qualified, won, lost, converted)
- last_contact_at (timestamp, nullable)
- converted_customer_id (uuid, fk Customer, nullable)
- created_at, updated_at

קשרים:
- Lead N:1 Pipeline
- Lead N:1 PipelineStage
- Lead N:1 User (owner)
- Lead 0..1 -> Customer

---

## 3.3 Pipeline
שדות:
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- name (string)
- is_default (boolean)
- is_active (boolean)
- created_at, updated_at

קשרים:
- Pipeline 1:N PipelineStage
- Pipeline 1:N Lead

## 3.4 PipelineStage
שדות:
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- pipeline_id (uuid, fk)
- name (string)
- order_index (int)
- probability (int, nullable, 0-100)
- is_closed_stage (boolean)
- created_at, updated_at

---

## 3.5 Office (משרד/יחידה)
שדות:
- id (uuid, pk)
- external_id_pickspace (string)
- location_id (string/uuid, nullable)
- code (string, nullable)
- name (string)
- office_type (enum: private_office, desk, meeting_room, other)
- status (enum: available, occupied, reserved, maintenance)
- size_sqm (decimal, nullable)
- floor (string, nullable)
- created_at, updated_at

קשרים:
- Office 1:N Contract
- Office 1:N Invoice (דרך הקצאה/חיוב)

---

## 3.6 Contract (חוזה)
שדות:
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- customer_id (uuid, fk)
- office_id (uuid, fk)
- contract_number (string, nullable)
- start_date (date)
- end_date (date, nullable)
- billing_cycle (enum: monthly, quarterly, yearly)
- amount (decimal)
- currency (string, default ILS)
- discount_percent (decimal, nullable)
- status (enum: draft, active, suspended, terminated, expired)
- signed_at (timestamp, nullable)
- created_at, updated_at

קשרים:
- Contract N:1 Customer
- Contract N:1 Office
- Contract 1:N Invoice

---

## 3.7 Invoice (חשבונית/מסמך חיוב)
שדות:
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- external_id_sumit_document (string, nullable)
- customer_id (uuid, fk)
- contract_id (uuid, fk, nullable)
- invoice_number (string, nullable)
- issue_date (date)
- due_date (date, nullable)
- total_amount (decimal)
- currency (string, default ILS)
- status (enum: draft, issued, sent, partially_paid, paid, overdue, cancelled)
- payment_status (enum: unpaid, partial, paid, failed)
- sent_at (timestamp, nullable)
- cancelled_at (timestamp, nullable)
- created_at, updated_at

קשרים:
- Invoice N:1 Customer
- Invoice N:1 Contract (optional)
- Invoice 1:N InvoiceLine
- Invoice 1:N PaymentAllocation

## 3.8 InvoiceLine
שדות:
- id (uuid, pk)
- invoice_id (uuid, fk)
- description (string)
- quantity (decimal)
- unit_price (decimal)
- vat_rate (decimal, nullable)
- line_total (decimal)
- created_at, updated_at

---

## 3.9 Payment (תשלום)
שדות:
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- external_id_sumit_payment (string, nullable)
- customer_id (uuid, fk)
- amount (decimal)
- currency (string, default ILS)
- payment_date (timestamp)
- method (enum: card, bank_transfer, cash, check, direct_debit, other)
- status (enum: initiated, succeeded, failed, chargeback, refunded)
- reference_number (string, nullable)
- failure_reason (string, nullable)
- created_at, updated_at

קשרים:
- Payment N:1 Customer
- Payment N:M Invoice דרך PaymentAllocation

## 3.10 PaymentAllocation
שדות:
- id (uuid, pk)
- payment_id (uuid, fk)
- invoice_id (uuid, fk)
- allocated_amount (decimal)
- created_at, updated_at

---

## 3.11 Task (משימה תפעולית)
שדות:
- id (uuid, pk)
- entity_type (enum: lead, customer, invoice, payment, contract, office, system)
- entity_id (uuid/string)
- title (string)
- description (text, nullable)
- assignee_user_id (uuid, fk User)
- priority (enum: low, medium, high, critical)
- status (enum: open, in_progress, blocked, done, cancelled)
- due_at (timestamp, nullable)
- created_at, updated_at

---

## 3.12 ApprovalRequest (בקשת אישור)
שדות:
- id (uuid, pk)
- action_type (enum: discount_change, invoice_cancel, write_off, payment_refund, contract_change, other)
- entity_type (enum: invoice, payment, contract, customer, lead, system)
- entity_id (uuid/string)
- risk_level (enum: low, medium, high)
- requested_by (uuid, fk User)
- approver_user_id (uuid, fk User, nullable)
- status (enum: pending, approved, rejected, expired)
- reason (text, nullable)
- approved_at (timestamp, nullable)
- rejected_at (timestamp, nullable)
- created_at, updated_at

---

## 3.13 AuditEvent
שדות:
- id (uuid, pk)
- user_id (uuid, fk User, nullable)
- action (string)
- entity_type (string)
- entity_id (string)
- before_json (json, nullable)
- after_json (json, nullable)
- correlation_id (string, nullable)
- source_system (enum: workies, pickspace, zoho, sumit, sap, other)
- created_at

---

## 3.14 IntegrationJob
שדות:
- id (uuid, pk)
- connector (enum: pickspace, zoho, sumit, sap)
- direction (enum: inbound, outbound, bidirectional)
- job_type (string)
- status (enum: queued, running, succeeded, failed, retried)
- payload_ref (string/json)
- attempts (int)
- last_error (text, nullable)
- scheduled_at (timestamp, nullable)
- started_at (timestamp, nullable)
- finished_at (timestamp, nullable)
- created_at, updated_at

---

## 3.15 User
שדות:
- id (uuid, pk)
- external_auth_id (string, nullable)
- full_name (string)
- email (string, unique)
- role_id (uuid, fk Role)
- is_active (boolean)
- last_login_at (timestamp, nullable)
- created_at, updated_at

## 3.16 Role
שדות:
- id (uuid, pk)
- name (enum: management, sales, marketing, finance, operations, admin)
- description (string, nullable)
- created_at, updated_at

---

## 4. קשרים מרכזיים (Summary)
1. Customer -> Contracts -> Invoices -> Payments
2. Leads -> Pipeline -> Conversion -> Customer
3. Offices <- Contracts (שיוך יחידה לחוזה)
4. ApprovalRequest נקשר ל-Invoice/Payment/Contract לפי פעולה
5. AuditEvent ו-IntegrationJob חוצי ישויות

---

## 5. Source of Truth (גרסה ראשונית)
- לקוח/חוזה/משרד: Pickspace
- ליד/Pipeline: Zoho CRM או Pickspace (החלטה סופית נדרשת)
- מסמכי חיוב/תשלומים: Sumit
- ישות מאוחדת פנים-מערכתית: Workies DB

---

## 6. אינדקסים מומלצים (ביצועים)
- Lead: (status, pipeline_stage_id, owner_user_id, updated_at)
- Invoice: (status, due_date, customer_id, issue_date)
- Payment: (status, payment_date, customer_id)
- ApprovalRequest: (status, risk_level, approver_user_id, created_at)
- AuditEvent: (entity_type, entity_id, created_at)
- IntegrationJob: (connector, status, scheduled_at)

---

## 7. החלטות פתוחות לפני נעילת DB Schema
1. מקור אמת סופי ל-Leads (Zoho vs Pickspace)
2. שימוש ב-SAP ב-MVP: write-through vs export-only
3. ספי סיכון כספי מספריים (בשקלים/אחוזים)
4. אחידות מזהים חיצוניים (string vs numeric normalization)
