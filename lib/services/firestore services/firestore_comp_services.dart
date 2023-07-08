


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/basic_provider.dart';
import '../../providers/comp_list_provider.dart';
import '../../screens/Admin/Model/api_data_model.dart';

class FirestoreCompServices{
  FirebaseFirestore instance = FirebaseFirestore.instance;

  addComp(
      String docId,
      List<ChampModel> champList,
      String champListLength,
      BuildContext context
      )async{
    CollectionReference comp_Collection = instance.collection(compCollection);

    comp_Collection.doc(docId).set({
      CompCollectionFields().docId:docId,
      CompCollectionFields().champListLength:champListLength});
    for(int i=0; i<champList.length;i++){
      await comp_Collection.doc(docId).collection(champCollection).add(champList[i].toJson());

    }

  }

  List<CompCollectionModel> compCollectionList=[];
  List<String> docIds=[];
  List<List<ChampModel>> compChampionsList=[];
  fetchFirestoreData(BuildContext context)async{
    QuerySnapshot compQuery=await instance.collection(compCollection).get();
    if(compQuery.docs.isNotEmpty){

      for(int i=0;i<compQuery.docs.length;i++){
        CompCollectionModel singleComp= CompCollectionModel.fromJson(compQuery.docs[i]);
        compCollectionList.add(singleComp);
        docIds.add(compQuery.docs[i].id);
        QuerySnapshot champQuery=await instance.collection(compCollection).doc(compQuery.docs[i].id).collection(champCollection).get();
        List<ChampModel> champListFromQurey=[];
        for(int j=0;j<champQuery.docs.length;j++){
          ChampModel champFromQuery=ChampModel.fromJsonFirebase(champQuery.docs[j]);
          champListFromQurey.add(champFromQuery);
        }
        compChampionsList.add(champListFromQurey);
      }

    }
    Provider.of<CompListProvider>(context,listen: false).updateCompList(compCollectionList, docIds,true);
  }





}