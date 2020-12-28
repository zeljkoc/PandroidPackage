  TZCPArduinoBridge = class sealed external 'zeljus.com.Pascal' name 'ArduinoBridge' (JLObject)
  public
    constructor create(); overload;
    class procedure Init(); static; overload;
    class procedure Connect(para1: JLString; para2: jint; para3: jint); static; overload;
    class procedure Disconnect(); static; overload;
    class function isConnected(): JLBoolean; static; overload;
    class function Write(para1: Arr1jbyte): Arr1jbyte; static; overload;
    class function Write(var para1: array of jbyte): Arr1jbyte; static; overload;
    class procedure Free(); static; overload;
  end;

