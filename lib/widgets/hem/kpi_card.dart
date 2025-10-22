import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final double value;
  final VoidCallback onPressed;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromARGB(255, 204, 204, 204),
      elevation: 1,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                Text(
                  "$value%",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: value <= 0
                        ? const Color.fromARGB(255, 138, 24, 24)
                        : const Color.fromARGB(255, 68, 155, 71),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.keyboard_arrow_right_outlined,
            color: const Color.fromARGB(255, 107, 107, 107),
            size: 35,
          ),
        ],
      ),
    );
  }
}
