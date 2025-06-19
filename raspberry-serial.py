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
BAUDRATE = 9600
TIMEOUT = 2  # secondi

# --- CONFIGURAZIONE INFLUXDB ---
INFLUX_URL = "http://localhost:8086"
INFLUX_TOKEN = "<IL_TUO_TOKEN>"
INFLUX_ORG = "<LA_TUA_ORG>"
INFLUX_BUCKET = "<IL_TUO_BUCKET>"


def find_arduino_port():
    """Prova a trovare automaticamente la porta seriale di Arduino."""
    ports = list_ports.comports()
    for port in ports:
        if 'Arduino' in port.description or 'ttyUSB' in port.device:
            return port.device
    return None


def parse_line(line):
    """Estrae temperatura, umidità aria e umidità suolo da una linea di seriale."""
    t = h = moisture = None
    try:
        # Esempio linea: "TEMPERATURE:25, HUMIDITY:60"
        # e poi: "MOISTURELEVEL:512"
        if 'TEMPERATURE:' in line and 'HUMIDITY:' in line:
            m = re.search(r"TEMPERATURE:(?P<temp>\d+), HUMIDITY:(?P<hum>\d+)", line)
            if m:
                t = int(m.group('temp'))
                h = int(m.group('hum'))
        elif 'MOISTURELEVEL:' in line:
            m2 = re.search(r"MOISTURELEVEL:(?P<moist>\d+\.?\d*)", line)
            if m2:
                moisture = float(m2.group('moist'))
    except Exception as e:
        print(f"Errore parsing linea: {e}")
    return t, h, moisture


def main():
    port = find_arduino_port()
    if port is None:
        print("Porta Arduino non trovata. Verifica il collegamento USB.")
        return

    ser = serial.Serial(port, BAUDRATE, timeout=TIMEOUT)
    print(f"Connesso ad Arduino su {port} @ {BAUDRATE}bps")

    # Inizializza client InfluxDB
    client = InfluxDBClient(url=INFLUX_URL, token=INFLUX_TOKEN, org=INFLUX_ORG)
    write_api = client.write_api(write_options=WriteOptions(batch_size=1))

    try:
        while True:
            line = ser.readline().decode('utf-8', errors='ignore').strip()
            if not line:
                continue

            temp, hum, moisture = parse_line(line)
            # Quando abbiamo tutti e tre i valori, inviamo a InfluxDB
            if temp is not None and hum is not None:
                # attendiamo il moisture successivo
                continue
            if moisture is not None:
                timestamp = time.time_ns()
                # crea punto InfluxDB
                point = Point("sensori_arua").tag("device", "arduino1") \
                    .field("temperature", temp) \
                    .field("humidity", hum) \
                    .field("moisture", moisture) \
                    .time(timestamp)

                write_api.write(bucket=INFLUX_BUCKET, org=INFLUX_ORG, record=point)
                print(f"Inviati: T={temp}°C H={hum}% M={moisture}")

    except KeyboardInterrupt:
        print("Interrotto da utente.")
    finally:
        ser.close()
        client.close()


if __name__ == "__main__":
    main()
