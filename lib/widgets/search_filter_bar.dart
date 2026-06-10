import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onFilterTap;
  final Widget? filterWidget;

  const SearchFilterBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onFilterTap,
    this.filterWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        if (onFilterTap != null || filterWidget != null) ...[
          const SizedBox(width: 8),
          if (filterWidget != null)
            filterWidget!
          else
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: onFilterTap,
            ),
        ],
      ],
    );
  }
}
