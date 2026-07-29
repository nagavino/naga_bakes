import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local storage with silent auto-recovery
  try {
    await Hive.initFlutter();
  } catch (_) {
    // If Hive init fails, ensure binding is handled cleanly
  }

  runApp(const ProviderScope(child: NagaBakesApp()));
}

class NagaBakesApp extends ConsumerStatefulWidget {
  const NagaBakesApp({super.key});

  @override
  ConsumerState<NagaBakesApp> createState() => _NagaBakesAppState();
}

class _NagaBakesAppState extends ConsumerState<NagaBakesApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Naga Bakes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _appRouter.config(),
    );
  }
}
