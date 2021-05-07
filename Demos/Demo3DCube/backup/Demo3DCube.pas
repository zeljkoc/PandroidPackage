unit Demo3DCube;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.demo3dcube}

interface
{$include AndroidVersion.inc} 
, Rjava, AActivity; 


type
  MainActivity = class(Activity) 
  public 
    procedure onCreate(savedInstanceState: AOBundle); override; 
    procedure onClick(aView: AVView); override; 
  end; 

implementation

procedure MainActivity.onCreate(savedInstanceState: AOBundle);
var
  layout : AWLinearLayout;
begin
  inherited onCreate(savedInstanceState);
  layout:= AWLinearLayout.Create(Self);
  layout.setOrientation(AWLinearLayout.VERTICAL);

 setContentView(layout);
end;

procedure MainActivity.onClick(aView: AVView);
begin
   case aView.id of
      1: begin end;
   end;
end;

end.
