{******************************************}
{*          Zeljko Cvijanovic             *}
{*       E-mail: cvzeljko@gmail.com       *}
{*       Copyright (R)  2013 - 2019       *}
{******************************************}
unit StdCtrls;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.units.pascal}

interface

//uses androidr15;
{$include ../AndroidVersion.inc}
;

type
    { TOnclickNotifyEvent }
    TOnClickEvent             = procedure (Value: AVView) of object;
    TOnCreateContextMenuEvent = procedure(aContexMenu: AVContextMenu; aView: AVView; AInfo: AVContextMenu.InnerContextMenuInfo) of object;
    TOnDragEvent              = function (aView: AVView; aDragEvent: AVDragEvent): jboolean of object;
    TonFocusChangeEvent       = procedure (aView: AVView; aBoolean: jboolean) of object;
    TonGenericMotionEvent     = function (aView: AVView; aMotionEvent: AVMotionEvent): jboolean of object;
    TonHoverEvent             = function (para1: AVView; para2: AVMotionEvent): jboolean of object;
    TonKeyEvent               = function (para1: AVView; para2: jint; para3: AVKeyEvent): jboolean of object;
    TonLongClickEvent         = function (para1: AVView): jboolean of object;
    TonSystemUiVisibilityChangeEvent = procedure (para1: jint) of object;
    TonTouchEvent             = function (para1: AVView; para2: AVMotionEvent): jboolean of object;

    TOnChangeTextEvent        = procedure(para1: JLObject) of object;
    TonCheckedChangedEvent    = procedure (para1: AWCompoundButton; para2: jboolean) of object;

    TonItemLongClickEvent     = function (para1: AWAdapterView; para2: AVView; para3: jint; para4: jlong): jboolean of object;
    TonItemClickEvent         = procedure (para1: AWAdapterView; para2: AVView; para3: jint; para4: jlong) of object;

  { TTextView }

  TTextView = class(AWTextView)
  public
    constructor create(para1: ACContext); overload;
    constructor create(para1: ACContext; para2: AUAttributeSet); overload;
    constructor create(para1: ACContext; para2: AUAttributeSet; para3: jint); overload;
  public
    property Text;
  end;

 { TLabelTextView }

 TLabelTextView = class(AWLinearLayout)
    fTextView: TTextView;
  public
    constructor create(para1: ACContext; aText: JLString); overload;
  public
    property TextView: TTextView read fTextView;
  end;

  { TEditText }

  TEditText = class(AWEditText, ATTextWatcher)
    FOnChangeText: TOnChangeTextEvent;
    procedure beforeTextChanged(charSequence: JLCharSequence; start: LongInt; lengthBefore: LongInt; lengthAfter: LongInt); overload;
    procedure onTextChanged(charSequence: JLCharSequence; start: LongInt; before: LongInt; count: LongInt); override;
    procedure afterTextChanged(editable: ATEditable); overload;
  public
    constructor create(para1: ACContext); virtual; overload;
    constructor create(para1: ACContext; para2: AUAttributeSet); overload;
    constructor create(para1: ACContext; para2: AUAttributeSet; para3: jint); overload;
  public
    property onChangeText: TOnChangeTextEvent read FOnChangeText write FOnChangeText;
    property Text;
  end;

  { TLabelEditText }

  TLabelEditText = class(AWLinearLayout)
    fTextView: TTextView;
    fEditText: TEditText;
  public
    constructor create(para1: ACContext; aText: JLString; aGravity: jint = AVGravity.LEFT); overload;
  public
    property EditText: TEditText read fEditText;
    property TextView: TTextView read fTextView;
  end;

  { TButton }

  TButton = class(AWButton,  AVView.InnerOnClickListener, AVView.InnerOnLongClickListener)
  private
    FEnabled: jboolean;
    FOnclick            : TOnclickEvent;
    FonLongClick        : TonLongClickEvent;
    FDrawable: AGDGradientDrawable;
  public
    procedure onClick(para1: AVView); overload;
    function onLongClick(para1: AVView): jboolean; overload;
  public
    constructor create(para1: ACContext); overload;
    constructor create(para1: ACContext; para2: AUAttributeSet); overload;
    constructor create(para1: ACContext; para2: AUAttributeSet; para3: jint); overload;
    procedure setEnabled(para1: jboolean); overload; override;
  public
    property onClickListener: TOnclickEvent read FOnClick write FOnClick;
    property OnLongClickListener: TonLongClickEvent read FonLongClick write FonLongClick;
    property Enabled: jboolean read FEnabled  write setEnabled;
  end;

  { TLabelEditTextButton }

  TLabelEditTextButton = class(AWLinearLayout)
    fTextView: TTextView;
    fEditText: TEditText;
    fButton: TButton;
  public
    constructor create(para1: ACContext; aText: JLString; aBText: JLString); overload;
  public
    property EditText: TEditText read fEditText;
    property Button: TButton read FButton;
  end;

  { TLabelButton }

  TLabelButton = class (AWLinearLayout)
    fTextView: TTextView;
    fButton: TButton;
  public
    constructor create(para1: ACContext; aText: JLString; aBText: JLString); overload;
  public
    property TextView: TTextView read fTextView;
    property Button: TButton read FButton;
  end;

  { TButtonLabel }

  TButtonLabel = class (AWLinearLayout)
    fButton: TButton;
    fTextView: TTextView;
  public
    constructor create(para1: ACContext; aBText: String; aText: String; aGravity: jint = AVGravity.LEFT); overload;
  public
    property TextView: TTextView read fTextView;
    property Button: TButton read FButton;
  end;

  { TButtonEditText }

  TButtonEditText = class (AWLinearLayout)
    fButton: TButton;
    fEditText: TEditText;
  public
    constructor create(para1: ACContext; aBText: String; aGravity: jint = AVGravity.LEFT); overload;
  public
    property Button: TButton read FButton;
    property EditText: TEditText read fEditText;
  end;

  { TImageButton }

  TImageButton = class(AWImageButton,  AVView.InnerOnClickListener, AVView.InnerOnLongClickListener)
  private
    FEnabled: jboolean;
    FOnclick            : TOnclickEvent;
    FonLongClick        : TonLongClickEvent;
    FDrawable: AGDGradientDrawable;
  public
    procedure onClick(para1: AVView); overload;
    function onLongClick(para1: AVView): jboolean; overload;
    procedure setEnabled(para1: jboolean); overload; override;
  public
    constructor create(para1: ACContext); overload;
    constructor create(para1: ACContext; para2: AUAttributeSet); overload;
    constructor create(para1: ACContext; para2: AUAttributeSet; para3: jint); overload;
  public
    property onClickListener: TOnclickEvent read FOnClick write FOnClick;
    property OnLongClickListener: TonLongClickEvent read FonLongClick write FonLongClick;
    property Enabled: jboolean read FEnabled write setEnabled;
  end;

  { TCheckBox }

  TCheckBox = class(AWCheckBox, AWCompoundButton.InnerOnCheckedChangeListener)
    FonCheckedChanged : TonCheckedChangedEvent;
  public
    procedure onCheckedChanged(para1: AWCompoundButton; para2: jboolean); overload;
  public
    constructor create(para1: ACContext); overload;
    constructor create(para1: ACContext; para2: AUAttributeSet); overload;
    constructor create(para1: ACContext; para2: AUAttributeSet; para3: jint); overload;
  public
    property onCheckedChangedListener: TonCheckedChangedEvent read FonCheckedChanged write FonCheckedChanged;
  end;

  { TRadioGroup }

  TRadioGroup = class(AWRadioGroup)
   property Orientation: jint read getOrientation write setOrientation; //0 horizontal;  1 vertical
   property ItemChecked: jint read getCheckedRadioButtonId;
  end;

  { TRadioButton }

  TRadioButton = class(AWRadioButton, AWCompoundButton.InnerOnCheckedChangeListener)
    FonCheckedChanged : TonCheckedChangedEvent;
  public
    procedure onCheckedChanged(para1: AWCompoundButton; para2: jboolean); overload;
  public
    constructor create(para1: ACContext); overload;
    constructor create(para1: ACContext; para2: AUAttributeSet); overload;
    constructor create(para1: ACContext; para2: AUAttributeSet; para3: jint); overload;
  public
    property onCheckedChangedListener: TonCheckedChangedEvent read FonCheckedChanged write FonCheckedChanged;
    property Checked: jboolean read isChecked write setChecked;
  end;

  { TGridViewLayout }

  TGridViewLayout = class(AWLinearLayout,
                      AWAdapterView.InnerOnItemLongClickListener,
                      AWAdapterView.InnerOnItemClickListener)
    FGridView: AWGridView;
    FItemLongClick: TonItemLongClickEvent;
    FItemClick: TonItemClickEvent;
    function onItemLongClick(para1: AWAdapterView; para2: AVView; para3: jint; para4: jlong): jboolean; overload; virtual;
    procedure onItemClick(para1: AWAdapterView; para2: AVView; para3: jint; para4: jlong); overload; virtual;
  public
    constructor create(para1: ACContext); virtual; overload;
  public
    property GridView: AWGridView read FGridView;
    property onItemLongClickListener: TonItemLongClickEvent read FItemLongClick write FItemLongClick;
    property onItemClickListener: TonItemClickEvent read FItemClick write FItemClick;
  end;


implementation

{ TButtonEditText }

constructor TButtonEditText.create(para1: ACContext; aBText: String; aGravity: jint);
var
  drawable: AGDGradientDrawable;
begin
  inherited Create(para1);
  setPadding(8, 8, 8, 8);
  //button

  fButton := TButton.create(getContext);
  with fButton do begin
    Text :=  ATHtml.fromHtml(aBText);
    TextSize := TextSize * 0.7;
  end; addView(fButton, AVViewGroup_LayoutParams.create(AVViewGroup_LayoutParams.WRAP_CONTENT, AVViewGroup_LayoutParams.FILL_PARENT));
  //end button

  drawable:= AGDGradientDrawable.create;
  with drawable do begin
    setColor(AGColor.parseColor('#d9f7c4'));
    setStroke(1,  AGColor.parseColor('#3c4934'));   //rub prekidaca
    setCornerRadius($05);
  end;

  fEditText := TEditText.create(getContext);
  with fEditText do begin
    TextSize := TextSize * 0.7;
    Gravity := aGravity or AVGravity.CENTER_VERTICAL;
    setBackgroundDrawable(drawable );
  end; addView(fEditText, AVViewGroup_LayoutParams.create(AVViewGroup_LayoutParams.MATCH_PARENT, AVViewGroup_LayoutParams.FILL_PARENT));
end;

{ TButtonLabel }

constructor TButtonLabel.create(para1: ACContext; aBText: String; aText: String; aGravity: jint = AVGravity.LEFT);
var
  drawable: AGDGradientDrawable;
begin
  inherited Create(para1);
  fButton := TButton.create(getContext);
  with fButton do begin
    Text :=  ATHtml.fromHtml(aBText);
    TextSize := TextSize * 0.7;
  end; addView(fButton, AVViewGroup_LayoutParams.create(AVViewGroup_LayoutParams.WRAP_CONTENT, AVViewGroup_LayoutParams.FILL_PARENT));
  //end button

  drawable:= AGDGradientDrawable.create;
  with drawable do begin
    setColor(AGColor.parseColor('#FFEBEE'));
    setStroke(1,  AGColor.parseColor('#3c4934'));   //rub prekidaca
    setCornerRadius($05);
  end;

  fTextView := TTextView.create(getContext);
  with fTextView do begin
    Text := JLString(aText);
    TextSize := TextSize * 0.7;
    setPadding(10, 0, 10, 0);
    Gravity := aGravity or AVGravity.CENTER_VERTICAL;
    setBackgroundDrawable(drawable );
  end; addView(fTextView, AVViewGroup_LayoutParams.create(AVViewGroup_LayoutParams.MATCH_PARENT, AVViewGroup_LayoutParams.FILL_PARENT));
end;

{ TLabelButton }

constructor TLabelButton.create(para1: ACContext; aText: JLString;
  aBText: JLString);
begin
  inherited Create(para1);
  setLayoutParams(AVViewGroup_LayoutParams(AWRelativeLayout.InnerLayoutParams.create(AWRelativeLayout.InnerLayoutParams.MATCH_PARENT, AWRelativeLayout.InnerLayoutParams.WRAP_CONTENT)));
  setGravity(AVGravity.TOP);

    fTextView := TTextView.create(getContext);
    fTextView.Text := aText;
    fTextView.setTypeface(nil, AGTypeface.BOLD_ITALIC);
  addView(fTextView);
    fButton := TButton.create(getContext);
    fButton.Text := aBText;
  addView(fButton);
end;

{ TLabelEditTextButton }

constructor TLabelEditTextButton.create(para1: ACContext; aText: JLString; aBText: JLString);
var
  drawable: AGDGradientDrawable;
begin
  inherited Create(para1);
  setLayoutParams(AVViewGroup_LayoutParams(AWRelativeLayout.InnerLayoutParams.create(AWRelativeLayout.InnerLayoutParams.MATCH_PARENT, AWRelativeLayout.InnerLayoutParams.WRAP_CONTENT)));
  setGravity(AVGravity.TOP);

    fTextView := TTextView.create(getContext);
    fTextView.Text := ATHtml.fromHtml(aText.toString);
    fTextView.setTypeface(nil, AGTypeface.BOLD_ITALIC);
  addView(fTextView);
    fEditText := TEditText.create(getContext);
  addView(fEditText);
   //button
    drawable:= AGDGradientDrawable.create;
    with drawable do begin
      setColor(AGColor.parseColor('#d9f7c4'));
      setStroke(1,  AGColor.parseColor('#00897B'));   //rub prekidaca
      setCornerRadius($1F);
    end;

    fButton := TButton.create(getContext);
    fButton.setBackgroundDrawable(drawable );
    fButton.Text := ATHtml.fromHtml(aBText.toString);
  addView(fButton);
end;

{ TLabelTextView }

constructor TLabelTextView.create(para1: ACContext; aText: JLString);
begin
  inherited Create(para1);
  setLayoutParams(AVViewGroup_LayoutParams(AWRelativeLayout.InnerLayoutParams.create(AWRelativeLayout.InnerLayoutParams.MATCH_PARENT, AWRelativeLayout.InnerLayoutParams.WRAP_CONTENT)));
  setGravity(AVGravity.TOP);

    fTextView := TTextView.create(getContext);
    fTextView.Text := aText;
    fTextView.setTypeface(nil, AGTypeface.BOLD_ITALIC);
  addView(fTextView);
    fTextView := TTextView.create(getContext);
  addView(fTextView);
end;

{ TLabelEditText }

constructor TLabelEditText.create(para1: ACContext; aText: JLString; aGravity: jint);
var
  drawable: AGDGradientDrawable;
begin
  inherited Create(para1);
  setPadding(8, 8, 8, 8);

    fTextView := TTextView.create(getContext);
    fTextView.Text :=  ATHtml.fromHtml(aText.toString);
    fTextView.Gravity := AVGravity.CENTER_VERTICAL;
  addView(fTextView, AVViewGroup_LayoutParams.create(AVViewGroup_LayoutParams.WRAP_CONTENT, AVViewGroup_LayoutParams.FILL_PARENT));

  //button
  drawable:= AGDGradientDrawable.create;
  with drawable do begin
    setColor(AGColor.parseColor('#d9f7c4'));
    setStroke(1,  AGColor.parseColor('#00897B'));   //rub prekidaca
    setCornerRadius($10);
  end;

    fEditText := TEditText.create(getContext);
    fEditText.Gravity := aGravity or AVGravity.CENTER_VERTICAL;
    fEditText.setBackgroundDrawable(drawable);
  addView(fEditText,   AVViewGroup_LayoutParams.create(AVViewGroup_LayoutParams.MATCH_PARENT, AVViewGroup_LayoutParams.FILL_PARENT));
end;

{ TImageButton }

procedure TImageButton.setEnabled(para1: jboolean);
begin
  inherited setEnabled(para1);
  FEnabled := para1;
  if para1 then FDrawable.setColor(AGColor.parseColor('#C8E6C9'))
   else FDrawable.setColor(AGColor.parseColor('#FFCDD2'));
end;


procedure TImageButton.onClick(para1: AVView);
begin
    if Assigned(FOnclick) then  FOnclick(para1);
end;

function TImageButton.onLongClick(para1: AVView): jboolean;
begin
  if Assigned(FonLongClick) then Result := FonLongClick(para1)
  else Result:= onLongClick(para1);
end;

constructor TImageButton.create(para1: ACContext);
begin
  inherited create(para1);
  self.setOnClickListener(Self);
  self.setOnLongClickListener(Self);

  FDrawable:= AGDGradientDrawable.create; //(AGDGradientDrawable.InnerOrientation.fTOP_BOTTOM, colors);
  with FDrawable do begin
    setColor(AGColor.parseColor('#C8E6C9'));
    setStroke(2,  AGColor.parseColor('#00897B'));   //rub prekidaca
    setCornerRadius($10);
  end;

  setBackgroundDrawable(FDrawable);
end;

constructor TImageButton.create(para1: ACContext; para2: AUAttributeSet);
begin
    inherited create(para1, para2);
    self.setOnClickListener(Self);
    self.setOnLongClickListener(Self);

  FDrawable:= AGDGradientDrawable.create; //(AGDGradientDrawable.InnerOrientation.fTOP_BOTTOM, colors);
  with FDrawable do begin
    setColor(AGColor.parseColor('#C8E6C9'));
    setStroke(2,  AGColor.parseColor('#00897B'));   //rub prekidaca
    setCornerRadius($10);
  end;

  setBackgroundDrawable(FDrawable);
end;

constructor TImageButton.create(para1: ACContext; para2: AUAttributeSet; para3: jint);
begin
    inherited create(para1, para2, para3);
    self.setOnClickListener(Self);
    self.setOnLongClickListener(Self);

  FDrawable:= AGDGradientDrawable.create; //(AGDGradientDrawable.InnerOrientation.fTOP_BOTTOM, colors);
  with FDrawable do begin
    setColor(AGColor.parseColor('#C8E6C9'));
    setStroke(2,  AGColor.parseColor('#00897B'));   //rub prekidaca
    setCornerRadius($10);
  end;

  setBackgroundDrawable(FDrawable);
end;

{ TGridViewLayout }

function TGridViewLayout.onItemLongClick(para1: AWAdapterView; para2: AVView; para3: jint; para4: jlong): jboolean;
begin
   if Assigned(FItemLongClick) then Result := FItemLongClick(para1, para2, para3, para4)
   else Result := onItemLongClick(para1, para2, para3, para4);
end;

procedure TGridViewLayout.onItemClick(para1: AWAdapterView; para2: AVView; para3: jint; para4: jlong);
begin
   if Assigned(FItemClick) then FItemClick(para1, para2, para3, para4)
   else onItemClick(para1, para2, para3, para4);
end;

constructor TGridViewLayout.create(para1: ACContext);
begin
  inherited Create(para1);
  FGridView:= AWGridView.create(para1);
  FGridView.setOnItemLongClickListener(self);
  FGridView.setOnItemClickListener(Self);
 addView(FGridView);
end;

{ TTextView }

constructor TTextView.create(para1: ACContext);
begin
  inherited Create(para1);
end;

constructor TTextView.create(para1: ACContext; para2: AUAttributeSet);
begin
  inherited Create(para1, para2);
end;

constructor TTextView.create(para1: ACContext; para2: AUAttributeSet; para3: jint);
begin
  inherited Create(para1, para2, para3);
end;


{ TRadioButton }

procedure TRadioButton.onCheckedChanged(para1: AWCompoundButton; para2: jboolean);
begin
    if Assigned(FonCheckedChanged) then FonCheckedChanged(para1, para2);
end;

constructor TRadioButton.create(para1: ACContext);
begin
  inherited Create(para1);
  self.setOnCheckedChangeListener(self);
end;

constructor TRadioButton.create(para1: ACContext; para2: AUAttributeSet);
begin
  inherited Create(para1, para2);
  self.setOnCheckedChangeListener(self);
end;

constructor TRadioButton.create(para1: ACContext; para2: AUAttributeSet; para3: jint);
begin
  inherited Create(para1, para2, para3);
  self.setOnCheckedChangeListener(self);
end;



{ TCheckBox }

procedure TCheckBox.onCheckedChanged(para1: AWCompoundButton; para2: jboolean);
begin
  if Assigned(FonCheckedChanged) then FonCheckedChanged(para1, para2);
end;

constructor TCheckBox.create(para1: ACContext);
begin
  inherited Create(para1);
  self.setOnCheckedChangeListener(self);
end;

constructor TCheckBox.create(para1: ACContext; para2: AUAttributeSet);
begin
  inherited Create(para1, para2);
  self.setOnCheckedChangeListener(self);
end;

constructor TCheckBox.create(para1: ACContext; para2: AUAttributeSet;
  para3: jint);
begin
  inherited Create(para1, para2, para3);
  self.setOnCheckedChangeListener(self);
end;

{ TEditText }

procedure TEditText.beforeTextChanged(charSequence: JLCharSequence;
  start: LongInt; lengthBefore: LongInt; lengthAfter: LongInt);
begin

end;

procedure TEditText.onTextChanged(charSequence: JLCharSequence; start: LongInt;
  before: LongInt; count: LongInt);
begin
  inherited onTextChanged(charSequence, start, before, count);
end;

procedure TEditText.afterTextChanged(editable: ATEditable);
begin
  if Assigned(FOnChangeText) then FOnChangeText(self);
end;


constructor TEditText.create(para1: ACContext);
begin
  inherited Create(para1);
  self.addTextChangedListener(Self);
end;

constructor TEditText.create(para1: ACContext; para2: AUAttributeSet);
begin
  inherited Create(para1, para2);
  self.addTextChangedListener(Self);
end;

constructor TEditText.create(para1: ACContext; para2: AUAttributeSet; para3: jint);
begin
    inherited Create(para1, para2, para3);
    self.addTextChangedListener(Self);
end;


{ TButton }

procedure TButton.onClick(para1: AVView);
begin
  if Assigned(FOnclick) then  FOnclick(para1);
end;

function TButton.onLongClick(para1: AVView): jboolean;
begin
  if Assigned(FonLongClick) then Result := FonLongClick(para1)
  else Result:= onLongClick(para1);
end;

constructor TButton.create(para1: ACContext);
begin
  inherited create(para1);
  self.setOnClickListener(Self);
  self.setOnLongClickListener(Self);

  FDrawable:= AGDGradientDrawable.create; //(AGDGradientDrawable.InnerOrientation.fTOP_BOTTOM, colors);
  with FDrawable do begin
    setColor(AGColor.parseColor('#C8E6C9'));
    setStroke(2,  AGColor.parseColor('#00897B'));   //rub prekidaca
    setCornerRadius($10);
  end;

  setBackgroundDrawable(FDrawable);
end;

constructor TButton.create(para1: ACContext; para2: AUAttributeSet);
begin
    inherited create(para1, para2);
    self.setOnClickListener(Self);
    self.setOnLongClickListener(Self);

  FDrawable:= AGDGradientDrawable.create; //(AGDGradientDrawable.InnerOrientation.fTOP_BOTTOM, colors);
  with FDrawable do begin
    setColor(AGColor.parseColor('#C8E6C9'));
    setStroke(2,  AGColor.parseColor('#00897B'));   //rub prekidaca
    setCornerRadius($10);
  end;

  setBackgroundDrawable(FDrawable);
end;

constructor TButton.create(para1: ACContext; para2: AUAttributeSet; para3: jint );
begin
    inherited create(para1, para2, para3);
    self.setOnClickListener(Self);
    self.setOnLongClickListener(Self);

  FDrawable:= AGDGradientDrawable.create; //(AGDGradientDrawable.InnerOrientation.fTOP_BOTTOM, colors);
  with FDrawable do begin
    setColor(AGColor.parseColor('#C8E6C9'));
    setStroke(2,  AGColor.parseColor('#00897B'));   //rub prekidaca
    setCornerRadius($10);
  end;

  setBackgroundDrawable(FDrawable);
end;

procedure TButton.setEnabled(para1: jboolean);
begin
  inherited setEnabled(para1);
  FEnabled := para1;
  if para1 then FDrawable.setColor(AGColor.parseColor('#C8E6C9'))
   else FDrawable.setColor(AGColor.parseColor('#FFCDD2'));
end;

end.

