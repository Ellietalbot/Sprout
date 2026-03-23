import 'package:flutter/material.dart';
import '../pages/housekeeping_quiz.dart';
import '../models/lesson_item.dart';

class CookingLessonPage extends StatelessWidget {
  final LessonItem lesson;

  const CookingLessonPage({super.key, required this.lesson});

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
              Center(
                child: Icon(
                  Icons.restaurant,
                  size: 80,
                  color: Colors.orange.shade600,
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
                title: "🔥 Sauté means quick cooking",
                content:
                    "Sautéing means cooking food quickly in a small amount of oil over relatively high heat.",
              ),

              _buildSection(
                title: "🌡️ Chicken must hit 165°F",
                content:
                    "Chicken should reach an internal temperature of 165°F (74°C) to be safe to eat.",
              ),

              _buildSection(
                title: "🧂 Salt your pasta water",
                content:
                    "Salt in pasta water helps season the pasta itself and improves flavor.",
              ),

              _buildSection(
                title: "🔪 Avoid cross-contamination",
                content:
                    "Use separate cutting boards for raw meat and produce to keep bacteria from spreading.",
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HousekeepingQuiz(lesson: lesson),
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