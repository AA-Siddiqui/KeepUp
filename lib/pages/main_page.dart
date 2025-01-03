import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:keep_up/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

// TODO: local_notifications and shared_preferences
class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final _navBarTimeout = const Duration(seconds: 3);
  final _pageController = PageController(initialPage: 0);
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

  void _bringUpNavbar() {
    _navBarAnimController
        .reverse()
        .whenComplete(() => _navBarAnimController.forward());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Logout"),
              onTap: () {
                Supabase.instance.client.auth.signOut();
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(["Classes", "Tasks", "Settings"][_pageTabIndex]),
        actions: [
          IconButton(
            onPressed: () {
              setState(_bringUpNavbar);
            },
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (newIndex) {
              setState(() {
                _pageTabIndex = newIndex;
                _bringUpNavbar();
              });
            },
            children: [
              HomePage(
                bringUpNavbar: _bringUpNavbar,
              ),
              Container(
                color: Colors.redAccent,
                child: Center(
                  child: TextButton(
                    child: const Text("Page 2"),
                    onPressed: () async {
                      print("HOGTOG: Start");
                      final SupabaseClient supabaseClient =
                          Supabase.instance.client;
                      final x = await supabaseClient
                          .from("Class")
                          .select("classId, subjectName, Enrollment(userId)");
                      // .eq("userId",
                      //     supabaseClient.auth.currentUser?.id as Object);
                      print("HOGTOG: $x");
                    },
                  ),
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
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
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
                          backgroundBlendMode: BlendMode.saturation,
                          color: _pageTabIndex == index
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.secondary,
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
