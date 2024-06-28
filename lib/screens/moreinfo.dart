import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'user_id_provider.dart';
import 'package:clpfus/pages/home.dart';

class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;
  late String _university;
  String? _role;

  List<String> _genderOptions = ['Male', 'Female'];
  List<String> _roleOptions = ['Student', 'Lecturer'];

  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState == null) {
      print("Form state is null");
      return; // Defensive check
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final userIdProvider =
          Provider.of<UserIdProvider?>(context, listen: false);
      if (userIdProvider == null) {
        setState(() {
          _isLoading = false;
        });
        print("UserIdProvider not found");
        return;
      }

      final userId = userIdProvider.userId;
      var uri = Uri.parse('http://192.168.43.245/CLP/moreinfo.php');
      var request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = userId.toString()
        ..fields['gender'] = _gender!
        ..fields['university'] = _university
        ..fields['role'] = _role!;

      if (_profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          _profileImage!.path,
        ));
      }

      try {
        var response = await request.send();
        var responseData = await http.Response.fromStream(response);

        if (response.statusCode == 200) {
          var data = jsonDecode(responseData.body);
          if (data['status'] == 'success') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            _showErrorDialog("Update failed: ${data['status']}");
          }
        } else {
          _showErrorDialog('Server error');
        }
      } catch (e) {
        _showErrorDialog('Exception: $e');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE8D6),
      body: SingleChildScrollView(
        child: Container(
          constraints:
              BoxConstraints.expand(height: MediaQuery.of(context).size.height),
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
                  key: _formKey, // Ensure the form key is assigned here
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: const Text(
                          'User Information',
                          style: TextStyle(
                            color: Color(0xFFCB997E),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFFCB997E),
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : null,
                            child: _profileImage == null
                                ? const Icon(Icons.camera_alt,
                                    size: 50, color: Colors.white)
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                        items: _genderOptions.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Choose your gender',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'University',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your university';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _university = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _role,
                        onChanged: (value) {
                          setState(() {
                            _role = value!;
                          });
                        },
                        items: _roleOptions.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Student or Teacher?',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your role';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  print("Button pressed");
                                  _submitForm();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCB997E),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19),
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
    );
  }
}
