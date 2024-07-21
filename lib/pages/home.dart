import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clpfus/yolo/appbar.dart';
import 'package:clpfus/yolo/navbar.dart';
import 'package:clpfus/yolo/AddQuestion.dart';
import 'package:clpfus/yolo/Adddiss.dart';
import 'package:clpfus/screens/user_id_provider.dart';
import 'diss.dart';
import 'qanda.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the user ID and firstname from the provider
    final userIdProvider = Provider.of<UserIdProvider>(context);
    String userId = userIdProvider.userId;
    String firstName = userIdProvider.firstname;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color(0xFFFFE8D6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Display "Hello, FirstName!" aligned to the left
            Text(
              "Hello, $firstName!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10), // Add spacing
            // Display "Welcome to the Learning App!" below with smaller size
            Text(
              "Welcome to the Learning App!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20), // Add spacing
            // Display images vertically
            buildImageCard(
              context,
              'assets/diss.jpg',
              'Discussion',
              onButtonPressed: (String action) {
                // Handle button actions
                if (action == 'view') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Diss(),
                    ),
                  );
                } else if (action == 'add') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Adddiss(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 10), // Add spacing between images
            buildImageCard(
              context,
              'assets/think.jpg',
              'Question',
              onButtonPressed: (String action) {
                // Handle button actions
                if (action == 'view') {
                  // Navigate to view question
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Qanda(),
                    ),
                  );
                } else if (action == 'add') {
                  // Navigate to add question
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddQuestionPage(userId: userId),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20), // Add spacing
            // Footer with copyright information
            Center(
              child: Text(
                "\u00A9 All rights reserved",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CoolBottomNavBar(),
    );
  }

  Widget buildImageCard(BuildContext context, String imagePath, String heading,
      {required void Function(String action) onButtonPressed}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: Container(
            width: double.infinity,
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), // Adjust the opacity here
                  BlendMode.darken,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Text(
            heading,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  color: Colors.black.withOpacity(0.7),
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 2,
          left: 70,
          child: ElevatedButton(
            onPressed: () => onButtonPressed('view'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCB997E),
            ),
            child: Text('View'),
          ),
        ),
        Positioned(
          bottom: 2,
          left: 187,
          child: ElevatedButton(
            onPressed: () => onButtonPressed('add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCB997E),
            ),
            child: Text('Add'),
          ),
        ),
      ],
    );
  }
}
