import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/features/vendor/presentation/pages/profile/vendor_profile.dart';

abstract class VendorProfileBuilder extends State<VendorProfile> {
  Widget get contentBuilderWidget {
    final vendor = widget.vendor;
    final isMobile = !Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.8
                : MediaQuery.of(context).size.width - 32,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.withOpacity(.08),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile
                    ? 16
                    : isTablet
                    ? 24
                    : 32,
                vertical: isMobile ? 16 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeader(vendor),
                  SizedBox(height: isMobile ? 20 : 28),

                  // Company Information - responsive cards
                  Text(
                    'Company Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = constraints.maxWidth < 600
                          ? constraints.maxWidth
                          : (constraints.maxWidth / 3) - 16;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _infoCardSized(
                            width: itemWidth,
                            icon: Icons.phone,
                            label: 'Company Mobile',
                            value: vendor.vCompanyMobileNumber ?? 'N/A',
                            color: Colors.indigo,
                          ),
                          _infoCardSized(
                            width: itemWidth,
                            icon: Icons.business,
                            label: 'Company Name',
                            value: vendor.vCompanyName ?? 'N/A',
                            color: Colors.blue,
                          ),
                          _infoCardSized(
                            width: itemWidth,
                            icon: Icons.verified_user,
                            label: 'GSTIN',
                            value: vendor.vCompanyGSTIN ?? 'N/A',
                            color: Colors.green,
                          ),
                          _infoCardSized(
                            width: itemWidth,
                            icon: Icons.code,
                            label: 'Vendor Code',
                            value: vendor.vCode ?? 'N/A',
                            color: Colors.amber,
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Vendor Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = constraints.maxWidth < 600
                          ? constraints.maxWidth
                          : (constraints.maxWidth / 3) - 16;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _infoCardSized(
                            width: itemWidth,
                            icon: Icons.person,
                            label: 'Vendor Name',
                            value: vendor.vVendorName ?? 'N/A',
                            color: Colors.orange,
                          ),
                          _infoCardSized(
                            width: itemWidth,
                            icon: Icons.phone,
                            label: 'Vendor Mobile',
                            value: vendor.vVendorMobileNumber ?? 'N/A',
                            color: Colors.red,
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Representative Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = constraints.maxWidth < 600
                          ? constraints.maxWidth
                          : (constraints.maxWidth / 3) - 16;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _infoCardSized(
                            width: itemWidth,
                            icon: Icons.person_outline,
                            label: 'Representative Name',
                            value: vendor.vRepresentativeName ?? 'N/A',
                            color: Colors.purple,
                          ),
                          _infoCardSized(
                            width: itemWidth,
                            icon: Icons.phone,
                            label: 'Representative Mobile',
                            value: vendor.vRepresentativeNumber ?? 'N/A',
                            color: Colors.teal,
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic vendor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple.shade600, Colors.purple.shade800],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(Icons.store, size: 32, color: Colors.purple.shade600),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vendor Profile',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  vendor.vCompanyName ?? 'Unknown Vendor',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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
    final isMobile = !Responsive.isDesktop(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.12), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: color, size: isMobile ? 20 : 24),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 4 : 6),
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
          ),
          // If value looks like a phone number, show copy icon
          if (RegExp(r'^\d{6,}$').hasMatch(value))
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Copied $label')));
              },
              icon: Icon(
                Icons.copy,
                size: isMobile ? 18 : 20,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoCardSized({
    required double width,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return SizedBox(
      width: width,
      child: _buildInfoCard(
        icon: icon,
        label: label,
        value: value,
        color: color,
      ),
    );
  }
}
