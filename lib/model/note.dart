/**
 * @author: udaraw
 * @since: 26/12/2021 12.37AM
 * @version 1.0.0
 */

class Note {
  int? id;
  late String? noteTitle;
  late DateTime? dateTime;
  late String? priority;
  late int? status;

  Note({
    this.noteTitle,
    this.dateTime,
    this.priority,
    this.status
  });

  Note.full({
    this.id,
    this.noteTitle,
    this.dateTime,
    this.priority,
    this.status
  });

  Map<String, dynamic> convertToNoteMap() {
    final mapObj = Map<String, dynamic> ();
    if(id!=null) {
      mapObj['id'] = id;
    }
    mapObj['note_title'] = noteTitle;
    mapObj['date'] = dateTime?.toIso8601String();
    mapObj['priority'] = priority;
    mapObj['status'] = status;

    return mapObj;
  }

  factory Note.convertFromNoteMap(Map<String, dynamic> mapObj) {
    return Note.full(
      id: mapObj['id'],
      noteTitle: mapObj['note_title'],
      dateTime: DateTime.parse(mapObj['date']),
      priority: mapObj['priority'],
      status: mapObj['status'],
    );
  }

}