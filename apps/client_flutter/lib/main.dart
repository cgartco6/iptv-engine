import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/tv_focusable_card.dart';
import 'ui/epg_timeline_grid.dart';
import 'features/multiview_grid.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure landscape orientation for TV / Media interfaces
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const SmartIptvApp());
}

class SmartIptvApp extends StatelessWidget {
  const SmartIptvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart IPTV Engine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0E14),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF151921),
          primary: Color(0xFF3B82F6),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedTab = 0;

  final List<Widget> _screens = const [
    EpgTimelineGrid(),
    MultiViewGrid(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail for TV D-Pad Focus
          Container(
            width: 80,
            color: const Color(0xFF151921),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TvFocusableCard(
                  onTap: () => setState(() => _selectedTab = 0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.tv,
                      color: _selectedTab == 0 ? const Color(0xFF3B82F6) : Colors.white54,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TvFocusableCard(
                  onTap: () => setState(() => _selectedTab = 1),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.grid_view,
                      color: _selectedTab == 1 ? const Color(0xFF3B82F6) : Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Dynamic Active Screen Display
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}
