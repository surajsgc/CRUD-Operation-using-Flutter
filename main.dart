import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  final firebase = FirebaseFirestore.instance;

  create()async{
    try{
      await firebase.collection("User").doc(name.text).set({"name":name.text, "email":email.text});
    }catch(e){
      print(e);
    }
  }

  update()async{
    try{
      firebase.collection("User").doc(name.text).update({'email':email.text});
    }catch(e){
      print(e);
    }
  }

  delete()async{
    try{
      firebase.collection("User").doc(name.text).delete();
    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crud Operations in Flutter"),
      ) ,


      body:
      SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child:Column(

          children: [

            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText:"User Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText:"Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: (){
                      create();
                      name.clear();
                      email.clear();
                    },
                    child: const Text("Create")),

                ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: (){
                      update();
                      name.clear();
                      email.clear();

                    },
                    child: const Text("Update")),

                ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: (){
                      delete();
                      name.clear();
                      email.clear();
                    },
                    child: const Text("Delete")),


              ],
            ),
            Container(
              height: 300,
              width: double.infinity,
              child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firebase.collection("User").snapshots(),
                      builder: (context,snapshot) {
                        if(snapshot.hasData){
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                QueryDocumentSnapshot x = snapshot.data!.docs[i];
                                return ListTile(
                                  title: Text(x['name']),
                                  subtitle: Text(x['email']),
                                );
                              }
                          );
                        } else {
                          return Center(child:CircularProgressIndicator());
                        }
                      },
                  ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}