import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/features/client/data/model/upload_client_model.dart';
import 'package:indogrip/features/outsource/data/model/stretch_missrecord_model.dart';
import 'package:indogrip/features/outsource/data/model/tap_miss_record_model.dart';
import 'package:indogrip/core/utils/shell_scaffold.dart';
import 'package:indogrip/features/auth/presentation/view/forgot_password.dart';
import 'package:indogrip/features/auth/presentation/view/login_panel.dart';
import 'package:indogrip/features/auth/presentation/view/otpverification.dart';
import 'package:indogrip/features/auth/presentation/view/setpassword.dart';
import 'package:indogrip/features/carton/data/models/add_carton_api_param.dart';
import 'package:indogrip/features/carton/data/models/view_carton_model.dart';
import 'package:indogrip/features/carton/presentation/pages/add/add_carton.dart';
import 'package:indogrip/features/carton/presentation/pages/edit/edit_carton.dart';
import 'package:indogrip/features/carton/presentation/pages/view/view_carton.dart';
import 'package:indogrip/features/chalan/presentation/page/bill/bill_formate.dart';
import 'package:indogrip/features/chalan/presentation/page/chalan_panel.dart';
import 'package:indogrip/features/client/data/model/view_staff_modeld.dart';
import 'package:indogrip/features/client/presentation/pages/add/add_client.dart';
import 'package:indogrip/features/client/presentation/pages/client-miss-record/client_miss_record_panel.dart';
import 'package:indogrip/features/client/presentation/pages/edit/edit_client.dart';
import 'package:indogrip/features/client/presentation/pages/profile/client_profile.dart';
import 'package:indogrip/features/client/presentation/pages/view/view_client.dart';
import 'package:indogrip/features/core/presentation/pages/add/add_core.dart';
import 'package:indogrip/features/core/presentation/pages/edit/edit_core.dart';
import 'package:indogrip/features/core/presentation/pages/view/view_core.dart';
import 'package:indogrip/features/dashboard/presentation/page/deshboard.dart';
import 'package:indogrip/features/global/data/model/jumbo_missrecord_model.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_uploadfile_response_model.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_jumbo_roll_model.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/add/add_jumbo_roll.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/edit/edit_jump_roll.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/jumbo-roll-miss-record/jumbo_roll_miss_record_panel.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/view/view_jumbo_roll.dart';
import 'package:indogrip/features/notifications/view/notification_responsive.dart';
import 'package:indogrip/features/outsource/data/model/upload_tap_miss_record_model.dart';
import 'package:indogrip/features/outsource/data/model/view_stretchfilm_model.dart';
import 'package:indogrip/features/outsource/data/model/view_tap_in_model.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/edit%20-%20stretch/edit_stretch_in.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/edit/edit_in.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/pages/outsource_in.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/packing%20strip/page/packing_strip_panel.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/silica/page/silica_panel.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/strach%20film/pages/print_stretch_sticker.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/strach%20film/pages/stratch_film.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/tap/page/tap_panel.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/tap/page/tape_sticker.dart';
import 'package:indogrip/features/print/print_sticker.dart';
import 'package:indogrip/features/profile/profile.dart';
import 'package:indogrip/features/round/data/models/upload_round_record_model.dart';
import 'package:indogrip/features/round/data/models/view_round_modeld.dart';
import 'package:indogrip/features/round/presentation/pages/add/add_round.dart';
import 'package:indogrip/features/round/presentation/pages/edit/edit_round.dart';
import 'package:indogrip/features/round/presentation/pages/profile/round_profile.dart';
import 'package:indogrip/features/round/presentation/pages/round-miss-record/round_miss_record_panel.dart';
import 'package:indogrip/features/round/presentation/pages/view/view_round.dart';
import 'package:indogrip/features/splash/splash_screen.dart';
import 'package:indogrip/features/staff/data/models/edit_staff_details_param_model.dart';
import 'package:indogrip/features/staff/presentation/pages/add/add_statff.dart';
import 'package:indogrip/features/staff/presentation/pages/edit/edit_add_staff_page.dart';
import 'package:indogrip/features/staff/presentation/pages/view/view_staff.dart';
import 'package:indogrip/features/stretch-film-miss-record/presentation/stretch_film_miss_record_panel.dart';
import 'package:indogrip/features/tape/presentation/pages/tape-miss-record/tape_miss_record_panel.dart';
import 'package:indogrip/features/vendor/data/models/upload_vendor_button.dart';
import 'package:indogrip/features/vendor/data/models/view_vendor_model.dart';
import 'package:indogrip/features/vendor/presentation/pages/add/add_vendor.dart';
import 'package:indogrip/features/vendor/presentation/pages/edit/edit_vendor.dart';
import 'package:indogrip/features/vendor/presentation/pages/profile/vendor_profile.dart';
import 'package:indogrip/features/vendor/presentation/pages/vendor-miss-record/vendor_miss_record_panel.dart';
import 'package:indogrip/features/vendor/presentation/pages/view/view_vendor.dart';
import 'package:indogrip/features/wastage/data/model/edit_wastage_api_param.dart';
import 'package:indogrip/features/wastage/presentation/pages/add/add_wastage.dart';
import 'package:indogrip/features/wastage/presentation/pages/edit/edit_wastage.dart';
import 'package:indogrip/features/wastage/presentation/pages/view/view_wastage.dart';
import 'package:indogrip/features/wastage/presentation/pages/profile/wastage_profile.dart';
import 'package:indogrip/features/wastage/data/model/view_wastage_model.dart';

GoRouter routers = GoRouter(
  initialLocation: SplashScreen.routeName,
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) => ShellScaffold(child: child),
      routes: [
        GoRoute(
          path: IndoGripDashboard.routeName,
          name: IndoGripDashboard.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const IndoGripDashboard(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => IndoGripDashboard(),
        ),

        // //* Notification Screen
        GoRoute(
          path: Notifications.routeName,
          name: Notifications.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const Notifications(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Notifications(),
        ),

        GoRoute(
          path: ClientMissRecordPanel.routeName,
          name: ClientMissRecordPanel.routeName,
          pageBuilder: (context, state) {
            final record = state.extra as UploadClientResponse;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: ClientMissRecordPanel(
                record: record,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Notifications(),
        ),
        GoRoute(
          path: VendorMissRecordPanel.routeName,
          name: VendorMissRecordPanel.routeName,
          pageBuilder: (context, state) {
            final record = state.extra as UploadVendorResponse;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: VendorMissRecordPanel(
                record: record,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Notifications(),
        ),
        GoRoute(
          path: JumboRollMissRecordPanel.routeName,
          name: JumboRollMissRecordPanel.routeName,
          pageBuilder: (context, state) {
            final misRecord = state.extra as JumboUploadFileResponseModel;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: JumboRollMissRecordPanel(
                missRecord: misRecord,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Notifications(),
        ),

        GoRoute(
          path: RoundMissRecordPanel.routeName,
          name: RoundMissRecordPanel.routeName,
          pageBuilder: (context, state) {
            final record = state.extra as UploadRoundRecordModel;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: RoundMissRecordPanel(
                record: record,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Notifications(),
        ),
        GoRoute(
          path: TapeMissRecordPanel.routeName,
          name: TapeMissRecordPanel.routeName,
          pageBuilder: (context, state) {
            final missRecord = state.extra as UploadTapRecordModel;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: TapeMissRecordPanel(
                record: missRecord,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Notifications(),
        ),
        GoRoute(
          path: StretchFilmMissRecordPanel.routeName,
          name: StretchFilmMissRecordPanel.routeName,
          pageBuilder: (context, state) {
            final missRecord = state.extra as StretchMissRecordResponse;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: StretchFilmMissRecordPanel(
                record: missRecord,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Notifications(),
        ),
        GoRoute(
          path: TapPanel.routeName,
          name: TapPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const TapPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Notifications(),
        ),
        GoRoute(
          path: StretchFilmPanel.routeName,
          name: StretchFilmPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const StretchFilmPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Notifications(),
        ),
        GoRoute(
          path: SilicaPanel.routeName,
          name: SilicaPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const SilicaPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Notifications(),
        ),

        GoRoute(
          path: PackingStripPanel.routeName,
          name: PackingStripPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const PackingStripPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Notifications(),
        ),

        //* Staff routes
        GoRoute(
          path: AddStaff.routeName,
          name: AddStaff.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const AddStaff(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const AddStaff(),
        ),
        GoRoute(
          path: ViewStaffPanel.routeName,
          name: ViewStaffPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const ViewStaffPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const ViewStaffPanel(),
        ),
        GoRoute(
          path: ChalanPanel.routeName,
          name: ChalanPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const ChalanPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const ChalanPanel(),
        ),

        GoRoute(
          path: EditStaffDetailsPage.routeName,
          name: EditStaffDetailsPage.routeName,
          pageBuilder: (context, state) {
            final editStaff = state.extra as EditStaffModel;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: EditStaffDetailsPage(
                editStaffModel: editStaff,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) {
          //   final editStaff = state.extra as EditStaffModel;
          //   return EditStaffDetailsPage(editStaffModel: editStaff);
          // },
        ),

        GoRoute(
          path: EditOutSourceIN.routeName,
          name: EditOutSourceIN.routeName,
          pageBuilder: (context, state) {
            final editTap = state.extra as TapRecord;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: EditOutSourceIN(record: editTap), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
        ),

        GoRoute(
          path: EditStretchOutSourceIN.routeName,
          name: EditStretchOutSourceIN.routeName,
          pageBuilder: (context, state) {
            final stretch = state.extra as StretchRecord;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: EditStretchOutSourceIN(
                record: stretch,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
        ),

        GoRoute(
          path: PrintTapeSticker.routeName,
          name: PrintTapeSticker.routeName,
          pageBuilder: (context, state) {
            final rKey = state.extra as String;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: PrintTapeSticker(rKey: rKey), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
        ),

        GoRoute(
          path: BillFormate.routeName,
          name: BillFormate.routeName,
          pageBuilder: (context, state) {
            final rKey = state.extra as String;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: BillFormate(orderKey: rKey), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
        ),

        GoRoute(
          path: PrintStretchFilmSticker.routeName,
          name: PrintStretchFilmSticker.routeName,
          pageBuilder: (context, state) {
            final rKey = state.extra as String;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: PrintStretchFilmSticker(
                rKey: rKey,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
        ),

        //* client routes
        GoRoute(
          path: AddClientPanel.routeName,
          name: AddClientPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const AddClientPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const AddClientPanel(),
        ),
        GoRoute(
          path: ViewClientPanel.routeName,
          name: ViewClientPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const ViewClientPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const ViewClientPanel(),
        ),

        GoRoute(
          path: EditClient.routeName,
          name: EditClient.routeName,
          pageBuilder: (context, state) {
            final editClient = state.extra as EditClientParam;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: EditClient(param: editClient), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimHation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },

          // builder: (context, state) {
          //   final editClient = state.extra as EditClientApiParam;
          //   return EditClient(param: editClient);
          // },
        ),

        //* client profile
        GoRoute(
          path: ClientProfile.routeName,
          name: ClientProfile.routeName,
          pageBuilder: (context, state) {
            final editClient = state.extra as ClientRecord;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: ClientProfile(client: editClient), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },

          // builder: (context, state) {
          //   final editClient = state.extra as EditClientApiParam;
          //   return EditClient(param: editClient);
          // },
        ),

        //* Vendor routes
        GoRoute(
          path: AddVendorPanel.routeName,
          name: AddVendorPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const AddVendorPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => AddVendorPanel(),
        ),

        GoRoute(
          path: ViewVendorPanel.routeName,
          name: ViewVendorPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const ViewVendorPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const ViewVendorPanel(),
        ),

        GoRoute(
          path: OutSourceIN.routeName,
          name: OutSourceIN.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const OutSourceIN(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const ViewVendorPanel(),
        ),

        GoRoute(
          path: EditVendorPanel.routeName,
          name: EditVendorPanel.routeName,
          pageBuilder: (context, state) {
            final editVendor = state.extra as VendorRecord;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: EditVendorPanel(
                param: editVendor,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) {
          //   final editVendor = state.extra as EditVendorApiParam;
          //   return EditVendorPanel(param: editVendor);
          // },
        ),

        //* vendor profile
        GoRoute(
          path: VendorProfile.routeName,
          name: VendorProfile.routeName,
          pageBuilder: (context, state) {
            final vendor = state.extra as VendorRecord;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: VendorProfile(vendor: vendor), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
        ),

        //* Jumbo Roll routes
        GoRoute(
          path: AddJumboRollPanel.routeName,
          name: AddJumboRollPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const AddJumboRollPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => AddJumboRollPanel(),
        ),

        GoRoute(
          path: ViewJumboRollPanel.routeName,
          name: ViewJumboRollPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const ViewJumboRollPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const ViewJumboRollPanel(),
        ),

        GoRoute(
          path: EditJumboRollPanel.routeName,
          name: EditJumboRollPanel.routeName,
          pageBuilder: (context, state) {
            final editJumboRoll = state.extra as JumboRollRecord;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: EditJumboRollPanel(
                jumboRollRecords: editJumboRoll,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) {
          //   final editJumboRoll = state.extra as JumboRollApiParams;
          //   return EditJumboRollPanel(jumboRollRecords: editJumboRoll);
          // },
        ),

        //* Round routes
        GoRoute(
          path: AddRoundPanel.routeName,
          name: AddRoundPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const AddRoundPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => AddRoundPanel(),
        ),

        GoRoute(
          path: ViewRoundPanel.routeName,
          name: ViewRoundPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const ViewRoundPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const ViewRoundPanel(),
        ),

        GoRoute(
          path: EditRoundPanel.routeName,
          name: EditRoundPanel.routeName,
          pageBuilder: (context, state) {
            final editRound = state.extra as RoundRecord;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: EditRoundPanel(record: editRound), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
        ),

        GoRoute(
          path: RoundProfile.routeName,
          name: RoundProfile.routeName,
          pageBuilder: (context, state) {
            final round = state.extra as RoundRecord;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: RoundProfile(round: round), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) {
          //   final editJumboRoll = state.extra as JumboRollApiParams;
          //   return EditJumboRollPanel(jumboRollRecords: editJumboRoll);
          // },
        ),

        GoRoute(
          path: PrintSticker.routeName,
          name: PrintSticker.routeName,
          pageBuilder: (context, state) {
            final rKey = state.extra as String;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: PrintSticker(rKey: rKey), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) {
          //   final editRound = state.extra as AddRoundParam;
          //   return EditRoundPanel(param: editRound);
          // },
        ),

        //* Wastage routes
        GoRoute(
          path: AddWastagePanel.routeName,
          name: AddWastagePanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const AddWastagePanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => AddWastagePanel(),
        ),

        GoRoute(
          path: ViewWastagePanel.routeName,
          name: ViewWastagePanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const ViewWastagePanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const ViewWastagePanel(),
        ),

        GoRoute(
          path: EditWastagePanel.routeName,
          name: EditWastagePanel.routeName,
          pageBuilder: (context, state) {
            final editWastage = state.extra as EditWastageApiParam;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: EditWastagePanel(
                param: editWastage,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) {
          //   final editWastage = state.extra as EditWastageApiParam;
          //   return EditWastagePanel(param: editWastage);
          // },
        ),

        GoRoute(
          path: WastageProfile.routeName,
          name: WastageProfile.routeName,
          pageBuilder: (context, state) {
            final wastage = state.extra as WastageRecord;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: WastageProfile(wastage: wastage), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) {
          //   final editWastage = state.extra as EditWastageApiParam;
          //   return EditWastagePanel(param: editWastage);
          // },
        ),

        //* Carton routes
        GoRoute(
          path: AddCartonPanel.routeName,
          name: AddCartonPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const AddCartonPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => AddCartonPanel(),
        ),

        GoRoute(
          path: ViewCartonPanel.routeName,
          name: ViewCartonPanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const ViewCartonPanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const ViewCartonPanel(),
        ),

        GoRoute(
          path: EditCartonPanel.routeName,
          name: EditCartonPanel.routeName,
          pageBuilder: (context, state) {
            final editCarton = state.extra as ViewCartonRecord;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: EditCartonPanel(
                param: editCarton,
              ), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) {
          //   final editCarton = state.extra as CartonApiParams;
          //   return EditCartonPanel(param: editCarton);
          // },
        ),

        //* Core routes
        GoRoute(
          path: AddCorePanel.routeName,
          name: AddCorePanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const AddCorePanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => AddCorePanel(),
        ),

        GoRoute(
          path: ViewCorePanel.routeName,
          name: ViewCorePanel.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const ViewCorePanel(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => const ViewCorePanel(),
        ),

        GoRoute(
          path: EditCorePanel.routeName,
          name: EditCorePanel.routeName,
          pageBuilder: (context, state) {
            final editCore = state.extra as CartonApiParams;
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: EditCorePanel(param: editCore), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) {
          //   final editCore = state.extra as CartonApiParams;
          //   return EditCorePanel(param: editCore);
          // },
        ),

        //* Profile
        GoRoute(
          path: Profile.routeName,
          name: Profile.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey, // Required for unique page identification
              child: const Profile(), // The screen to display
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Define a fade transition to avoid bouncing
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Animation duration
            );
          },
          // builder: (context, state) => Profile(),
        ),
      ],
    ),

    //* Splash Screen
    GoRoute(
      path: SplashScreen.routeName,
      name: SplashScreen.routeName,

      builder: (context, state) => const SplashScreen(),
    ),

    //! Authentication Routes

    //* login screen
    GoRoute(
      path: IndoGripLoginPanel.routeName,
      name: IndoGripLoginPanel.routeName,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey, // Required for unique page identification
          child: const IndoGripLoginPanel(), // The screen to display
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Define a fade transition to avoid bouncing
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(
            milliseconds: 300,
          ), // Animation duration
        );
      },
      // builder: (context, state) => IndoGripLoginPanel(),
    ),

    GoRoute(
      path: Otpverification.routeName,
      name: Otpverification.routeName,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey, // Required for unique page identification
          child: const Otpverification(), // The screen to display
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Define a fade transition to avoid bouncing
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(
            milliseconds: 300,
          ), // Animation duration
        );
      },
      // builder: (context, state) => Otpverification(),
    ), //* set password Screen

    GoRoute(
      path: SetPassword.routeName,
      name: SetPassword.routeName,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey, // Required for unique page identification
          child: const SetPassword(), // The screen to display
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Define a fade transition to avoid bouncing
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(
            milliseconds: 300,
          ), // Animation duration
        );
      },
      // builder: (context, state) => SetPassword(),
    ),

    GoRoute(
      path: ForgotPasswordPanel.routeName,
      name: ForgotPasswordPanel.routeName,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey, // Required for unique page identification
          child: const ForgotPasswordPanel(), // The screen to display
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Define a fade transition to avoid bouncing
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(
            milliseconds: 300,
          ), // Animation duration
        );
      },
      // builder: (context, state) => SetPassword(),
    ),
  ],
);
