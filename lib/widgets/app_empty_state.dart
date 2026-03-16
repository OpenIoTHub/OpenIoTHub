import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.message,
    this.primaryLabel,
    this.primaryIcon,
    this.onPrimaryTap,
    this.secondaryLabel,
    this.onSecondaryTap,
  });

  final String message;
  final String? primaryLabel;
  final IconData? primaryIcon;
  final VoidCallback? onPrimaryTap;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ThemeUtils.isDarkMode(context);
    final illustration = isDark
        ? 'assets/images/empty_list_black.png'
        : 'assets/images/empty_list.png';

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height - AppSpacing.emptyStateMinHeightOffset,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: AppSpacing.emptyIllustrationSize,
                  height: AppSpacing.emptyIllustrationSize,
                  child: Image.asset(illustration, fit: BoxFit.contain),
                ),
                const SizedBox(height: AppSpacing.emptyStateSpacing),
                Text(
                  message,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (primaryLabel != null && onPrimaryTap != null) ...[
                  const SizedBox(height: AppSpacing.emptyStateButtonSpacing),
                  FilledButton.icon(
                    onPressed: onPrimaryTap,
                    icon: Icon(primaryIcon ?? Icons.add, size: 20),
                    label: Text(primaryLabel!),
                  ),
                ],
                if (secondaryLabel != null && onSecondaryTap != null) ...[
                  const SizedBox(height: AppSpacing.emptyStateButtonSpacing),
                  OutlinedButton(
                    onPressed: onSecondaryTap,
                    child: Text(secondaryLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
