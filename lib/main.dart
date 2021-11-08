import 'package:final_project/createpostpage.dart';
import 'package:final_project/usernamepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'dear_feature/UsernameInputCubit.dart';
import 'package:final_project/postpage.dart';



void main() {
  runApp(MyApp());
  final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
         home: BlocProvider(
          create: (context) => UsernameInputCubit(),
          child: UserNamePage(key:key)
      )   
      //home: CreatePostPage()
       /* home: BlocProvider(
          create: (context) => CreatePostCubit(),
          child: CreatePostPage(key:key)
      )  */ 
    );
  }
}
