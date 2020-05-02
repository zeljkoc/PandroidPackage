{******************************************}
{*          Zeljko Cvijanovic             *}
{*       E-mail: cvzeljko@gmail.com       *}
{*       Copyright (R)  2013 - 2019       *}
{******************************************}
unit Utils;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.units.pascal}

interface

//uses androidr15;
{$include ../AndroidVersion.inc}
;

function checkExistsFile(aFileName: JLString): jboolean;
function DeleteFile(aFileName: JLString): jboolean;
procedure DeleteFolders(aPath: JLString);
//CopyFile('/data/zeljus.com.popis/popis01.csv', 'popis01.csv' {fNameTo})
function CopyFileExternal(currentDBPath: JLString; backupDBFile: JLString): JLString;
function CopyFile(currentDBPath: JLString; backupDBFile: JLString): JLString;
//Number Utisl
function RealToFormatString(aFormat: JLString; aNumber: Real): JLString;

//Date Utils
function FBDateTimeToString: JLString;  //Firebird Date time
function FBDateToString: JLString;  //Firebird Date
function FBTimeToString: JLString;  //Firebird Time
function DateStringToString(aDate, InFormat, OutFormat: String): JLString;
function DateTimeFormatToString(aFormat: String): JLString;


//Strings
function LeftStr(Str: JLString; ch: jChar; Size: Integer): JLString;
function RightStr(Str: JLString; ch: jChar; Size: Integer): JLString;
function CharReplace(Str: JLString; ch: Char; ToCh: Char): JLString;
function HtmlText(aString: String): ATSpanned;

function AsciToHex(Str: JLString): JLString;
function HexToAsci(Str: JLString): JLString;

//Test barcode
function EAN13CheckSum(aValue: JLString): integer;


//
function StrToIntDef(const s: String; Default: integer): integer;
//
function QuotedStr(aStr: String) : String;
function Quoted(aStr: String): String;

function drawText(text: JLString; textWidth: jint; textSize: jint): AGBitmap;


function getStringFromBitmap(bitmapPicture: AGBitmap): JLString;
function getBitmapFromString(stringPicture: JLString): AGBitmap;

implementation


function checkExistsFile(aFileName: JLString): jboolean;
begin
  Result := JIFile.Create(aFileName).exists;
end;


function DeleteFile(aFileName: JLString): jboolean;
var
  fn: JIFile;
begin
   Result := false;
   try
     fn := JIFile.create(aFileName);
     if  (fn.exists) then Result := fn.delete();
     Result := true;
   except
   end;
   fn := nil;
end;

procedure DeleteFolders(aPath: JLString);
var
  fn: JIFile;
  f: Arr1JIFile;
  i: integer;
begin
  fn:= JIFile.create(aPath);
  if fn.isDirectory then begin
     f := fn.listFiles;
     for i:=0 to length(f) - 1 do
       f[i].delete;
  end;
end;

function CopyFileExternal(currentDBPath: JLString; backupDBFile: JLString): JLString;
var
  data: JIFile;
  currentDB: JIFile;
  backupDB: JIFile;
  src: JNCFileChannel;
  dst: JNCFileChannel;
begin
  data := AOEnvironment.getDataDirectory;

  currentDB := JIFile.create(data, currentDBPath);
  backupDB := JIFile.create(AOEnvironment.getExternalStoragePublicDirectory(
                     AOEnvironment.fDIRECTORY_DOWNLOADS), backupDBFile);
  //odredi putanju za slanje
  Result := backupDB.toString;

  if (currentDB.exists) then begin

   src := JIFileInputStream.Create(currentDB).getChannel;
   dst:=  JIFileOutputStream.Create(backupDB).getChannel;

   dst.transferFrom(JNCReadableByteChannel(src), 0, src.size);
   src.close;
   dst.close;
  end;

end;

function CopyFile(currentDBPath: JLString; backupDBFile: JLString): JLString;
var
 // sd: JIFile;
  data: JIFile;
  currentDB: JIFile;
  backupDB: JIFile;
  src: JNCFileChannel;
  dst: JNCFileChannel;
begin
 // sd := AOEnvironment.getDownloadCacheDirectory();
  data := AOEnvironment.getRootDirectory();

  currentDB := JIFile.create(data, currentDBPath);
  backupDB := JIFile.create(AOEnvironment.getExternalStoragePublicDirectory(
                     AOEnvironment.fDIRECTORY_DOWNLOADS), backupDBFile);

  //odredi putanju za slanje
  Result :=  backupDB.toString;

  if (currentDB.exists) then begin

   src := JIFileInputStream.Create(currentDB).getChannel;
   dst:=  JIFileOutputStream.Create(backupDB).getChannel;

   dst.transferFrom(JNCReadableByteChannel(src), 0, src.size);
   src.close;
   dst.close;
  end;

end;

function RealToFormatString(aFormat: JLString; aNumber: Real): JLString;
begin
  Result := JTDecimalFormat.create(aFormat).format(aNumber); // -1235
  {a:= JTDecimalFormat.create('00').format(0); // 0
  a:= JTDecimalFormat.create('##00').format(0); // 00
  a:= JTDecimalFormat.create('.00').format(-.4567); // -.46
  a:= JTDecimalFormat.create('0.00').format(-.34567); // -0.346
  a:= JTDecimalFormat.create('#.######').format(-012.34567); // -12.34567
  a:= JTDecimalFormat.create('#.000000').format(-1234.567); // -1234.567000
  a:= JTDecimalFormat.create('#,###,###').format(-01234567.890); // -1 234 568
  a:= JTDecimalFormat.create('text'#').format(+1234.567); // text1235
  a:= JTDecimalFormat.create('00.00E0').format(-012345.67); // -12.35E2}
end;

function FBDateTimeToString: JLString;
begin
   //'2015-12-07 16:46:40'; - Firebird format
  Result := JTSimpleDateFormat.create(JLString('yyyy-dd-MM HH:mm:ss')).format(JUDate.Create);
//    Result := JTSimpleDateFormat.create(JLString('dd-MM-yyyy HH:mm:ss')).format(JUDate.Create);
end;

function FBDateToString: JLString;
begin
  //'2015-12-07 16:46:40'; - Firebird format
  Result := JTSimpleDateFormat.create(JLString('yyyy-dd-MM')).format(JUDate.Create);
end;

function FBTimeToString: JLString;
begin
  //'2015-12-07 16:46:40'; - Firebird format
  Result := JTSimpleDateFormat.create(JLString('HH:mm:ss')).format(JUDate.Create);
end;

function DateStringToString(aDate, InFormat, OutFormat: String): JLString;
begin
 Result := JTSimpleDateFormat.create(JLString(OutFormat)).format(
    JTSimpleDateFormat.create(JLString(InFormat)).parse(JLString(aDate)));
end;

function DateTimeFormatToString(aFormat: String): JLString;
begin
    Result := JTSimpleDateFormat.create(JLString(aFormat)).format(JUDate.Create);
end;

function LeftStr(Str: JLString; ch: jChar; Size: Integer): JLString;
var
   msg: JLStringBuilder;
   i: integer;
 begin
    msg:= JLStringBuilder.Create(Str);
    for i:=0 to (Size - msg.length - 1) do
      msg.insert(0, ch);
    msg.SetLength(Size);
    Result := msg.toString;
end;

function RightStr(Str: JLString; ch: jChar; Size: Integer): JLString;
var
  msg: JLStringBuilder;
  i: integer;
begin
   msg:= JLStringBuilder.Create(Str);
   for i:=0 to (Size - msg.length - 1)  do
      msg.append(ch);
   msg.SetLength(Size);
   Result := msg.toString;

end;

function CharReplace(Str: JLString; ch: Char; ToCh: Char): JLString;
var
  msg: JLStringBuilder;
  i: integer;
begin
   msg:= JLStringBuilder.Create(Str);
   for i:= 0 to msg.length - 1 do
     if msg.charAt(i) = ch then
      msg.setCharAt(i, toCh);
   Result := msg.toString;
end;

function HtmlText(aString: String): ATSpanned;
begin
 Result := ATHtml.fromHtml(aString);
end;

function StrToIntDef(const s: String; Default: integer): integer;
var
  E: integer;
begin
   val(s, Result, E);
   if E <> 0 then Result := Default;
end;

function QuotedStr(aStr: String): String;
begin
  Result :=  '''' + aStr + '''';
end;

function Quoted(aStr: String): String;
begin
  Result := '"'+ aStr + '"';
end;

function drawText(text: JLString; textWidth: jint; textSize: jint): AGBitmap;
var
  textPaint: ATTextPaint;
  mTextLayout: ATStaticLayout;
  b: AGBitmap;
  c: AGCanvas;
  paint: AGPaint;
begin
   // Get text dimensions
   textPaint := ATTextPaint.create(AGPaint.ANTI_ALIAS_FLAG and AGPaint.LINEAR_TEXT_FLAG);
   textPaint.setStyle(AGPaint.InnerStyle.fFILL);
   textPaint.setColor(AGColor.BLACK);
   textPaint.setTextSize(textSize);
   mTextLayout := ATStaticLayout.create(text, textPaint,
    				textWidth, ATLayout.InnerAlignment.fALIGN_NORMAL, 1.0, 0.0, false);

   // Create bitmap and canvas to draw to
    b := AGBitmap.createBitmap(textWidth, mTextLayout.getHeight, AGBitmap.InnerConfig.fRGB_565);
    c := AGCanvas.create(b);

    // Draw background
    paint := AGPaint.create(AGPaint.ANTI_ALIAS_FLAG and AGPaint.LINEAR_TEXT_FLAG);
    paint.setStyle(AGPaint.InnerStyle.fFILL);
    paint.setColor(AGColor.WHITE);
    c.drawPaint(paint);


    // Draw text
    c.save;
    c.translate(0, 0);
    mTextLayout.draw(c);
    c.restore;

    Result := b;
end;

function getStringFromBitmap(bitmapPicture: AGBitmap): JLString;
const
   COMPRESSION_QUALITY: jint = 100;
var
  byteArrayBitmapStream: JIByteArrayOutputStream;
  b: Array of jbyte;
begin
    byteArrayBitmapStream := JIByteArrayOutputStream.create;
    bitmapPicture.compress(AGBitmap.InnerCompressFormat.fPNG, COMPRESSION_QUALITY, byteArrayBitmapStream);
    b := byteArrayBitmapStream.toByteArray;
    Result := AUBase64.encodeToString(b, AUBase64.DEFAULT);
end;

function getBitmapFromString(stringPicture: JLString): AGBitmap;
var
  decodedString: array of jbyte;
begin
  decodedString := AUBase64.decode(stringPicture, AUBase64.DEFAULT);
  Result := AGBitmapFactory.decodeByteArray(decodedString, 0, length(decodedString));
end;

function AsciToHex(Str: JLString): JLString;
var
   ch: array of jchar;
   builder: JLStringBuilder;
   i: integer;
begin
  Result := Str;
  if Str.length = 0 then Exit;
  setLength(ch, Str.length);
  ch := Str.toCharArray;

  builder := JLStringBuilder.Create;
  for i:=0 to Str.length - 1 do
    builder.append(JLInteger.toHexString(ord(ch[i])).toUpperCase);

  Result := builder.toString; // Str;
end;

function HexToAsci(Str: JLString): JLString;
var
  builder: JLStringBuilder;
  i: integer;
begin
  Result := Str;
  if Str.length = 0 then Exit;
  builder:= JLStringBuilder.Create;

  i:= 0;
  repeat
     builder.append(char(JLInteger.parseInt(Str.substring(i, (i + 2)), 16)));
    inc(i, 2);
  until i > Str.length - 1;

  Result := builder.toString;
end;

function EAN13CheckSum(aValue: JLString): integer;
var
  i, Digit: integer;
  Odd: boolean;
  Sum: integer;
  bValue: JLString;
begin
  Result := -1;

  if (aValue.length > 13) then Exit;
 if aValue.length < 13 then begin
  repeat
     aValue := JLString(string('0')).concat(aValue.toString);
  until aValue.length = 12;
  aValue := JLString(string('2')).concat(aValue.toString);
 end;


  bValue := aValue.CopyValueOf(aValue.toCharArray, 0, aValue.length - 1);

  Sum:=0; Odd := true;
  for i:= bValue.length downto 1 do begin
      Digit := StrToIntDef(string(bValue.charAt(i-1)), 0);
      if odd then
         sum := sum + digit * 3
      else
         Sum := Sum + Digit;
      Odd := not Odd;
  end;
  Result := Sum mod 10;
  if Result <> 0 then Result := 10 - Result;

end;





end.

