import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/appbar/desktop_appbar.dart';
import 'package:indogrip/core/utils/appbar/mobile_appbar.dart';
import 'package:indogrip/core/utils/sidebar.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/chalan/presentation/page/chalan_builder.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/data_filtration.dart';
import 'package:indogrip/features/global/presentation/widget/pagination_widget.dart';

class ChalanPanel extends StatefulWidget {
  const ChalanPanel({super.key});
  static const String routeName = '/chalan-panel';

  @override
  State<ChalanPanel> createState() => _ChalanPanelState();
}

class _ChalanPanelState extends ChalanBuilder {
  final GlobalKey<ScaffoldState> statekey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    selectedRows.clear();
    dataSource?.dispose();
    dataSource = null;
    super.dispose();
  }

  Widget _buildTabletView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (Responsive.isDesktop(context))
                DesktopAppBar(context, statekey, 'Challan Panel', false),
              // Filter fields would go here (similar to ViewStaffPanel)
              const SizedBox(height: 15),
              BlocListener<GlobalBloc, GlobalState>(
                bloc: globalBloc,
                listener: (context, state) {
                  if (state is GlobalChangeUserStatusSuccessStatus) {
                    // Handle status change success (for approved, rejected, blocked, etc.)
                    if (state.changeStatusEntity.status == 1) {
                      ToastService.instance.showSuccess(
                        context,
                        state.changeStatusEntity.message.toString(),
                      );

                      // Refresh list after status change
                      dataLoadingEventCall();
                    } else {
                      ToastService.instance.showError(
                        context,
                        state.changeStatusEntity.message.toString(),
                      );
                    }
                  } else if (state is GlobalChangeUserStatusErrorStatus) {
                    ToastService.instance.showError(
                      context,
                      state.message.toString(),
                    );
                  } else if (state is GlobalDeleteRecordSuccessStatus) {
                    ToastService.instance.showSuccess(
                      context,
                      state.deleteRecordEntity.message.toString(),
                    );
                    // Refresh list after single delete
                    dataLoadingEventCall();
                  } else if (state is GlobalDeleteRecordErrorStatus) {
                    ToastService.instance.showError(
                      context,
                      state.message.toString(),
                    );
                  } else if (state
                      is GlobalDeleteMultipleRecordsSuccessStatus) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.deleteRecordEntity.message ?? 'Records deleted',
                        ),
                      ),
                    );
                    // Refresh list after bulk delete
                    dataLoadingEventCall();
                    // Clear selection
                    setState(() {
                      selectedRows.clear();
                      // selectedItems.clear();
                      isMultipleSelection = false;
                    });
                  } else if (state is GlobalDeleteMultipleRecordsErrorStatus) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: !Responsive.isDesktop(context)
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: searchFields,
                      )
                    : Column(
                        children: [
                          DateFiltration(
                            isChalan: true,
                            fromDateController: fromDateController,
                            toDateController: toDateController,
                            clientKey: clientKey,
                            staffKey: staffKey,
                            onChanged: (client) {
                              setState(() {
                                clientKey = client;
                              });
                              dataLoadingEventCall();
                            },
                            onStaffChanged: (staff) {
                              setState(() {
                                staffKey = staff;
                              });
                              dataLoadingEventCall();
                            },
                          ),
                          searchFields,
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [refreshButton],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_buildPaginationWidget],
              ),
              buildContentTableWidget,
            ],
          ),
        ),
      ],
    );
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
          key: statekey,
          appBar: !Responsive.isDesktop(context)
              ? MobileAppBar(context, statekey, 'Challan Panel')
              : null,
          drawer: !Responsive.isDesktop(context)
              ? const SideMenuWidget()
              : null,
          body: _buildTabletView(),
        );
      },
    );
  }

  Widget get _buildPaginationWidget => TableBottomWidget(
    currentPage: pageNo,
    pageQty: pageQty,
    onPagePressed: (pageNumber) {
      setState(() {
        pageNo = pageNumber;
      });
      dataLoadingEventCall();
      // Add pagination logic here when BLoC is implemented
    },
    onFirstPressed: () {
      setState(() {
        pageNo = 1;
      });
      dataLoadingEventCall();
    },
    onPreviousPressed: () {
      if (pageNo != null && pageNo! > 1) {
        setState(() {
          pageNo = pageNo! - 1;
        });
        dataLoadingEventCall();
      }
    },
    onNextPressed: () {
      if (pageNo != null && pageQty != null && pageNo! < pageQty!) {
        setState(() {
          pageNo = pageNo! + 1;
        });
        dataLoadingEventCall();
      }
    },
    onLastPressed: () {
      setState(() {
        pageNo = pageQty;
      });
      dataLoadingEventCall();
    },
  );
}
