import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trackin_n_bingein/styling/styling.dart';

class MediaConsumptionData {

  // Initialize empty list initially
  // categories = name of categories
  // percentages = values of overallStat
  static List<String> categories = []; 
  static List<double> percentages = [];
  static List<Color> colors = [
    Color.fromARGB(255, 122, 195, 255),
    Color.fromARGB(255, 255, 135, 126),
    Color.fromRGBO(255, 241, 119, 1),
    Color.fromARGB(255, 231, 124, 255),
    Color.fromARGB(255, 191, 255, 175),
    Color.fromARGB(255, 172, 167, 198),
    Color.fromARGB(255, 184, 175, 255),
    Color.fromARGB(255, 119, 255, 192),
  ];
}

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
  
}

class _StatisticsState extends State<Statistics> {
  late String _userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
    fetchCategories();
  }

void _getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    _userId = user.uid;
  }
}

// fetch categories and store on lists initialized above
Future<void> fetchCategories() async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Category')
      .where('UserId', isEqualTo: _userId)
      .get();
    
    final List<DocumentSnapshot> documents = querySnapshot.docs;
    
    final List<String> names = [];
    final List<double> percentages = [];
    
    documents.forEach((doc) {
      final name = doc['Name'];
      final percentage = doc['OverallStat'] as double? ?? 0.0; 
      if (name != null) {
        names.add(name);
        percentages.add(percentage);
      }
    });
    
    setState(() {
      MediaConsumptionData.categories = names;
      MediaConsumptionData.percentages = percentages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 35.0, right: 15.0),
        child: ListView(
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
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
                            text: "Your media consumption",
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
                          "Statistics",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // if category collection is empty
                if (MediaConsumptionData.categories.isEmpty)
                  const Center(
                    child: Text(
                      'You have no media listings yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Styling.textColor3,
                      ),
                    ),
                  )
                // if category collection is not empty
                else Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            "Here is the summary of the media you've consumed this week.",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 2,
                              child: PieChartWidget(),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: generateLegends(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ...generateLinearIndicators(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // create legends for each category
  List<Widget> generateLegends() {
    List<Widget> legends = [];
    for (int i = 0; i < MediaConsumptionData.categories.length; i++) {
      legends.add(
        LegendItem(
          label: MediaConsumptionData.categories[i],
          color: MediaConsumptionData.colors[i],
        ),
      );
    }
    return legends;
  }

  List<Widget> generateLinearIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < MediaConsumptionData.categories.length; i++) {
      indicators.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Text(
                MediaConsumptionData.categories[i],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: MediaConsumptionData.percentages[i] / 100,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(MediaConsumptionData.colors[i]),
                      minHeight: 8,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text('${MediaConsumptionData.percentages[i].toStringAsFixed(0)}%'),
            ],
          ),
        ),
      );
    }

    return indicators;
  }
}

class LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const LegendItem({super.key, 
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// piechart
class PieChartWidget extends StatelessWidget {
  const PieChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(
        PieChartData(
          sections: List.generate(
            MediaConsumptionData.categories.length,
            (index) => PieChartSectionData(
              value: MediaConsumptionData.percentages[index],
              color: MediaConsumptionData.colors[index],
            ),
          ),
        ),
      ),
    );
  }
}
