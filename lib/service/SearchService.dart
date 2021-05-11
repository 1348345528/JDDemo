import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_jd/service/Storage.dart';

class SearchService{

  static setSearchData(value) async{

     try{
       List searchListData = json.decode(await Storage.getString("searchList"));
       print(searchListData);
       
       var hasData = searchListData.any((v){
         return v == value;
       });
       
       if(!hasData){
         searchListData.add(value);
         await Storage.setString('searchList', json.encode(searchListData));
       }
     }catch(e){

       List  tempList = List();
       tempList.add(value);
       await Storage.setString('searchList', json.encode(tempList));
     }


  }

  static getSearchData() async{
    try{
      List searchListData = json.decode(await Storage.getString("searchList"));
      print(searchListData);
      return searchListData.reversed.toList();
    }catch(e){
      return [];
    }
  }
}