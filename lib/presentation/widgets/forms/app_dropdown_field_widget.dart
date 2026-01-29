import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

/// A dropdown form field with label, design-system styling, and optional validation.
class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool required;
  final String? hint;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.required = false,
    this.hint,
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
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDesignSystem.spacing16,
              vertical: AppDesignSystem.spacing12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              borderSide: BorderSide(color: AppDesignSystem.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              borderSide: BorderSide(color: AppDesignSystem.error),
            ),
            filled: true,
            fillColor: Colors.transparent,
          ),
          style: AppTextStyles.body,
        ),
      ],
    );
  }
}
