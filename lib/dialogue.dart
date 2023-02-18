import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyWidget extends StatefulWidget {
   MyWidget({
    super.key,
  required this.titleController,
  required this.desController,
  required this.actions,
  required this.formkey
 

  });
TextEditingController titleController;
  TextEditingController desController;
  List<Widget>actions;
  Key formkey;
  
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                content:Container(
                  width: 200,
                  height: 350,
                  child: Form(
                    key: widget.formkey,
                    child: Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Image(image:AssetImage('assets/notes.jpg')),
                        const Text('Add notes',style: TextStyle(fontSize: 20),),
                        TextFormField(
                          validator: (value){
                            if (value!.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                          controller:widget.titleController ,
                          decoration: const InputDecoration(
                            hintText: 'title',
                          
                            
                          ),
                          
                        ),
                        TextFormField(
                          validator: (value){
                            if (value!.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                          controller:widget.desController ,
                          decoration: const InputDecoration(
                            hintText: 'description',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                actions: widget.actions
              );
  }
}