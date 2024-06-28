import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clpfus/pages/home.dart';
import 'package:clpfus/pages/diss.dart';
import 'package:clpfus/pages/qanda.dart';
import 'package:clpfus/screens/user_id_provider.dart';

class CoolBottomNavBar extends StatefulWidget {
  @override
  _CoolBottomNavBarState createState() => _CoolBottomNavBarState();
}

class _CoolBottomNavBarState extends State<CoolBottomNavBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int _prevSelectedIndex = 0;

  late List<Widget> _widgetOptions;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _widgetOptions = [
      HomePage(),
      const Diss(),
      const Qanda(),
    ];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _prevSelectedIndex = _selectedIndex;
      _selectedIndex = index;
    });
    _animationController
        .forward()
        .then((value) => _animationController.reset());
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFE8D6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Color(0xFFCB997E),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: Color(0xFFCB997E),
                ),
                label: 'Discussion',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.help,
                  color: Color(0xFFCB997E),
                ),
                label: 'Q&A',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFFCB997E),
            unselectedItemColor: Colors.grey[600],
            onTap: (index) {
              _onItemTapped(index);
              // Navigate to the selected page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => _widgetOptions[index]),
              );
            },
            type: BottomNavigationBarType.fixed,
            elevation: 5,
            selectedLabelStyle: _prevSelectedIndex == _selectedIndex
                ? const TextStyle(fontWeight: FontWeight.bold)
                : const TextStyle(fontWeight: FontWeight.normal),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
