unit Data;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.demosqlite}

interface
{$include AndroidVersion.inc} 
, DB, DataBase;

const
  DataBaseName  = 'DemoSqlite01.ldb';

var
    dBase: TDataBase;

function initDataBase(aContext: ACContext; aDatabase: TDataBase): TDataBase;

implementation

function initDataBase(aContext: ACContext; aDatabase: TDataBase): TDataBase;
begin
  aDatabase :=  TDatabase.Create(aContext, DataBaseName, nil, 1);

 //sifrarnici
 aDatabase.SQL.add(JLString('create table sPartner (' +
          'PartnerID integer primary key autoincrement, '+
          'Partner text not null'+
          ') '));

  Result := aDatabase;
end;



end.
