import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackin_n_bingein/authentication/user_auth.dart';
import 'package:trackin_n_bingein/screens/user_authentication_pages/signin.dart';
import 'package:trackin_n_bingein/styling/styling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// must be a stateful widget
class Profile extends StatefulWidget {
  // declare
  final String email;
  const Profile({Key? key, required this.email}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<String> _usernameFuture;

  @override
  void initState() {
    super.initState();
    _usernameFuture = fetchUsername(widget.email);
  }

  // fetching method
  Future<String> fetchUsername(String email) async {
    try {
      // Fetch username from Firestore based on email
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('Email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.get('Username');
      } else {
        throw Exception('No user found with email: $email');
      }
    } catch (e) {
      print('Error fetching username: $e');
      throw Exception('Failed to fetch username');
    }
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
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Customize your page",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          "lib/assets/placeholder_profile.jpg",
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Name: ${snapshot.data}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Styling.textColor3,
                        ),
                      ),
                      Text(
                        "Email: ${widget.email}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Styling.textColor3,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        buildCardWithIcon(
                          title: 'Log Out',
                          icon: Icons.logout,
                          onTap: () {
                            showLogoutConfirmationDialog(context);
                          },
                        ),
                        SizedBox(height: 10),
                        buildCardWithIcon(
                          title: 'Delete Account',
                          icon: Icons.delete,
                          onTap: () {
                            showDeleteAccountDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildCardWithIcon({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDarker = false,
    Color? cardColor,
  }) {
    cardColor ??= isDarker ? Styling.textColor1 : Color.fromARGB(255, 197, 219, 221);

    return Card(
      color: cardColor,
      elevation: 4,
      child: SizedBox(
        width: 300,
        height: 70,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Styling.textColor3,
                  ),
                ),
              ),
              Icon(icon),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  // log out 
  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Signin()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // delete account dialog
  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text(
            "Are you sure you want to delete your account? If you delete your account, you will lose all your data. Continue?"
          ),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                await FirebaseAuthentication().deleteUserAccount();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Signin()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}