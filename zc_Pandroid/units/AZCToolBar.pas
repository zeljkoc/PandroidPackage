{******************************************}
{*          Zeljko Cvijanovic             *}
{*       E-mail: cvzeljko@gmail.com       *}
{*       Copyright (R)  2013 - 2019       *}
{******************************************}
unit AZCToolBar;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.units}

interface

//uses androidr15;
{$include /usr/local/pandroid/units/AndroidVersion.inc}
;

type

  { AZCArrayAddapter }

  TZCArrayAddapter = class(AWArrayAdapter)
    FView: JUArrayList;
  public
    constructor create(aContext: ACContext; para2: jint; aView: JUArrayList); overload; virtual;
    function getView(para1: jint; aView: AVView; aViewGroup: AVViewGroup): AVView;  override;
  end;

  { TZCToolBar }

  TZCToolBar = class(AWLinearLayout)
    FAdapter: TZCArrayAddapter;
    FItems: JUArrayList;
    FGridView: AWGridView;
    FHeight: jint;
  public
    function GetNumColumnsGridView: jint;
    function getStretchModeGridView: jint;
    procedure setColumnWidthGridView(AValue: jint);
    procedure setGravityGridView(AValue: jint);
    procedure setHorizontalSpacingGridView(AValue: jint);
    procedure SetNumColumnsGridView(AValue: jint);
    procedure setStretchModeGridView(AValue: jint);
    procedure setVerticalSpacingGridView(AValue: jint);
  public
    constructor create(para1: ACContext); overload;
    function add(para1: JLObject): jboolean; overload; virtual;
    procedure Clear;
  public
    property Items: JUArrayList read FItems;
    property Height : jint read FHeight write FHeight;
  end;

implementation

{ TZCToolBar }
uses StdCtrls;


function TZCToolBar.GetNumColumnsGridView: jint;
begin
  Result := FGridView.getNumColumns;
end;

function TZCToolBar.getStretchModeGridView: jint;
begin
  Result := FGridView.getStretchMode;
end;

procedure TZCToolBar.setColumnWidthGridView(AValue: jint);
begin
  FGridView.setColumnWidth(AValue);
end;

procedure TZCToolBar.setGravityGridView(AValue: jint);
begin
  FGridView.setGravity(AValue);
end;

procedure TZCToolBar.setHorizontalSpacingGridView(AValue: jint);
begin
  FGridView.setHorizontalSpacing(AValue);
end;

procedure TZCToolBar.SetNumColumnsGridView(AValue: jint);
begin
  FGridView.setNumColumns(AValue);
end;

procedure TZCToolBar.setStretchModeGridView(AValue: jint);
begin
  FGridView.setStretchMode(AValue);
end;

procedure TZCToolBar.setVerticalSpacingGridView(AValue: jint);
begin
  FGridView.setVerticalSpacing(AValue);
end;

constructor TZCToolBar.create(para1: ACContext);
begin
  inherited create(para1);
  setPadding(8, 4, 8, 8);
  FItems:= JUArrayList.Create;
  FHeight := 65 ;

  FGridView:= AWGridView.create(para1);
  with FGridView do begin
    setVerticalSpacingGridView(4);
    setHorizontalSpacingGridView(2);
    setNumColumnsGridView(AWGridView.AUTO_FIT);
    SetNumColumnsGridView(3);
  end;

  FAdapter := TZCArrayAddapter.create(para1, AR.innerLayout.simple_list_item_1, FItems);

  FGridView.setAdapter(FAdapter);
  inherited addView(FGridView)
end;

function TZCToolBar.add(para1: JLObject): jboolean;
begin
    if (para1 is AVView) then begin
      with (para1 as AVView) do begin
        setLayoutParams(AVViewGroup_LayoutParams(AWLinearLayout.InnerLayoutParams.create(AWLinearLayout.InnerLayoutParams.MATCH_PARENT, FHeight)));
      end;
    end;
  FItems.add(para1);
end;

procedure TZCToolBar.Clear;
begin
  FItems.clear;
  FAdapter.clear;
end;


{ AZCArrayAddapter }

constructor TZCArrayAddapter.create(aContext: ACContext; para2: jint; aView: JUArrayList);
begin
 FView := aView;
 inherited create(aContext,  para2, FView);
end;

function TZCArrayAddapter.getView(para1: jint; aView: AVView; aViewGroup: AVViewGroup): AVView;
begin
  Result:=  AVView(FView.get(para1));
end;

end.

