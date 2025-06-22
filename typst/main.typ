#import "lib.typ": typs
#set text(lang: "it") 
#set enum(indent: 1.8em)
#set list(indent: 1.8em)

#show: typs.with( 
  title: text(25pt)[Progetto di IOT
  #show raw.where(block: false): set text(size: 12pt)
  #show raw: set text(font: "Roboto Mono")
    #text(13pt)[\ Sistema di irrigazione autonomo tramite Arduino e Raspberry Pi]
  ],
  author: "Daniele De Martin [162521], Massimiliano Di Marco [144714],\nAurora Marzinotto [162556], Enrico Peressin [163503]",
  date: datetime(year: 2025, month: 6, day: 18),
  abstract: [
    Corso di Internet of Things, 
    \ a.a. 2024/2025 
  ],
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true),

  
)



= Introduzione 

== Sommario
L'obiettivo di questo progetto è sviluppare un sistema di irrigazione automatico di una pianta di basilico. Il sistema deve essere in grado di mantenere l'umidità del terreno entro una soglia impostabile, a seconda della specie della pianta e delle sue specifiche richieste (nel nostro contesto una pianta di basilico), e se necessario provvedere ad irrigare il terreno con dell'acqua. 


== Descrizione generale del lavoro  
Le funzionalità che il sistema deve rispettare sono riportate di seguito: 
  + Controllo di parametri di temperatura, umidità dell'aria, umidità del terreno (_moisture_).
  + Controllo del livello dell'acqua disponibile per l'irrigazione in un apposito recipiente.
  + Irrigazione automatica tramite pompa di irrigazione predisposta.
  + Caricamento su `InfluxDb` dei dati raccolti in serie temporale.
  + Uso di `Grafana`per visualizzazione dei dati.
  + Visualizzazione da remoto. 

= Metodologia

== Strumenti Utilizzati 
 - _Raspberry Pi 5:_ ultima versione del single-board computer sviluppato da Raspberry.
   #align(center)[
      #image("raspberry.png", width: 20%)
   ]
 - _ArduinoUno:_ piattaforma oper-source di prototipazione elettronica programmata tramite l'apposito IDE.
   #align(center)[
      #image("arduino.jpg", width: 20%)
   ]
 - _Sensore di umidità dell'aria e temperatura (DHT11):_ è stato collegato ad arduino per controllare la temperatura e l'umidità dell'ambiente.
   #align(center)[
      #image("temp.jpg", width: 20%)
   ]
 - _Sensore di umidità del suolo:_ il sensore è stato inserito all'interno del vaso della pianta in modo da poter monitorarne l'umidità del terreno per gestire l'irrigazione.
   #align(center)[
      #image("umidita.png", width: 20%)
   ]
 - _Sensore di livello dell'acqua:_ il sensore è stato inserito nel recipiente dell'acqua per poterne controllare il livello e di conseguenza sapere quando ha bisogno di essere riempito.
   #align(center)[
      #image("sensore_acqua.jpg", width: 20%)
   ]
 - _Mini pompa dell'acqua sommergibile:_ inserita all'interno del recipiente essa eroga l'acqua aspirandola e facendola passare attraverso il tubo.
   #align(center)[
      #image("pompa.png", width: 20%)
   ]
 - _Modulo relè ad 1 canale:_ utilizzato per azionare la pompa.
   #align(center)[
      #image("modulo-rele-1-canale.jpg", width: 20%)
   ]
 - _Tubo flessibile:_ al tubo in PVC, posizionato al centro del vaso, sono stati fatti dei fori all'estremità in modo da bagnare uniformemente il terreno della pianta.
   #align(center)[
      #image("tubo.png", width: 20%)
   ]
 - _Alimentazione da 3V:_ per alimentare la pompa dell'acqua viene utilizzata un'alimentazione da 3V realizzata ponendo due batterie da $1,5$ $V$ in serie.

 == Librerie Python
 - #raw("Pyserial"): libreria che permette di comunicare tramite porte seriali, viene utilizzata per leggere dati da Arduino ed inviarli al Raspberry
 - #raw("Influxdb-client"): libreria utilizzata per comunicare con InfluxDB, un database ottimizzato per memorizzare dati temporali

= Progetto (fisico)

= Implementazione


= Osservazioni conclusive

