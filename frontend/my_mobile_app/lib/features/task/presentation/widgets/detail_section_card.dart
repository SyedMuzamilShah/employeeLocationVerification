import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class DetailSectionCard extends StatelessWidget {
  final List<DetailItem> items;

  const DetailSectionCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: items
              .map((item) => _buildDetailRow(context, item))
              .expand((widget) => [widget, Divider(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4), height: 16,)])
              .toList()
            ..removeLast(),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, DetailItem item) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: item.isMultiLine
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            item.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          // child: Text(
          //   item.value,
          //   style: theme.textTheme.bodyMedium?.copyWith(
          //     color: item.isHighlighted
          //         ? theme.colorScheme.primary
          //         : theme.colorScheme.onSurface,
          //     fontWeight: item.isHighlighted ? FontWeight.bold : FontWeight.normal,
          //   ),
          // ),
          child: ReadMoreText(
            item.value,
            // trimLines: item.isMultiLine ? 2 : 1,
            trimLines: 1,
            style: TextStyle(
              color: item.isHighlighted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
              fontWeight:
                  item.isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class DetailItem {
  final String label;
  final String value;
  final bool isMultiLine;
  final bool isHighlighted;

  DetailItem({
    required this.label,
    required this.value,
    this.isMultiLine = false,
    this.isHighlighted = false,
  });
}
