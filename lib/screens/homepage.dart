import 'package:flutter/material.dart';
import 'package:trackin_n_bingein/styling/styling.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    Container(
      color: Colors.white,
      child: Center(
        child: Text(
          'Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    Container(
      color: Colors.white,
      child: Center(
        child: Text(
          'Statistics',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    Container(
      color: Colors.white,
      child: Center(
        child: Text(
          'List',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    Container(
      color: Colors.white,
      child: Center(
        child: Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
        automaticallyImplyLeading: false,
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _currentIndex == 0 ? Styling.textColor3 : Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics, color: _currentIndex == 1 ? Styling.textColor3 : Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: _currentIndex == 2 ? Styling.textColor3 : Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _currentIndex == 3 ? Styling.textColor3 : Colors.black),
            label: '',
          ),
        ],
      ),
    );
  }
}
