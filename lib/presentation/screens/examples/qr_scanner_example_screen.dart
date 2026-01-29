import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

/// Example screen that uses the camera to scan QR/barcodes and shows the result.
class QrScannerExampleScreen extends StatefulWidget {
  const QrScannerExampleScreen({super.key});

  @override
  State<QrScannerExampleScreen> createState() => _QrScannerExampleScreenState();
}

class _QrScannerExampleScreenState extends State<QrScannerExampleScreen> {
  final MobileScannerController _controller = MobileScannerController();
  String? _lastScanned;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'QR Scanner',
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

  /// Column: instructions, scanner widget, last-scanned result.
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDesignSystem.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInstructions(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildScannerSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildResultSection(context),
          if (_lastScanned != null) ...[
            SizedBox(height: AppDesignSystem.spacing16),
            _buildScanAgainButton(context),
          ],
        ],
      ),
    );
  }

  /// Restarts the scanner so the user can scan another code.
  Widget _buildScanAgainButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppNavigationButton.secondary(
        text: 'Scan again',
        icon: Icons.qr_code_scanner,
        onPressed: () => _controller.start(),
      ),
    );
  }

  /// Short instruction text.
  Widget _buildInstructions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark
        ? AppDesignSystem.onSurfaceDarkSecondary
        : AppDesignSystem.lightOnSurfaceSecondary;
    return Text(
      'Point your camera at a QR code or barcode to scan it.',
      style: AppTextStyles.body.copyWith(color: secondaryColor),
      textAlign: TextAlign.center,
    );
  }

  /// Scanner with fixed aspect ratio so it has a defined size on screen.
  Widget _buildScannerSection(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: QrScannerWidget(
        controller: _controller,
        onScanned: _handleScanned,
        showScanningOverlay: true,
      ),
    );
  }

  /// Shows last scanned value or placeholder.
  Widget _buildResultSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppDesignSystem.surfaceDarkTertiary
            : AppDesignSystem.lightSurfaceTertiary,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last scanned',
            style: AppTextStyles.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          SizedBox(height: AppDesignSystem.spacing8),
          Text(
            _lastScanned ?? 'No code scanned yet',
            style: AppTextStyles.body,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Stops the scanner after first detection, updates last scanned, and shows snackbar.
  void _handleScanned(String value) {
    if (!mounted) return;
    _controller.stop();
    setState(() => _lastScanned = value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scanned: ${value.length > 40 ? '${value.substring(0, 40)}...' : value}'),
        backgroundColor: AppDesignSystem.success,
      ),
    );
  }
}
