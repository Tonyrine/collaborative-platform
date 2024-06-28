import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:clpfus/screens/user_id_provider.dart';
import 'package:clpfus/pages/qanda.dart'; // Import the destination screen

class AddQuestionPage extends StatefulWidget {
  final String userId;

  const AddQuestionPage({Key? key, required this.userId}) : super(key: key);

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  String? _selectedSubject;
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String subject = _selectedSubject!;
      String question = _questionController.text;
      String description = _descriptionController.text;
      String userId = widget.userId;

      try {
        var url =
            Uri.parse('http://192.168.43.245/CLP/questions/add_questions.php');
        var request = http.MultipartRequest('POST', url);

        request.fields['subject'] = subject;
        request.fields['question'] = question;
        request.fields['description'] = description;
        request.fields['userId'] = userId;

        if (_imageFile != null) {
          String fileName = _imageFile!.path.split('/').last;
          request.files.add(await http.MultipartFile.fromPath(
              'image', _imageFile!.path,
              filename: fileName));
        }

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          var parsedResponse = jsonDecode(response.body);

          if (parsedResponse['status'] == 'success') {
            print("Success");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text('Question added successfully!'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Qanda()),
                        );
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );

            _questionController.clear();
            _descriptionController.clear();
            setState(() {
              _selectedSubject = null;
              _imageFile = null;
            });
          } else {
            _showErrorDialog(
                'Error', parsedResponse['message'] ?? 'Unknown error');
          }
        } else {
          _showErrorDialog('HTTP Error', 'Failed to connect to server');
        }
      } catch (e) {
        _showErrorDialog(
            'Exception', 'An error occurred. Please try again later.');
        print("Exception: $e");
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Question'),
      ),
      backgroundColor: const Color(0xFFFFE8D6),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  height: 65,
                  child: DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    hint: const Text('Subject'),
                    iconSize: 30,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a subject';
                      }
                      return null;
                    },
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSubject = newValue;
                      });
                    },
                    items: [
                      'Engineering',
                      'Computer Science',
                      'Business',
                      'Medicine',
                      'Arts',
                      'Law',
                      'Education',
                      'Social Sciences',
                    ].map((String subject) {
                      return DropdownMenuItem<String>(
                        value: subject,
                        child: Text(subject),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  height: 65,
                  child: TextFormField(
                    controller: _questionController,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the main question';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Main Question',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(top: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(top: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
                const SizedBox(height: 10),
                _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('ASK'),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(60)),
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
