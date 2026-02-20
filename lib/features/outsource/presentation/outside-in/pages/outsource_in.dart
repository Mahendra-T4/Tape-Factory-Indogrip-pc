import 'package:flutter/material.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/api%20service/csv_urls.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/heading_text.dart';
import 'package:indogrip/features/client/presentation/widgets/download_csv_button_client.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/pages/outsource_in_builder.dart';

class OutSourceIN extends StatefulWidget {
  const OutSourceIN({super.key});
  static const String routeName = '/outsource/in';

  @override
  State<OutSourceIN> createState() => _OutSourceINState();
}

class _OutSourceINState extends OutsourceInBuilder {
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
              ? MobileAppBar(context, stateKey, 'Inventory-IN')
              : DesktopAppBar(context, stateKey, 'Inventory-IN', false),
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,

          body: _buildOutsourceDesktop,
        );
      },
    );
  }

  Widget get _buildOutsourceDesktop => Row(
    children: [
      // const SideMenuWidget(),
      Expanded(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // DesktopAppBar(context, stateKey, 'Add Outsource In', false),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * .18,
                            child: DownloadClientFileButton(
                              defaultFileName: 'import-tape-sample.csv',
                              label: 'Download Tape CSV',
                              csvURL: CSVUrls.tapeCSVFilePath,
                            ),
                          ),
                          SizedBox(width: 20),

                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * .22,
                            child: DownloadClientFileButton(
                              defaultFileName: 'import-stretch-film-sample.csv',
                              label: 'Download Stretch Film CSV',
                              csvURL: CSVUrls.stretchFilmCSVFilePath,
                            ),
                          ),
                          buttonUi,
                        ],
                      ),
                      buildProductHeaderDesktop,

                      buildSectionTitle('Bill Information'),
                      if (selectedProduct == '2')
                        buildBillingSectionForStretchDesktop
                      else
                        buildBillingSectionDesktop,
                      buildMainProductSectionDesktop,
                      // buildRemarkDesktop,
                      submitButton,
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
