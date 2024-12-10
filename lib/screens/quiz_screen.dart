import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> topic;

  QuizScreen({required this.topic});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  String _selectedOption = "";
  bool _isAnswered = false;
  int _correctAnswers = 0;

  List<Map<String, Object>> get _questions => widget.topic['questions'];

  void _answerQuestion(String answer) {
    setState(() {
      _selectedOption = answer;
      _isAnswered = true;

      // Check if the answer is correct
      if (_selectedOption == _questions[_currentQuestionIndex]['answer']) {
        _correctAnswers++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _isAnswered = false;
      _selectedOption = "";
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Calculate and update the progress
        double progress = _correctAnswers / _questions.length;
        Navigator.pop(context, progress); // Return progress to TopicSelectionScreen
      }
    });
  }

  void _showImageFullScreen(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: PhotoView(
              imageProvider: AssetImage(imagePath),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final String correctAnswer = question['answer'] as String;
    final String? imagePath = question['image'] as String?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.topic['name'],
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0xFF283593),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (imagePath != null) // Check if imagePath is provided
                        GestureDetector(
                          onTap: () => _showImageFullScreen(imagePath),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                        ),
                      SizedBox(height: 24),
                      Text(
                        question['question'] as String,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: (question['options'] as List<String>).length,
                        itemBuilder: (ctx, index) {
                          final option = (question['options'] as List<String>)[index];
                          final isCorrect = option == correctAnswer;
                          final isSelected = option == _selectedOption;

                          Color optionColor;
                          if (_isAnswered) {
                            if (isCorrect) {
                              optionColor = Colors.green;
                            } else if (isSelected) {
                              optionColor = Colors.red;
                            } else {
                              optionColor = Colors.grey[200]!;
                            }
                          } else {
                            optionColor = Colors.grey[200]!;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (!_isAnswered) {
                                  _answerQuestion(option);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: optionColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    if (_isAnswered && isSelected)
                                      Icon(
                                        isCorrect ? Icons.check_circle : Icons.cancel,
                                        color: Colors.white,
                                      ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          color: _isAnswered ? Colors.white : Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (_isAnswered) ...[
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _nextQuestion,
                          child: Text(_currentQuestionIndex < _questions.length - 1
                              ? "Next Question"
                              : "Finish Quiz"),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
