import 'package:flutter/material.dart';

class TaskFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const TaskFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final tabs = ['ALL', 'Pending', 'Completed'];

    return Container(
      padding: EdgeInsets.all(w * 0.01),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(w * 0.04),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final bool active = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: h * 0.012),
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(w * 0.035),
                  boxShadow: active
                      ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: w * 0.015,
                      offset: Offset(0, h * 0.003),
                    )
                  ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: w * 0.032,
                      fontWeight: FontWeight.w600,
                      color: active
                          ? const Color(0xFFFFA726)
                          : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
