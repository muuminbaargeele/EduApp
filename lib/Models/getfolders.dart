// To parse this JSON data, do
//
//     final getFolders = getFoldersFromJson(jsonString);

import 'dart:convert';

List<GetFolders> getFoldersFromJson(String str) =>
    List<GetFolders>.from(json.decode(str).map((x) => GetFolders.fromJson(x)));

String getFoldersToJson(List<GetFolders> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetFolders {
  final String folderId;
  final String folderName;
  final DateTime createdDate;
  final String folderColor;
  final String noteCount;

  GetFolders({
    required this.folderId,
    required this.folderName,
    required this.createdDate,
    required this.folderColor,
    required this.noteCount,
  });

  factory GetFolders.fromJson(Map<String, dynamic> json) => GetFolders(
        folderId: json["FolderId"],
        folderName: json["FolderName"],
        createdDate: DateTime.parse(json["CreatedDate"]),
        folderColor: json["FolderColor"],
        noteCount: json["NoteCount"],
      );

  Map<String, dynamic> toJson() => {
        "FolderId": folderId,
        "FolderName": folderName,
        "CreatedDate": createdDate.toIso8601String(),
        "FolderColor": folderColor,
        "NoteCount": noteCount,
      };
}
