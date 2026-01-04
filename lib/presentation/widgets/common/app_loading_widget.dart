import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

class AppLoadingWidget extends StatelessWidget {
  final String? message;
  final bool isFullScreen;
  final Color? color;
  final double? size;
  final bool showMessage;

  const AppLoadingWidget({
    super.key,
    this.message,
    this.isFullScreen = false,
    this.color,
    this.size,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loadingColor = color ?? theme.colorScheme.primary;
    final loadingSize = size ?? AppDesignSystem.iconLarge;

    final loadingWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: loadingSize,
          height: loadingSize,
          child: CircularProgressIndicator(
            color: loadingColor,
            strokeWidth: 3.0,
          ),
        ),
        if (showMessage && message != null) ...[
          SizedBox(height: AppDesignSystem.spacing16),
          Text(
            message!,
            style: AppTextStyles.body.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (isFullScreen) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(AppDesignSystem.spacing24),
            child: loadingWidget,
          ),
        ),
      );
    }

    return Center(
      child: loadingWidget,
    );
  }
}

class AppLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;
  final Color? overlayColor;

  const AppLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withOpacity(0.3),
            child: AppLoadingWidget(
              message: message,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
