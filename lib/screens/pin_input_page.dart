import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/pin_display.dart';
import '../widgets/number_pad.dart';
import '../services/pin_encryption_service.dart';
import '../services/auth_state_service.dart';

class PinInputPage extends StatefulWidget {
  const PinInputPage({super.key});

  @override
  State<PinInputPage> createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> with SingleTickerProviderStateMixin {
  String _pin = '';
  final int _pinLength = 6;
  bool _isError = false;
  int _wrongAttempts = 0;
  final int _maxAttempts = 5;
  String _errorMessage = '';
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += number;
        _isError = false;
      });

      if (_pin.length == _pinLength) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _isError = false;
      });
    }
  }

  void _onReset() {
    setState(() {
      _pin = '';
      _isError = false;
    });
  }

  Future<void> _verifyPin() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final authState = AuthStateService();

    Future.delayed(const Duration(milliseconds: 300), () async {
      try {
        // Verify PIN using PBKDF2 encryption
        final isValid = await PinEncryptionService.verifyPin(_pin);

        if (isValid) {
          // Set authentication flag in volatile memory
          authState.authenticate();

          // Navigate to secret list screen
          if (mounted) {
            navigator.pushReplacementNamed('/secret-list');
          }
        } else {
          // Wrong PIN - increment attempt counter
          if (mounted) {
            setState(() {
              _wrongAttempts++;
              _isError = true;
            });
          }

          // Shake animation
          _shakeController.forward().then((_) {
            _shakeController.reverse();
          });

          // Check if max attempts reached
          if (_wrongAttempts >= _maxAttempts) {
            // Exit app after 5 failed attempts
            if (mounted) {
              setState(() {
                _errorMessage = 'Too many failed attempts. Exiting app...';
              });
            }
            Future.delayed(const Duration(seconds: 2), () {
              SystemNavigator.pop(); // Exit the app
            });
          } else {
            // Show remaining attempts
            if (mounted) {
              setState(() {
                _errorMessage =
                    'Wrong PIN. ${_maxAttempts - _wrongAttempts} attempts remaining';
              });
            }

            // Reset PIN input after delay
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted) {
                setState(() {
                  _pin = '';
                  _isError = false;
                  _errorMessage = '';
                });
              }
            });
          }
        }
      } catch (e) {
        // Error during verification
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error verifying PIN: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        if (mounted) {
          setState(() {
            _pin = '';
            _isError = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // App Logo/Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Text(
                'Secretum',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Enter your PIN to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 60),

              // PIN Display
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final offset = _shakeController.value * 10;
                  return Transform.translate(
                    offset: Offset(
                      offset * (1 - (2 * (_shakeController.value - 0.5)).abs()),
                      0,
                    ),
                    child: PinDisplay(
                      pinLength: _pinLength,
                      currentLength: _pin.length,
                      isError: _isError,
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Error Message
              SizedBox(
                height: 24,
                child: _errorMessage.isNotEmpty
                    ? Text(
                        _errorMessage,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : null,
              ),

              const Spacer(),

              // Number Pad
              NumberPad(
                onNumberPressed: _onNumberPressed,
                onBackspace: _onBackspace,
                onReset: _onReset,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
