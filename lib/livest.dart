import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:livest/core/config/supabase_config.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Livest extends StatefulWidget {
  const Livest({super.key});

  static final Completer<void> supabaseReady = Completer<void>();

  @override
  State<Livest> createState() => _LivestState();
}

class _LivestState extends State<Livest> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _initSupabase();
  }

  Future<void> _initSupabase() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    if (!Livest.supabaseReady.isCompleted) {
      Livest.supabaseReady.complete();
    }

    if (!mounted) return;

    _authSubscription = SupabaseConfig.client.auth.onAuthStateChange.listen((
      data,
    ) {
      final event = data.event;

      if (event == AuthChangeEvent.initialSession) return;

      if (event == AuthChangeEvent.signedOut) {
        _navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteGenerator.splash,
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      theme: LivestAppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: RouteGenerator.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
