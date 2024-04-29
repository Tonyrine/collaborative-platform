import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'activate.dart'; // Import ActivatePage widget
import 'login.dart'; // Import LoginPage widget

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fname = TextEditingController();
  TextEditingController sname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future register() async {
    var url = Uri.parse("http://192.168.43.245/CLP/register.php");
    var tada = {
      "firstname": fname.text,
      "secondname": sname.text,
      "email": email.text,
      "password": pass.text,
    };
    var response = await http.post(
      url,
      body: jsonEncode(tada),
      headers: {'Content-Type': 'application/json'},
    );

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Registration successful
      if (data['status'] == 'success') {
        print("success");
        // Navigate to ActivatePage and pass email
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivatePage(email: email.text),
          ),
        );
      } else {
        // Registration failed, display error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text(data['message'] ?? 'Unknown error'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle HTTP errors
      print("HTTP Error: ${response.statusCode}");
      print("Response Body: ${response.body}");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Failed'),
            content: Text('Failed to connect to server'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE8D6),
      body: SingleChildScrollView(
        child: Container(
          constraints:
              BoxConstraints.expand(height: MediaQuery.of(context).size.height),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Sign-Up',
                          style: TextStyle(
                            color: Color(0xFFCB997E),
                            fontSize: 35,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                          controller: fname,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                          ),
                          controller: sname,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          controller: email,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          controller: pass,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Handle registration
                                register();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFE8D6),
                            ),
                            child: const Text(
                              'Register',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 19),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            // Navigate back to Login Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: const Text(
                            'Back to Login',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
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
