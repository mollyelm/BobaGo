import 'package:flutter/material.dart';
import 'package:boba_go/main.dart';
import 'package:boba_go/settings_page.dart';
import 'package:boba_go/statistics.dart';
import 'package:boba_go/tutorial.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    if (GameStats.sessionStartTime == null) {
      GameStats.initializeStats();
    }
  }

  @override
  void dispose() {
    GameStats.updateSessionTime();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      GameStats.updateSessionTime();
    } else if (state == AppLifecycleState.resumed) {
      GameStats.sessionStartTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boba Go!',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown.shade50),
        scaffoldBackgroundColor: Colors.pink[100],
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/homepage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Boba Go!',
                style: TextStyle(
                  fontSize: 85,
                  color: Colors.brown.shade900,
                ),
              ),
              const SizedBox(height: 15),
              // Play Button
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const GamePanel()),
                    );
                  },
                  child: const Text(
                    'Play',
                    style: TextStyle(fontSize: 30, color: Colors.brown),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Settings Button
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                  child: const Text(
                    'Settings',
                    style: TextStyle(fontSize: 30, color: Colors.brown),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Statistics Button
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StatisticsPage()),
                    );
                  },
                  child: const Text(
                    'Statistics',
                    style: TextStyle(fontSize: 30, color: Colors.brown),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TutorialPage()),
                    );
                  },
                  child: const Text(
                    'Tutorial',
                    style: TextStyle(fontSize: 30, color: Colors.brown),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}