import 'package:flutter/material.dart';
import 'package:clpfus/yolo/appbar.dart';
import 'package:clpfus/yolo/navbar.dart';
import 'package:clpfus/yolo/AddQuestion.dart';
import 'package:clpfus/yolo/category_tags.dart';
import 'package:clpfus/yolo/AskedQ.dart';

class Qanda extends StatelessWidget {
  const Qanda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'Engineering',
      'Computer Science',
      'Business',
      'Medicine',
      'Arts',
      'Law',
      'Education',
      'Social Sciences',
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color(0xFFFFE8D6),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding to the column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50, // Adjust the height of the search bar
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: const TextStyle(
                      color: Color(0xFFCB997E)), // Set hint text color
                  fillColor: Colors.white, // Set background color to white
                  filled: true, // Enable fill color
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Set rounded borders
                    borderSide: const BorderSide(
                        color: Color(0xFFCB997E)), // Set border color
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: const Color(0xFFCB997E),
                    onPressed: () {
                      // Implement search functionality here
                      // Access the text field value using TextEditingController
                      // Example:
                      // controller.text
                    },
                  ),
                ),
                onSubmitted: (String value) {
                  // Handle search when submitted
                },
              ),
            ),
            const SizedBox(height: 20),
            // Display the category tags
            CategoryTags(categories: categories),
            const Expanded(
              child: Center(
                child: Text("Welcome to the Q & A page!"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFCB997E),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            // Show the popup menu
            _showPopupMenu(context);
          },
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CoolBottomNavBar(),
    );
  }

  void _showPopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final double bottomInset =
        MediaQuery.of(context).padding.bottom; // Get the bottom inset
    final Offset buttonPosition = Offset(
        MediaQuery.of(context).size.width - 80,
        MediaQuery.of(context).size.height -
            bottomInset -
            200); // Adjust the y-coordinate

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        buttonPosition.dx,
        buttonPosition.dy,
        overlay.size.width - buttonPosition.dx,
        overlay.size.height - buttonPosition.dy,
      ),
      items: [
        const PopupMenuItem(
          value: 1,
          child: ListTile(
            leading: Icon(
              Icons.add,
              color: Color(0xFFCB997E),
            ),
            title: Text('Ask New Question'),
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: ListTile(
            leading: Icon(
              Icons.history,
              color: Color(0xFFCB997E),
            ),
            title: Text('My Asked Questions'),
          ),
        ),
      ],
      elevation: 8.0,
    ).then<void>((value) {
      if (value == 1) {
        // Navigate to the AddQuestionPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddQuestionPage(),
          ),
        );
      } else if (value == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AskedQ(),
          ),
        );
      }
    });
  }
}
