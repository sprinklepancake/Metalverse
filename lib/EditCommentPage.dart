import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EditCommentPage extends StatefulWidget {
  final String commentId;
  final Map<String, dynamic> commentData;

  const EditCommentPage({super.key, required this.commentId, required this.commentData});   //get the comment id we are working wit as well as the data (the data contains the actual comment text that we want to modify)

  @override
  _EditCommentPageState createState() => _EditCommentPageState();
}

class _EditCommentPageState extends State<EditCommentPage> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the controller with existing comment content
    final String initialComment = widget.commentData['content'] ?? '';  //fill the comment text editing controller with the comment text we got from the previous page, if content is null make it be '' (cant be null, mostly used in testing)
    _commentController.text = initialComment;
  }

  Future<void> updateComment() async {
    final String commentText = _commentController.text.trim();
    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a comment")),
      );
      return;
    }

    final updatedCommentData = {
      'content': commentText,
    };

    try {
      // Update the comment in Firestore
      final commentRef = FirebaseFirestore.instance.collection('comments').doc(widget.commentId);
      await commentRef.update(updatedCommentData);

      Navigator.pop(context); //after updating the comment, we leave the page back to the band details page
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating comment: $error")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Comment'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF212121),
              Color(0xFF1a1a1a), 
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _commentController, //controller to handle the comment text
                maxLines: null, // Allow multiline editing
                decoration: InputDecoration(
                  labelText: "Edit your comment",
                  fillColor: Colors.grey,
                  filled: true,
                  contentPadding: const EdgeInsets.all(10.0), 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: Colors.grey, 
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0), 
              ElevatedButton(
                onPressed: updateComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400], //manage how strong i want the colors to be
                  foregroundColor: Colors.white, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text('Save Comment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}