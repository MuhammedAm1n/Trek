import 'package:video_diary/Core/networking/Gdrive.dart';

class Gdriverepo {
  final GoogleDriveApi _googleDriveApi;

  Gdriverepo(this._googleDriveApi);

  uploadVideos() async {
    await _googleDriveApi.uploadAllVideos();
  }

  cancelUploading() {
    _googleDriveApi.cancelUpload();
  }
}
