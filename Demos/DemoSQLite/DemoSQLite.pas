unit DemoSQLite;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.demosqlite}

interface
{$include AndroidVersion.inc} 
, Rjava, AActivity, Data, fEdit;


type
  MainActivity = class(Activity) 
  public 
    procedure onCreate(savedInstanceState: AOBundle); override; 
    procedure onClick(aView: AVView); override; 
  end; 

implementation
uses  AZCForms;

procedure MainActivity.onCreate(savedInstanceState: AOBundle);
var
  layout : AZCForm;
begin
  inherited onCreate(savedInstanceState);
  layout := AZCForm.create(Self, R.drawable.logo, 'EMail: cvzeljko@gmail.com');
  layout.Gravity := AVGravity.CENTER;

  dBase := initDataBase(self, dBase);

  layout.addLine(AGColor.BLUE);
  layout.addButtonImage(Self, 1, 'Database', R.drawable.ic_next);
  layout.addLine(AGColor.BLUE);
  layout.addButtonImage(Self, 10, 'Exit', R.drawable.exit);

 setContentView(layout);
end;

procedure MainActivity.onClick(aView: AVView);
var
  intent: ACIntent;
begin
   case aView.id of
      1: begin
          intent:=ACIntent.Create(Self, JLClass(TFormEdit));
          startActivity(intent);
      end;
      10: Finish;
   end;
end;

end.
