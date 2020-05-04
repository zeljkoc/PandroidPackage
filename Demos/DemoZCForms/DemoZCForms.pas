unit DemoZCForms;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.demozcforms}

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

uses AZCForms, Dialogs;

procedure MainActivity.onCreate(savedInstanceState: AOBundle);
var
    layout : AZCForm;
begin
  inherited onCreate(savedInstanceState);
  layout := AZCForm.create(Self, R.drawable.logo, 'EMail: cvzeljko@gmail.com');
  layout.Gravity := AVGravity.CENTER;

  layout.addLine(AGColor.BLUE);
  layout.addButtonImage(Self, 1, 'ITEMS 1', R.drawable.ic_next);
  layout.addButtonImage(Self, 2, 'ITEMS 2', R.drawable.ic_next);
  layout.addLine(AGColor.BLUE);
  layout.addButtonImage(Self, 10, 'Exit', R.drawable.exit);

 setContentView(layout);
end;

procedure MainActivity.onClick(aView: AVView);
begin
   case aView.id of
      1: ShowMessage(Self, JLString('Press ITEMS 1'));
      2: ShowMessage(Self, JLString('Press ITEMS 1'));
      10: Finish;
   end;
end;

end.
