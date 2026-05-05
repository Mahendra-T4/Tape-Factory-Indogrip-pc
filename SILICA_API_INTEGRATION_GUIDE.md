# Silica Records API Integration Guide

## Overview
This guide explains how to handle multiple silica records from the dynamic form and send them to the API as a structured request.

---

## Data Structure

### 1. SilicaRecordData (Single Record)
```dart
{
  'serial_number': '12345',
  'gross': '1000.00',
  'cost': '800.00',
  'transport_price': '50.00',
  'margin': '10',           // Percentage
  'total_price': '935.00',  // Auto-calculated
  'remark': 'Good quality'
}
```

### 2. AddSilicaRequestData (Complete Request)
```dart
{
  'bill_date': '2024-04-28',
  'bill_number': 'BL-001',
  'vendor_id': 'V-123',
  'silica_records': [
    { /* Record 1 */ },
    { /* Record 2 */ },
    { /* Record 3 */ }
  ]
}
```

---

## Complete Data Flow

```
User adds multiple records
        ↓
Click Submit button
        ↓
validateAllRecords() - Validates all form fields
        ↓
collectAllRecordsData() - Converts controllers to data objects
        ↓
logCollectedData() - Logs for debugging
        ↓
toJson() - Converts to JSON format
        ↓
API Call (submitSilicaRecords)
        ↓
Server processes and stores records
```

---

## Step-by-Step Integration

### Step 1: Validate Form
```dart
bool validateAllRecords() {
  for (int i = 0; i < silicaRecords.length; i++) {
    // Checks:
    // - Serial number is not empty
    // - Gross, Cost, Margin are provided
    // - Margin <= 100
    // - Bill date and vendor are selected
  }
}
```

### Step 2: Collect Data
```dart
AddSilicaRequestData collectAllRecordsData() {
  final records = silicaRecords.map((record) {
    return SilicaRecordData(
      serialNumber: record.serialNumberController.text.trim(),
      gross: record.grossController.text.trim(),
      cost: record.costController.text.trim(),
      transportPrice: record.transportPriceController.text.trim(),
      margin: record.marginController.text.trim(),
      totalPrice: record.totalPriceController.text.trim(),
      remark: record.remarkController.text.trim(),
    );
  }).toList();

  return AddSilicaRequestData(
    billDate: billDateController.text.trim(),
    billNumber: billNumberController.text.trim(),
    vendor: selectedVendor ?? '',
    silicaRecords: records,
  );
}
```

### Step 3: Convert to JSON
```dart
Map<String, dynamic> toJson() {
  return {
    'bill_date': billDate,
    'bill_number': billNumber,
    'vendor_id': vendor,
    'silica_records': silicaRecords.map((record) => record.toJson()).toList(),
  };
}
```

### Step 4: Submit to API
```dart
Future<void> submitSilicaRecords() async {
  try {
    // Validate
    if (!validateAllRecords()) return;

    // Collect
    final requestData = collectAllRecordsData();

    // Log (for debugging)
    logCollectedData();

    // Convert to JSON
    final jsonData = requestData.toJson();

    // Send to API
    final response = await _silicaRepository.addSilicaRecords(requestData);

    // Handle response
    if (response.status == 1) {
      _showSuccess('Records added successfully!');
      // Navigate or reset form
    } else {
      _showError(response.message);
    }
  } catch (e) {
    _showError('Error: $e');
  }
}
```

---

## Example JSON Payload

```json
{
  "bill_date": "2024-04-28",
  "bill_number": "BL-001",
  "vendor_id": "V-123",
  "silica_records": [
    {
      "serial_number": "SN-001",
      "gross": "1000.00",
      "cost": "800.00",
      "transport_price": "50.00",
      "margin": "10",
      "total_price": "935.00",
      "remark": "Quality check passed"
    },
    {
      "serial_number": "SN-002",
      "gross": "1500.00",
      "cost": "1200.00",
      "transport_price": "75.00",
      "margin": "15",
      "total_price": "1402.50",
      "remark": "Good condition"
    }
  ]
}
```

---

## API Implementation Examples

### Using Dio
```dart
Future<SilicaApiResponse> addSilicaRecords(AddSilicaRequestData data) async {
  try {
    final response = await dio.post(
      '/api/outsource/silica/add',
      data: data.toJson(),
    );
    return SilicaApiResponse.fromJson(response.data);
  } catch (e) {
    return SilicaApiResponse(status: 0, message: 'Error: $e');
  }
}
```

### Using HTTP Package
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<SilicaApiResponse> addSilicaRecords(AddSilicaRequestData data) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}/api/outsource/silica/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return SilicaApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return SilicaApiResponse(
        status: 0,
        message: 'Failed: ${response.statusCode}',
      );
    }
  } catch (e) {
    return SilicaApiResponse(status: 0, message: 'Error: $e');
  }
}
```

---

## Features Included

✅ **Validation**: 
- Validates all records before submission
- Checks margin <= 100
- Ensures required fields are filled

✅ **Data Collection**:
- Collects all form data from multiple records
- Trims whitespace
- Converts to proper format

✅ **Logging**:
- Logs each record individually
- Shows complete JSON payload
- Useful for debugging

✅ **Error Handling**:
- Validates data
- Catches exceptions
- Shows user-friendly error messages

✅ **Multiple Records Support**:
- Add unlimited records
- Delete records
- Auto-calculate total price per record

---

## Usage in UI

```dart
// In your form submission
CustomButton(
  label: 'Submit',
  onPressed: submitSilicaRecords,  // Handles everything
)
```

---

## Debugging

To see the collected data in console:

```dart
// This logs all records to console
logCollectedData();
```

Output example:
```
Bill Date: 2024-04-28
Bill Number: BL-001
Vendor: V-123
Total Records: 2
Record 1: SilicaRecordData(serialNumber: SN-001, cost: 800.00, margin: 10, totalPrice: 935.00)
Record 2: SilicaRecordData(serialNumber: SN-002, cost: 1200.00, margin: 15, totalPrice: 1402.50)
JSON: {...}
```

---

## Next Steps

1. Implement `SilicaRepository` with your HTTP client
2. Call `addSilicaRecords()` instead of mock response
3. Handle success/error responses
4. Navigate or reset form after submission
5. Test with multiple records

---

## Tips

- Always validate before sending to API
- Log data for debugging in development
- Handle network timeouts gracefully
- Show loading indicator during API call
- Provide clear error messages to users
