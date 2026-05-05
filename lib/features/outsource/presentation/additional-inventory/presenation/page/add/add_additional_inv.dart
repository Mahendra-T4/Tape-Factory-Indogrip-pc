import 'package:flutter/material.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/features/outsource/presentation/additional-inventory/presenation/page/add/add_additional_in_record_builder.dart';

class AdditionalInventoryRecordPanel extends StatefulWidget {
  const AdditionalInventoryRecordPanel({super.key});
  static const String routeName = '/outsource/additional/add';

  @override
  State<AdditionalInventoryRecordPanel> createState() =>
      _AdditionalInventoryRecordPanelState();
}

class _AdditionalInventoryRecordPanelState
    extends AdditionalInventoryRecordBuilder {
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
              ? MobileAppBar(context, stateKey, 'Add Silica')
              : DesktopAppBar(context, stateKey, 'Add Silica', false),
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
                SliverToBoxAdapter(child: buildSilicaHeaderWidget),
                SliverToBoxAdapter(
                  child: Column(
                    children: List.generate(
                      silicaRecords.length,
                      (index) => Column(
                        children: [
                          Row(
                            spacing: Responsive.betweenSpace,
                            children: [
                              Text(
                                'Silica Information ${index + 1}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Row(
                                children: [
                                  if (index == silicaRecords.length - 1)
                                    IconButton(
                                      onPressed: addSilicaRecord,
                                      icon: Icon(
                                        Icons.add_circle_outline,
                                        color: kButtonColor,
                                      ),
                                      tooltip: 'Add new silica record',
                                    ),
                                  if (silicaRecords.length > 1)
                                    IconButton(
                                      onPressed: () =>
                                          removeSilicaRecord(index),
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      tooltip: 'Delete silica record',
                                    ),
                                ],
                              ),
                            ],
                          ),
                          buildMultiWidgetRowWidgetForRecord(
                            silicaRecords[index],
                            index,
                          ),
                          const SizedBox(height: 16),
                          buildMiddleRowWidgetForRecord(
                            silicaRecords[index],
                            index,
                          ),
                          // buildPricingRowWidgetForRecord(silicaRecords[index]),
                          // buildRemarkRowWidgetForRecord(
                          //   silicaRecords[index],
                          //   index,
                          // ),
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

  Widget get buildSecondaryMultiOptionLayout => Column(
    children: [
      Row(
        spacing: Responsive.betweenSpace,
        children: [
          Text(
            'Silica Information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_circle_outline, color: kButtonColor),
          ),
        ],
      ),
      SizedBox(height: 16),
      // buildMiddleRowWidget,
      // buildPricingRowWidget,
      // buildRemarkRowWidget,
    ],
  );
}
