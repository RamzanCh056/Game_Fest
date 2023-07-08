



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/providers/basic_provider.dart';
import 'package:provider/provider.dart';

import '../Model/api_data_model.dart';

class AdminFirestoreServices{
  FirebaseFirestore instance=FirebaseFirestore.instance;

  addSetValue(String setValue)async{
    CollectionReference setsCollection = instance.collection("Sets Value");
    setsCollection.doc('1').set({
      'current set value':setValue
    });
  }

  addChamp(
      List<ChampModel> champList,
      BuildContext context
      )async{
    CollectionReference championCollection = instance.collection(champCollection);
    bool forLoopExecuted=false;

      for (int i = 0; i < champList.length; i++) {
        await championCollection.add(champList[i].toJson()).then((value) => {
        if(i==champList.length-1){
        Provider.of<BasicProvider>(context,listen: false).updateFirebaseDataAdded(),
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Uploaded Successfully"))),


      }
        });


    }

  }

  deleteChamp(
      List<ChampModel> champList,
      List<String> docIds,
      BuildContext context
      )async {
    CollectionReference championCollection = instance.collection(
        champCollection);


      for (int i = 0; i < champList.length; i++) {
        championCollection.doc(docIds[i]).delete();
        // championCollection.doc(docIds[i]).delete();
        // if(i==champList.length-1){
        //   Provider.of<BasicProvider>(context,listen: false).updateFirebadeDataDeleted();
        // }

    }


  }




}