import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackin_n_bingein/backend/models/categoryModel.dart';
import 'package:trackin_n_bingein/screens/media_pages/mediaList.dart';
import 'package:trackin_n_bingein/styling/styling.dart';

class Media extends StatefulWidget {
  const Media({Key? key}) : super(key: key);

  @override
  _MediaState createState() => _MediaState();
}

class MediaCard extends StatelessWidget {
  final String Mediatitle;
  final String imagePath;
  final VoidCallback onDelete;

  MediaCard({
    required this.Mediatitle,
    required this.imagePath,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaList(
              title: Mediatitle,
            ),
          ),
        );
      },
      //card configuration
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: Colors.black54, 
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Mediatitle,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete, 
                    icon: Icon(Icons.delete),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaState extends State<Media> {
  List<MediaCard> mediaList = [];
  late TextEditingController addController;
  late String userId;
  late bool loading = true;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    addController = TextEditingController();
    getCurrentUser();
    fetchCategories();
  }

  @override
  void dispose() {
    addController.dispose(); // Corrected controller disposal
    super.dispose();
  }

  // Function to get the current user
  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  // fetching categories
  Future<void> fetchCategories() async{
    try{
      // fetch categories from Firestore
      QuerySnapshot querySnapshot = await firestore
        .collection('Category')
        .where('UserId', isEqualTo: userId)
        .get();

      setState((){
        loading = false;
      });

      List<MediaCard> tempMediaList = [];

      // iterate through the documents and create MediaCard for each category
      querySnapshot.docs.forEach((doc){
        String categoryName = doc['Name'];
        tempMediaList.add(
          MediaCard(
            Mediatitle: categoryName,
            imagePath: "lib/assets/books.jpg", 
            onDelete: () {  },
          ),
        );
      });

      setState((){
        mediaList = tempMediaList;
      });
    } catch (e){
        print('Error Fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFf9b9b7),
        tooltip: 'Increment',
        onPressed: () async {
          final newMedia = await addMedia(context);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 35.0, right: 15.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "lib/assets/placeholder_profile.jpg",
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    SizedBox(width: 10),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Explore your media listings",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Styling.textColor3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "lib/assets/banner1.png",
                        fit: BoxFit.fill,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 25, right: 25),
                        child: Text(
                          "Track what you binge",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Media listings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Styling.textColor3,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Add logic to sort media
                      },
                      icon: Icon(Icons.sort),
                      color: Colors.black,
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                if (loading)
                  CircularProgressIndicator() // Show loading indicator
                else if (mediaList.isEmpty)
                  Text(
                    "Start tracking",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Styling.textColor3,
                    ),
                  )
                else
                  Column(
                    children: mediaList.map((media) {
                      return MediaCard(
                        Mediatitle: media.Mediatitle,
                        imagePath: media.imagePath,
                        onDelete: () => deleteMediaCategory(media.Mediatitle),
                      );
                    }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addMedia(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Media'),
        content: TextField(
          controller: addController,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Add media'),
        ),
        actions: [
          TextButton(
            child: Text('SUBMIT'),
            onPressed: () {
              submitMedia(context); 
            },
          )
        ],
      ),
    );
  }

  // submit button for adding a media
  Future<void> submitMedia(BuildContext context) async {
    final mediaName = addController.text;
    double overallStat = 0;

    try {
      // Create a new instance of CategoryModel
      final newCategory = CategoryModel(
        userId: userId,
        name: mediaName,
        overallStat: overallStat,
      );

      // Convert CategoryModel to JSON and add to Firestore
      await firestore.collection('Category').add(newCategory.toJson());

      setState(() {
        // Add the new media card to the list
        mediaList.add(
          MediaCard(
            Mediatitle: mediaName,
            imagePath: "lib/assets/books.jpg", 
            onDelete: () {  },
          ),
        );
      });
      Navigator.of(context).pop();
      addController.clear();
    } catch (e) {
      print('Error adding media: $e');
    }
  }

  Future<void> deleteMediaCategory(String categoryName) async {
    try {
      // Get the document reference of the category to be deleted
      QuerySnapshot querySnapshot = await firestore
          .collection('Category')
          .where('UserId', isEqualTo: userId)
          .where('Name', isEqualTo: categoryName)
          .get();

      // Delete the category from Firestore
      querySnapshot.docs.forEach((doc) async {
        // Get the reference of the category document
        final categoryRef = doc.reference;

        // Delete the category document
        await categoryRef.delete();

        // Get the media associated with the category
        QuerySnapshot mediaQuerySnapshot = await firestore
            .collection('Media')
            .where('UserId', isEqualTo: userId)
            .where('CategoryName', isEqualTo: categoryName)
            .get();

        // Delete all media associated with the category
        mediaQuerySnapshot.docs.forEach((mediaDoc) async {
          await mediaDoc.reference.delete();
        });
      });

      // Remove the category from mediaList
      setState(() {
        mediaList.removeWhere((media) => media.Mediatitle == categoryName);
      });
    } catch (e) {
      print('Error deleting media category: $e');
    }
  }

}