// To parse this JSON data, do
//
//     final GetTrash = getTrashFromJson(jsonString);

import 'dart:convert';

List<GetTrash> getTrashFromJson(String str) => List<GetTrash>.from(json.decode(str).map((x) => GetTrash.fromJson(x)));

String getTrashToJson(List<GetTrash> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTrash {
    final String noteId;
    final String noteDescription;
    final String topicName;
    final String noteColor;
    final DateTime createdDate;
    final String folderId;

    GetTrash({
        required this.noteId,
        required this.noteDescription,
        required this.topicName,
        required this.noteColor,
        required this.createdDate,
        required this.folderId,
    });

    factory GetTrash.fromJson(Map<String, dynamic> json) => GetTrash(
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
