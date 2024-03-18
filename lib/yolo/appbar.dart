import 'package:flutter/material.dart';
import 'package:clpfus/pages/userprof.dart';
import 'package:clpfus/pages/quiz.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color iconColor = const Color(0xFFcb997e); // Define the color
    bool hasProfilePic = true; // Set to true if the user has a profile pic

    return AppBar(
      title: const Text(
        'Learning Platform',
        style: TextStyle(
          fontSize: 20, // Increase font size
          fontWeight: FontWeight.bold, // Make text bold
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(15, 228, 218, 218), // Solid color
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.book),
        color: iconColor, // Use the color for the icon
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizPage()),
          );
        },
      ),
      actions: [
        // Conditionally render the avatar or the icon
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AvatarPage()),
            );
          },
          child: hasProfilePic
              ? const CircleAvatar(
                  radius: 23, // Increase avatar size
                  backgroundImage: AssetImage('assets/prof.jpg'),
                  backgroundColor: Colors.transparent,
                )
              // ignore: dead_code
              : IconButton(
                  icon: const Icon(Icons.account_circle),
                  color: iconColor, // Use the color for the icon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AvatarPage()),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 5); // Increase app bar height
}
