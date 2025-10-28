import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final double value;
  final String errorValue;
  final VoidCallback onPressed;
  final bool loading;

  const KpiCard({
    super.key,
    required this.title,
    double? value,
    required this.onPressed,
    this.loading = false,
  }) : errorValue = value == null ? "Kunde inte hämta" : "",
       value = value ?? 0;

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
                loading
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CircularProgressIndicator(),
                      )
                    : errorValue.isEmpty
                    ? Text(
                        "${value.toStringAsFixed(2)}%",
                        style: Theme.of(context).textTheme.displaySmall!
                            .copyWith(
                              color: value <= 0
                                  ? const Color.fromARGB(255, 138, 24, 24)
                                  : const Color.fromARGB(255, 68, 155, 71),
                            ),
                      )
                    : Text(
                        errorValue,
                        style: Theme.of(context).textTheme.displaySmall!
                            .copyWith(
                              color: const Color.fromARGB(255, 138, 24, 24),
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
