import 'package:flutter/material.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/features/client/presentation/pages/client-miss-record/client_miss_record_panel_builder.dart';

class ClientMissRecordPanel extends StatefulWidget {
  const ClientMissRecordPanel({super.key});
  static const String routeName = '/client-miss-record-panel';

  @override
  State<ClientMissRecordPanel> createState() => _ClientMissRecordPanelState();
}

class _ClientMissRecordPanelState extends ClientMissRecordPanelBuilder {
  final GlobalKey<ScaffoldState> _statekey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

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
          key: _statekey,
          appBar: DesktopAppBar(context, _statekey, 'Client Miss Record', false),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reason',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: TextFormField(
                        readOnly: true,
                        controller: _reasonController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              'Failed to import all records from uploaded file',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              buildTableRecordWidget,
            ],
          ),
          
        );
      }
    );
  }
}
