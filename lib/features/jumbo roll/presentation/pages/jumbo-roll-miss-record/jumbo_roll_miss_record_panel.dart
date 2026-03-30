import 'package:flutter/material.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/jumbo_uploadfile_response_model.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/jumbo-roll-miss-record/jumbo_roll_miss_record_panel_builder.dart';

class JumboRollMissRecordPanel extends StatefulWidget {
  final JumboUploadFileResponseModel missRecord;

  const JumboRollMissRecordPanel({super.key, required this.missRecord});
  static const String routeName = '/jumbo-roll-miss-record-panel';

  @override
  State<JumboRollMissRecordPanel> createState() =>
      _JumboRollMissRecordPanelState();
}

class _JumboRollMissRecordPanelState extends JumboRollMissRecordPanelBuilder {
  final GlobalKey<ScaffoldState> _statekey = GlobalKey<ScaffoldState>();
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reasonController.text = widget.missRecord.message.toString();
  }

  @override
  void dispose() {
    reasonController.dispose();
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
          appBar: DesktopAppBar(
            context,
            _statekey,
            'Jumbo Roll Miss Record',
            false,
          ),
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: TextFormField(
                        readOnly: true,
                        controller: reasonController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              'Failed to import jumbo roll records from file',
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
      },
    );
  }
}
