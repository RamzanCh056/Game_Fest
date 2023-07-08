

import 'package:cloud_firestore/cloud_firestore.dart';

String champCollection= 'Champ';
String compCollection = 'Comp Collection';
String champTraitsCollection='Comp_Collection_Champ_Traits';

class CompCollectionFields{
  String docId = 'Document Id';
  ///
  /// Champlist length is used for position champ on main screen according
  /// to the position of team builder
  ///
  ///     String champListLength = ChampList Length
  String champListLength="ChampList Length";
}

class CompCollectionModel{
  String docId;
  String champListLength;
  CompCollectionModel({
    required this.docId,
    required this.champListLength
  });

  factory CompCollectionModel.fromJson(DocumentSnapshot json)=>
      CompCollectionModel(
          docId: json[CompCollectionFields().docId],
        champListLength: json[CompCollectionFields().champListLength]

      );

}



class ChampModelFields{
  String champName='Champ Name';
  String imagePath = 'Image Path';
  String champCost = 'Champ Cost';
  String champTraits='Champ Traits';
  String champPositionIndex="champ position index";

}

class ChampModel{
  String champName;
  String imagePath;
  String champCost;
  List champTraits;
  String champPositionIndex;

  ChampModel({
    required this.champName,
    required this.imagePath,
    required this.champCost,
    required this.champTraits,
    required  this.champPositionIndex
  });

  Map<String, dynamic> toJson() {
    return{
      ChampModelFields().champName: champName,
      ChampModelFields().imagePath:imagePath,
      ChampModelFields().champCost:champCost,
      ChampModelFields().champTraits:champTraits,
      ChampModelFields().champPositionIndex:champPositionIndex
    };
  }

  factory ChampModel.fromJson(Map<String, dynamic> json)=>ChampModel(
      champName: json[ChampModelFields().champName],
      imagePath: json[ChampModelFields().imagePath],
    champCost: json[ChampModelFields().champCost],
    champTraits: json[ChampModelFields().champTraits],
    champPositionIndex: json[ChampModelFields().champPositionIndex]
  );

  factory ChampModel.fromJsonFirebase(DocumentSnapshot json)=>ChampModel(
      champName: json[ChampModelFields().champName],
      imagePath: json[ChampModelFields().imagePath],
    champCost: json[ChampModelFields().champCost],
    champTraits: json[ChampModelFields().champTraits],
      champPositionIndex: json[ChampModelFields().champPositionIndex]
  );

}



