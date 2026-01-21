import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth_screen.dart';
import 'screens/breastfeeding_tracker_screen.dart';

/// Ponto de entrada do aplicativo
void main() {
  // Configurar a orientação para retrato
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const AppAmamenta());
}

/// Widget principal do aplicativo
class AppAmamenta extends StatelessWidget {
  const AppAmamenta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Amamenta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Definir tema escuro com cores personalizadas
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2D1B36),
        scaffoldBackgroundColor: const Color(0xFF2D1B36),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF4081),
          secondary: Color(0xFF9C27B0),
          surface: Color(0xFF3D2A47),
        ),
        // Definir fontes
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF4081),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ),
      // Tela inicial do app (Login/Cadastro)
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),
        '/home': (context) => const BreastfeedingTrackerScreen(),
      },
    );
  }
}
