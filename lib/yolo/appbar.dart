import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:clpfus/pages/userprof.dart'; // Import your user profile page
import 'package:clpfus/pages/quiz.dart'; // Import your quiz page
import 'package:clpfus/screens/user_id_provider.dart'; // Import your user ID provider

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 5);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late Map<String, dynamic> userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userIdProvider = Provider.of<UserIdProvider>(context, listen: false);
    final userId = userIdProvider.userId;

    final response = await http.post(
      Uri.parse('http://192.168.43.245/CLP/get_user_info.php'),
      body: {'user_id': userId.toString()},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          userData = data['data'];
          isLoading = false;
        });
      } else {
        _showErrorDialog('Failed to fetch user data');
      }
    } else {
      _showErrorDialog('Server error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = const Color(0xFFcb997e);

    return AppBar(
      title: const Text(
        'Learning Platform',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(15, 228, 218, 218),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.book),
        color: iconColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizPage()),
          );
        },
      ),
      actions: [
        Padding(
          padding:
              const EdgeInsets.only(right: 8.0), // Adjust right padding here
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AvatarPage(),
                ),
              );
            },
            child: isLoading
                ? const CircularProgressIndicator()
                : userData['image'] != null
                    ? CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage(
                            'http://192.168.43.245/CLP/images/pf/' +
                                userData['image']),
                        backgroundColor: Colors.transparent,
                      )
                    : Icon(Icons.account_circle, color: iconColor),
          ),
        ),
      ],
    );
  }
}
