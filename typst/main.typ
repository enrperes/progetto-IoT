#import "lib.typ": typs
#set text(lang: "it") 
#set enum(indent: 1.8em)
#set list(indent: 1.8em)

#show: typs.with( 
  title: text(25pt)[Progetto di IoT
  #show raw.where(block: false): set text(size: 12pt)
  #show raw: set text(font: "Roboto Mono")
    #text(13pt)[\ Sistema di irrigazione autonomo tramite Arduino e Raspberry Pi]
  ],
  author: "Daniele Mozzarella [******], Massimiliano Di Marco [144714],\nAurora Marzinotto [162556], Enrico Peressin [163503]",
  // date: datetime(year: 2025, month: 6, day: 18),
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
L'obiettivo di questo progetto è sviluppare un sistema di irrigazione automatico di una pianta. Il sistema deve essere in grado di mantenere l'umidità del terreno entro una soglia impostabile, a seconda della specie della pianta e delle sue specifiche richieste (nel nostro contesto una pianta di basilico), e se necessario provvedere ad irrigare il terreno con dell'acqua. 


== Descrizione generale del lavoro  
Le funzionalità che il sistema deve rispettare sono riportate di seguito: 
  + Controllo di parametri di temperatura, umidità dell'aria e umidità del terreno (_moisture_)
  + Controllo del livello dell'acqua disponibile per l'irrigazione in un apposito recipiente
  + Irrigazione automatica tramite pompa di irrigazione predisposta
  + Caricamento su `InfluxDb` dei dati raccolti in serie temporale
  + Visualizzazione da remoto 

= Metodologia

== Strumenti Utilizzati 
 - Raspberry Pi
 - ArduinoUno
 - Sensore di umidità dell'aria
 - Sensore di umidità del terreno
 


 - Librerie Python 
  - #raw("Pyserial"):
  - #raw("")

= Progetto (fisico)

= Implementazione


= Osservazioni conclusive

