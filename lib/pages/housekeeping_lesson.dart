import 'package:flutter/material.dart';
import '../pages/housekeeping_quiz.dart';
import '../models/lesson_item.dart';

class HousekeepingLessonPage extends StatelessWidget {
  final LessonItem lesson;
  const HousekeepingLessonPage({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Hero Icon
              Center(
                child: Icon(
                  Icons.cleaning_services,
                  size: 80,
                  color: Colors.blue.shade600,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                lesson.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _buildSection(
                title: "💨 Ventilation first.",
                content: "The #1 reason to run the fan or open a window after a shower is to remove moisture and prevent mold. Not to cool down or reduce noise.",
              ),

              _buildSection(
                title: "🧹 Right tool for the job.",
                content: "A toilet brush is the correct tool for cleaning a toilet bowl.",
              ),

              _buildSection(
                title: "🧖‍♀️ Towel rotation",
                content: "Towels should be washed every 3–4 uses. Damp towels breed bacteria faster than you think.",
              ),

              _buildSection(
                title: "🪞 Streak-free mirrors",
                content: "Use glass cleaner + a microfiber cloth. Rough sponges scratch.",
              ),

              const SizedBox(height: 40),

              // Take Quiz Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HousekeepingQuiz(
                          lesson: lesson,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Take Quiz",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}