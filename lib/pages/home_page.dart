import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// TODO: local_notifications
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _navBarTimeout = const Duration(seconds: 10);
  final _pageController = PageController();
  late final AnimationController _navBarAnimController;
  int _pageTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _navBarAnimController = AnimationController(
      vsync: this,
      duration: _navBarTimeout,
    );

    _navBarAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              {
                "icon": Icons.home,
                "label": "Home",
              },
              {
                "icon": Icons.article,
                "label": "Tasks",
              },
              {
                "icon": Icons.settings,
                "label": "Settings",
              },
            ].indexed.map((indexedItem) {
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
                    color: _pageTabIndex == index ? Colors.redAccent : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item["icon"] as IconData),
                      Text(item["label"] as String),
                    ],
                  ),
                ),
              );
            }).toList() as List<Widget>,
          ),
        ),
      )
          .animate(
            controller: _navBarAnimController,
          )
          .slideY(
            delay: _navBarTimeout,
            begin: 0,
            end: 1,
            curve: Curves.decelerate,
          ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _pageTabIndex = newIndex;
            _navBarAnimController.reverse().whenComplete(() {
              _navBarAnimController.forward();
            });
          });
        },
        children: [
          Container(
            color: Colors.amberAccent,
            child: const Center(
              child: Text("Page 1"),
            ),
          ),
          Container(
            color: Colors.redAccent,
            child: const Center(
              child: Text("Page 2"),
            ),
          ),
          Container(
            color: Colors.blueAccent,
            child: const Center(
              child: Text("Page 3"),
            ),
          ),
        ],
      ),
      // body: Center(
      //   child: TextButton(
      //     onPressed: () async {
      //       await Supabase.instance.client.auth.signOut();
      //     },
      //     // child: Text(Supabase.instance.client.auth.currentUser!.identities![0]
      //     //     .identityData!["display_name"]),
      //     child: Text(Supabase.instance.client.auth.currentUser!.identities![0]
      //         .identityData!["full_name"]),
      //     // child: const Text("Logged In!"),
      //   ),
      // ),
    );
  }
}
