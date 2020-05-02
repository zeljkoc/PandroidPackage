{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit zc_Pandroid;

{$warn 5023 off : no warning about unused units}
interface

uses
  RegLazPandroid, FormNewProject, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('RegLazPandroid', @RegLazPandroid.Register);
end;

initialization
  RegisterPackage('zc_Pandroid', @Register);
end.
