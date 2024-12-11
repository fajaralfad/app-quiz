import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> topic;

  const QuizScreen({Key? key, required this.topic}) : super(key: key);

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
    if (_isAnswered) return;

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
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: PhotoView(
              imageProvider: AssetImage(imagePath),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
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
      backgroundColor: const Color(0xFF6A4CE3), // Vibrant purple background
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            Container(
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
                backgroundColor: Colors.white30,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),

            // Question and Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question Counter
                    Text(
                      'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Question Card
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Image (if available)
                                if (imagePath != null)
                                  GestureDetector(
                                    onTap: () => _showImageFullScreen(imagePath),
                                    child: Container(
                                      height: 200,
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(imagePath),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),

                                // Question Text
                                Text(
                                  question['question'] as String,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 20),

                                // Options List
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: (question['options'] as List<String>).length,
                                  itemBuilder: (ctx, index) {
                                    final option = (question['options'] as List<String>)[index];
                                    final isCorrect = option == correctAnswer;
                                    final isSelected = option == _selectedOption;

                                    Color optionColor;
                                    Color textColor;
                                    IconData? optionIcon;

                                    if (_isAnswered) {
                                      if (isCorrect) {
                                        optionColor = Colors.green.shade100;
                                        textColor = Colors.green.shade800;
                                        optionIcon = Icons.check_circle;
                                      } else if (isSelected) {
                                        optionColor = Colors.red.shade100;
                                        textColor = Colors.red.shade800;
                                        optionIcon = Icons.cancel;
                                      } else {
                                        optionColor = Colors.grey.shade100;
                                        textColor = Colors.grey.shade800;
                                        optionIcon = null;
                                      }
                                    } else {
                                      optionColor = Colors.grey.shade100;
                                      textColor = Colors.black87;
                                      optionIcon = null;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: GestureDetector(
                                        onTap: () => _answerQuestion(option),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: optionColor,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isSelected && _isAnswered 
                                                ? (isCorrect ? Colors.green : Colors.red)
                                                : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              if (optionIcon != null)
                                                Icon(optionIcon, color: textColor),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  option,
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
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

                                // Next Button
                                if (_isAnswered)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: ElevatedButton(
                                      onPressed: _nextQuestion,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF6A4CE3),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        _currentQuestionIndex < _questions.length - 1
                                            ? "Next Question"
                                            : "Finish Quiz",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}