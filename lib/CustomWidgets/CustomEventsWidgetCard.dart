import 'package:Surprize/Resources/ImageResources.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/CustomWidgets/CalendarEventManagement.dart';
import 'package:Surprize/Helper/AppHelper.dart';

class CustomEventWidgetCard extends StatelessWidget {

  String _photoUrl;
  String _title;
  String _desc;
  DateTime _time;

  CustomEventWidgetCard(this._photoUrl, this._title, this._desc, this._time);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return fullSize(context);
  }

  Widget fullSize(context){
    return  Container(
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: FadeInImage(height:80, width:160, image: NetworkImage(_photoUrl), placeholder: AssetImage(ImageResources.emptyImageLoadingUrlPlaceholder)),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0, right:8.0),
              child: Container(
                color:Colors.grey[200],
                height: 1,
                width: 120,
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(_title,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.purple[900],
                        fontWeight: FontWeight.w500,
                        fontSize: 20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 2.0, top:4.0),
              child: Text(_desc,
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.black,
                      fontSize: 18)),
            ),
            Text(AppHelper.dateToReadableString(_time),
                style: TextStyle(
                    fontFamily: 'Raleway',
                    color: Colors.grey,
                    fontSize: 16)),

            GestureDetector(
              onTap: (){
                CalendarEventManagement().addEventToCalendar(_title,
                    _desc,
                    _time,
                    _time).then((value){
                }).catchError((error){
                  print(error);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top:16.0, bottom:8.0, left:8, right: 8),
                child: Container(
                  decoration: new BoxDecoration(
                      color:Colors.white,
                      border:
                      new Border.all(color: Colors.green[100], width: 1),
                      borderRadius:
                      new BorderRadius.all(Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.alarm, color:Colors.green),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0, right: 4.0),
                          child: Text("Set Reminder",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Colors.green,
                                  fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}