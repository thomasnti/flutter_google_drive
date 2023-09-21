import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:intl/intl.dart';

import 'main.dart';

class GoogleDriveActionsPage extends StatelessWidget {
  GoogleDriveActionsPage({super.key});

  final _googleSignIn = GoogleSignIn.standard(
    scopes: [
      drive.DriveApi.driveScope,
      drive.DriveApi.driveFileScope,
    ],
  );
  final TextStyle textStyle = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drive Actions Page',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Drive Actions'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => googleLogout(context),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(Colors.red.shade600),
                ),
                child: Text(
                  'Google Drive Sign out',
                  style: textStyle,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => uploadFile(context),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(Colors.purple.shade600),
                ),
                child: Text(
                  'Upload file',
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  googleLogout(BuildContext context) async {
    await _googleSignIn.signOut();
  }

  Future<void> _uploadToHidden(BuildContext context) async {}

  uploadFile(BuildContext context) async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return;
      }
      // Not allow a user to do something else
      // showGeneralDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   transitionDuration: const Duration(seconds: 2),
      //   barrierColor: Colors.black.withOpacity(0.5),
      //   pageBuilder: (context, animation, secondaryAnimation) => const Center(
      //     child: CircularProgressIndicator(color: Colors.pink),
      //   ),
      // );

      // Create data here instead of loading a file
      const contents = "Thomas Ntinas";
      final Stream<List<int>> mediaStream = Future.value(contents.codeUnits).asStream().asBroadcastStream();
      var media = drive.Media(mediaStream, contents.length);

      // Set up File info
      var driveFile = drive.File();
      final timestamp = DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
      driveFile.name = "technical-feeder-$timestamp.txt";
      driveFile.modifiedTime = DateTime.now().toUtc();
      //driveFile.parents = ["appDataFolder"];

      final response = await driveApi.files.create(driveFile, uploadMedia: media);

      print(response);
    } finally {
      // Remove a dialog
      //Navigator.pop(context);
    }
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final googleUser = await _googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    // if (headers == null) {
    //   await showMessage(context, "Sign-in first", "Error");
    //   return null;
    // }

    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }
}
