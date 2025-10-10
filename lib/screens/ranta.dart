import 'package:flutter/material.dart';

class RantaScreen extends StatefulWidget {
  const RantaScreen({super.key});

  @override
  State<RantaScreen> createState() => _RantaScreenState();
}

class _RantaScreenState extends State<RantaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Ränta")));
  }
}
