import 'package:flutter/cupertino.dart';
import 'package:home_chef/model/profile_model.dart';
import 'package:home_chef/server/http_request.dart';

class ProfileProvider with ChangeNotifier{
  List<Profile> _profileData = [];
  List<Profile> get profileData {
    return _profileData;
  }
  Profile profile;


  Future<dynamic> fetchProfile() async {
    final data = await CustomHttpRequest.getProfile();

    print("Profile data are $data");
     profile = Profile.fromJson(data);
      //name = profile.name;


   // print(name);
    print(
        '....#####################.............');
    print(profile);
    print(
        '.......#############################.......');

    try {
      _profileData.firstWhere((element) => element.email == profile.email);
    } catch (e) {
      _profileData.add(profile);
    }
    notifyListeners();
  }
  //notifyListeners();
}