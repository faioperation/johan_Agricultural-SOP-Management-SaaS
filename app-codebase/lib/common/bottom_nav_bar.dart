import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isManager;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isManager,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    /// 🔒 MOBILE LOCK (no change under 600px)
    final bool isMobile = w < 600;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        isMobile ? 12 : w * 0.03,
        0,
        isMobile ? 12 : w * 0.03,
        isMobile ? 16 : 24,
      ),
      child: Container(
        height: isMobile ? 64 : 80,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(Icons.home_outlined, 'Home', 0, isMobile),
            _item(Icons.description_outlined, 'Sops', 1, isMobile),

            /// 🔶 CENTER HEXAGON (UNCHANGED ON MOBILE)
            GestureDetector(
              onTap: () => onTap(2),
              child: Transform.translate(
                offset: Offset(0, isMobile ? -10 : -14),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipPath(
                      clipper: _HexagonClipper(),
                      child: Container(
                        width: isMobile ? 60 : 80,
                        height: isMobile ? 68 : 90,
                        color: Colors.white,
                      ),
                    ),
                    ClipPath(
                      clipper: _HexagonClipper(),
                      child: Container(
                        width: isMobile ? 60 : 80,
                        height: isMobile ? 80 : 100,
                        color: const Color(0xFFFFA726),
                        child: Icon(
                          Icons.check_box_outlined,
                          size: isMobile ? 26 : 34,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _item(Icons.chat_bubble_outline, 'Messages', 3, isMobile,
                badge: true),

            _item(
              isManager ? Icons.group_outlined : Icons.person_outline,
              isManager ? 'Employee' : 'Profile',
              4,
              isMobile,
            ),
          ],
        ),
      ),
    );
  }

  /// ================= ITEM =================
  Widget _item(
      IconData icon,
      String label,
      int index,
      bool isMobile, {
        bool badge = false,
      }) {
    final active = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: SizedBox(
        width: isMobile ? 60 : 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: isMobile ? 22 : 30,
                  color:
                  active ? const Color(0xFFFFA726) : Colors.black,
                ),
                if (badge)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      width: isMobile ? 14 : 18,
                      height: isMobile ? 14 : 18,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '●',
                        style: TextStyle(
                          fontSize: isMobile ? 8 : 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isMobile ? 10 : 13,
                fontWeight: FontWeight.w500,
                color:
                active ? const Color(0xFFFFA726) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔷 HEXAGON
class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w, h * 0.25)
      ..lineTo(w, h * 0.75)
      ..lineTo(w * 0.5, h)
      ..lineTo(0, h * 0.75)
      ..lineTo(0, h * 0.25)
      ..close();
  }

  @override
  bool shouldReclip(_) => false;
}
