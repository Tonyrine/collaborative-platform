import 'package:flutter/material.dart';
import 'package:clpfus/yolo/appbar.dart';
import 'package:clpfus/yolo/navbar.dart';
import 'package:clpfus/yolo/AddQuestion.dart';
import 'package:clpfus/yolo/category_tags.dart';

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
            SizedBox(height: 20),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add question page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddQuestionPage()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFCB997E),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CoolBottomNavBar(),
    );
  }
}
