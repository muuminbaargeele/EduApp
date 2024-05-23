// ignore_for_file: prefer_const_constructors

import 'package:edu_app/Databases/services.dart';
import 'package:edu_app/Providers/connprovider.dart';
import 'package:edu_app/Widgets/trashbox.dart';
import 'package:flutter/material.dart';
import 'package:edu_app/Widgets/svgicon.dart';
import 'package:edu_app/const.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({
    super.key, this.folderId,
  });
  final String? folderId;

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
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

  void showDeleteConfirmationDialog(BuildContext context, String userid) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to clear Trash?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                deleteNote(delete: "delete", userid: userid).then((value) {
                  setState(() {});
                });
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  late Box box;

  @override
  void initState() {
    super.initState();
    box = Hive.box('local_storage');
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
                SizedBox(
                  width: double.infinity,
                  child: SizedBox(
                    child: Row(
                      children: [
                        const ColoredSvgIcon(
                          assetName: downArrowAsaet,
                          width: 20,
                          height: 20,
                        ),
                        Text(
                          "Deleted Files",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: sizes("height", 12)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: TrashBox(folderId: widget.folderId,),
                ),
              ],
            ),
          ),
          floatingActionButton: Visibility(
            visible: connectivityProvider.isConnected,
            child: GestureDetector(
              onTap: () {
                showDeleteConfirmationDialog(context, box.get('UserId'));
              },
              child: Container(
                height: 60.0,
                width: 60.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: const Icon(Icons.delete_forever_rounded,
                    color: Colors.white),
              ),
            ),
          )),
    );
  }
}
