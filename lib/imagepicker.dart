import 'dart:ffi';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'MobileId';

class PickImage extends StatefulWidget {
  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
  testDevices: testDevice != null?<String>[testDevice] : null,
  childDirected:  true,
  keywords:  <String>['Game','Mario'],
);

BannerAd _bannerAd;
//InterstitialAd _interstitialAd;

BannerAd createBannerAd(){
  return new BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
    targetingInfo: targetInfo,
    listener: (MobileAdEvent event){
    print("Banner event : $event");
    }
  );
}
/*InterstitialAd createInterstitialAd(){
  return new InterstitialAd(adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetInfo,
      listener: (MobileAdEvent event){
        print("Interstitial event : $event");
      }
  );
}
*/
  File _image;
  int _coins = 0;
  RewardedVideoAd videoAd = RewardedVideoAd.instance;
@override
void initState(){
  FirebaseAdMob.instance.initialize(
      appId: FirebaseAdMob.testAppId
  );
  _bannerAd =createBannerAd()..load()..show(
    anchorType: AnchorType.bottom,
  );
  videoAd.listener =
      (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
    print("REWARDED VIDEO AD $event");
    if (event == RewardedVideoAdEvent.rewarded) {
      setState(() {
        _coins += rewardAmount;
      });
    }
  };
  super.initState();
}
@override
void dispose()
{
  _bannerAd.dispose();
  super.dispose();
   //_interstitialAd.dispose();
}
  @override
  Widget build(BuildContext context) {
    Future getImage() async{
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState((){
        _image = image;
        print("Image path $_image");
      });

    }
    Future uploadPic(BuildContext context) async{
      String filName = p.basename(_image.path);
      StorageReference reference = FirebaseStorage.instance.ref().child(filName);
      StorageUploadTask uploadTask = reference.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        print("Image Uploaded");
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded"),));
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('ImagePicker+Firebase'),
        leading: IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Builder(
        // Create an inner BuildContext so that the onPressed methods
        // can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                /*Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 500,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    child:(_image!=null)?Image.file(_image,fit: BoxFit.fill,) : Image.network("https://previews.123rf.com/images/lineartist/lineartist1907/lineartist190702409/127623033-doing-office-work-on-laptop-cute-girl-cartoon-character-vector-illustration.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: IconButton(
                    icon: Icon(Icons.photo_camera,size: 30.0,),
                    onPressed: (){
                      getImage();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: Color(0xff476cfb),
                      onPressed: (){
                        uploadPic(context);
                      },
                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      child: Text(
                        "Upload",
                        style: TextStyle(color: Colors.white,fontSize: 16.0),
                      ),
                    ),
                  ],
                ),*/
                SizedBox(height: 50,),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('LOAD REWARDED VIDEO AD'),
                      RaisedButton(
                        child: Text("LOAD REWARDED AD"),
                        onPressed: () {
                          videoAd.load(
                              adUnitId: RewardedVideoAd.testAdUnitId,
                              targetingInfo: targetInfo);
                        },
                      ),
                      RaisedButton(
                        child: Text("SHOW REWARDED VIDEOAD"),
                        onPressed: () {
                          videoAd.show();
                        },
                      ),
                      Text("YOU HAVE $_coins coins"),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

