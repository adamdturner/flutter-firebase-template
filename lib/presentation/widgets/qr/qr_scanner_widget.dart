import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:flutter_firebase_template/core/design_system.dart';

/// Camera-based QR/barcode scanner with optional border overlay; uses [MobileScannerController].
class QrScannerWidget extends StatefulWidget {
  final void Function(String value) onScanned;
  final MobileScannerController controller;
  final bool showScanningOverlay;

  const QrScannerWidget({
    super.key,
    required this.onScanned,
    required this.controller,
    this.showScanningOverlay = true,
  });

  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
        child: Stack(
          children: [
            MobileScanner(
              controller: widget.controller,
              onDetect: (capture) {
                for (final barcode in capture.barcodes) {
                  final value = barcode.rawValue;
                  if (value != null && value.isNotEmpty) {
                    widget.onScanned(value);
                    break;
                  }
                }
              },
            ),
            if (widget.showScanningOverlay) _buildBorderOverlay(),
          ],
        ),
      ),
    );
  }

  /// Optional primary-colored border overlay around the scan area.
  Widget _buildBorderOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
          border: Border.all(
            color: AppDesignSystem.primary,
            width: 4,
          ),
        ),
      ),
    );
  }
}
