import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:clpfus/yolo/appbar.dart';
import 'package:clpfus/yolo/navbar.dart';
import 'package:clpfus/yolo/Adddiss.dart';
import 'package:clpfus/yolo/category_tags.dart';
import 'package:clpfus/yolo/chat_page.dart';

class Diss extends StatelessWidget {
  const Diss({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'Engineering',
      'Computer Science',
      'Business',
      'Medicine',
      'Arts',
      'Law',
      'Education',
      'Social Sciences',
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color(0xFFFFE8D6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: const TextStyle(color: Color(0xFFCB997E)),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Color(0xFFCB997E)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: const Color(0xFFCB997E),
                    onPressed: () {
                      // Implement search functionality here
                      // Access the text field value using TextEditingController
                      // Example:
                      // controller.text
                    },
                  ),
                ),
                onSubmitted: (String value) {
                  // Handle search when submitted
                },
              ),
            ),
            const SizedBox(height: 20),
            CategoryTags(categories: categories),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchDiss(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Map<String, dynamic>> diss = snapshot.data!;
                    return ListView.builder(
                      itemCount: diss.length,
                      itemBuilder: (context, index) {
                        var item = diss[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the chat page with the question data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    id: item['id'], // Pass the id
                                    question: item['title'],
                                    description: item['description'],
                                    image: item['image'],
                                    subject: item['subject'],
                                    source: 'diss' // Indicate the source
                                    ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] ?? 'No Title',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      item['description'] ?? 'No Description',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 8),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Adddiss()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFCB997E),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CoolBottomNavBar(),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchDiss() async {
    final response = await http
        .get(Uri.parse('http://192.168.43.245/CLP/diss/get_diss.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load diss');
    }
  }
}
