unit ZCPascalScript;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,  uPSComponent;

{ TDataM }

type

  { TZCPascalScript }

  TZCPascalScript = class(TComponent)
  private
    FPSMessage: WideString;
    { private declarations }
    FPSScript: TPSScript;

    function GetPascalScript: String;
    procedure SetPascalScript(AValue: String);
  protected
    { protected declarations }
    procedure DoCompile(Sender: TPSScript);
    procedure DoExecute(Sender: TPSScript);
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    //pascal script
    property PascalScript: String read GetPascalScript write SetPascalScript;
    property PSMessage: WideString read FPSMessage;
  end;

{var
  DataM: TDataM;  }

var
  ResultPascalScript: TStringList;

implementation
uses Variants,
   uPSRuntime
 // , uPSComponent_Default
 // , uPSComponent_DB
 // , uPSComponent_COM
//  , uPSC_strutils
  ;

procedure WritelnPascalScript(const s: String);
begin
  ResultPascalScript.Add(s);
end;


constructor TZCPascalScript.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPSScript:= TPSScript.Create(nil);
  FPSScript.OnCompile := @DoCompile;
  FPSScript.OnExecute := @DoExecute;

 { TPSPluginItem(FPSScript.Plugins.Add).Plugin := TPSImport_Classes.Create(nil);
//  TPSPluginItem(FPSScript.Plugins.Add).Plugin := TPSImport_DB.Create(nil);
  TPSPluginItem(FPSScript.Plugins.Add).Plugin := TPSImport_DateUtils.Create(nil);
  TPSPluginItem(FPSScript.Plugins.Add).Plugin := TPSImport_StrUtils.Create(nil);
 // TPSPluginItem(FPSScript.Plugins.Add).Plugin := TPSImport_ComObj.Create(nil);}

  ResultPascalScript:= TStringList.Create;
end;

destructor TZCPascalScript.Destroy;
begin
  ResultPascalScript.Free;
  FPSScript.Free;
  inherited Destroy;
end;


function TZCPascalScript.GetPascalScript: String;
begin
  Result := ResultPascalScript.Text;
  ResultPascalScript.Clear;
end;

procedure TZCPascalScript.DoCompile(Sender: TPSScript);
begin
  Sender.AddRegisteredVariable('vars', 'Variant');

  Sender.AddFunction(@WritelnPascalScript, 'procedure Write(s: String);');  // write result to Activity
  // ... more function to work pandroid module


end;

procedure TZCPascalScript.DoExecute(Sender: TPSScript);
begin
   PPSVariantVariant(Sender.GetVariable('VARS'))^.Data := VarArrayCreate([0, 1], varShortInt);
end;


procedure TZCPascalScript.SetPascalScript(AValue: String);
begin
  FPSMessage := 'Ok';
  FPSScript.Script.Clear;
  FPSScript.Script.Add(AValue);
  if FPSScript.Compile then FPSScript.Execute
  else FPSMessage := FPSScript.CompilerErrorToStr(0);
end;

end.


