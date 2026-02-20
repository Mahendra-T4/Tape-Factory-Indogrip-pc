import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/utils/appbar/appbar_widget.dart';
import 'package:indogrip/features/auth/domain/repositories/auth_repo.dart';
import 'package:indogrip/features/auth/presentation/view/login_panel.dart';
import 'package:indogrip/features/notifications/view/notification_responsive.dart';
import 'package:indogrip/features/profile/profile.dart';

class ItemModel {
  final String title;
  final IconData icon;
  final Widget onPress;

  ItemModel(this.title, this.icon, this.onPress);
}

AppBar DesktopAppBar(
  BuildContext context,
  GlobalKey<ScaffoldState> key,
  String? title,
  bool isCanPop,
) {
  CustomPopupMenuController controller = CustomPopupMenuController();

  List<ItemModel> menuItems = [
    ItemModel('Profile', Icons.person_outline_rounded, Profile()),
    ItemModel('Logout', Icons.logout_rounded, const IndoGripLoginPanel()),
  ];

  return AppBar(
    title: Text(
      title.toString(),
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 20,
      ),
    ),
    elevation: 0,
    toolbarHeight: 70,
    leadingWidth: 70,
    leading: isCanPop
        ? Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  tooltip: 'Back',
                ),
              ),
            ),
          )
        : null,
    actions: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            _buildActionButton(
              onPressed: () {
                GoRouter.of(context).goNamed(Notifications.routeName);
              },
              icon: Icons.notifications_none_rounded,
              tooltip: 'Notifications',
            ),
            const SizedBox(width: 12),
            // Profile Menu
            CustomPopupMenu(
              menuBuilder: () => Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Material(
                    color: Colors.transparent,
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF2C3E50),
                                  const Color(0xFF3498DB),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(
                                      Assets.assetsImagesDefaultAvatar,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${HiveService.getFName()} ${HiveService.getLName()}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        // fontFamily: AppFonts.textFieldLabelFont,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        "Admin",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
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
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              pressType: PressType.singleClick,
              verticalMargin: 10,
              controller: controller,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF3498DB),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3498DB).withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(
                            Assets.assetsImagesDefaultAvatar,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3498DB).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Admin",
                              style: TextStyle(
                                color: Colors.blue[300],
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${HiveService.getFName()} ${HiveService.getLName()}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.expand_more_rounded,
                                color: Colors.white.withOpacity(0.8),
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
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    ],
    backgroundColor: const Color(0xFF2C3E50),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2C3E50),
            const Color(0xFF3498DB).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
  );
}

Widget _buildActionButton({
  required VoidCallback onPressed,
  required IconData icon,
  required String tooltip,
}) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 24),
        tooltip: tooltip,
        padding: const EdgeInsets.all(12),
      ),
    ),
  );
}

Widget _buildMenuItem(
  ItemModel item,
  CustomPopupMenuController controller,
  BuildContext context,
) {
  return InkWell(
    onTap: () {
      controller.hideMenu();
      if (item.title == 'Logout') {
        userLogout(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item.onPress),
        );
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Icon(
            item.icon,
            size: 20,
            color: item.title == 'Logout'
                ? Colors.red[400]
                : const Color(0xFF2C3E50),
          ),
          const SizedBox(width: 12),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 14,
              color: item.title == 'Logout'
                  ? Colors.red[400]
                  : const Color(0xFF2C3E50),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

void userLogout(BuildContext context) {
  // Clear any stored user data/preferences here if needed

  // Navigate to login screen and remove all previous routes
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const IndoGripLoginPanel()),
    (route) => false,
  );
}
