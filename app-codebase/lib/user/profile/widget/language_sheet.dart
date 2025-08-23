import 'package:flutter/material.dart';

class LanguageSheet extends StatefulWidget {
  const LanguageSheet({super.key});

  @override
  State<LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<LanguageSheet> {
  String selectedLang = 'English';

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        w * 0.04,
        h * 0.02,
        w * 0.04,
        h * 0.03,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 🔘 TOP INDICATOR + TITLE
          Column(
            children: [
              Container(
                width: w * 0.12,
                height: h * 0.006,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: h * 0.015),
              Text(
                'Select Language',
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: h * 0.025),

          /// 🌐 LANGUAGE OPTIONS
          _languageTile(
              w: w,
              h: h,
              title: 'English',
              subtitle: 'English',
              selected: selectedLang == 'English',
              onTap: () {
                // context.setLocale(const Locale('en'));
                // Navigator.pop(context);
              }
          ),

          _languageTile(
              w: w,
              h: h,
              title: 'Dutch',
              subtitle: 'Dutch',
              selected: selectedLang == 'Dutch',
              onTap: () {
                // context.setLocale(const Locale('nl'));
                // Navigator.pop(context);
              }
          ),

          SizedBox(height: h * 0.02),

          /// ❌ CANCEL BUTTON
          SizedBox(
            width: double.infinity,
            height: h * 0.055,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF1F3F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w * 0.035),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: w * 0.038,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= LANGUAGE TILE =================
  Widget _languageTile({
    required double w,
    required double h,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.015),
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFE0B2) : Colors.white,
          borderRadius: BorderRadius.circular(w * 0.04),
          border: Border.all(
            color: selected ? Colors.orange : Colors.black12,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.004),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: w * 0.055,
              ),
          ],
        ),
      ),
    );
  }
}