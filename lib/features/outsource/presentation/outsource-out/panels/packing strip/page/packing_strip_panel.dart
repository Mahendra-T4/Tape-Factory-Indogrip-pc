import 'package:flutter/material.dart';

class PackingStripPanel extends StatefulWidget {
  const PackingStripPanel({super.key});
  static const String routeName = '/outsource/out/packing-strip-panel';

  @override
  State<PackingStripPanel> createState() => _PackingStripPanelState();
}

class _PackingStripPanelState extends State<PackingStripPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Packing Strip')),
      body: const Center(child: Text('Packing Strip')),
    );
  }
}
