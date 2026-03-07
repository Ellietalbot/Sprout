import 'package:flutter/material.dart';
import '../widgets/option_card.dart';
import '../models/lesson_item.dart';


class HousekeepingQuiz extends StatefulWidget {
  final LessonItem lesson;

  const HousekeepingQuiz({
    super.key,
    required this.lesson,
  });

  @override
  State<HousekeepingQuiz> createState() => _HousekeepingQuizState();
}

class _HousekeepingQuizState extends State<HousekeepingQuiz> {
  int currentIndex = 0;
  String? selectedAnswer;
  bool hasChecked = false;

  List<dynamic> get questions => widget.lesson.questions;

  void _handleCheck() {
    if (selectedAnswer == null) return;
    setState(() {
      hasChecked = true;
    });
  }

  void _handleNext() {
    setState(() {
      if (currentIndex < questions.length - 1) {
        currentIndex++;
        selectedAnswer = null;
        hasChecked = false;
      } else {
        // Quiz finished
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.lesson.title)),
        body: const Center(child: Text("No questions available.")),
      );
    }

    final question = questions[currentIndex];
    final options = question['options'] as Map<String, dynamic>;
    final correctAnswer = question['answer'];
    final progressValue = (currentIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Progress Bar
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

              const SizedBox(height: 40),

              // Question Text
              Text(
                question['question'],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Options Grid
              Expanded(
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: options.entries.map((entry) {
                      final key = entry.key;
                      final value = entry.value;
                      final isSelected = selectedAnswer == key;
                      final isCorrect = key == correctAnswer;

                      Color? cardColor;
                      if (hasChecked && isSelected) {
                        cardColor = isCorrect ? Colors.green.shade100 : Colors.red.shade100;
                      } else if (isSelected) {
                        cardColor = Colors.blue.shade100;
                      }

                      return OptionCard(
                        emoji: value['emoji'] ?? '',
                        label: value['text'] ?? '',
                        color: cardColor,
                        onTap: hasChecked ? () {} : () {
                          setState(() {
                            selectedAnswer = key;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Check / Next Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: hasChecked ? _handleNext : _handleCheck,
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
                    hasChecked
                        ? (currentIndex < questions.length - 1 ? "NEXT" : "FINISH")
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