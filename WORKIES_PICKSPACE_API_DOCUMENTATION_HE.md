# Pickspace API — דוקומנטציה מלאה וניתוח פונקציות עבור Workies

_מקור Swagger_: `https://workies.pickspace.com/api-v2/swagger-json`
_זמן יצירה_: 2026-04-05 21:58:35 UTC

## 1) היקף
- המסמך כולל **את כל הפונקציות (operations)** שמופיעות ב-Swagger של Pickspace.
- כולל: סיכום API, אבטחה, חלוקה לתחומים, קטלוג מלא לפי תגיות, ומיפוי שימוש ל-Workies.

## 2) תמונת מצב API
- שם API: **Pickspace API**
- גרסה: **1.40.3**
- מספר Paths: **294**
- מספר פונקציות כולל (Operations): **400**

### 2.1 אימות והרשאות
| Scheme | Type | Bearer Format |
|---|---|---|
| bearer | http | JWT |

- פונקציות עם אימות: **379**
- פונקציות ללא אימות: **21**

### 2.2 התפלגות לפי Method
| Method | Count |
|---|---:|
| GET | 216 |
| POST | 92 |
| PUT | 23 |
| PATCH | 38 |
| DELETE | 31 |

### 2.3 התפלגות לפי תחום (Tag)
| Tag | Operations |
|---|---:|
| invoices | 31 |
| analytics | 19 |
| locations | 16 |
| offices | 16 |
| offices/report | 10 |
| users | 10 |
| contracts | 9 |
| registers | 9 |
| budgets | 8 |
| cams | 8 |
| inspections | 8 |
| management-fee | 8 |
| members | 8 |
| leads | 7 |
| package | 7 |
| settings | 7 |
| applications | 6 |
| chats | 6 |
| email-group-conditions | 6 |
| payment-batches | 6 |
| payments | 6 |
| time-logs | 6 |
| checks | 5 |
| content | 5 |
| email-groups | 5 |
| email-senders | 5 |
| email-templates | 5 |
| expense-types | 5 |
| expenses | 5 |
| external-amenities | 5 |
| journal-entries | 5 |
| lead-metas | 5 |
| listing-sections | 5 |
| locks | 5 |
| ocr-integration | 5 |
| outgoing-payments | 5 |
| owners | 5 |
| reconciliations | 5 |
| ticket-tags | 5 |
| tours | 5 |
| transaction-account | 5 |
| accounting-account | 4 |
| accounting-code | 4 |
| auth | 4 |
| floor-plan-markers | 4 |
| form-templates | 4 |
| offices-history | 4 |
| pipeline-stages | 4 |
| scheduledReports | 4 |
| vendors | 4 |
| bills | 3 |
| companies | 3 |
| contract-templates | 3 |
| custom-field-values | 3 |
| custom-fields | 3 |
| form-template-fields | 3 |
| lead-sources | 3 |
| pipelines | 3 |
| untagged | 3 |
| countries | 2 |
| email-logs | 2 |
| lock-integration | 2 |
| tickets | 2 |
| transaction-account-type | 2 |
| ui-settings | 2 |
| zones | 2 |
| actions | 1 |
| alert-templates | 1 |
| currencies | 1 |
| email-lists | 1 |
| email-variables | 1 |
| failure-logs | 1 |
| file-upload | 1 |
| general-ledger | 1 |
| health | 1 |
| notifications | 1 |
| pdf-integration | 1 |

## 3) ניתוח פרקטי ל-Workies
| תחום Workies | Tags מרכזיים ב-Pickspace | עדיפות |
|---|---|---|
| גבייה ופיננסים | `invoices`, `payments`, `bills`, `registers`, `general-ledger` | Must |
| מכירות ומשפך | `leads`, `pipelines`, `pipeline-stages`, `applications`, `tours` | Must |
| חוזים וחידושים | `contracts`, `contract-templates`, `members`, `offices` | Must |
| דשבורד ו-KPI | `analytics`, `offices-history`, `locations`, `registers` | Must |
| תקשורת והתראות | `notifications`, `sms`, `email-*`, `content` | High |
| תפעול | `offices`, `offices/report`, `inspections`, `tickets` | High |

### כללי יישום מומלצים
1. פעולות פיננסיות כותבות: ללא retry עיוור, רק טיפול מבוקר + משימה.
2. פעולות תפעוליות/שליפה: retry מדורג (30s/2m/10m).
3. לזרימות חתימה/עזיבה יש להפעיל orchestration עם compensation.
4. לכל פעולה עסקית יש לתעד correlation_id ו-AuditEvent.

## 4) קטלוג מלא של כל הפונקציות (All Functions)
> הקטלוג כולל את כל 400 הפעולות מה-Swagger, מקובצות לפי Tag.

### invoices (31)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/invoices` | `InvoiceController_index` | כן | 8 |  | 200 |  |
| 2 | GET | `/api-v2/invoices/delinquency` | `InvoiceController_getAllOfficesHistoryDelinquency` | כן | 1 |  | 200 |  |
| 3 | GET | `/api-v2/invoices/expense-accrual` | `InvoiceController_getExpenseAccrual` | כן | 8 |  | 200 |  |
| 4 | GET | `/api-v2/invoices/expense-cash` | `InvoiceController_getExpenseCash` | כן | 8 |  | 200 |  |
| 5 | GET | `/api-v2/invoices/failed-integrations` | `InvoiceController_getFailedIntegrations` | כן | 3 |  | 200 |  |
| 6 | GET | `/api-v2/invoices/failed-to-be-sent-invoices` | `InvoiceController_getFailedToBeSentInvoices` | כן | 7 |  | 200 |  |
| 7 | GET | `/api-v2/invoices/getAllUnpaidInvoicesForCurrentMonth` | `InvoiceController_getAllUnpaidInvoicesForCurrentMonth` | כן | 0 |  | 200 |  |
| 8 | GET | `/api-v2/invoices/income-accrual` | `InvoiceController_getIncomeAccrual` | כן | 8 |  | 200 |  |
| 9 | GET | `/api-v2/invoices/income-cash` | `InvoiceController_getIncomeCash` | כן | 8 |  | 200 |  |
| 10 | GET | `/api-v2/invoices/invoice-extensions` | `InvoiceController_getInvoiceExtensions` | כן | 7 |  | 200 |  |
| 11 | GET | `/api-v2/invoices/invoice-extensions-within-date-range` | `InvoiceController_getInvoiceExtensionsWithinDateRange` | כן | 3 |  | 200 |  |
| 12 | GET | `/api-v2/invoices/invoice-extensions-within-date-range/owner` | `InvoiceController_getOwnerInvoiceExtensionsWithinDateRange` | כן | 3 |  | 200 |  |
| 13 | GET | `/api-v2/invoices/open-with-offices` | `InvoiceController_getOpenInvoicesWithOffices` | כן | 1 |  | 200 |  |
| 14 | GET | `/api-v2/invoices/open-with-offices/owner` | `InvoiceController_getOwnerOpenInvoicesWithOffices` | כן | 1 |  | 200 |  |
| 15 | GET | `/api-v2/invoices/recurring` | `InvoiceController_getInvoicesRecurringTemplate` | כן | 7 |  | 200 |  |
| 16 | GET | `/api-v2/invoices/recurring/{id}` | `InvoiceController_getInvoicesRecurringTemplateById` | כן | 1 |  | 200 |  |
| 17 | GET | `/api-v2/invoices/tenant-ledger` | `InvoiceController_getAllTenantInvoicesPayments` | כן | 2 |  | 200 |  |
| 18 | GET | `/api-v2/invoices/vendor` | `InvoiceController_getVendorInvoices` | כן | 7 |  | 200 |  |
| 19 | GET | `/api-v2/invoices/within-date-range` | `InvoiceController_getInvoicesWithinDateWithOffices` | כן | 3 |  | 200 |  |
| 20 | GET | `/api-v2/invoices/within-date-range/owner` | `InvoiceController_getOwnerInvoicesWithinDateWithOffices` | כן | 3 |  | 200 |  |
| 21 | GET | `/api-v2/invoices/{id}` | `InvoiceController_getById` | כן | 2 |  | 200 |  |
| 22 | POST | `/api-v2/invoices` | `InvoiceController_create` | כן | 0 | application/json:CreateInvoice | 201 |  |
| 23 | POST | `/api-v2/invoices/preview` | `InvoiceController_getInvoicePreview` | כן | 0 | application/json:GetInvoicePreviewValidation | 201 |  |
| 24 | POST | `/api-v2/invoices/recurring` | `InvoiceController_createRecurring` | כן | 0 | application/json:CreateRecurringValidation | 201 |  |
| 25 | POST | `/api-v2/invoices/recurring/{id}` | `InvoiceController_updateRecurring` | כן | 1 | application/json:CreateRecurringValidation | 201 |  |
| 26 | POST | `/api-v2/invoices/recurring/{id}/consume` | `InvoiceController_consumeInvoiceTemplate` | כן | 1 |  | 201 |  |
| 27 | POST | `/api-v2/invoices/recurring/{id}/disable` | `InvoiceController_disableRecurring` | כן | 1 |  | 201 |  |
| 28 | POST | `/api-v2/invoices/recurring/{id}/enable` | `InvoiceController_enableRecurring` | כן | 1 |  | 201 |  |
| 29 | POST | `/api-v2/invoices/vendor` | `InvoiceController_createVendorInvoice` | כן | 0 | application/json:CreateVendorInvoiceValidation | 201 |  |
| 30 | PATCH | `/api-v2/invoices/{id}` | `InvoiceController_updateInvoice` | כן | 1 | application/json:UpdateSingleInvoiceValidation | 200 |  |
| 31 | DELETE | `/api-v2/invoices/{id}` | `InvoiceController_deleteInvoice` | כן | 1 |  | 200 |  |

### analytics (19)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/analytics/churn` | `AnalyticsController_getChurn` | כן | 3 |  | 200 |  |
| 2 | GET | `/api-v2/analytics/conference-amenity` | `AnalyticsController_getAmenityAnalytics` | כן | 3 |  | 200 |  |
| 3 | GET | `/api-v2/analytics/dashboard-event-calendar` | `AnalyticsController_getDashboardEventCalendar` | כן | 3 |  | 200 |  |
| 4 | GET | `/api-v2/analytics/discount-pie-chart` | `AnalyticsController_getDiscountPieChart` | כן | 3 |  | 200 |  |
| 5 | GET | `/api-v2/analytics/move-in-move-out-widget` | `AnalyticsController_getMoveInMoveOutWidget` | כן | 3 |  | 200 |  |
| 6 | GET | `/api-v2/analytics/move-in-out` | `AnalyticsController_getMoveInOutAnalytics` | כן | 2 |  | 200 |  |
| 7 | GET | `/api-v2/analytics/occupancy/breakdown` | `AnalyticsController_getOccupancyBreakdown` | כן | 3 |  | 200 |  |
| 8 | GET | `/api-v2/analytics/occupancy/general` | `AnalyticsController_getGenralOccupancyStatistics` | כן | 2 |  | 200 |  |
| 9 | GET | `/api-v2/analytics/occupancy/timeline` | `AnalyticsController_getOccupancyByType` | כן | 3 |  | 200 |  |
| 10 | GET | `/api-v2/analytics/overview-widget` | `AnalyticsController_getOverview` | כן | 3 |  | 200 |  |
| 11 | GET | `/api-v2/analytics/report-categories` | `AnalyticsController_getReportCategories` | כן | 0 |  | 200 |  |
| 12 | GET | `/api-v2/analytics/reports` | `AnalyticsController_getReports` | כן | 0 |  | 200 |  |
| 13 | GET | `/api-v2/analytics/reports/{id}` | `AnalyticsController_getReportById` | כן | 1 |  | 200 |  |
| 14 | GET | `/api-v2/analytics/unit-types` | `AnalyticsController_getUnitTypes` | כן | 0 |  | 200 |  |
| 15 | POST | `/api-v2/analytics/report-categories` | `AnalyticsController_createReportCategory` | כן | 0 | application/json:CreateReportCategoryValidation | 201 |  |
| 16 | POST | `/api-v2/analytics/send-email` | `AnalyticsController_create` | כן | 0 | application/json:SendReportInMail | 201 |  |
| 17 | PUT | `/api-v2/analytics/report-categories/{id}` | `AnalyticsController_updateReportCategory` | כן | 1 | application/json:CreateReportCategoryValidation | 200 |  |
| 18 | PUT | `/api-v2/analytics/reports/{id}` | `AnalyticsController_updateReport` | כן | 1 | application/json:UpdateReportValidation | 200 |  |
| 19 | DELETE | `/api-v2/analytics/report-categories/{id}` | `AnalyticsController_deleteReportCategory` | כן | 1 |  | 200 |  |

### locations (16)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/locations` | `LocationController_index` | כן | 8 |  | 200 |  |
| 2 | GET | `/api-v2/locations/bank-accounts` | `LocationController_locationsBankAccounts` | כן | 0 |  | 200 |  |
| 3 | GET | `/api-v2/locations/counter-headers` | `LocationController_headers` | כן | 0 |  | 200 |  |
| 4 | GET | `/api-v2/locations/location-members` | `LocationController_locationMembers` | כן | 6 |  | 200 |  |
| 5 | GET | `/api-v2/locations/location-payment-member` | `LocationController_locationPaymentMember` | כן | 2 |  | 200 |  |
| 6 | GET | `/api-v2/locations/location-percentage/{id}` | `LocationController_locationPercentage` | כן | 1 |  | 200 |  |
| 7 | GET | `/api-v2/locations/location-settings/{id}` | `LocationController_locationSettings` | כן | 1 |  | 200 |  |
| 8 | GET | `/api-v2/locations/location-stats/{id}` | `LocationController_stats` | כן | 1 |  | 200 |  |
| 9 | GET | `/api-v2/locations/location-user/{id}` | `LocationController_locationUser` | כן | 1 |  | 200 |  |
| 10 | GET | `/api-v2/locations/member-saving-cross-report` | `LocationController_getMemberSavingReportForAllLocations` | כן | 0 |  | 200 |  |
| 11 | GET | `/api-v2/locations/payment-vendors` | `LocationController_locationsVendors` | כן | 0 |  | 200 |  |
| 12 | GET | `/api-v2/locations/property-ledger-report` | `LocationController_getPropertyLedger` | כן | 3 |  | 200 |  |
| 13 | GET | `/api-v2/locations/total-sqft/{id}` | `LocationController_getTotalSqftByLocationId` | כן | 1 |  | 200 |  |
| 14 | GET | `/api-v2/locations/{id}` | `LocationController_location` | כן | 2 |  | 200 |  |
| 15 | POST | `/api-v2/locations` | `LocationController_locationCreate` | כן | 0 | application/json:CreateLocation | 201 |  |
| 16 | PUT | `/api-v2/locations/{id}` | `LocationController_locationUpdate` | כן | 1 | application/json:UpdateLocation | 200 |  |

### offices (16)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/offices` | `OfficesController_getAll` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/offices/amenities` | `OfficesController_getAmenities` | כן | 3 |  | 200 |  |
| 3 | GET | `/api-v2/offices/feed/ZIF.xml` | `OfficesController_sendOfficeZIFXML` | כן | 0 |  | 200 |  |
| 4 | GET | `/api-v2/offices/filters` | `OfficesController_getOfficeFilters` | כן | 1 |  | 200 |  |
| 5 | GET | `/api-v2/offices/listings` | `OfficesController_getOfficesListing` | כן | 7 |  | 200 |  |
| 6 | GET | `/api-v2/offices/listings/available-types` | `OfficesController_getAvailableTypes` | כן | 0 |  | 200 |  |
| 7 | GET | `/api-v2/offices/listings/{id}` | `OfficesController_getOfficeListingById` | כן | 1 |  | 200 |  |
| 8 | GET | `/api-v2/offices/location-history` | `OfficesController_getAllOfficesHistoryByDate` | כן | 2 |  | 200 |  |
| 9 | GET | `/api-v2/offices/location/{id}` | `OfficesController_getOfficesByLocation` | כן | 1 |  | 200 |  |
| 10 | GET | `/api-v2/offices/location/{id}/available` | `OfficesController_getAvailableOfficesByLocation` | כן | 1 |  | 200 |  |
| 11 | GET | `/api-v2/offices/location/{id}/available-soon` | `OfficesController_findAllLeaseEndingOfficesByLocations` | כן | 2 |  | 200 |  |
| 12 | GET | `/api-v2/offices/office-entry-report` | `OfficesController_getOfficeEntryReport` | כן | 1 |  | 200 |  |
| 13 | GET | `/api-v2/offices/years` | `OfficesController_getMoveInYears` | כן | 1 |  | 200 |  |
| 14 | GET | `/api-v2/offices/{id}` | `OfficesController_getOfficeById` | כן | 1 |  | 200 |  |
| 15 | POST | `/api-v2/offices/amenities` | `OfficesController_createAmenity` | כן | 0 | application/json:CreateAmenityValidation | 201 |  |
| 16 | POST | `/api-v2/offices/{id}` | `OfficesController_updateMarketingInformation` | כן | 1 | application/json:UpdateOffice | 201 |  |

### offices/report (10)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/offices/report/consolidated-sales-report` | `OfficesReportController_getConsolidatedSalesReport` | כן | 3 |  | 200 |  |
| 2 | GET | `/api-v2/offices/report/contract-value-report` | `OfficesReportController_getContractValueReport` | כן | 3 |  | 200 |  |
| 3 | GET | `/api-v2/offices/report/lease-report` | `OfficesReportController_getLeaseReport` | כן | 1 |  | 200 |  |
| 4 | GET | `/api-v2/offices/report/office-entry-report` | `OfficesReportController_getOfficeEntryReport` | כן | 1 |  | 200 |  |
| 5 | GET | `/api-v2/offices/report/rent-change-report` | `OfficesReportController_getRentChangeReport` | כן | 3 |  | 200 |  |
| 6 | GET | `/api-v2/offices/report/sales-report` | `OfficesReportController_getSalesReport` | כן | 3 |  | 200 |  |
| 7 | GET | `/api-v2/offices/report/tenant-payment-report` | `OfficesReportController_getTenantPaymentReport` | כן | 3 |  | 200 |  |
| 8 | GET | `/api-v2/offices/report/tenant-turnover-report` | `OfficesReportController_getOfficeTurnoverReport` | כן | 3 |  | 200 |  |
| 9 | GET | `/api-v2/offices/report/unit-discount-logs-report` | `OfficesReportController_getUnitDiscountLogsReport` | כן | 1 |  | 200 |  |
| 10 | GET | `/api-v2/offices/report/vacancy-report` | `OfficesReportController_getVacancyReport` | כן | 1 |  | 200 |  |

### users (10)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/users` | `UsersController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/users/brokers` | `UsersController_getBrokers` | כן | 0 |  | 200 |  |
| 3 | GET | `/api-v2/users/ids` | `UsersController_indexByIds` | כן | 1 |  | 200 |  |
| 4 | GET | `/api-v2/users/{id}` | `UsersController_getById` | כן | 1 |  | 200 |  |
| 5 | POST | `/api-v2/users` | `UsersController_create` | כן | 0 | application/json:CreateUser | 201 |  |
| 6 | PUT | `/api-v2/users/info/{id}` | `UsersController_updateUserInfo` | כן | 0 | application/json:UpdateUserInfo | 200 |  |
| 7 | PUT | `/api-v2/users/permissions` | `UsersController_assignPermissions` | כן | 0 | application/json:PermissionsValidations | 200 |  |
| 8 | PUT | `/api-v2/users/{id}` | `UsersController_updateUser` | כן | 0 | application/json:UpdateUser | 200 |  |
| 9 | DELETE | `/api-v2/users/permissions` | `UsersController_revokePermissions` | כן | 0 | application/json:PermissionsValidations | 200 |  |
| 10 | DELETE | `/api-v2/users/{id}` | `UsersController_delete` | כן | 1 |  | 200 |  |

### contracts (9)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/contracts` | `ContractController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/contracts/search_member` | `ContractController_searchMember` | כן | 7 |  | 200 |  |
| 3 | GET | `/api-v2/contracts/{id}` | `ContractController_show` | כן | 1 |  | 200 |  |
| 4 | POST | `/api-v2/contracts/smart` | `ContractController_create` | כן | 0 | application/json:CreateSmartContract | 201 |  |
| 5 | PUT | `/api-v2/contracts/{id}` | `ContractController_update` | כן | 1 | application/json:UpdateSmartContractValidation | 200 |  |
| 6 | PATCH | `/api-v2/contracts/{id}/approve` | `ContractController_approve` | כן | 1 |  | 200 |  |
| 7 | PATCH | `/api-v2/contracts/{id}/decline` | `ContractController_decline` | כן | 1 | application/json:DeclineSmartContract | 200 |  |
| 8 | PATCH | `/api-v2/contracts/{id}/sign` | `ContractController_sign` | כן | 1 |  | 200 |  |
| 9 | DELETE | `/api-v2/contracts/{id}` | `ContractController_remove` | כן | 1 |  | 200 |  |

### registers (9)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/registers` | `RegisterController_index` | כן | 8 |  | 200 |  |
| 2 | GET | `/api-v2/registers/12-months-rolling` | `RegisterController_twelve_months_rolling` | כן | 8 |  | 200 |  |
| 3 | GET | `/api-v2/registers/balance-sheet` | `RegisterController_balanceSheet` | כן | 8 |  | 200 |  |
| 4 | GET | `/api-v2/registers/budget-vs-actual` | `RegisterController_getBudgetVsActualReport` | כן | 3 |  | 200 |  |
| 5 | GET | `/api-v2/registers/income-expense-report` | `RegisterController_getIncomeExpenseTransactionReport` | כן | 8 |  | 200 |  |
| 6 | GET | `/api-v2/registers/member/{memberId}` | `RegisterController_getMemberInvoices` | כן | 1 |  | 200 |  |
| 7 | GET | `/api-v2/registers/operating-statement` | `RegisterController_operating_statement` | כן | 8 |  | 200 |  |
| 8 | GET | `/api-v2/registers/pnl` | `RegisterController_pnl` | כן | 6 |  | 200 |  |
| 9 | GET | `/api-v2/registers/total` | `RegisterController_total` | כן | 8 |  | 200 |  |

### budgets (8)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/budgets` | `BudgetController_getAll` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/budgets/values` | `BudgetController_getBudgetValues` | כן | 7 |  | 200 |  |
| 3 | POST | `/api-v2/budgets` | `BudgetController_create` | כן | 0 | application/json:CreateBudget | 201 |  |
| 4 | POST | `/api-v2/budgets/values` | `BudgetController_createBudgetValue` | כן | 0 | application/json:CreateBudgetValueValidation | 201 |  |
| 5 | POST | `/api-v2/budgets/values/template` | `BudgetController_getTemplate` | כן | 0 | application/json:GetBudgetTemplateValidation | 201 |  |
| 6 | POST | `/api-v2/budgets/values/{id}/import` | `BudgetController_import` | כן | 1 |  | 201 |  |
| 7 | PATCH | `/api-v2/budgets/values/{id}` | `BudgetController_UpdateBudgetValueValue` | כן | 1 | application/json:UpdateBudgetValueValue | 200 |  |
| 8 | DELETE | `/api-v2/budgets/values/{id}` | `BudgetController_removeBudgetValue` | כן | 1 |  | 200 |  |

### cams (8)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/cams` | `CamsController_getAll` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/cams/cams-expenses-lines/{id}` | `CamsController_getCamsWithExpensesLines` | כן | 1 |  | 200 |  |
| 3 | GET | `/api-v2/cams/get-cam-invoices/{id}` | `CamsController_getCamInvoices` | כן | 1 |  | 200 |  |
| 4 | GET | `/api-v2/cams/get-invoices-members-simulation/{id}` | `CamsController_getInvoicesMembersSimulation` | כן | 1 |  | 200 |  |
| 5 | GET | `/api-v2/cams/initiating-invoice-members/{id}` | `CamsController_initiatingInvoiceMembers` | כן | 1 |  | 200 |  |
| 6 | GET | `/api-v2/cams/outstanding-cams-report` | `CamsController_getOutstandingCamsReport` | כן | 3 |  | 200 |  |
| 7 | POST | `/api-v2/cams` | `CamsController_createCam` | כן | 0 | application/json:CreateCAM | 201 |  |
| 8 | PATCH | `/api-v2/cams/{id}` | `CamsController_update` | כן | 1 | application/json:UpdateCAM | 200 |  |

### inspections (8)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/inspections` | `InspectionsController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/inspections/{id}` | `InspectionsController_getById` | כן | 2 |  | 200 |  |
| 3 | POST | `/api-v2/inspections` | `InspectionsController_create` | כן | 0 | application/json:CreateInspection | 201 |  |
| 4 | POST | `/api-v2/inspections/{id}/comments` | `InspectionsController_addComment` | כן | 1 | application/json:CreateInspectionCommentValidation | 201 |  |
| 5 | POST | `/api-v2/inspections/{id}/send-reminder` | `InspectionsController_sendReminder` | כן | 1 |  | 201 |  |
| 6 | PATCH | `/api-v2/inspections/{id}` | `InspectionsController_updateInspection` | כן | 1 | application/json:UpdateInspection | 200 |  |
| 7 | DELETE | `/api-v2/inspections/comments/{id}` | `InspectionsController_deleteInspectionComment` | כן | 1 |  | 200 |  |
| 8 | DELETE | `/api-v2/inspections/{id}` | `InspectionsController_deleteInspection` | כן | 1 |  | 200 |  |

### management-fee (8)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/management_fee` | `ManagementFeeController_getAll` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/management_fee/configuration` | `ManagementFeeController_getAllConfiguration` | כן | 7 |  | 200 |  |
| 3 | GET | `/api-v2/management_fee/configuration/{id}` | `ManagementFeeController_getConfigurationById` | כן | 1 |  | 200 |  |
| 4 | GET | `/api-v2/management_fee/report` | `ManagementFeeController_getManagementFeeReport` | כן | 3 |  | 200 |  |
| 5 | POST | `/api-v2/management_fee` | `ManagementFeeController_create` | כן | 0 | application/json:CreateManagementFeeValidation | 201 |  |
| 6 | POST | `/api-v2/management_fee/configuration` | `ManagementFeeController_createConfiguration` | כן | 0 | application/json:CreateManagementFeeConfigurationValidation | 201 |  |
| 7 | DELETE | `/api-v2/management_fee/configuration/{id}` | `ManagementFeeController_deleteConfigurationById` | כן | 1 |  | 200 |  |
| 8 | DELETE | `/api-v2/management_fee/{id}` | `ManagementFeeController_deleteManagementFeeById` | כן | 1 |  | 200 |  |

### members (8)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/members` | `MemberController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/members/get-payment-methods` | `MemberController_getMemberPaymentMethodsByEmail` | כן | 1 |  | 200 |  |
| 3 | GET | `/api-v2/members/outstanding-payment-report` | `MemberController_getOutstandingPaymentReport` | כן | 3 |  | 200 |  |
| 4 | GET | `/api-v2/members/tenant-autopay-off-report` | `MemberController_getTenantWhoAutopayOff` | כן | 3 |  | 200 |  |
| 5 | GET | `/api-v2/members/tenant-entry-report` | `MemberController_getTenantEntryReport` | כן | 3 |  | 200 |  |
| 6 | GET | `/api-v2/members/tenant-revenues-report` | `MemberController_getTenantRevenues` | כן | 3 |  | 200 |  |
| 7 | POST | `/api-v2/members/create-bulk-members` | `MemberController_createBulkMembers` | כן | 0 | application/json:CreateBulkMembersWithFileValidation | 201 |  |
| 8 | POST | `/api-v2/members/send-email` | `MemberController_create` | כן | 0 | application/json:SendMemberAnEmailMessage | 201 |  |

### leads (7)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/leads` | `LeadsController_getAll` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/leads/broker` | `LeadsController_getAllLeadsByBrokerId` | כן | 0 |  | 200 |  |
| 3 | POST | `/api-v2/leads` | `LeadsController_create` | כן | 0 | application/json:CreateLeadValidation | 201 |  |
| 4 | POST | `/api-v2/leads/convert-lead-to-member/{id}` | `LeadsController_convertLeadToMember` | כן | 1 | application/json:ConvertLeadToMember | 201 |  |
| 5 | POST | `/api-v2/leads/prompt-filling-application` | `LeadsController_prompt` | כן | 0 | application/json:PromptLeadToFillApplicationValidation | 201 |  |
| 6 | PATCH | `/api-v2/leads/{id}` | `LeadsController_update` | כן | 1 | application/json:UpdateLeadValidation | 200 |  |
| 7 | DELETE | `/api-v2/leads/{id}` | `LeadsController_archive` | כן | 1 |  | 200 |  |

### package (7)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/package` | `PackageController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/package/{id}` | `PackageController_getById` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/package` | `PackageController_create` | כן | 0 | application/json:CreatePackage | 201 |  |
| 4 | POST | `/api-v2/package/{id}/reminder` | `PackageController_sendPackageReminder` | כן | 1 |  | 201 |  |
| 5 | PATCH | `/api-v2/package/{id}` | `PackageController_updatePackage` | כן | 1 | application/json:UpdatePackage | 200 |  |
| 6 | PATCH | `/api-v2/package/{id}/pick` | `PackageController_pickPackage` | כן | 1 |  | 200 |  |
| 7 | DELETE | `/api-v2/package/{id}` | `PackageController_removePackage` | כן | 1 |  | 200 |  |

### settings (7)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/settings/approval-config` | `SettingsControllers_getApprovalViewers` | לא | 0 |  | 200 |  |
| 2 | GET | `/api-v2/settings/listings` | `SettingsControllers_getListingSettings` | לא | 0 |  | 200 |  |
| 3 | GET | `/api-v2/settings/version` | `SettingsControllers_getVersion` | לא | 0 |  | 200 |  |
| 4 | PUT | `/api-v2/settings/approval-bills` | `SettingsControllers_updateApprovalBills` | לא | 0 | application/json:UpdateBillApprovalType | 200 |  |
| 5 | PUT | `/api-v2/settings/external` | `SettingsControllers_updateExternalSettings` | לא | 0 | application/json:array<string> | 200 |  |
| 6 | PUT | `/api-v2/settings/update-invoice-reminder-cron/{id}` | `SettingsControllers_updateInvoiceReminderCron` | לא | 1 | application/json:UpdateInvoiceReminderCron | 200 |  |
| 7 | PUT | `/api-v2/settings/{id}` | `SettingsControllers_update` | לא | 1 | application/json:UpdateClientSettings | 200 |  |

### applications (6)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/applications` | `ApplicationController_getAll` | כן | 7 |  | 200 |  |
| 2 | POST | `/api-v2/applications` | `ApplicationController_create` | כן | 0 | application/json:CreateApplicationValidation | 201 |  |
| 3 | POST | `/api-v2/applications/public` | `ApplicationController_publicCreate` | לא | 0 | application/json:PublicCreateApplicationValidation | 201 |  |
| 4 | PATCH | `/api-v2/applications/{id}` | `ApplicationController_update` | כן | 1 | application/json:UpdateApplicationValidation | 200 |  |
| 5 | PATCH | `/api-v2/applications/{id}/approve` | `ApplicationController_approve` | כן | 1 |  | 200 |  |
| 6 | PATCH | `/api-v2/applications/{id}/reject` | `ApplicationController_reject` | כן | 1 | application/json:RejectApplicationValidation | 200 |  |

### chats (6)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/chats` | `ChatController_getChatConversations` | כן | 0 |  | 200 |  |
| 2 | GET | `/api-v2/chats/chat-notification-user-email` | `ChatController_getChatNotificationEmails` | כן | 0 |  | 200 |  |
| 3 | GET | `/api-v2/chats/tenants/{id}` | `ChatController_getConversationByTenantId` | כן | 1 |  | 200 |  |
| 4 | GET | `/api-v2/chats/{id}` | `ChatController_getConversation` | כן | 1 |  | 200 |  |
| 5 | POST | `/api-v2/chats` | `ChatController_sendMessage` | כן | 0 | application/json:CreateChatMessageValidation | 201 |  |
| 6 | POST | `/api-v2/chats/chat-notification-user-email` | `ChatController_storeChatNotificationUserEmails` | כן | 0 | application/json:ChatNotificationUserEmailValidation | 201 |  |

### email-group-conditions (6)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/email-group-conditions` | `EmailGroupConditionController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/email-group-conditions/{id}` | `EmailGroupConditionController_show` | כן | 1 |  | 200 |  |
| 3 | GET | `/api-v2/email-group-conditions/{id}/{selector}` | `EmailGroupConditionController_showEmails` | כן | 2 |  | 200 |  |
| 4 | POST | `/api-v2/email-group-conditions` | `EmailGroupConditionController_create` | כן | 0 |  | 201 |  |
| 5 | PUT | `/api-v2/email-group-conditions` | `EmailGroupConditionController_update` | כן | 0 |  | 200 |  |
| 6 | DELETE | `/api-v2/email-group-conditions/{id}` | `EmailGroupConditionController_remove` | כן | 1 |  | 200 |  |

### payment-batches (6)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/payment-batches` | `PaymentBatchController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/payment-batches/payment-processor` | `PaymentBatchController_getPaymentProcessorBatchById` | כן | 1 |  | 200 |  |
| 3 | GET | `/api-v2/payment-batches/{id}` | `PaymentBatchController_getById` | כן | 2 |  | 200 |  |
| 4 | POST | `/api-v2/payment-batches` | `PaymentBatchController_create` | כן | 0 | application/json:CreatePaymentBatch | 201 |  |
| 5 | POST | `/api-v2/payment-batches/webhook` | `PaymentBatchController_webhook` | כן | 0 | application/json:AutomaticBatchValidation | 201 |  |
| 6 | PUT | `/api-v2/payment-batches/{id}` | `PaymentBatchController_updateAccountingCode` | כן | 1 | application/json:UpdatePaymentBatch | 200 |  |

### payments (6)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/payments` | `PaymentController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/payments/{id}` | `PaymentController_getById` | כן | 2 |  | 200 |  |
| 3 | POST | `/api-v2/payments` | `PaymentController_create` | כן | 0 | application/json:CreateBulkPayment | 201 |  |
| 4 | POST | `/api-v2/payments/chargebacks` | `PaymentController_post` | כן | 0 | application/json:CreateChargeBackValidation | 201 |  |
| 5 | PATCH | `/api-v2/payments/{id}` | `PaymentController_updatePayment` | כן | 1 | application/json:UpdatePayment | 200 |  |
| 6 | DELETE | `/api-v2/payments/{id}` | `PaymentController_deletePayment` | כן | 1 |  | 200 |  |

### time-logs (6)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/time-logs` | `TimeLogsController_get` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/time-logs/time-logs-report` | `TimeLogsController_getOutstandingCamsReport` | כן | 3 |  | 200 |  |
| 3 | GET | `/api-v2/time-logs/{id}` | `TimeLogsController_getById` | כן | 2 |  | 200 |  |
| 4 | POST | `/api-v2/time-logs` | `TimeLogsController_create` | כן | 0 | application/json:CreateTimeLogValidation | 201 |  |
| 5 | PUT | `/api-v2/time-logs/{id}` | `TimeLogsController_update` | כן | 1 | application/json:UpdateTimeLogValidation | 200 |  |
| 6 | DELETE | `/api-v2/time-logs/{id}` | `TimeLogsController_deleteById` | כן | 1 |  | 200 |  |

### checks (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/checks` | `CheckController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/checks/{id}` | `CheckController_getById` | כן | 2 |  | 200 |  |
| 3 | POST | `/api-v2/checks` | `CheckController_create` | כן | 0 | application/json:CreateCheck | 201 |  |
| 4 | PATCH | `/api-v2/checks/{id}` | `CheckController_updateCheck` | כן | 1 | application/json:UpdateCheck | 200 |  |
| 5 | DELETE | `/api-v2/checks/{id}` | `CheckController_deleteCheck` | כן | 1 |  | 200 |  |

### content (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/content` | `ContentController_get` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/content/ticket-analytics-report` | `ContentController_getTicketAnalyticsReport` | כן | 3 |  | 200 |  |
| 3 | GET | `/api-v2/content/{id}` | `ContentController_getById` | כן | 2 |  | 200 |  |
| 4 | POST | `/api-v2/content` | `ContentController_create` | כן | 0 | application/json:CreateContent | 201 |  |
| 5 | POST | `/api-v2/content/overdue-notification` | `ContentController_overdueNotification` | כן | 0 |  | 201 |  |

### email-groups (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/email-groups` | `EmailGroupController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/email-groups/{id}` | `EmailGroupController_show` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/email-groups` | `EmailGroupController_create` | כן | 0 | application/json:CreateEmailGroup | 201 |  |
| 4 | PUT | `/api-v2/email-groups/{id}` | `EmailGroupController_update` | כן | 1 | application/json:UpdateEmailGroup | 200 |  |
| 5 | DELETE | `/api-v2/email-groups/{id}` | `EmailGroupController_remove` | כן | 1 |  | 200 |  |

### email-senders (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/email-senders` | `EmailSenderController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/email-senders/{id}` | `EmailSenderController_show` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/email-senders` | `EmailSenderController_create` | כן | 0 | application/json:CreateEmailSender | 201 |  |
| 4 | PUT | `/api-v2/email-senders/{id}` | `EmailSenderController_update` | כן | 1 | application/json:UpdateEmailSender | 200 |  |
| 5 | DELETE | `/api-v2/email-senders/{id}` | `EmailSenderController_remove` | כן | 1 |  | 200 |  |

### email-templates (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/email-templates` | `EmailTemplateController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/email-templates/{id}` | `EmailTemplateController_show` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/email-templates` | `EmailTemplateController_create` | כן | 0 | application/json:CreateEmailTemplate | 201 |  |
| 4 | PUT | `/api-v2/email-templates/{id}` | `EmailTemplateController_update` | כן | 1 | application/json:UpdateEmailTemplate | 200 |  |
| 5 | DELETE | `/api-v2/email-templates/{id}` | `EmailTemplateController_remove` | כן | 1 |  | 200 |  |

### expense-types (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/expense-types` | `ExpenseTypeController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/expense-types/{id}` | `ExpenseTypeController_getById` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/expense-types` | `ExpenseTypeController_create` | כן | 0 | application/json:CreateExpenseType | 201 |  |
| 4 | PATCH | `/api-v2/expense-types/{id}` | `ExpenseTypeController_updateExpenseType` | כן | 1 | application/json:UpdateExpenseType | 200 |  |
| 5 | DELETE | `/api-v2/expense-types/{id}` | `ExpenseTypeController_deleteExpenseType` | כן | 1 |  | 200 |  |

### expenses (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/expenses` | `ExpenseController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/expenses/{id}` | `ExpenseController_getById` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/expenses` | `ExpenseController_create` | כן | 0 | application/json:CreateExpense | 201 |  |
| 4 | PATCH | `/api-v2/expenses/{id}` | `ExpenseController_updateExpense` | כן | 1 | application/json:UpdateExpense | 200 |  |
| 5 | DELETE | `/api-v2/expenses/{id}` | `ExpenseController_deleteExpense` | כן | 1 |  | 200 |  |

### external-amenities (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/external-amenities` | `ExternalAmenitiesController_getExternalAmenities` | כן | 0 |  | 200 |  |
| 2 | GET | `/api-v2/external-amenities/icons` | `ExternalAmenitiesController_getExternalAmenityIcons` | כן | 0 |  | 200 |  |
| 3 | POST | `/api-v2/external-amenities` | `ExternalAmenitiesController_createExternalAmenity` | כן | 0 | application/json:CreateExternalAmenityValidation | 201 |  |
| 4 | PUT | `/api-v2/external-amenities/{id}` | `ExternalAmenitiesController_update` | כן | 1 | application/json:UpdateExternalAmenityValidation | 200 |  |
| 5 | DELETE | `/api-v2/external-amenities/{id}` | `ExternalAmenitiesController_removeListingSectionItem` | כן | 1 |  | 200 |  |

### journal-entries (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/journal-entries` | `JournalEntriesController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/journal-entries/{id}` | `JournalEntriesController_getById` | כן | 2 |  | 200 |  |
| 3 | POST | `/api-v2/journal-entries` | `JournalEntriesController_create` | כן | 0 | application/json:CreateJournalEntry | 201 |  |
| 4 | PATCH | `/api-v2/journal-entries/{id}` | `JournalEntriesController_updateJournalEntry` | כן | 1 | application/json:UpdateJournalEntry | 200 |  |
| 5 | DELETE | `/api-v2/journal-entries/{id}` | `JournalEntriesController_deleteJournalEntry` | כן | 1 |  | 200 |  |

### lead-metas (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/lead-metas` | `LeadMetaController_getAll` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/lead-metas/{id}` | `LeadMetaController_getByLeadId` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/lead-metas` | `LeadMetaController_create` | כן | 0 | application/json:CreateLeadMetaValidation | 201 |  |
| 4 | PATCH | `/api-v2/lead-metas/{id}` | `LeadMetaController_update` | כן | 1 | application/json:UpdateLeadMetaValidation | 200 |  |
| 5 | DELETE | `/api-v2/lead-metas/{id}` | `LeadMetaController_destroy` | כן | 1 |  | 200 |  |

### listing-sections (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/listing-sections` | `ListingSectionsControllers_getListingSections` | לא | 0 |  | 200 |  |
| 2 | POST | `/api-v2/listing-sections/add-item` | `ListingSectionsControllers_createListingSectionItem` | לא | 0 | application/json:CreateListingSectionItem | 201 |  |
| 3 | PUT | `/api-v2/listing-sections/item/{id}` | `ListingSectionsControllers_updateListingSectionItem` | לא | 1 | application/json:UpdateListingSectionItem | 200 |  |
| 4 | PUT | `/api-v2/listing-sections/{id}` | `ListingSectionsControllers_updateListingSection` | לא | 1 | application/json:UpdateListingSection | 200 |  |
| 5 | DELETE | `/api-v2/listing-sections/item/{id}` | `ListingSectionsControllers_removeListingSectionItem` | לא | 1 |  | 200 |  |

### locks (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/locks` | `LockController_getAllLocks` | כן | 3 |  | 200 |  |
| 2 | GET | `/api-v2/locks/groups` | `LockController_getAllLockGroups` | כן | 0 |  | 200 |  |
| 3 | POST | `/api-v2/locks/login` | `LockController_login` | כן | 0 | application/json:SigninToLockGateway | 201 |  |
| 4 | POST | `/api-v2/locks/sync-locks` | `LockController_syncUserWithLockGroups` | כן | 0 | application/json:SyncUserWithLockGroups | 201 |  |
| 5 | POST | `/api-v2/locks/unlock-door` | `LockController_unlock` | כן | 0 | application/json:UnlockDoor | 201 |  |

### ocr-integration (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/ocr-integration/invoice_template` | `OCRIntegrationController_getInvoiceTemplates` | כן | 0 |  | 200 |  |
| 2 | GET | `/api-v2/ocr-integration/invoice_template/{id}` | `OCRIntegrationController_getCompletedInvoiceTemplateById` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/ocr-integration` | `OCRIntegrationController_create` | כן | 0 | application/json:OCRIntegrationValidation | 201 |  |
| 4 | POST | `/api-v2/ocr-integration/invoice_template/{id}/consume` | `OCRIntegrationController_consumeInvoiceTemplate` | כן | 1 |  | 201 |  |
| 5 | POST | `/api-v2/ocr-integration/webhook` | `OCRIntegrationController_webhook` | כן | 0 |  | 201 |  |

### outgoing-payments (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/outgoing-payments` | `OutGoingPaymentController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/outgoing-payments/{id}` | `OutGoingPaymentController_getById` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/outgoing-payments` | `OutGoingPaymentController_create` | כן | 0 | application/json:CreateOutgoingPayment | 201 |  |
| 4 | PATCH | `/api-v2/outgoing-payments/{id}` | `OutGoingPaymentController_updateOutGoingPayment` | כן | 1 | application/json:UpdateOutgoingPayment | 200 |  |
| 5 | DELETE | `/api-v2/outgoing-payments/{id}` | `OutGoingPaymentController_deleteOutGoingPayment` | כן | 1 |  | 200 |  |

### owners (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/owners` | `OwnerController_getAll` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/owners/{id}` | `OwnerController_findById` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/owners` | `OwnerController_create` | כן | 0 | application/json:CreateOwnerValidation | 201 |  |
| 4 | PATCH | `/api-v2/owners/{id}` | `OwnerController_update` | כן | 1 | application/json:UpdateOwnerValidation | 200 |  |
| 5 | DELETE | `/api-v2/owners/{id}` | `OwnerController_deleteOwnerById` | כן | 1 |  | 200 |  |

### reconciliations (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/reconciliations` | `ReconciliationController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/reconciliations/{id}` | `ReconciliationController_getById` | כן | 2 |  | 200 |  |
| 3 | POST | `/api-v2/reconciliations` | `ReconciliationController_create` | כן | 0 | application/json:CreateReconciliation | 201 |  |
| 4 | PUT | `/api-v2/reconciliations/{id}` | `ReconciliationController_updateReconciliation` | כן | 1 | application/json:UpdateReconciliation | 200 |  |
| 5 | DELETE | `/api-v2/reconciliations/{id}` | `ReconciliationController_deleteById` | כן | 1 |  | 200 |  |

### ticket-tags (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/ticket-tags` | `TicketTagsController_findAll` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/ticket-tags/get-vendor-referral-tag-assignments` | `TicketTagsController_getAllAssignments` | כן | 7 |  | 200 |  |
| 3 | POST | `/api-v2/ticket-tags/assign-vendor-to-tag` | `TicketTagsController_createReferralTagAssignments` | כן | 0 | application/json:CreateReferralTagAssignment | 201 |  |
| 4 | PATCH | `/api-v2/ticket-tags/update-assign-vendor/{id}` | `TicketTagsController_updateReferralTagAssignment` | כן | 1 | application/json:UpdateReferralTagAssignment | 200 |  |
| 5 | DELETE | `/api-v2/ticket-tags/delete-assign-vendor/{id}` | `TicketTagsController_removeReferralTagAssignment` | כן | 1 |  | 200 |  |

### tours (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/tours` | `ToursController_getAll` | כן | 7 |  | 200 |  |
| 2 | POST | `/api-v2/tours` | `ToursController_create` | כן | 0 | application/json:CreateTour | 201 |  |
| 3 | PATCH | `/api-v2/tours/{id}` | `ToursController_update` | כן | 1 | application/json:UpdateTour | 200 |  |
| 4 | PATCH | `/api-v2/tours/{id}/approve` | `ToursController_approve` | כן | 1 |  | 200 |  |
| 5 | PATCH | `/api-v2/tours/{id}/reject` | `ToursController_reject` | כן | 1 | application/json:DeclineTourValidation | 200 |  |

### transaction-account (5)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/transaction-account` | `TransactionAccountController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/transaction-account/reports/{id}` | `TransactionAccountController_getTransactionAccountReport` | כן | 9 |  | 200 |  |
| 3 | GET | `/api-v2/transaction-account/{id}` | `TransactionAccountController_getById` | כן | 1 |  | 200 |  |
| 4 | POST | `/api-v2/transaction-account` | `TransactionAccountController_create` | כן | 0 | application/json:CreateTransactionAccount | 201 |  |
| 5 | PATCH | `/api-v2/transaction-account/{id}` | `TransactionAccountController_updateTransactionCode` | כן | 1 | application/json:UpdateTransactionAccount | 200 |  |

### accounting-account (4)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/accounting-account` | `AccountingAccountController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/accounting-account/{id}` | `AccountingAccountController_getById` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/accounting-account` | `AccountingAccountController_create` | כן | 0 | application/json:CreateAccountingAccount | 201 |  |
| 4 | PATCH | `/api-v2/accounting-account/{id}` | `AccountingAccountController_updateAccountingCode` | כן | 1 | application/json:UpdateAccountingAccount | 200 |  |

### accounting-code (4)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/accounting-code` | `AccountingCodeController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/accounting-code/{id}` | `AccountingCodeController_getById` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/accounting-code` | `AccountingCodeController_create` | כן | 0 | application/json:CreateAccountingCode | 201 |  |
| 4 | PATCH | `/api-v2/accounting-code/{id}` | `AccountingCodeController_updateAccountingCode` | כן | 1 | application/json:UpdateAccountingCode | 200 |  |

### auth (4)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/auth/me` | `AuthController_me` | כן | 0 |  | 200 |  |
| 2 | POST | `/api-v2/auth/check-token` | `AuthController_checkToken` | לא | 0 | application/json:CheckUserToken | 201 |  |
| 3 | POST | `/api-v2/auth/impersonate` | `AuthController_loginAsMember` | לא | 0 | application/json:LoginAsMemberValidation | 201 |  |
| 4 | POST | `/api-v2/auth/login` | `AuthController_userLogin` | לא | 0 | application/json:LoginUser | 201 |  |

### floor-plan-markers (4)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/floor-plan-markers/locations/{locationId}` | `FloorPlanController_getFloorPlanByLocationId` | כן | 1 |  | 200 |  |
| 2 | GET | `/api-v2/floor-plan-markers/offices/{officeId}` | `FloorPlanController_getFloorPanByOfficeId` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/floor-plan-markers` | `FloorPlanController_create` | כן | 0 | application/json:CreateFloorPlanMarkerValidation | 201 |  |
| 4 | DELETE | `/api-v2/floor-plan-markers/locations/{locationId}` | `FloorPlanController_deleteLocationMarkers` | כן | 1 |  | 200 |  |

### form-templates (4)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/form-templates` | `FormTemplatesController_getAll` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/form-templates/public/{id}` | `FormTemplatesController_publicGetFromTemplate` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/form-templates` | `FormTemplatesController_create` | כן | 0 | application/json:CreateFormTemplateValidation | 201 |  |
| 4 | PATCH | `/api-v2/form-templates/{id}` | `FormTemplatesController_update` | כן | 1 | application/json:UpdateFormTemplateValidation | 200 |  |

### offices-history (4)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/offices-history/by-date/{groupby}` | `OfficesHistoryController_getAllOfficesHistoryByDate` | כן | 3 |  | 200 |  |
| 2 | GET | `/api-v2/offices-history/dashboard-move-in-out` | `OfficesHistoryController_getDashboardMoveInOut` | כן | 3 |  | 200 |  |
| 3 | GET | `/api-v2/offices-history/occupied-offices` | `OfficesHistoryController_getOldOccupiedOffices` | כן | 1 |  | 200 |  |
| 4 | GET | `/api-v2/offices-history/turnover-report` | `OfficesHistoryController_getTurnoverReport` | כן | 3 |  | 200 |  |

### pipeline-stages (4)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/pipeline-stages` | `PipelineStagesController_getAll` | כן | 0 |  | 200 |  |
| 2 | GET | `/api-v2/pipeline-stages/{pipelineId}` | `PipelineStagesController_getByPipelineId` | כן | 1 |  | 200 |  |
| 3 | POST | `/api-v2/pipeline-stages` | `PipelineStagesController_create` | כן | 0 | application/json:CreatePipelineStageValidation | 201 |  |
| 4 | PATCH | `/api-v2/pipeline-stages/{pipelineStageId}` | `PipelineStagesController_update` | כן | 1 | application/json:UpdatePipelineStageValidation | 200 |  |

### scheduledReports (4)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/scheduled-reports` | `ScheduledReportsController_index` | כן | 0 |  | 200 |  |
| 2 | GET | `/api-v2/scheduled-reports/test` | `ScheduledReportsController_test` | כן | 0 |  | 200 |  |
| 3 | POST | `/api-v2/scheduled-reports` | `ScheduledReportsController_create` | כן | 0 | application/json:CreateScheduledReportDtoValidation | 201 |  |
| 4 | PATCH | `/api-v2/scheduled-reports/{id}` | `ScheduledReportsController_update` | כן | 1 | application/json:UpdateScheduledReportDtoValidation | 200 |  |

### vendors (4)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/vendors` | `VendorController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/vendors/{id}` | `VendorController_getById` | כן | 2 |  | 200 |  |
| 3 | POST | `/api-v2/vendors` | `VendorController_create` | כן | 0 | application/json:CreateVendor | 201 |  |
| 4 | PATCH | `/api-v2/vendors/{id}` | `VendorController_updateVendor` | כן | 1 | application/json:UpdateVendor | 200 |  |

### bills (3)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/bills/approval-logs` | `BillsController_getApprovalLogsByInvoiceId` | כן | 1 |  | 200 |  |
| 2 | POST | `/api-v2/bills/approve` | `BillsController_approveBillByReviewer` | כן | 0 | application/json:ApproveBill | 201 |  |
| 3 | PUT | `/api-v2/bills/revoke` | `BillsController_revokeBillByReviewer` | כן | 0 | application/json:ApproveBill | 200 |  |

### companies (3)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/companies` | `CompanyController_getAll` | כן | 7 |  | 200 |  |
| 2 | POST | `/api-v2/companies` | `CompanyController_create` | כן | 0 | application/json:CreateCompanyValidation | 201 |  |
| 3 | PATCH | `/api-v2/companies/{id}` | `CompanyController_update` | כן | 1 | application/json:UpdateCompanyValidation | 200 |  |

### contract-templates (3)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/contract-templates` | `ContractTemplateController_getAll` | כן | 7 |  | 200 |  |
| 2 | POST | `/api-v2/contract-templates` | `ContractTemplateController_create` | כן | 0 | application/json:CreateContractTemplate | 201 |  |
| 3 | DELETE | `/api-v2/contract-templates/{id}` | `ContractTemplateController_destroy` | כן | 1 |  | 200 |  |

### custom-field-values (3)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/custom-field-values` | `CustomFieldValuesController_getAll` | כן | 7 |  | 200 |  |
| 2 | POST | `/api-v2/custom-field-values` | `CustomFieldValuesController_create` | כן | 0 | application/json:array<string> | 201 |  |
| 3 | PATCH | `/api-v2/custom-field-values/{id}` | `CustomFieldValuesController_update` | כן | 1 | application/json:UpdateCustomFieldValueValidation | 200 |  |

### custom-fields (3)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/custom-fields` | `CustomFieldsController_getAll` | כן | 7 |  | 200 |  |
| 2 | POST | `/api-v2/custom-fields` | `CustomFieldsController_create` | כן | 0 | application/json:CreateCustomFieldValidation | 201 |  |
| 3 | PATCH | `/api-v2/custom-fields/{id}` | `CustomFieldsController_update` | כן | 1 | application/json:UpdateCustomFieldValidation | 200 |  |

### form-template-fields (3)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/form-template-fields` | `FormTemplateFieldsController_getAll` | כן | 7 |  | 200 |  |
| 2 | POST | `/api-v2/form-template-fields` | `FormTemplateFieldsController_create` | כן | 0 | application/json:CreateFormTemplateFieldValidation | 201 |  |
| 3 | PATCH | `/api-v2/form-template-fields/{id}` | `FormTemplateFieldsController_update` | כן | 1 | application/json:UpdateFormTemplateFieldValidation | 200 |  |

### lead-sources (3)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/lead-sources` | `LeadSourceController_getAll` | כן | 0 |  | 200 |  |
| 2 | POST | `/api-v2/lead-sources` | `LeadSourceController_create` | כן | 0 | application/json:CreateLeadSourceValidation | 201 |  |
| 3 | PATCH | `/api-v2/lead-sources/{id}` | `LeadSourceController_update` | כן | 1 | application/json:UpdateLeadSourceValidation | 200 |  |

### pipelines (3)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/pipelines` | `PipelineController_getAll` | כן | 6 |  | 200 |  |
| 2 | POST | `/api-v2/pipelines` | `PipelineController_create` | כן | 0 | application/json:CreatePipelineValidation | 201 |  |
| 3 | PATCH | `/api-v2/pipelines/{id}` | `PipelineController_update` | כן | 1 | application/json:UpdatePipelineValidation | 200 |  |

### untagged (3)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | POST | `/api-v2/sms` | `SmsController_sendSmsAlert` | לא | 0 | application/json:SendSmsAlertValidation | 201 |  |
| 2 | POST | `/api-v2/sms/message` | `SmsController_sendSmsMessage` | לא | 0 | application/json:SendSmsMessageValidation | 201 |  |
| 3 | POST | `/api-v2/sms/webhook` | `SmsController_receiveSms` | לא | 0 | application/json:TwilioWebhookResponseDto | 201 |  |

### countries (2)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/countries` | `CountryController_index` | כן | 6 |  | 200 |  |
| 2 | GET | `/api-v2/countries/{id}` | `CountryController_getById` | כן | 1 |  | 200 |  |

### email-logs (2)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/email-logs` | `EmailLogController_getLeadsByEmail` | כן | 3 |  | 200 |  |
| 2 | GET | `/api-v2/email-logs/export` | `EmailLogController_exportEmailLogs` | כן | 2 |  | 200 |  |

### lock-integration (2)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/lock-integration/current` | `LockIntegrationController_getCurrentIntegration` | כן | 0 |  | 200 |  |
| 2 | POST | `/api-v2/lock-integration` | `LockIntegrationController_create` | כן | 0 | application/json:CreateLockIntegration | 201 |  |

### tickets (2)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/tickets` | `TicketsController_findAll` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/tickets/{id}/comments` | `TicketsController_getAllTicketComments` | כן | 1 |  | 200 |  |

### transaction-account-type (2)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/transaction-account-type` | `TransactionAccountTypeController_index` | כן | 7 |  | 200 |  |
| 2 | GET | `/api-v2/transaction-account-type/{id}` | `TransactionAccountTypeController_getById` | כן | 1 |  | 200 |  |

### ui-settings (2)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/ui-settings` | `UiSettingsControllers_getUiSettings` | לא | 0 |  | 200 |  |
| 2 | PUT | `/api-v2/ui-settings` | `UiSettingsControllers_updateExternalSettings` | לא | 0 | application/json:array<string> | 200 |  |

### zones (2)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/zones` | `ZoneController_index` | כן | 6 |  | 200 |  |
| 2 | GET | `/api-v2/zones/{id}` | `ZoneController_getById` | כן | 1 |  | 200 |  |

### actions (1)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/actions` | `ActionsController_index` | כן | 7 |  | 200 |  |

### alert-templates (1)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/alert-templates` | `AlertTemplateController_index` | כן | 7 |  | 200 |  |

### currencies (1)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/currencies` | `CurrencyController_index` | כן | 6 |  | 200 |  |

### email-lists (1)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/email-lists` | `EmailListController_index` | כן | 7 |  | 200 |  |

### email-variables (1)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/email-variables` | `EmailVariablesController_index` | כן | 7 |  | 200 |  |

### failure-logs (1)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/failure-logs` | `FailureLogsController_getAll` | כן | 7 |  | 200 |  |

### file-upload (1)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | POST | `/api-v2/file-upload` | `FileUploadController_create` | כן | 0 |  | 201 |  |

### general-ledger (1)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | GET | `/api-v2/general-ledger` | `GeneralLedgerController_index` | כן | 3 |  | 200 |  |

### health (1)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | POST | `/api-v2/health` | `HealthCheckController_check` | כן | 0 |  | 200, 201 |  |

### notifications (1)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | POST | `/api-v2/notifications/send-email` | `EmailController_sendEmail` | כן | 0 | application/json:SendEmailMessageValidation | 201 |  |

### pdf-integration (1)
| # | Method | Path | operationId | Auth | Params | Request Body | 2xx | Summary |
|---:|---|---|---|---|---:|---|---|---|
| 1 | POST | `/api-v2/pdf/future-invoice` | `PDFIntegrationController_getInvoiceTemplates` | כן | 0 | application/json:GenerateFutureInvoiceValidation | 201 |  |

## 5) פונקציות ללא אימות
| Method | Path | Tag | operationId |
|---|---|---|---|
| POST | `/api-v2/applications/public` | applications | `ApplicationController_publicCreate` |
| POST | `/api-v2/auth/check-token` | auth | `AuthController_checkToken` |
| POST | `/api-v2/auth/impersonate` | auth | `AuthController_loginAsMember` |
| POST | `/api-v2/auth/login` | auth | `AuthController_userLogin` |
| GET | `/api-v2/listing-sections` | listing-sections | `ListingSectionsControllers_getListingSections` |
| POST | `/api-v2/listing-sections/add-item` | listing-sections | `ListingSectionsControllers_createListingSectionItem` |
| PUT | `/api-v2/listing-sections/item/{id}` | listing-sections | `ListingSectionsControllers_updateListingSectionItem` |
| PUT | `/api-v2/listing-sections/{id}` | listing-sections | `ListingSectionsControllers_updateListingSection` |
| DELETE | `/api-v2/listing-sections/item/{id}` | listing-sections | `ListingSectionsControllers_removeListingSectionItem` |
| GET | `/api-v2/settings/approval-config` | settings | `SettingsControllers_getApprovalViewers` |
| GET | `/api-v2/settings/listings` | settings | `SettingsControllers_getListingSettings` |
| GET | `/api-v2/settings/version` | settings | `SettingsControllers_getVersion` |
| PUT | `/api-v2/settings/approval-bills` | settings | `SettingsControllers_updateApprovalBills` |
| PUT | `/api-v2/settings/external` | settings | `SettingsControllers_updateExternalSettings` |
| PUT | `/api-v2/settings/update-invoice-reminder-cron/{id}` | settings | `SettingsControllers_updateInvoiceReminderCron` |
| PUT | `/api-v2/settings/{id}` | settings | `SettingsControllers_update` |
| GET | `/api-v2/ui-settings` | ui-settings | `UiSettingsControllers_getUiSettings` |
| PUT | `/api-v2/ui-settings` | ui-settings | `UiSettingsControllers_updateExternalSettings` |
| POST | `/api-v2/sms` | untagged | `SmsController_sendSmsAlert` |
| POST | `/api-v2/sms/message` | untagged | `SmsController_sendSmsMessage` |
| POST | `/api-v2/sms/webhook` | untagged | `SmsController_receiveSms` |