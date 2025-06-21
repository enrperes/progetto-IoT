#!/usr/bin/env python3

"""
Script Python per Raspberry Pi che legge i dati seriali inviati da Arduino UNO via USB
e li salva su InfluxDB per visualizzazione con Grafana.

Dipendenze:
    pip3 install pyserial influxdb-client

Configurazione InfluxDB:
    URL e token devono essere configurati sotto.
"""
import serial
import time
import re
from serial.tools import list_ports
from influxdb_client import InfluxDBClient, Point, WriteOptions

# --- CONFIGURAZIONE SERIAL ---
# Imposta manualmente la porta seriale se vuoi bypassare la ricerca automatica:
SERIAL_PORT = '/dev/ttyACM0'  # <--- Modifica qui con la porta corretta

# Se SERIAL_PORT è None lo script cercherà automaticamente Arduino via USB
# SERIAL_PORT = None
BAUDRATE = 9600
TIMEOUT = 2  # secondi


# --- CONFIGURAZIONE INFLUXDB ---
INFLUX_URL = "http://localhost:8086"
INFLUX_TOKEN = ""
INFLUX_ORG = ""
INFLUX_BUCKET = ""


def main():
    port = SERIAL_PORT
    if port is None:
        print("Porta Arduino non trovata. Verifica il collegamento USB.")
        return

    ser = serial.Serial(port, BAUDRATE, timeout=TIMEOUT)
    print(f"Connesso ad Arduino su {port} @ {BAUDRATE}bps")

    # Inizializza client InfluxDB
    client = InfluxDBClient(url=INFLUX_URL, token=INFLUX_TOKEN, org=INFLUX_ORG)
    write_api = client.write_api(write_options=WriteOptions(batch_size=1))
    time.sleep(3)
    line = ser.readline().decode()
    while True:
         line = ser.readline().decode()
         if "TEMPERATURA" in line and "UMID_ARIA" and "UMID_SUOLO":
            line = line.split(" ") 
            temp = int(line[0].split(":")[1])
            hum = int(line[1].split(":")[1])
            moisture = float(line[2].split(":")[1])
            liv_acqua = float(line[3].split(":")[1])
#            print(temp, hum, moisture, liv_acqua)

             # crea punto InfluxDB
            timestamp = time.time_ns()
            point = Point("sensori_arua").tag("device", "arduino1").field("temperature", temp).field("humidity", hum).field("moisture", moisture).field("livello acqua", liv_acqua).time(timestamp)

            write_api.write(bucket=INFLUX_BUCKET, org=INFLUX_ORG, record=point)
            print(f"Inviati: T={temp}°C H={hum}% M={moisture}")


if __name__ == "__main__":
    main()