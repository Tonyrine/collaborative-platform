import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:clpfus/screens/user_id_provider.dart';
import 'package:clpfus/screens/login.dart'; // Import your login page
import 'package:clpfus/screens/update.dart'; // Import your update page

class AvatarPage extends StatefulWidget {
  const AvatarPage({Key? key}) : super(key: key);

  @override
  _AvatarPageState createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
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

  Future<void> _logout() async {
    final response = await http.get(
      Uri.parse('http://192.168.43.245/CLP/logout.php'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, // Remove all routes from stack
        );
      } else {
        _showErrorDialog('Failed to logout');
      }
    } else {
      _showErrorDialog('Server error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your profile'),
      ),
      backgroundColor: const Color(0xFFFFE8D6),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                backgroundImage: userData['image'] != null
                                    ? NetworkImage(
                                        'http://192.168.43.245/CLP/images/pf/' +
                                            userData['image'])
                                    : const AssetImage('assets/prof.jpg')
                                        as ImageProvider,
                                onBackgroundImageError:
                                    (exception, stackTrace) {},
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
                        Text(
                          '${userData['firstname']} ${userData['secondname']}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                                border: TableBorder.symmetric(
                                  inside: BorderSide.none,
                                  outside: BorderSide.none,
                                ),
                                children: [
                                  _buildUserInfoItem(
                                      'Email', userData['email']),
                                  _buildUserInfoItem(
                                      'Gender', userData['gender']),
                                  _buildUserInfoItem(
                                      'Program', 'Computer Science'),
                                  _buildUserInfoItem(
                                      'University', userData['uni']),
                                  _buildUserInfoItem('Role', userData['role']),
                                  _buildUserInfoItem('Password',
                                      '******'), // For security, don't show the password
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Row containing buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdatePage(
                                            userData: userData,
                                          ),
                                        ),
                                      );
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
                                    onPressed: _logout,
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
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
