import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';
import 'package:edu_app/Databases/services.dart';
import 'package:edu_app/Providers/connprovider.dart';
import 'package:edu_app/Providers/foldersprovider.dart';
import 'package:edu_app/Screens/notes.dart';
import 'package:edu_app/Widgets/mytextfield.dart';
import 'package:edu_app/Widgets/primarybutton.dart';
import 'package:edu_app/Widgets/svgicon.dart';
import 'package:edu_app/const.dart';
import 'package:provider/provider.dart';

class FolderBox extends StatefulWidget {
  const FolderBox({super.key});

  @override
  State<FolderBox> createState() => _FolderBoxState();
}

class _FolderBoxState extends State<FolderBox> {
  void showDeleteConfirmationDialog(BuildContext context, String folderId,
      String folderName, Function onFolderDeleted) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use ScaffoldMessenger of the passed context
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text('Do you want to delete $folderName?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close the dialog
                final response = await deleteFolder(
                    folderId); // Assuming deleteFolder is an async function
                if (response["Status"] == "Success") {
                  scaffoldMessenger.showSnackBar(SnackBar(
                      content: Text('$folderName Deleted'),
                      duration: const Duration(seconds: 1)));
                  // Invoke the callback function after successful deletion
                  onFolderDeleted();
                } else {
                  scaffoldMessenger.showSnackBar(SnackBar(
                      content: Text('Failed to Delete $folderName'),
                      duration: const Duration(seconds: 1)));
                }
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(
      BuildContext context, folderId, folderName, Color folderColor) async {
    final topicController = TextEditingController(text: folderName);
    Color pickerColor = folderColor;
    String topicError = "";
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          void changeLocalColor(Color color) {
            setState(() => pickerColor = color);
          }

          Future<void> handleSave() async {
            if (topicController.text.isNotEmpty) {
              String userId = box.get('UserId');
              setState(() => isLoading = true);
              final response = await updateFolder(
                userId,
                folderId,
                topicController.text,
                pickerColor.value.toRadixString(16).padLeft(8, '0'),
              );
              if (!mounted) return;
              setState(() => isLoading = false);
              if (response["Status"] == "Success") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Folder Updated'),
                    duration: Duration(seconds: 1)));
                Provider.of<FolderProvider>(context, listen: false)
                    .fetchFolders(userId);
                topicController.clear();
                Navigator.of(context).pop();
              } else {
                setState(() => topicError = response["Status"]);
              }
            } else {
              setState(() => topicError = "Enter Folder Name");
            }
          }

          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            elevation: 0,
            content: Container(
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyTextField(
                      errorName: topicError,
                      controller: topicController,
                      text: "Enter Folder Name",
                      textInputType: TextInputType.name,
                      padding: 0,
                    ),
                    SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeLocalColor,
                        labelTypes: const [],
                        pickerAreaHeightPercent: 0.5,
                      ),
                    ),
                    PrimryButton(
                      btntext: "Save",
                      fontclr: Colors.white,
                      color: primaryColor,
                      width: double.infinity,
                      ontap: () => topicController.text != folderName ||
                              pickerColor != folderColor
                          ? handleSave()
                          : Navigator.of(context).pop(),
                      icon: isLoading ? null : Icons.save_as,
                      isLoading: isLoading,
                      iconclr: Colors.white,
                      textSize: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  late Box box;
  bool isLoading = false;
  getFolders() {
    String userId = box.get('UserId');
    Provider.of<FolderProvider>(context, listen: false)
        .fetchFolders(userId)
        .then((value) => isLoading = false);
  }

  @override
  void initState() {
    box = Hive.box('local_storage');
    String userId = box.get('UserId');
    setState(() {
      isLoading = true;
    });
    Provider.of<FolderProvider>(context, listen: false)
        .fetchFolders(userId)
        .then((value) => isLoading = false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    if (connectivityProvider.isConnected) getFolders();
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

    const String folderAsaet = 'assets/Icons/folder2.svg';
    return Expanded(
      child: Consumer<FolderProvider>(
        builder: (context, foldersprofider, child) {
          if (connectivityProvider.isConnected) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (foldersprofider.folders.isEmpty) {
                return const Center(
                  child: Text("No Folders"),
                );
              } else {
                final folders = foldersprofider.folders;
                return GridView.builder(
                  itemCount: folders.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.shortestSide > 600 ? 3 : 2,
                    childAspectRatio: (100 / 100),
                    crossAxisSpacing: sizes("height", 25)!,
                    mainAxisSpacing: sizes("height", 25)!,
                  ),
                  itemBuilder: (_, index) => GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => NotesScreen(
                                  folderId: folders[index].folderId,
                                  folderName: folders[index].folderName,
                                ))),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(
                              int.parse('0xff${folders[index].folderColor}')),
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(int.parse(
                                    '0xff${folders[index].folderColor}'))
                                .withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(-4, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                          sizes("height", 15)!,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  PopupMenuButton<String>(
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        onTap: () {
                                          showEditDialog(
                                            context,
                                            folders[index].folderId,
                                            folders[index].folderName,
                                            Color(int.parse(
                                                '0xff${folders[index].folderColor}')),
                                          );
                                        },
                                        child: const Text('Edit'),
                                      ),
                                      PopupMenuItem<String>(
                                        onTap: () {
                                          showDeleteConfirmationDialog(
                                              context,
                                              folders[index].folderId,
                                              folders[index].folderName, () {
                                            String userId = box.get(
                                                'UserId'); // Assuming 'box' is accessible in this scope
                                            Provider.of<FolderProvider>(context,
                                                    listen: false)
                                                .fetchFolders(userId);
                                          });
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                    child: const Icon(Icons.more_vert_sharp),
                                  ),
                                ],
                              ),
                            ),
                            ColoredSvgIcon(
                              assetName: folderAsaet,
                              width: sizes("height", 60)!,
                              height: sizes("height", 60)!,
                              color: Color(int.parse(
                                  '0xff${folders[index].folderColor}')),
                            ),
                            const Spacer(),
                            Text(
                              folders[index].folderName.capitalizeFirstLetter(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: sizes("height", 16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${folders[index].noteCount} notes",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: sizes("height", 10),
                                fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

extension CapitalizeExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
