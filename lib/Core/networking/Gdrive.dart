import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleDriveApi {
  final List<String> _scopes = [drive.DriveApi.driveFileScope];
  drive.DriveApi? _driveApi;

  Future<void> authenticate() async {
    final clientId = ClientId('<YOUR_CLIENT_ID>', '<YOUR_CLIENT_SECRET>');
    final client = await clientViaUserConsent(clientId, _scopes, _prompt);

    _driveApi = drive.DriveApi(client);
  }

  Future<void> uploadFile(String filePath, String fileName) async {
    if (_driveApi == null) return;

    final driveFile = drive.File()..name = fileName;
    final file = File(filePath);
    final media = drive.Media(file.openRead(), await file.length());

    await _driveApi!.files.create(
      driveFile,
      uploadMedia: media,
    );
  }

  void _prompt(String url) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 46021);
    await launchUrl(Uri.parse(url));
    print('Please go to the following URL and grant access:');
    print('  => $url');

    await for (HttpRequest request in server) {
      final uri = request.uri;
      if (uri.path == '/') {
        final code = uri.queryParameters['code'];
        if (code != null) {
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.html
            ..write('<html><h1>You can close this window now</h1></html>');
          await request.response.close();
          await server.close();
          _handleCode(code);
          break;
        }
      }
    }
  }

  void _handleCode(String code) async {
    final clientId = ClientId('<YOUR_CLIENT_ID>', '<YOUR_CLIENT_SECRET>');
    final tokenEndpoint = 'https://oauth2.googleapis.com/token';

    final response = await http.post(
      Uri.parse(tokenEndpoint),
      body: {
        'code': code,
        'client_id': clientId.identifier,
        'client_secret': clientId.secret,
        'redirect_uri': 'http://localhost:46021',
        'grant_type': 'authorization_code',
      },
    );

    if (response.statusCode == 200) {
      final credentials = json.decode(response.body);
      final accessToken = credentials['access_token'];
      final refreshToken = credentials['refresh_token'];
      final expiry =
          DateTime.now().add(Duration(seconds: credentials['expires_in']));

      final authClient = authenticatedClient(
        http.Client(),
        AccessCredentials(
          AccessToken('Bearer', accessToken, expiry),
          refreshToken,
          _scopes,
        ),
      );

      _driveApi = drive.DriveApi(authClient);
    } else {
      print('Failed to exchange code for tokens: ${response.body}');
    }
  }
}
