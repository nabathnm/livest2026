import 'dart:async';
import 'package:flutter/material.dart';
import 'package:livest/core/config/supabase_config.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Livest extends StatefulWidget {
  const Livest({super.key});

  @override
  State<Livest> createState() => _LivestState();
}

class _LivestState extends State<Livest> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    _authSubscription = SupabaseConfig.client.auth.onAuthStateChange.listen((
      data,
    ) {
      final event = data.event;

      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.signedOut) {
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
