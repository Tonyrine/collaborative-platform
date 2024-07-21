import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:clpfus/yolo/appbar.dart';
import 'package:clpfus/yolo/navbar.dart';
import 'package:clpfus/yolo/AddQuestion.dart';
import 'package:clpfus/yolo/AskedQ.dart';
import 'package:clpfus/yolo/chat_page.dart';
import 'package:provider/provider.dart';
import 'package:clpfus/screens/user_id_provider.dart';

class Qanda extends StatefulWidget {
  const Qanda({Key? key}) : super(key: key);

  @override
  _QandaState createState() => _QandaState();
}

class _QandaState extends State<Qanda> {
  List<Map<String, dynamic>> _questionsList = [];
  List<Map<String, dynamic>> _filteredQuestionsList = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _searchController.addListener(_filterQuestions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterQuestions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredQuestionsList = _questionsList.where((item) {
        final matchesQuery = item['title'].toLowerCase().contains(query) ||
            item['description'].toLowerCase().contains(query);
        final matchesCategory =
            _selectedCategory == 'All' || item['subject'] == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  Future<void> _fetchQuestions() async {
    final response = await http.get(
        Uri.parse('http://192.168.43.245/CLP/questions/get_questions.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _questionsList = data.cast<Map<String, dynamic>>();
        _filteredQuestionsList = _questionsList;
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserIdProvider>(context).userId;

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
                      _filterQuestions();
                    },
                  ),
                ),
                onSubmitted: (String value) {
                  _filterQuestions();
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
                      border: Border.all(color: const Color(0xFFCB997E)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                            _filterQuestions();
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
              child: _filteredQuestionsList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredQuestionsList.length,
                      itemBuilder: (context, index) {
                        var question = _filteredQuestionsList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  id: question['id'],
                                  question: question['title'],
                                  description: question['description'],
                                  image: question['image'],
                                  subject: question['subject'],
                                  source: 'qanda',
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
                                      question['title'] ?? 'No Title',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      question['description'] ??
                                          'No Description',
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
      floatingActionButton: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFCB997E),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _showPopupMenu(context, userId);
          },
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CoolBottomNavBar(),
    );
  }

  void _showPopupMenu(BuildContext context, String userId) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final double bottomInset =
        MediaQuery.of(context).padding.bottom; // Get the bottom inset
    final Offset buttonPosition = Offset(
        MediaQuery.of(context).size.width - 80,
        MediaQuery.of(context).size.height -
            bottomInset -
            200); // Adjust the y-coordinate

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        buttonPosition.dx,
        buttonPosition.dy,
        overlay.size.width - buttonPosition.dx,
        overlay.size.height - buttonPosition.dy,
      ),
      items: [
        const PopupMenuItem(
          value: 1,
          child: ListTile(
            leading: Icon(
              Icons.add,
              color: Color(0xFFCB997E),
            ),
            title: Text('Ask New Question'),
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: ListTile(
            leading: Icon(
              Icons.history,
              color: Color(0xFFCB997E),
            ),
            title: Text('My Asked Questions'),
          ),
        ),
      ],
      elevation: 8.0,
    ).then<void>((value) {
      if (value == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddQuestionPage(userId: userId),
          ),
        );
      } else if (value == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AskedQ(),
          ),
        );
      }
    });
  }
}
