import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final VoidCallback bringUpNavbar;
  const HomePage({super.key, required this.bringUpNavbar});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _lastScrollPosition = 0;

  final String subjectName = "Subject Name Very Long Extended";
  final String teacherName = "Mr. Teacher Surname";

  String _getClassIdentifier() {
    const String term = "Spring 2025";
    const String program = "BS Software Engineering";
    const int semester = 5;
    const String section = "B";

    String shortHandTerm(String t) {
      return "${t[0]}${t.substring(t.length - 2)}";
    }

    String shortHandProgram(String p) {
      return p
          .split('')
          .where((c) => ((c.toUpperCase() == c) && (c.toLowerCase() != c)))
          .join();
    }

    return "${shortHandProgram(program)}-${shortHandTerm(term)}-$semester$section";
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    double currentPosition = _scrollController.position.pixels;
    bool isScrollingUp = currentPosition + 10 < _lastScrollPosition;

    if (isScrollingUp) {
      widget.bringUpNavbar();
    }
    _lastScrollPosition = currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: List.generate(
          10,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.secondaryContainer,
                // color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                // color: const Color(0xFF222222),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subjectName,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .apply(fontFamily: ""),
                      ),
                      Text(
                        "${_getClassIdentifier()} • $teacherName",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(fontFamily: ""),
                      ),
                    ],
                  ),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: Text(
                        index.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
