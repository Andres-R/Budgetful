import 'package:budgetful/screens/settings/settings_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:budgetful/screens/budgeting/budgeting_screen.dart';
import 'package:budgetful/screens/settings/settings_screen.dart';
import 'package:budgetful/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    _pages = widget.userID == kGuestID
        ? [
            BudgetingScreen(userID: widget.userID),
            SettingsErrorScreen(userID: widget.userID),
          ]
        : [
            BudgetingScreen(userID: widget.userID),
            SettingsScreen(userID: widget.userID),
          ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        backgroundColor: kMainBGColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kCurrencyColor,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Budgeting'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
        ],
      ),
    );
  }
}
