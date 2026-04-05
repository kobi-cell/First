# WORKIES AIO — Data Model Initial (Mockup Aligned)

## 1. מטרת המסמך
להגדיר מבנה נתונים ראשוני (יישויות, שדות, קשרים) שמכסה את כל מסכי המוקאפ:
- Workbench
- התראות
- גבייה
- Pipeline
- חוזים וחידושים
- KPI
- Aging
- דוח שבועי
- P&L חודשי

---

## 2. עקרונות מודל
1. לכל ישות מזהה פנימי `uuid`.
2. לכל ישות נתמכת באינטגרציה שדות `external_id_*`.
3. כל ישות כוללת `created_at`, `updated_at`.
4. סטטוסים מוגדרים כ-enum.
5. כל פעולה רגישה נרשמת ב-AuditEvent.

---

## 3. ישויות ליבה (Core)

## 3.1 User
- id (uuid, pk)
- full_name (string)
- email (string, unique)
- role (enum: management, sales, marketing, finance, operations, admin)
- is_active (boolean)
- created_at, updated_at

## 3.2 Alert
תומך במסך "התראות".
- id (uuid, pk)
- severity (enum: low, medium, high)
- module (enum: collections, sales, contracts, operations, reports, kpi, system)
- title (string)
- body (text)
- related_entity_type (enum: invoice, lead, contract, task, kpi_snapshot, report, payment, customer)
- related_entity_id (uuid/string)
- due_at (timestamp, nullable)
- action_label (string, nullable)  // למשל: "שלח תזכורת"
- action_route (string, nullable)
- source (enum: rule_engine, integration, manual)
- is_read (boolean, default false)
- created_at

## 3.3 Customer
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- external_id_zoho_account (string, nullable)
- external_id_sumit_customer (string, nullable)
- name (string)
- company_number (string, nullable)
- email (string, nullable)
- phone (string, nullable)
- status (enum: active, inactive, at_risk)
- created_at, updated_at

## 3.4 Office
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- office_name (string)
- location_name (string, nullable)
- office_type (enum: office, desk, meeting_room, other)
- occupancy_status (enum: occupied, available, reserved, maintenance)
- created_at, updated_at

## 3.5 Contract
תומך במסך "חוזים וחידושים".
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- customer_id (uuid, fk -> Customer)
- office_id (uuid, fk -> Office, nullable)
- contract_number (string, nullable)
- start_date (date)
- end_date (date)
- monthly_amount (decimal)
- currency (string, default ILS)
- renewal_status (enum: active, renewal_required, proposal_sent, signed, leaving, expired)
- renewal_risk_level (enum: low, medium, high)
- next_action_date (date, nullable)
- created_at, updated_at

## 3.6 Lead
תומך במסך Pipeline.
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- external_id_zoho (string, nullable)
- name (string)
- company_name (string, nullable)
- email (string, nullable)
- phone (string, nullable)
- pipeline_id (uuid, fk -> Pipeline)
- stage_id (uuid, fk -> PipelineStage)
- expected_monthly_value (decimal, nullable)
- expected_arr (decimal, nullable)
- is_hot (boolean, default false)
- owner_user_id (uuid, fk -> User)
- status (enum: open, won, lost, converted)
- created_at, updated_at

## 3.7 Pipeline
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- name (string)
- is_active (boolean)
- created_at, updated_at

## 3.8 PipelineStage
- id (uuid, pk)
- pipeline_id (uuid, fk -> Pipeline)
- external_id_pickspace (string, nullable)
- stage_name (enum: new_inquiry, proposal_sent, negotiation, closed_won, closed_lost)
- sort_order (int)
- created_at, updated_at

## 3.9 Invoice
תומך במסכי גבייה + Aging.
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- external_id_sumit_document (string, nullable)
- customer_id (uuid, fk -> Customer)
- contract_id (uuid, fk -> Contract, nullable)
- office_id (uuid, fk -> Office, nullable)
- invoice_number (string, nullable)
- issue_date (date)
- due_date (date)
- total_amount (decimal)
- paid_amount (decimal, default 0)
- balance_amount (decimal)
- status (enum: open, partial, paid, cancelled, overdue)
- aging_bucket (enum: d0_30, d31_60, d61_90, d90_plus)
- created_at, updated_at

## 3.10 Payment
- id (uuid, pk)
- external_id_pickspace (string, nullable)
- external_id_sumit_payment (string, nullable)
- customer_id (uuid, fk -> Customer)
- amount (decimal)
- payment_date (timestamp)
- method (enum: card, direct_debit, transfer, cash, check, other)
- status (enum: success, failed, chargeback, refunded, pending)
- reference_number (string, nullable)
- created_at, updated_at

## 3.11 Task
משימות יומיות ל-Workbench.
- id (uuid, pk)
- title (string)
- description (text, nullable)
- module (enum: sales, collections, contracts, operations, reports)
- entity_type (string)
- entity_id (uuid/string)
- priority (enum: critical, urgent, normal)
- status (enum: open, in_progress, done, cancelled)
- due_date (date, nullable)
- assignee_user_id (uuid, fk -> User)
- created_at, updated_at

## 3.12 KPI Snapshot
תומך מסכי KPI / Workbench.
- id (uuid, pk)
- period_type (enum: daily, weekly, monthly)
- period_label (string)  // e.g. 2026-03
- metric_key (string)    // e.g. collection_rate
- metric_name (string)
- actual_value (decimal)
- target_value (decimal, nullable)
- delta_percent (decimal, nullable)
- status (enum: on_track, near_target, off_track)
- created_at

## 3.13 Weekly Report
- id (uuid, pk)
- week_label (string) // e.g. 2026-W11
- generated_at (timestamp)
- generated_by (enum: system, user)
- report_file_url (string, nullable)
- summary_json (json)
- created_at

## 3.14 Monthly PnL Report
- id (uuid, pk)
- month_label (string) // e.g. 2026-02
- generated_at (timestamp)
- revenue_total (decimal)
- expense_total (decimal)
- gross_profit (decimal)
- profit_margin_percent (decimal)
- report_file_url (string, nullable)
- categories_json (json) // breakdown by category
- created_at

## 3.15 ApprovalRequest
תומך זרימות אישור חריגות.
- id (uuid, pk)
- action_type (enum: invoice_cancel, payment_adjustment, contract_change, write_off, other)
- entity_type (string)
- entity_id (uuid/string)
- risk_level (enum: low, medium, high)
- requested_by_user_id (uuid, fk -> User)
- approver_user_id (uuid, fk -> User, nullable)
- status (enum: pending, approved, rejected, expired)
- reason (text, nullable)
- approved_at (timestamp, nullable)
- rejected_at (timestamp, nullable)
- created_at, updated_at

## 3.16 AuditEvent
- id (uuid, pk)
- user_id (uuid, nullable)
- action (string)
- entity_type (string)
- entity_id (string)
- before_json (json, nullable)
- after_json (json, nullable)
- source_system (enum: workies, pickspace, zoho, sumit, sap)
- correlation_id (string, nullable)
- created_at

## 3.17 IntegrationJob
- id (uuid, pk)
- connector (enum: pickspace, zoho, sumit, sap)
- job_type (string)
- direction (enum: inbound, outbound, bidirectional)
- status (enum: queued, running, succeeded, failed, retrying, dead_letter)
- attempts (int, default 0)
- last_error (text, nullable)
- payload_ref (string/json, nullable)
- scheduled_at (timestamp, nullable)
- started_at (timestamp, nullable)
- finished_at (timestamp, nullable)
- created_at, updated_at

---

## 4. קשרים מרכזיים
1. Customer 1:N Contract
2. Customer 1:N Invoice
3. Customer 1:N Payment
4. Office 1:N Contract
5. Contract 1:N Invoice
6. Pipeline 1:N PipelineStage
7. PipelineStage 1:N Lead
8. ApprovalRequest N:1 User (requester/approver)
9. Task N:1 User (assignee)
10. Alert קשור לכל ישות עסקית דרך related_entity_type/id

---

## 5. מפת Source of Truth (גרסה ראשונית)
- Leads/Pipeline: Zoho CRM או Pickspace (נעילה לפני פיתוח)
- Customers/Contracts/Offices: Pickspace
- Invoices/Payments: Sumit (חשבונאי) + Pickspace (תפעולי)
- KPI/Reports: Workies (מחושב מאוחד)

---

## 6. שדות חובה מינימליים למסכי המוקאפ
## Workbench
- Task.title, Task.priority, Task.due_date, Alert.severity
- KPI Snapshot (רווח, גבייה, תפוסה, חריגות)

## גבייה / Aging
- Invoice.invoice_number, customer_id, total_amount, paid_amount, balance_amount, due_date, aging_bucket, status

## Pipeline
- Lead.name, stage_id, expected_monthly_value, expected_arr, is_hot, last_activity

## חוזים וחידושים
- Contract.end_date, renewal_status, monthly_amount, next_action_date

## דוחות
- WeeklyReport.summary_json
- MonthlyPnLReport.revenue_total, expense_total, gross_profit, categories_json

---

## 7. החלטות פתוחות לפני נעילת Schema
1. הגדרת ספי Aging מדויקים אם due_date בעתיד (pre-due bucket).
2. האם לשמור Monthly KPI כחישוב בזמן אמת או snapshot nightly בלבד.
3. זיהוי חד-ערכי לקוח (company_number מול email/phone fallback).
4. ניהול currency במקרה לקוחות בינלאומיים (כרגע ILS default).
