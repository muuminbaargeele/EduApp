import 'package:edu_app/Providers/connprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:edu_app/Providers/notesprovider.dart';
import 'package:edu_app/Screens/note.dart';
import 'package:edu_app/Widgets/svgicon.dart';
import 'package:provider/provider.dart';

class NoteBox extends StatefulWidget {
  const NoteBox({super.key, required this.folderId, required this.folderName});

  final String folderId;
  final String folderName;

  @override
  State<NoteBox> createState() => _NoteBoxState();
}

class _NoteBoxState extends State<NoteBox> {
  bool isLoading = false;
  getNotes() {
    Provider.of<NotesProvider>(context, listen: false)
        .fetchNotes(widget.folderId)
        .then((value) => isLoading = false);
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<NotesProvider>(context, listen: false)
        .fetchNotes(widget.folderId)
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

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    if (connectivityProvider.isConnected) getNotes();
    const String pointerAsaet = 'assets/Icons/pointer.svg';
    return Consumer<NotesProvider>(
      builder: (context, notesprofider, child) {
        if (connectivityProvider.isConnected) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (notesprofider.notes.isEmpty) {
              return const Center(
                child: Text("No Files"),
              );
            } else {
              final notes = notesprofider.notes;
              return GridView.builder(
                itemCount: notes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.shortestSide > 600 ? 3 : 2,
                    childAspectRatio: (100 / 100),
                    crossAxisSpacing: sizes("height", 25),
                    mainAxisSpacing: sizes("height", 25)),
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoteScreen(
                          notes: notes[index],
                          folderId: widget.folderId,
                          folderName: widget.folderName,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color:
                            Color(int.parse('0xff${notes[index].noteColor}')),
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Color(int.parse('0xff${notes[index].noteColor}'))
                                  .withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(-4, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: sizes("height", 15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  notes[index].topicName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: sizes("height", 12),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              ColoredSvgIcon(
                                assetName: pointerAsaet,
                                height: sizes("height", 25),
                                width: sizes("width", 25),
                                color: Color(
                                    int.parse('0xff${notes[index].noteColor}')),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(notes[index].createdDate),
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: sizes("height", 8)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: sizes("height", 12)),
                              child: Text(
                                notes[index].noteDescription,
                                overflow: TextOverflow.fade,
                                style: TextStyle(fontSize: sizes("height", 8)),
                              ),
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
