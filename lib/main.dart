import 'package:flutter/material.dart';
import 'AppLocalizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'customer/page/customer_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale = const Locale("en", "CA");

  void changeLanguage(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale("en", "CA"),
        Locale("bn"),
        Locale("zh"),
        Locale("ko"),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _locale,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/customer': (context) => CustomerListPage(),
        '/car': (context) => DummyPage(title: "Car Page"),
        '/boat': (context) => DummyPage(title: "Boat Page"),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Menu", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) {
              if (value == "en")
                MyApp.setLocale(context, const Locale("en", "CA"));
              if (value == "ko") MyApp.setLocale(context, const Locale("ko"));
              if (value == "zh") MyApp.setLocale(context, const Locale("zh"));
              if (value == "bn") MyApp.setLocale(context, const Locale("bn"));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "en", child: Text("English")),
              const PopupMenuItem(value: "ko", child: Text("한국어")),
              const PopupMenuItem(value: "zh", child: Text("中文")),
              const PopupMenuItem(value: "bn", child: Text("বাংলা")),
            ],
          ),
        ],
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.translate("TextSelect")!,
                style: const TextStyle(fontSize: 26),
              ),

              const SizedBox(height: 40),

              _menuButton(context, "Car List", "/car"),
              const SizedBox(height: 16),

              _menuButton(context, "Boat Page", "/boat"),
              const SizedBox(height: 16),

              _menuButton(context, "Settings", "/settings"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String label, String route) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(label),
    );
  }
}

// Simple placeholder pages for clean navigation
class DummyPage extends StatelessWidget {
  final String title;
  const DummyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title, style: TextStyle(fontSize: 22))),
    );
  }
}
