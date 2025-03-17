import 'package:blue_raycargo_id/provider/auth_provider.dart';
import 'package:blue_raycargo_id/provider/customer_provider.dart';
import 'package:blue_raycargo_id/screens/form_address.dart';
import 'package:blue_raycargo_id/screens/home_screens.dart';
import 'package:blue_raycargo_id/screens/login_screens.dart';
import 'package:blue_raycargo_id/screens/mini_register_screens.dart';
import 'package:blue_raycargo_id/screens/profil_screens.dart';
import 'package:blue_raycargo_id/screens/registerM_screens.dart';
import 'package:blue_raycargo_id/screens/verifikasi_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Blue Ray Cargo ID',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF395998)),
            ),
            home: authProvider.isAutentikasi ? HomeScreen() : LoginScreens(),
            routes: {
              '/login': (context) => LoginScreens(),
              '/registerMini': (context) => MiniRegisScreens(),
              '/register_mandatory': (context) => RegisterMScreens(),
              '/verisikasi_kode': (context) => VerifikasiKodeScreens(),
              '/home': (context) => HomeScreen(),
              '/form_address': (context) => FormAddressScreen(),
              '/profil': (context) => ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
