#include <DHT.h>
// #include <DHT_U.h>

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

    if(umidita_suolo<560){
    digitalWrite(MOTORE, LOW);
    } else{
    digitalWrite(MOTORE, HIGH);
    delay(5000);
    }

    if(liv_acqua<15){
      digitalWrite(LED, HIGH); 

    } else {
      digitalWrite(LED, LOW);
    }

    Serial.println();
    delay(1000);
}

int readSensor() {
  digitalWrite(SENSOR_POWER, HIGH);  // Turn the sensor ON
  delay(10);                        // wait 10 milliseconds
  val = analogRead(WATER_LVL);      // Read the analog value form sensor
  digitalWrite(SENSOR_POWER, LOW);   // Turn the sensor OFF
  return val;                       // send current reading
}
