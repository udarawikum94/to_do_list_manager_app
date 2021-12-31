import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_manager_app/model/note.dart';
import 'package:to_do_list_manager_app/repository/db_util.dart';

import 'manage_note.dart';

/**
 * @author: udaraw
 * @since: 23/12/2021 12.23AM
 * @version 1.0.0
 */

class HomeScreen extends StatefulWidget {
  //const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateFormat _dateFormatter = DateFormat('dd MMM, yyy');
  late Future<List<Note>> _listNotes;

  DbUtil dbUtil = DbUtil.dbUtil;

  @override
  void initState() {
    super.initState();
    _getNoteList();
  }

  _getNoteList() {
    _listNotes = DbUtil.dbUtil.getAllNotes() as Future<List<Note>>;
  }

  Widget _buildNote(Note note){
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(note.noteTitle!, style: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              decoration: note.status == 0? TextDecoration.none:TextDecoration.lineThrough,
              decorationColor: Colors.black87, decorationThickness: 3.0,
              ),
            ),
            subtitle: Text.rich(
              TextSpan(
                text: '${_dateFormatter.format(note.dateTime!)} - ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                  decoration: note.status == 0? TextDecoration.none:TextDecoration.lineThrough,
                  decorationColor: Colors.black87, decorationThickness: 3.0,
                ),
                children: <TextSpan>[
                  TextSpan(text: '${note.priority}', style: TextStyle(
                    color: note.priority == 'Low'? Colors.green
                        : note.priority == 'Medium'? Colors.orange : Colors.red,
                    fontSize: 16.0,
                    decoration: note.status == 0? TextDecoration.none:TextDecoration.lineThrough,
                    decorationColor: Colors.black87, decorationThickness: 3.0,
                  )),
                ],
              ),
            ),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  onChanged: (value) {
                    note.status = value! ? 1 : 0;
                    DbUtil.dbUtil.updateNote(note);
                    _getNoteList();

                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context)
                    => HomeScreen()));
                  },
                  activeColor: Theme.of(context).primaryColor,
                  value: note.status == 0? false : true,
                ),
                new IconButton(
                  icon: new Icon(Icons.edit_rounded),
                  onPressed: () => Navigator.push(
                      context, CupertinoPageRoute(builder: (context)
                  => ManageNoteScreen(
                      note: note,
                      functionGetUpdateNoteList: _getNoteList()
                  ))),


                ),
              ],
            ),
          ),
          Divider(height: 5.0, color: Colors.deepPurple, thickness: 1.0,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          Navigator.push(context, CupertinoPageRoute(builder: (context) => ManageNoteScreen(
              functionGetUpdateNoteList: _getNoteList()
          ),));
        },
        child: Icon(Icons.add),
      ),

      body: FutureBuilder (
        future: _listNotes,
        builder: (context, AsyncSnapshot asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final int totalCompletedNotesCount = asyncSnapshot.data!.where(
                  (Note note) => note.status == 1
          ).toList().length;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 80.0),
              itemCount: int.parse(asyncSnapshot.data!.length.toString())+1,
              itemBuilder: (BuildContext context, int index) {
                if(index==0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'My Notes',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '$totalCompletedNotesCount of ${asyncSnapshot.data.length}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return _buildNote(asyncSnapshot.data![index - 1]);
              }
          );
        },
      ),
    );
  }
}
