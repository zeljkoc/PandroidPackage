unit ZCPascalScript;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,  uPSComponent, IBConnection, SQLDB;

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
    procedure OpenFirebird;
  published
    //pascal script
    property PascalScript: String read GetPascalScript write SetPascalScript;
    property PSMessage: WideString read FPSMessage;
  end;

{var
  DataM: TDataM;  }

var
  ResultPascalScript: TStringList;

  IBConnection1: TIBConnection;
  SQLTransaction1: TSQLTransaction;
  SQLQuery1: TSQLQuery;

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

procedure ReadSQL;
var
  i: integer;
begin
    SQLQuery1.First;
    while not SQLQuery1.EOF do begin
    for i:=0 to SQLQuery1.FieldCount - 1 do
        WritelnPascalScript(SQLQuery1.Fields[i].AsString);
      SQLQuery1.Next;
    end;
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

  OpenFirebird;
end;

destructor TZCPascalScript.Destroy;
begin
   SQLQuery1.Free;
   IBConnection1.Free;
   SQLTransaction1.Free;


  ResultPascalScript.Free;
  FPSScript.Free;
  inherited Destroy;
end;

procedure TZCPascalScript.OpenFirebird;
begin
  SafeLoadLibrary('libfbclient.so');
  IBConnection1:= TIBConnection.Create(nil);
  IBConnection1.DatabaseName := 'employee';
  IBConnection1.HostName := '192.168.1.22';
 // IBConnection1.CharSet := 'WIN1250';
  IBConnection1.UserName := 'SYSDBA';
  IBConnection1.Password := 'miki';

  SQLTransaction1:= TSQLTransaction.Create(nil);
  SQLTransaction1.DataBase := IBConnection1;

  SQLQuery1:= TSQLQuery.Create(nil);
  SQLQuery1.DataBase := IBConnection1;
  SQLQuery1.SQL.Add('SELECT r.COUNTRY, r.CURRENCY FROM COUNTRY r');
  SQLQuery1.Open;

 // IBConnection1.Connected := true;
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

  Sender.AddFunction(@ReadSQL, 'procedure ReadSQL;');

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


