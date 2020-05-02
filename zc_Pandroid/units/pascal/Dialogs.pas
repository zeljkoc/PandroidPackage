{******************************************}
{*          Zeljko Cvijanovic             *}
{*       E-mail: cvzeljko@gmail.com       *}
{*       Copyright (R)  2013 - 2019       *}
{******************************************}
unit Dialogs;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.units.pascal}

interface

//uses  androidr15,
{$include ../AndroidVersion.inc}
, DialogsView, StdCtrls;

type
  TOnClickEventDialog   = procedure (para1: ACDialogInterface; para2: jint) of object;

  TTypeButton = (btNeutral, btNegative, btPositive);    //-3 -2 -1

  { TDialog }

  TDialog = class(AAAlertDialog, ACDialogInterface.InnerOnClickListener)
  private
   fID: integer;
   FOnClick: TOnClickEventDialog;

   FOnAfterEventDialog: TOnClickEventDialog;
   FOnBeforeEventDialog: TOnClickEventDialog;
   procedure SetTitle(AValue: JLString);
  public
   constructor create(para1: ACContext); overload; virtual;
   procedure AddButton(aTypeButton: TTypeButton; aName: JLCharSequence);
   procedure onClick(para1: ACDialogInterface; para2: jint); overload; virtual;
  public
   property ID: integer read fID write fID;
   property OnClickListener: TOnClickEventDialog read FOnClick write FOnClick;
   property OnBeforeEventDialog: TOnClickEventDialog read FOnBeforeEventDialog write FOnBeforeEventDialog;
   property OnAfterEventDialog: TOnClickEventDialog read FOnAfterEventDialog write FOnAfterEventDialog;
   property Title: JLString write SetTitle;
  end;

  { TTimePickerDialog }

  TTimePickerDialog = class(TDialog)
  private
    FTimePicker: AWTimePicker;
    function GetHour: JLInteger;
    function GetMinute: JLInteger;
    procedure SetHour(AValue: JLInteger);
    procedure SetMinute(AValue: JLInteger);
  public
    constructor create(para1: ACContext); override;
  public
    property TimePicker: AWTimePicker read FTimePicker;
    property OnBeforeEventDialog;
    property OnAfterEventDialog;
    property Hour: JLinteger read GetHour write SetHour;
    property Minute: JLinteger read GetMinute write SetMinute;
  end;

  { TDatePickerDialog }

  TDatePickerDialog = class(TDialog, AWDatePicker.InnerOnDateChangedListener)
  private
    FDatePicker: AWDatePicker;
  public
    constructor create(para1: ACContext); override;
    procedure setDate(aDate: JLString);
    function getDate: JLString;
    procedure onDateChanged(para1: AWDatePicker; para2: jint; para3: jint; para4: jint); overload;
  public
    property DatePicker: AWDatePicker read FDatePicker;
    property OnBeforeEventDialog;
    property OnAfterEventDialog;
  end;

  { TUserNamePasswordDialog }

  TUserNamePasswordDialog = class(TDialog)
  private
    FUserPasswordView: TUserPasswordView;
  public
    constructor create(para1: ACContext); overload; override;
  public
    property UserNamePassword: TUserPasswordView read FUserPasswordView;
  end;


  { TEditFileDialog }

  TEditFileDialog = class(TDialog)
  private
    FFileName: JLString;
    FEditText: AWEditText;
    FHorizontalScropllView : AWHorizontalScrollView;
  strict protected
    procedure LoadFile;
    procedure WriteFile;
  public
    constructor create(para1: ACContext; aFileName: JLString); overload;
    procedure show; overload; override;
    procedure onClick(para1: ACDialogInterface; para2: jint); overload; override;

    property OnBeforeEventDialog;
    property OnAfterEventDialog;
  end;

  { TAboutDialog }

  TAboutDialog = class(TDialog)
  private
  public
    constructor create(para1: ACContext); overload; override;
  public

  end;

  { TTextEditDialog }

  TTextEditDialog = class(TDialog)
  private
    fEditText : TEditText;
    fInputType: jint;
    FOldText: JLString;
    FError: Boolean;
    procedure BeforeExitDialog(para1: ACDialogInterface; para2: jint);
    procedure ChangeText(para1: JLObject);
  protected
    function TestInputType: jboolean;
  public
    constructor create(para1: ACContext); overload;  override;
    procedure show(); overload; override;

    property InputType: jint read fInputType write fInputType;
    property EditText: TEditText read fEditText;
    property OnClickListener;
  end;

  { TYesNoDialog }

  TYesNoDialog = class(TDialog)
  private
    fTextView : AWTextView;
  public
    constructor create(para1: ACContext); overload;  override;

    property TextView: AWTextView read fTextView;
    property OnClickListener;
  end;


procedure ShowMessage(aContext: ACContext; aMessage: JLString; aTitle: JLString = ' ? ');

implementation

uses Utils;

procedure ShowMessage(aContext: ACContext; aMessage: JLString; aTitle: JLString = ' ? ');
var
  messageText: AWTextView;
begin
    with TDialog.create(aContext) do begin
      Title := aTitle;
      messageText:= AWTextView.create(aContext);
      messageText.setText(ATHtml.fromHtml('<br> <b> '+aMessage.toString+' </b>'));
      messageText.setGravity(AVGravity.CENTER);
      setView(messageText);
     // setMessage(aMessage.toString);
      AddButton(btPositive, ATHtml.fromHtml('<b> OK </b>'));
      Show;
    end;
end;

{ TYesNoDialog }

constructor TYesNoDialog.create(para1: ACContext);
begin
  inherited create(para1);
  inherited Title := ' ? ';
  fTextView := AWTextView.create(para1);
  setView(fTextView);
  inherited AddButton(btPositive,  ATHtml.fromHtml('<b> Yes </b>'));
  inherited AddButton(btNegative,  ATHtml.fromHtml('<b> No </b>'));
end;

{ TTextEditDialog }

procedure TTextEditDialog.ChangeText(para1: JLObject);
begin
  if (not TestInputType) then begin
   FError := true;
   fEditText.setError(JLString('Error'));
  end else begin
      FError := False;
      fEditText.setError(nil);
  end;
end;

function TTextEditDialog.TestInputType: jboolean;
begin
  Result := true;
  try
    if (fEditText.Text.length = 0) then Exit;
    case fInputType of
      ATInputType.TYPE_CLASS_NUMBER: JLInteger.parseInt(fEditText.Text.toString);    //decimal
      ATInputType.TYPE_CLASS_PHONE:   JLFloat.parseFloat(fEditText.Text.toString);   //float
    end;
   except
      Result := false;
   end;
end;

procedure TTextEditDialog.BeforeExitDialog(para1: ACDialogInterface; para2: jint);
begin
  if FError then fEditText.Text := FOldText;
end;

constructor TTextEditDialog.create(para1: ACContext);
begin
  inherited create(para1);
  fInputType := ATInputType.TYPE_NULL;
  fEditText := TEditText.create(para1);
  FEditText.onChangeText := @ChangeText;
  FError := false;

  setView(fEditText);
  inherited AddButton(btPositive, ATHtml.fromHtml('<b> OK </b>'));
  inherited AddButton(btNegative, ATHtml.fromHtml('<b> Cancel </b>'));

  inherited OnBeforeEventDialog := @BeforeExitDialog;
end;

procedure TTextEditDialog.show();
begin
  inherited show();
  fEditText.setFocusable(true);
  fEditText.setInputType(fInputType);
  fEditText.selectAll;
  FOldText := fEditText.Text.toString;
  getWindow.setSoftInputMode(AVWindowManager.InnerLayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
end;


{ TAboutDialog }

constructor TAboutDialog.create(para1: ACContext);
var
  FTextAbout: AWTextView;
  FHorizontalScropllView : AWHorizontalScrollView;
begin
  inherited create(para1);
  Title := ' Abaut ';

  fHorizontalScropllView := AWHorizontalScrollView.create(para1);

       FTextAbout:= AWTextView.create(para1);
       FTextAbout.setText(
       ATHtml.fromHtml(JLString('<h3> Ovaj program je komercijalni! <br> potrebna je licenca za koristenje. <br> <br>')
                       .concat(' Zabranjeno je: <br>  - presnimavanje, <br> - umnozavanje, <br> - reverzibilni inzinjering <br> bez saglasnosti autora. <br> <br>')
                       .concat(' Autor ne odgovara za <br> stetu nastalu koristenjem <br> ovog programa! <br> <br> ')
                       .concat( 'Autor ne odgovara za <br> tacnost unesenih <br> podataka!  </h3><br> <br>')
         ) );
    fHorizontalScropllView.addView(FTextAbout);

  setView(fHorizontalScropllView);

  setButton(ATHtml.fromHtml('<b> OK </b>'), Self);
  //inherited OnClickListener :=  @onClick;
end;

{ TEditFile }

procedure TEditFileDialog.LoadFile;
var
  reader: JIBufferedReader;
  line: JLString;
  Data: JLString;
begin
  line := string(''); Data := string('');

  if checkExistsFile(FFileName) then begin
       reader := JIBufferedReader.create((JIFileReader.create(FFileName)));
       while not (line = nil) do begin
         try
           line := reader.readLine;
           if line <> nil then
             Data := JLString(Data).concat(line).concat(string(#10));
         finally
         end;
       end;
   end;
   FEditText.setText(Data);
end;

procedure TEditFileDialog.WriteFile;
begin
    with JIFileWriter.create(fFileName) do begin
      append(FEditText.getText.toString);
      close;
    end;
end;

constructor TEditFileDialog.create(para1: ACContext; aFileName: JLString);
var
  drawable: AGDGradientDrawable;
begin
  fFileName := aFileName;
  inherited create(para1);
  Title := 'edit ini files!' ;
  fHorizontalScropllView := AWHorizontalScrollView.create(para1);
  drawable:= AGDGradientDrawable.create;
  with drawable do begin
    setColor(AGColor.parseColor('#d9f7c4'));
    setStroke(1,  AGColor.parseColor('#3c4934'));   //rub prekidaca
    setCornerRadius($05);
  end;

  fEditText:= AWEditText.create(para1);
  fEditText.setBackgroundDrawable(drawable);
  fHorizontalScropllView.addView(FEditText);
  setView(fHorizontalScropllView);

  setButton(ATHtml.fromHtml('<b> Save </b>'), Self);
  setButton2(ATHtml.fromHtml('<b> Cancel</b>'), Self);
 inherited OnClickListener :=  @onClick;
end;

procedure TEditFileDialog.show;
begin
  LoadFile;
  inherited show;
end;

procedure TEditFileDialog.onClick(para1: ACDialogInterface; para2: jint);
begin
 if Assigned(FOnBeforeEventDialog) then FOnBeforeEventDialog(para1, para2);
  case para2 of
    -1: WriteFile;
  end;
  if Assigned(FOnAfterEventDialog) then FOnAfterEventDialog(para1, para2);
end;


{ TDialog }

procedure TDialog.onClick(para1: ACDialogInterface; para2: jint);
begin
  if Assigned(FOnBeforeEventDialog) then FOnBeforeEventDialog(para1, para2);
  if Assigned(FOnClick) then FOnClick(para1, para2);
  if Assigned(FOnAfterEventDialog) then FOnAfterEventDialog(para1, para2);
end;

procedure TDialog.SetTitle(AValue: JLString);
begin
  SetTitle(ATHtml.fromHtml('<font color=''#4DB6AC''> <i> '+AValue.toString +' </font></i>'));
end;

constructor TDialog.create(para1: ACContext);

begin
  inherited Create(para1, AAAlertDialog.THEME_DEVICE_DEFAULT_LIGHT); // AR.Innerstyle.Theme_Holo_Light_Dialog); // AAAlertDialog.THEME_DEVICE_DEFAULT_LIGHT);

  // getWindow.setType(AVWindowManager.InnerLayoutParams.TYPE_SYSTEM_ALERT);
 // setTitle(AAActivity(para1).getPackageManager.getApplicationLabel(AAActivity(para1).getApplicationInfo));
 // setIcon(AAActivity(para1).getPackageManager.getApplicationIcon(AAActivity(para1).getApplicationInfo));
end;

procedure TDialog.AddButton(aTypeButton: TTypeButton; aName: JLCharSequence);
begin
  setButton(ord(aTypeButton) - (Ord(High(TTypeButton)) + 1), aName, Self);
end;


{ TTimePickerDialog }
function TTimePickerDialog.GetHour: JLInteger;
begin
 {$IFDEF AOBuild.InnerVERSION.fSDK_INT >= 23 }
    Result :=  TimePicker.getHour;
 {$ELSE}
    Result :=  TimePicker.getCurrentHour;
 {$ENDIF}
end;

function TTimePickerDialog.GetMinute: JLInteger;
begin
  {$IFDEF AOBuild.InnerVERSION.fSDK_INT >= 23 }
     Result :=  TimePicker.getMinute;
  {$ELSE}
     Result :=  TimePicker.getCurrentMinute;
  {$ENDIF}
end;

procedure TTimePickerDialog.SetHour(AValue: JLInteger);
begin
  {$IFDEF AOBuild.InnerVERSION.fSDK_INT >= 23 }
    TimePicker.setHour(AValue);
  {$ELSE}
     TimePicker.setCurrentHour(AValue) ;
  {$ENDIF}
end;

procedure TTimePickerDialog.SetMinute(AValue: JLInteger);
begin
  {$IFDEF AOBuild.InnerVERSION.fSDK_INT >= 23 }
    TimePicker.setMinute(AValue);
  {$ELSE}
     TimePicker.setCurrentMinute(AValue) ;
  {$ENDIF}
end;

constructor TTimePickerDialog.create(para1: ACContext);
begin
  inherited Create(para1);
  FTimePicker:= AWTimePicker.create(getContext);
  setButton(ATHtml.fromHtml('<b> Add </b>'), Self);
  setButton2(ATHtml.fromHtml('<b> Cancel</b>'), Self);
  Self.setView(FTimePicker);
end;


{ TDatePickerDialog }

procedure TDatePickerDialog.onDateChanged(para1: AWDatePicker; para2: jint; para3: jint; para4: jint);
begin

end;

constructor TDatePickerDialog.create(para1: ACContext);

begin
  inherited Create(para1);
  FDatePicker := AWDatePicker.create(getContext);

  setButton(ATHtml.fromHtml('<b> Add </b>'), Self);
  setButton2(ATHtml.fromHtml('<b> Cancel</b>'), Self);
  Self.setView(FDatePicker);

 setDate(JTSimpleDateFormat.create(JLString('dd.MM.yyyy')).format(JUDate.Create));
end;

procedure TDatePickerDialog.setDate(aDate: JLString);
var
 tok : JUStringTokenizer;
 aYear, aMonth, aDay: jint;
begin
 tok :=  JUStringTokenizer.create(aDate,  JLString(string('.')));
 aDay:=   JLInteger.parseInt(tok.nextToken);
 aMonth:= JLInteger.parseInt(tok.nextToken);
 aYear:=  JLInteger.parseInt(tok.nextToken);
 FDatePicker.init(aYear, aMonth - 1, aDay, self);
end;


function TDatePickerDialog.getDate: JLString;
begin
  Result := JLString(JLInteger.toString(FDatePicker.getDayOfMonth)).concat(string('.'))
             .concat(JLInteger.toString(FDatePicker.getMonth + 1)).concat(string('.'))
             .concat(JLInteger.toString(FDatePicker.getYear));
end;


{ TUserNamePasswordDialog }

constructor TUserNamePasswordDialog.create(para1: ACContext);
begin
  inherited Create(para1);
  FUserPasswordView := TUserPasswordView.create(getContext);
  FUserPasswordView.UserNameCaption := 'User name: ';
  FUserPasswordView.PasswordCaption := 'Password:  ';
  Self.setView(FUserPasswordView);
end;








end.

