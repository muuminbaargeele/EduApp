import 'package:edu_app/Screens/trash.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:edu_app/Screens/login.dart';
import 'package:provider/provider.dart';
import '../Providers/userprovider.dart';

class Header extends StatefulWidget {
  const Header({
    super.key,
    this.folderId,
  });

  final String? folderId;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late Box box;
  @override
  void initState() {
    box = Hive.box('local_storage');
    String userId = box.get('UserId');
    Provider.of<UserProvider>(context, listen: false).fetchUsers(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back",
              style: TextStyle(
                  color: Colors.grey[500], fontSize: sizes("height", 12)),
            ),
            Consumer<UserProvider>(
              builder: (_, userProvider, child) {
                if (userProvider.users.isEmpty) {
                  return Text(
                    "...",
                    style: TextStyle(fontSize: sizes("height", 16)),
                  );
                } else {
                  final user = userProvider.users[0];
                  return Text(
                    user.username!.capitalizeFirstLetter(),
                    style: TextStyle(fontSize: sizes("height", 16)),
                  );
                }
              },
            ),
          ],
        ),
        PopupMenuButton<String>(
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              child: const Text('Log Out'),
              onTap: () {
                box.put("isLogin", false);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false);
              },
            ),
            PopupMenuItem<String>(
              child: const Text('Trash'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TrashScreen(folderId: widget.folderId,)),
                );
              },
            ),
          ],
          child: const Icon(Icons.more_vert_sharp),
        ),
      ],
    );
  }
}

extension CapitalizeExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
