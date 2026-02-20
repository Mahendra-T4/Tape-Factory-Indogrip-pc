import 'package:flutter/material.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/features/carton/presentation/pages/add/add_carton.dart';
import 'package:indogrip/features/carton/presentation/pages/view/view_carton.dart';
import 'package:indogrip/features/client/presentation/pages/add/add_client.dart';
import 'package:indogrip/features/client/presentation/pages/view/view_client.dart';
import 'package:indogrip/features/core/presentation/pages/add/add_core.dart';
import 'package:indogrip/features/core/presentation/pages/view/view_core.dart';
import 'package:indogrip/features/dashboard/presentation/page/deshboard.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/add/add_jumbo_roll.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/view/view_jumbo_roll.dart';
import 'package:indogrip/features/loss%20meters/pages/add/add_lossmeter.dart';
import 'package:indogrip/features/loss%20meters/pages/view/view_loss_meter.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/pages/outsource_in.dart';
import 'package:indogrip/features/round/presentation/pages/add/add_round.dart';
import 'package:indogrip/features/round/presentation/pages/view/view_round.dart';
import 'package:indogrip/features/staff/presentation/pages/add/add_statff.dart';
import 'package:indogrip/features/staff/presentation/pages/view/view_staff.dart';
import 'package:indogrip/features/vendor/presentation/pages/add/add_vendor.dart';
import 'package:indogrip/features/vendor/presentation/pages/view/view_vendor.dart';
import 'package:indogrip/features/wastage/presentation/pages/add/add_wastage.dart';
import 'package:indogrip/features/wastage/presentation/pages/view/view_wastage.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  bool isStaff = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C3E50), Color(0xFF1A1A2E)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Modern logo container
          Container(
            width: 100,
            height: 100,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Image.asset(Assets.indoGripLogoImage, fit: BoxFit.cover),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ClipRRect(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndoGripDashboard(),
                        ),
                      );
                    },
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.dashboard, // Transfer/Exchange icon
                        size: 20,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    title: Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),

                  _buildSectionHeader('Account'),
                  _buildExpandableMenuItem(
                    'Staff',
                    Icons.people_alt_outlined, // Staff management icon
                    [AddStaff(), ViewStaffPanel()],
                    ['ADD', 'VIEW'],
                  ),
                  _buildExpandableMenuItem(
                    'Client',
                    Icons.business_center_outlined, // Client/Business icon
                    [AddClientPanel(), ViewClientPanel()],
                    ['ADD', 'VIEW'],
                  ),
                  _buildExpandableMenuItem(
                    'Vendor',
                    Icons.store_outlined, // Vendor/Store icon
                    [AddVendorPanel(), ViewVendorPanel()],
                    ['ADD', 'VIEW'],
                  ),
                  _buildSectionHeader('Operations'),
                  _buildExpandableMenuItem(
                    'Jumbo Roll',
                    Icons.rotate_90_degrees_ccw_outlined, // Roll/Rotation icon
                    [AddJumboRollPanel(), ViewJumboRollPanel()],
                    ['ADD', 'VIEW'],
                  ),
                  _buildExpandableMenuItemAtt(
                    'Round',
                    Icons.circle_outlined, // Round/Circle icon
                    [AddRoundPanel(), ViewRoundPanel()],
                    ['ADD', 'VIEW'],
                  ),
                  _buildSectionHeader('General'),

                  // ListTile(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => OutSourceIN()),
                  //     );
                  //   },
                  //   leading: Container(
                  //     padding: EdgeInsets.all(8),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white.withOpacity(0.1),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Icon(
                  //       Icons.swap_horiz_outlined, // Transfer/Exchange icon
                  //       size: 20,
                  //       color: Colors.white.withOpacity(0.9),
                  //     ),
                  //   ),
                  //   title: Text(
                  //     'Outsource [IN]',
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.white.withOpacity(0.9),
                  //     ),
                  //   ),
                  // ),
                  _buildExpandableMenuItemAtt(
                    'Wastage Peace',
                    Icons.delete_outline, // Wastage/Delete icon
                    [AddWastagePanel(), ViewWastagePanel()],
                    ['ADD', 'VIEW'],
                  ),
                  // _buildExpandableMenuItem(
                  //   'Estimation',
                  //   Icons.calculate_outlined, // Calculator/Estimation icon
                  //   [AddEstimation(), ViewstaffPage()],
                  //   ['ADD', 'VIEW'],
                  // ),
                  // _buildExpandableMenuItem(
                  //   'Loss Meters',
                  //   Icons.trending_down_outlined, // Downward trend/Loss icon
                  //   [AddLossMeterPanel(), ViewLossMeterPanel()],
                  //   ['ADD', 'VIEW'],
                  // ),
                  _buildSectionHeader('Stock Maintenance'),
                  _buildExpandableMenuItem(
                    'Carton',
                    Icons.inventory_2_outlined, // Box/Inventory icon
                    [AddCartonPanel(), ViewCartonPanel()],
                    ['ADD', 'VIEW'],
                  ),
                  _buildExpandableMenuItem(
                    'Core',
                    Icons.category_outlined, // Core/Category icon
                    [AddCorePanel(), ViewCorePanel()],
                    ['ADD', 'VIEW'],
                  ),
                  // _buildSectionHeader('Main Menu'),
                  // _buildExpandableMenuItem(
                  //   'Cartoon',
                  //   Icons.business,
                  //   [Addclient(), Viewclient()],
                  //   ['Add', 'View'],
                  // ),
                  // _buildSectionHeader('Logout'),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[400],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildExpandableMenuItem(
    String title,
    IconData icon,
    List<Widget> screens,
    List<String> screenNames,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.white.withOpacity(0.9)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        trailing: Icon(
          Icons.expand_more,
          size: 18,
          color: Colors.white.withOpacity(0.5),
        ),
        children: List.generate(
          screenNames.length,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(0.05),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                screenNames[index],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              leading: Icon(
                index == 0
                    ? Icons.add_circle_outline
                    : Icons.remove_red_eye_outlined,
                size: 18,
                color: Colors.white.withOpacity(0.7),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screens[index]),
                );
              },
              hoverColor: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableMenuItemAtt(
    String title,
    IconData icon,
    List<Widget> screens,
    List<String> screenNames,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.white.withOpacity(0.9)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        trailing: Icon(
          Icons.expand_more,
          size: 18,
          color: Colors.white.withOpacity(0.5),
        ),
        children: List.generate(
          screenNames.length,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(0.05),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                screenNames[index],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              leading: Icon(
                index == 0
                    ? Icons.add_circle_outline
                    : Icons.remove_red_eye_outlined,
                size: 18,
                color: Colors.white.withOpacity(0.7),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screens[index]),
                );
              },
              hoverColor: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ),
    );
  }
}
