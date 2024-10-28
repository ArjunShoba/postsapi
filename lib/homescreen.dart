import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postapi/post.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<PostApi> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  Future<PostApi> fetchPosts() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/posts'));

    if (response.statusCode == 200) {
      return postApiFromJson(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: FutureBuilder<PostApi>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.posts.isEmpty) {
            return Center(child: Text('No posts found.'));
        
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.posts.length,
              itemBuilder: (context, index) {
                final post = snapshot.data!.posts[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(post.body),
                        SizedBox(height: 8.0),
                        Text('Tags: ${post.tags.join(', ')}'),
                        SizedBox(height: 8.0),
                        Text(
                            'Likes: ${post.reactions.likes}, Dislikes: ${post.reactions.dislikes}'),
                        SizedBox(height: 4.0),
                        Text('Views: ${post.views}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
