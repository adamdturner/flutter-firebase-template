import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

class IconWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const IconWidget({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.padding,
    this.backgroundColor,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: padding ?? const EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: backgroundColor ?? 
               (isDark ? AppDesignSystem.surfaceDarkSecondary : AppDesignSystem.surface),
        borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
        boxShadow: boxShadow ?? 
                   (isDark ? AppDesignSystem.shadowSmallDark : AppDesignSystem.shadowSmall),
        border: border ?? 
                (isDark ? Border.all(color: AppDesignSystem.onSurfaceDarkTertiary.withOpacity(0.3)) : null),
      ),
      child: Image.asset(
        'assets/icons/Penguin-Icon-256.png',
        height: height ?? 80,
        width: width ?? 80,
        fit: fit,
      ),
    );
  }
}
