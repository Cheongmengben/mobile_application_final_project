import 'package:favorite_button/favorite_button.dart';
import 'package:final_project/createpostpage.dart';
import 'package:final_project/dear_feature/UsernameInputCubit.dart';
import 'package:final_project/postdetailpage.dart';
import 'package:final_project/postpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({ Key? key, required this.name, required List favoritePost }) : super(key: key);
  final String name;
  late List favoritePost;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
      create: (context) => UsernameInputCubit(),
      child: Favorite_Page(name: name, favoritePost: favoritePost),
    ));
  }
}
class Favorite_Page extends StatefulWidget {
  Favorite_Page({ Key? key, required this.name, favoritePost }) : super(key: key);
  final String name;
  late List favoritePost;
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<Favorite_Page> {
  bool isDescending = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Page'),
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
                isFavorite: true,
              valueChanged: (_isFavorite){
                Navigator.push(
                          context,
                            MaterialPageRoute(
                              builder: (context) => PostPage(name: widget.name))
                              );
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
              itemCount: widget.favoritePost.length,
              itemBuilder: (context, index){
                final sortedPosts = widget.favoritePost..sort((post1, post2){
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
                          isFavorite: false,
                        valueChanged: (){}
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