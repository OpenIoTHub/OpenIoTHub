import 'package:flutter/foundation.dart';
import 'package:ssh/ssh.dart';

import 'services.dart';

class ConnectionModel with ChangeNotifier {
  SSHClient _client;
  set client(SSHClient value) {
    _client = value;
    notifyListeners();
  }

  SSHClient get client => _client;

  bool _isLoading = true;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  bool _isPasteMode = false;
  set isPasteMode(bool value) {
    _isPasteMode = value;
    notifyListeners();
  }

  bool get isPasteMode => _isPasteMode;

  bool _isCopyMode = false;
  set isCopyMode(bool value) {
    _isCopyMode = value;
    notifyListeners();
  }

  bool get isCopyMode => _isCopyMode;

  List<FileInfo> _savedFileInfos;
  set savedFileInfos(List<FileInfo> value) {
    _savedFileInfos = value;
    notifyListeners();
  }

  List<FileInfo> get savedFileInfos => _savedFileInfos;

  List<String> _savedFilePaths;
  set savedFilePaths(List<String> value) {
    _savedFilePaths = value;
    notifyListeners();
  }

  List<String> get savedFilePaths => _savedFilePaths;

  bool _showProgress = false;
  set showProgress(bool value) {
    _showProgress = value;
    notifyListeners();
  }

  bool get showProgress => _showProgress;

  String _progressType;

  /// can be 'download', 'upload', 'cache'
  set progressType(String value) {
    _progressType = value;
    notifyListeners();
  }

  String get progressType => _progressType;

  int _progressValue = 0;

  /// status of the download or upload in percentage
  set progressValue(int value) {
    _progressValue = value;
    notifyListeners();
  }

  int get progressValue => _progressValue;

  String _loadFilename;

  /// name of the file that is downloading or uploading
  set loadFilename(String value) {
    _loadFilename = value;
    notifyListeners();
  }

  String get loadFilename => _loadFilename;
}
