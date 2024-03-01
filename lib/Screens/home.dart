import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';
import 'package:edu_app/Databases/services.dart';
import 'package:edu_app/Providers/connprovider.dart';
import 'package:edu_app/Providers/foldersprovider.dart';
import 'package:edu_app/Widgets/header.dart';
import 'package:edu_app/Widgets/folderbox.dart';
import 'package:edu_app/Widgets/mytextfield.dart';
import 'package:edu_app/Widgets/primarybutton.dart';
import 'package:edu_app/Widgets/svgicon.dart';
import 'package:edu_app/const.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box box;
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

  Color pickerColor = const Color(0xff443a49);

  TextEditingController topicController = TextEditingController();

  void showAlertDialog(BuildContext context, isConnected) async {
    Color localPickerColor = pickerColor;
    String localTopicError = "";
    bool isLoding = false;

    void changeLocalColor(Color color, Function setState) {
      localPickerColor = color;
      setState(() {});
    }

    Future<void> handleSave(Function setState, isConnected) async {
      if (isConnected) {
        if (topicController.text.isNotEmpty) {
          String userId = box.get('UserId').toString();
          setState(() {
            isLoding = true;
          });
          final response = await addFolder(
            topicController.text,
            DateTime.now().toString(),
            localPickerColor.value.toRadixString(16).padLeft(8, '0'),
            userId,
          );
          setState(() {
            isLoding = false;
          });

          if (!mounted) return;

          if (response["Status"] == "Success") {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Folder Added'), duration: Duration(seconds: 1)));
            Provider.of<FolderProvider>(context, listen: false)
                .fetchFolders(userId);
            Navigator.of(context).pop();
          } else {
            if (mounted) {
              setState(() => localTopicError = response["Status"]);
            }
          }

          topicController.clear();
        } else {
          setState(() => localTopicError = "Enter Folder Name");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No Internet'), duration: Duration(seconds: 1)));
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
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
                      errorName: localTopicError,
                      controller: topicController,
                      text: "Enter Folder Name",
                      textInputType: TextInputType.name,
                      padding: 0,
                    ),
                    SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: localPickerColor,
                        onColorChanged: (Color color) =>
                            changeLocalColor(color, setState),
                        labelTypes: const [],
                        pickerAreaHeightPercent: 0.5,
                      ),
                    ),
                    PrimryButton(
                      btntext: "Save",
                      fontclr: Colors.white,
                      color: primaryColor,
                      width: double.infinity,
                      ontap: () => handleSave(setState, isConnected),
                      icon: isLoding ? null : Icons.save_as,
                      isLoading: isLoding,
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
      barrierDismissible: true,
    );
  }

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
                const Header(),
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
                      Text(
                        "Folders",
                        style: TextStyle(
                          fontSize: sizes("height", 24),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const FolderBox(),
              ],
            ),
          ),
          floatingActionButton: Visibility(
            visible: connectivityProvider.isConnected,
            child: GestureDetector(
              onTap: () {
                showAlertDialog(context, connectivityProvider.isConnected);
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
