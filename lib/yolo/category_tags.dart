import 'package:flutter/material.dart';

class CategoryTags extends StatelessWidget {
  final List<String> categories;

  const CategoryTags({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(
                12), // Increase padding for larger tag size
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(40),
              color: Colors.white, // Set background color to white
            ),
            child: Text(
              category,
              style: const TextStyle(
                color: Color(0xFFCB997E),
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CategorySlideshow extends StatelessWidget {
  final List<String> categories;
  final List<IconData> icons;

  const CategorySlideshow({
    required this.categories,
    required this.icons,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categories.length,
          (index) => GestureDetector(
            onTap: () {
              // Navigate to the corresponding page based on the tapped category
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/diss');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/qanda');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/quiz');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/userprof');
                  break;
                default:
                  break;
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black), // Add border
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icons[index], color: Colors.black),
                  const SizedBox(height: 10),
                  Text(
                    categories[index],
                    style: const TextStyle(color: Colors.black),
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
