import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/movie_search/presentation/pages/home_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'core/themes/app_theme.dart';
import 'core/network/connectivity_service.dart';
import 'core/widgets/no_internet_widget.dart';

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
        home: const ConnectivityWrapper(child: HomePage()),
      ),
    );
  }
}

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);

    return StreamBuilder<bool>(
      stream: connectivityService.connectionStatusStream,
      builder: (context, snapshot) {
        // If we have data and are connected, show the normal app content
        if (snapshot.hasData && snapshot.data == true) {
          return child;
        }

        // If we have data but are not connected, show the no internet widget
        if (snapshot.hasData && snapshot.data == false) {
          return Scaffold(
            body: NoInternetWidget(
              onRetry: () async {
                // This will trigger a UI refresh if connectivity has changed
                final isConnected = await connectivityService.isConnected();
                if (isConnected && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ইন্টারনেট সংযোগ পুনরুদ্ধার করা হয়েছে'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          );
        }

        // If we're still waiting for data, show a loading indicator
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
