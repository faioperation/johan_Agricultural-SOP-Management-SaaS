import 'package:flutter/material.dart';
import 'package:farm_check_support/common/bottom_nav_bar.dart';

class AppShell extends StatefulWidget {
  final List<Widget> pages;
  final int initialIndex;
  final bool isManager;

  const AppShell({
    super.key,
    required this.pages,
    this.initialIndex = 0,
    required this.isManager,
  });

  @override
  State<AppShell> createState() => AppShellState();
}

class AppShellState extends State<AppShell> {
  late int index;
  late final List<GlobalKey<NavigatorState>> _navigatorKeys;

  void setIndex(int i) {
    setState(() => index = i);
  }

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
    _navigatorKeys =
        List.generate(widget.pages.length, (_) => GlobalKey<NavigatorState>());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final NavigatorState? navigator = _navigatorKeys[index].currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        } else {
          // If the nested navigator cannot pop, we can allow the system to handle it
          // which will likely exit the app or go back in the root navigator.
          if (context.mounted) {
             Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: index,
          children: List.generate(widget.pages.length, (i) {
            return Navigator(
              key: _navigatorKeys[i],
              onGenerateRoute: (_) =>
                  MaterialPageRoute(builder: (_) => widget.pages[i]),
            );
          }),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: index,
          isManager: widget.isManager,
          onTap: (i) {
            if (i == index) {
              _navigatorKeys[i]
                  .currentState
                  ?.popUntil((route) => route.isFirst);
            } else {
              setIndex(i);
            }
          },
        ),
      ),
    );
  }
}
