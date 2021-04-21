
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_chef/model/SearchProduct_model.dart';
import 'package:home_chef/screens/search_product_details.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/spin_kit.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constant.dart';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  bool onProgress = false;
  List<Search> list = [];

  Future fatchItems() async {
    setState(() {
      onProgress = true;
    });
    final data = await CustomHttpRequest.SearchItems();
    print("value are $data");
    for (var entries in data) {
      Search model = Search(
        id: entries["id"],
        name: entries['name'],
        image: entries['image'],
      );
      try {
        print(" view my entries are  ${entries['name']}");
        list.firstWhere((element) => element.id == entries['id']);
        setState(() {
          onProgress = false;
        });
      } catch (e) {
        if (mounted) {
          setState(() {
            list.add(model);
            onProgress = false;
          });
        }
      }
    }
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
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchHere(itemsList: list));
            },
            icon: Icon(Icons.search),)
        ],
      ),
      body:  ModalProgressHUD(
        inAsyncCall: onProgress,
        opacity: 0.2,
        progressIndicator: Spin(),
        child: Container(
          padding: EdgeInsets.only(top: 5),
          child: ListView.builder(
              itemCount: list.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index){
                if(list.length >0){
                  return  Card(
                    elevation: 0.2,
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
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
                        // subtitle: Text("${list[index].price[0].originalPrice}"),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://homechef.masudlearn.com/images/${list[index].image}"),
                          radius: 30,
                        ),
                      ),
                    ),
                  );
                }else{
                  return Container(child: Center(child: Spin(),));
                }
              }),
        ),
      ),
    );
  }
}
class SearchHere extends SearchDelegate<Search>{
  final List<Search> itemsList;
  SearchHere({this.itemsList});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: (){
      query = "";
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
      close(context, null);
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    final myList = query.isEmpty? itemsList :
    itemsList.where((element) => element.name.toLowerCase().startsWith(query)).toList();
    return  myList.isEmpty ? Center(child: Text('No result found',style: TextStyle(fontSize: 18),)) : ListView.builder(
        itemCount: myList.length,
        itemBuilder: (context,index){
          return Card(
            elevation: 0.2,
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return SearchDetailsPage(id: myList[index].id,);
                  }));
                },
                title: Text(myList[index].name.toString()),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://homechef.masudlearn.com/images/${myList[index].image}"),
                  radius: 30,
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final myList = query.isEmpty? itemsList :
    itemsList.where((element) => element.name.toLowerCase().startsWith(query)).toList();
    return myList.isEmpty ? Center(child: Text('No result found',style: TextStyle(fontSize: 18),))
        : Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
          itemCount: myList.length,
          itemBuilder: (context,index){
            return Card(
              elevation: 0.2,
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return SearchDetailsPage(id: myList[index].id,);
                    }));
                  },
                  title: Text(myList[index].name.toString()),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://homechef.masudlearn.com/images/${myList[index].image}"),
                    radius: 30,
                  ),
                ),
              ),
            );
          }),
        );
  }

}


/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_chef/model/SearchProduct_model.dart';
import 'package:home_chef/screens/search_product_details.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/spin_kit.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constant.dart';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();

  bool onProgress = false;
  List<Search> searchList = [];
  Search search ;

  Future searchItems() async {
    */
/*setState(() {
      onProgress = true;
    });*//*

    final uri = Uri.parse(
        "https://apihomechef.masudlearn.com/api/search/product");

    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequest.defaultHeader);
    print('going');
    //request.bodyFields
    request.fields['name'] = searchController.text.toString();
    print('gone');
    var response = await request.send();
    print(response.statusCode);
    var responseData = await response.stream.toBytes();

    var responseString = String.fromCharCodes(responseData);

    print("responseBody1 " + responseString);
    var data = jsonDecode(responseString);
   // search = Search.fromJson(data);
    print("print all search is : $data");
    */
/*print("print all search is : $search");
    setState(() {
      onProgress =false;
    });*//*

    */
/*if(response.statusCode == 200){
      for (var entry in data){
        search = Search.fromJson(entry);
        searchList.add(search);
      }
    }*//*

    for (var entry in data) {
      Search search = Search(
        id: entry['id'],
        name: entry['name'],
        image: entry['image'],
      );
      try {
        print("all data ${entry['name']}");
        searchList.firstWhere((element) => element.id == entry['id']);
        setState(() {
          onProgress = false;
        });
      } catch (e) {
        if (mounted) {
          setState(() {
            searchList.add(search);
            onProgress = false;
          });
        }
      }
    }
  }

  @override
  void initState() {

    //searchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search..'
          ),
          onSaved: (value){

            searchItems();
          },
          autofocus: true,

        ),
        leading: IconButton(icon: Icon(Icons.clear),onPressed: (){
          searchController.text = '';
          searchList = null;

        },),
        actions: [
          IconButton(
            onPressed: () {
              //showSearch(context: context, delegate: SearchHere(itemsList: list));
              searchItems();
            },
            icon: Icon(Icons.search),)
        ],
      ),
      body:  Container(
        child:searchList.isEmpty ? Center(child: Text('search'),) : searchController.text.isEmpty? Center(child: Text('search'),) : ListView.builder(
            itemCount: searchList.length,

            itemBuilder: (context,index){

                return  Card(
                  elevation: 0.2,
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return SearchDetailsPage(id:searchList[index].id,);
                        }));
                      },
                      title: Text('${searchList[index].name}', style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w500)),
                      //subtitle: Text("${list[index].id}"),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://homechef.masudlearn.com/images/${searchList[index].image}"),
                        radius: 30,
                      ),
                    ),
                  ),
                );

            }) ,
      ),
    );
  }
}*/
