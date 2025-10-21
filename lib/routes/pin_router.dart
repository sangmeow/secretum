import 'package:flutter/material.dart';
import '../screens/pin_input_page.dart';
import '../screens/pin_setup_page.dart';

class PinRouter extends StatelessWidget {
  const PinRouter({super.key});

  static const String pinInput = '/pin-input';
  static const String pinSetup = '/pin-setup';

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case pinSetup:
            builder = (BuildContext context) => const PinSetupPage();
            break;
          case pinInput:
          default:
            builder = (BuildContext context) => const PinInputPage();
            break;
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }

  // Navigation helpers
  static void navigateToSetup(BuildContext context) {
    Navigator.of(context).pushNamed(pinSetup);
  }

  static void navigateToInput(BuildContext context) {
    Navigator.of(context).pushNamed(pinInput);
  }
}
