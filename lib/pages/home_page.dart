import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/category_section.dart';
import '../widgets/skill_card.dart';
import '../pages/completed_page.dart';
import '../models/lesson_item.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

// Home page with NavigationRail
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    // Switch between pages
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const CompletedPage();
        break;
      default:
        page = const HomePage();
    }

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Completed',
          ),
        ],
      ),
    );
  }
}

// -------- Pages --------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> lessons = [];

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    final String response = await rootBundle.loadString('assets/lessons.json');
    final data = json.decode(response);
    setState(() {
      lessons = data['lessons'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        // App title
                        'Sprout',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Display the email being used
                      Text(
                        FirebaseAuth.instance.currentUser?.email ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  // Logout button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.logout),
                      color: Colors.red,
                      tooltip: "Logout",
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),


            const SizedBox(height: 20),
            

            // 🔹 Horizontal Skills Section
            SizedBox(
              height: 200,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  SkillCard(title: 'Cooking', icon: Image.asset('assets/Matt_Cooking.png', width: 140, height: 140)),
                  SkillCard(title: 'Budgeting', icon: Image.asset('assets/Matt_Finances.png', width: 140, height: 140)),
                  SkillCard(title: 'Car Care', icon: Image.asset('assets/Matt_CarMaintenance.png', width: 140, height: 140)),
                  SkillCard(title: 'Cleaning', icon: Image.asset('assets/Matt_HouseCleaning.png', width: 140, height: 140)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Category Sections (Team Code)
            CategorySection(
              title: "Cooking",
              titleColor: Colors.orange,
              lessons: lessons
                  .where((l) => l['category'] == 'Cooking')
                  .map((l) => LessonItem(
                        title: l['title'],
                        description: "Learn about ${l['title'].toLowerCase()}.",
                        difficulty: l['difficulty'],
                        duration: "${(l['questions'] as List).length} questions",
                        routeName: '/cooking',
                        questions: l['questions'],
                      ))
                  .toList(),
            ),

            CategorySection(
              title: "Car Care",
              titleColor: Colors.blue,
              lessons: lessons
                  .where((l) => l['category'] == 'Car Care')
                  .map((l) => LessonItem(
                        title: l['title'],
                        description: "Learn about ${l['title'].toLowerCase()}.",
                        difficulty: l['difficulty'],
                        duration: "${(l['questions'] as List).length} questions",
                        routeName: '/car-care',
                        questions: l['questions'],
                      ))
                  .toList(),
            ),

            CategorySection(
              title: "Time Management",
              titleColor: Colors.purple,
              lessons: lessons
                  .where((l) => l['category'] == 'Time Management')
                  .map((l) => LessonItem(
                        title: l['title'],
                        description: "Learn about ${l['title'].toLowerCase()}.",
                        difficulty: l['difficulty'],
                        duration: "${(l['questions'] as List).length} questions",
                        routeName: '/time-management',
                        questions: l['questions'],
                      ))
                  .toList(),
            ),
            CategorySection(
              title: "Cleaning",
              titleColor: Colors.pink,
              lessons: lessons
              .where((l) => l['category'] == 'Housekeeping')
                    .map((l) => LessonItem(
                          title: l['title'],
                          description: "Learn about ${l['title'].toLowerCase()}.",
                          difficulty: l['difficulty'],
                          duration: "${(l['questions'] as List).length} questions",
                          routeName: '/housekeeping',
                          questions: l['questions'],
                        ))
                    .toList(),
            ),


            CategorySection(
              title: "Finances",
              titleColor: Colors.green,
              lessons: lessons
                  .where((l) => l['category'] == 'Finances')
                  .map((l) => LessonItem(
                        title: l['title'],
                        description: "Learn about ${l['title'].toLowerCase()}.",
                        difficulty: l['difficulty'],
                        duration: "${(l['questions'] as List).length} questions",
                        routeName: '/finances',
                        questions: l['questions'],
                      ))
                  .toList(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}