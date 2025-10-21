import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/pin_display.dart';
import '../widgets/number_pad.dart';
import '../services/pin_encryption_service.dart';
import '../services/auth_state_service.dart';
import '../services/encryption_key_service.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  String _firstPin = '';
  final int _pinLength = 6;
  bool _isConfirming = false;
  bool _isError = false;
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
        _handlePinComplete();
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

  void _handlePinComplete() {
    if (!_isConfirming) {
      // First PIN entry - move to confirmation
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _firstPin = _pin;
          _pin = '';
          _isConfirming = true;
        });
      });
    } else {
      // Second PIN entry - verify match
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_pin == _firstPin) {
          // PINs match - success
          _showSuccessAndNavigate();
        } else {
          // PINs don't match - show error and reset
          _showMismatchError();
        }
      });
    }
  }

  Future<void> _showSuccessAndNavigate() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final authState = AuthStateService();

    try {
      // Save encrypted PIN using PBKDF2
      await PinEncryptionService.savePin(_firstPin);

      // Generate and save AES-256-GCM encryption key
      await EncryptionKeyService.generateAndSaveKey();

      // Mark as not first run
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_first_run', false);

      // Set authentication flag in volatile memory
      authState.authenticate();

      // Navigate to secret list screen immediately
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/secret-list');
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error saving PIN: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showMismatchError() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });

    setState(() {
      _isError = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _pin = '';
        _firstPin = '';
        _isConfirming = false;
        _isError = false;
      });
    });
  }

  String _getTitle() {
    if (!_isConfirming) {
      return 'Create your PIN';
    } else {
      return 'Confirm your PIN';
    }
  }

  String _getSubtitle() {
    if (!_isConfirming) {
      return 'Enter a 6-digit PIN';
    } else {
      return 'Enter the same PIN again';
    }
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
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isConfirming ? Icons.lock_outline : Icons.lock_open,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                _getTitle(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                _getSubtitle(),
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
