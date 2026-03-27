import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/category_section.dart';
import '../widgets/skill_card.dart';
import '../pages/completed_page.dart';
import '../models/lesson_item.dart';
import 'dart:convert';
import 'package:flutter/services.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> lessons = [];
  String selectedCategory = 'All';

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

  List<dynamic> get filteredLessons {
    if (selectedCategory == 'All') return lessons;
    return lessons.where((l) => l['category'] == selectedCategory).toList();
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Cooking':
        return Colors.orange;
      case 'Car Care':
        return Colors.blue;
      case 'Housekeeping':
        return Colors.pink;
      case 'Finances':
        return Colors.green;
      case 'Time Management':
        return Colors.purple;
      default:
        return Colors.grey;
    }
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
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Adulting App',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        FirebaseAuth.instance.currentUser?.email ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
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

            // 🔹 Horizontal Skills Section
            SizedBox(
              height: 200,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
  SkillCard(
    title: 'All',
    icon: const Icon(Icons.apps, size: 100),
    onTap: () => setState(() => selectedCategory = 'All'),
  ),
  SkillCard(
    title: 'Cooking',
    icon: const Icon(Icons.restaurant, size: 100),
    onTap: () => setState(() => selectedCategory = 'Cooking'),
  ),
  SkillCard(
    title: 'Car Care',
    icon: const Icon(Icons.directions_car, size: 100),
    onTap: () => setState(() => selectedCategory = 'Car Care'),
  ),
  SkillCard(
    title: 'Housekeeping',
    icon: const Icon(Icons.cleaning_services, size: 100),
    onTap: () => setState(() => selectedCategory = 'Housekeeping'),
  ),
  SkillCard(
    title: 'Finances',
    icon: const Icon(Icons.attach_money, size: 100),
    onTap: () => setState(() => selectedCategory = 'Finances'),
  ),
  SkillCard(
    title: 'Time Management',
    icon: const Icon(Icons.access_time, size: 100),
    onTap: () => setState(() => selectedCategory = 'Time Management'),
  ),
],
                  // SkillCard(title: 'Cooking', icon: Image.asset('assets/Matt_Cooking.png', width: 140, height: 140)),
                  // SkillCard(title: 'Budgeting', icon: Image.asset('assets/Matt_Finances.png', width: 140, height: 140)),
                  // SkillCard(title: 'Car Care', icon: Image.asset('assets/Matt_CarMaintenance.png', width: 140, height: 140)),
                  // SkillCard(title: 'Cleaning', icon: Image.asset('assets/Matt_HouseCleaning.png', width: 140, height: 140)),
                //],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Category Sections
            ...['Cooking', 'Car Care', 'Housekeeping', 'Finances', 'Time Management']
                .where((cat) => selectedCategory == 'All' || selectedCategory == cat)
                .map(
                  (cat) => CategorySection(
                    title: cat,
                    titleColor: _categoryColor(cat),
                    lessons: filteredLessons
                        .where((l) => l['category'] == cat)
                        .map((l) => LessonItem(
                              title: l['title'],
                              description: "Learn about ${l['title'].toLowerCase()}.",
                              difficulty: l['difficulty'],
                              duration: "${(l['questions'] as List).length} questions",
                              routeName: '/${cat.toLowerCase().replaceAll(' ', '-')}', 
                              questions: l['questions'],
                            ))
                        .toList(),
                  ),
                )
                .toList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}