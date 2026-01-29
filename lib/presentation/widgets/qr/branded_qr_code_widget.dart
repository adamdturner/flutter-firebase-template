import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/core/utils/device_utils.dart';

/// QR code with a centered logo overlay in a white box; uses high error correction.
class BrandedQrWidget extends StatelessWidget {
  final String data;
  final double? size;
  final Color foregroundColor;
  final Color backgroundColor;
  final ImageProvider logoImage;
  final double logoBoxRatio;
  final double logoInnerPadding;
  final int version;
  final int errorCorrection;

  const BrandedQrWidget({
    super.key,
    required this.data,
    required this.logoImage,
    this.size,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.logoBoxRatio = 0.28,
    this.logoInnerPadding = 6.0,
    this.version = QrVersions.auto,
    this.errorCorrection = 3,
  });

  @override
  Widget build(BuildContext context) {
    final double qrSize = (size ?? 300.0) * DeviceUtils.scaleFactor;
    final double boxSize = qrSize * logoBoxRatio;

    return Container(
      color: backgroundColor, // outer background
      child: SizedBox(
        width: qrSize,
        height: qrSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. The QR code itself
            QrImageView(
              data: data,
              size: qrSize,
              version: version,
              errorCorrectionLevel: errorCorrection,
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: foregroundColor,
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: foregroundColor,
              ),
              backgroundColor: backgroundColor,
            ),

            // 2. White rounded box to hide modules under the logo
            Container(
              width: boxSize,
              height: boxSize,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
                border: Border.all(
                  color: foregroundColor,
                  width: 1, // thin ring helps it feel intentional/“badge-y”
                ),
              ),
            ),

            // 3. Actual logo inside that box
            Padding(
              padding: EdgeInsets.all(logoInnerPadding),
              child: Image(
                image: logoImage,
                width: boxSize,
                height: boxSize,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
