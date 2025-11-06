import 'package:flutter/material.dart';
import 'package:shake_quote_app/home_view.dart';

void main() {
  runApp(const ShakeQuoteApp());
}

class ShakeQuoteApp extends StatelessWidget {
  const ShakeQuoteApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeView(),
    );
  }
}
