import 'package:flutter/material.dart';

class AvatarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your profile'),
      ),
      backgroundColor: const Color(0xFFFFE8D6),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  // Avatar with camera icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: const AssetImage('assets/prof.jpg'),
                          onBackgroundImageError: (exception, stackTrace) {},
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // User details
                  const SizedBox(height: 20),
                  const Text(
                    'Your Name', // Replace with user's name
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Add more user details here
                  const SizedBox(height: 20),
                  // Container to display user information and buttons
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // User information table
                        Table(
                          // Remove border
                          border: TableBorder.symmetric(
                            inside: BorderSide.none,
                            outside: BorderSide.none,
                          ),
                          children: [
                            _buildUserInfoItem('Email', 'example@example.com'),
                            _buildUserInfoItem('Gender', 'Male'),
                            _buildUserInfoItem('Program', 'Computer Science'),
                            _buildUserInfoItem(
                                'University', 'Example University'),
                            _buildUserInfoItem('Role', 'Student'),
                            _buildUserInfoItem('Password',
                                '******'), // For security, don't show the password
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Row containing buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Handle update button press
                              },
                              icon: const Icon(
                                Icons.update,
                                color: Color(0xFFCB997E),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFE8D6),
                              ),
                              label: const Text(
                                'Update',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Handle logout button press
                              },
                              icon: const Icon(
                                Icons.logout,
                                color: Color(0xFFCB997E),
                              ),
                              label: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFE8D6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build user information item
  TableRow _buildUserInfoItem(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Increase font size
              color: Colors.black, // Change text color
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18, // Increase font size
            ),
          ),
        ),
      ],
    );
  }
}
