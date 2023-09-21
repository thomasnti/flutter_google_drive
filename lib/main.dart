// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_google_drive/google_drive_actions_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _googleSignIn = GoogleSignIn.standard(
    scopes: [
      drive.DriveApi.driveScope,
      drive.DriveApi.driveFileScope,
    ],
  );

  final TextStyle textStyle = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => googleLogin(context),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.blue.shade600),
              ),
              child: Text(
                'Google Drive Sign in',
                style: textStyle,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> googleLogin(BuildContext context) async {
    try {
      final account = await _googleSignIn.signIn();
      // final authHeaders = await account.authHeaders;
      print(account);
      if (account != null) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoogleDriveActionsPage(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String>? _headers;
  final _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers!);
    return _client.send(request);
  }
}
