import 'package:cool_alert/cool_alert.dart';
import 'package:to_do_list_manager_app/model/note.dart';
import 'package:to_do_list_manager_app/repository/db_util.dart';

import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/**
 * @author: udaraw
 * @since: 25/12/2021 02.12PM
 * @version 1.0.0
 */

class ManageNoteScreen extends StatefulWidget {

  final Note? note;
  final Function? functionGetUpdateNoteList;
  //AddNewNoteScreen({Key? key, this.note, this.functionGetUpdateNoteList}) : super(key: key);
  ManageNoteScreen({
    this.note,
    this.functionGetUpdateNoteList
  });

  @override
  _ManageNoteScreenState createState() => _ManageNoteScreenState();
}

class _ManageNoteScreenState extends State<ManageNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _proiritiesList = ['Low', 'Medium', 'Higher'];

  String _proiritiesDefault = 'Low';
  String btnText = 'CREATE NEW';
  String titleText = 'CREATE NEW NOTE';
  String noteTitle = '';

  String titleValidatorMessage = 'Note title cannot be blank';
  String priorityValidatorMessage = 'Priority cannot be blank';

  TextEditingController _dateFormatController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('dd MMM, yyy');
  DateTime _dateTime =DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      noteTitle = widget.note!.noteTitle!;
      _dateTime = widget.note!.dateTime!;
      _proiritiesDefault = widget.note!.priority!;

      setState(() {
        btnText = 'UPDATE';
        titleText = 'MANAGE NOTE';
      });
    } else {
      setState(() {
        btnText = 'CREATE';
        titleText = 'CREATE NEW NOTE';
      });
    }

    _dateFormatController.text = _dateFormatter.format(_dateTime);
  }

  @override
  void dispose() {
    _dateFormatController.dispose();
    super.dispose();
  }
  _datePickerHandler() async{
    final DateTime? dateTime = await showDatePicker(
        context: context, 
        initialDate: _dateTime, 
        firstDate: DateTime(1980), 
        lastDate: DateTime(2050),
    );

    if(dateTime != null && dateTime != _dateTime) {
      setState(() {
        _dateTime = dateTime;
      });

      _dateFormatController.text = _dateFormatter.format(dateTime);
    }
  }

  _processData() {
    if (_formKey.currentState == null) {
      print("_formKey.currentState is null!");
    } else if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Note note = Note(noteTitle: noteTitle, dateTime: _dateTime,
          priority: _proiritiesDefault);

      if (widget.note != null) {
        print("performing update!");
        note.id = widget.note!.id;
        note.status = widget.note!.status;

        DbUtil.dbUtil.updateNote(note);
        print("performing update done!");

        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Update was successful!",
          //autoCloseDuration: Duration(seconds: 2),
        );

        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => HomeScreen()));

        //widget.functionGetUpdateNoteList!();
      } else {
        print("performing save!");
        note.status = 0;
        DbUtil.dbUtil.saveNote(note);

        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Create was successful!",
           // autoCloseDuration: Duration(seconds: 2),
        );

        print("performing save done!");
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => HomeScreen()));

      }
    }
  }

  _deleteData() {
    print("performing delete!");
    DbUtil.dbUtil.deleteNote(widget.note!.id);
    print("performing delete done!");

    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: "Delete was successful!",
    );

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen())),
                  child: Icon(
                    Icons.arrow_back_sharp,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 20.0,),
                Text(
                  titleText,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10.0,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Note Title',
                            labelStyle: TextStyle(
                              fontSize: 18.0
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          validator: (input) => input!.trim().isEmpty ?
                          titleValidatorMessage : null,
                          onSaved: (input) => noteTitle = input!,
                          initialValue: noteTitle,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateFormatController,
                          style: TextStyle(fontSize: 18.0),
                          onTap: _datePickerHandler,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(Icons.arrow_drop_down_circle_sharp),
                          iconSize: 23.0,
                          iconEnabledColor: Theme.of(context).primaryColor,
                          items: _proiritiesList.map((String priority) {
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priority,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            );
                          }).toList(),
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => _proiritiesDefault == null ?
                          priorityValidatorMessage : null,
                          onChanged: (value) {
                            setState(() {
                              _proiritiesDefault = value.toString();
                            });
                          },
                          value: _proiritiesDefault,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        width: double.infinity,
                        height: 70.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0)
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: Text(
                            btnText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: () => {_processData()},
                        ),
                      ),
                      widget.note != null? Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        width: double.infinity,
                        height: 70.0,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: Text(
                            'DELETE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: () => {_deleteData()},
                        ),
                      ):SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
