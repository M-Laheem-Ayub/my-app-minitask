import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../tabs/notifications_tab.dart';
import '../tabs/photo_tab.dart';
import '../tabs/text_tab.dart';
import '../../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _tabs = const [NotificationsTab(), PhotoTab(), TextTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.barsStaggered,
              color: Color(0xFF3361c3),
              size: 20,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: AppDrawer(
        selectedIndex: _index,
        onTabSelected: (index) => setState(() => _index = index),
      ),
      body: _tabs[_index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
              spreadRadius: 2,
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: const Color(0xFF3361c3).withOpacity(0.15),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            destinations: [
              NavigationDestination(
                icon: FaIcon(
                  FontAwesomeIcons.bell,
                  size: 20,
                  color: _index == 0
                      ? const Color(0xFF3361c3)
                      : Colors.grey[600],
                ),
                selectedIcon: FaIcon(
                  FontAwesomeIcons.bell,
                  size: 20,
                  color: const Color(0xFF3361c3),
                ),
                label: '',
              ),
              NavigationDestination(
                icon: FaIcon(
                  FontAwesomeIcons.camera,
                  size: 20,
                  color: _index == 1
                      ? const Color(0xFF3361c3)
                      : Colors.grey[600],
                ),
                selectedIcon: FaIcon(
                  FontAwesomeIcons.camera,
                  size: 20,
                  color: const Color(0xFF3361c3),
                ),
                label: '',
              ),
              NavigationDestination(
                icon: FaIcon(
                  FontAwesomeIcons.message,
                  size: 20,
                  color: _index == 2
                      ? const Color(0xFF3361c3)
                      : Colors.grey[600],
                ),
                selectedIcon: FaIcon(
                  FontAwesomeIcons.message,
                  size: 20,
                  color: const Color(0xFF3361c3),
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
