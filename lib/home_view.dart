import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const EventChannel _eventChannel = EventChannel('shake_event');
  StreamSubscription? _shakeSubscription;
  String _currentQuote = 'Shake the phone to get a random quote';

  final List<String> quotes = [
    "Believe you can and you're halfway there.",
    "Dream big, work hard, stay humble.",
    "Success is not final, failure is not fatal.",
    "Push yourself, because no one else will.",
    "The harder you work, the luckier you get.",
  ];
  @override
  void initState() {
    super.initState();
    _startListeningForShake();
  }

  void _startListeningForShake() {
    _shakeSubscription = _eventChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        _showRandomQuote();
      });
    });
  }

  void _showRandomQuote() {
    setState(() {
      _currentQuote = quotes[Random().nextInt(quotes.length)];
    });
  }

  @override
  void dispose() {
    _shakeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shake to get a random quote')),
      body: Center(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          child: Text(
            _currentQuote,
            key: ValueKey(_currentQuote),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
