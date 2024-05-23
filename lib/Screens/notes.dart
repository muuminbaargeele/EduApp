// ignore_for_file: prefer_const_constructors

import 'package:edu_app/Providers/connprovider.dart';
import 'package:flutter/material.dart';
import 'package:edu_app/Screens/note.dart';
import 'package:edu_app/Widgets/header.dart';
import 'package:edu_app/Widgets/notebox.dart';
import 'package:edu_app/Widgets/svgicon.dart';
import 'package:edu_app/const.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen(
      {super.key, required this.folderId, required this.folderName});
  final String folderId;
  final String folderName;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  sizes(type, size) {
    if (type == "width") {
      double converted = size / 183;
      return MediaQuery.of(context).size.width * converted;
    }
    if (type == "height") {
      double converted = size / 901;
      return MediaQuery.of(context).size.height * converted;
    }
  }

  @override
  Widget build(BuildContext context) {
    const String downArrowAsaet = 'assets/Icons/down_arrow.svg';
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    return SafeArea(
      child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(
                vertical: sizes("height", 30), horizontal: sizes("width", 10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(folderId: widget.folderId,),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            const ColoredSvgIcon(
                              assetName: downArrowAsaet,
                              width: 20,
                              height: 20,
                            ),
                            Text(
                              "Last modified",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: sizes("height", 12)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Text(
                            widget.folderName,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: sizes("height", 24),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: NoteBox(
                    folderId: widget.folderId,
                    folderName: widget.folderName,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Visibility(
            visible: connectivityProvider.isConnected,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => NoteScreen(
                              folderId: widget.folderId,
                              folderName: widget.folderName,
                            )));
              },
              child: Container(
                height: 60.0,
                width: 60.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          )),
    );
  }
}
