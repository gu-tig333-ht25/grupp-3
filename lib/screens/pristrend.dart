import 'package:flutter/material.dart';

class PristrendScreen extends StatefulWidget {
  const PristrendScreen({super.key});

  @override
  State<PristrendScreen> createState() => _PristrendScreenState();
}

class _PristrendScreenState extends State<PristrendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Pristrend")));
  }
}
