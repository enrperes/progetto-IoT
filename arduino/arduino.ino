#include <DHT.h>

int MOTORE = 13;
int UM_SUOLO = A5;
int TEMP = 8;
int SENSOR_POWER = 7;
int WATER_LVL = A4;
int LED = 9; 

int val = 0; 

#define DHTTYPE DHT11
DHT dht(TEMP, DHTTYPE);

void setup() {
  Serial.begin(9600);
  dht.begin();
  pinMode(LED, OUTPUT); 
  pinMode(MOTORE, OUTPUT);
  pinMode(UM_SUOLO, INPUT);
  pinMode(TEMP, INPUT);
  pinMode(SENSOR_POWER, OUTPUT);
  digitalWrite(SENSOR_POWER, LOW);
  digitalWrite(MOTORE, HIGH);
  delay(500);
}

void loop(){
    int t = dht.readTemperature();
    int h = dht.readHumidity();
    float umidita_suolo = analogRead(UM_SUOLO);
    float liv_acqua = readSensor();
    Serial.print("TEMPERATURA:"); 
    Serial.print(t);
    Serial.print(" UMID_ARIA:"); 
    Serial.print  (h);
    Serial.print(" UMID_SUOLO:"); 
    Serial.print(umidita_suolo);
    Serial.print(" LIV_ACQUA:");
    Serial.println(liv_acqua);

    if(umidita_suolo>450){ // soglia umidità terreno 
    digitalWrite(MOTORE, LOW);
    delay(2000);
    digitalWrite(MOTORE, HIGH);
    } else{
    digitalWrite(MOTORE, HIGH);
    delay(2000);
    }

    if(liv_acqua<15){
      digitalWrite(LED, HIGH); 

    } else {
      digitalWrite(LED, LOW);
    }

    Serial.println();
    delay(600000); // 10 minuti
}

int readSensor() {
  digitalWrite(SENSOR_POWER, HIGH);  
  delay(10);                        
  val = analogRead(WATER_LVL);      
  digitalWrite(SENSOR_POWER, LOW);  
  return val;                       
}
