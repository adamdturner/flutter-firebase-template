import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

class AppFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool required;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final String? helperText;
  final String? errorText;

  const AppFormField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.required = false,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.contentPadding,
    this.helperText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
              children: required
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: AppDesignSystem.error,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]
                  : [],
            ),
          ),
          SizedBox(height: AppDesignSystem.spacing8),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          focusNode: focusNode,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            helperText: helperText,
            errorText: errorText,
            contentPadding: contentPadding ?? EdgeInsets.symmetric(
              horizontal: AppDesignSystem.spacing16,
              vertical: AppDesignSystem.spacing12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              borderSide: BorderSide(
                color: AppDesignSystem.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              borderSide: BorderSide(
                color: AppDesignSystem.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              borderSide: BorderSide(
                color: AppDesignSystem.error,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            filled: true,
            fillColor: enabled 
                ? Colors.transparent 
                : Colors.grey.shade100,
          ),
        ),
      ],
    );
  }
}

class AppFormFieldWithIcon extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool required;
  final IconData icon;
  final Widget? suffixIcon;
  final VoidCallback? onIconTap;
  final int? maxLines;
  final bool enabled;
  final Function(String)? onChanged;

  const AppFormFieldWithIcon({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.required = false,
    required this.icon,
    this.suffixIcon,
    this.onIconTap,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppFormField(
      label: label,
      hint: hint,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      required: required,
      maxLines: maxLines,
      enabled: enabled,
      onChanged: onChanged,
      prefixIcon: GestureDetector(
        onTap: onIconTap,
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }
}

class AppSearchField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool showClearButton;

  const AppSearchField({
    super.key,
    this.hint = "Search...",
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppFormField(
      label: "",
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      prefixIcon: Icon(
        Icons.search,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      suffixIcon: showClearButton && controller.text.isNotEmpty
          ? IconButton(
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              onPressed: () {
                controller.clear();
                onClear?.call();
              },
            )
          : null,
    );
  }
}
