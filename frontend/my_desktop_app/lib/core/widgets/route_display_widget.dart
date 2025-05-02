import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteDisplayWidget extends ConsumerWidget {
  final String routeText;
  final String? subRouteText;
  final Function()? routeTextClick;
  const RouteDisplayWidget({
    super.key,
    this.subRouteText,
    required this.routeText,
    this.routeTextClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final routeStyle = theme.textTheme.bodySmall?.copyWith(
      // color: Colors.blue.shade700, // Updated color
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: routeText,
            style: routeStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = routeTextClick
          ),
          if (subRouteText != null)
            TextSpan(
              text: ' / ',
              style: routeStyle,
            ),
          if (subRouteText != null)
            TextSpan(
              text: subRouteText,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade800,
              ),
            ),
        ],
      ),
    );
  }
}
