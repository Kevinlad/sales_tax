import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xianinfotech_task/screens/dashboard.dart';
import 'package:xianinfotech_task/screens/home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../responsive.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  BottomBar({
    super.key,
    this.selectpage,
    this.cate,
  });
  late int? selectpage;

  String? cate = "Baby Shower";
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with WidgetsBindingObserver {
  late int _currentIndex;
  late final PageController _pageController;
  final List<String> drawerItems = [
    "Home",
    "Category",
    "My Drafts",
    "My Orders",
    "More"
  ];

  late List<Widget> _screens;
  double _keyboardHeight = 0.0;
  void getCategory() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? category = prefs.getString("category");
    // if (category == null) {
    //   prefs.setString("category", "Baby Shower");
    // }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }


  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectpage ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
    if (widget.selectpage != null) {
      widget.selectpage = null;
    }
    getCategory();

    _screens = [
      HomeScreen(), Dashboard()

    ];
  
  }


  // ResizeObserver to detect changes in the view size

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
      ),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard, color: Colors.black),
      label: "Dashboard",
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.inventory,
        color: Colors.black,
      ),
      label: "items",
    ),
    const BottomNavigationBarItem(
        icon: Icon(Icons.menu, color: Colors.black), label: "Menu"),
    const BottomNavigationBarItem(
      icon: Icon(Icons.workspace_premium, color: Colors.yellow),
      label: "Get Preminium",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: Scaffold(
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (newvalue) {
              setState(() {
                _currentIndex = newvalue;
              });
            },
            children: _screens,
          ),
          bottomNavigationBar: _keyboardHeight > 0
              ? SizedBox.shrink()
              : BottomNavigationBar(
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.blue,
                  selectedIconTheme: const IconThemeData(color: Colors.blue),
                  unselectedItemColor: Colors.black,
                  items: _bottomNavBarItems,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
        ),
        desktop: Scaffold(
          backgroundColor: Colors.black54,
          body: Row(
            children: [
              SizedBox(
                width: 190,
                child: Scaffold(
                  body: Drawer(
                    child: ListView.builder(
                      itemCount: drawerItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(drawerItems[index]),
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            });
                          },
                          selected: _currentIndex == index,
                          selectedTileColor: Colors.blue.withOpacity(0.6),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _screens[_currentIndex],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
