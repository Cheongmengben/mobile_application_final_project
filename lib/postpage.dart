import 'dart:convert';
import 'package:favorite_button/favorite_button.dart';
import 'package:final_project/createpostpage.dart';
import 'package:final_project/favoritepage.dart';
import 'package:final_project/postdetailpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';

import 'dear_feature/UsernameInputCubit.dart';

 class PostPage extends StatelessWidget {
  const PostPage({ Key? key, required this.name }) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
      create: (context) => UsernameInputCubit(),
      child: Post_Page(name: name),
    ));
  }
} 

class Post_Page extends StatefulWidget {
  Post_Page({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<Post_Page> {
bool isDescending = false;
final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
List posts = [];
late List favoritePost = [];
late List displayPost = posts;
bool displayFavorite = false;

void getPosts() {
  channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        posts = decodedMessage['data']['posts'];
      });
      channel.sink.close();
    });
    channel.sink.add('{"type": "get_posts"}');  //send data to server
  }

  void initState(){
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts Page'),
      ),
      body: Column(
        children: <Widget>[ 
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                          icon: const Icon(Icons.add_box_rounded),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreatePostPage(name: widget.name)),
                            );
                          },
                        ),
                    
              TextButton.icon(
                icon: RotatedBox(quarterTurns:1,
                child: Icon(Icons.sort_by_alpha, size: 28),
                ),
                label: Text(
                  isDescending? 'Ascending':'Descending',
                  style: TextStyle(fontSize:16),
                ),
               onPressed: () => setState(() => isDescending =!isDescending)
                ),
              FavoriteButton(
                isFavorite: false,
              valueChanged: (_isFavorite){
                if (_isFavorite == true){
                          setState(() {
                            displayFavorite = true;
                            displayPost = favoritePost;
                          });
                          }
                          else{
                          setState(() {
                            displayFavorite = false;
                            displayPost = posts;
                          });
                          }
              },
            ),
          ],
          ), 
          BlocBuilder<UsernameInputCubit, String>(
                bloc: context.read<UsernameInputCubit>(),
                builder: (context, state) {
                  return Expanded(
            flex:2,
            child: ListView.builder(
              itemCount: displayPost.length,
              itemBuilder: (context, index){
                final sortedPosts = displayPost..sort((post1, post2){
                  var title1 = post1['title'];
                  var title2 = post2['title'];
                if (isDescending == false){
                  return title2.compareTo(title1);} 
                else{
                  return title1.compareTo(title2);}});

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      channel.sink.close();
                        Navigator.push(
                          context,
                            MaterialPageRoute(
                              builder: (context) => PostDetail(
                                title: sortedPosts[index]['title'],
                                description: sortedPosts[index]['description'],
                                url: sortedPosts[index]['image'],
                                name: widget.name,)),
                                
                                      );
                                    },
                  
                  child: Row(
                    children:<Widget> [
                      Container(
                          height: 100,
                          width: 100,
                        child: Image.network('${sortedPosts[index]["image"]}'),
                      ),  
                      Expanded(
                        flex:2,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text('${sortedPosts[index]["title"]}')
                                ),
                              Container(
                                child: Text('${sortedPosts[index]["description"]}')
                                ),
                              Container(
                                child: Text('${sortedPosts[index]["date"]}')
                                ) 
                        ],))
                      ),
                      Container(child: IconButton(
                          icon: const Icon(Icons
                            .delete_forever),
                          color: Colors.black,
                          onPressed: () {
                            context.read<UsernameInputCubit>().login(widget.name);
                            context.read<UsernameInputCubit>().deletePost(sortedPosts[index]["_id"]);
                            context.read<UsernameInputCubit>().response();
                          },
                          ),
                          ),
                      Container(
                        
                        child:FavoriteButton(
                          //isFavorite: false,
                        valueChanged: (_isFavorite){
                          if (_isFavorite == true){  
                          favoritePost.add(displayPost[index]);
                          }
                          else{
                          favoritePost.remove(displayPost[index]);
                          }
                        },
                        ),
                      )
                    ],
                ),
                  )
                );
              },
          )
                  
                  );
                })
                
        ]
      ),
    );
  }
}
