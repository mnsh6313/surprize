import 'dart:io';

import 'package:Surprize/CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/CustomWidgets/CustomAppBarWithAction.dart';
import 'package:Surprize/EditProfilePage.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Player.dart';

import 'Helper/AppHelper.dart';
import 'Models/PopUpMenus/ProfileMenu.dart';
import 'Resources/ImageResources.dart';
import 'package:Surprize/BLOC/UserBLOC.dart';
import 'UserProfileManagement/UserProfile.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  Player _player = UserMemory().getPlayer();
  double _screenHeight;
  double _imageUploadProgressValue;
  bool _isImageLoading = false;
  UserBLOC _userBLOC;

  CustomLabelTextFieldWidget _emailField = CustomLabelTextFieldWidget("Add email","", Colors.black, false,validation: AppHelper.validateEmail);
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();

  List<ProfileMenu> _popUpMenuChoice = [
    ProfileMenu(
        profileMenuType: ProfileMenuType.EDIT_PAGE,
        title: "Edit Profile",
        icon: Icons.edit)
  ];

  @override
  void initState() {
    super.initState();
    _userBLOC = UserBLOC();
    _userBLOC.init();
    _userBLOC.playerEventSink.add("Player");

  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: CustomAppBarWithAction("Profile", context, appBarActions()),
            body: SingleChildScrollView(
                child: StreamBuilder(
                    stream: _userBLOC.player,
                    builder: (BuildContext context,
                        AsyncSnapshot<Player> playerSnapshot) {
                      _player = playerSnapshot.data;
                      print("Player" + _player.toString());
                      if (_player == null) {
                        return noProfileDisplay();
                      }
                      return displayProfile();
                    }))));
  }

  /// App bar actions
  List<Widget> appBarActions() {
    return [
      PopupMenuButton<ProfileMenu>(
        onSelected: _OnPopUpMenuItemSelected,
        itemBuilder: (BuildContext context) {
          return _popUpMenuChoice.map((ProfileMenu menu) {
            return PopupMenuItem<ProfileMenu>(
                value: menu,
                child: ListTile(
                    leading: Icon(menu.icon),
                    title: Text(menu.title,
                        style: TextStyle(fontFamily: 'Raleway'))));
          }).toList();
        },
      )
    ];
  }

  /// If pop up menu item is selected
  void _OnPopUpMenuItemSelected(ProfileMenu value) {
    if (value.profileMenuType == ProfileMenuType.EDIT_PAGE) {
      AppHelper.cupertinoRoute(context, EditProfilePage());
    }
  }

  @override
  void dispose() {
    _userBLOC.dispose();
    super.dispose();
  }

  /// If no profile exists
  Widget noProfileDisplay() {
    return Padding(
      padding: EdgeInsets.only(top: _screenHeight / 2 - 92),
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(backgroundColor: Colors.purple),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: CircularProgressIndicator(),
              )
            ],
          )),
    );
  }

  Widget displayProfile() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: profilePhotoContainer()),
          personalInformationHolder(),
          //AppHelper.appSmallHeader("Recent Activity"),
          //Container(child: recentActivityList()),
          Visibility(visible:_player.email.isEmpty, child: _emailForm()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: FlatButton(color:Colors.purple[400], onPressed: () => AppHelper.cupertinoRoute(context, EditProfilePage()),
                child: Text("Edit profile", style: TextStyle(fontFamily: 'Raleway', fontSize:18,color:Colors.white)))),
          )
        ],
      ),
    );
  }

  var image = "";
  /*
  User profile photo container
   */
  Widget profilePhotoContainer() {
    return Container(
      color: Colors.purple[800],
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// Photo of player
          circularPhotoContainer(),
          Padding(
            padding: _player.email.isNotEmpty?const EdgeInsets.only(top: 16.0):const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              _player.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
         Visibility(
           visible:_player.email.isNotEmpty,
           child: Padding(
              padding:const EdgeInsets.only(bottom:8.0),
              child: Text(
                _player.email,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
         )
        ],
      ),
    );
  }

  /// Circular photo container
  Widget circularPhotoContainer() {
    return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(
          child: GestureDetector(
            onTap: () => pickPhoto(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _player.profileImageURL.isEmpty
                              ? AssetImage(ImageResources
                              .emptyUserProfilePlaceholderImage)
                              : CachedNetworkImageProvider(
                              _player.profileImageURL),
                          fit: BoxFit.fill)),
                  child:

                  /// Image upload progress
                  Visibility(
                      visible: _isImageLoading,
                      child: CircularProgressIndicator(
                          value: _imageUploadProgressValue,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.purple[600]))),
                ),
              ],
            ),
          ),
        ));
  }

  /// Profile information holder
  Widget personalInformationHolder() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(children: <Widget>[
        Visibility(
          visible: _player.country.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: textWithIcon(Icons.place, _player.country, Colors.purple),
          ),
        ),
        Visibility(
          visible: _player.address.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: textWithIcon(
                Icons.location_city, _player.address, Colors.purple),
          ),
        ),
        Visibility(
          visible: _player.dob.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child:
            textWithIcon(Icons.calendar_today, _player.dob, Colors.purple),
          ),
        ),
        Visibility(
          visible: _player.gender.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child:
            textWithIcon(Icons.person, _player.gender, Colors.purple),
          ),
        ),
        Visibility(
          visible: _player.phoneNumber.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child:
            textWithIcon(Icons.phone, _player.phoneNumber, Colors.purple),
          ),
        ),
      ]),
    );
  }

  /*
  Widget for text with icon
   */
  Widget textWithIcon(IconData iconData, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Icon(
                iconData,
                color: Colors.purple,
                size: 18,
              )),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              text,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: color),
            ),
          ),
        )
      ],
    );
  }

  /// Method to pick photo
  pickPhoto() async {
    File image = await AppHelper.pickAndCropPhoto(520, 520);
    if (image != null) {
      uploadImage(image);
    }
  }

  /// Upload image to server
  uploadImage(File url) {
    StorageUploadTask uploadTask =
    UserProfile().uploadFileToStorage(url, _player.membershipId);
    listenImageUploadProgress(uploadTask);
  }

  /// Listen for image upload progress
  void listenImageUploadProgress(StorageUploadTask uploadTask) {
    /// Uploading events
    uploadTask.events.listen((event) {
      setState(() {
        _isImageLoading = true;
        _imageUploadProgressValue = event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble();
        print("Image upload prgress value" +
            _imageUploadProgressValue.toString());
      });
    });

    /// If upload is completed
    uploadTask.onComplete.then((snapshot) {
      snapshot.ref.getDownloadURL().then((url) {
        afterImageUploaded(url);
      });
    });
  }

  /// After image is uploaded to database
  void afterImageUploaded(String url) {
    UserProfile()
        .addProfileImageToFirestore(_player.membershipId, url)
        .then((value) {
      setState(() {
        _isImageLoading = false;
        _player.profileImageURL = url;
        UserMemory().getPlayer().profileImageURL = url;
      });
    });
  }


  Widget _emailForm(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Form(
          key: _emailFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(width: MediaQuery.of(context).size.width * 0.8, child: _emailField),
              FlatButton(color:Colors.green, child: Text("Save", style: TextStyle(fontFamily:'Raleway',color: Colors.white)), onPressed: () => editEmail())
            ],
          ),
        ),
      ),
    );
  }


  editEmail() {
    if(!_emailFormKey.currentState.validate())
      return;

    _player.email = _emailField.getValue();
    UserMemory().savePlayer(_player);
    UserProfile().updateProfile(_player.membershipId, _player).then((_){
      setState(() {
        _player = _player;
      });
    });
  }


}
