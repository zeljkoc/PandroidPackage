unit DemoFirebird;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.demofirebird}

interface
{$include AndroidVersion.inc} 
, Rjava, AActivity, PandroidModule;


type
  MainActivity = class(Activity) 
  public 
    procedure onCreate(savedInstanceState: AOBundle); override; 
  end;

implementation

uses StdCtrls;

procedure MainActivity.onCreate(savedInstanceState: AOBundle);
var
  layout : AWLinearLayout;
   tv: TTextView;
   PModule: ZCPandroidModule;
   IDPModule: jint;
begin
  inherited onCreate(savedInstanceState);
  layout:= AWLinearLayout.Create(Self);
  layout.setOrientation(AWLinearLayout.VERTICAL);

    tv:= TTextView.create(self);
 layout.addView(tv);

  PModule:= ZCPandroidModule.Create;
  IDPModule:= PModule.CreateObject('TZCPascalScript');

 //---------------------------------
  //sned to pandroid module procedure  name
   PModule.SetPropValue(IDPModule, JLString('PascalScript'), JLString('begin  ReadSQL; end.' ) );
   //read pandroid module procedure
   tv.Text :=  PModule.GetPropValue(IDPModule, JLString('PascalScript')) ;
 //-----------------------------------------


 setContentView(layout);
end;


end.
