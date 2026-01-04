import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/logic/database_switch/env_cubit.dart';
import 'package:flutter_firebase_template/envdb.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      title: BlocBuilder<EnvCubit, Env>(
        builder: (context, env) {
          if (env == Env.sandbox) {
            // When in demo mode, use custom layout with centered title
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Demo Mode Indicator
                Container(
                  margin: const EdgeInsets.only(right: AppDesignSystem.spacing8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.spacing8,
                    vertical: AppDesignSystem.spacing4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade400,
                        Colors.orange.shade600,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: AppDesignSystem.iconSmall,
                      ),
                      const SizedBox(width: AppDesignSystem.spacing4),
                      Text(
                        'DEMO',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Title - Flexible to prevent overflow
                Flexible(
                  child: Text(
                    title,
                    style: AppTextStyles.heading3.copyWith(
                      color: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            );
          } else {
            // When not in demo mode, just show the centered title with overflow handling
            return Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                color: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            );
          }
        },
      ),
      backgroundColor: isDark ? AppDesignSystem.surfaceDarkSecondary : AppDesignSystem.surface,
      foregroundColor: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
      centerTitle: centerTitle,
      elevation: 0,
      actions: actions,
      // Need to default to an empty leading widget because Flutter's AppBar will automatically show a back button when leading is null and there are routes to pop.
      leading: leading ?? (showBackButton ? _buildBackButton(context) : const SizedBox.shrink()),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
    );
  }

  Widget? _buildBackButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
        size: AppDesignSystem.iconMedium,
      ),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      tooltip: 'Back',
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
