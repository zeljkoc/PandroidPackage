unit TestArduino;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.testarduino}

interface
{$include AndroidVersion.inc} 
, Rjava, AActivity, AArduinoBridge, StdCtrls;


type
  MainActivity = class(Activity) 
  public 
    procedure onCreate(savedInstanceState: AOBundle); override; 
    procedure onClick(aView: AVView); override;
  public
    bridge: TZCPArduinoBridge;
    bt: TButton;
    tv: TTextView;
  end; 

implementation

procedure MainActivity.onCreate(savedInstanceState: AOBundle);
var
  layout : AWLinearLayout;
begin
  inherited onCreate(savedInstanceState);
  layout:= AWLinearLayout.Create(Self);
  layout.setOrientation(AWLinearLayout.VERTICAL);

    tv:= TTextView.Create(Self);
    tv.setTextSize(20);
   layout.addView(tv);

    bt:= TButton.Create(Self);
    bt.setOnClickListener(Self);
    bt.Id := 1;
    bt.text := JLString('Set');
   layout.addView(bt);

    bt:= TButton.Create(Self);
    bt.setOnClickListener(Self);
    bt.Id := 2;
    bt.text := JLString('On');
   layout.addView(bt);

    bt:= TButton.Create(Self);
    bt.setOnClickListener(Self);
    bt.Id := 3;
    bt.text := JLString('OFF');
   layout.addView(bt);

    bt:= TButton.Create(Self);
    bt.setOnClickListener(Self);
    bt.Id := 4;
    bt.text := JLString('Read');
   layout.addView(bt);

   bridge:= TZCPArduinoBridge.create;
   bridge.Init;
   bridge.Connect(JLString('192.168.1.212'), 502, 100);


 setContentView(layout);
end;

procedure MainActivity.onClick(aView: AVView);
var
  s: array of jbyte;
begin
   case aView.id of
      1: begin  //set
           setLength(s, 3);
           s[0] := 0;
           s[1] := 2;
           s[2] := 1;
           bridge.Write(s);
         end;

        2: begin
           setLength(s, 3);
           s[0] := 1;
           s[1] := 2;
           s[2] := 0;
           bridge.Write(s);
         end;

        3: begin
           setLength(s, 3);
           s[0] := 1;
           s[1] := 2;
           s[2] := 1;
           bridge.Write(s);
         end;
      4: begin
           setLength(s, 2);
           s[0] := 2;
           s[1] := 2;
           s := bridge.Write(s);
           tv.text := JLString.Create(s);
         end;

   end;
end;

end.
