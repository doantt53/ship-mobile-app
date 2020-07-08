import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ship/data/global.dart';
import 'package:http/http.dart' as http;

String BeginDate = DateFormatString(DateTime.now());
String EndDate = DateFormatString(DateTime.now());
int Giatri;
String DateFormatString(DateTime dateTime) {
  final y = dateTime.year.toString().padLeft(4, '0');
  final m = dateTime.month.toString().padLeft(2, '0');
  final d = dateTime.day.toString().padLeft(2, '0');
  return "$d-$m-$y";
}
class AddDate extends StatefulWidget {
  @override
  _FormAddDate createState() => _FormAddDate();
}

class _FormAddDate extends State<AddDate> {
  String _dateStart = DateFormatString(DateTime.now());
  String _dateEnd = DateFormatString(DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xin mời chọn ngày '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2015, 1, 1),
                      maxTime: DateTime(2025, 12, 31), onConfirm: (date) {
                    print('confirm $date');
                    _dateStart = DateFormatString(date);
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.vi);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.blue,
                                ),
                                Text(
                                  " $_dateStart",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "Từ ngày",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2015, 1, 1),
                      maxTime: DateTime(2025, 12, 31), onConfirm: (date) {
                    print('confirm $date');
                    _dateEnd = DateFormatString(date);
                    print("Day la gia tri ngay bau dau" + _dateEnd);
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.vi);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.blue,
                                ),
                                Text(
                                  " $_dateEnd",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "Đến ngày",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 10.0,
              ),
              ListTile(
                title: Text('Số ký tự đã nhắn là: ',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),),
                subtitle: Text(
                   '${Giatri}',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),

              ),
              new SizedBox(
                width: 130.0,
                height: 50.0,
                child: new RaisedButton(
                  padding: const EdgeInsets.all(10.20),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () async {
                    String startDate = _dateStart;
                    String endDate = _dateEnd;
                    print("Chay den day1" + startDate);
                    print("Chay den day1" + endDate);
//                    DataSMS dataSMS =
//                    DataSMS(startDate,endDate,0);
                    print("chay den day2");

                    BeginDate = startDate;
                    EndDate = endDate;

                    final data = await GetSMS();
                    print("Kiemtra");
                    print(data);
                    setState(() {});

                    print("chay den res");
                  },
                  child: const Text('Đồng ý', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<int> GetSMS() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String sUserId = _prefs.getString("saved_user_id") ?? "";
    print("sUserId => $sUserId");
    String _url = URL_ADD_SMS +
        sUserId +
        "&startDate=" +
        BeginDate +
        "&endDate=" +
        EndDate +
        key;
    print(_url);
    final response = await http.get(_url);
    if (response.statusCode == 200) {
      final values = json.decode(response.body);
      Giatri = values['NumMessageContent'] as int;
      print(Giatri);
      return Giatri;
    } else {
      throw Exception('Không lấy được dữ liệu ');
    }
  }
}
