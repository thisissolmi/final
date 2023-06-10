import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryData {
  final String category;
  int count;
  final Color color;

  CategoryData(this.category, this.count, this.color);
}

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> questionSnapshot =
      FirebaseFirestore.instance.collection('products').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('종류별 목록 리스트')),
      body: Center(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: questionSnapshot,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            List<CategoryData> data = [
              CategoryData('한식', 1, Colors.red),
              CategoryData('중식', 2, Colors.green),
              CategoryData('양식', 3, Colors.blue),
              CategoryData('일식', 4, Colors.orange),
              CategoryData('디저트', 5, Colors.purple),
            ];

            snapshot.data!.docs.forEach((doc) {
              String category = doc['category'];
              //final category = document.data()['category'] as String?;
              for (CategoryData catData in data) {
                if (catData.category == category) {
                  catData.count++;
                  break;
                }
              }
            });

            int totalCount = data.fold(0, (sum, item) => sum + item.count);
            List<PieChartSectionData> sections = [];
            for (int i = 0; i < data.length; i++) {
              double percentage = (data[i].count / totalCount) * 100;
              sections.add(
                PieChartSectionData(
                  color: data[i].color,
                  value: percentage,
                  title:
                      '${data[i].category}: ${data[i].count}개 \n (${percentage.toStringAsFixed(1)}%)',
                  radius: 100,
                ),
              );
            }

            return Column(
              children: [
                SizedBox(height: 10),
                Text('< Food Category Rate >'),
                SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        sectionsSpace: 3,
                        borderData: FlBorderData(show: false),
                      ),
                      //swapAnimationDuration: Duration(milliseconds: 150),
                      //swapAnimationCurve: Curves.linear,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
