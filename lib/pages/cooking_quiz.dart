import 'package:flutter/material.dart';
import '../models/lesson_item.dart';
import '../widgets/option_card.dart';
import 'completed_page.dart';

class CookingQuiz extends StatefulWidget {
  final LessonItem lesson;

  const CookingQuiz({super.key, required this.lesson});

  @override
  State<CookingQuiz> createState() => _CookingQuizState();
}

class _CookingQuizState extends State<CookingQuiz> {
  int currentQuestionIndex = 0;
  String? selectedOptionKey;
  int score = 0;

  List<dynamic> get questions => widget.lesson.questions;

  void _selectOption(String optionKey) {
    setState(() {
      selectedOptionKey = optionKey;
    });
  }

  void _checkAnswer() {
    if (selectedOptionKey == null) return;

    final currentQuestion = questions[currentQuestionIndex];
    final correctAnswer = currentQuestion['answer'];

    if (selectedOptionKey == correctAnswer) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionKey = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CompletedPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final options = currentQuestion['options'] as Map<String, dynamic>;
    final progressValue = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          width: constraints.maxWidth * progressValue,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 73, 40),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                currentQuestion['question'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: options.entries.map((entry) {
                    final optionKey = entry.key;
                    final optionData = entry.value as Map<String, dynamic>;

                    return OptionCard(
                      emoji: optionData['emoji'] ?? '',
                      label: optionData['text'] ?? '',
                      onTap: () => _selectOption(optionKey),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedOptionKey == null ? null : _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 241, 73, 40),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    currentQuestionIndex == questions.length - 1
                        ? "FINISH"
                        : "CHECK",
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}