import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/common/app_loading_widget.dart';
import 'package:flutter_firebase_template/presentation/widgets/qr/branded_qr_code_widget.dart';
import 'package:flutter_firebase_template/presentation/widgets/qr/custom_qr_code_widget.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Displays a QR code with optional title, subtitle, logo overlay, and download/share actions.
class QrDisplayWidget extends StatefulWidget {
  final String qrData;
  final String? title;
  final String? subtitle;
  final double? size;
  final bool isLoading;
  final String? loadingMessage;
  final bool centerContent;
  final EdgeInsetsGeometry? padding;
  /// Optional logo to overlay in the center of the QR (uses branded layout when set).
  final ImageProvider? logoImage;
  final double logoBoxRatio;
  final double logoInnerPadding;

  const QrDisplayWidget({
    super.key,
    required this.qrData,
    this.title,
    this.subtitle,
    this.size,
    this.isLoading = false,
    this.loadingMessage,
    this.centerContent = true,
    this.padding,
    this.logoImage,
    this.logoBoxRatio = 0.24,
    this.logoInnerPadding = 8.0,
  });

  @override
  State<QrDisplayWidget> createState() => _QrDisplayWidgetState();
}

class _QrDisplayWidgetState extends State<QrDisplayWidget> {
  final GlobalKey _fullWidgetKey = GlobalKey();
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    return Container(
      padding: widget.padding ?? EdgeInsets.all(AppDesignSystem.spacing16),
      child: widget.centerContent
          ? _buildCenteredContent(context)
          : _buildContent(context),
    );
  }

  /// Shows loading spinner and message when [isLoading] is true.
  Widget _buildLoadingState() {
    return Container(
      padding: widget.padding ?? EdgeInsets.all(AppDesignSystem.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLoadingWidget(
            message: widget.loadingMessage ?? 'Generating QR code...',
            isFullScreen: false,
          ),
        ],
      ),
    );
  }

  /// Centered column: title, QR, subtitle, then download/share buttons.
  Widget _buildCenteredContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Wrap the entire displayable content (title, QR code, subtitle) in RepaintBoundary
        RepaintBoundary(
          key: _fullWidgetKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.title != null) ...[
                Text(
                  widget.title!,
                  style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDesignSystem.spacing16),
              ],
              _buildQrCode(),
              if (widget.subtitle != null) ...[
                SizedBox(height: AppDesignSystem.spacing16),
                Text(
                  widget.subtitle!,
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: AppDesignSystem.spacing16),
        _buildDownloadButton(context),
      ],
    );
  }

  /// Left-aligned column: title, QR, subtitle, then download/share buttons.
  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wrap the entire displayable content (title, QR code, subtitle) in RepaintBoundary
        RepaintBoundary(
          key: _fullWidgetKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null) ...[
                Text(
                  widget.title!,
                  style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDesignSystem.spacing16),
              ],
              _buildQrCode(),
              if (widget.subtitle != null) ...[
                SizedBox(height: AppDesignSystem.spacing16),
                Text(
                  widget.subtitle!,
                  style: AppTextStyles.bodyLarge,
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: AppDesignSystem.spacing16),
        _buildDownloadButton(context),
      ],
    );
  }

  /// QR code in a white rounded container; branded if [logoImage] is set.
  Widget _buildQrCode() {
    return Container(
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
      child: widget.logoImage != null
          ? BrandedQrWidget(
              data: widget.qrData,
              size: widget.size,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              logoImage: widget.logoImage!,
              logoBoxRatio: widget.logoBoxRatio,
              logoInnerPadding: widget.logoInnerPadding,
            )
          : CustomQrCodeWidget(
              data: widget.qrData,
              size: widget.size,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
    );
  }

  /// Download and share buttons; hidden on web.
  Widget _buildDownloadButton(BuildContext context) {
    // Hide download/share buttons on web platform
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isDownloading ? null : () => _downloadQrCode(context),
                icon: _isDownloading 
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : const Icon(Icons.download),
                label: Text(_isDownloading ? 'Downloading...' : 'Download QR Code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppDesignSystem.primary,
                  foregroundColor: AppDesignSystem.surface,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.spacing16,
                    vertical: AppDesignSystem.spacing12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDesignSystem.spacing12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isDownloading ? null : () => _shareQrCode(context),
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppDesignSystem.primary,
                  side: BorderSide(color: AppDesignSystem.primary),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.spacing16,
                    vertical: AppDesignSystem.spacing12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Captures RepaintBoundary as image and saves to gallery (mobile only).
  Future<void> _downloadQrCode(BuildContext context) async {
    // Only work on mobile platforms
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download feature is only available on mobile devices'),
          backgroundColor: AppDesignSystem.warning,
        ),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    try {
      // Wait for the next frame to ensure the widget is fully rendered before capturing
      await WidgetsBinding.instance.endOfFrame;
      
      // Capture the entire widget (title + QR code + subtitle) as an image
      final RenderRepaintBoundary? boundary = 
          _fullWidgetKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) {
        throw Exception('Unable to capture widget - widget not found');
      }
      
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = 
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save to gallery
      final result = await ImageGallerySaver.saveImage(
        pngBytes,
        quality: 100,
        name: 'qr_code_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (mounted) {
        if (result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('QR code saved to gallery!'),
              backgroundColor: AppDesignSystem.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save QR code'),
              backgroundColor: AppDesignSystem.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppDesignSystem.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  /// Captures RepaintBoundary as image and shares via platform share sheet (mobile only).
  Future<void> _shareQrCode(BuildContext context) async {
    // Only work on mobile platforms
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Share feature is only available on mobile devices'),
          backgroundColor: AppDesignSystem.warning,
        ),
      );
      return;
    }

    try {
      // Wait for the next frame to ensure the widget is fully rendered before capturing
      await WidgetsBinding.instance.endOfFrame;
      
      // Capture the entire widget (title + QR code + subtitle) as an image
      final RenderRepaintBoundary? boundary = 
          _fullWidgetKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) {
        throw Exception('Unable to capture widget - widget not found');
      }
      
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = 
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save to temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes);

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: widget.title != null 
            ? 'QR Code for ${widget.title}'
            : 'QR Code',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing QR code: $e'),
            backgroundColor: AppDesignSystem.error,
          ),
        );
      }
    }
  }
}
