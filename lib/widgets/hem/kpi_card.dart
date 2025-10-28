import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final double value;
  final VoidCallback onPressed;
  final bool showArrow;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.onPressed,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor,
      elevation: 1,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // centrerar texten
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "$value%",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: value <= 0
                        ? const Color.fromARGB(255, 138, 24, 24)
                        : const Color.fromARGB(255, 68, 155, 71),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (showArrow)
            const Icon(
              Icons.keyboard_arrow_right_outlined,
              color: Color.fromARGB(255, 107, 107, 107),
              size: 35,
            ),
        ],
      ),
    );
  }
}
