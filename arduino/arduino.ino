#include <DHT.h>
// #include <DHT_U.h>

int MOTORE = 13;
int UM_SUOLO = A5;
int TEMP = 8;
#define DHTTYPE DHT11
DHT dht(TEMP, DHTTYPE);

void setup() {
    Serial.begin(9600);
    dht.begin();
    pinMode(MOTORE, OUTPUT);
    pinMode(UM_SUOLO, INPUT);
    pinMode(TEMP, INPUT);

    digitalWrite(MOTORE, HIGH);
    delay(500);
}

void loop() {
    int t = dht.readTemperature();
    int h = dht.readHumidity();
    float umidita_suolo = analogRead(UM_SUOLO);
    Serial.print("TEMPERATURA:");
    Serial.print(t);
    Serial.print(" HUMIDITY:");
    Serial.print(h);
    Serial.print(" MOISTURELEVEL:");
    Serial.println(umidita_suolo);
    if (umidita_suolo > 750) {
        digitalWrite(MOTORE, LOW);
    } else {
        digitalWrite(MOTORE, HIGH);
    }
    Serial.println();
    delay(1000);
}