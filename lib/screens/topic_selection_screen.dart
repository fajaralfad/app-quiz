import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_screen.dart';

class TopicSelectionScreen extends StatefulWidget {
  @override
  _TopicSelectionScreenState createState() => _TopicSelectionScreenState();
}

class _TopicSelectionScreenState extends State<TopicSelectionScreen> {
  // Updated topics list with images
  final List<Map<String, dynamic>> topics = [
    {
      'name': 'Matematika',
      'icon': FontAwesomeIcons.squareRootAlt,
      'progress': 0.0,
      'questions': [
        {
          'question': 'What is the term for...',
          'image': 'assets/images/icon.png', // Image path
          'options': ['Term A', 'Term B', 'Term C', 'Term D'],
          'answer': 'Term A',
        },
        // Add more questions for Terminology
      ],
    },
    {
      'name': 'IPA',
      'icon': FontAwesomeIcons.flask,
      'progress': 0.0,
      'questions': [
        {
          'question': 'Which muscle is found in...',
          'image': 'assets/images/pertanyaan_1.png', // Image path
          'options': ['Muscle A', 'Muscle B', 'Muscle C', 'Muscle D'],
          'answer': 'Muscle B',
        },
        // Add more questions for Upper limb
      ],
    },
    {
      'name': 'Geografi',
      'icon': FontAwesomeIcons.globe,
      'progress': 0.0,
      'questions': [
        {
          'question': 'Which muscle is found in...',
          'image': 'assets/images/pertanyaan_1.png', // Image path
          'options': ['Muscle A', 'Muscle B', 'Muscle C', 'Muscle D'],
          'answer': 'Muscle B',
        },
        // Add more questions for Upper limb
      ],
    },
    // Add more topics with questions
    {
      'name': 'Sejarah',
      'icon': FontAwesomeIcons.book,
      'progress': 0.0,
      'questions': [
        {
          'question': 'Which muscle is found in...',
          'image': 'assets/images/pertanyaan_1.png', // Image path
          'options': ['Muscle A', 'Muscle B', 'Muscle C', 'Muscle D'],
          'answer': 'Muscle B',
        },
        // Add more questions for Upper limb
      ],
    },
    // Add more topics with questions
    {
      'name': 'B.Indonesia',
      'icon': FontAwesomeIcons.feather,
      'progress': 0.0,
      'questions': [
        {
          'question': 'Which muscle is found in...',
          'image': 'assets/images/pertanyaan_1.png', // Image path
          'options': ['Muscle A', 'Muscle B', 'Muscle C', 'Muscle D'],
          'answer': 'Muscle B',
        },
        {
          'question': 'Which muscle is found in...',
          'image': 'assets/images/pertanyaan_1.png', // Image path
          'options': ['Muscle A', 'Muscle B', 'Muscle C', 'Muscle D'],
          'answer': 'Muscle B',
        },
        {
          'question': 'Which muscle is found in...',
          'image': 'assets/images/pertanyaan_1.png', // Image path
          'options': ['Muscle A', 'Muscle B', 'Muscle C', 'Muscle D'],
          'answer': 'Muscle B',
        },
        {
          'question': 'Which muscle is found in...',
          'image': 'assets/images/pertanyaan_1.png', // Image path
          'options': ['Muscle A', 'Muscle B', 'Muscle C', 'Muscle D'],
          'answer': 'Muscle B',
        },
        {
          'question': 'Which muscle is found in...',
          'image': 'assets/images/pertanyaan_1.png', // Image path
          'options': ['Muscle A', 'Muscle B', 'Muscle C', 'Muscle D'],
          'answer': 'Muscle B',
        },
      ],
    },
    // Add more topics with questions
    {
      'name': 'B.Inggris',
      'icon': FontAwesomeIcons.comment,
      'progress': 0.0,
      'questions': [
        {
          'question': 'Which muscle is found in...',
          'image': 'assets/images/pertanyaan_1.png', // Image path
          'options': ['Muscle A', 'Muscle B', 'Muscle C', 'Muscle D'],
          'answer': 'Muscle B',
        },
        // Add more questions for Upper limb
      ],
    },
    // Add more topics with questions
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // Method to load saved progress from shared_preferences
  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < topics.length; i++) {
      double progress = prefs.getDouble('topic_progress_$i') ?? 0.0;
      setState(() {
        topics[i]['progress'] = progress;
      });
    }
  }

  // Method to save progress to shared_preferences
  Future<void> _saveProgress(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('topic_progress_$index', topics[index]['progress']);
  }

  // Update the topic's progress and save it
  void _updateTopicProgress(int index, double progress) {
    setState(() {
      topics[index]['progress'] = progress;
    });
    _saveProgress(index); // Save progress
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pilih mata pelajaran",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Color(0xFF1A237E), // Deep Indigo
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F5F5), // Soft Grey Background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return GestureDetector(
                    onTap: () async {
                      // Navigate to QuizScreen and update progress upon completion
                      final double progress = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                topic: topic,
                              ),
                            ),
                          ) ??
                          topic['progress'];

                      // Update topic's progress
                      _updateTopicProgress(index, progress);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF283593), // Deep Indigo
                            Color(0xFF5C6BC0), // Lighter Indigo
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularPercentIndicator(
                            radius: 65.0,
                            lineWidth: 10.0,
                            percent: topic['progress'],
                            center: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                topic['icon'],
                                size: 45.0,
                                color: Colors.white,
                              ),
                            ),
                            progressColor: Colors.white,
                            backgroundColor: Colors.white24,
                          ),
                          SizedBox(height: 15),
                          Text(
                            topic['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1.1,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '${(topic['progress'] * 100).toStringAsFixed(0)}% Completed',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}