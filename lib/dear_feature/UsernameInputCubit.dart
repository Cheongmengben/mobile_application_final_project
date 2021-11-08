import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';


class UsernameInputCubit extends Cubit<String>{
  final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  UsernameInputCubit() : super('');
  String name = '';


  void response(){
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      print(decodedMessage);
      channel.sink.close();
    });
  }

  String login(text){
    channel.sink.add('{"type": "sign_in", "data": { "name": "$text"}}');
    emit(text);
    return state;
  }

  void createPost(title, description, image) {
    channel.sink.add(
        '{"type": "create_post", "data": {"title": "$title", "description": "$description", "image": "$image"}}');
  }

  void deletePost(postid) {
    channel.sink.add('{"type": "delete_post", "data": {"postId": "$postid"}}');
  }

  String getName(){
    return state;
  }
}