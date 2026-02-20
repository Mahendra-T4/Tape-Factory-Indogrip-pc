import 'package:flutter/material.dart';

class StickerDialog {
  static Future<void> show(BuildContext context, Map<String, dynamic> data) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.sticky_note_2, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Sticker Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('Basic Information', [
                  _buildDetailRow(
                    'Roll Number',
                    data['rollNumber']?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Width',
                    '${data['width']?.toString() ?? '-'} mm',
                  ),
                  _buildDetailRow('Base', data['base']?.toString() ?? '-'),
                  _buildDetailRow('Mic', data['mic']?.toString() ?? '-'),
                  _buildDetailRow(
                    'Length',
                    '${data['length']?.toString() ?? '-'} m',
                  ),
                ]),
                const SizedBox(height: 16),
                _buildSection('Production Details', [
                  _buildDetailRow(
                    'Total Weight',
                    '${data['totalWeight']?.toString() ?? '-'} kg',
                  ),
                  _buildDetailRow(
                    'Amount/KG',
                    '₹${data['amountPerKG']?.toString() ?? '-'}',
                  ),
                  _buildDetailRow(
                    'Cut MM Meter',
                    data['cutMMMeter']?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Round Count',
                    data['roundCount']?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Tape Length',
                    data['tapeLength']?.toString() ?? '-',
                  ),
                ]),
                const SizedBox(height: 16),
                _buildSection('Additional Info', [
                  _buildDetailRow(
                    'Damage Pieces',
                    data['damagePieces']?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Wastage',
                    '${data['wastagePercentage']?.toString() ?? '-'}%',
                  ),
                ]),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Close'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          elevation: 5,
        );
      },
    );
  }

  static Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  static Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
