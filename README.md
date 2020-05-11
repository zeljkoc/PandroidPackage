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


#### Screenshot
![GitHub Logo](/images/pandroid.png) 

#### Component overview
![Platforms](https://img.shields.io/badge/unit-StdCtrls-red.svg)
color.Blue("TTextView"), TLabelTextView, TEditText, TLabelEditText, TButton, TLabelEditTextButton, TLabelButton, TButtonLabel, 
TButtonEditText, TImageButton, TCheckBox, TRadioGroup, TGridViewLayout

![Platforms](https://img.shields.io/badge/unit-DB-red.svg)
TValue, TField, TFieldDef, TCursorDataSet, TDataSetAddapter, TDBEditText, TDBTextView, TDBDialog, TDBGridViewLayout,
TDBFindDialog, TDBLookupComboBox, TDBGridViewCheckedLayout

![Platforms](https://img.shields.io/badge/unit-Dialogs-red.svg)
TDialog, TTimePickerDialog, TDatePickerDialog, TUserNamePasswordDialog, TEditFileDialog, TTextEditDialog, TYesNoDialog

![Platforms](https://img.shields.io/badge/unit-AZCForms-red.svg)
AZCForm, AZCHorizontalForm, THederForms

![Platforms](https://img.shields.io/badge/unit-AZCToolBar-red.svg)
TZCArrayAddapter, TZCToolBar


#### License
- __PandroidPackage__  is released under Mozilla Public License 2.0 (MPL-2.0)

#### Autor
- Made by  __Željko Cvijanović__  and  __Miran Horjak__ 

www.zeljus.com


