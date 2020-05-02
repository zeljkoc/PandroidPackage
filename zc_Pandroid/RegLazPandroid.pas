{*******************************************************************
* Zeljko Cvijanovic www.zeljus.com (cvzeljko@gmail.com)  &         *
*              Miran Horjak usbdoo@gmail.com                       *
*                                                                  *
* Pandroid is released under Mozilla Public License 2.0 (MPL-2.0)  *
* https://tldrlegal.com/license/mozilla-public-license-2.0-(mpl-2) *
*                           2020                                   *
********************************************************************}
unit RegLazPandroid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FormEditingIntf, ProjectIntf, NewItemIntf, LazIDEIntf,
  Controls, forms;

type

    { TPandroidUnitDescriptor }

    TPandroidUnitDescriptor = class(TProjectFileDescriptor)
    public
      constructor Create; override;
      function GetLocalizedName: string; override;
      function GetLocalizedDescription: string; override;
      function CreateSource(const {%H-}Filename, {%H-}SourceName,
                            {%H-}ResourceName: string): string; override;
    end;

    { TPandroidProjectDescriptor }

    TPandroidProjectDescriptor = class(TProjectDescriptor)
    public
      constructor create; override;
      function GetLocalizedName: string; override;
      function GetLocalizedDescription: string; override;
      function InitProject(AProject: TLazProject) : TModalResult; override;
      function CreateStartFiles(AProject: TLazProject) : TModalResult; override;
    published
      { Published declarations }
    end;


Procedure Register;

implementation

uses  MacroIntf, MacroDefIntf, FormNewProject;

Resourcestring
  SPandroidApps     = 'Android (fpcjvm) ';
  SPandroidAppName  = 'Applications for Android (fpcjvm) ';
  SPandroidAppDescr = 'Applications for Android (fpcjvm)';
  SPandroidUnitName  = 'Unit for Android (fpcjvm) ';
  SPandroidUnitDescr = 'Unit for Android (fpcjvm)';

procedure Register;
var
  DirPackage : String;
begin
  RegisterNewItemCategory(TNewIDEItemCategory.Create(SPandroidApps));
  RegisterProjectDescriptor(TPandroidProjectDescriptor.Create, SPandroidApps);
  RegisterProjectFileDescriptor(TPandroidUnitDescriptor.Create, SPandroidApps);

  DirPackage:='$PkgDir(zc_Pandroid)';
  IDEMacros.SubstituteMacros(DirPackage);
  IDEMacros.Add(TTransferMacro.Create('PandroidDir', DirPackage, 'path to pandroid directory', nil, []));
  {$IFDEF Linux}
  IDEMacros.Add(TTransferMacro.Create('PANDROID', DirPackage+PathDelim+'pandroid', 'path to pandroid binaries', nil, []));
  {$ELSE}
   IDEMacros.Add(TTransferMacro.Create('PANDROID', DirPackage+PathDelim+'pandroid.exe', 'path to pandroid binaries', nil, []));
  {$ENDIF}
end;

{ TPandroidUnitDescriptor }

constructor TPandroidUnitDescriptor.Create;
begin
  inherited Create;
  Name := SPandroidUnitName;
  DefaultFilename:='unit1.pas';
  DefaultSourceName:='unit1';
  DefaultFileExt:='.pas';
//  AddToProject:= true;
end;

function TPandroidUnitDescriptor.GetLocalizedName: string;
begin
  Result:= SPandroidUnitName;
end;

function TPandroidUnitDescriptor.GetLocalizedDescription: string;
begin
  Result := SPandroidUnitDescr;
end;

function TPandroidUnitDescriptor.CreateSource(const Filename, SourceName, ResourceName: string): string;
var
  Src : TStrings;
begin
  Src:=TStringList.Create;
  try
    src.Clear;
    With Src do begin
      Add('unit unit1;');
      Add('');
      Add('{$mode objfpc}{$H+}');
      Add('{$modeswitch unicodestrings}');
      Add('{$namespace  pandroid.unit }');
      Add('');
      Add('interface');
      Add('{$include AndroidVersion.inc} ');
      Add(', Rjava, AActivity; ');
      Add('');
      Add('');
      Add('type');
      Add('  MainActivity = class(Activity) ');
      Add('  public ');
      Add('    procedure onCreate(savedInstanceState: AOBundle); override; ');
      Add('    procedure onClick(aView: AVView); override; ');
      Add('  end; ');
      Add('');
      Add('implementation');
      Add('');
      Add('procedure MainActivity.onCreate(savedInstanceState: AOBundle);');
      Add('var');
      Add('  layout : AWLinearLayout;');
      Add('begin');
      Add('  inherited onCreate(savedInstanceState);');
      Add('  layout:= AWLinearLayout.Create(Self);');
      Add('  layout.setOrientation(AWLinearLayout.VERTICAL);');
      Add('');
      Add(' setContentView(layout);');
      Add('end;');
      Add('');
      Add('procedure MainActivity.onClick(aView: AVView);');
      Add('begin');
      Add('   case aView.id of');
      Add('      1: begin end;');
      Add('   end;');
      Add('end;');
      Add('');
      Add('end.');
      end;
      Result := Src.Text;

  finally
    Src.Free;
  end;
end;


{ TPandroidProjectDescriptor }

constructor TPandroidProjectDescriptor.create;
begin
  inherited create;
  Name:= 'Android (fpcjvm)';
end;

function TPandroidProjectDescriptor.GetLocalizedName: string;
begin
  Result := SPandroidAppName;
end;

function TPandroidProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := SPandroidAppDescr;
end;

function TPandroidProjectDescriptor.InitProject(AProject: TLazProject): TModalResult;
Var
  F : TLazProjectFile;
  Src : TStrings;
  NewProject: TNewProject;
begin
  Result:=Inherited InitProject(AProject);
  If (Result=mrOK) then begin
    //======================================= Zeljus
    NewProject:= TNewProject.Create(nil);
    try
      if NewProject.ShowModal = mrOK then begin

        AProject.Title:='Android application';
        AProject.LazCompilerOptions.TargetOS       := 'Android';
        AProject.LazCompilerOptions.TargetCPU      := 'jvm';
        AProject.LazCompilerOptions.OtherUnitFiles := '$(PandroidDir)'+PathDelim+'units;'+'$(PandroidDir)'+PathDelim+'units'+PathDelim+'pascal';
        AProject.LazCompilerOptions.IncludePath    := '$(PandroidDir)'+PathDelim+'units';
        AProject.LazCompilerOptions.TargetFilename := 'android'+PathDelim+'bin'+PathDelim+'classes'+PathDelim + NewProject.eAppName.Text;
       // AProject.LazCompilerOptions.ExecuteBefore.Command := '$(PANDROID) B $(CompPath) $(ProjPath) $(JavaPackageName) $(ProjFile) $(FPCSrcDir)';

       AProject.LazCompilerOptions.CustomOptions :='-d'+StringReplace(NewProject.Target, '-',   '' ,   [rfReplaceAll]);
       AProject.LazCompilerOptions.ExecuteBefore.Command := '$(PANDROID) R $PkgDir(zc_Pandroid) $(ProjFile)'; //Priprema compajlera za apk  //'$(PANDROID) B $(CompPath) $(ProjPath) '+ NewProject.eJavaPackageName.Text+' $(ProjFile) $(FPCSrcDir)';
       AProject.LazCompilerOptions.ExecuteAfter.Command  := '$(PANDROID) B $PkgDir(zc_Pandroid) $(ProjFile)';    //napraviti
       AProject.LazCompilerOptions.BuildMacros.Add('PandroidPkg');
       AProject.LazCompilerOptions.BuildMacros.Items[0].Values.Add(NewProject.eJavaPackageName.Text);


      if not (DirectoryExists(NewProject.eProjectDir.Text+ PathDelim +NewProject.eAppName.Text)) then CreateDir( NewProject.eProjectDir.Text+ PathDelim +NewProject.eAppName.Text);
      //create android directory for project
      NewProject.CreateAndroidProject;

      AProject.ProjectInfoFile:= NewProject.eProjectDir.Text+ PathDelim +NewProject.eAppName.Text+ PathDelim + NewProject.eAppName.Text+'.lpi';
      F:=AProject.CreateProjectFile(NewProject.eProjectDir.Text+ PathDelim +NewProject.eAppName.Text+ PathDelim + NewProject.eAppName.Text+'.pas');
    //========================================
          AProject.AddFile(F, False);
          AProject.MainFileID:=0;
          Src:=TStringList.Create;
          try
        //    Src.Add('Test manifest');

         //   Src.SaveToFile(NewProject.eProjectDir.Text+ PathDelim +NewProject.eAppName.Text+ PathDelim +'android'+PathDelim+'AndroidManifest.xml');
            src.Clear;
            With Src do begin
              Add('unit '+NewProject.eAppName.Text+';');
              Add('');
              Add('{$mode objfpc}{$H+}');
              Add('{$modeswitch unicodestrings}');
              Add('{$namespace '+NewProject.eJavaPackageName.Text+'}');
              Add('');
              Add('interface');
              Add('{$include AndroidVersion.inc} ');
              Add(', Rjava, AActivity; ');
              Add('');
              Add('');
              Add('type');
              Add('  MainActivity = class(Activity) ');
              Add('  public ');
              Add('    procedure onCreate(savedInstanceState: AOBundle); override; ');
              Add('    procedure onClick(aView: AVView); override; ');
              Add('  end; ');
              Add('');
              Add('implementation');
              Add('');
              Add('procedure MainActivity.onCreate(savedInstanceState: AOBundle);');
              Add('var');
              Add('  layout : AWLinearLayout;');
              Add('begin');
              Add('  inherited onCreate(savedInstanceState);');
              Add('  layout:= AWLinearLayout.Create(Self);');
              Add('  layout.setOrientation(AWLinearLayout.VERTICAL);');
              Add('');
              Add(' setContentView(layout);');
              Add('end;');
              Add('');
              Add('procedure MainActivity.onClick(aView: AVView);');
              Add('begin');
              Add('   case aView.id of');
              Add('      1: begin end;');
              Add('   end;');
              Add('end;');
              Add('');
              Add('end.');
              end;
            F.SetSourceText(Src.Text);

          finally
            Src.Free;
          end;
       end;
      finally
        NewProject.Free;
      end;
    end;
end;

function TPandroidProjectDescriptor.CreateStartFiles(AProject: TLazProject): TModalResult;
begin
  try     //kada je cancel pravi izuzetak
   Result:=LazarusIDE.DoOpenEditorFile(AProject.MainFile.Filename,-1,-1,
                                       [ofProjectLoading,ofRegularFile]);
   Result:=LazarusIDE.DoSaveAll([]);
  except
  end;
end;

end.

