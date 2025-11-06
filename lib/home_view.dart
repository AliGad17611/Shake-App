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
  static const MethodChannel _methodChannel = MethodChannel('shake_control');
  StreamSubscription? _shakeSubscription;
  String _currentQuote = 'Tap the start button to begin listening for shakes';
  bool _isListening = false;

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
  }

  Future<void> _startListening() async {
    try {
      final result = await _methodChannel.invokeMethod('startListening');
      if (result == 'Listening started') {
        setState(() {
          _isListening = true;
          _currentQuote = 'Shake the phone to get a random quote!';
        });
        _shakeSubscription = _eventChannel.receiveBroadcastStream().listen((
          event,
        ) {
          setState(() {
            _showRandomQuote();
          });
        });
      }
    } catch (e) {
      setState(() {
        _currentQuote = 'Failed to start listening: $e';
      });
    }
  }

  Future<void> _stopListening() async {
    try {
      final result = await _methodChannel.invokeMethod('stopListening');
      if (result == 'Listening stopped') {
        setState(() {
          _isListening = false;
          _currentQuote = 'Listening stopped. Tap start to begin again.';
        });
        _shakeSubscription?.cancel();
        _shakeSubscription = null;
      }
    } catch (e) {
      setState(() {
        _currentQuote = 'Failed to stop listening: $e';
      });
    }
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
      appBar: AppBar(
        title: const Text('Shake Quote App'),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: (_isListening ? Colors.green : Colors.grey).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isListening ? Colors.green : Colors.grey,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isListening ? Icons.vibration : Icons.vibration_outlined,
                      color: _isListening ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isListening ? 'Listening' : 'Not Listening',
                      style: TextStyle(
                        color: _isListening ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Quote display
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Container(
                      key: ValueKey(_currentQuote),
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        _currentQuote,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isListening ? null : _startListening,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Listening'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _isListening ? _stopListening : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Listening'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Instructions
              Text(
                _isListening
                    ? 'Shake your phone to get a new quote!'
                    : 'Tap "Start Listening" to begin',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
