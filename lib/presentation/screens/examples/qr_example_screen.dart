import 'package:flutter/material.dart';

import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

/// Example screen showcasing plain QR, branded QR with logo, and full display widget with download/share.
class QrExampleScreen extends StatelessWidget {
  const QrExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'QR Example',
        showBackButton: true,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppDesignSystem.surfaceDarkSecondary
          : AppDesignSystem.surface,
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  /// Scrollable body with sectioned QR examples.
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDesignSystem.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScannerLink(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Plain QR code'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildPlainQrSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Branded QR (with logo)'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildBrandedQrSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Display widget (no logo)'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildDisplayQrSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Display widget (with logo)'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildDisplayQrWithLogoSection(context),
        ],
      ),
    );
  }

  /// Link to QR scanner example screen.
  Widget _buildScannerLink(BuildContext context) {
    return Center(
      child: AppNavigationButton.secondary(
        text: 'Scan QR code',
        icon: Icons.qr_code_scanner,
        onPressed: () => Navigator.pushNamed(context, '/examples/qr_scanner'),
      ),
    );
  }

  /// Section title.
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.heading3,
    );
  }

  /// CustomQrCodeWidget: plain QR, no logo.
  Widget _buildPlainQrSection(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(AppDesignSystem.spacing16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CustomQrCodeWidget(
          data: 'https://example.com/plain',
          size: 180,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  /// BrandedQrWidget: QR with centered logo overlay.
  Widget _buildBrandedQrSection(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(AppDesignSystem.spacing16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: BrandedQrWidget(
          data: 'https://example.com/branded',
          size: 180,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          logoImage: const AssetImage('assets/icons/Penguin-Icon-48.png'),
          logoBoxRatio: 0.24,
          logoInnerPadding: 6.0,
        ),
      ),
    );
  }

  /// QrDisplayWidget without logo: title, subtitle, download/share.
  Widget _buildDisplayQrSection(BuildContext context) {
    return QrDisplayWidget(
      qrData: 'https://example.com/display',
      title: 'Scan to open',
      subtitle: 'Plain display with actions',
      size: 160,
      centerContent: true,
    );
  }

  /// QrDisplayWidget with logo: title, subtitle, branded QR, download/share.
  Widget _buildDisplayQrWithLogoSection(BuildContext context) {
    return QrDisplayWidget(
      qrData: 'https://example.com/display-branded',
      title: 'Template QR',
      subtitle: 'With logo and share/download',
      size: 160,
      centerContent: true,
      logoImage: const AssetImage('assets/icons/Penguin-Icon-48.png'),
      logoBoxRatio: 0.24,
      logoInnerPadding: 6.0,
    );
  }
}
