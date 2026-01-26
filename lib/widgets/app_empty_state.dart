import 'package:flutter/material.dart';
import 'package:openiothub/configs/consts.dart';
import 'package:openiothub/utils/theme_utils.dart';

/// 统一空状态组件：插图 + 提示文案 + 可选主/次按钮
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
          minHeight: MediaQuery.sizeOf(context).height - LayoutConstants.emptyStateMinHeightOffset,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.spacingLg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: LayoutConstants.emptyIllustrationSize,
                  height: LayoutConstants.emptyIllustrationSize,
                  child: Image.asset(illustration, fit: BoxFit.contain),
                ),
                const SizedBox(height: LayoutConstants.emptyStateSpacing),
                Text(
                  message,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (primaryLabel != null && onPrimaryTap != null) ...[
                  const SizedBox(height: LayoutConstants.emptyStateButtonSpacing),
                  FilledButton.icon(
                    onPressed: onPrimaryTap,
                    icon: Icon(primaryIcon ?? Icons.add, size: 20),
                    label: Text(primaryLabel!),
                  ),
                ],
                if (secondaryLabel != null && onSecondaryTap != null) ...[
                  const SizedBox(height: LayoutConstants.emptyStateButtonSpacing),
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
