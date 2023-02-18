import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:notes_app/dialogue.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final titleController=TextEditingController();
  final desController=TextEditingController();

  var formkey=GlobalKey<FormState>();
var isVisible=false;
  @override
  Widget build(BuildContext context) {


    var firestore= FirebaseFirestore.instance.collection('Notes').snapshots();

   log('Printing data');
    return Scaffold(
      
      appBar: AppBar(
       
        title: Text(widget.title),
        centerTitle: true,
      ),
      body:StreamBuilder(
        stream: firestore,
        builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
          if (snapshot.connectionState==ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Some Error'),);
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              String title=snapshot.data!.docs[index]['title'];
              String desc=snapshot.data!.docs[index]['desc'];
              String docId=snapshot.data!.docs[index]['docId'];

              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListTile(
                  leading: InkWell(
                    onTap: (){
                      setState(() {
                        isVisible=true;
                      });
                      showDialog(
          
            context: context,
             builder: (context){
              return Visibility(
                visible: isVisible,
                child: AlertDialog(
                  content:Container(
                    width: 200,
                    height: 300,
                    child: Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Image(image:AssetImage('assets/notes.jpg')),
                        const Text('Add notes',style: TextStyle(fontSize: 20),),
                        TextFormField(
                          
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: 'title',
                          ),
                        ),
                        TextFormField(
                          controller: desController,
                          
                          decoration: const InputDecoration(
                            hintText: 'description',
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton
                    (onPressed: (){
              
                      Navigator.pop(context);
                      titleController.clear();
                      desController.clear();
                    }, child: Text('Cancel')),
                     TextButton
                    (onPressed: (){
                      if (titleController.text.isNotEmpty &&desController.text.isNotEmpty) {
                        setState(() {
                        var firestore= FirebaseFirestore.instance.collection('Notes').doc(docId).update({
                        'title':titleController.text,
                        'desc':desController.text,
                        

                      }).then((value) {
                        titleController.clear();
                        desController.clear();
                      });
                     });
                      }
                     
                      Navigator.pop(context);
                    }, child: Text('Update'))
                  ],
                ),
              );
             
             }
             );
          
                    },
                    child:const  Icon(Icons.edit,size: 30,)
                    
                    ),
                  trailing:InkWell(
                    onTap: (){
                      FirebaseFirestore.instance.collection('Notes').doc(docId).delete();
                    },
                    child: const Icon(Icons.delete_forever,color: Colors.red,size: 30,)
                    ) ,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.brown,width: 1)
                  ),
                  title: Text(title),
                  subtitle: Text(desc),
                ),
              );
            }
            );
        }
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         
          showDialog(
            context: context,
             builder: (context){
              return  MyWidget(
                formkey: formkey,
            desController:desController ,
            titleController: titleController,
            actions: [
              TextButton
                  (onPressed: (){

                    Navigator.pop(context);
                    titleController.clear();
                    desController.clear();
                  }, child: Text('Cancel')),
                   TextButton
                  (onPressed: (){
                   setState(() {
                      if (formkey.currentState!.validate()) {
                        addData();
                         Navigator.pop(context);
                      }
                   });
                   
                  }, child: Text('Add'))
            ],
           );
             }
             );
          

            // showDialog(
          
            // context: context,
            //  builder: (context){
            //   return AlertDialog(
            //     content:Container(
            //       width: 200,
            //       height: 300,
            //       child: Column(
                    
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const Image(image:AssetImage('assets/notes.jpg')),
            //           const Text('Add notes',style: TextStyle(fontSize: 20),),
            //           TextField(
            //             controller:titleController ,
            //             decoration: const InputDecoration(
            //               hintText: 'title',
            //             ),
            //           ),
            //           TextField(
            //             controller:desController ,
            //             decoration: const InputDecoration(
            //               hintText: 'description',
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //     actions: [
            //       TextButton
            //       (onPressed: (){

            //         Navigator.pop(context);
            //         titleController.clear();
            //         desController.clear();
            //       }, child: Text('Cancel')),
            //        TextButton
            //       (onPressed: (){
            //        setState(() {
            //           addData();
            //        });
            //         Navigator.pop(context);
            //       }, child: Text('Add'))
            //     ],
            //   );
             
            //  }
            //  );
          
        },
        tooltip: 'Add Notes',
        child: const Icon(Icons.add),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  
  }
  updateData(){
    
  }
   
  
  addData(){
  var docId=DateTime.now().millisecondsSinceEpoch.toString();

    var firestore= FirebaseFirestore.instance.collection('Notes').doc(docId).set({
      'title':titleController.text,
      'desc':desController.text,
      'docId':docId,

    }).then((value) {
      titleController.clear();
      desController.clear();
    });


  }

 

}
