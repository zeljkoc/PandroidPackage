unit Demo2DDraw;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.demo2ddraw}

interface
{$include AndroidVersion.inc} 
, Rjava, AActivity;

type
  MainActivity = class(Activity)
  public
    procedure onCreate(savedInstanceState: AOBundle); override;
  public

  end;

  { MyView }

  MyView = class(AVView)
    constructor create(para1: ACContext); overload;
    procedure onDraw(canvas: AGCanvas); overload; override;
  end;


implementation

{ MyView }

constructor MyView.create(para1: ACContext);
begin
  inherited create(para1);
end;

procedure MyView.onDraw(canvas: AGCanvas);
var
  x1, y1, radius: integer;
 paint: AGPaint;
begin
  inherited onDraw(canvas);
  x1 := getWidth;
  y1 := getHeight;
  radius := 100;

  paint:= AGPaint.create();
  paint.setStyle(AGPaint.InnerStyle.fFILL);
  paint.setColor(AGColor.WHITE);
  canvas.drawPaint(paint);
  // Use Color.parseColor to define HTML colors
  paint.setColor(AGColor.parseColor(JLString('#CD5C5C')));
  canvas.drawCircle(x1 / 2, y1 / 2, radius, paint);

end;


procedure MainActivity.onCreate(savedInstanceState: AOBundle);
begin
  inherited onCreate(savedInstanceState);
  setContentView(MyView.create(Self));
end;


end.
