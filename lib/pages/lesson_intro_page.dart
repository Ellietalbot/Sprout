import 'package:flutter/material.dart';
import '../models/lesson_item.dart';
import 'quiz_page.dart';
import '../widgets/lesson_tips_widget.dart';

class LessonIntroPage extends StatelessWidget {
  final LessonItem lesson;

  const LessonIntroPage({super.key, required this.lesson});

  IconData _iconForLesson(LessonItem lesson) {
    final route = lesson.routeName ?? '';
    if (route == '/housekeeping') return Icons.cleaning_services;
    if (route == '/car-care') return Icons.directions_car;
    if (route == '/finances') return Icons.attach_money;
    if (route == '/time-management') return Icons.schedule;
    if (route == '/cooking') return Icons.restaurant;
    return Icons.menu_book;
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionCount = lesson.questions.length;

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Icon
              Center(
                child: Icon(
                  _iconForLesson(lesson),
                  size: 90,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 28),

              // Title
              Text(
                lesson.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                lesson.description,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),

              const SizedBox(height: 24),

              // Stats row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _difficultyColor(lesson.difficulty),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      lesson.difficulty,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.quiz_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '$questionCount question${questionCount == 1 ? '' : 's'}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Dynamic tips from tips.json, matched by lesson title ──
              LessonTipsWidget(lessonTitle: lesson.title),

              const SizedBox(height: 28),

              // Take Quiz Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: questionCount == 0
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HousekeepingQuiz(lesson: lesson);
                              },
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(questionCount == 0 ? 'No Questions Yet' : 'Take Quiz'),
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