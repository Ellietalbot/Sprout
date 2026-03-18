import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LessonTipsWidget extends StatefulWidget {
  /// The lesson's title (e.g. 'Kitchen Basics') — must match a key in tips.json.
  final String lessonTitle;

  const LessonTipsWidget({super.key, required this.lessonTitle});

  @override
  State<LessonTipsWidget> createState() => _LessonTipsWidgetState();
}

class _LessonTipsWidgetState extends State<LessonTipsWidget> {
  late Future<List<_TipSection>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadTips();
  }

  Future<List<_TipSection>> _loadTips() async {
    final raw = await rootBundle.loadString('assets/tips.json');
    final Map<String, dynamic> all = json.decode(raw);

    final items = all[widget.lessonTitle] as List<dynamic>? ?? [];
    return items.map((item) => _TipSection(
      emoji: item['emoji'] as String? ?? '',
      title: item['title'] as String? ?? '',
      description: item['description'] as String? ?? '',
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_TipSection>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No tips found',
              style: TextStyle(color: Colors.orange));
        }

        final tips = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tips & Reminders",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...tips.map((tip) => _TipCard(tip: tip)),
          ],
        );
      },
    );
  }
}

class _TipCard extends StatelessWidget {
  final _TipSection tip;

  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${tip.emoji} ${tip.title}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            tip.description,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _TipSection {
  final String emoji;
  final String title;
  final String description;

  const _TipSection({
    required this.emoji,
    required this.title,
    required this.description,
  });
}