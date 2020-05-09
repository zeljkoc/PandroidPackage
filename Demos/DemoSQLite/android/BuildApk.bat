cd E:\Example\DemoSQLite\android\
set JAVA_HOME=E:\Zeljus\Java\&lt;jdkdir&gt;
ant -verbose release
jarsigner -verify -verbose -certs E:\Example\DemoSQLite\DemoSQLite.apk
