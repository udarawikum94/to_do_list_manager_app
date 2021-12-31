import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list_manager_app/model/note.dart';

/**
 * @author: udaraw
 * @since: 26/12/2021 01.01AM
 * @version 1.0.0
 */

class DbUtil {
  static final DbUtil dbUtil = DbUtil._createInstance();

  static Database? _database;
  DbUtil._createInstance();

  String dbName = "todo_list_manager.db";
  String tblNote = 'my_notes';
  String colId = 'id';
  String colNoteTitle = 'note_title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database?> get database async {
    _database ??= await _processCreateDb();

    return _database;
  }

  void _createDatabase(Database db, int version) async {
    await db.execute(
      'create table $tblNote($colId integer primary key autoincrement, '
          '$colNoteTitle text, $colDate text, $colPriority text, $colStatus integer)'
    );
  }

  Future<Database> _processCreateDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + dbName;

    final appDb = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return appDb;
  }

  Future<List<Map<String, dynamic>>> _queryNoteList() async {
    Database? db = await database;
    final List<Map<String, dynamic>> queryResult = await db!.query(tblNote);

    return queryResult;
  }

  Future<List<Note>> getAllNotes() async {
    final List<Map<String, dynamic>> resultList = await _queryNoteList();
    final List<Note> listNotes = [];

    for (var element in resultList) {
      listNotes.add(Note.convertFromNoteMap(element));
    }

    listNotes.sort((a,b) => a.dateTime!.compareTo(b.dateTime!));

    return listNotes;
  }

  Future<int> saveNote(Note note) async {
    Database? db = await database;
    final int queryResult = await db!.insert(tblNote, note.convertToNoteMap());

    return queryResult;
  }

  Future<int> updateNote(Note note) async {
    Database? db = await database;
    final int queryResult = await db!.update(tblNote, note.convertToNoteMap(),
        where: '$colId = ?', whereArgs: [note.id]);

    return queryResult;
  }

  Future<int> deleteNote(int? noteId) async {
    Database? db = await database;
    final int queryResult = await db!.delete(tblNote, where: '$colId = ?',
        whereArgs: [noteId]);

    return queryResult;
  }

}