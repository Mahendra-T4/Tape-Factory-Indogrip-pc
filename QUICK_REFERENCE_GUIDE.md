# IndoGrip Panel UI - Quick Reference Guide

## 🚀 Quick Start: Creating a New Feature Panel

### Step 1: Create Feature Structure
```
lib/features/[feature-name]/
├── data/
│   ├── models/
│   │   ├── [entity]_model.dart
│   │   └── [entity]_api_param.dart
│   └── repositories/
│       └── [feature]_repo.dart
├── domain/
│   └── entities/
│       └── [entity].dart
└── presentation/
    ├── bloc/
    │   ├── [feature]_bloc.dart
    │   ├── [feature]_event.dart
    │   └── [feature]_state.dart
    ├── pages/
    │   ├── add/
    │   │   └── add_[feature].dart
    │   ├── view/
    │   │   ├── view_[feature].dart
    │   │   └── view_[feature]_builder.dart
    │   └── edit/
    │       └── edit_[feature].dart
    └── widgets/
        └── [feature]_specific_widgets.dart
```

### Step 2: Create View Panel
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';

class View[Feature]Panel extends StatefulWidget {
  const View[Feature]Panel({super.key});
  static const String routeName = '/view-[feature]';

  @override
  State<View[Feature]Panel> createState() => _View[Feature]PanelState();
}

class _View[Feature]PanelState extends State<View[Feature]Panel> {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _stateKey,
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: !Responsive.isDesktop(context)
          ? MobileAppBar(context, _stateKey, '[Feature] List')
          : DesktopAppBar(context, _stateKey, '[Feature] List', false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // DataGrid with filter, pagination, actions
          ],
        ),
      ),
    );
  }
}
```

### Step 3: Create Add Panel
```dart
class Add[Feature]Panel extends StatefulWidget {
  const Add[Feature]Panel({super.key});
  static const String routeName = '/add-[feature]';

  @override
  State<Add[Feature]Panel> createState() => _Add[Feature]PanelState();
}

class _Add[Feature]PanelState extends State<Add[Feature]Panel> {
  final GlobalKey<ScaffoldState> _stateKey = GlobalKey<ScaffoldState>();
  late [Feature]Bloc [feature]Bloc;
  
  // Form controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    [feature]Bloc = [Feature]Bloc();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    [feature]Bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _stateKey,
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: !Responsive.isDesktop(context)
          ? MobileAppBar(context, _stateKey, 'Add [Feature]')
          : DesktopAppBar(context, _stateKey, 'Add [Feature]', true),
      body: BlocListener<[Feature]Bloc, [Feature]State>(
        bloc: [feature]Bloc,
        listener: (context, state) {
          if (state is Add[Feature]Success) {
            ToastService.instance.showSuccess(context, 'Added successfully');
            context.go(View[Feature]Panel.routeName);
          } else if (state is Add[Feature]Error) {
            ToastService.instance.showError(context, state.message);
          }
        },
        child: Form(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Name',
                    controller: nameController,
                  ),
                  CustomTextField(
                    label: 'Email',
                    controller: emailController,
                  ),
                  // More fields...
                  CustomButton(
                    label: 'Add',
                    onPressed: () {
                      [feature]Bloc.add(Add[Feature]Event(
                        name: nameController.text,
                        email: emailController.text,
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Step 4: Register Route in routers.dart
```dart
GoRoute(
  path: View[Feature]Panel.routeName,
  name: View[Feature]Panel.routeName,
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: const View[Feature]Panel(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  ),
),
```

### Step 5: Add to Sidebar Navigation
```dart
// In lib/core/utils/sidebar.dart, add to SideMenuWidget
_buildExpandableMenuItem(
  '[Feature]',
  Icons.icon_name,
  [Add[Feature]Panel(), View[Feature]Panel()],
  ['ADD', 'VIEW'],
),
```

---

## 📝 Commonly Used Widgets

### Form Input Widgets

**CustomTextField**
```dart
CustomTextField(
  label: 'Field Name',
  controller: controller,
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
  prefixIcon: Icons.person,
  suffixIcon: Icons.clear,
  obscureText: false,
  keyboardType: TextInputType.text,
)
```

**CustomDropdown**
```dart
CustomDropdown(
  label: 'Select Option',
  items: ['Option 1', 'Option 2', 'Option 3'],
  onChanged: (value) {},
  selectedValue: selectedValue,
)
```

**CustomDatePicker**
```dart
CustomDatePicker(
  label: 'Select Date',
  controller: dateController,
  onDateChanged: (date) {},
)
```

**CustomMultiSelectDropdown**
```dart
CustomMultiSelectDropdown(
  label: 'Select Multiple',
  items: items,
  onChanged: (selectedItems) {},
  selectedItems: selectedItems,
)
```

### Data Display Widgets

**CustomTable (DataGrid)**
```dart
BlocBuilder<[Feature]Bloc, [Feature]State>(
  builder: (context, state) {
    if (state is View[Feature]Loaded) {
      return Syncfusion DataGrid with columns
    }
    return LoadingWidget();
  },
)
```

**DataFiltration**
```dart
DataFiltration(
  onFilter: (filterData) {
    [feature]Bloc.add(Filter[Feature]Event(filter: filterData));
  },
  onReset: () {
    [feature]Bloc.add(Reset[Feature]FilterEvent());
  },
)
```

**PaginationWidget**
```dart
PaginationWidget(
  currentPage: currentPage,
  totalPages: totalPages,
  onPageChanged: (page) {
    [feature]Bloc.add(Paginate[Feature]Event(page: page));
  },
)
```

### Feedback Widgets

**Toast Notifications**
```dart
// Success
ToastService.instance.showSuccess(context, 'Operation successful');

// Error
ToastService.instance.showError(context, 'Error occurred');

// In BlocListener
BlocListener<[Feature]Bloc, [Feature]State>(
  listener: (context, state) {
    if (state is [Feature]Success) {
      ToastService.instance.showSuccess(context, state.message);
    } else if (state is [Feature]Error) {
      ToastService.instance.showError(context, state.message);
    }
  },
  child: Container(),
)
```

**Alert Dialogs**
```dart
// Delete confirmation
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Confirm Delete'),
    content: const Text('Are you sure?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          [feature]Bloc.add(Delete[Feature]Event(id: itemId));
          Navigator.pop(context);
        },
        child: const Text('Delete'),
      ),
    ],
  ),
)
```

---

## 🔄 Common Panel Actions

### Multi-Select Delete
```dart
List<DataGridRow> selectedRows = [];

// In onSelectionChanged callback
selectedRows = selectedRowIndexes.map((index) {
  return dataGridRows[index];
}).toList();

// Delete button
ElevatedButton(
  onPressed: selectedRows.isEmpty
    ? null
    : () {
      List<int> ids = selectedRows.map((row) => row.id).toList();
      [feature]Bloc.add(Delete[Feature]sEvent(ids: ids));
    },
  child: const Text('Delete Selected'),
)
```

### Status Change
```dart
// In GlobalBloc listener
BlocListener<GlobalBloc, GlobalState>(
  listener: (context, state) {
    if (state is GlobalChangeUserStatusSuccessStatus) {
      ToastService.instance.showSuccess(context, 'Status updated');
      _refreshData(); // Refresh the list
    }
  },
)
```

### Bulk Operations
```dart
// Approve multiple records
ElevatedButton(
  onPressed: () {
    globalBloc.add(
      GlobalChangeUserStatusEvent(
        activity: 'approve-[feature]',
        ids: selectedIds,
        status: 1,
      ),
    );
  },
  child: const Text('Approve Selected'),
)
```

---

## 🎨 Styling Guidelines

### Colors (from theme/color_conts.dart)
```dart
// Use theme constants
Color primary = Color(0xFF..);      // Brand color
Color success = Color(0xFF4CAF50);  // Green for success
Color error = Color(0xFFE53935);    // Red for error
Color warning = Color(0xFFFB8C00);  // Orange for warning
Color neutral = Color(0xFF757575);  // Gray for neutral
```

### Spacing Constants
```dart
const double spacingHz = 20.0;    // Horizontal spacing
const double spacingVt = 15.0;    // Vertical spacing
const double betweenSpace = 15.0; // Between elements
const double kHZPadding = 40;     // Horizontal padding
const double kVRTPadding = 20;    // Vertical padding
```

### Container Styling
```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.95),
        Colors.blue.shade50.withOpacity(0.5),
      ],
    ),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.grey.shade200),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: // Content
)
```

---

## 🔧 BLoC Event & State Pattern

### Event Template
```dart
abstract class [Feature]Event extends Equatable {
  const [Feature]Event();

  @override
  List<Object> get props => [];
}

class View[Feature]Event extends [Feature]Event {
  final int page;
  final String? filter;

  const View[Feature]Event({this.page = 1, this.filter});

  @override
  List<Object> get props => [page, filter ?? ''];
}

class Add[Feature]Event extends [Feature]Event {
  final String name;
  final String email;

  const Add[Feature]Event({required this.name, required this.email});

  @override
  List<Object> get props => [name, email];
}
```

### State Template
```dart
abstract class [Feature]State extends Equatable {
  const [Feature]State();

  @override
  List<Object> get props => [];
}

class [Feature]Initial extends [Feature]State {
  const [Feature]Initial();
}

class [Feature]Loading extends [Feature]State {
  const [Feature]Loading();
}

class View[Feature]Loaded extends [Feature]State {
  final List<[Entity]> items;
  final int totalPages;

  const View[Feature]Loaded({required this.items, required this.totalPages});

  @override
  List<Object> get props => [items, totalPages];
}

class Add[Feature]Success extends [Feature]State {
  final String message;

  const Add[Feature]Success({required this.message});

  @override
  List<Object> get props => [message];
}

class [Feature]Error extends [Feature]State {
  final String message;

  const [Feature]Error({required this.message});

  @override
  List<Object> get props => [message];
}
```

### BLoC Implementation
```dart
class [Feature]Bloc extends Bloc<[Feature]Event, [Feature]State> {
  final [Feature]Repository repository;

  [Feature]Bloc({required this.repository}) : super(const [Feature]Initial()) {
    on<View[Feature]Event>(_onView);
    on<Add[Feature]Event>(_onAdd);
    on<Edit[Feature]Event>(_onEdit);
    on<Delete[Feature]Event>(_onDelete);
  }

  Future<void> _onView([Feature]Event event, Emitter<[Feature]State> emit) async {
    emit(const [Feature]Loading());
    try {
      final items = await repository.view[Feature]s(page: event.page);
      emit(View[Feature]Loaded(items: items, totalPages: 5));
    } catch (e) {
      emit([Feature]Error(message: e.toString()));
    }
  }

  Future<void> _onAdd(Add[Feature]Event event, Emitter<[Feature]State> emit) async {
    emit(const [Feature]Loading());
    try {
      await repository.add[Feature](name: event.name, email: event.email);
      emit(const Add[Feature]Success(message: 'Added successfully'));
    } catch (e) {
      emit([Feature]Error(message: e.toString()));
    }
  }
}
```

---

## 📱 Responsive Implementation

### Desktop Layout
```dart
if (Responsive.isDesktop(context)) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: _buildSidebar(),
      ),
      Expanded(
        flex: 3,
        child: _buildMainContent(),
      ),
    ],
  );
}
```

### Tablet Layout
```dart
if (Responsive.isTablet(context)) {
  return Scaffold(
    drawer: _buildSidebar(),
    body: _buildMainContent(),
  );
}
```

### Mobile Layout
```dart
if (Responsive.isMobile(context)) {
  return Scaffold(
    drawer: _buildMobileSidebar(),
    body: SingleChildScrollView(
      child: Column(
        children: [
          _buildMobileHeader(),
          _buildMainContent(),
        ],
      ),
    ),
  );
}
```

---

## 🔌 API Integration

### Using DioService
```dart
// Make API call
final response = await DioService.dioPostApiCall(
  data: FormData.fromMap({
    'activity': 'view-[feature]',
    'page': page,
    'filter': filter,
    'userKey': HiveService.getUserId(),
  }),
);

// Handle response
if (response.statusCode == 200) {
  final data = response.data;
  // Parse response
} else {
  throw Exception('Failed to load data');
}
```

### Error Handling
```dart
try {
  final response = await DioService.dioPostApiCall(data: data)
    .timeout(const Duration(seconds: 5));
  // Handle success
} on TimeoutException {
  emit([Feature]Error(message: 'Request timeout'));
} on DioException catch (e) {
  emit([Feature]Error(message: e.message ?? 'Network error'));
} catch (e) {
  emit([Feature]Error(message: 'Unknown error'));
}
```

---

## 💾 Local Storage (Hive)

### Store Data
```dart
// Save user ID
await HiveService.saveUserId(userId);

// Get user ID
final userId = HiveService.getUserId();

// Save user role
await HiveService.saveRole(role);

// Get user role
final role = HiveService.getRole();
```

---

## 🧪 Testing Common Scenarios

### Test View Panel Loading
```dart
testWidgets('View panel loads data', (WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: View[Feature]Panel()));
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  // Wait for data
  await tester.pumpAndSettle();
  expect(find.byType(DataGrid), findsOneWidget);
});
```

### Test Add Panel Submission
```dart
testWidgets('Add panel submits form', (WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: Add[Feature]Panel()));
  
  await tester.enterText(find.byType(TextField).first, 'Test Name');
  await tester.enterText(find.byType(TextField).last, 'test@email.com');
  
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  
  expect(find.byType(SnackBar), findsOneWidget);
});
```

---

## 📚 Useful Resources

**Key Files Location:**
- `lib/routers.dart` - Route definitions
- `lib/core/responsive/responsive.dart` - Responsive helpers
- `lib/core/utils/shell_scaffold.dart` - Main container
- `lib/core/utils/widgets/` - Reusable widgets
- `lib/core/theme/color_conts.dart` - Color constants

**Common Imports:**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
```

---

**Questions? Check:**
1. Similar feature implementation (e.g., View another feature's panels)
2. Routers.dart for route patterns
3. ShellScaffold for layout structure
4. Widget library in core/utils/widgets/
