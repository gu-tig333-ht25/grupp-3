import 'package:flutter/material.dart';
import 'package:template/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:template/screens/pristrend_screen/pristrend_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ChartProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bostadskollen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
