import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

// --- Reusable Option Widget ---
class OptionCard extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const OptionCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final emojiSize = (constraints.maxHeight * 0.32).clamp(32.0, 48.0);

          return Container(
            decoration: BoxDecoration(
              color: color ?? Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: emojiSize),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    flex: 7,
                    child: Center(
                      child: AutoSizeText(
                        label,
                        maxLines: 3,
                        minFontSize: 12,
                        stepGranularity: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}