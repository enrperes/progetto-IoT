#let title = text(25pt)[Relazione progetto IoT]
#let subtitle = text(20pt)[Corso di Internet of Things]
#let date = text(15pt)[Università degli studi di Udine, A.A. 2024-2025]

// Outline
#show outline.entry.where(level: 1): set text(weight: "bold", size: 13pt)
#show outline.entry.where(level: 1): set block(above: 1.5em)

// link
#show link: set text(fill: blue)
#show link: underline

/* ------------ Libraries ------------- */
#import "@preview/zebraw:0.5.2": *

/* ------------ Document Setup ------------- */
#set text(lang: "it")
#set page(numbering: "1")
#set par(justify: true)
#set enum(indent: 1em)


// Debug
// #set block(stroke: 0.5pt)

// Quotes
#set quote(block: true)
#show quote: set text(font: "", size: 12pt, style: "italic")

// Headings
#set heading(numbering: "1.")
#show heading: set block(below: 1.5em)
#show heading.where(level: 1): set text(20pt)
#show heading.where(level: 2): set text(14pt)
#show heading.where(level: 3): set text(12pt)
#show heading.where(level: 4): set heading(numbering: none)


// Figures
#show figure.caption: it => [
 #text(9pt)[ 
 #it.supplement
 #context it.counter.display(it.numbering)]:
 #it.body
]


/* ------------ Document Starts Here ------------- */

#align(center, text(25pt)[
  #v(15%)
  #image("media/logo_uniud.svg", width: 20%)
  #title \
  #subtitle \
  #date
])

#grid(
  columns: (1fr, 1fr),
  align(center)[
    Daniele De Martin [162521\@spes.uniud.it] \
    Enrico Peressin [163503\@spes.uniud.it] \
  ],
  align(center)[
    Massimiliano Di Marco [144714\@spes.uniud.it] \
    Aurora Marzinotto [162556\@spes.uniud.it] \
  ]
)

#align(center)[
  #v(5em)
  #text(17pt)[#strong()[#upper[Sistema di irrigazione autonomo tramite \ Arduino e raspberry pi]]]
  #v(2em)
]
#pagebreak()

/* ------------Outline------------- */
#outline(
  indent: 2.5em, title: "Indice",
)

#pagebreak()



= Introduzione 

== Sommario
L'obiettivo di questo progetto è sviluppare un sistema di irrigazione automatico per una pianta di basilico. Il sistema deve essere in grado di monitorare l'umidità del terreno e mantenerla entro una soglia regolabile, in base alle esigenze della specie vegetale (nel nostro caso il basilico), attivando l'irrigazione quando necessario.
Inoltre, i dati raccolti devono poter essere visualizzabili in tempo reale.


== Descrizione generale e obiettivi del lavoro  
Le funzionalità che il sistema deve rispettare sono riportate di seguito: 

  + *Controllo di parametri* come temperatura, umidità dell'aria, umidità del terreno.
  + *Controllo del livello dell'acqua* disponibile per l'irrigazione in un apposito recipiente.
  + *Irrigazione automatica* tramite pompa di irrigazione predisposta.
  + *Caricamento su `InfluxDb`* dei dati raccolti in serie temporale.
  + *Uso di `Grafana`* per visualizzazione dei dati.
  + *Visualizzazione* da remoto. 

= Componenti hardware e software

== Strumenti Utilizzati 
 - *_Raspberry Pi 5_:* \ L'ultima versione del single-board computer sviluppato da Raspberry. Viene usato come supporto per il caricamento dei dati, la creazione di grafici e per esporre i servizi rendendoli disponibili da remoto.
   #align(center)[
      #image("media/raspberry.png", width: 25%)
   ]
 - *_Arduino Uno R3_:* \ Piattaforma open-source di prototipazione elettronica programmata tramite l'apposito IDE. Usato nella gestione dei sensori e nella traduzione da segnale analogico a digitale per il sensore di umidità del suolo e quello di livello dell'acqua.
   #align(center)[
      #image("media/arduino.jpg", width: 25%)
   ]

  
 - *_Sensore di umidità dell'aria e temperatura (DHT11):_* \ #upper[è] stato collegato ad Arduino per controllare la temperatura e l'umidità dell'ambiente.
   #align(center)[
      #image("media/temp.jpg", width: 20%)
   ]
 - *_Sensore di umidità del suolo:_*\ #upper[è] stato inserito all'interno del terriccio in modo da poter monitorarne l'umidità per gestire l'irrigazione.
   #align(center)[
      #image("media/umidita.png", width: 20%)
   ]
 - *_Sensore di livello dell'acqua:_* \ Il sensore è stato inserito nel recipiente dell'acqua per poterne controllare il livello e di conseguenza sapere quando ha bisogno di essere riempito.
   #align(center)[
      #image("media/sensore_acqua.jpg", width: 20%)
   ]
 - *_Pompa d'acqua sommergibile:_* \ Immersa all'interno del recipiente, essa eroga l'acqua pompandola attraverso l'apposito tubo.
   #align(center)[
      #image("media/pompa.png", width: 20%)
   ]
 - *_Modulo relè ad un canale:_* \ Viene utilizzato per azionare la pompa tramite Arduino.
   #align(center)[
      #image("media/modulo-rele-1-canale.jpg", width: 20%)
   ]
 #v(7em)
   - *_Tubo flessibile in PVC:_* \ Al tubo, posizionato al centro del vaso, sono stati fatti dei fori sul lato destro e sinistro in modo da bagnare uniformemente il terreno della pianta.
   #align(center)[
      #image("media/tubo.png", width: 20%)
   ]
 - *_Alimentazione da 3V:_* \ Per alimentare la pompa dell'acqua viene utilizzata un'alimentazione da 3V realizzata ponendo due batterie da $1,5$ $V$ in serie. 
   #align(center)[
      #image("media/slotBatterie.png", width: 25%)
   ]
 
 - *_Led_:* \ Viene usato un led rosso per avvisare quando il livello dell'acqua è sotto una soglia limite e necessita di rifornimento.
   #align(center)[
      #image("media/led-rosso-5mm.jpg", width: 20%)
   ]



= Implementazione hardware

Il progetto è stato costruito su una base di due tavolette di legno per rendere il tutto trasportabile e più ordinato. Nella prima tavoletta è stato posto un recipiente per l'acqua e di fianco la piantina di basilico.
Nella seconda tavoletta è stata predisposta l'elettronica del progetto: Arduino con relativa breadboard e tutti i sensori sopraccitati, case con le batterie per l'alimentazione del motorino, relè e il Raspberry alimentato via USB-C.

== Cablaggio pompa - alimentazione - relè

Il motorino per pompare l'acqua necessita di una alimentazione di 3V. È stato quindi preso un porta batterie e inserite due batterie, posizionate in serie, di tipo AA ciascuna da 1.5V. Il polo negativo della batteria è stato collegato direttamente al cavo che identifica il polo negativo del motorino con apposito incastro e dopo aver stagnato i cavi per garantire una miglior tenuta.
Il polo positivo della batteria è stato collegato all'ingresso "normalmente aperto" del relè. Il circuito è stato poi chiuso mettendo il polo positivo del motorino nell'ingresso di "controllo" del relè.
Il motorino rimane spento in condizioni normali e viene attivato in base alle condizioni rilevate dai sensori, chiudendo il circuito tramite l'attivazione del relè

#align(center)[
      #image("media/circuito.png", width: 30%)
]

Il pin di input del relè è stato collegato direttamente al pin digitale 13 di Arduino (identificato dal cavo arancione), mentre gli altri pin di ground e tensione sono stati collegati nelle apposite posizioni della breadboard. 

== Montaggio sensori di temperatura/umidità e umidità del suolo

Il sensore DHT11, per la rilevazione di temperatura e umidità dell'aria, è stato inserito nella breadboard rivolto verso l'esterno. Il pin di input è stato collegato (con un cavo blu) sulla porta digitale 8 di Arduino. 

Il sensore per l'umidità del suolo è stato inserito in profondità, circa al centro della pianta, in modo da avere una rilevazione più accurata e precisa possibile. Il suo pin di trasmissione è stato inserito nell'ingresso analogico `A5`, identificabile dal cavo giallo.

== Montaggio pompa, sensore di livello e led

La pompa è stata fissata alla base di un recipiente contentente dell'acqua, in modo tale da garantirne quasi il totale utilizzo. Pochi centimetri in parte è stato fissato allo stesso modo il sensore di livello in modo che poggiasse a terra per fornire un'indicazione più veritiera possibile del livello attuale dell'acqua. Il pin di segnale del sensore è stato collegato al pin analogico `A4`, identificabile dal cavo verde, mentre il canale di alimentazione al pin digitale `7` in modo da alimentarlo solo quando necessario per evitare corrosioni.

È stato poi posto un led rosso sulla breadboard, collegato con apposita resistenza di $220Ω$, che verrà poi acceso quando il livello dell'acqua nella bacinella è critico. Il led è stato collegato sul pin digitale 9, identificabile dal cavo bianco.

== Il progetto completo


#align(center)[
      #image("media/completo.jpg", width: 100%)
]
= Implementazione software

Sono stati sviluppati due file: `arduino.ino`, caricato nell'Arduino e `raspberry-serial.py`, in esecuzione sul Raspberry Pi. 

== Calibrazione dei sensori

Sono stati rilevati i valori registrati dal sensore di umidità del terreno nelle situazioni di totale aridità e saturazione del terriccio. Nel primo caso viene registrato un valore approssimativo di 350, nel secondo attorno ai 650. \ 
L'umidità ideale del terreno per una pianta di basilico si aggira intorno al 60-70%, quindi è stato posto il valore di soglia a 450, che corrisponde al 40% di aridità (cioè il 60% di umidità), come valore sopra al quale la pompa inizia l'erogazione dell'acqua. 

Il sensore di livello dell'acqua registra un valore intorno a 200 quando il contenitore è pieno e scende fino a circa 0 quando è vuoto. #upper[è] stato scelto 15 come valore limite, che indica di riempire il contenitore. 

== Codice arduino.ino
Il programma nella fase `setup()` (eseguita una sola volta all'avvio) inizializza la comunicazione seriale (`Serial.begin(9600)`) per stampare i dati nel monitor seriale. Inoltre, viene avviato il sensore DHT11 con `dht.begin()`, vengono impostati i pin in modalità input/output a seconda del componente. 
La funzione `loop()`, che si ripete all'infinito, legge i dati dai sensori e stampa su monitor seriale tutti i valori letti nel formato:

`TEMPERATURA: t UMID_ARIA: h UMID_SUOLO: m LIV_ACQUA: l`, dove $t, h, m, l$ rappresentano i valori rilevati dal sensore. 

Se il valore di umidità del suolo rilevato dal sensore supera 450 (cioè troppo secco), viene accesa la pompa per 2 secondi. 
Un'altra condizione è presente sul sensore di livello dell'acqua: quando il livello è minore di 15 viene acceso il led rosso, indicando all'utente di riempire il contenitore d'acqua. 

Alla fine del `loop()` è presente un `delay(600000)` che sospende l'Arduino per 10 minuti. 


#zebraw(
  header: [arduino.ino],
```cpp
#include <DHT.h>

int MOTORE = 13;
int UM_SUOLO = A5;
int TEMP = 8;
int SENSOR_POWER = 7;
int WATER_LVL = A4;
int LED = 9; 

int val = 0; 
float liv_acqua = readSensor();

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
```

)

== Codice raspberry-serial.py

Questo script `Python` viene eseguito sul Raspberry Pi e ha lo scopo di ricevere i dati tramite la porta seriale dall'Arduino e inviarli al database di _InfluxDB_. \
Il programma è così strutturato: 
viene aperta una connessione sulla porta seriale corrispondente al cavo USB con cui Arduino è stato collegato. \
Arduino invia ogni 10 minuti una stringa contenente i valori dei sensori, che vengono estratti e convertiti. Si registra un timestamp e si crea un oggetto `Point` con tutti i valori, che viene poi inviato a InfluxDB tramite `write_api`. 
Ad ogni scrittura avvenuta correttamente, viene stampato l'output nel terminale per conferma. 
Nel codice vengono usate le seguenti librerie: 
- `pyserial`: permette di comunicare tramite porte seriali, serve a leggere i dati da Arduino e inviarli a Raspberry Pi. 
- `influxdb-client`: Interagisce con InfluxDB e serve per creare i punti dati e inviarli al server. 
\
#zebraw(
  header: [raspberry-serial.py],
```python
#!/usr/bin/env python3
import serial
import time
from serial.tools import list_ports
from influxdb_client import InfluxDBClient, Point, WriteOptions

# --- CONFIGURAZIONE SERIAL ---
# Impostare manualmente la porta 
SERIAL_PORT = '/dev/ttyACM0' 

BAUDRATE = 9600
TIMEOUT = 2  # secondi

# --- CONFIGURAZIONE INFLUXDB ---
INFLUX_URL = "http://localhost:8086"
INFLUX_TOKEN = "TOKEN"
INFLUX_ORG = "IoT"
INFLUX_BUCKET = "bucket_sensori"

def main():
    port = SERIAL_PORT
    if port is None:
        print("Porta Arduino non trovata")
        return

    ser = serial.Serial(port, BAUDRATE, timeout=TIMEOUT)
    print(f"Connesso ad Arduino su {port} @ {BAUDRATE}bps")

    # Inizializzazione client InfluxDB
    client = InfluxDBClient(url=INFLUX_URL, token=INFLUX_TOKEN, org=INFLUX_ORG)
    write_api = client.write_api(write_options=WriteOptions(batch_size=1))
    time.sleep(3)
    line = ser.readline().decode()
    while True:
         line = ser.readline().decode()
         if "TEMPERATURA" in line and "UMID_ARIA" in line and  
         "UMID_SUOLO" in line and "LIV_ACQUA" in line:
            line = line.split(" ") 
            temp = int(line[0].split(":")[1])
            hum = int(line[1].split(":")[1])
            moisture = float(line[2].split(":")[1])
            liv_acqua = float(line[3].split(":")[1])

            # Creazione punto InfluxDB
            timestamp = time.time_ns()
            point = Point("sensori_pianta").tag("device", 
            "arduino").field("Temperatura", temp).field
            ("Umidita' Aria", hum).field("Umidita' Terreno", 
            moisture).field("Livello Acqua", liv_acqua).time(timestamp)

            write_api.write(bucket=INFLUX_BUCKET, org=INFLUX_ORG, record=point)
            print(f"Inviati: T={temp} C H={hum}% M={moisture} L={liv_acqua}")


if __name__ == "__main__":
    main()
```
)

== Installazione InfluxDB

InfluxDB V2 è stato installato sul Raspberry Pi direttamente dal repository ufficiale. 
Dopo l'installazione è stato abilitato il servizio con il comando `sudo systemctl enable influxdb`. \
La dashboard web di InfluxDB è disponibile alla porta 8086 del Raspberry Pi. Da qui è stato creato un utente admin, un'organizzazione e un bucket, sul quale verranno salvati i dati. 

== Installazione Grafana
Come per InfluxDB, Grafana è stato installato sul Raspberry Pi dal repository ufficiale e con `sudo systemctl start grafana-server` è stato avviato. L'interfaccia web è accessibile alla porta 3000. \
Nella sezione _Connections > Data source_ è stato aggiunto InfluxDB, inserendo tutti i parametri impostati precedentemente (credenziali, nome organizzazione, bucket...). 
Nella sezione _Dashboard_, sono state create le due visualizzazioni, prendendo i dati da InfluxDB tramite la query scritta in Flux. 

#zebraw(
  header: [Query],
  ```flux
  from(bucket: "bucket_sensori")      
  |> range(start: -24h)               
  |> map(fn: (r) => ({                
    r with                            
    _value:
      if r._field == "Livello Acqua"  
        then float(v: r._value) / 2   
        else float(v: r._value)       
  }))
  ```
)

La query richiede le tuple provenienti dal bucket _bucket_sensori_ e fa un mapping per rendere il valore del livello dell'acqua espresso in forma percentuale ed essere così meglio interpretabile.

== Scelta dei grafici e interfaccia di Grafana

Dopo aver scritto l'opportuna query per estrarre i dati da _InfluxDB_, è stato scelto come grafico per l'esposizione quello di tipo _Gauge_. Esso permette la visualizzazione live dei quattro parametri di interesse: livello dell'acqua, temperatura, umidità dell'aria e del suolo, inoltre sono stati aggiunti dei parametri di threshold, unità di visualizzazione e colorazioni per interpretare al meglio i dati.

#image("dashboard-gauge.png")

#upper[è] stata anche creata un'altra dashboard del tipo _Time Series_, per visualizzare l'andamento dei vari parametri. 

#image("dashboard-graph.png")

#upper[è] stato attivato il sistema di alert che _Grafana_ mette a disposizione impostando un bot su _Telegram_ (\@basilicooobot) che avvisa quando il livello della bacinella scende sotto il valore di soglia, inviando una notifica. 

#align(center)[

      #image("telegram-bot.png", width: 50%)
]

= Implementazione visione da remoto

Per visualizzare i grafici su _Grafana_, se si è nella stessa rete del Rasperry, è sufficiente collegarsi alla porta 3000 di esso conoscendo il suo indirizzo IP privato (nel nostro caso 192.168.1.32).\ Per rendere questo servizio accessibile anche se si è fuori casa si presentano due soluzioni: esporre una porta del router di casa in modo da reindirizzare sulla porta corretta del Rasperry oppure sfruttare un servizio di VPN.

== Esposizione di una porta su internet e DNS

Questa alternativa permette di rendere visibile il servizio su internet, pertanto chiunque disponga di una connessione a internet è libero di visualizzare i grafici su _Grafana_.
Per iniziare sono state modificate le tabelle di NAT del router di casa, in questo modo tutte le richieste che arrivano al router nella porta 3000 vengono reindirizzate all'indirizzo 192.168.1.32 nella porta 3000 dove è esposto il servizio _Grafana_.

Per rendere l'interazione migliore e non doversi ricordare l'indirizzo IP del router a memoria è stato attivato un nome di dominio che va a sostituire l'indirizzo IP pubblico del router di casa.\
L'accesso a _Grafana_ è quindi disponibile al link http://basilico.blog:3000 da qualsiasi dispositivo con connessione a internet.

== Servizio di VPN Tailscale

Per rendere meno dipendente il Raspberry dal router di casa è stato adottato anche il servizio `Tailscale`, un servizio di mesh VPN costruita su WireGuard che crea una rete privata fra i dispositivi iscritti. In questo modo, anche se il Raspberry
viene spostato in un’altra rete, per esempio
collegato a un hotspot 4G, i dispositivi
nella rete privata del Raspberry possono continuare a 
raggiungerlo liberamente.
Grazie a *MagicDNS* si evita di ricordare gli indirizzi IP, quindi il servizio di _Grafana_ è disponibile al link `http://raspberrypi:3000` da qualunque
device autenticato nella rete privata.

== Visualizzazione dei grafici senza autenticazione

Il grafico Gauge è disponibile liberamente al link http://basilico.blog:3000/public-dashboards/93dd5dfa69884ef0a5264a5a2b108807 quando il Raspberry è connesso al router di casa.\ In alternativa è sempre disponibile al link http://raspberrypi:3000/public-dashboards/93dd5dfa69884ef0a5264a5a2b108807 se si è connessi tramite dispositivo registrato alla rete `Tailscale`.

= Osservazioni conclusive

Questo progetto ci ha permesso di sperimentare con strumenti diffusi come Arduino e Raspberry Pi, con l'obiettivo di monitorare e regolare i parametri ambientali e vitali di una pianta di basilico. 

L'implementazione non ha comporatato costi elevati per quanto riguarda i sensori e la pompa dell'acqua (\~15€), mentre più ingenti sono state quelle per il Raspberry Pi 5 (\~100€) e l'Arduino Uno (\~30€). 
#upper[è] importante sottolineare che, pur potendo realizare una versione più semplice del sistema anche senza Raspberry, questo ricopre il ruolo fondamentale di server locale per raccolta e visualizzazione remota dei dati. 

I software utilizzati (_InfluxDB_ e _Grafana_) sono risultati intuitivi e di facile gestione. Anche i codici .ino e .py di supporto ad'Arduino e a Raspberry non hanno richiesto conoscenze eccessivamente approfondite per essere implementati.

In conclusione, il progetto ci ha permesso di spaziare su più fronti sia nell'ambito software che nell'ambito hardware del mondo dell'Internet of Things e realizzare un sistema di controllo di irrigazione automatica che può essere adattato o ampliato con altre piante semplicemente modificando i parametri rilevati dai sensori.



