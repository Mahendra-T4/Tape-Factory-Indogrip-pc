import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/core/utils/appbar/appbar_widget.dart';
import 'package:indogrip/features/auth/domain/repositories/auth_repo.dart';
import 'package:indogrip/features/auth/presentation/view/login_panel.dart';
import 'package:indogrip/features/profile/profile.dart';

class ItemModel {
  final String title;
  final IconData icon;
  final Widget onPress;

  ItemModel(this.title, this.icon, this.onPress);
}

AppBar DesktopAppBarNotification(
  BuildContext context,
  GlobalKey<ScaffoldState> key,
) {
  CustomPopupMenuController controller = CustomPopupMenuController();

  List<ItemModel> menuItems = [
    ItemModel('Profile', Icons.person_outline_rounded, Profile()),
    // ItemModel('Logout', Icons.logout_rounded, userLogout(context)),
  ];

  return AppBar(
    title: Text(
      'Notifications',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 20,
      ),
    ),
    elevation: 0,
    toolbarHeight: 70,
    // leadingWidth: 70,
    // leading: Padding(
    //   padding: const EdgeInsets.only(left: 16.0),
    //   child: MouseRegion(
    //     cursor: SystemMouseCursors.click,
    //     child: Container(
    //       margin: const EdgeInsets.symmetric(vertical: 8),
    //       decoration: BoxDecoration(
    //         color: Colors.white.withOpacity(0.1),
    //         borderRadius: BorderRadius.circular(12),
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.black.withOpacity(0.1),
    //             blurRadius: 8,
    //             offset: const Offset(0, 2),
    //           ),
    //         ],
    //       ),
    //       child: IconButton(
    //         onPressed: () {
    //           GoRouter.of(context).pop();
    //         },
    //         icon: const Icon(
    //           Icons.arrow_back_ios_new_rounded,
    //           color: Colors.white,
    //           size: 20,
    //         ),
    //         tooltip: 'Back',
    //       ),
    //     ),
    //   ),
    // ),
    actions: [
      // Profile Menu
      CustomPopupMenu(
        menuBuilder: () => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue[50],
                          backgroundImage: AssetImage(
                            Assets.assetsImagesDefaultAvatar,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User",
                              style: TextStyle(
                                // fontFamily: AppFonts.textFieldLabelFont,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Admin",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    child: buildNotificationItem(
                      () {
                        context.goNamed(Profile.routeName);
                        controller.hideMenu();
                      },
                      'Profile',
                      Icons.person_outline_rounded,

                      // '15m ago',
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    child: buildNotificationItem(
                      () {
                        AuthRepository.userLogout(context);
                      },
                      'Logout',
                      Icons.logout_rounded,

                      // '1h ago',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        pressType: PressType.singleClick,
        verticalMargin: -10,
        controller: controller,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(Assets.assetsImagesDefaultAvatar),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Admin",
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        "User",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 8),
    ],
    backgroundColor: Color(0xFF2C3E50),
  );
}

Widget _buildMenuItem(
  ItemModel item,
  CustomPopupMenuController controller,
  BuildContext context,
) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item.onPress),
        );
        controller.hideMenu();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: <Widget>[
            Icon(
              item.icon,
              size: 20,
              color: item.title == 'Logout'
                  ? Colors.red[400]
                  : Colors.grey[700],
            ),
            const SizedBox(width: 12),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 14,
                color: item.title == 'Logout'
                    ? Colors.red[400]
                    : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//! mobile app for notification

AppBar MobileAppBarNotificaton(
  BuildContext context,
  GlobalKey<ScaffoldState> key,
) {
  CustomPopupMenuController controller = CustomPopupMenuController();

  List<ItemModel> menuItems = [
    // ItemModel('Profile', Icons.person_outline_rounded, const Profile()),
    ItemModel('Logout', Icons.logout_rounded, const IndoGripLoginPanel()),
  ];

  return AppBar(
    elevation: 0,
    toolbarHeight: 65,
    leading: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () {
          key.currentState!.openDrawer();
        },
        icon: Image.asset(
          Assets.assetsImagesApps,
          color: Colors.white,
          // scale: 20,
          height: 50,
          width: 50,
        ),
      ),
    ),
    leadingWidth: 60,
    actions: [
      // Profile Menu
      CustomPopupMenu(
        menuBuilder: () => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.blue[50],
                          child: Image.asset("assets/images/img_1.png"),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mahendra",
                              style: TextStyle(
                                // fontFamily: AppFonts.textFieldLabelFont,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Admin",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ...menuItems.map(
                    (item) => _buildMenuItem(item, controller, context),
                  ),
                ],
              ),
            ),
          ),
        ),
        pressType: PressType.singleClick,
        verticalMargin: -10,
        controller: controller,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Image.asset("assets/images/img_1.png"),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Admin",
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Mahendra",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 8),
    ],
    backgroundColor: Color(0xFF2C3E50),
  );
}

// Widget _buildMenuItem(ItemModel item, CustomPopupMenuController controller,
//     BuildContext context) {
//   return Material(
//     color: Colors.transparent,
//     child: InkWell(
//       onTap: () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => item.onPress),
//         );
//         controller.hideMenu();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           children: <Widget>[
//             Icon(
//               item.icon,
//               size: 18,
//               color:
//                   item.title == 'Logout' ? Colors.red[400] : Colors.grey[700],
//             ),
//             const SizedBox(width: 12),
//             Text(
//               item.title,
//               style: TextStyle(
//                 fontSize: 13,
//                 color:
//                     item.title == 'Logout' ? Colors.red[400] : Colors.grey[800],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
