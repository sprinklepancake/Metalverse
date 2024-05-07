import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCommentPage extends StatefulWidget {
  final String bandName;
  final String username;  //these 2 are passed from the band details page since each band has their own comments section

  const AddCommentPage({Key? key, required this.bandName, required this.username}) : super(key: key);

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final _commentController = TextEditingController(); //handling the comment text

  Future<void> addComment() async {
    final String commentText = _commentController.text.trim();
    if (commentText.isEmpty) {  //check if user entered an empty comment
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a comment")),
      );
      return;
    }

    final commentData = {
      'content': commentText,
      'username': widget.username,  //passed by previous page
      'timestamp': FieldValue.serverTimestamp(),  //get the time of the comment using a built in function
      'bandName': widget.bandName,  //also passed by previous page
    };

    try {
      // Access Firestore to add comment to comments collection
      final commentsRef = FirebaseFirestore.instance.collection('comments');
      await commentsRef.add(commentData); //add the comment to the comments collection and it will have an auto generated ID

      Navigator.pop(context); 
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding comment: $error")),  //if somehow an error occurs, display error (mainly used in my testing phase)
      );
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text("Add Comment"),
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
                controller: _commentController,   //controller we defined earlier to handle comment text
                decoration: InputDecoration(
                  labelText: "Enter your comment",
                  fillColor: Colors.grey,
                  filled: true, 
                  contentPadding: const EdgeInsets.all(10.0), 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),   //make it circular since it looks better
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                maxLines: null, //allow the addition of multi line comments
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: addComment,
                child: const Text("Submit Comment"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  foregroundColor: Colors.black, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
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
