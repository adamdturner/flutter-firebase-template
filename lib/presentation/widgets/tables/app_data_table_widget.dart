import 'package:flutter/material.dart';

import 'package:flutter_firebase_template/core/design_system.dart';

/// A reusable data table with optional header row and design-system styling.
class AppDataTable extends StatelessWidget {
  /// Optional column header labels; if provided, first row is styled as header.
  final List<String>? headers;

  /// Each inner list is one row of cell widgets (length should match [headers] or be consistent).
  final List<List<Widget>> rows;

  /// When true, first column cells use secondary text style (e.g. for row labels).
  final bool firstColumnIsLabel;

  /// Reduces vertical padding for a denser table.
  final bool dense;

  /// Whether to draw borders around cells.
  final bool showBorders;

  final EdgeInsets? cellPadding;

  const AppDataTable({
    super.key,
    this.headers,
    required this.rows,
    this.firstColumnIsLabel = false,
    this.dense = false,
    this.showBorders = true,
    this.cellPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final padding = cellPadding ??
        EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spacing12,
          vertical: dense ? AppDesignSystem.spacing8 : AppDesignSystem.spacing12,
        );
    final headerBg = isDark
        ? AppDesignSystem.surfaceDarkTertiary
        : AppDesignSystem.lightSurfaceTertiary;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    final tableRows = <TableRow>[];

    if (headers != null && headers!.isNotEmpty) {
      tableRows.add(
        TableRow(
          decoration: BoxDecoration(color: headerBg),
          children: headers!
              .map(
                (h) => _tableCell(
                  context,
                  padding: padding,
                  child: Text(
                    h,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  useLabelStyle: false,
                  theme: theme,
                ),
              )
              .toList(),
        ),
      );
    }

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      tableRows.add(
        TableRow(
          children: row.asMap().entries.map((entry) {
            final isFirst = entry.key == 0;
            return _tableCell(
              context,
              padding: padding,
              child: entry.value,
              useLabelStyle: firstColumnIsLabel && isFirst,
              theme: theme,
            );
          }).toList(),
        ),
      );
    }

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: showBorders
          ? TableBorder(
              horizontalInside: BorderSide(color: borderColor),
              verticalInside: BorderSide(color: borderColor),
              left: BorderSide(color: borderColor),
              right: BorderSide(color: borderColor),
              top: BorderSide(color: borderColor),
              bottom: BorderSide(color: borderColor),
            )
          : null,
      children: tableRows,
    );
  }

  /// Builds a table cell with padding; first column can use label text style.
  Widget _tableCell(
    BuildContext context, {
    required EdgeInsets padding,
    required Widget child,
    bool useLabelStyle = false,
    ThemeData? theme,
  }) {
    final t = theme ?? Theme.of(context);
    final effectiveChild = useLabelStyle
        ? DefaultTextStyle(
            style: AppTextStyles.caption.copyWith(
              color: t.colorScheme.onSurface.withOpacity(0.8),
            ),
            child: child,
          )
        : child;
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: padding,
        child: effectiveChild,
      ),
    );
  }
}
