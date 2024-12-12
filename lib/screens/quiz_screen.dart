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
  int _incorrectAnswers = 0;
  bool _quizCompleted = false;

  List<Map<String, Object>> get _questions => widget.topic['questions'];

  void _answerQuestion(String answer) {
    if (_isAnswered) return;

    setState(() {
      _selectedOption = answer;
      _isAnswered = true;

      // Check if the answer is correct
      if (_selectedOption == _questions[_currentQuestionIndex]['answer']) {
        _correctAnswers++;
      } else {
        _incorrectAnswers++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _isAnswered = false;
        _selectedOption = "";
        _currentQuestionIndex++;
      } else {
        _quizCompleted = true;
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

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedOption = "";
      _isAnswered = false;
      _correctAnswers = 0;
      _incorrectAnswers = 0;
      _quizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return _buildScoreScreen();
    }

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
                                    onTap: () =>
                                        _showImageFullScreen(imagePath),
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
                                  itemCount:
                                      (question['options'] as List<String>)
                                          .length,
                                  itemBuilder: (ctx, index) {
                                    final option = (question['options']
                                        as List<String>)[index];
                                    final isSelected =
                                        option == _selectedOption;
                                    final isCorrect = option == correctAnswer;

                                    Color optionColor;
                                    Color textColor;
                                    IconData? optionIcon;

                                    if (_isAnswered) {
                                      if (isSelected) {
                                        if (isCorrect) {
                                          optionColor = Colors.green.shade100;
                                          textColor = Colors.green.shade800;
                                          optionIcon = Icons.check_circle;
                                        } else {
                                          optionColor = Colors.red.shade100;
                                          textColor = Colors.red.shade800;
                                          optionIcon = Icons.cancel;
                                        }
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: GestureDetector(
                                        onTap: () => _answerQuestion(option),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: optionColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isSelected && _isAnswered
                                                  ? (isCorrect
                                                      ? Colors.green
                                                      : Colors.red)
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              if (optionIcon != null)
                                                Icon(optionIcon,
                                                    color: textColor),
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
                                        backgroundColor:
                                            const Color(0xFF6A4CE3),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        _currentQuestionIndex <
                                                _questions.length - 1
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

  Widget _buildScoreScreen() {
    double scorePercentage = (_correctAnswers / _questions.length) * 100;
    String scoreEmoji = _getScoreEmoji(scorePercentage);

    return Scaffold(
      backgroundColor: const Color(0xFF6A4CE3),
      body: SafeArea(
        child: Column(
          children: [
            // Close/Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    // Navigate back to the topic selection screen
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            
            // Expanded content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Emoji and Main Score
                      Text(
                        scoreEmoji,
                        style: const TextStyle(fontSize: 100),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Quiz Completed!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Score Card
                      Container(
                        width: 300,
                        padding: const EdgeInsets.all(20),
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
                        child: Column(
                          children: [
                            Text(
                              '${scorePercentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6A4CE3),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildScoreDetail(
                                  Icons.check_circle,
                                  Colors.green,
                                  _correctAnswers,
                                  'Correct',
                                ),
                                _buildScoreDetail(
                                  Icons.cancel,
                                  Colors.red,
                                  _incorrectAnswers,
                                  'Incorrect',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDetail(
      IconData icon, Color color, int count, String label) {
    return Column(
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(height: 5),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _getScoreEmoji(double scorePercentage) {
    if (scorePercentage >= 90) {
      return '🏆'; // Trophy for excellent score
    } else if (scorePercentage >= 70) {
      return '🎉'; // Party popper for good score
    } else if (scorePercentage >= 50) {
      return '👍'; // Thumbs up for average score
    } else {
      return '😢'; // Sad face for low score
    }
  }
}