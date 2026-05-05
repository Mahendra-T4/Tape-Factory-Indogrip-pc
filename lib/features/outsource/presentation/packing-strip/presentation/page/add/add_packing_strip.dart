import 'package:flutter/material.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/outsource/presentation/packing-strip/presentation/page/add/add_packing_stip_builder.dart';
import 'package:indogrip/core/theme/color_conts.dart';

class AddPackingStripRecordPanel extends StatefulWidget {
  const AddPackingStripRecordPanel({super.key});
  static const String routeName = '/outsource/packing-strip/add';

  @override
  State<AddPackingStripRecordPanel> createState() =>
      _AddPackingStripRecordPanelState();
}

class _AddPackingStripRecordPanelState extends AddPackingStripRecordBuilder {
  final GlobalKey<ScaffoldState> stateKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: InternetConnectionService().connectionStream,
      initialData: true, // Assume connected initially
      builder: (context, snapshot) {
        // Handle error state
        if (snapshot.hasError) {
          return const NoInternetConnection();
        }

        // Handle disconnected state
        if (snapshot.data == false) {
          return const NoInternetConnection();
        }

        // Handle loading state
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          key: stateKey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, stateKey, 'Add Packing Strip')
              : DesktopAppBar(context, stateKey, 'Add Packing Strip', false),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,

          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding + 20,
              vertical: kDefaultVerticalPadding,
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: buildPackingStripHeaderWidget),
                SliverToBoxAdapter(
                  child: Column(
                    children: List.generate(
                      packingStripRecords.length,
                      (index) => Column(
                        children: [
                          Row(
                            spacing: Responsive.betweenSpace,
                            children: [
                              Text(
                                'Packing Strip ${index + 1}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Row(
                                children: [
                                  if (index == packingStripRecords.length - 1)
                                    IconButton(
                                      onPressed: addPackingStripRecord,
                                      icon: Icon(
                                        Icons.add_circle_outline,
                                        color: kButtonColor,
                                      ),
                                      tooltip: 'Add new packing strip record',
                                    ),
                                  if (packingStripRecords.length > 1)
                                    IconButton(
                                      onPressed: () =>
                                          deletePackingStripRecord(index),
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      tooltip: 'Delete packing strip record',
                                    ),
                                ],
                              ),
                            ],
                          ),
                          buildMultiWidgetRowWidgetForRecord(
                            packingStripRecords[index],
                            index,
                          ),
                          const SizedBox(height: 16),
                          buildMiddleRowWidgetForRecord(
                            packingStripRecords[index],
                            index,
                          ),
                          // buildPricingRowWidgetForRecord(
                          //   packingStripRecords[index],
                          // ),
                          buildRemarkRowWidgetForRecord(
                            packingStripRecords[index],
                            index,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 40)),
                SliverToBoxAdapter(child: buildSubmitButton),
              ],
            ),
          ),
        );
      },
    );
  }
}
