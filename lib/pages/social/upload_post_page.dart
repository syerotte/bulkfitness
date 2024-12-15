import 'package:flutter/material.dart';
import '../../components/my_appbar.dart';

class UploadPostPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onPostSubmitted;

  const UploadPostPage({Key? key, required this.onPostSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController contentController = TextEditingController();

    return Scaffold(
      appBar: MyAppbar(
        showBackButton: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upload a Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind?',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey,
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> newPost = {
                      'username': 'YourUsername', // Replace with actual username logic
                      'category': 'New Post', // You can make this dynamic if needed
                      'content': contentController.text,
                      'comments': [],
                      'likes': 0,
                      'likedBy': <String>{},
                      'image': null, // Optional: You can handle images if needed
                    };
                    onPostSubmitted(newPost);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}