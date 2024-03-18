import 'package:flutter/material.dart';

class Adddiss extends StatefulWidget {
  const Adddiss({Key? key}) : super(key: key);

  @override
  _AdddissState createState() => _AdddissState();
}

class _AdddissState extends State<Adddiss> {
  String? _selectedSubject; // Track the selected subject
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the form
  final _questionController =
      TextEditingController(); // Controller for the question text field
  final _descriptionController =
      TextEditingController(); // Controller for the description text field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new discussion'),
      ),
      backgroundColor: const Color(0xFFFFE8D6),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            // Wrap the Column with Form
            key: _formKey, // Set the GlobalKey
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
                  // Wrap the DropdownButtonFormField with Center
                  child: DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    hint: const Text('Subject'), // Add hint text
                    iconSize: 30, // Increase dropdown icon size
                    elevation: 16,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 18), // Adjust text style
                    decoration: const InputDecoration(
                      border: InputBorder.none, // Remove border
                      contentPadding: EdgeInsets.only(
                          top: 20), // Add padding to move the effect down
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Validate the form
                      // If the form is valid, proceed with further actions
                      // For example, handle form submission or navigation
                    }
                  },
                  child: const Text('Start'),
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
