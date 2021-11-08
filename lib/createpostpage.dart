import 'dart:convert';
import 'dart:ffi';
import 'package:final_project/postpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'dear_feature/UsernameInputCubit.dart';
class CreatePostPage extends StatelessWidget {
  const CreatePostPage({ Key? key, required this.name }) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
          create: (context) => UsernameInputCubit(),
          child: Create_Post_Page(name: name))
      );   
  }
}
class Create_Post_Page extends StatefulWidget {
  const Create_Post_Page({ Key? key, required this.name }) : super(key: key);
  final String name;

  @override
  State<Create_Post_Page> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<Create_Post_Page> {
  final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

 String title = "";
 String description = "";
 String image = "";
 List response = [];

 void initState(){
   super.initState();
 }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post Page'),
      ),
      body: Center(
           child: BlocBuilder<UsernameInputCubit, String>(
                bloc: context.read<UsernameInputCubit>(),
                builder: (context, state) {
                  return Form(
                    key: formKey,
                    child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: <Widget>[
            /* Container(
              child: Text('Title', textAlign:TextAlign.left, style:TextStyle(fontSize: 20),)
            ), */
            Container(
              child:TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                hintText: 'Title',
                labelText: 'Title'
                ),
                 validator: (String? value){
                    if(value == null || value.isEmpty){
                      return "Title cannot be empty";
                      }
                      return null;
                    },
                onChanged: (String? value){
                     title = value!;
                } 
              )
            ),
            Container(
                child:TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      ),
                    hintText: 'Description',
                    labelText: 'Description',
                    contentPadding: EdgeInsets.symmetric(vertical:50, horizontal: 10)
                  ),
                 validator: (String? value){
                    if(value == null || value.isEmpty){
                      return "Description cannot be empty";
                      }
                      return null;
                    },
                onChanged: (String? value){
                      description = value!;
                } 
                )
              ),
            Container(
              child:TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                hintText: 'Image URL',
                labelText: 'Image URL',
                ),
                validator: (String? value){
                    if(value == null || value.isEmpty){
                      return "Image URL cannot be empty";
                      }
                      return null;
                    },
                onChanged: (String? value){
                    image = value!;
                }
              )
            ),

            Expanded(
              flex: 5,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget> [
                ElevatedButton(
                  onPressed:(){ 
                      formKey.currentState?.validate()?? false ?
                      // ignore: unnecessary_statements
                      {context.read<UsernameInputCubit>().login(widget.name),
                       context.read<UsernameInputCubit>().createPost(title, description, image),
                       context.read<UsernameInputCubit>().response(), 
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostPage(name: widget.name)))
                      }: null;
                  },
                  child: Text('CREATE POST')
                ),
                ElevatedButton(onPressed:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostPage(name: widget.name)),
                  ); 
                }, 
                  child: Text('CANCEL')
                ),
              ],
             )
            )
          ]
                    )
      );
                }
                )
                )
      );    
      

        

  }
}