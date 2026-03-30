import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../widgets/option_card.dart';
import '../models/lesson_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        _markLessonComplete();
        Navigator.pop(context);
      }
    });
  }

  Future<void> _markLessonComplete() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final lessonId = widget.lesson.title; 

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('completedLessons')
      .doc(lessonId)
      .set({
    'title': widget.lesson.title,
    'completedAt': Timestamp.now(),
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


              AutoSizeText(
                question['question'],
                maxLines: 3,
                minFontSize: 18,
                stepGranularity: 1,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),


              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const spacing = 16.0;
                    const crossAxisCount = 2;
                    final rowCount = (options.length / crossAxisCount).ceil();
                    final totalSpacing = spacing * (rowCount - 1);
                    final availableHeight = constraints.maxHeight - totalSpacing;
                    final rawCardHeight = availableHeight / rowCount;
                    final cardHeight = rawCardHeight < 80.0
                        ? rawCardHeight
                        : rawCardHeight.clamp(80.0, 220.0);
                    final optionEntries = options.entries.toList();

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        mainAxisExtent: cardHeight,
                      ),
                      itemCount: optionEntries.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final entry = optionEntries[index];
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
                          onTap: hasChecked
                              ? () {}
                              : () {
                                  setState(() {
                                    selectedAnswer = key;
                                  });
                                },
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              if (hasChecked && selectedAnswer != null)
                  Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: selectedAnswer == questions[currentIndex]['answer'] ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    selectedAnswer == questions[currentIndex]['answer'] ? "👍 Great Job" : "👎 Not quite",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selectedAnswer == questions[currentIndex]['answer']
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

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
                    hasChecked ? (currentIndex < questions.length - 1 ? "NEXT" : "FINISH") : "CHECK",
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
