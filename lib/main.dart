import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:livest/main_page.dart';
import 'package:livest/features/auth/presentation/providers/auth_provider.dart';
import 'package:livest/features/auth/data/auth_repository_impl.dart';
import './app.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kktruowghwbltqrwcden.supabase.co',
    anonKey: 'sb_publishable_6djwNuOhXt5RVIy3b5mp1Q_XP45LA2x',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthRepositoryImpl()),
        ),
      ],
      child: const MaterialApp(debugShowCheckedModeBanner: false, home: App()),
    );
  }
}
