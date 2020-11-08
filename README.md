![Lazarus package](https://img.shields.io/badge/-Lazarus%20package-green.svg)
![Full source](https://img.shields.io/badge/-Full%20source-green.svg)
![Platforms](https://img.shields.io/badge/Platforms-Linux%20and%20Windows-red.svg)
![Platforms](https://img.shields.io/badge/Build-Android%20Apk-red.svg)

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/zeljus?locale.x=en_US)

#### Info
Configure ini file: __pandroid.ini__

Change keystore/__zeljus.keystore__ and to correct template/__ant.properties__


You need to install
- [x] [android __sdk__](http://www.downloads.puresoft.ir/files/android/SDK/) 
- [x] [__OpenJdk-8__](https://developers.redhat.com/products/openjdk/download)
- [x] [apache __ant__](https://ant.apache.org/)

Exampl: (openjdk-8-jdk and appache ant) <br/>
__Debiana buster lxde 64 bit__ <br/>
#: apt-get install wget <br/>
#: wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add - <br/>
#: nano /etc/apt/sources.list <br/>
  deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ buster main <br/>

#: apt-get update  <br/>
#: apt-get install libgtk2.0-dev gdb adoptopenjdk-8-jdk android-tools-adb ant mtp-tools aapt zip git <br/> 
#: update-alternatives --config java <br/>
(set openjdk-8-jdk) <br/>


for lazarus cross compile ([__laz4android__](https://sourceforge.net/projects/laz4android/))
- [x] __jvm-android__  (android vizual create AWLinearLayout, AWButton, AWEditText, AWTextView, ...; include *.jar file)     
- [x] __arm-android__ or __aarch64-android__ (not vizual component, pascalscript, indy, ...)
- [x] [__ndk__ for arm-android and aarch64-android ](https://developer.android.com/ndk/downloads) 


Pandroid exe or pandroid for linux compiled from PandroidTools
-  Lazarus compiler calls before pandorid.exe and creates R.java and Rjava.pas, necessary for compiling Pascal classes.
-  The second part compiles the classes from the paskal code
-  Lazarus compiler calls after pandorid.exe and makes a script to create apk, and create apk

Attached is the possibility of a template more for arm-android compilation, such as pandroidmodule,
making * .so then making  PandroidModule.jar and finally making PandroidModule.pas PandroidModule.inc for the compiler

#### Component overview
![Platforms](https://img.shields.io/badge/unit-StdCtrls-red.svg)
![Platforms](https://img.shields.io/badge/TTextView-blue.svg)
![Platforms](https://img.shields.io/badge/TLabelTextView-blue.svg)
![Platforms](https://img.shields.io/badge/TEditText-blue.svg)
![Platforms](https://img.shields.io/badge/TLabelEditText-blue.svg)
![Platforms](https://img.shields.io/badge/TButton-blue.svg)
![Platforms](https://img.shields.io/badge/TLabelEditTextButton-blue.svg)
![Platforms](https://img.shields.io/badge/TLabelButton-blue.svg)
![Platforms](https://img.shields.io/badge/TButtonLabel-blue.svg)
![Platforms](https://img.shields.io/badge/TButtonEditText-blue.svg)
![Platforms](https://img.shields.io/badge/TImageButton-blue.svg)
![Platforms](https://img.shields.io/badge/TCheckBox-blue.svg)
![Platforms](https://img.shields.io/badge/TRadioGroup-blue.svg)
![Platforms](https://img.shields.io/badge/TGridViewLayout-blue.svg)

![Platforms](https://img.shields.io/badge/unit-DB-red.svg)
![Platforms](https://img.shields.io/badge/TValue-blue.svg)
![Platforms](https://img.shields.io/badge/TField-blue.svg)
![Platforms](https://img.shields.io/badge/TFieldDef-blue.svg)
![Platforms](https://img.shields.io/badge/TCursorDataSet-blue.svg)
![Platforms](https://img.shields.io/badge/TDataSetAddapter-blue.svg)
![Platforms](https://img.shields.io/badge/TDBEditText-blue.svg)
![Platforms](https://img.shields.io/badge/TDBTextView-blue.svg)
![Platforms](https://img.shields.io/badge/TDBDialog-blue.svg)
![Platforms](https://img.shields.io/badge/TDBGridViewLayout-blue.svg)
![Platforms](https://img.shields.io/badge/TDBFindDialog-blue.svg)
![Platforms](https://img.shields.io/badge/TDBLookupComboBox-blue.svg)
![Platforms](https://img.shields.io/badge/TDBGridViewCheckedLayout-blue.svg)

![Platforms](https://img.shields.io/badge/unit-Dialogs-red.svg)
![Platforms](https://img.shields.io/badge/TDialog-blue.svg)
![Platforms](https://img.shields.io/badge/TTimePickerDialog-blue.svg)
![Platforms](https://img.shields.io/badge/TDatePickerDialog-blue.svg)
![Platforms](https://img.shields.io/badge/TUserNamePasswordDialog-blue.svg)
![Platforms](https://img.shields.io/badge/TEditFileDialog-blue.svg)
![Platforms](https://img.shields.io/badge/TTextEditDialog-blue.svg)
![Platforms](https://img.shields.io/badge/TYesNoDialog-blue.svg)

![Platforms](https://img.shields.io/badge/unit-AZCForms-red.svg)
![Platforms](https://img.shields.io/badge/AZCForm-blue.svg)
![Platforms](https://img.shields.io/badge/AZCHorizontalForm-blue.svg)
![Platforms](https://img.shields.io/badge/THederForms-blue.svg)

![Platforms](https://img.shields.io/badge/unit-AZCToolBar-red.svg)
![Platforms](https://img.shields.io/badge/TZCArrayAddapter-blue.svg)
![Platforms](https://img.shields.io/badge/TZCToolBar-blue.svg)

#### Screenshot
![GitHub Logo](/images/pandroid.png) 

#### License
- __PandroidPackage__  is released under Mozilla Public License 2.0 (MPL-2.0)

#### Autor
- Made by  __Željko Cvijanović__  and  __Miran Horjak__ 

www.zeljus.com


