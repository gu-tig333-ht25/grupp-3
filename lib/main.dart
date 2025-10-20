import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/providers/news_provider.dart';
import 'package:template/screens/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()..loadNews()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bostadskollen',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
