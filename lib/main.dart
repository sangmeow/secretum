import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/splash_screen.dart';
import 'screens/pin_input_page.dart';
import 'screens/pin_setup_page.dart';
import 'screens/secret_list_page.dart';
import 'screens/secret_edit_page.dart';
import 'routes/pin_router.dart';
// import 'utils/clear_secure_storage.dart';

/// Main entry point of the Secretum application
/// Initializes required services and runs the app
void main() async {
  // Ensure Flutter bindings are initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database for local storage
  await Hive.initFlutter();
  // Open the 'secretum' box to store encrypted secrets
  await Hive.openBox('secretum');

  // Clear all storage (FlutterSecureStorage + SharedPreferences + Hive) for development/testing
  // COMMENTED OUT: Uncomment only when you need to reset the app completely
  // await clearAllStorage();

  // Configure system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SecretumApp());
}

/// Root widget of the Secretum application
/// Configures theme and routing for the entire app
class SecretumApp extends StatelessWidget {
  const SecretumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secretum',
      debugShowCheckedModeBanner: false,
      // Dark theme configuration
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        primaryColor: const Color(0xFF6C63FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFF8B83FF),
          surface: Color(0xFF1D1E33),
        ),
        useMaterial3: true,
      ),
      // Initial screen is the splash screen
      home: const SplashScreen(),
      // Define named routes for navigation
      routes: {
        PinRouter.pinInput: (context) => const PinInputPage(),
        PinRouter.pinSetup: (context) => const PinSetupPage(),
        '/secret-list': (context) => const SecretListPage(),
        '/secret-edit': (context) => const SecretEditPage(),
      },
    );
  }
}
