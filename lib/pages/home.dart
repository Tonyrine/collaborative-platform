import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:clpfus/yolo/appbar.dart';
import 'package:clpfus/yolo/navbar.dart';
import 'package:clpfus/yolo/category_tags.dart';
import 'package:clpfus/screens/user_id_provider.dart'; // Import the CategoryTags widget

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the user ID from the provider
    final userIdProvider = Provider.of<UserIdProvider>(context);
    String userId = userIdProvider.userId;

    // Dummy category data
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: const TextStyle(color: Color(0xFFCB997E)),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Color(0xFFCB997E)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: const Color(0xFFCB997E),
                    onPressed: () {},
                  ),
                ),
                onSubmitted: (String value) {},
              ),
            ),
            const SizedBox(height: 20),
            // Display the category tags
            CategoryTags(categories: categories),
            Expanded(
              child: Center(
                child: Text(
                    "Welcome to the Home Page, User $userId!"), // Display the user ID
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CoolBottomNavBar(),
    );
  }
}
