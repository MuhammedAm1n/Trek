import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as p;

// Custom exceptions
class HandleException implements Exception {
  final String message;
  HandleException(this.message);

  @override
  String toString() => ' $message';
}

class GoogleDriveApi {
  drive.DriveApi? _driveApi;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/drive.file'],
  );

  GoogleSignInAccount? _currentUser;

  Future<void> authenticate() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser == null) {
        throw HandleException('Sign-in failed or was canceled');
      }

      final authHeaders = await _currentUser!.authHeaders;
      final client = http.Client();
      final authenticatedClient = _AuthenticatedClient(client, authHeaders);

      _driveApi = drive.DriveApi(authenticatedClient);
    } catch (e) {
      throw HandleException('Authentication failed: $e');
    }
  }

  Future<String> _getOrCreateFolder(String folderName) async {
    if (_driveApi == null) {
      throw HandleException('Drive API not initialized');
    }

    try {
      final fileList = await _driveApi!.files.list(
        q: "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false",
      );
      if (fileList.files != null && fileList.files!.isNotEmpty) {
        return fileList.files!.first.id!;
      } else {
        final folder = drive.File()
          ..name = folderName
          ..mimeType = 'application/vnd.google-apps.folder';
        final folderCreation = await _driveApi!.files.create(folder);
        return folderCreation.id!;
      }
    } catch (e) {
      throw HandleException('Failed to create or get folder');
    }
  }

  Future<void> uploadAllVideos() async {
    if (_driveApi == null) {
      await authenticate();
    }

    final directory = Directory(
        "/data/user/0/com.example.video_diary/app_flutter/.myAppVideos");
    final videoFiles = directory
        .listSync()
        .where((file) => file.path.endsWith('.mp4'))
        .toList();

    List<String> existingFiles = [];
    bool newFilesUploaded = false;

    final folderId =
        await _getOrCreateFolder('MyAppVideos'); // Specify your folder name

    for (var file in videoFiles) {
      try {
        bool fileExists =
            await _checkIfFileExists(p.basename(file.path), folderId);
        if (!fileExists) {
          await uploadFile(file.path, p.basename(file.path), folderId);
          newFilesUploaded = true;
        } else {
          existingFiles.add(file.path);
        }
      } catch (e) {
        throw HandleException('Failed to upload file ${file.path}: $e');
      }
    }

    if (!newFilesUploaded && existingFiles.isNotEmpty) {
      throw HandleException("All videos have already been backed up.");
    }
  }

  Future<void> uploadFile(
    String filePath,
    String fileName,
    String folderId,
  ) async {
    if (_driveApi == null) {
      throw HandleException('Drive API not initialized');
    }

    final driveFile = drive.File()
      ..name = fileName
      ..parents = [folderId];
    final file = File(filePath);
    final media = drive.Media(file.openRead(), await file.length());

    try {
      final uploadedFile = await _driveApi!.files.create(
        driveFile,
        uploadMedia: media,
      );

      if (uploadedFile.name == null) {
        throw HandleException('Failed to upload $fileName');
      }
    } catch (e) {
      throw HandleException('Failed to upload file $fileName: $e');
    }
  }

  Future<bool> _checkIfFileExists(String fileName, String folderId) async {
    if (_driveApi == null) {
      throw HandleException('Drive API not initialized');
    }

    try {
      final fileList = await _driveApi!.files.list(
        q: "name = '$fileName' and '$folderId' in parents and trashed = false",
      );
      return fileList.files?.isNotEmpty ?? false;
    } catch (e) {
      throw HandleException('Error checking if file exists: $e');
    }
  }
}

// Custom HTTP client to add authorization headers
class _AuthenticatedClient extends http.BaseClient {
  final http.Client _client;
  final Map<String, String> _authHeaders;

  _AuthenticatedClient(this._client, this._authHeaders);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_authHeaders);
    return _client.send(request);
  }
}
