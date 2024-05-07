import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proj_mobile_flutter/EditCommentPage.dart';
import 'package:proj_mobile_flutter/add_comment_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class BandDetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>>? comments;
  final Map<String, dynamic>? bandData;

  BandDetailsPage({Key? key, required this.bandData, this.comments}) : super(key: key); //get the band that has been selected (pressed on)

  @override
  _BandDetailsPageState createState() => _BandDetailsPageState();
}

class _BandDetailsPageState extends State<BandDetailsPage> {
  Future<String?> getUsernameFromFirestore() async {  //get the current user to check if the username can edit the comments displayed and when the user adds a new comment the username gets passed to the new page
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return null;
    }

    final String currentUserId = currentUser.uid;

    final DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);
    final docSnapshot = await userDocRef.get();

    if (docSnapshot.exists) {
      final username = (docSnapshot.data() as Map<String, dynamic>)['username'];
      return username;
    } else {
      return null;
    }
  }

  Future<bool> isCurrentUser(Map<String, dynamic> commentData) async {
    final String? currentUsername = await getUsernameFromFirestore();

    if (currentUsername == null) {
      return false;
    }

    return commentData['username'] == currentUsername;  //here we check each comment if the user who made it is the user currently on the app (to be able to edit the comment)
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchComments(String bandName) async { //here we go to the comments collection and check each comment if the bandname field in that comment document fits our band name we display it.
    final commentsRef = FirebaseFirestore.instance.collection('comments');
    final querySnapshot = await commentsRef.where('bandName', isEqualTo: bandName).get();
    return querySnapshot.docs;  
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bandData == null) {
      return const Center(
        child: Text(
          "No band data available",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Band: ${widget.bandData?['name']}",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.start, //placement of the children along the axis
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),  //with opacity makes it slightily transparent to make the page look nicer and more put together
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description:",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      " ${widget.bandData?['description'] ?? 'No description provided'}", //check if we have a description in the band data (which we always will have), if null, display no desc provided (also mostly used for testing purposes)
                      style: const TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Comments:",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    const SizedBox(height: 5.0),
                    FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>( //future builder because we are fetching them from the firestore and that helps with performance
                      future: _fetchComments(widget.bandData!['name']), // ! because it cant be null
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final comments = snapshot.data!;
                          return Column(
                            children: comments.map((comment) {
                              return FutureBuilder<bool>(
                                future: isCurrentUser(comment.data()),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final isCurrentUserValue = snapshot.data!;
                                    return _buildCommentTile(context, comment.data(), isCurrentUserValue, comment.id);  //we call the widget we defined down for the comments display
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final String? currentUsername = await getUsernameFromFirestore(); //get the username to pass it to the new page (add comment)
                  if (currentUsername != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCommentPage(bandName: widget.bandData!['name'], username: currentUsername),
                      ),
                    ).then((value) {
                      setState(() {}); // Refresh the comments list
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error: Username not found")), //cannot be called since the user should always be signed in but also used mosly for testing and keeping the app and data secure
                    );
                  }
                },
                child: const Text("Add Comment"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentTile(BuildContext context, Map<String, dynamic> commentData, bool isCurrentUser, String commentId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              commentData['username'] ?? 'Anonymous', //if username null display "anonymous" (cant happen, mostly used in testing the app)
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              commentData['content'],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          if (isCurrentUser)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),  //built in icon for editing
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCommentPage(commentId: commentId, commentData: commentData),
                  ),
                ).then((value) {
                  setState(() {}); // Refresh the comments list
                });
              },
            ),
        ],
      ),
    );
  }
}
