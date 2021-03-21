import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_chef/model/SearchProduct_model.dart';
import 'package:home_chef/screens/search_product_details.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/spin_kit.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Search> list = [];
  //List<Search> _search = [];
  //Search search;

  TextEditingController searchController = TextEditingController();

  Future fatchItems()async{
    final uri = Uri.parse("https://apihomechef.masudlearn.com/api/product/search?name=");

    var request = http.Request("POST",uri);
    request.headers.addAll(await CustomHttpRequest.defaultHeader);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    // _search = (jsonDecode(String.fromCharCodes(responseData)) as List)
    //     .map((value) => Search.fromJson(value))
    //     .toList();
//
// print("printing length: ${_search.length}");
//     print("printing---${_search[2].name}");

    var responseString = String.fromCharCodes(responseData);

      print("responseBody1 " + responseString);
      var data = jsonDecode(responseString);
      //search = Search.fromJson(data);
      print("print all search is : $data");
      for(var entry in data){
        Search search = Search(
          id: entry['id'],
          name: entry['name'],
          image: entry['image'],
        );
        try {
          print("all data ${entry['name']}");
          list.firstWhere((element) => element.id == entry['id']);
        } catch (e) {
          if(mounted){
            setState(() {
              list.add(search);
            });
          }
        }
      }

    //_list = Search.fromJson(responseString);
    /*if(response.statusCode == 201){
      for(var item in responseString){
        _list = Search.fromJson(item);
      }
    }*/
    //
    // print("print all list data is$_list");
    // print("print all list data is${_list[2].name}");


  }
  @override
  void initState() {
    fatchItems();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text('Search'),

      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child:Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              height: 50,
              child: TextFormField(
                controller: searchController,
                onChanged: (text){
                  text.toLowerCase();
                  setState(() {
                    list = list.where((item){
                      var itemName = item.name.toLowerCase();
                      return itemName.contains(text);
                    }).toList();
                  });
                },
                decoration: InputDecoration(

                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      gapPadding: 5.0,
                      borderSide:  BorderSide(color: hHighlightTextColor,width: 2.5)),

                  suffixIcon: IconButton( icon: Icon(Icons.search),onPressed: (){

                  },),
                  hintText: "Search here",
                ),

              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
             child: ListView.builder(
                 itemCount: list.length,

                 itemBuilder: (context,index){
                   if(list.length >0){
                     return  _listItems(index);
                   }else{
                     return Center(child: Spin(),);
                   }
                 }),
              ),
          ),
        ],
      ),

    );
  }
  _searchBar(){
   return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: TextFormField(
        controller: searchController,
        onChanged: (text){
          text.toLowerCase();
          setState(() {
            list = list.where((item){
              var itemName = item.name.toLowerCase();
              return itemName.contains(text);
            }).toList();
          });
        },
        decoration: InputDecoration(

          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              gapPadding: 5.0,
              borderSide:  BorderSide(color: hHighlightTextColor,width: 2.5)),

          suffixIcon: IconButton( icon: Icon(Icons.search),onPressed: (){

          },),
          hintText: "Search here",
        ),

      ),
    );
  }

  _listItems(index){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return SearchDetailsPage(id: list[index].id,);
          }));
        },
        title: Text('${list[index].name}', style: TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w500)),
        //subtitle: Text("${list[index].id}"),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              "https://homechef.masudlearn.com/images/${list[index].image}"),
          radius: 30,
        ),
      ),
    );
  }
}
