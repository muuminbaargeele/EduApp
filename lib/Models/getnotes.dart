// To parse this JSON data, do
//
//     final getNotes = getNotesFromJson(jsonString);

import 'dart:convert';

List<GetNotes> getNotesFromJson(String str) => List<GetNotes>.from(json.decode(str).map((x) => GetNotes.fromJson(x)));

String getNotesToJson(List<GetNotes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetNotes {
    final String noteId;
    final String noteDescription;
    final String topicName;
    final String noteColor;
    final DateTime createdDate;
    final String folderId;

    GetNotes({
        required this.noteId,
        required this.noteDescription,
        required this.topicName,
        required this.noteColor,
        required this.createdDate,
        required this.folderId,
    });

    factory GetNotes.fromJson(Map<String, dynamic> json) => GetNotes(
        noteId: json["NoteId"],
        noteDescription: json["NoteDescription"],
        topicName: json["TopicName"],
        noteColor: json["NoteColor"],
        createdDate: DateTime.parse(json["CreatedDate"]),
        folderId: json["FolderId"],
    );

    Map<String, dynamic> toJson() => {
        "NoteId": noteId,
        "NoteDescription": noteDescription,
        "TopicName": topicName,
        "NoteColor": noteColor,
        "CreatedDate": createdDate.toIso8601String(),
        "FolderId": folderId,
    };
}
