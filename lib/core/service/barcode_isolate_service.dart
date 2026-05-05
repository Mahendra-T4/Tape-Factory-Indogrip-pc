import 'dart:isolate';
import 'dart:developer' as developer;

/// Model to pass data to isolate
class BarcodeProcessingData {
  final String barcode;
  final List<String> existingBarcodes;

  BarcodeProcessingData({
    required this.barcode,
    required this.existingBarcodes,
  });
}

/// Model for isolate response
class BarcodeProcessingResult {
  final bool success;
  final String processedBarcode;
  final String message;
  final List<String> updatedBarcodes;

  BarcodeProcessingResult({
    required this.success,
    required this.processedBarcode,
    required this.message,
    required this.updatedBarcodes,
  });
}

/// Isolate entry point - runs in a separate thread
void _barcodeProcessingIsolate(SendPort sendPort) {
  // Create a receive port to listen for messages from main isolate
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  // Listen for incoming messages
  receivePort.listen((message) {
    if (message is Map<String, dynamic>) {
      try {
        final data = message['data'] as BarcodeProcessingData;
        final responsePort = message['responsePort'] as SendPort;

        // Perform barcode validation and processing
        final result = _validateAndProcessBarcode(data);

        // Send result back to main isolate
        responsePort.send(result);
      } catch (e) {
        developer.log('Error in isolate: $e', name: 'BarcodeIsolate');
      }
    }
  });
}

/// Actual barcode processing logic
BarcodeProcessingResult _validateAndProcessBarcode(BarcodeProcessingData data) {
  final barcode = data.barcode.trim();

  // Validation checks
  if (barcode.isEmpty) {
    return BarcodeProcessingResult(
      success: false,
      processedBarcode: '',
      message: 'Barcode cannot be empty',
      updatedBarcodes: data.existingBarcodes,
    );
  }

  // Check for duplicates
  if (data.existingBarcodes.contains(barcode)) {
    return BarcodeProcessingResult(
      success: false,
      processedBarcode: '',
      message: 'Barcode already exists',
      updatedBarcodes: data.existingBarcodes,
    );
  }

  // Validate barcode format (basic alphanumeric check)
  if (!RegExp(r'^[a-zA-Z0-9\-_]+$').hasMatch(barcode)) {
    return BarcodeProcessingResult(
      success: false,
      processedBarcode: '',
      message:
          'Invalid barcode format. Only alphanumeric, dash, and underscore allowed',
      updatedBarcodes: data.existingBarcodes,
    );
  }

  // Add barcode and return updated list
  final updatedList = [...data.existingBarcodes, barcode];

  return BarcodeProcessingResult(
    success: true,
    processedBarcode: barcode,
    message: 'Barcode added successfully',
    updatedBarcodes: updatedList,
  );
}

/// Service to manage barcode processing with isolates
class BarcodeIsolateService {
  static final BarcodeIsolateService _instance =
      BarcodeIsolateService._internal();

  factory BarcodeIsolateService() {
    return _instance;
  }

  BarcodeIsolateService._internal();

  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;

  /// Initialize the isolate
  Future<void> initialize() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      _barcodeProcessingIsolate,
      _receivePort!.sendPort,
    );

    // Get the send port from the isolate
    _sendPort = await _receivePort!.first as SendPort;
  }

  /// Process a barcode in the isolate
  Future<BarcodeProcessingResult> processBarcode(
    String barcode,
    List<String> existingBarcodes,
  ) async {
    if (_sendPort == null) {
      await initialize();
    }

    final data = BarcodeProcessingData(
      barcode: barcode,
      existingBarcodes: existingBarcodes,
    );

    // Create a response port to receive the result
    final responsePort = ReceivePort();
    _sendPort!.send({'data': data, 'responsePort': responsePort.sendPort});

    // Wait for the result
    final result = await responsePort.first as BarcodeProcessingResult;
    responsePort.close();

    return result;
  }

  /// Dispose the isolate
  void dispose() {
    _isolate?.kill();
    _receivePort?.close();
    _isolate = null;
    _sendPort = null;
    _receivePort = null;
  }
}

/// Simpler approach: Using Isolate.run (one-time execution)
/// This is easier and doesn't require managing isolate lifecycle
class SimpleBarcodeProcessor {
  static Future<BarcodeProcessingResult> processBarcode(
    BarcodeProcessingData data,
  ) async {
    // This runs in a separate isolate automatically
    return await Isolate.run(() => _validateAndProcessBarcode(data));
  }
}
