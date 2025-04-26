import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/movie_search/presentation/pages/home_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'core/themes/app_theme.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize dependencies
  await di.init();
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use MultiProvider to provide the necessary providers down the widget tree
    return MultiProvider(
      providers: createProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie Search App',
        theme: AppTheme.getTheme(),
        home: const HomePage(),
      ),
    );
  }
}
