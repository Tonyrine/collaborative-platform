import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart'; // Import LoginPage widget

class ActivatePage extends StatelessWidget {
  final String email;
  late String token; // Define token variable here

  ActivatePage({Key? key, required this.email}) : super(key: key);

  Future<void> activateAccount(String token, BuildContext context) async {
    var url = Uri.parse("http://192.168.43.245/CLP/activate.php");
    var body = jsonEncode({"email": email, "token": token});

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    var data = jsonDecode(response.body);
    // Handle the response here
    if (data == "success") {
      // Activation successful
      // Navigate to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Activation failed
      // Show SnackBar with failure message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Activation failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE8D6),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Activate your account',
                  style: TextStyle(
                    color: Color(0xFFCB997E),
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter the 4-digit token to activate your account',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: 'Token',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (value) {
                    // Update the token variable when the text changes
                    token = value;
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8D6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Add logic to activate account here
                      await activateAccount(token, context);
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Activate Account',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
