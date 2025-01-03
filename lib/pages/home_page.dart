import 'package:flutter/material.dart';
import 'package:keep_up/models/class.dart';
import 'package:keep_up/pages/class_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback bringUpNavbar;
  const HomePage({super.key, required this.bringUpNavbar});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    double currentPosition = _scrollController.position.pixels;
    bool isScrollingUp = currentPosition < _lastScrollPosition;

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
            (index) => ClassItem(
                  numberOfUndone: index,
                  classData: Class(
                    classId: 1,
                    subjectName: "Subject Name Very Long Extended",
                    program: "BS Software Engineering",
                    term: "Fall 2024",
                    semester: 5,
                    section: "B",
                    teacher: "Mr. Teacher Surname",
                  ),
                )),
      ),
    );
  }
}

class ClassItem extends StatelessWidget {
  String _getClassIdentifier() {
    String shortHandTerm =
        "${classData.term[0]}${classData.term.substring(classData.term.length - 2)}";

    String shortHandProgram = classData.program
        .split('')
        .where((c) => ((c.toUpperCase() == c) && (c.toLowerCase() != c)))
        .join();

    return "$shortHandProgram-$shortHandTerm-${classData.semester}${classData.section}";
  }

  final Class classData;

  final int numberOfUndone;
  const ClassItem({
    super.key,
    required this.numberOfUndone,
    required this.classData,
  });

  void _navigateToClassPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassPage(
          subjectId: classData.classId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToClassPage(context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondaryContainer,
            border: Border.all(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
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
                    classData.subjectName,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .apply(fontFamily: ""),
                  ),
                  Text(
                    "${_getClassIdentifier()} • ${classData.teacher}",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .apply(fontFamily: ""),
                  ),
                ],
              ),
              if (numberOfUndone > 0)
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      numberOfUndone.toString(),
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
    );
  }
}
