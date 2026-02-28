import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:livest/core/config/supabase_config.dart';
import 'package:livest/core/routes/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.anonKey,
  );
  runApp(const LivestApp());
}

class LivestApp extends StatefulWidget {
  const LivestApp({super.key});
  @override
  State<LivestApp> createState() => _LivestAppState();
}

class _LivestAppState extends State<LivestApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    SupabaseConfig.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.signedOut) {
        _navigatorKey.currentState?.pushNamedAndRemoveUntil(RouteGenerator.splash, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFFFDFDFD)),
      initialRoute: RouteGenerator.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}