import 'package:flutter/material.dart';
import 'package:trackin_n_bingein/backend/userFetch.dart';
import 'package:trackin_n_bingein/screens/statistics.dart'; 

class Homepage extends StatefulWidget {
  final String email;
  const Homepage({Key? key, required this.email}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<String> _usernameFuture;
  late final UserService _userService;

  @override
  void initState() {
    super.initState();
    _userService = UserService(widget.email);
    _usernameFuture = _userService.fetchUsername(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _usernameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data to fetch, show a loading indicator
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If an error occurs while fetching data, show an error message
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Once data is fetched, build the UI with the fetched username
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Color(0xFFA7BCC7),
                  elevation: 0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('lib/assets/logofin.png', height: 50),
                      Text("Trackin' n' Bingein"),
                    ],
                  ),
                ),
                GreetingSection(username: snapshot.data!),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WeeklyWrapUpSection(),
                      const SizedBox(height: 20),
                      MyListingsSection(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// greeting section
class GreetingSection extends StatelessWidget {
  final String username;

  const GreetingSection({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      height: 100,
      decoration: const BoxDecoration(
        color: Color(0xFFA7BCC7),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi $username!',
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Text(
            'Keep track of your media journey with ease.',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

// weekly wrap up section
class WeeklyWrapUpSection extends StatelessWidget {  // not finished
  @override 
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Weekly Wrap-up',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Here is the summary of the media you've consumed this week."),
            SizedBox(height: 10),
            Container(
              width: 250, // Set your desired width
              height: 250,
              child: PieChartWidget(),
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

// listings section
class MyListingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, top: 8),
          child: Text(
            'My Listings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ListingItem(
                image: 'books.jpg', 
                label: 'Books',
              ),
              ListingItem(
                image: 'movie.jpg', 
                label: 'Movies',
              ),
              ListingItem(
                image: 'music.png',
                label: 'Podcasts',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ListingItem extends StatelessWidget {
  final String image;
  final String label;

  const ListingItem({
    Key? key,
    required this.image,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/$image'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}