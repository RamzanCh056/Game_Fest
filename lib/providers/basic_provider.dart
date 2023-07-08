
import 'package:flutter/material.dart';
import '/screens/Admin/Model/api_data_model.dart';

class BasicProvider with ChangeNotifier{
  String baseUrl = 'https://raw.communitydragon.org/latest/game/';
  String apiImageUrl =  'https://raw.communitydragon.org/pbe/plugins/rcp-be-lol-game-data/global/default/assets/characters/';
  bool isLoading=false;
  bool firebaseDataDeleted = false;
  bool firebaseDataAdded = false;
  bool dataFetched=false;
  List<ChampModel> chosenTeam=[];
  List<String> chosenTeamIndexes=[];
  List<ChampModel> teamBuilderChamps=[];

  updateTeamBuilderChamps(List<ChampModel> champ){
    teamBuilderChamps = champ;
    notifyListeners();
  }

  List<List<ChampModel>> compChampList=[];
  updateCompChampList(List<List<ChampModel>> compChampionsList){
    compChampList=compChampionsList;
    notifyListeners();
  }
  sortChampList(bool isTeamBuilder){
    if(isTeamBuilder){
      teamBuilderChamps.sort((a,b)=>(a.champName+a.champCost).compareTo(b.champName+b.champCost));
      // teamBuilderChamps=teamBuilderChamps.reversed.toList();
    }else{
      teamBuilderChamps.sort((a,b)=>(a.champName+a.champCost).compareTo(b.champName+b.champCost));
      // champListFromFirebase=champListFromFirebase.reversed.toList();
    }

    notifyListeners();
  }


  sortChampListZtoA(bool isTeamBuilder){
    if(isTeamBuilder){
      // teamBuilderChamps.sort((a,b)=>(a.champName+a.champCost).compareTo(b.champName+b.champCost));
      teamBuilderChamps=teamBuilderChamps.reversed.toList();
    }else{
      // teamBuilderChamps.sort((a,b)=>(a.champName+a.champCost).compareTo(b.champName+b.champCost));
      champListFromFirebase=champListFromFirebase.reversed.toList();
    }

    notifyListeners();
  }


  sortCompChampListByAtoZ(){
    List<List<ChampModel>> temporaryCompChampList=[];
    for(int i=0; i<compChampList.length;i++){
      List<ChampModel> temporaryChampList=compChampList[i].reversed.toList();
      temporaryCompChampList.add(temporaryChampList);
    }
    compChampList=temporaryCompChampList;
    notifyListeners();
  }



  updataDataFetched(){
    dataFetched=true;
    notifyListeners();
  }

  updateChosenTeam(ChampModel champ,String index){
    chosenTeam.add(champ);
    chosenTeamIndexes.add(index);
    notifyListeners();
  }

  resetChosenTeam(){
    chosenTeam.clear();
    chosenTeamIndexes.clear();
    notifyListeners();
  }


  startLoading(){
    isLoading= true;
    notifyListeners();
  }

  stopLoading(){
    isLoading= false;
    notifyListeners();
  }

  updateFirebaseDataDeleted(){
    firebaseDataDeleted=true;
    notifyListeners();
  }

  resetFirebaseDataDeleted(){
    firebaseDataDeleted=false;
    notifyListeners();
  }

  updateFirebaseDataAdded(){
    firebaseDataAdded=true;
    notifyListeners();
  }

  resetFirebaseDataAdded(){
    firebaseDataAdded=true;
    notifyListeners();
  }




  /// ************************************************************
///

  ///       ======> Code for optimization of left side widget <======
  ///

  List<ChampModel> champListFromFirebase =[];
  List<ChampModel> foundData =[];

  TextEditingController searchController=TextEditingController();
  bool visibleSearchData = false;
  bool isVisibleDataFromFirebase=false;

  void runFilter(String enteredKeyword,bool isTeamBuilder) {

    List<ChampModel> results = [];
    if (enteredKeyword.isEmpty) {
      isVisibleDataFromFirebase=true;
      visibleSearchData=false;
      notifyListeners();
    } else {
      isVisibleDataFromFirebase=false;
      visibleSearchData=true;
      if(isTeamBuilder){
        results = teamBuilderChamps.where((user) =>
            user.champName.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();

      }else{
        results = champListFromFirebase.where((user) =>
            user.champName.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
      }

    }
    foundData=results;

    notifyListeners();
  }

  updateFirebaseDataFetchedLeftSideWidget(List<ChampModel> champList){
    champListFromFirebase.clear();
    champListFromFirebase=champList;
    isVisibleDataFromFirebase=true;
    notifyListeners();
  }




}
