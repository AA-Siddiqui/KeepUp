import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:keep_up/pages/home_page.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class NavbarData {
  final IconData icon;
  final String label;
  final String pageTitle;
  Widget page;
  NavbarData({
    required this.icon,
    required this.label,
    required this.pageTitle,
    required this.page,
  });
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String pageTitle = "Main Page";
  VoidCallback _bringUpNavbar = () {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: const [
                  DrawerHeader(child: Text("LOL")),
                  ListTile(title: Text("LOL")),
                  ListTile(title: Text("LOL")),
                  ListTile(title: Text("LOL")),
                  ListTile(title: Text("LOL")),
                  ListTile(title: Text("LOL")),
                  ListTile(title: Text("LOL")),
                  ListTile(title: Text("LOL")),
                ],
              ),
            ),
            const ListTile(title: Text("Logout")),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(pageTitle),
        actions: [
          IconButton(
            onPressed: () {
              setState(_bringUpNavbar);
            },
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
      body: PagwViewWithCustomNavbar(
        onInit: (bringUpFunc, newPageTitle) {
          setState(() {
            _bringUpNavbar = bringUpFunc;
            pageTitle = newPageTitle;
          });
        },
        onPageChange: (newPageTitle) {
          setState(() {
            pageTitle = newPageTitle;
          });
        },
        navbarData: [
          NavbarData(
            icon: Icons.home,
            label: "Home",
            pageTitle: "Classes",
            page: HomePage(bringUpNavbar: _bringUpNavbar),
          ),
          NavbarData(
            icon: Icons.article,
            label: "Tasks",
            pageTitle: "Tasks",
            page: Container(
              color: Colors.redAccent,
              child: const Center(
                child: Text("Page 2"),
              ),
            ),
          ),
          NavbarData(
            icon: Icons.settings,
            label: "Settings",
            pageTitle: "Settings",
            page: Container(
              color: Colors.blueAccent,
              child: const Center(
                child: Text("Page 3"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PagwViewWithCustomNavbar extends StatefulWidget {
  final List<NavbarData> navbarData;
  final void Function(String) onPageChange;
  final void Function(VoidCallback bringUpFunc, String pageTitle) onInit;
  final Duration navbarTimeout;
  final int initialPage;

  const PagwViewWithCustomNavbar({
    super.key,
    required this.navbarData,
    required this.onPageChange,
    required this.onInit,
    this.navbarTimeout = const Duration(seconds: 3),
    this.initialPage = 0,
  });

  @override
  State<PagwViewWithCustomNavbar> createState() =>
      _PagwViewWithCustomNavbarState();
}

class _PagwViewWithCustomNavbarState extends State<PagwViewWithCustomNavbar>
    with TickerProviderStateMixin {
  int _pageTabIndex = 0;
  late final PageController _pageController;
  late final AnimationController _navBarAnimController;

  @override
  void initState() {
    super.initState();
    _navBarAnimController = AnimationController(
      vsync: this,
      duration: widget.navbarTimeout,
    );

    _navBarAnimController.forward();

    _pageController = PageController(initialPage: widget.initialPage);
    _pageTabIndex = widget.initialPage;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onInit(
          _bringUpNavbar, widget.navbarData[widget.initialPage].pageTitle);
    });
  }

  void _bringUpNavbar() {
    _navBarAnimController
        .reverse()
        .whenComplete(() => _navBarAnimController.forward());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (newIndex) {
            setState(() {
              _pageTabIndex = newIndex;
              _bringUpNavbar();
              widget.onPageChange(widget.navbarData[newIndex].pageTitle);
            });
          },
          children: widget.navbarData.map((item) {
            return item.page;
          }).toList(),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Animate(
            controller: _navBarAnimController,
            effects: [
              SlideEffect(
                delay: widget.navbarTimeout,
                begin: Offset.zero,
                end: const Offset(0, 1),
                curve: Curves.decelerate,
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  // color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.navbarData.indexed.map((indexedItem) {
                    final index = indexedItem.$1;
                    final item = indexedItem.$2;

                    return GestureDetector(
                      onTap: () => setState(() {
                        _pageTabIndex = index;
                        _pageController.animateToPage(
                          _pageTabIndex,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          backgroundBlendMode: BlendMode.saturation,
                          color: _pageTabIndex == index
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.secondary,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(item.icon),
                            Text(item.label),
                          ],
                        ),
                      ),
                    );
                  }).toList() as List<Widget>,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
