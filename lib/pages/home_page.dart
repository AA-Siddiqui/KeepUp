import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  int _pageTabIndex = 0;
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
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _pageTabIndex = newIndex;
          });
        },
        children: const [
          Center(
            child: Text("Page 1"),
          ),
          Center(
            child: Text("Page 2"),
          ),
          Center(
            child: Text("Page 3"),
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
