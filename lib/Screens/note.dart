import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:edu_app/Databases/services.dart';
import 'package:edu_app/Models/getnotes.dart';
import 'package:edu_app/Providers/connprovider.dart';
import 'package:edu_app/Providers/foldersprovider.dart';
import 'package:edu_app/Providers/notesprovider.dart';
import 'package:edu_app/Widgets/primarybutton.dart';
import 'package:edu_app/Widgets/svgicon.dart';
import 'package:edu_app/const.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key, this.notes, this.folderName, this.folderId});
  final GetNotes? notes;
  final String? folderId;
  final String? folderName;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
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

  late Color pickerColor = isExits
      ? Color(int.parse('0xff${widget.notes!.noteColor}'))
      : const Color(0xff443a49);
  late Color currentColor = Color(int.parse('0xff${widget.notes!.noteColor}'));
  late bool isExits = widget.notes == null ? false : true;

  void showDeleteConfirmationDialog(
      BuildContext context, String noteId, VoidCallback ontap) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                deleteNote(noteId).then((value) {
                  update();
                  ontap();
                });
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  update() {
    String userId = box.get('UserId');
    Provider.of<NotesProvider>(context, listen: false)
        .fetchNotes(widget.folderId);
    Provider.of<FolderProvider>(context, listen: false).fetchFolders(userId);
  }

  showAlertDialog(BuildContext context, VoidCallback ontap) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(0),
      elevation: 0,
      content: Container(
        height: sizes("height", 450),
        // width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                  labelTypes: const [],
                  pickerAreaHeightPercent: sizes("height", 0.8),
                ),
              ),
              PrimryButton(
                btntext: "Save",
                fontclr: Colors.white,
                color: primaryColor,
                width: double.infinity,
                ontap: ontap,
                icon: Icons.save_as,
                iconclr: Colors.white,
                textSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        },
        barrierDismissible: true);
  }

  TextEditingController noteController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  late Box box;
  late bool isLoading;

  @override
  void initState() {
    box = Hive.box('local_storage');
    isLoading = false;
    if (isExits) {
      noteController.text = widget.notes!.noteDescription;
      topicController.text = widget.notes!.topicName;
    } else {
      currentColor = primaryColor;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String pointerAsaet = 'assets/Icons/pointer.svg';
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: sizes("height", 30), horizontal: sizes("width", 10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.folderName!,
                  style: TextStyle(
                    fontSize: sizes("height", 20),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (String value) {
                    if (value == 'Delete' && isExits) {
                      if (connectivityProvider.isConnected) {
                        showDeleteConfirmationDialog(context,
                            widget.notes!.noteId, () => Navigator.pop(context));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('No Internet'),
                                duration: Duration(seconds: 1)));
                      }
                    } else if (value == 'Color') {
                      showAlertDialog(context, () {
                        setState(() => currentColor = pickerColor);
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuEntry<String>> menuItems = [];

                    // Conditionally add Delete item
                    if (isExits) {
                      menuItems.add(
                        const PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      );
                    }

                    // Always add Color item
                    menuItems.add(
                      const PopupMenuItem<String>(
                        value: 'Color',
                        child: Text('Color'),
                      ),
                    );

                    return menuItems;
                  },
                  child: const Icon(Icons.more_horiz_sharp),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM d, yyyy \'at\' h:mm a').format(
                      isExits ? widget.notes!.createdDate : DateTime.now()),
                  style: TextStyle(
                    fontSize: sizes("height", 12),
                    color: Colors.grey[500],
                  ),
                ),
                ColoredSvgIcon(
                  assetName: pointerAsaet,
                  height: sizes("height", 22),
                  width: sizes("width", 20),
                  color: currentColor,
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Enter Title"),
              keyboardType: TextInputType.name,
              maxLines: 1,
              style: TextStyle(
                  fontSize: sizes("height", 18), fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: TextField(
                controller: noteController,
                style: TextStyle(
                  fontSize: sizes("height", 14),
                  fontWeight: FontWeight.normal,
                ),
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Try Somthing..."),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            PrimryButton(
              btntext: isExits ? "Update" : "Save",
              fontclr: Colors.white,
              color: primaryColor,
              width: double.infinity,
              isLoading: isLoading,
              ontap: connectivityProvider.isConnected
                  ? () async {
                      if (noteController.text.isEmpty ||
                          topicController.text.isEmpty) {
                        // Perhaps show a snackbar message indicating that input is required.
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill in all fields')));
                      } else {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          var response = isExits
                              ? await updateNote(
                                  noteController.text,
                                  topicController.text,
                                  currentColor.value
                                      .toRadixString(16)
                                      .padLeft(8, '0'),
                                  widget.notes!.noteId)
                              : await addNote(
                                  noteController.text,
                                  topicController.text,
                                  currentColor.value
                                      .toRadixString(16)
                                      .padLeft(8, '0'),
                                  DateTime.now().toString(),
                                  widget.folderId!);
                          setState(() {
                            isLoading = false;
                          });

                          if (!mounted) return;

                          // Handle the response
                          var snackBarText = response["Status"] == "Success"
                              ? isExits
                                  ? 'Note Updated'
                                  : 'Note Added'
                              : response["Status"];
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(snackBarText),
                              duration: const Duration(seconds: 1)));
                        } catch (e) {
                          // Handle any errors that occur during the update or add operation
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('An error occurred'),
                                  duration: Duration(seconds: 2)));
                        } finally {
                          // Always executed regardless of success or failure
                          update(); // Assuming update() refreshes the UI or navigates away
                          Navigator.pop(context);
                        }
                      }
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('No Internet'),
                          duration: Duration(seconds: 1)));
                    },
              textSize: sizes("height", 16),
            )
          ],
        ),
      )),
    );
  }
}
