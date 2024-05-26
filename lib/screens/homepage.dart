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
    HomeTab(),
    StatisticsTab(),
    ListTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _tabs[_currentIndex],
          Positioned(
            child: Column(
              children: [
                Container(
                  color: Color(0xFFA7BCC7),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('lib/assets/logofin.png', height: 50),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _currentIndex = 3; // Direct to ProfileTab
                            });
                          },
                          child: CircleAvatar(   // User profile
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.person, size: 30, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_currentIndex == 0) ...[
                  GreetingSection(),
                ],
              ],
            ),
          ),
        ],
      ),
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

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 180.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            WeeklyWrapUpSection(),
            SizedBox(height: 20),
            MyListingsSection(),
          ],
        ),
      ),
    );
  }
}

class GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFFA7BCC7),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi Kzlyr!',  // should be the input username
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                'Keep track of your media journey with ease.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeeklyWrapUpSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Weekly Wrap-up',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Some informative text.'),
            CircularProgressIndicator(
              value: 0.0,
              strokeWidth: 10,
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('View my statistics'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyListingsSection extends StatelessWidget { // not finished
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Listings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ListingItem(
                icon: Icons.book,
                label: 'Books',
              ),
              ListingItem(
                icon: Icons.podcasts,
                label: 'Podcasts',
              ),
              ListingItem(
                icon: Icons.movie,
                label: 'Movies',
              ),
              // Add more items as needed
            ],
          ),
        ),
      ],
    );
  }
}

class ListingItem extends StatelessWidget {
  final IconData icon;
  final String label;

  ListingItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.blue),
              ],
            ),
          ),
        ),
      Text(label),
      ],
    );
  }
}

class StatisticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Statistics',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'List',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
