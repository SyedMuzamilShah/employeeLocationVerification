import 'package:sidebarx/sidebarx.dart';
import 'package:flutter/material.dart';

mySidebarXExtendedTheme(BuildContext context) => SidebarXTheme(
      width: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
      ),
    );

SidebarXTheme mySidebarXTheme(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return SidebarXTheme(
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: colorScheme.surface.withValues(alpha: 0.95), // Softer base color
      borderRadius: BorderRadius.circular(16),
    ),
    hoverColor: colorScheme.primary.withValues(alpha: 0.05),
    textStyle: theme.textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurface.withValues(alpha: 0.7),
    ),
    selectedTextStyle: theme.textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w600,
    ),
    hoverTextStyle: theme.textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w500,
    ),
    itemTextPadding: const EdgeInsets.only(left: 24),
    selectedItemTextPadding: const EdgeInsets.only(left: 24),
    itemDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: colorScheme.surface),
    ),
    selectedItemDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        colors: [
          colorScheme.primary.withValues(alpha: 0.2),
          // colorScheme.primary.withValues(alpha: 0.3),
          colorScheme.primary.withValues(alpha: 0.2),
        ],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        )
      ],
    ),
    iconTheme: IconThemeData(
      color: colorScheme.onSurface.withValues(alpha: 0.6),
      size: 22,
    ),
    selectedIconTheme: IconThemeData(
      color: colorScheme.primary,
      size: 22,
    ),
  );
}




// const primaryColor = Color(0xFF685BFF);
// const canvasColor = Color(0xFF2E2E48);
// const scaffoldBackgroundColor = Color(0xFF464667);
// const accentCanvasColor = Color(0xFF3E3E61);
// const white = Colors.white;
// final actionColor = const Color(0xFF5F5FA7).withValues(alpha: 0.6);
// final divider = Divider(color: white.withValues(alpha: 0.3), height: 1);