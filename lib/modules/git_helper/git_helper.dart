import 'dart:io';

import 'package:intl/intl.dart';
import 'package:yox/shared/helper/exec/exec.dart';

class GitHelper {
  static String userName = "";
  static String userEmail = "";

  static simplePush() {
    var dateString = DateFormat('EEE, MMM d, kk:mm:ss').format(DateTime.now());

    var res = exec("git config user.name");
    print(res);

    var repo = exec("git remote -v");
    print(repo);

    var _userName = "flutterlabz";
    var _email = "flutterlabz@gmail.com";

    if (repo.toString().contains("git@personal")) {
      _userName = "codekaze";
      _email = "codekaze.id@gmail.com";
    }

    execLines(
      [
        'git config user.name "$_userName"',
        'git config user.email "$_email"',
        'git add .',
        'git commit -m "$dateString"',
        'git push',
      ],
    );
  }

  static config() {
    var res = exec("git config user.name");
    print(res);

    var repo = exec("git remote -v");
    print(repo);

    var _userName = "flutterlabz";
    var _email = "flutterlabz@gmail.com";

    var isPersonal = false;
    if (repo.toString().contains("git@personal")) {
      _userName = "codekaze";
      _email = "codekaze.id@gmail.com";
      isPersonal = true;
    }

    print("IS PERSONAL: $isPersonal");
    print("username: $_userName");
    print("email: $_email");
  }

  // its > git remote add origin <url>
  static add(String fullArgumentString) async {
    var githubUrl = fullArgumentString.split(" ")[1];
    githubUrl = convertToSshUrl(githubUrl);
    execr('git init');
    execr('git remote remove origin');
    execr('git remote add origin $githubUrl');
    execr('git config user.name "$userName"');
    execr('git config user.email "$userEmail"');
    execr('git add .');
    execr('git commit -m "."');
    execr('git push --set-upstream origin master --force');
  }

  // its > git remote add origin <url>
  static clone(String fullArgumentString) async {
    var args = fullArgumentString.split(" ");
    var githubUrl = args[1];
    var parameter;
    if (args.length >= 3) {
      parameter = args[2];
    }

    githubUrl = convertToSshUrl(githubUrl);

    var arr = githubUrl.split("/");
    var repoName = arr[arr.length - 1];
    if (repoName.endsWith(".git")) {
      repoName = repoName.replaceAll(".git", "");
    }

    var cloneCommand = "git clone $githubUrl";
    if (parameter != null) {
      cloneCommand = "git clone $githubUrl .";
    }

    var changeDirectoryCommand = "";
    if (parameter == null) {
      changeDirectoryCommand = 'cd $repoName';
    }

    var preCommand = "";
    if (parameter != null) {
      preCommand = "rm -rf * .git .vscode";

      var nah = Directory.current.listSync();
      if (nah.length > 2) {
        writeSeparator();
        writeSeparator();
        print("Your Directory is not Empty, this Command is Very Dangerous");
        print("This command will delete all directory and files");
        print(
            "No Backup, please dont run this command on your project directory");
        writeSeparator();
        return;
      }
    }

    execLines(
      [
        preCommand,
        cloneCommand,
        changeDirectoryCommand,
        "git init",
        'git config user.name "$userName"',
        'git config user.email "$userEmail"',
        'dir',
        'echo %cd%',
      ],
    );
  }

  static convertToSshUrl(String url) {
    /*
    from:  https://github.com/codekaze/yocommerce.git
    to:    git@github.com:codekaze/yocommerce.git
    */

    if (!url.endsWith(".git")) {
      url = url + ".git";
    }

    url = url.replaceAll("https://github.com/", "git@github.com:");

    var arr = url.split(":");
    var username = arr[1].split("/")[0];

    /*
    from: git@github.com:codekaze/yocommerce.git
    to:   git@work:codekaze/yocommerce.git
          git@personal:codekaze/yocommerce.git
    */

    if (username == "codekaze") {
      url = url.replaceAll("github.com", "personal");
      userName = "codekaze";
      userEmail = "codekaze.id@gmail.com";
    } else {
      url = url.replaceAll("github.com", "work");
      userName = "flutterlabz";
      userEmail = "flutterlabz@gmail.com";
    }

    print("username: $username");
    print("url: $url");
    print("userName: $userName");
    print("email: $userEmail");
    return url;
  }
}
