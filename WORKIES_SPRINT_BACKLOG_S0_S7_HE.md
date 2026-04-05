# WORKIES AIO — Backlog & Sprint Plan (S0-S7) — Updated to Mockup v2

## 1) עקרונות תכנון
- משך ספרינט: 2 שבועות
- Story Points (SP): הערכה ראשונית לצוות Dev
- סדר פיתוח נגזר ישירות מהמסכים במוקאפ:
  1) Workbench + Alerts
  2) Pipeline
  3) Contracts & Renewals
  4) Collections + Aging
  5) KPI/Weekly/Monthly Reports

---

## 2) מסכי יעד מהמוקאפ (Traceability)
| Screen ID | שם מסך | מקור במוקאפ |
|---|---|---|
| SCR-01 | Workbench | page 1 |
| SCR-02 | Alerts | page 2 |
| SCR-03 | Collections | page 3 |
| SCR-04 | Pipeline | page 4 |
| SCR-05 | Contracts & Renewals | page 5 |
| SCR-06 | KPI Report | page 6 |
| SCR-07 | Aging Report | page 7 |
| SCR-08 | Weekly Report | page 8 |
| SCR-09 | Monthly P&L | page 9 |

---

## 3) Sprint S0 — Foundation
מטרה: שלד מערכת, הרשאות, audit, תשתיות.

| Story ID | Story | SP |
|---|---|---:|
| US-001 | פרויקט בסיס + CI/CD + environments | 8 |
| US-002 | Auth + JWT + session handling | 8 |
| US-003 | RBAC middleware לפי מטריצה | 8 |
| US-004 | Audit log foundation + correlation ID | 8 |
| US-005 | Error framework + retry utilities | 5 |

**סה"כ S0: 37 SP**

---

## 4) Sprint S1 — Workbench + Alerts
מטרה: מסכי SCR-01, SCR-02 פעילים.

| Story ID | Story | SP | Screen |
|---|---|---:|---|
| US-006 | App shell + side nav + counters | 8 | SCR-01 |
| US-007 | KPI cards live bindings | 8 | SCR-01 |
| US-008 | Urgent tasks widget + actions | 8 | SCR-01 |
| US-009 | Alerts list + severity + filters | 8 | SCR-02 |
| US-010 | Alert actions (send reminder, update, escalate) | 8 | SCR-02 |
| US-011 | Mark-as-read / mark-all-read | 3 | SCR-02 |

**סה"כ S1: 43 SP**

---

## 5) Sprint S2 — Pipeline + Contracts
מטרה: מסכי SCR-04, SCR-05.

| Story ID | Story | SP | Screen |
|---|---|---:|---|
| US-012 | Pipeline Kanban board | 13 | SCR-04 |
| US-013 | Lead CRUD + stage transitions | 13 | SCR-04 |
| US-014 | Convert lead to member + contract trigger | 8 | SCR-04 |
| US-015 | Contracts list + renewal statuses | 8 | SCR-05 |
| US-016 | Renewal actions (renew, exit, update signed) | 8 | SCR-05 |
| US-017 | Contract risk flags (14/30 days) | 5 | SCR-05 |

**סה"כ S2: 55 SP**

---

## 6) Sprint S3 — Collections + Aging
מטרה: מסכי SCR-03, SCR-07.

| Story ID | Story | SP | Screen |
|---|---|---:|---|
| US-018 | Open invoices table + filters | 8 | SCR-03 |
| US-019 | Collection tasks panel + actions | 8 | SCR-03 |
| US-020 | Debt buckets 0-30/31-60/61-90/90+ | 8 | SCR-03/SCR-07 |
| US-021 | Aging customer report table | 8 | SCR-07 |
| US-022 | Payment update flow (full/partial) | 8 | SCR-03 |
| US-023 | Reminder sending bulk/single | 5 | SCR-03/SCR-07 |
| US-024 | Exception workflow handoff to approvals | 5 | SCR-03 |

**סה"כ S3: 50 SP**

---

## 7) Sprint S4 — KPI + Weekly + Monthly Reports
מטרה: מסכי SCR-06, SCR-08, SCR-09.

| Story ID | Story | SP | Screen |
|---|---|---:|---|
| US-025 | KPI report page + target vs actual table | 8 | SCR-06 |
| US-026 | KPI trend widgets and status badges | 8 | SCR-06 |
| US-027 | Weekly report page + weekly comparison | 8 | SCR-08 |
| US-028 | Monthly P&L categories + margin cards | 8 | SCR-09 |
| US-029 | PDF export for all report screens | 8 | SCR-06/08/09 |
| US-030 | Email/send report actions | 5 | SCR-08/09 |

**סה"כ S4: 45 SP**

---

## 8) Sprint S5 — REST Integrations Wave 1
מטרה: Pickspace + Zoho ל-Sales/Contracts/Offices.

| Story ID | Story | SP |
|---|---|---:|
| US-031 | Pickspace leads/pipelines sync | 13 |
| US-032 | Pickspace members/contracts/offices sync | 13 |
| US-033 | Zoho leads/accounts/contacts sync | 13 |
| US-034 | Data reconciliation console (conflicts) | 8 |
| US-035 | Integration job monitoring (status/latency/errors) | 8 |

**סה"כ S5: 55 SP**

---

## 9) Sprint S6 — REST Integrations Wave 2 + Approvals
מטרה: Sumit + approvals מרכזי + SAP adapter v1.

| Story ID | Story | SP |
|---|---|---:|
| US-036 | Sumit customers/documents/payments integration | 13 |
| US-037 | Approval center UI + queue + actions | 13 |
| US-038 | Risk policy engine (low/medium/high) | 8 |
| US-039 | SAP adapter export (approved invoices/payments) | 8 |
| US-040 | End-to-end audit linkage (action->approval->result) | 8 |

**סה"כ S6: 50 SP**

---

## 10) Sprint S7 — Stabilization & Go-Live
מטרה: UAT, hardening, go-live checklist.

| Story ID | Story | SP |
|---|---|---:|
| US-041 | E2E tests for SCR-01..SCR-09 | 13 |
| US-042 | Performance tuning + query/index improvements | 8 |
| US-043 | Security hardening + permission audit | 8 |
| US-044 | UAT fixes batch | 13 |
| US-045 | Go-live runbook + rollback plan | 8 |

**סה"כ S7: 50 SP**

---

## 10.1) Popup Coverage Plan (POP-01..POP-08)
| Popup ID | תיאור | ספרינט יעד | Story IDs |
|---|---|---|---|
| POP-01 | שליחת תזכורת תשלום | S3 | US-019, US-023 |
| POP-02 | חשבונית חדשה | S3 + S6 | US-018, US-036 |
| POP-03 | עדכון הסדר תשלום | S3 | US-022, US-024 |
| POP-04 | הצעת מחיר לחתימה דיגיטלית | S2 + S5 | US-013, US-014, US-033 |
| POP-05 | עדכון מצב חידוש חוזה | S2 | US-015, US-016, US-017 |
| POP-06 | עדכון הסכם שנחתם + פעולות נלוות | S2 + S6 | US-016, US-037, US-040 |
| POP-07 | עדכון סיום הסכם/עזיבה | S2 + S6 | US-016, US-037, US-038 |
| POP-08 | אישור P&L חודשי | S4 + S6 | US-028, US-037, US-038 |

הערת ביצוע: פופאפים POP-06/07/08 מסומנים כ-critical וכוללים תרחישי E2E מחייבים ב-S7.

---

## 11) Summary
| Sprint | SP |
|---|---:|
| S0 | 37 |
| S1 | 43 |
| S2 | 55 |
| S3 | 50 |
| S4 | 45 |
| S5 | 55 |
| S6 | 50 |
| S7 | 50 |
| **Total** | **385 SP** |

---

## 12) Milestones
1. End S1: Workbench + Alerts demo
2. End S3: Sales + Collections operational demo
3. End S4: Full reporting demo
4. End S6: Integrations + approvals demo
5. End S7: Go-live readiness

---

## 13) Definition of Ready (לכל Story לפני ספרינט)
- מסך יעד קיים במוקאפ
- User story מנוסח
- Acceptance criteria מוגדר
- API dependencies ידועים
- Owner ברור
- כאשר רלוונטי: Popup ID מוגדר ומקושר ל-Story

## 14) Definition of Done
- Dev complete + QA pass
- RBAC enforced
- Audit events emitted
- API contracts updated
- Monitoring added
- Popup flows covered (open/save/cancel/error)
