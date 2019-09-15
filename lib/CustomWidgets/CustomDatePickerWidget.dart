import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'CustomTextButtonWidget.dart';

class CustomDatePickerWidget extends StatefulWidget{

  CustomDatePickerWidgetState _customDatePickerWidgetState;

  int y;
  int m;
  int d;
  Color color;

  CustomDatePickerWidget(this.y, this.m, this.d, this.color);

  String getSelectedDate(){
    return _customDatePickerWidgetState.currentDate;
  }

  bool isProperlyValidated(){
   return _customDatePickerWidgetState.isProperlyValidate();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    _customDatePickerWidgetState = CustomDatePickerWidgetState();
    return _customDatePickerWidgetState;
  }
}

class CustomDatePickerWidgetState extends State<CustomDatePickerWidget>{

  String currentDate = "";
  bool _properDateSelected = false;
  bool _showValidation = false;


  @override
  void initState() {
    super.initState();
    if(widget.y != 0 && widget.y != 0 && widget.d != 0)
      currentDate =  widget.y.toString() + "/" + widget.m.toString() + "/" + widget.d.toString();

  }

  CustomDatePickerWidgetState();
  /*
  Check for proper validation. If not, also set validation message.
   */
  bool isProperlyValidate(){
    if(!_properDateSelected){
      setState(() {
          _showValidation = true;
      });
    }
    return _properDateSelected;
  }

  void changeDate(int year, int month, int date){
    setState(() {
      currentDate = year.toString() + "/" + month.toString() + "/" + date.toString();
      _properDateSelected = true;
      _showValidation = false;
        currentDate = year.toString() + "/" + month.toString() + "/" + date.toString();
    });
  }

  String getCurrentDate(){
    return currentDate;
  }
  /*
 Open date picker
  */
  void openDatePicker(int y, int m, int d){
    print("ada");
    print(y.toString() + " " +  m.toString() + " " +  d.toString());

    DatePicker.showDatePicker(
      context,
      locale: 'i18n',
      showTitleActions: true,
      minYear: 1970,
      maxYear: 2020,
      initialYear: y,
      initialMonth: m,
      initialDate: d,
      cancel: Text('Cancel',style: TextStyle(fontFamily: 'Raleway')),
      confirm: Text('Confirm',style: TextStyle(fontFamily: 'Raleway')),
      dateFormat: 'yyyy-mm-dd',
      onChanged: (year, month, date) {

      },
      onConfirm: (year, month, date) {
        changeDate(year, month, date);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(bottom:8.0),
              child: Text("DOB   " + currentDate,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Raleway', color: widget.color)
              ),
            ),
          ),
          onTap: (){
            openDatePicker(widget.y,widget.m,widget.d);
          },
        ),
        Container(height: 1 , color: widget.color),
        Visibility(visible: _showValidation, child: Padding(
          padding: const EdgeInsets.only(top:8.0, left: 16.0),
          child: Text("Enter DOB from calendar", style:
          TextStyle(color:Colors.red, fontFamily:'Raleway',fontSize: 11.0)),
        )),
      ],
    );
  }

}

