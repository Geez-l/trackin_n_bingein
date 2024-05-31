import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackin_n_bingein/global/common/toast.dart';

class Details extends StatefulWidget {
  final String title;

  const Details({Key? key, required this.title}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late double progressToAdd;
  late double progress; 
  late String catName;
  
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    progressToAdd = 0;
    progress = 0;
    _fetchProgress(); // Fetch progress from Firestore
  }

  // method for fetching progress from Firestore
  void _fetchProgress() async {
    final snapshot = await FirebaseFirestore.instance
      .collection('Media')
      .where('Name', isEqualTo: widget.title)
      .get();
    
    if (snapshot.docs.isNotEmpty) {
      final mediaData = snapshot.docs.first;
      setState(() {
        progress = mediaData['Progress'] ?? 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Media')
            .where('Name', isEqualTo: widget.title)
            .snapshots()
            .map((snapshot) => snapshot.docs.first),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final mediaData = snapshot.data!;

          // Extract media fields
          final String name = mediaData['Name'];
          final String author = mediaData['Author'];
          final String description = mediaData['Description'];
          String status = mediaData['Status'];
          final double max = mediaData['Max'];
          catName = mediaData['CategoryName'];

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              const SizedBox(height: 20),
              Text('Name: $name', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Author: $author', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Description: $description', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Progress: $progress', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Status: $status', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Max: $max', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Add to Progress',
                  prefixIcon: Icon(Icons.add),
                ),
                onChanged: (value) {
                  setState(() {
                    progressToAdd = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Update progress here
                    progress += progressToAdd;

                    String newStatus = status;
                    if (progress >= max) {
                      progress = max;
                      newStatus = 'Finished';
                    }

                    FirebaseFirestore.instance
                        .collection('Media')
                        .where('Name', isEqualTo: widget.title)
                        .get()
                        .then((querySnapshot) {
                      querySnapshot.docs.forEach((doc) {
                        doc.reference.update({'Progress': progress, 'Status': newStatus});
                      });
                    });

                    // Update overall statistics only if progress is incremented and not reaching max
                    if (progressToAdd <= max - progressToAdd) {
                      FirebaseFirestore.instance
                          .collection('Category')
                          .where('Name', isEqualTo: catName)
                          .get()
                          .then((querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          final double existingOverallStat = doc['OverallStat'] ?? 0;
                          final double newOverallStat = existingOverallStat + progressToAdd;
                          doc.reference.update({'OverallStat': newOverallStat});
                        });
                      });
                    }
                    
                    // Clear the text field
                    showToast(message: 'Progress added');
                    _controller.clear();
                  });
                },
                child: Text('Add progress'),
              )
            ],
          );
        },
      ),
    );
  }
}
