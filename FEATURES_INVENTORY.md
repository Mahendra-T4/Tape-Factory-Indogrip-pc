# IndoGrip Features - Complete Panel Inventory

## 📋 Feature Overview Matrix

| Feature | Location | View Panel | Add Panel | Edit Panel | Profile Panel | Miss Record | Status |
|---------|----------|:----------:|:---------:|:----------:|:-------------:|:-----------:|:------:|
| **Carton** | `features/carton/` | ✅ | ✅ | ✅ | ❌ | ❌ | Active |
| **Client** | `features/client/` | ✅ | ✅ | ✅ | ✅ | ✅ | Active |
| **Vendor** | `features/vendor/` | ✅ | ✅ | ✅ | ✅ | ✅ | Active |
| **Staff** | `features/staff/` | ✅ | ✅ | ✅ | ❌ | ❌ | Active |
| **Round** | `features/round/` | ✅ | ✅ | ✅ | ✅ | ✅ | Active |
| **Jumbo Roll** | `features/jumbo roll/` | ✅ | ✅ | ✅ | ✅ | ✅ | Active |
| **Core** | `features/core/` | ✅ | ✅ | ✅ | ❌ | ❌ | Active |
| **Loss Meters** | `features/loss meters/` | ✅ | ✅ | ❌ | ❌ | ❌ | Active |
| **Wastage** | `features/wastage/` | ✅ | ✅ | ✅ | ✅ | ❌ | Active |
| **Dashboard** | `features/dashboard/` | ✅ | ❌ | ❌ | ❌ | ❌ | Active |
| **Machine Calc** | `features/machine/` | ✅ | ❌ | ❌ | ❌ | ❌ | Active |

---

## 🏢 Master Data Features

### **1. Carton Management** `features/carton/`

**Purpose:** Manage carton types and inventory

**Panels:**
- **ViewCartonPanel** - Display all cartons with filtering & pagination
  - Columns: ID, Name, Type, Quantity, Status, Actions
  - Features: Multi-select, Bulk actions, Filter by status
  - Location: `features/carton/presentation/pages/view/view_carton.dart`

- **AddCartonPanel** - Create new carton
  - Fields: Carton name, Type, Description, Quantity
  - Validation: Required fields, Unique name
  - Location: `features/carton/presentation/pages/add/add_carton.dart`

- **EditCartonPanel** - Modify existing carton
  - Pre-filled form with existing data
  - Location: `features/carton/presentation/pages/edit/edit_carton.dart`

**BLoC:** `CartonBloc`
**Route:** `/viewCarton`

---

### **2. Client Management** `features/client/`

**Purpose:** Manage client/customer relationships

**Panels:**
- **ViewClientPanel** - Client list with advanced filtering
  - Columns: ID, Client Name, Contact Person, Phone, Email, City, Status
  - Features: Search, Filter by status, Multi-select delete/approve
  - Location: `features/client/presentation/pages/view/view_client.dart`

- **AddClientPanel** - Register new client
  - Fields: Company name, Contact person, Email, Phone, Address, City, GST
  - Location: `features/client/presentation/pages/add/add_client.dart`

- **EditClientPanel** - Update client details
  - Location: `features/client/presentation/pages/edit/edit_client.dart`

- **ClientProfilePanel** - View full client details
  - Sections: Basic info, Contact info, GST, Address
  - Related data: Orders, Transactions, Miss records
  - Location: `features/client/presentation/pages/profile/client_profile.dart`

- **ClientMissRecordPanel** - Track missing items per client
  - Date range filter
  - Record details: Item, Quantity, Reason
  - Location: `features/client/presentation/pages/client-miss-record/client_miss_record_panel.dart`

**BLoC:** `ClientBloc`
**Routes:** `/viewClient`, `/addClient`, `/clientProfile`

---

### **3. Vendor Management** `features/vendor/`

**Purpose:** Manage vendor/supplier relationships

**Panels:**
- **ViewVendorPanel** - Vendor list
  - Columns: ID, Vendor name, Contact, Phone, Email, Rating
  - Similar structure to Client panel
  - Location: `features/vendor/presentation/pages/view/view_vendor.dart`

- **AddVendorPanel** - Register new vendor
  - Fields: Vendor name, Contact person, Email, Phone, Category, Terms
  - Location: `features/vendor/presentation/pages/add/add_vendor.dart`

- **EditVendorPanel** - Update vendor
  - Location: `features/vendor/presentation/pages/edit/edit_vendor.dart`

- **VendorProfilePanel** - Full vendor details
  - Related: Supplies, Payments, Ratings
  - Location: `features/vendor/presentation/pages/profile/vendor_profile.dart`

- **VendorMissRecordPanel** - Track vendor-specific missing items
  - Location: `features/vendor/presentation/pages/vendor-miss-record/vendor_miss_record_panel.dart`

**BLoC:** `VendorBloc`
**Routes:** `/viewVendor`, `/addVendor`, `/vendorProfile`

---

### **4. Staff Management** `features/staff/`

**Purpose:** Manage employee records

**Panels:**
- **ViewStaffPanel** - Employee list
  - Columns: ID, Name, Department, Position, Email, Phone, Status
  - Location: `features/staff/presentation/pages/view/view_staff.dart`

- **AddStaffPanel** - Register new employee
  - Fields: Name, Email, Phone, Department, Position, Salary, Joining date
  - Location: `features/staff/presentation/pages/add/add_statff.dart` (note: typo in file name)

- **EditStaffPanel** - Update employee details
  - Location: `features/staff/presentation/pages/edit/edit_add_staff_page.dart`

**BLoC:** `StaffBloc`
**Routes:** `/viewStaff`, `/addStaff`

---

## 🔄 Operational Features

### **5. Round Management** `features/round/`

**Purpose:** Manage production rounds/batches

**Panels:**
- **ViewRoundPanel** - List of production rounds
  - Columns: Round ID, Date, Shift, Status, Items count
  - Location: `features/round/presentation/pages/view/view_round.dart`

- **AddRoundPanel** - Create new production round
  - Fields: Round name, Date, Shift, Starting inventory, Notes
  - Location: `features/round/presentation/pages/add/add_round.dart`

- **EditRoundPanel** - Modify round details
  - Location: `features/round/presentation/pages/edit/edit_round.dart`

- **RoundProfilePanel** - Full round details & analytics
  - Summary: Total items, Status, Timeline
  - Details: Items processed, Waste recorded
  - Location: `features/round/presentation/pages/profile/round_profile.dart`

- **RoundMissRecordPanel** - Track missing items during round
  - Records: What was missing, Quantity, Reason
  - Location: `features/round/presentation/pages/round-miss-record/round_miss_record_panel.dart`

**BLoC:** `RoundBloc`
**Routes:** `/viewRound`, `/addRound`, `/roundProfile`

---

### **6. Jumbo Roll Management** `features/jumbo roll/`

**Purpose:** Manage jumbo roll inventory

**Panels:**
- **ViewJumboRollPanel** - Jumbo roll inventory
  - Columns: Roll ID, Supplier, Width, Length, Weight, Status
  - File upload support
  - Location: `features/jumbo roll/presentation/pages/view/view_jumbo_roll.dart`

- **AddJumboRollPanel** - Add new jumbo roll
  - Fields: Supplier, Width, Length, Weight, Grade, Cost, File upload
  - Location: `features/jumbo roll/presentation/pages/add/add_jumbo_roll.dart`

- **EditJumboRollPanel** - Update roll details
  - Location: `features/jumbo roll/presentation/pages/edit/edit_jump_roll.dart`

- **JumboRollProfilePanel** - Full roll specifications
  - Details: Dimensions, Weight, Grade, Current stock
  - Usage history
  - Location: Related to view panel

- **JumboRollMissRecordPanel** - Track wastage/missing jumbo rolls
  - Records: Date, Quantity, Reason, Cost impact
  - Location: `features/jumbo roll/presentation/pages/jumbo-roll-miss-record/jumbo_roll_miss_record_panel.dart`

**BLoC:** `JumboRollBloc`
**Routes:** `/viewJumboRoll`, `/addJumboRoll`

---

### **7. Core Management** `features/core/`

**Purpose:** Manage cardboard cores/tubes

**Panels:**
- **ViewCorePanel** - Core inventory
  - Location: `features/core/presentation/pages/view/view_core.dart`

- **AddCorePanel** - Register new core
  - Fields: Core type, Diameter, Length, Material, Stock quantity
  - Location: `features/core/presentation/pages/add/add_core.dart`

- **EditCorePanel** - Update core specifications
  - Location: `features/core/presentation/pages/edit/edit_core.dart`

**BLoC:** `CoreBloc` (if applicable)
**Routes:** `/viewCore`, `/addCore`

---

### **8. Loss Meters Management** `features/loss meters/`

**Purpose:** Track meter loss in production

**Panels:**
- **ViewLossMeterPanel** - Loss records by date/shift
  - Columns: Date, Shift, Meters lost, Amount lost, Notes
  - Location: `features/loss meters/pages/view/view_loss_meter.dart`

- **AddLossMeterPanel** - Record meter loss
  - Fields: Date, Shift, Meter count, Reason, Cost
  - Location: `features/loss meters/pages/add/add_lossmeter.dart`

**Routes:** `/viewLossMeter`, `/addLossMeter`

---

### **9. Wastage Management** `features/wastage/`

**Purpose:** Manage and track wastage/scrap

**Panels:**
- **ViewWastagePanel** - Wastage records
  - Columns: Date, Type, Quantity, Cost, Category, Status
  - Location: `features/wastage/presentation/pages/view/view_wastage.dart`

- **AddWastagePanel** - Record new wastage
  - Fields: Date, Type, Quantity, Unit cost, Category, Reason
  - Location: `features/wastage/presentation/pages/add/add_wastage.dart`

- **EditWastagePanel** - Modify wastage record
  - Location: `features/wastage/presentation/pages/edit/edit_wastage.dart`

- **WastageProfilePanel** - Detailed wastage analysis
  - Summary: Total wastage cost, Category breakdown
  - Timeline: Historical data, Trends
  - Location: `features/wastage/presentation/pages/profile/wastage_profile.dart`

**BLoC:** `WastageBloc`
**Routes:** `/viewWastage`, `/addWastage`, `/wastageProfile`

---

## 📦 Outsourcing Features

### **10. Outsource In** `features/outsource/outside-in/`

**Purpose:** Track items received from outsource suppliers

**Panels:**
- **OutsourceInPanel** - Receive outsource items
  - Scan items, Record quantities, Verify quality
  - Location: `features/outsource/presentation/outside-in/pages/outsource_in.dart`

- **EditOutsourceInPanel** - Modify received items
  - Location: `features/outsource/presentation/outside-in/edit/edit_in.dart`

**Routes:** `/outsourceIn`

---

### **11. Tape Outsourcing** `features/outsource/outsource-out/panels/tap/`

**Purpose:** Track tape inventory sent for processing

**Panels:**
- **TapPanelPanel** - Tape outsource management
  - Location: `features/outsource/presentation/outsource-out/panels/tap/page/tap_panel.dart`

- **TapeStickerPanel** - Print labels/stickers for tape
  - Location: `features/outsource/presentation/outsource-out/panels/tap/page/tape_sticker.dart`

- **TapeMissRecordPanel** - Track missing tape items
  - Location: `features/tape/presentation/pages/tape-miss-record/tape_miss_record_panel.dart`

**Routes:** `/tapPanel`, `/tapSticker`

---

### **12. Stretch Film Outsourcing** `features/outsource/outsource-out/panels/stretch-film/`

**Purpose:** Track stretch film inventory

**Panels:**
- **StretchFilmPanel** - Stretch film inventory
  - Location: `features/outsource/presentation/outsource-out/panels/strach%20film/pages/stratch_film.dart`

- **PrintStretchStickerPanel** - Print stretch film labels
  - Location: `features/outsource/presentation/outsource-out/panels/strach%20film/pages/print_stretch_sticker.dart`

- **StretchFilmMissRecordPanel** - Track missing stretch film
  - Location: `features/stretch-film-miss-record/presentation/stretch_film_miss_record_panel.dart`

**Routes:** `/stretchFilm`, `/printStretchSticker`

---

### **13. Packing Strip Management** `features/outsource/packing-strip/`

**Purpose:** Manage packing strip inventory

**Panels:**
- **AddPackingStripPanel** - Record new packing strips
  - Location: `features/outsource/presentation/packing-strip/presentation/page/add/add_packing_strip.dart`

- **ViewPackingStripPanel** - View all packing strips
  - Location: `features/outsource/presentation/packing-strip/presentation/page/table/view_packing_strip_record_table.dart`

**Routes:** `/addPackingStrip`, `/viewPackingStrip`

---

### **14. Additional Inventory (SILICA API)** `features/outsource/additional-inventory/`

**Purpose:** Manage SILICA integration & additional inventory items

**Panels:**
- **AddAdditionalInvPanel** - Record new inventory items
  - SILICA API integration
  - Location: `features/outsource/presentation/additional-inventory/presenation/page/add/add_additional_inv.dart`

- **ViewSilicaRecordsPanel** - View SILICA records
  - Location: `features/outsource/presentation/additional-inventory/presenation/page/table/view_silica_records.dart`

**Routes:** `/addAdditionalInv`, `/viewSilicaRecords`

---

## 📊 Special Features

### **15. Dashboard** `features/dashboard/`

**Purpose:** Business analytics and KPI overview

**Panels:**
- **IndoGripDashboard** - Main dashboard home
  - Sections:
    1. Welcome header with user info
    2. Profit & Loss Analytics (date range)
    3. Tape stock widget
    4. Stretch stock widget
    5. Predict calculation form
    6. Additional analytics
  - Features: Real-time data, Interactive charts, Date filters
  - Location: `features/dashboard/presentation/page/deshboard.dart`

**Widgets:**
- `ProfitandLossAnalyticsWidget` - P&L chart with date range
- `TapeStockWidget` - Tape inventory visualization
- `StretchStockWidget` - Stretch film inventory visualization
- `DefaultSettingWidget` - Configuration options

**Route:** `/indo-grip-dashboard`

---

### **16. Machine Calculation** `features/machine/`

**Purpose:** Calculate machine specifications

**Panels:**
- **MachineCalculationPanel** - Meter-to-weight calculator
  - Inputs: Meters of material
  - Calculations:
    - Machine 1: meter * (100/90) * 7.34
    - Machine 2: meter * 1.61
  - Outputs: 3 results per machine (different scenarios)
  - Features: Animated container, Gradient background
  - Location: `features/machine/machine_calculation.dart`

**Route:** `/machine-calculation`

---

### **17. Chalan (Invoice/Bill)** `features/chalan/`

**Purpose:** Create and manage chalans/invoices

**Panels:**
- **ChalanPanel** - Create new chalan
  - Location: `features/chalan/presentation/page/chalan_panel.dart`

- **ScannedCartonPanel** - Scan items into chalan
  - Features: QR/Barcode scanning, Item validation
  - Location: `features/chalan/presentation/page/scanned-carton/scanned_carton.dart`

- **MissRecordPanel** - Record missing items during picking
  - Location: `features/chalan/presentation/page/scanned-carton/miss_record.dart`

- **BillFormatPanel** - View/Print bill
  - Layout: Professional bill format
  - Location: `features/chalan/presentation/page/bill/bill_formate.dart`

- **SubmissionSuccessPanel** - Confirmation message
  - Location: `features/chalan/presentation/page/scanned-carton/submittion_success_msg.dart`

**Routes:** `/chalanPanel`, `/scannedCarton`, `/billFormat`

---

### **18. Printing** `features/print/`

**Purpose:** Print stickers and labels

**Panels:**
- **PrintStickerPanel** - Print product/item stickers
  - Features: Barcode generation, Label layout
  - Location: `features/print/print_sticker.dart`

**Route:** `/printSticker`

---

### **19. Profile** `features/profile/`

**Purpose:** User profile management

**Panels:**
- **Profile** - User account settings
  - Information: Name, Email, Role, Permissions
  - Actions: Edit profile, Change password, Logout
  - Location: `features/profile/profile.dart`

**Route:** `/profile`

---

### **20. Authentication** `features/auth/`

**Purpose:** User login and authorization

**Panels:**
- **LoginPanel** - User authentication
  - Fields: Email/Username, Password
  - Features: Remember me, Forgot password link
  - Location: `features/auth/presentation/view/login_panel.dart`

- **OTPVerification** - Two-factor authentication
  - Input: 6-digit OTP
  - Location: `features/auth/presentation/view/otpverification.dart`

- **ForgotPasswordPanel** - Password recovery
  - Fields: Email, Verification code, New password
  - Location: `features/auth/presentation/view/forgot_password.dart`

- **SetPasswordPanel** - Initial password setup
  - Fields: Password, Confirm password
  - Location: `features/auth/presentation/view/setpassword.dart`

**Routes:** `/login`, `/otpVerification`, `/forgotPassword`, `/setPassword`

---

### **21. Notifications** `features/notifications/`

**Purpose:** Real-time notification system

**Panels:**
- **NotificationPanel** - View notifications
  - Features:
    - Queue-based display (one at a time)
    - Mark as read
    - Click handlers for action
    - Auto-dismiss
  - Location: `features/notifications/view/notification_responsive.dart`

**Features:**
- Polling every 30 seconds from backend
- Queue management to prevent spam
- Notification status tracking

**Route:** `/notifications`

---

### **22. Splash Screen** `features/splash/`

**Purpose:** App initialization screen

**Panels:**
- **SplashScreen** - Loading screen on app start
  - Features: Logo animation, Loading indicator, Auto-navigate
  - Location: `features/splash/splash_screen.dart`

**Route:** `/splash`

---

## 🗂️ File Organization Summary

### Core Application Files
```
lib/
├── main.dart                          # App entry & initialization
├── app.dart                           # MaterialApp & theme setup
├── routers.dart                       # GoRouter configuration
└── Assets/
    └── assets.dart                    # Asset constants
```

### Core Infrastructure
```
lib/core/
├── config/                            # Environment configuration
├── constants/                         # App-wide constants
├── database/                          # Hive storage
│   ├── hive_service.dart
│   └── round_db_hive.dart
├── di/                                # Dependency injection
├── service/                           # Business services
│   ├── api service/dio_service.dart
│   ├── connectivity/
│   └── external_scanner_service.dart
├── theme/color_conts.dart            # Color constants
├── utils/                             # UI utilities
│   ├── appbar/
│   │   ├── desktop_appbar.dart
│   │   └── mobile_appbar.dart
│   ├── shell_scaffold.dart            # Main container
│   ├── sidebar.dart                   # Navigation menu
│   └── widgets/                       # Reusable widgets
│       ├── custom_button.dart
│       ├── custom_textfield.dart
│       ├── custom_table.dart
│       ├── custom_dropdown.dart
│       ├── custom_date_picker.dart
│       ├── pagination_widget.dart
│       ├── toast_service.dart
│       ├── notification_popup.dart
│       └── [...more widgets]
├── responsive/responsive.dart         # Responsive helpers
├── extension/                         # Dart extensions
├── indents/                           # Indentation helpers
└── ragex/                             # Regex patterns
```

### Features (21 Total)
```
lib/features/
├── auth/                  # Authentication
├── dashboard/             # Business analytics
├── carton/                # Carton management
├── client/                # Client management
├── vendor/                # Vendor management
├── staff/                 # Employee management
├── round/                 # Production rounds
├── jumbo roll/            # Jumbo roll inventory
├── core/                  # Core management
├── wastage/               # Wastage tracking
├── loss meters/           # Loss tracking
├── outsource/             # Outsource in/out
│   ├── outside-in/
│   ├── outsource-out/
│   ├── packing-strip/
│   └── additional-inventory/
├── chalan/                # Invoicing
├── tape/                  # Tape specific
├── stretch-film-miss-record/
├── machine/               # Calculations
├── print/                 # Label printing
├── profile/               # User profile
├── notifications/         # Notification system
├── splash/                # Splash screen
├── global/                # Global utilities
└── bloc/                  # Shared blocs
```

---

## 🎯 Common Operations by Feature

### View Panel Operations
1. **List Data** - Display all records in DataGrid
2. **Filter** - Search/filter records
3. **Paginate** - Navigate through pages
4. **Multi-select** - Select multiple records
5. **Bulk Delete** - Delete multiple records
6. **Bulk Status Change** - Change status for multiple records
7. **Edit** - Open edit panel for selected record
8. **Delete** - Delete single record
9. **View Details** - Open profile panel

### Add Panel Operations
1. **Fill Form** - Enter required data
2. **Validate** - Check field validation
3. **Submit** - Send to API
4. **Handle Error** - Show error toast
5. **Navigate Back** - Return to view panel on success

### Edit Panel Operations
1. **Load Data** - Pre-fill form with existing data
2. **Modify Fields** - Update values
3. **Validate** - Check field validation
4. **Submit** - Update record
5. **Refresh List** - Return to view panel

### Profile Panel Operations
1. **Display Details** - Show all record information
2. **Show Related Records** - Display linked data
3. **Edit** - Navigate to edit panel
4. **Delete** - Confirm and delete record
5. **View History** - Show historical data if available

### Miss Record Operations
1. **Filter by Date** - Select date range
2. **View Records** - Display missing items
3. **Add Record** - Record new missing item
4. **Edit Record** - Modify miss record
5. **Submit** - Save to database

---

## 🔐 Role-Based Features

Features are conditionally displayed based on user role:
- Admin: Full access to all panels
- Manager: Operations, Reports
- Staff: Limited operational access
- Client: View own data only

Implemented via:
- `HiveService.getRole()` - Get user role
- `HiveService.getPanels()` - Get allowed panels
- Conditional rendering in sidebar
- Route guards in navigation

---

## 📞 Feature Dependencies

**Key integrations:**
- All features → DioService (API calls)
- All features → HiveService (Local storage)
- Master features → Dashboard (Analytics)
- Outsource features → SILICA API (Inventory sync)
- Chalan → Carton, Client (Data pull)
- All features → Notification service (Updates)

---

## ✅ Feature Checklist

- [x] Carton management (View, Add, Edit)
- [x] Client management (View, Add, Edit, Profile, Miss record)
- [x] Vendor management (View, Add, Edit, Profile, Miss record)
- [x] Staff management (View, Add, Edit)
- [x] Round management (View, Add, Edit, Profile, Miss record)
- [x] Jumbo roll management (View, Add, Edit, Profile, Miss record)
- [x] Core management (View, Add, Edit)
- [x] Wastage management (View, Add, Edit, Profile)
- [x] Loss meter tracking (View, Add)
- [x] Outsource management (In/Out/Strip/Inventory)
- [x] Chalan/Invoice system (Create, Scan, Bill, Submit)
- [x] Dashboard analytics (P&L, Stock, Calculations)
- [x] Machine calculations (Meter-to-weight)
- [x] Label printing (Stickers, Barcodes)
- [x] Notification system (Real-time, Queue-based)
- [x] Authentication (Login, OTP, Password reset)
- [x] User profile management
- [x] Role-based access control

---

**Last Updated:** May 2026
**Total Features:** 22
**Total Panels:** 50+
**Total Routes:** 80+
