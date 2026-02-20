import 'package:flutter/material.dart';

class SilicaPanel extends StatefulWidget {
  const SilicaPanel({super.key});
  static const String routeName = '/outsource/out/silica-panel';

  @override
  State<SilicaPanel> createState() => _SilicaPanelState();
}

class _SilicaPanelState extends State<SilicaPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Silica')),
      body: const Center(child: Text('Silica Content')),
    );
  }
}
