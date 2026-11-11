import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/airin_theme.dart';
import 'features/catalog/presentation/providers.dart';
import 'app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // If .env is not present, ApiService falls back to default baseUrl
  }
  try {
    await initializeDateFormatting('id_ID', null);
  } catch (_) {}
  runApp(const ProviderScope(child: AirinApp()));
}

class AirinApp extends ConsumerWidget {
  const AirinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Airin Store',
      theme: AirinTheme.lightTheme,
      darkTheme: AirinTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
