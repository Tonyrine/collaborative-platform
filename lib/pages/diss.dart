import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:clpfus/yolo/appbar.dart';
import 'package:clpfus/yolo/navbar.dart';
import 'package:clpfus/yolo/Adddiss.dart';
import 'package:clpfus/yolo/chat_page.dart';

class Diss extends StatefulWidget {
  const Diss({Key? key}) : super(key: key);

  @override
  _DissState createState() => _DissState();
}

class _DissState extends State<Diss> {
  List<Map<String, dynamic>> _dissList = [];
  List<Map<String, dynamic>> _filteredDissList = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _fetchDiss();
    _searchController.addListener(_filterDiss);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDiss() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDissList = _dissList.where((item) {
        final matchesQuery = item['title'].toLowerCase().contains(query) ||
            item['description'].toLowerCase().contains(query);
        final matchesCategory =
            _selectedCategory == 'All' || item['subject'] == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  Future<void> _fetchDiss() async {
    final response = await http
        .get(Uri.parse('http://192.168.43.245/CLP/diss/get_diss.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _dissList = data.cast<Map<String, dynamic>>();
        _filteredDissList = _dissList;
      });
    } else {
      throw Exception('Failed to load diss');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'All',
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
                controller: _searchController,
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
                      _filterDiss();
                    },
                  ),
                ),
                onSubmitted: (String value) {
                  _filterDiss();
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Subject:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Color(0xFFCB997E)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                            _filterDiss();
                          });
                        },
                        items: categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredDissList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredDissList.length,
                      itemBuilder: (context, index) {
                        var item = _filteredDissList[index];
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
                                  source: 'diss', // Indicate the source
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
}
