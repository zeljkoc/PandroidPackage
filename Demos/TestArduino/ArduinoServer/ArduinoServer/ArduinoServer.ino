#include <ESP8266WiFi.h>

 
const char* ssid = "AP";
const char* password = "password";
int ModbusTCP_port = 502;

byte ByteArray[260];


//////////////////////////////////////////////////////////////////////////
 
WiFiServer MBServer(ModbusTCP_port);
 
void setup() {

  Serial.begin(115200);
  delay(100);
  WiFi.begin(ssid, password);
  delay(100);
  Serial.println(".");
 
  while (WiFi.status() != WL_CONNECTED) { delay(500); Serial.print("."); }
 
  MBServer.begin();
  Serial.println("Connected ");
  Serial.print("ESP8266 Slave Modbus TCP/IP ");
  Serial.print(WiFi.localIP()); Serial.print(":"); Serial.println(String(ModbusTCP_port));
  Serial.println("Modbus TCP/IP Online");
}
 
 
void loop() {
  // Check if a client has connected // Modbus TCP/IP
  WiFiClient client = MBServer.available();
  if (!client) { return; }

 
  // Modbus TCP/IP
  while (client.connected()) {
    if(client.available()) {
      int i = 0;
      while(client.available()) {
        ByteArray[i] = client.read(); Serial.print(ByteArray[i]);  Serial.print(" "); //zc test receive
        i++;
      }
      
      client.flush();


     switch (ByteArray[0]) {
         case 0:
            pinMode(ByteArray[1], ByteArray[2]);  
            break;
         case 1: 
           digitalWrite(ByteArray[1], ByteArray[2]);
           break;  
         case 2: 
           client.print(digitalRead(ByteArray[1])); 
           break;                 
            
      }

      
      Serial.println();
 
    }

  }
}


//--------------------------------
