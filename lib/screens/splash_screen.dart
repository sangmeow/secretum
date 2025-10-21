import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/pin_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    // Wait for 1 second
    await Future.delayed(const Duration(seconds: 1));

    // Check if this is the first run
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('is_first_run') ?? true;

    if (!mounted) return;

    if (isFirstRun) {
      // First run - navigate to PIN setup
      Navigator.of(context).pushReplacementNamed(PinRouter.pinSetup);
    } else {
      // Not first run - navigate to PIN input
      Navigator.of(context).pushReplacementNamed(PinRouter.pinInput);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SECRETUM',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF5F5F5),
                letterSpacing: 4.0,
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              color: Color(0xFF6C63FF),
            ),
          ],
        ),
      ),
    );
  }
}
