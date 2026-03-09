class LessonItem {
  final String title;
  final String description;
  final String difficulty;
  final String duration;
  final String? routeName;
  final List<dynamic> questions; 
  
  const LessonItem({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.duration,
    this.routeName,
    this.questions = const [], 
  });
}