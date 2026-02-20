// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:connectivity_plus/src/connectivity_plus_web.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_selector_web/file_selector_web.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:printing/printing_web.dart';
import 'package:share_plus/src/share_plus_web.dart';
import 'package:toast/toast_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  ConnectivityPlusWebPlugin.registerWith(registrar);
  FilePickerWeb.registerWith(registrar);
  FileSelectorWeb.registerWith(registrar);
  FluttertoastWebPlugin.registerWith(registrar);
  PrintingPlugin.registerWith(registrar);
  SharePlusWebPlugin.registerWith(registrar);
  ToastWebPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
