import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info/device_info.dart';

import '/filesaverz.dart';

export '../addons/filebrowser.dart' hide filebrowser;

/// Opening a custom file explorer.
Future<String?> filebrowser(BuildContext context, FileSaver fileSaver) async {
  if (await _checkPermission()) {
    /// If app have permission, it will opening a custom file expolorer of [FileSaver].
    return showDialog<String>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) => FractionalTranslation(
            translation: Offset(0, 1 - value), child: fileSaver),
      ),
    );
  } else {
    /// If user not giving the app permission, it will showing snackbar and returning null.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          fileSaver.style!.text.messageDenied,
          style: fileSaver.style!.primaryTextStyle.copyWith(
              fontSize: fileSaver.style!.secondaryTextStyle.fontSize ?? 14),
        ),
        backgroundColor: Colors.red,
      ),
    );
    return null;
  }
}

Future<bool> _checkPermission() async {
    final androidSdk = await _getAndroidSdkInt();
    // Android Tiramisu (13)
    if (androidSdk >= 33) {
      if ((await Permission.photos.status) != PermissionStatus.granted ||
          (await Permission.audio.status) != PermissionStatus.granted ||
          (await Permission.videos.status) != PermissionStatus.granted
      ) {
        try {
          return (await Future.wait([
            Permission.photos.request(),
            Permission.audio.request(),
            Permission.videos.request(),
            Permission.storage.request(),
          ], eagerError: false))
              .every((element) => element == PermissionStatus.granted);
        } catch (error) {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return _checkPermissionStorage();
    }
}

Future<bool> _checkPermissionStorage() async {
  PermissionStatus permission = await Permission.storage.status;
  if (permission != PermissionStatus.granted) {
    final permission = await Permission.storage.request();
    if (permission == PermissionStatus.granted) {
      return true;
    }
  } else {
    return true;
  }
  return false;
}

Future<int> _getAndroidSdkInt() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  return (await deviceInfo.androidInfo).version.sdkInt;
}
