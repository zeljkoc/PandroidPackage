unit fEdit;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.demosqlite}

interface
{$include AndroidVersion.inc} 
, Rjava, AActivity, DB, StdCtrls;


type

  { TFormEdit }

  TFormEdit = class(Activity)
  public 
    procedure onCreate(savedInstanceState: AOBundle); override; 
    procedure onClick(aView: AVView); override;
    function onOptionsItemSelected(Item: AVMenuItem): JBoolean; override;
  public
     lPartner: TDBGridViewLayout;
  end; 

implementation

uses Data;

procedure TFormEdit.onCreate(savedInstanceState: AOBundle);
var
  layout : AWLinearLayout;
  bt: TButton;
begin
  inherited onCreate(savedInstanceState);
  setTitle(JLString('Exit'));
  layout:= AWLinearLayout.create(Self);
  layout.setOrientation(AWLinearLayout.VERTICAL);

   getActionBar.setDisplayHomeAsUpEnabled(true);
   getActionBar.setIcon(R.drawable.exit);

     bt:= TButton.create(self);
     bt.Id := 100;
     bt.Text := JLString('Add item');
     bt.setOnClickListener(Self);
   layout.addView(bt);

   lPartner := TDBGridViewLayout.create(Self, dBase);
   with lPartner  do begin
      GridView.setNumColumns(1);  // ini file

      Adapter.CursorDataSet.TableName := 'sPartner';
      Adapter.CursorDataSet.SQLSelect := JLString('select PartnerID, Partner from sPartner ');

       //definisanje polja
      Adapter.CursorDataSet.FieldAll.ReadOnly[0] := True;
      Adapter.CursorDataSet.FieldAll.ReadOnly[1] := false;
      Adapter.CursorDataSet.FieldAll.DataType[1] := ftString;



       Adapter.CursorDataSet.SQLUpdate := JLString('update sPartner set Partner = :Partner  where PartnerID = :PartnerID ');
       Adapter.CursorDataSet.SQLDelete := JLString('delete from sPartner where PartnerID = :PartnerID ');
       ReadOnlyEdit:= false;
       ReadOnlyDelete:= false;
       Adapter.CursorDataSet.SQLInsert := JLString('insert into sPartner (Partner ) values ( :Partner  ) ');

     //  OnAfterEventDialog := @onAfterDialog;
       Adapter.HTMLTemplate := '<b> <#PartnerID>  <font color=''red''><#Partner></font> </b> ';
       Adapter.Gravity := AVGravity.CENTER;
       Adapter.TextScale := 1.1;
   end;
   layout.addView(lPartner);


  setContentView(layout);
end;

procedure TFormEdit.onClick(aView: AVView);
var
   aField : TFieldDef;
begin
    case aView.id of
      100: begin
         aField := lPartner.Adapter.CursorDataSet.FieldAll;
       //  aField.Value[0].AsString := string('1');
         aField.Value[1].AsString := JLString('Test partner');
         lPartner.InsertDialog(aField);
        //or  lPartner.Adapter.CursorDataSet.Insert(aField);
         lPartner.Refresh;
      end;

    end;
end;

function TFormEdit.onOptionsItemSelected(Item: AVMenuItem): JBoolean;
begin
  Result := true;
   case item.getItemID of
     AR.Innerid.home: onBackPressed;  // exit na prethodni meni
   else  Result := false;
  end;
end;

end.
