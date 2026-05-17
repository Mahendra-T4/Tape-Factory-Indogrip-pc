# IndoGrip UI Architecture - Key Patterns & Best Practices

## 🎯 Core Architectural Principles

### 1. **Modular Feature Architecture**
- Each feature is self-contained with data, domain, and presentation layers
- Features can be developed independently without affecting others
- Clear separation of concerns (BLoC, Repository, Service)

### 2. **Responsive Design-First**
- Single codebase supports desktop, tablet, and mobile
- Breakpoints: Desktop (≥1000px), Tablet (850-999px), Mobile (<850px)
- Conditional rendering using `Responsive` helper class

### 3. **State Management with BLoC**
- Event-driven state management
- Clear flow: UI Event → BLoC → Repository → Service → API/DB
- Type-safe and testable architecture

### 4. **Layered Architecture**
```
UI Layer (Screens/Panels)
    ↓
BLoC Layer (State Management)
    ↓
Repository Layer (Data Access)
    ↓
Service Layer (Business Logic)
    ↓
External (API, Database)
```

---

## 🏗️ Architectural Patterns

### **Pattern 1: View-Add-Edit-Profile-MissRecord**

Used for: Client, Vendor, Round, Jumbo Roll, Wastage

```dart
Feature
├── View Panel
│   ├── DataGrid
│   ├── Filters
│   ├── Pagination
│   └── Actions (Edit, Delete, Status, View Profile)
├── Add Panel
│   ├── Form with validation
│   └── API submission
├── Edit Panel
│   ├── Pre-filled form
│   └── Update API call
├── Profile Panel
│   ├── Full details display
│   ├── Related records section
│   └── Action buttons
└── Miss Record Panel
    ├── Date filter
    ├── Record listing
    └── Record submission
```

**Files Pattern:**
```
features/[feature]/
├── presentation/
│   ├── pages/
│   │   ├── view/
│   │   │   ├── view_[feature].dart
│   │   │   └── view_[feature]_builder.dart
│   │   ├── add/
│   │   │   └── add_[feature].dart
│   │   ├── edit/
│   │   │   └── edit_[feature].dart
│   │   ├── profile/
│   │   │   └── [feature]_profile.dart
│   │   └── [feature]-miss-record/
│   │       └── [feature]_miss_record_panel.dart
│   └── bloc/
│       ├── [feature]_bloc.dart
│       ├── [feature]_event.dart
│       └── [feature]_state.dart
```

### **Pattern 2: Simple CRUD (View-Add-Edit)**

Used for: Carton, Staff, Core, Loss Meters

```dart
Feature
├── View Panel (DataGrid + Actions)
├── Add Panel (Form)
└── Edit Panel (Pre-filled form)
```

### **Pattern 3: Inventory Management**

Used for: Jumbo Roll, Stretch Film, Tape, Packing Strip

```dart
Feature
├── Inventory View (Stock levels)
├── Add/Receive Items
├── Modify Quantities
├── Missing Item Tracking
└── History/Reports
```

### **Pattern 4: Multi-Step Workflow**

Used for: Chalan, Authentication

```dart
Step 1: Initial Data Entry
    ↓
Step 2: Confirmation/Review
    ↓
Step 3: Submit/Process
    ↓
Step 4: Success Message
```

### **Pattern 5: Master-Detail**

Used for: Client Profile, Vendor Profile, Round Profile

```dart
Master List (View Panel)
    ↓ (Select Item)
Detail View (Profile Panel)
    ↓ (Expand Section)
Related Records (Orders, History, Miss records)
```

---

## 🎨 UI Component Hierarchy

### **High-Level Structure**
```
ShellScaffold (Main Container)
├── DesktopAppBar / MobileAppBar (Top)
├── SideMenuWidget (Left)
└── Feature Panel (Center)
    ├── Header (Title, Filters)
    ├── Content Area
    │   ├── DataGrid (for View panels)
    │   ├── Form (for Add/Edit panels)
    │   ├── Profile Details (for Profile panels)
    │   └── Tables (for Miss record panels)
    └── Action Bar (Buttons, Pagination)
```

### **Component Reusability**
```
Base Widgets (core/utils/widgets/)
├── CustomTextField
├── CustomDropdown
├── CustomDatePicker
├── CustomMultiSelectDropdown
├── CustomButton
├── CustomTable
├── DataFiltration
├── PaginationWidget
├── Toast Notifications
└── Alert Dialogs

↓ Used by ↓

Feature Panels
├── View Panels (Table-based)
├── Add Panels (Form-based)
├── Edit Panels (Form-based)
├── Profile Panels (Detail-based)
└── Special Panels (Dashboard, Machine Calc, etc)
```

---

## 🔄 Data Flow Architecture

### **Read Operation (View Panel)**
```
1. User navigates to View Panel
   ↓
2. initState() triggers BLoC event
   ViewCartonEvent(page: 1)
   ↓
3. CartonBloc processes event
   ↓
4. Repository fetches data from API via DioService
   ↓
5. API returns data
   ↓
6. BLoC emits ViewCartonLoaded state
   ↓
7. BlocBuilder rebuilds with DataGrid
   ↓
8. User sees data with filter, pagination, actions
```

### **Create Operation (Add Panel)**
```
1. User fills form and clicks Add
   ↓
2. Form validation runs
   ↓
3. User clicks Submit → BLoC event
   AddCartonEvent(name: "...", type: "...")
   ↓
4. CartonBloc validates and calls Repository
   ↓
5. Repository calls DioService
   ↓
6. DioService makes POST request to API
   ↓
7. API processes and returns response
   ↓
8. BLoC emits AddCartonSuccess state
   ↓
9. BlocListener shows success toast
   ↓
10. Navigation returns to View Panel
    ↓
11. View panel refreshes list (new item visible)
```

### **Update Operation (Edit Panel)**
```
1. User clicks Edit on item
   ↓
2. Route navigates to Edit Panel with item ID
   ↓
3. Edit Panel fetches item details
   ↓
4. Form pre-fills with existing data
   ↓
5. User modifies fields and submits
   ↓
6. BLoC event: EditCartonEvent(id, updatedData)
   ↓
7. Repository calls API with PUT request
   ↓
8. BLoC emits EditCartonSuccess
   ↓
9. Toast shows success message
   ↓
10. Navigation returns to View Panel (auto-refresh)
```

### **Delete Operation**
```
1. User clicks Delete on item
   ↓
2. Confirmation dialog shown
   ↓
3. User confirms
   ↓
4. BLoC event: DeleteCartonEvent(id)
   ↓
5. Repository calls DELETE API
   ↓
6. BLoC emits DeleteCartonSuccess
   ↓
7. Toast shows success message
   ↓
8. View Panel refreshes list (item removed)
```

---

## 🎯 Navigation Flow

### **Route Structure (GoRouter)**
```dart
GoRouter
├── SplashScreen (/splash)
│   └─→ LoginPanel (/login)
│       └─→ OTPVerification (/otpVerification)
│           └─→ SetPassword (/setPassword)
│               └─→ ShellRoute (Main App)
│
└── ShellRoute (Main Navigation)
    ├── Dashboard (/indo-grip-dashboard)
    ├── Carton Management
    │   ├── ViewCartonPanel (/viewCarton)
    │   ├── AddCartonPanel (/addCarton)
    │   └── EditCartonPanel (/editCarton)
    ├── Client Management
    │   ├── ViewClientPanel (/viewClient)
    │   ├── AddClientPanel (/addClient)
    │   ├── EditClientPanel (/editClient)
    │   ├── ClientProfilePanel (/clientProfile)
    │   └── ClientMissRecordPanel (/clientMissRecord)
    └── [... other features ...]
```

### **Navigation Patterns**

**1. Sidebar Navigation (Desktop)**
```
User clicks sidebar item
    ↓
Sidebar item expands (if expandable)
    ↓
User clicks sub-item (Add/View)
    ↓
GoRouter.go(routeName)
    ↓
Panel loads with animation
```

**2. Hamburger Menu Navigation (Mobile)**
```
User clicks hamburger icon
    ↓
Drawer slides in
    ↓
User clicks item
    ↓
Drawer closes
    ↓
GoRouter.go(routeName)
    ↓
Panel displays
```

**3. In-Panel Navigation**
```
View Panel (DataGrid)
    ↓
User clicks Edit/View Profile
    ↓
Pass item ID via route parameter
    ↓
Edit/Profile panel loads with data
    ↓
User clicks Back
    ↓
Return to View Panel (list refreshes)
```

---

## 🛠️ Development Guidelines

### **Creating a New Feature**

#### Step 1: Plan Feature Structure
```
✓ What data does it display? (Model)
✓ What operations? (CRUD, special actions)
✓ What panels needed? (View, Add, Edit, Profile, etc)
✓ What BLoC states? (Loading, Success, Error)
✓ What API endpoints? (From backend docs)
```

#### Step 2: Follow Naming Conventions
```
Feature Name: [FeatureName]
File names: snake_case (view_carton.dart)
Class names: PascalCase (ViewCartonPanel)
BLoC naming: [Feature]Bloc, [Feature]Event, [Feature]State
Routes: lowercase with slashes (/view-carton)
```

#### Step 3: Use Reusable Widgets
```
DON'T create custom TextField when CustomTextField exists
DON'T create custom buttons when CustomButton exists
DO use core/utils/widgets/ components
DO extend/customize existing widgets if needed
```

#### Step 4: Follow BLoC Pattern
```
✓ Events: One event per user action
✓ States: Separate states for Loading, Success, Error
✓ BLoC: Handle business logic only
✓ Repository: Handle data fetching
✓ Service: Handle API/Database calls
```

#### Step 5: Implement Responsive Design
```dart
// Check screen size
if (Responsive.isDesktop(context)) {
  // Desktop layout: Full width, sidebar visible
} else if (Responsive.isTablet(context)) {
  // Tablet layout: Optimized spacing
} else {
  // Mobile layout: Single column, drawer menu
}
```

#### Step 6: Add Proper Error Handling
```dart
// API calls with timeout and retry
try {
  final response = await DioService.dioPostApiCall(data: data)
    .timeout(const Duration(seconds: 5));
} on TimeoutException {
  emit(FeatureError(message: 'Request timeout'));
} on DioException catch (e) {
  emit(FeatureError(message: e.message ?? 'Network error'));
} catch (e) {
  emit(FeatureError(message: 'Unknown error'));
}
```

#### Step 7: Add User Feedback
```dart
// Show loading indicator
if (state is FeatureLoading) {
  return const Center(child: CircularProgressIndicator());
}

// Show success message
BlocListener<FeatureBloc, FeatureState>(
  listener: (context, state) {
    if (state is FeatureSuccess) {
      ToastService.instance.showSuccess(context, state.message);
    }
  },
)

// Show error message
if (state is FeatureError) {
  ToastService.instance.showError(context, state.message);
}
```

---

## 📊 State Management Best Practices

### **BLoC Event Design**
```dart
✓ One event per user action
✓ Include all required data in event
✓ Use immutable classes (@immutable)
✓ Override props for equality

// Good
class AddCartonEvent extends CartonEvent {
  final String name;
  final String type;
  const AddCartonEvent({required this.name, required this.type});
  @override
  List<Object> get props => [name, type];
}

// Bad
class CartonActionEvent extends CartonEvent {} // Too generic
```

### **BLoC State Design**
```dart
✓ Separate states for each scenario
✓ Include data needed for UI
✓ Include error messages for failures
✓ Use discriminated unions pattern

// Good
abstract class CartonState extends Equatable {}
class CartonInitial extends CartonState {}
class CartonLoading extends CartonState {}
class ViewCartonLoaded extends CartonState {
  final List<Carton> items;
}
class CartonError extends CartonState {
  final String message;
}

// Bad
class CartonState {
  final bool isLoading;
  final List<Carton>? items;
  final String? error;
}
```

### **Avoiding Common Mistakes**

❌ **Don't:**
```dart
// Holding mutable state
List<Carton> items = [];  // Can be modified unexpectedly

// Mixing concerns in BLoC
// Business logic in UI
if (state is CartonSuccess) {
  API call here  // WRONG: Should be in BLoC
}

// Not handling loading state
if (state is CartonSuccess) show data
else show error  // What about loading?

// Forgetting to emit initial state
on<ViewCartonEvent>((event, emit) async {
  // Missing: emit(CartonLoading())
  final data = await repo.fetch();
  emit(CartonSuccess(data));
}
```

✅ **Do:**
```dart
// Immutable state with copyWith
@immutable
class CartonState extends Equatable {
  final List<Carton> items;
  final bool isLoading;
  final String? error;
  
  const CartonState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });
  
  CartonState copyWith({
    List<Carton>? items,
    bool? isLoading,
    String? error,
  }) => CartonState(
    items: items ?? this.items,
    isLoading: isLoading ?? this.isLoading,
    error: error ?? this.error,
  );
}

// Proper BLoC event handling
on<ViewCartonEvent>((event, emit) async {
  emit(CartonLoading());  // Emit loading first
  try {
    final data = await repository.viewCartons(page: event.page);
    emit(CartonSuccess(items: data));
  } catch (e) {
    emit(CartonError(message: e.toString()));
  }
}

// Handle all states in UI
if (state is CartonLoading) {
  return LoadingWidget();
} else if (state is CartonSuccess) {
  return DataGrid(items: state.items);
} else if (state is CartonError) {
  return ErrorWidget(message: state.message);
} else {
  return InitialWidget();
}
```

---

## 🎯 Performance Best Practices

### **1. Optimize DataGrid Rendering**
```dart
// Use virtualization for large datasets
SfDataGrid(
  source: DataSource(),
  columns: [
    GridColumn(columnName: 'id', label: Text('ID')),
    // ... columns
  ],
  // Only render visible rows (automatic in Syncfusion)
)

// Implement pagination instead of loading all at once
PaginationWidget(
  onPageChanged: (page) {
    bloc.add(ViewCartonEvent(page: page));
  },
)
```

### **2. Lazy Load Assets**
```dart
// Load images only when visible
Image.asset(
  Assets.imagePath,
  cacheHeight: 100,
  cacheWidth: 100,
)

// Use optimized SVG icons instead of PNG
SvgPicture.asset(Assets.iconPath)
```

### **3. Debounce Search/Filter**
```dart
Timer? _debounce;

void _onSearchChanged(String value) {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 500), () {
    bloc.add(FilterCartonEvent(query: value));
  });
}
```

### **4. Cache API Responses**
```dart
// HiveService for local caching
class CartonRepository {
  Future<List<Carton>> viewCartons({required int page}) async {
    // Check cache first
    final cached = HiveService.getCartons(page);
    if (cached != null) return cached;
    
    // Fetch from API
    final response = await DioService.dioPostApiCall(...);
    final items = parseResponse(response);
    
    // Cache for next use
    await HiveService.saveCartons(page, items);
    return items;
  }
}
```

### **5. Use Const Widgets**
```dart
// Good: Reuse widget instance
const Widget appBar = DesktopAppBar(...);

// Better: Use const constructors
const Text('Title')
const SizedBox(height: 16)
const Padding(padding: EdgeInsets.all(8))
```

---

## 🔒 Security Best Practices

### **1. Store Sensitive Data Safely**
```dart
// Use HiveService for encrypted storage
await HiveService.saveUserId(userId);    // Safe
await HiveService.saveToken(token);      // Safe

// Never store in local variables or logs
String password = inputValue;  // WRONG
```

### **2. Validate Input**
```dart
// Form validation
TextFormField(
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Required';
    if (value!.length < 3) return 'Too short';
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) return 'Invalid';
    return null;
  },
)
```

### **3. Secure API Communication**
```dart
// Use HTTPS (automatic with DioService)
// Add headers with authentication
final response = await DioService.dioPostApiCall(
  data: FormData.fromMap({
    'userKey': HiveService.getUserId(),  // User identified
    'activity': 'view-carton',            // Action specified
  }),
);
```

### **4. Handle Authentication Properly**
```dart
// Check login status before showing app
if (!HiveService.isUserLoggedIn()) {
  goto(LoginPanel.routeName);
}

// Refresh token if expired
if (response.statusCode == 401) {
  // Token expired
  goto(LoginPanel.routeName);
}
```

---

## 📈 Scalability Patterns

### **1. Feature Module Structure**
```
Each feature is self-contained and can be:
- Developed independently
- Tested independently  
- Disabled/Enabled via feature flags
- Migrated to separate package if needed
```

### **2. Service Abstraction**
```dart
// Services are singletons, not tied to features
DioService         // Shared API service
HiveService        // Shared storage
NotificationService // Shared notifications

// Each feature uses these services
```

### **3. Shared Models**
```
core/models/   // Shared data models
core/dtos/     // API data transfer objects
core/constants/ // App-wide constants
```

### **4. Add New Feature Without Breaking Existing**
```
1. Create new feature folder
2. Implement CRUD panels
3. Add routes to routers.dart
4. Add sidebar item
5. No changes needed in other features
```

---

## 🧪 Testing Strategy

### **Unit Test (BLoC)**
```dart
testWidgets('View carton loads data', (WidgetTester tester) async {
  final mockRepository = MockCartonRepository();
  when(mockRepository.viewCartons(page: 1))
    .thenAnswer((_) async => [mockCarton]);
  
  final bloc = CartonBloc(repository: mockRepository);
  bloc.add(const ViewCartonEvent());
  
  expect(bloc.state, isA<ViewCartonLoaded>());
  expect((bloc.state as ViewCartonLoaded).items.length, 1);
});
```

### **Widget Test (UI)**
```dart
testWidgets('View panel displays DataGrid', (WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: ViewCartonPanel()));
  await tester.pumpAndSettle();
  
  expect(find.byType(SfDataGrid), findsOneWidget);
  expect(find.byType(DataGridRow), findsWidgets);
});
```

### **Integration Test (Features)**
```dart
testWidgets('User can add carton', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  await tester.tap(find.text('Add'));
  await tester.pumpAndSettle();
  
  await tester.enterText(find.byType(TextField), 'New Carton');
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  
  expect(find.byType(SnackBar), findsOneWidget);
});
```

---

## 📋 Checklist for New Features

- [ ] Feature folder structure created
- [ ] BLoC events and states defined
- [ ] Repository and data source implemented
- [ ] View panel with DataGrid
- [ ] Add panel with form
- [ ] Edit panel (if needed)
- [ ] Profile panel (if needed)
- [ ] Miss record panel (if needed)
- [ ] Routes added to routers.dart
- [ ] Sidebar menu item added
- [ ] Error handling for all API calls
- [ ] Loading states for all operations
- [ ] Toast notifications for feedback
- [ ] Responsive design tested
- [ ] Input validation implemented
- [ ] Unit tests written
- [ ] Widget tests written
- [ ] Integration tests written
- [ ] Documentation added
- [ ] Code review completed

---

## 🎓 Key Takeaways

1. **Modular Architecture** - Features are self-contained and independent
2. **Responsive by Default** - Single codebase, multiple screen sizes
3. **Clean Code** - Clear separation of concerns with BLoC pattern
4. **Reusable Components** - Widget library reduces code duplication
5. **Scalable Design** - Easy to add features without affecting existing code
6. **User-Friendly** - Loading states, error messages, success feedback
7. **Performance-Conscious** - Lazy loading, pagination, caching
8. **Security-Focused** - Safe storage, input validation, secure API calls
9. **Well-Tested** - Unit, widget, and integration tests
10. **Maintainable** - Consistent patterns throughout the codebase

---

**For more details, see:**
- `PANEL_UI_STRUCTURE_ANALYSIS.md` - Detailed architecture
- `QUICK_REFERENCE_GUIDE.md` - Code examples and templates
- `FEATURES_INVENTORY.md` - Complete feature list with descriptions
