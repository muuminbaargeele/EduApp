import 'package:edu_app/Providers/trashprovider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:edu_app/Providers/connprovider.dart';
import 'package:edu_app/Providers/foldersprovider.dart';
import 'package:edu_app/Providers/notesprovider.dart';
import 'package:edu_app/Providers/userprovider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'Screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir =
      await getApplicationDocumentsDirectory(); // Use path_provider
  Hive.init(appDocumentDir.path);
  await Hive.openBox('local_storage');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FolderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TrashProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              textTheme: Theme.of(context)
                  .textTheme
                  .apply(fontFamily: GoogleFonts.roboto().fontFamily)),
          home: const SplashScreen()),
    );
  }
}
