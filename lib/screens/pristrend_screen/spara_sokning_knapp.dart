import 'package:flutter/material.dart';

class SaveSearchButton extends StatelessWidget {
  const SaveSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: () {
          debugPrint("Knappen tryckt!");
        },
        child: const Text(
          "Spara sökning",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
