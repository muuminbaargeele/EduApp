import 'package:edu_app/Databases/services.dart';
import 'package:edu_app/Providers/connprovider.dart';
import 'package:edu_app/Providers/foldersprovider.dart';
import 'package:edu_app/Providers/notesprovider.dart';
import 'package:edu_app/Providers/trashprovider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrashBox extends StatefulWidget {
  const TrashBox({
    super.key,
    this.folderId,
  });

  final String? folderId;

  @override
  State<TrashBox> createState() => _TrashBoxState();
}

class _TrashBoxState extends State<TrashBox> {
  bool isLoading = false;
  late Box box;
  getTrash() {
    Provider.of<TrashProvider>(context, listen: false)
        .fetchtrash(true)
        .then((value) => isLoading = false);
  }

  @override
  void initState() {
    box = Hive.box('local_storage');
    setState(() {
      isLoading = true;
    });
    Provider.of<TrashProvider>(context, listen: false)
        .fetchtrash(true)
        .then((value) => isLoading = false);
    super.initState();
  }

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

  update() {
    String userId = box.get('UserId');
    Provider.of<NotesProvider>(context, listen: false)
        .fetchNotes(widget.folderId);
    Provider.of<FolderProvider>(context, listen: false).fetchFolders(userId);
  }

  void showDeleteConfirmationDialog(BuildContext context, String noteid) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to Restore?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                deleteNote(recovery: "recovery", noteId: noteid).then((value) {
                  update();
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

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    if (connectivityProvider.isConnected) getTrash();
    return Consumer<TrashProvider>(
      builder: (context, trashprofider, child) {
        if (connectivityProvider.isConnected) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (trashprofider.trash.isEmpty) {
              return const Center(
                child: Text("Empty"),
              );
            } else {
              final trash = trashprofider.trash;
              return GridView.builder(
                itemCount: trash.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.shortestSide > 600 ? 3 : 2,
                    childAspectRatio: (100 / 100),
                    crossAxisSpacing: sizes("height", 25),
                    mainAxisSpacing: sizes("height", 25)),
                itemBuilder: (_, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color(int.parse('0xff${trash[index].noteColor}')),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(int.parse('0xff${trash[index].noteColor}'))
                            .withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(-4, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(sizes("height", 15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trash[index].topicName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: sizes("height", 12),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(trash[index].createdDate),
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: sizes("height", 8)),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (String value) {
                                if (value == 'Restore') {
                                  if (connectivityProvider.isConnected) {
                                    showDeleteConfirmationDialog(
                                      context,
                                      trash[index].noteId,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('No Internet'),
                                            duration: Duration(seconds: 1)));
                                  }
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                List<PopupMenuEntry<String>> menuItems = [];

                                menuItems.add(
                                  const PopupMenuItem<String>(
                                    value: 'Restore',
                                    child: Text('Restore'),
                                  ),
                                );

                                return menuItems;
                              },
                              child: const Icon(Icons.more_vert_sharp),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: sizes("height", 12)),
                            child: Text(
                              trash[index].noteDescription,
                              overflow: TextOverflow.fade,
                              style: TextStyle(fontSize: sizes("height", 8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        } else {
          return const Center(child: Text("No Internet"));
        }
      },
    );
  }
}

extension CapitalizeExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
