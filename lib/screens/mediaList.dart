import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackin_n_bingein/screens/details.dart';
import 'package:trackin_n_bingein/screens/addItem.dart';

class MediaList extends StatefulWidget {
  final String title;
  const MediaList({Key? key, required this.title}) : super(key: key);

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  late TextEditingController addController;
  late String userId;

  @override
  void initState() {
    super.initState();
    addController = TextEditingController();
    getCurrentUser();
  }

  @override
  void dispose() {
    addController.dispose();
    super.dispose();
  }

  // Function to get the current user
  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFf9b9b7),
        tooltip: 'Increment',
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItem(categoryName: widget.title),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Media')
              .where('CategoryName', isEqualTo: widget.title)
              .where('UserId', isEqualTo: userId) 
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final mediaDocs = snapshot.data!.docs;

            if (mediaDocs.isEmpty) {
              return Center(
                child: Text('Empty'),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: mediaDocs.length,
              itemBuilder: (context, index) {
                final media = mediaDocs[index];
                return MediaListCard(
                  title: media['Name'],
                  imagePath: media['Image'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(title: media['Name']),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class MediaListCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const MediaListCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.transparent,
                width: 0,
              ),
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
