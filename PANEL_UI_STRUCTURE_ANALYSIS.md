# IndoGrip Project - Panel UI Structure Analysis

## 📋 Overview

The IndoGrip project is a **Flutter desktop application** with a comprehensive panel-based UI system. It uses a **multi-feature modular architecture** with responsive design patterns supporting desktop, tablet, and mobile layouts.

---

## 🏗️ Architecture Layers

### 1. **Core Application Structure**

```
App Entry Point (main.dart)
    ↓
ProviderScope + MaterialApp.router (app.dart)
    ↓
GoRouter Navigation (routers.dart)
    ↓
ShellScaffold (core/utils/shell_scaffold.dart)
    ↓
Feature Panels (Feature-specific screens)
```

**Key Files:**
- `main.dart` - App initialization, BLoC setup, Hive database, window manager
- `app.dart` - Theme configuration, Router setup
- `routers.dart` - GoRouter configuration with all routes

---

## 🎯 ShellScaffold (Core Container)

The **ShellScaffold** is the main persistent container that wraps all feature panels.

**Responsibilities:**
- Desktop/Tablet/Mobile responsive layout
- Left sidebar navigation
- Top AppBar management
- Notification system (queue-based)
- Network connectivity monitoring
- Animation controllers for panel transitions

**Key Features:**
```dart
class ShellScaffold extends ConsumerStatefulWidget {
  // Main layout container
  // Manages sidebar, appbar, and child panels
  // Handles notifications with queue management
  // Fetches notifications every 30 seconds
}
```

**Structure:**
```
ShellScaffold
├── Top AppBar (DesktopAppBar or MobileAppBar)
├── Left Sidebar (Navigation menu)
└── Content Area (Feature Panel)
```

---

## 🛣️ Navigation System (Routers)

**Route Definition Pattern:**

```dart
GoRouter(
  initialLocation: SplashScreen.routeName,
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellScaffold(child: child),
      routes: [
        // All main feature routes here
        GoRoute(path: '/indo-grip-dashboard', ...),
        GoRoute(path: '/carton', ...),
        // ... etc
      ]
    )
  ]
)
```

**Key Routes:**
- `/splash` - Splash screen
- `/login` - Authentication
- `/indo-grip-dashboard` - Main dashboard
- Feature routes (carton, client, vendor, staff, round, jumbo-roll, outsource, etc.)

---

## 📱 Responsive Design System

**Breakpoints:**
```dart
static const double mobileBreakpoint = 850;      // Small screens
static const double tabletBreakpoint = 900;      // Medium screens
static const double desktopBreakpoint = 1000;    // Desktop screens
```

**Spacing Standards:**
```
Horizontal Spacing (Hz): 20.0 - 120.0 px
Vertical Spacing (Vt): 15.0 - 20.0 px
Padding: 40px (horizontal), 20px (vertical)
```

**Responsive Classes:**
```dart
Responsive.isDesktop(context)    // Desktop layout
Responsive.isTablet(context)     // Tablet layout
Responsive.isMobile(context)     // Mobile layout
Responsive.widthPercent(context, percent)
Responsive.heightPercent(context, percent)
```

---

## 📐 Panel UI Structure Types

### **Type 1: View Panel (Data Display)**

**Pattern:**
```
View Panel
├── Desktop AppBar
├── Desktop View
│   ├── Data Filtration Widget
│   ├── Syncfusion DataGrid
│   ├── Pagination Controls
│   └── Action Buttons (Edit, Delete, Status Change)
└── Mobile View (Responsive)
    ├── Mobile AppBar
    ├── Simplified Data Display
    └── Inline Actions
```

**Example: `ViewCartonPanel`**
```dart
class ViewCartonPanel extends StatefulWidget {
  // Desktop View: DataGrid with columns, sorting, selection
  // Mobile View: List or card-based layout
  // Features:
  // - Multi-select with checkbox
  // - Pagination
  // - Data filtering
  // - Bulk actions (Delete, Status Change)
  // - Individual actions (Edit, View, Delete)
}
```

**Components Used:**
- `Syncfusion DataGrid` - Table display
- `CustomTable` - Custom table widget
- `DataFiltration` - Filter panel
- `PaginationWidget` - Pagination controls
- `RefreshButton` - Data refresh

---

### **Type 2: Add/Edit Panel (Form Input)**

**Pattern:**
```
Add/Edit Panel
├── Desktop/Mobile AppBar (with back button)
├── Form Container
│   ├── TextFields
│   │   ├── Standard TextFields
│   │   ├── Dropdown Fields
│   │   ├── Multi-select Dropdowns
│   │   ├── Date Pickers
│   │   └── Optional Fields
│   ├── Validation Messages
│   ├── Animated Transitions
│   └── Submit/Cancel Buttons
└── Toast Notifications (Success/Error)
```

**Example: `AddCartonPanel`**
```dart
class AddCartonPanel extends StatefulWidget {
  // Form with validation
  // API integration for submission
  // Toast feedback on success/error
  // Navigation back on success
}
```

**Custom Form Widgets:**
- `CustomTextField` - Standard input field
- `CustomDropdown` - Dropdown selection
- `CustomMultiSelectDropdown` - Multi-select
- `CustomDatePicker` - Date selection
- `CustomOptionalField` - Optional field wrapper
- `CustomButtonWithEnterKey` - Submit with Enter key support

---

### **Type 3: Profile/Detail Panel**

**Pattern:**
```
Profile Panel
├── Desktop AppBar
├── Profile Header
│   ├── Avatar/Image
│   ├── Entity Name
│   └── Status Badge
├── Details Section
│   ├── Basic Information
│   ├── Contact Information
│   ├── Additional Details
│   └── Calculated Fields
├── Action Buttons
│   ├── Edit Button
│   ├── Delete Button
│   └── Back Button
└── Related Records Section (optional)
```

**Examples:**
- `ClientProfilePanel`
- `VendorProfilePanel`
- `RoundProfilePanel`
- `WastageProfilePanel`

---

### **Type 4: Miss Record Panel**

**Pattern:**
```
Miss Record Panel
├── Header with Date Filters
├── Data Display (Table/List)
├── Record Details Section
├── Miss Reason Input
├── Submit Functionality
└── Success Message
```

**Examples:**
- `ClientMissRecordPanel`
- `VendorMissRecordPanel`
- `RoundMissRecordPanel`
- `TapeMissRecordPanel`
- `JumboRollMissRecordPanel`

---

### **Type 5: Specialized Panels**

**Dashboard Panel:**
```
Dashboard
├── Welcome Header
├── Profit & Loss Analytics (Date range filter)
├── Tape Stock Widget
├── Stretch Stock Widget
├── Predict Calculation Form
└── Additional Analytics
```

**Machine Calculation Panel:**
```
Machine Calculation
├── Meter Input Field
├── Machine 1 Calculation (3 results)
├── Machine 2 Calculation (3 results)
├── Animated Container with gradient
└── Calculate Buttons
```

**Chalan Panel:**
```
Chalan (Invoice/Bill Management)
├── Chalan Creation
├── Carton Scanning Interface
├── Miss Record Handling
├── Bill Format Display
└── Success Submission Message
```

**Outsource Panels:**
```
Outsource In/Out
├── Stretch Film Management
├── Tape In/Out
├── Packing Strip Management
├── Additional Inventory (SILICA API)
├── Miss Record Tracking
└── Sticker Printing
```

---

## 🧩 Core Widget Components

### **AppBar Widgets**

**DesktopAppBar:**
```dart
DesktopAppBar(
  context,           // BuildContext
  stateKey,         // ScaffoldState
  'Panel Title',    // Title
  true              // Can pop back?
)
// Features:
// - Title display
// - Back button (optional)
// - Notification bell icon
// - Profile dropdown menu (Profile, Logout)
// - Custom styling with gradient background
```

**MobileAppBar:**
```dart
MobileAppBar(context, stateKey, 'Title')
// Features:
// - Hamburger menu toggle
// - Title display
// - Back button support
// - Simplified layout for small screens
```

---

### **Sidebar Navigation**

**SideMenuWidget:**
```
Sidebar
├── IndoGrip Logo
├── Dashboard Link
├── Sections:
│   ├── ACCOUNT
│   │   ├── Staff (Add/View)
│   │   ├── Client (Add/View)
│   │   └── Vendor (Add/View)
│   ├── OPERATIONS
│   │   ├── Jumbo Roll (Add/View)
│   │   └── Round (Add/View)
│   ├── GENERAL
│   │   └── Core (Add/View)
│   │   └── Loss Meters
│   └── OUTSOURCING
│       ├── Outside In
│       ├── Stretch Film Out
│       ├── Tape Out
│       └── Packing Strip
└── Expandable Menu Items
    └── SidebarPanelBuilder (with animation)
```

**Expandable Menu Animation:**
- Icon rotation (0° → 180°)
- Height expansion animation
- Opacity fade-in/out
- 300ms animation duration

---

### **Data Display Widgets**

**CustomTable:**
- Syncfusion DataGrid integration
- Column width management
- Row selection
- Sorting capabilities
- Multi-select checkboxes

**DataFiltration:**
- Filter input fields
- Filter button
- Reset filters
- Applied filters display

**PaginationWidget:**
- Previous/Next buttons
- Page number display
- Items per page selector
- Total items counter

**RefreshButton:**
- Refresh data functionality
- Loading indicator

---

### **Form Input Widgets**

**TextFieldLabel:**
```dart
// Wrapper for labeled text input
// Label above field with optional asterisk
// Validation error messages below
```

**CustomTextField:**
```dart
// Standard input with:
// - Validation
// - Custom styling
// - Prefix/Suffix icons
// - Input formatting
```

**CustomDropdown:**
```dart
// Dropdown selection with:
// - Custom styling
// - Search capability (optional)
// - Multi-select variant
// - Default value support
```

**CustomDatePicker:**
```dart
// Date selection with:
// - Date range support
// - Validation
// - Custom formatting
// - Disabled dates (optional)
```

---

### **Notification & Feedback Widgets**

**ToastService:**
```dart
ToastService.instance.showSuccess(context, 'Message')
ToastService.instance.showError(context, 'Error Message')
// Toast notifications with:
// - Success (green)
// - Error (red)
// - Queue management
// - Auto-dismiss
```

**NotificationPopup:**
```dart
// In-app notification popups
// Features:
// - Queue-based display
// - Click handlers
// - Mark as read
// - Auto-dismiss
```

**AlertBox/DeleteAlert:**
```dart
// Confirmation dialogs for critical actions
// Delete confirmation with visual feedback
```

---

## 📊 Feature Panel Organization

### **Directory Structure Pattern**

Each feature follows this pattern:

```
features/[feature-name]/
├── data/
│   ├── datasources/
│   ├── models/
│   │   ├── [entity]_model.dart
│   │   └── [entity]_param_model.dart
│   └── repositories/
├── domain/
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── bloc/
    │   ├── [feature]_bloc.dart
    │   ├── [feature]_event.dart
    │   └── [feature]_state.dart
    ├── pages/
    │   ├── add/
    │   │   └── add_[feature].dart
    │   ├── edit/
    │   │   └── edit_[feature].dart
    │   ├── view/
    │   │   ├── view_[feature].dart
    │   │   └── view_[feature]_builder.dart
    │   ├── [feature]-miss-record/
    │   │   └── [feature]_miss_record_panel.dart
    │   └── profile/
    │       └── [feature]_profile.dart
    └── widgets/
        └── [feature]-specific widgets
```

---

## 🎨 Styling & Theme System

**ThemeData:**
```dart
ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
  ),
)
```

**Colors (from theme/color_conts.dart):**
- Primary colors for CTAs
- Gradient backgrounds
- Status colors (success, error, warning)
- Neutral grays for text

**Animations:**
- Page transitions (FadeTransition, SlideTransition)
- Widget expansion (Menu items)
- Fade-in effects on panel load
- Smooth state transitions

---

## 🔄 State Management (BLoC Pattern)

**Flow:**
```
UI (Panel Widget)
  ↓
BLoC Event (user action)
  ↓
Repository (data layer)
  ↓
API/Database (DioService/HiveService)
  ↓
BLoC State (success/error)
  ↓
UI Update (BlocListener/BlocBuilder)
```

**Example: CartonBloc**
```dart
class CartonBloc extends Bloc<CartonEvent, CartonState> {
  // ViewCartonEvent → ViewCartonState
  // AddCartonEvent → AddCartonState
  // EditCartonEvent → EditCartonState
  // DeleteCartonEvent → DeleteCartonState
}
```

---

## 📱 Responsive Behavior

### **Desktop (≥1000px width)**
- Full-width sidebar (left navigation)
- Main panel in center
- DataGrid with all columns visible
- All features enabled
- DesktopAppBar

### **Tablet (850-999px width)**
- Collapsible sidebar
- Optimized spacing
- Some column hiding in DataGrid
- Tablet-optimized forms
- Hybrid layout

### **Mobile (<850px width)**
- Drawer-based sidebar (hamburger menu)
- Single column layout
- Simplified DataGrid (card view)
- Stacked forms
- MobileAppBar

---

## 🔌 Service Integration

### **Authentication Service**
- Login panel
- OTP verification
- Password reset
- Token management (HiveService)

### **API Service (DioService)**
- Network requests with timeout
- Error handling
- Retry logic
- FormData support

### **Database Service (HiveService)**
- Local storage of user data
- User ID, Role, Panels, Preferences

### **Notification Service**
- Queue-based notification display
- Real-time notification fetching
- Read/Unread status tracking

### **Connectivity Service**
- Internet connection monitoring
- Stream-based status updates
- Fallback UI for offline mode

---

## 🎯 Key Panel Examples

### **1. Carton Management**
- **View Panel**: DataGrid with filter, pagination, multi-select, edit/delete actions
- **Add Panel**: Form with carton details input, validation
- **Edit Panel**: Form pre-filled with existing data
- **Pattern**: Standard CRUD with data table

### **2. Client Management**
- **View Panel**: Client list with miss record tracking
- **Add Panel**: Client registration form
- **Profile Panel**: Client details with related orders
- **Miss Record Panel**: Track client-specific missing items
- **Pattern**: Master-detail with miss records

### **3. Outsource Management**
- **Outside In Panel**: Receiving outsourced items
- **Stretch Film Panel**: Stretch film inventory management
- **Tape Panel**: Tape inventory tracking
- **Packing Strip Panel**: Strip inventory
- **Additional Inventory Panel**: SILICA API integration
- **Pattern**: Multi-tab inventory management

### **4. Chalan (Invoice)**
- **Chalan Creation**: Create bills for orders
- **Carton Scanning**: Scan items into chalan
- **Miss Record**: Record missing items
- **Bill Format**: Print/view bill
- **Success Screen**: Confirmation message
- **Pattern**: Multi-step workflow

---

## 🚀 Performance Features

1. **Lazy Loading**: Routes loaded on-demand
2. **State Caching**: BLoC state preservation
3. **Animation Controller**: Efficient animations
4. **Pagination**: Large datasets split into pages
5. **Notification Queue**: Prevents notification spam
6. **Network Timeout**: 5-second API timeout with retry
7. **Local Storage**: Hive for offline access

---

## 📋 Complete Feature List

| Feature | View | Add | Edit | Profile | Miss Record |
|---------|------|-----|------|---------|-------------|
| Carton | ✅ | ✅ | ✅ | - | - |
| Client | ✅ | ✅ | ✅ | ✅ | ✅ |
| Vendor | ✅ | ✅ | ✅ | ✅ | ✅ |
| Staff | ✅ | ✅ | ✅ | - | - |
| Round | ✅ | ✅ | ✅ | ✅ | ✅ |
| Jumbo Roll | ✅ | ✅ | ✅ | ✅ | ✅ |
| Core | ✅ | ✅ | ✅ | - | - |
| Wastage | ✅ | ✅ | ✅ | ✅ | - |
| Tape (Outsource) | ✅ | - | - | - | ✅ |
| Stretch Film (Outsource) | ✅ | - | - | - | ✅ |
| Packing Strip | ✅ | ✅ | - | - | - |
| Additional Inventory | ✅ | ✅ | - | - | - |
| Chalan | ✅ | ✅ | - | - | - |
| Machine Calculation | - | - | - | - | - |
| Dashboard | ✅ | - | - | - | - |

---

## 🔐 Role-Based Access Control

**Integrated with:**
- `HiveService.getRole()` - Current user role
- `HiveService.getPanels()` - Allowed panels for user
- Panel visibility based on user role

**Implementation:**
- Sidebar items conditionally rendered based on role
- Route guards prevent unauthorized access
- API calls include user role validation

---

## 📝 Common Patterns

### **CRUD Panel Pattern**
```
View (Table) → Select Item
    ↓
[Edit Button] → Edit Form → Save → Refresh View
    ↓
[Delete Button] → Confirm → API Call → Refresh View
    ↓
[Add Button] → Add Form → Save → Refresh View
```

### **Multi-Tab Feature Pattern**
```
Feature Sidebar Item (Expandable)
├── Sub-item 1 (View)
├── Sub-item 2 (Add/In)
├── Sub-item 3 (Out)
└── Sub-item 4 (Records)
```

### **Master-Detail Pattern**
```
Master List (View Panel)
    ↓ (Select Item)
Detail Panel (Profile)
    ↓ (Expand Section)
Related Records (Miss Record Panel)
```

---

## 🎯 Summary

The **IndoGrip Panel UI Structure** is built on:

1. **Modular Architecture**: Independent features in clean folders
2. **Responsive Design**: Works on desktop, tablet, mobile
3. **Component-Based**: Reusable widgets throughout
4. **State Management**: BLoC pattern for state handling
5. **Service Layer**: Centralized API, Database, Notification services
6. **Navigation**: GoRouter for type-safe routing
7. **Consistency**: Standardized panel types (View, Add, Edit, Profile, Miss Record)
8. **Performance**: Lazy loading, pagination, caching
9. **UX**: Smooth animations, toast feedback, queue notifications
10. **Role-Based**: Permission-aware UI rendering

This architecture allows **scalability, maintainability, and consistent user experience** across all features.
