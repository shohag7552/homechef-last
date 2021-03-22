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



  Future fatchItems() async {
    final uri = Uri.parse(
        "https://apihomechef.masudlearn.com/api/product/search?name=");

    var request = http.Request("POST", uri);
    request.headers.addAll(await CustomHttpRequest.defaultHeader);
    var response = await request.send();
    var responseData = await response.stream.toBytes();

    var responseString = String.fromCharCodes(responseData);

    print("responseBody1 " + responseString);
    var data = jsonDecode(responseString);
    //search = Search.fromJson(data);
    print("print all search is : $data");
    for (var entry in data) {
      Search search = Search(
        id: entry['id'],
        name: entry['name'],
        image: entry['image'],
      );
      try {
        print("all data ${entry['name']}");
        list.firstWhere((element) => element.id == entry['id']);
      } catch (e) {
        if (mounted) {
          setState(() {
            list.add(search);
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
      body:  Container(
        child: ListView.builder(
            itemCount: list.length,

            itemBuilder: (context,index){
              if(list.length >0){
                return  Padding(
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
              }else{
                return Center(child: Spin(),);
              }
            }),
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
    return Center(child: Text(query),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final myList = query.isEmpty? itemsList :
        itemsList.where((element) => element.name.toLowerCase().startsWith(query)).toList();
    return myList.isEmpty ? Center(child: Text('No result found',style: TextStyle(fontSize: 18),)) : ListView.builder(
        itemCount: myList.length,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
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
          );
        });
  }

}