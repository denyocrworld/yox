import 'dart:io';

import 'package:ftpconnect/ftpconnect.dart';

class Deploy {
  static run(String fullArgumentString) async {
    FTPConnect ftpConnect = FTPConnect(
      'codekaze.com',
      user: 'codekaze',
      pass: '!CodekazeRoot123',
      isSecured: true,
    );

    File fileToUpload = File('hotkey.ahk');
    await ftpConnect.connect();
    bool res =
        await ftpConnect.uploadFileWithRetry(fileToUpload, pRetryCount: 2);
    await ftpConnect.disconnect();
    print(res);
  }
}
