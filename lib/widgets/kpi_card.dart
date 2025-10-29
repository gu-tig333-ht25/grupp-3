import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final double value;
  final String errorValue;
  final VoidCallback onPressed;
  final bool showArrow;
  final bool loading;

  const KpiCard({
    super.key,
    required this.title,
    double? value,
    required this.onPressed,
    this.showArrow = true,
    this.loading = false,
  }) : errorValue = value == null ? "Kunde inte hämta" : "",
       value = value ?? 0;

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
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
                loading
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CircularProgressIndicator(),
                      )
                    : errorValue.isEmpty
                    ? Text(
                        "$value%",
                        style: Theme.of(context).textTheme.displaySmall!
                            .copyWith(
                              color: value <= 0
                                  ? const Color.fromARGB(255, 200, 0, 0)
                                  : const Color.fromARGB(255, 68, 155, 71),
                            ),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        errorValue,
                        style: Theme.of(context).textTheme.displaySmall!
                            .copyWith(
                              color: const Color.fromARGB(255, 200, 0, 0),
                            ),
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
