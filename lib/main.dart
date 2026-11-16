import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/cart_store.dart';
import 'screens/login_page.dart';
import 'screens/shop_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final cartBox = await Hive.openBox<dynamic>('cart');
  final preferences = await SharedPreferences.getInstance();

  runApp(StoreApp(preferences: preferences, cartBox: cartBox));
}

class StoreApp extends StatefulWidget {
  const StoreApp({super.key, required this.preferences, required this.cartBox});

  final SharedPreferences preferences;
  final Box<dynamic> cartBox;

  @override
  State<StoreApp> createState() => _StoreAppState();
}

class _StoreAppState extends State<StoreApp> {
  late String? _username = widget.preferences.getString('username');

  Future<void> _login(String username) async {
    await widget.preferences.setString('username', username);
    if (mounted) setState(() => _username = username);
  }

  Future<void> _logout() async {
    await widget.preferences.remove('username');
    if (mounted) setState(() => _username = null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruang Belanja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF167D6E),
          surface: const Color(0xFFF7F8F5),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8F5),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: _username == null
          ? LoginPage(onLogin: _login)
          : ShopShell(
              username: _username!,
              cartStore: CartStore(widget.cartBox),
              onLogout: _logout,
            ),
    );
  }
}
