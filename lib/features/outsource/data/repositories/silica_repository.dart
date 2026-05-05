import 'package:indogrip/features/outsource/presentation/additional-inventory/presenation/page/add/add_additional_in_record_builder.dart';
import 'dart:developer' as developer;

/// Sample API Response model
class SilicaApiResponse {
  final int status;
  final String message;
  final dynamic data;

  SilicaApiResponse({required this.status, required this.message, this.data});

  factory SilicaApiResponse.fromJson(Map<String, dynamic> json) {
    return SilicaApiResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? 'Unknown error',
      data: json['data'],
    );
  }
}

/// Repository for handling silica API calls
class SilicaRepository {
  // TODO: Inject your HTTP client or Dio instance
  // final HttpClient _httpClient;
  // final String baseUrl = 'https://api.example.com';

  // SilicaRepository(this._httpClient);

  /// Add multiple silica records
  Future<SilicaApiResponse> addSilicaRecords(
    AddSilicaRequestData requestData,
  ) async {
    try {
      developer.log('Sending silica records to API', name: 'SilicaRepository');

      // Log the request payload
      final jsonPayload = requestData.toJson();
      developer.log('Request Payload: $jsonPayload', name: 'SilicaRepository');

      // TODO: Replace with your actual HTTP call
      // Example using Dio:
      // final response = await _httpClient.post(
      //   '$baseUrl/outsource/silica/add',
      //   data: jsonPayload,
      //   options: Options(
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Authorization': 'Bearer $token',
      //     },
      //   ),
      // );

      // Example using http package:
      // final response = await http.post(
      //   Uri.parse('$baseUrl/outsource/silica/add'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      //   body: jsonEncode(jsonPayload),
      // );
      //
      // if (response.statusCode == 200) {
      //   final jsonResponse = jsonDecode(response.body);
      //   return SilicaApiResponse.fromJson(jsonResponse);
      // } else {
      //   throw Exception('Failed to add silica records: ${response.statusCode}');
      // }

      // Mock successful response for demonstration
      return SilicaApiResponse(
        status: 1,
        message:
            '${requestData.silicaRecords.length} silica records added successfully',
        data: {'records_created': requestData.silicaRecords.length},
      );
    } catch (e) {
      developer.log('Error: $e', name: 'SilicaRepository', error: e);
      return SilicaApiResponse(status: 0, message: 'Error: ${e.toString()}');
    }
  }

  /// Example: Get silica records (for editing/viewing)
  Future<SilicaApiResponse> getSilicaRecords({
    required String billNumber,
  }) async {
    try {
      developer.log(
        'Fetching silica records for bill: $billNumber',
        name: 'SilicaRepository',
      );

      // TODO: Replace with your actual HTTP call
      // final response = await _httpClient.get(
      //   '$baseUrl/outsource/silica?bill_number=$billNumber',
      // );

      return SilicaApiResponse(
        status: 1,
        message: 'Silica records fetched successfully',
        data: [],
      );
    } catch (e) {
      return SilicaApiResponse(status: 0, message: 'Error: ${e.toString()}');
    }
  }

  /// Example: Update silica records
  Future<SilicaApiResponse> updateSilicaRecords({
    required String billId,
    required AddSilicaRequestData requestData,
  }) async {
    try {
      developer.log(
        'Updating silica records for bill: $billId',
        name: 'SilicaRepository',
      );

      final jsonPayload = requestData.toJson();
      developer.log('Update Payload: $jsonPayload', name: 'SilicaRepository');

      // TODO: Replace with your actual HTTP call
      // final response = await _httpClient.put(
      //   '$baseUrl/outsource/silica/$billId',
      //   data: jsonPayload,
      // );

      return SilicaApiResponse(
        status: 1,
        message: 'Silica records updated successfully',
      );
    } catch (e) {
      return SilicaApiResponse(status: 0, message: 'Error: ${e.toString()}');
    }
  }
}
