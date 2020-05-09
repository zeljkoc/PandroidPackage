cd E:\Example\DemoSQLite\android
del E:\Example\DemoSQLite\DemoSQLite.apk
rd bin /s /q
rd gen /s /q
mkdir bin
mkdir bin\classes
mkdir gen

E:\Zeljus\pandroid\sdk\build-tools\23.0.3\aapt.exe package -m -J E:\Example\DemoSQLite\android\gen -M E:\Example\DemoSQLite\android\AndroidManifest.xml -S E:\Example\DemoSQLite\android\res -I E:\Zeljus\pandroid\sdk\platforms\android-15\android.jar -S E:\Example\DemoSQLite\android\res -m -J E:\Example\DemoSQLite\android\gen 
