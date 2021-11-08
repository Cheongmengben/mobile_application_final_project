import 'package:final_project/postpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'dear_feature/UsernameInputCubit.dart';


class UserNamePage extends StatefulWidget {
  const UserNamePage({ Key? key }) : super(key: key);

  @override
  _UserNamePageState createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Name Page'),
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
                          Container(
                            child:TextFormField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.person),
                                hintText: 'Input field',
                                labelText: 'Username',
                              ),
                              validator: (String? value){
                              if(value == null || value.isEmpty){
                                return "Username cannot be empty";
                              }
                                return null;
                              },
                              onChanged: (String? value){
                                state= value!;
                              }
                            )
                          ),
                          ElevatedButton(
                            onPressed:(){
                            formKey.currentState!.validate()?
                            // ignore: unnecessary_statements
                            {context.read<UsernameInputCubit>().login(state),
                          
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PostPage(name:state)),
                            ) 
                            }:
                            null;
              
                            }, 
                              child: Text('ENTER TO THE APP')
                            )
                          ],
                      )
             );
           }
         )          
        ),
      );
    }
}
