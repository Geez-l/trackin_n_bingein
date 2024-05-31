import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackin_n_bingein/backend/models/mediaModel';
import 'package:trackin_n_bingein/buttons/buttons.dart';
import 'package:trackin_n_bingein/styling/styling.dart';

class AddItem extends StatefulWidget {
  final String categoryName;

  const AddItem({super.key, required this.categoryName});

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  late String _userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  // get id of current user
  // Method to get the current user's ID

  void _getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
    }
  }

  // Controllers for text input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _maxDurationController = TextEditingController();
  File? _image;

  // Method to pick an image from the gallery
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Variables for description and word count
  String description = '';
  int descriptionWordCount = 0;
  final int maxDescriptionWordCount = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Image picker section
            GestureDetector(
              onTap: _getImage,
              child: _image == null
                  ? Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: Icon(Icons.add_a_photo, size: 50),
                    )
                  : Image.file(_image!,
                      width: 100, height: 100, fit: BoxFit.cover),
            ),
            Center(
              child: Text(
                "Click to choose photo for your media",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Styling.textColor3,
                ),
              ),
            ),
            SizedBox(height: 30),
            // Text input fields for media details
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.bookmark),
              ),
            ),
            TextFormField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author or Creator',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextFormField(
              controller: _maxDurationController,
              decoration: InputDecoration(
                labelText: 'Max Duration',
                prefixIcon: Icon(Icons.punch_clock),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            // Description input field with word count
            Stack(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    } else if (descriptionWordCount > maxDescriptionWordCount) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Description exceeds word limit'),
                        ),
                      );
                      return "error";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      description = value;
                      descriptionWordCount = value.trim().split(' ').length;
                    });
                  },
                ),
                SizedBox(height: 20),
                Positioned(
                  bottom: 5.0,
                  right: 10.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      '$descriptionWordCount / $maxDescriptionWordCount words',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Buttons for cancelling and adding media
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Buttons.cancelButton(context),
                ElevatedButton(
                  onPressed: () async {
                    // Convert max duration to double
                    double maxDuration = 0;
                    String status = 'Ongoing';
                    double progress = 0;
                    try {
                      maxDuration = double.parse(_maxDurationController.text);
                    } catch (e) {
                      print('Error parsing max duration: $e');
                    }

                    // Create a new instance of MediaModel with user inputs
                    MediaModel newMedia = MediaModel(
                      userId: _userId,
                      categoryName: widget.categoryName,
                      name: _nameController.text,
                      progress: progress,
                      status: status,
                      author: _authorController.text,
                      description: description,
                      maxDuration: maxDuration,
                      image: _image,
                    );
                    
                    // Add the new media item to Firestore
                    await FirebaseFirestore.instance.collection('Media').add(newMedia.toJson());

                    // Navigate back to the previous screen
                    Navigator.of(context).pop();

                    // Clear all input fields
                    _nameController.clear();
                    _authorController.clear();
                    _maxDurationController.clear();
                    _image = null;
                    setState(() {
                      description = '';
                      descriptionWordCount = 0;
                    });
                  },
                  child: Text('Add Media'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ButtonStyling.primaryColor,
                    backgroundColor: ButtonStyling.buttonTextColor,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    textStyle: TextStyle(fontSize: 18),
                    elevation: 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
