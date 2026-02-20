import 'package:flutter/material.dart';

import 'package:indogrip/features/wastage/presentation/pages/profile/wastage_profile.dart';

abstract class WastageProfileBuilder extends State<WastageProfile> {
  Widget get contentBuilderWidget {
    final wastage = widget.wastage;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(wastage),
            SizedBox(height: 15),
            Text(
              'Wastage Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 12),
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.person,
                    label: 'Client Name',
                    value: wastage.wastageClient ?? 'N/A',
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.business,
                    label: 'Consignee Name',
                    value: wastage.consigneeName ?? 'N/A',
                    color: Colors.cyan,
                  ),
                ),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.calendar_today,
                    label: 'Wastage Date',
                    value: wastage.wastageDateText ?? 'N/A',
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.receipt,
                    label: 'Bill Number',
                    value: wastage.billNumber?.toString() ?? 'N/A',
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.scale,
                    label: 'Weight',
                    value:
                        '${wastage.weight ?? "N/A"} ${wastage.weight != null ? "kg" : ""}',
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.price_check,
                    label: 'Price Per KG',
                    value:
                        '${wastage.pricePerKG ?? "N/A"} ${wastage.pricePerKG != null ? "₹" : ""}',
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.attach_money,
                    label: 'Total Price',
                    value:
                        '${wastage.price ?? "N/A"} ${wastage.price != null ? "₹" : ""}',
                    color: Colors.amber,
                  ),
                ),
                Expanded(
                  child: Container(
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purple.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.notes,
                            color: Colors.purple,
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Remarks',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          wastage.remark ?? 'No remarks',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.grey.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget get contentBuilderDesktopWidget {
    final wastage = widget.wastage;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(wastage),
            SizedBox(height: 15),
            Text(
              'Wastage Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 12),
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.person,
                    label: 'Client Name',
                    value: wastage.wastageClient ?? 'N/A',
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.business,
                    label: 'Consignee Name',
                    value: wastage.consigneeName ?? 'N/A',
                    color: Colors.cyan,
                  ),
                ),
              ],
            ),

            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.calendar_today,
                    label: 'Wastage Date',
                    value: wastage.wastageDateText ?? 'N/A',
                    color: Colors.teal,
                  ),
                ),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.person,
                    label: 'Client Name',
                    value: wastage.wastageClient ?? 'N/A',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.business,
                    label: 'Consignee Name',
                    value: wastage.consigneeName ?? 'N/A',
                    color: Colors.cyan,
                  ),
                ),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.calendar_today,
                    label: 'Wastage Date',
                    value: wastage.wastageDateText ?? 'N/A',
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.receipt,
                    label: 'Bill Number',
                    value: wastage.billNumber?.toString() ?? 'N/A',
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.scale,
                    label: 'Weight',
                    value:
                        '${wastage.weight ?? "N/A"} ${wastage.weight != null ? "kg" : ""}',
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.price_check,
                    label: 'Price Per KG',
                    value:
                        '${wastage.pricePerKG ?? "N/A"} ${wastage.pricePerKG != null ? "₹" : ""}',
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.attach_money,
                    label: 'Total Price',
                    value:
                        '${wastage.price ?? "N/A"} ${wastage.price != null ? "₹" : ""}',
                    color: Colors.amber,
                  ),
                ),
              ],
            ),

            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: Container(
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purple.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.notes,
                            color: Colors.purple,
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Remarks',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          wastage.remark ?? 'No remarks',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.grey.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic wastage) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red.shade600, Colors.red.shade800],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.delete_outline,
                  size: 32,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wastage Record',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      wastage.wastageClient ?? 'Unknown Client',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          wastage.wastageDateText ?? 'N/A',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    // final isMobile = !Responsive.isDesktop(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade900,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  double _getCardWidth(BoxConstraints constraints, bool isMobile) {
    if (isMobile) {
      return constraints.maxWidth;
    } else if (constraints.maxWidth > 1200) {
      return (constraints.maxWidth - 32) / 4 - 12 / 4;
    } else {
      return (constraints.maxWidth - 32) / 2 - 8;
    }
  }
}
