{*******************************************************************
* Zeljko Cvijanovic www.zeljus.com (cvzeljko@gmail.com)  &         *
*              Miran Horjak usbdoo@gmail.com                       *
*                                                                  *
* Pandroid is released under Mozilla Public License 2.0 (MPL-2.0)  *
* https://tldrlegal.com/license/mozilla-public-license-2.0-(mpl-2) *
*                           2020                                   *
********************************************************************}
unit FormNewProject;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn;

type

  { TNewProject }

  TNewProject = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cbProject: TComboBox;
    eAppName: TEdit;
    eJavaPackageName: TEdit;
    eProjectDir: TDirectoryEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure eAppNameExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    PackageDirectory: String;
    AndroidSDKDir,
    BuildTools: String;
    procedure ProjectTemplateDirectory(ListDir: String);
    procedure LoadIniFile;
    procedure SaveIniFile;
    function StringNameReplace(S: String): String;
  public
    Target: String;
    Procedure CreateAndroidProject;
  end;

var
  NewProject: TNewProject;

implementation

{$R *.lfm}
uses MacroIntf, IniFiles, FileUtil;

{ TNewProject }

procedure TNewProject.eAppNameExit(Sender: TObject);
begin
 // eJavaPackageName.Text := eJavaPackageName.Text + eAppName.Text;
end;

procedure TNewProject.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SaveIniFile;
end;

procedure TNewProject.FormCreate(Sender: TObject);
begin
  PackageDirectory:='$PkgDir(zc_Pandroid)';
  IDEMacros.SubstituteMacros(PackageDirectory);
  LoadIniFile;
  ProjectTemplateDirectory(PackageDirectory+PathDelim+'template'+PathDelim);
end;

procedure TNewProject.ProjectTemplateDirectory(ListDir: String);
var
   Info: TSearchRec;
begin
  cbProject.Clear;
  if FindFirst(ListDir+'*', faAnyFile and faDirectory, Info) = 0 then begin
    repeat
      with Info do begin
        if ((Attr and faDirectory) <> 0) and (Name <> '.') and (Name <> '..') then
          cbProject.Items.Add(Name);
      end;
    until FindNext(info)<>0;
  end;
  FindClose(Info);
  cbProject.Text := cbProject.Items[0];
end;

procedure TNewProject.LoadIniFile;
var
   IniFile : TIniFile;
begin
   IniFile := TIniFile.Create(PackageDirectory + PathDelim+ 'pandroid.ini');
   try
     eJavaPackageName.Text   := IniFile.ReadString('pandroid', 'JavaPackageName', 'zeljus.com.button');
     eProjectDir.Text        := IniFile.ReadString('pandroid', 'ProjectDir', '/usr/local/pandroid/example');

     AndroidSDKDir     := IniFile.ReadString('pandroid', 'AndroidSDKDir', '/usr/local/pandroid/sdk');
     Target            := IniFile.ReadString('pandroid', 'Target', 'android-15');
     BuildTools        := IniFile.ReadString('pandroid', 'BuildTools', '23.0.3');
   finally
     IniFile.Free;
   end;
end;

procedure TNewProject.SaveIniFile;
var
   IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(PackageDirectory + PathDelim+ 'pandroid.ini');
  try
     IniFile.WriteString('pandroid', 'JavaPackageName', eJavaPackageName.Text);
     IniFile.WriteString('pandroid', 'ProjectDir',      eProjectDir.Text);

   //  IniFile.WriteString('pandroid', 'AndroidSDKDir',   AndroidSDKDir);
   //  IniFile.WriteString('pandroid', 'Target',          Target);
   //  IniFile.WriteString('pandroid', 'BuildTools',      BuildTools);
  finally
    IniFile.Free;
  end;
end;

function TNewProject.StringNameReplace(S: String): String;
begin
  S :=  StringReplace(S, '#ProjectDir#',      eProjectDir.Text,      [rfReplaceAll]);
  S :=  StringReplace(S, '#JavaPackageName#', eJavaPackageName.Text, [rfReplaceAll]);
  S :=  StringReplace(S, '#AndroidSDKDir#',   AndroidSDKDir,         [rfReplaceAll]);
  S :=  StringReplace(S, '#Target#',          Target,                [rfReplaceAll]);
  S :=  StringReplace(S, '#BuildTools#',      BuildTools,            [rfReplaceAll]);
  S :=  StringReplace(S, '#AppName#',         eAppName.Text,         [rfReplaceAll]);
//  S :=  StringReplace(S, '#ActivityName#',    AProject.gActivityName,    [rfReplaceAll]);
  S :=  StringReplace(S, '#PANDROID#',        PackageDirectory,      [rfReplaceAll]);
  S :=  StringReplace(S, '#DatumVreme#',      DateTimeToStr(now),    [rfReplaceAll]);
  Result := S;
end;

{$ifndef linux}
function Replace(S, Old, New: String): String;
var i: integer;
begin
  Result := '';
  for i:=1 to Length(S) do begin
     if S[i]=Old then Result := Result + New
     else Result := Result + S[i];
  end;
end;
{$Endif}

procedure TNewProject.CreateAndroidProject;
var
  Str: string;
  lFile: TStringList;
  i: integer;
  ProjectPath: String;
  AndroidPath: String;
begin

  ProjectPath := eProjectDir.Text + PathDelim + eAppName.Text;
  AndroidPath := ProjectPath + PathDelim + 'android';

  ForceDirectories(AndroidPath);
  ForceDirectories(AndroidPath + PathDelim + 'libs' ); //+ PathDelim + 'armeabi');
  ForceDirectories(AndroidPath + PathDelim + 'res' + PathDelim + 'values');

  Str := StringReplace(eJavaPackageName.Text, '.', PathDelim, [rfReplaceAll]);
  ForceDirectories(AndroidPath + PathDelim + 'src' + PathDelim + Str);

  lFile := TStringList.Create;
  try
     //build xml
    lFile.LoadFromFile(PackageDirectory +PathDelim+'template'+PathDelim + cbProject.Text +PathDelim+'android'+PathDelim+ 'AndroidManifest.xml');
    for i:=0 to lFile.Count - 1 do begin
      lFile.Strings[i] := StringNameReplace(lFile.Strings[i]);
    end;
    lFile.SaveToFile(AndroidPath + PathDelim + 'AndroidManifest.xml');


    lFile.Clear;
    lFile.LoadFromFile(PackageDirectory + PathDelim + 'template' + PathDelim + cbProject.Text + PathDelim + 'android' + PathDelim + 'build.xml');
    for i:=0 to lFile.Count - 1 do begin
      lFile.Strings[i] := StringNameReplace(lFile.Strings[i]);
    end;
    lFile.SaveToFile(AndroidPath + PathDelim + 'build.xml');

    //Build java files
 {   lFile.Clear;
    lFile.Add('# Project target.');
    lFile.Add('target='+ Target);
    lFile.Add('# SDK directory');
    {$ifdef linux}
     lFile.Add('sdk.dir='+ AndroidSDKDir);
    {$else}
     lFile.Add('sdk.dir=' + Replace(AndroidSDKDir, '\', '\\'));
    {$endif}
    lFile.SaveToFile(AndroidPath + PathDelim + 'project.properties');

   lFile.Clear;
    lFile.LoadFromFile(PackageDirectory + PathDelim + 'template' + PathDelim + cbProject.Text + PathDelim + 'android' + PathDelim + 'ant.properties');
    for i:=0 to lFile.Count - 1 do begin
      lFile.Strings[i] := StringNameReplace(lFile.Strings[i]);
      {$IFDEF Windows}
      if pos('key.store', lFile.Strings[i]) <> 0 then begin
      lFile.Strings[i] := StringReplace(lFile.Strings[i], '\',   '\\' ,   [rfReplaceAll]);
      lFile.Strings[i] := StringReplace(lFile.Strings[i], '/',   '\\' ,   [rfReplaceAll]);
      end else
      lFile.Strings[i] := StringReplace(lFile.Strings[i], '/',   '\' ,   [rfReplaceAll]);
      {$ENDIF}
    end;
    lFile.SaveToFile(AndroidPath + PathDelim + 'ant.properties');
  }
    // copy Rjava.pas
    lFile.Clear;
    lFile.LoadFromFile(PackageDirectory + PathDelim + 'template' + PathDelim + cbProject.Text + PathDelim + 'Rjava.pas');
    for i:=0 to lFile.Count - 1 do begin
      lFile.Strings[i] := StringNameReplace(lFile.Strings[i]);
    end;
    lFile.SaveToFile(ProjectPath + PathDelim+ 'Rjava' + '.pas');

    //copy res files

    lFile.Clear;
    lFile.LoadFromFile(PackageDirectory + PathDelim + 'template' + PathDelim + cbProject.Text + PathDelim + 'android' + PathDelim + 'res' + PathDelim + 'values' + PathDelim + 'strings.xml');
    for i:=0 to lFile.Count - 1 do begin
      lFile.Strings[i] := StringNameReplace(lFile.Strings[i]);
    end;
    lFile.SaveToFile(AndroidPath + PathDelim + 'res' + PathDelim + 'values' + PathDelim + 'strings.xml');

    lFile.Clear;
    lFile.LoadFromFile(PackageDirectory + PathDelim + 'template' + PathDelim + cbProject.Text + PathDelim + 'android' + PathDelim + 'res' + PathDelim + 'values' + PathDelim + 'styles.xml');
    for i:=0 to lFile.Count - 1 do begin
      lFile.Strings[i] := StringNameReplace(lFile.Strings[i]);
    end;
    lFile.SaveToFile(AndroidPath + PathDelim + 'res' + PathDelim + 'values' + PathDelim + 'styles.xml');


    FileUtil.CopyDirTree(PackageDirectory + PathDelim + 'template' + PathDelim + cbProject.Text + PathDelim+ 'android' + PathDelim + 'res' + PathDelim + 'drawable',
                        AndroidPath + PathDelim + 'res' + PathDelim + 'drawable' , [cffCreateDestDirectory]);

    FileUtil.CopyDirTree(PackageDirectory + PathDelim+ 'template'+PathDelim+ cbProject.Text +PathDelim+ 'android' + PathDelim + 'res' + PathDelim + 'drawable-ldpi',
                       AndroidPath + PathDelim + 'res' + PathDelim + 'drawable-ldpi' , [cffCreateDestDirectory]);

    FileUtil.CopyDirTree(PackageDirectory + PathDelim+ 'template'+PathDelim + cbProject.Text +PathDelim+ 'android' + PathDelim + 'libs',
                       AndroidPath + PathDelim + 'libs' , [cffCreateDestDirectory]);

    FileUtil.CopyDirTree(PackageDirectory + PathDelim+ 'template'+PathDelim+ cbProject.Text +PathDelim+ 'android' + PathDelim + 'assets',
                       AndroidPath  + PathDelim + 'assets' , [cffCreateDestDirectory]);

  //Kopiranje direktorija ako postoji
  if DirectoryExists(PackageDirectory + PathDelim + 'template' + PathDelim + cbProject.Text + PathDelim + 'pascalsrc') then
    FileUtil.CopyDirTree(PackageDirectory + PathDelim + 'template'+ PathDelim + cbProject.Text + PathDelim + 'pascalsrc',
                         ProjectPath + PathDelim+ 'pascalsrc'  , [cffCreateDestDirectory]);


  finally
    lFile.Free;
  end;


end;

procedure TNewProject.Button2Click(Sender: TObject);
begin
  Close;
end;

end.

