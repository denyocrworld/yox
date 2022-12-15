@REM Required:
@REM flutter pub global activate cider

cmd /c cider bump patch 
git add .
git commit -m "Set new version"
git push --force
flutter pub publish --force