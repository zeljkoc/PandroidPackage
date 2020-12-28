  TZCPArduinoBridge = class sealed external 'zeljus.com.Pascal' name 'ArduinoBridge' (JLObject)
  public
    constructor create(); overload;
    class procedure Init(); static; overload;
    class procedure Connect(Host: JLString; Port: jint; ReadTimeOut: jint); static; overload;
    class procedure Disconnect(); static; overload;
    class function isConnected(): JLBoolean; static; overload;
    class function Write(Command: Arr1jbyte): Arr1jbyte; static; overload;
    class function Write(var Command: array of jbyte): Arr1jbyte; static; overload;
    class procedure Free(); static; overload;
  end;

