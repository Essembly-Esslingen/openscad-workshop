/* busle.scad
Author: andimoto@posteo.de

----------------------------
Das ist das Model für den OpenSCAD Basis Workshop
des Makerspace Esslingen am 6.8.2022

Dieses Model besteht aus verschiedenen Teilen (Modulen), welche zu einem
Objekt zusammen gesetzt werden. Es soll die grundlegenden Funktionen
von OpenSCAD zeigen mit welchen man bereits Modelle erstellen kann. 
Zudem hat es den Anspruch auf einem 3D Drucker gut druckbar 
zu sein (Print-In-Place). Das erfordert die Beachtung einiger 
Punkte im Design (z.B. der Kegel in zwischen Reifen und Achse).
Das ist auch der Grund warum das Model auf der Seite liegt.
Es wird bewusst auf Schleifen, Bedingungsabfragen und ähnliche fortgeschrittene 
Funktionen von OpenSCAD verzichtet.


Wenn der Programmcode unübersichtlich zu sein scheint, hilft das Auftrennen
der einzelnen Übergabeparameter (in einzelne Zeilen) als auch die folgenden Hilfsmittel zum Markieren von Teilen:

Verwende '#' vor einem Objekt um es rot zu markieren,
'%' um es grau zu markieren (und vom Rendering auszuschließen),
'!' um das Objekt als einziges Teil anzuzeigen. So kann man
einen schnellen Überblick erhalten.

OpenSCAD Funktionen auf einen Blick https://openscad.org/cheatsheet/

Diese Datei kann im Customizer verwendet werden. (Fenster->Customizer)
*/

// Auflösung (abgerundete Körper)
$fn=50;

// Länge des hinteren Fahrgastraum.
LaengeBusHinten = 60;
// Breite des Busses
BusBreite = 40;
// Hoehe des Busses ohne Reifen
BusHoehe = 40;


// Radius des Reifens
ReifenRadius = 12;
// Dicke des Reifens
ReifenDicke = 5;
// Radius der des inneren Achsenteils
AchsenRadius = 5;
// Länge des inneren Achsenteils
AchsenDicke = 5;


// bestimmt den Abstand der Reifen zur Forder- oder Rückseite
ReifenPosX = 20;
// bestimmt die Lage der Reifen vom Boden. (Y Richtung)
ReifenPosY = 1;


/* Halbe Achse mit einem Reifen  - liegend auf Reifen
   Parameter:
   - length = Länge der halben Achse
   - tyreR = Reifenradius
   - tyreT = Reifendicke 
   - axesR = Achsenradius
   - axesT = Achsendicke */
module ReifenMitAchse(length=10, tyreR=5, tyreT=4, axesR=2, axesT=3)
{
  /* Reifen */
  cylinder(r=tyreR,h=tyreT);

  /* Verbindungsstück Reifen zu Achse.
     Kegelförmige Verbindung macht das Objekt 3d druckbar (print-in-place)  */
  translate([0,0,tyreT]) cylinder(r1=tyreR,r2=axesR,h=length-axesT-tyreT);

  /* Achse */
  translate([0,0,(length-axesT)]) cylinder(r=axesR,h=axesT);
}

/* Halber Fahrgastraum des Busses. 
   Parameter:
   - carLen = Länge des hinteren Teils
   - halfCarWidth = Breite des halben Fahrzeugs
   = carHeight = Karosseriehöhe des Fahrzeugs */
module BusHinten(carLen = 40, halfCarWidth = 10, carHeight = 20)
{
  /* Hinterer Teil des Busses mit schräger Kante.
     Kante wird durch Verbindung mit sehr dünnem Kubus erreicht. */
  hull()
  {
    translate([1,0,0]) cube([carLen-1,carHeight-1,0.2]); // x/y sind jeweils 1mm kleiner
    translate([0,0,1]) cube([carLen,carHeight,halfCarWidth-1]); // 1mm höher gesetzt für 45° Schräge
  }
}

// Konstante. Bestimmt die Lage der Reifen und Achse in Y Richtung
ReifenPosYfix = 1.2;

/* Konstanten vanFront...: bestimmen die Form der Fahrerzelle */
vanFrontLen1 = 30;
vanFrontLen2 = 20;
vanFrontY = 20;

/* xpos2: Die Distanz von Vorderrad zur Vorderseite und Hinterrad zur Hinterseite
   soll immer gleich sein und sich automatisch anpassen */
xPos2 = LaengeBusHinten+vanFrontLen1-ReifenPosX;

/* Polygone für Fahrerzelle. Ein manche Punkte des 1. Polygons sind um 1mm verschoben.
   Dadurch wird hier auch eine schräge Kante erstellt. Zusätzlich werden die Punkte zum Teil
   aus den obigen Parametern erstellt. */
frontPoly1 = [[0,0],[vanFrontLen1-1,0],[vanFrontLen1-1,vanFrontY-1],[vanFrontLen2-1,BusHoehe-1],[0,BusHoehe-1]];
frontPoly2 = [[0,0],[vanFrontLen1,0],[vanFrontLen1,vanFrontY],[vanFrontLen2,BusHoehe],[0,BusHoehe]];


/* Halbe Fahrerzelle - dieser Teil wird komplett aus Polygonen erstellt 
   Parameter: 
   - p1 = Polygon mit 0.2mm Höhe
   - p2 = Polygon extrudiert mit 'extrusionHeight'
   - extrusionHeight = Extrusionshöhe von p2 */
module BusVorne(p1, p2, extrusionHeight = 10)
{
  hull()
  {
    linear_extrude(height=0.1) polygon(p1);
    translate([0,0,1]) linear_extrude(height=extrusionHeight-1) polygon(p2);
  }
}

// Konstante setzt den Abstand zwischen Ausschnitt und Reifen im Körper fest.
zwischenAbstandRadius = 0.5;

/* Halbes Bussle wird in diesem Modul aneinander gesetzt.
   - Buskarosserie aus BusHinten und BusVorne
   - Ausschnitt der Reifen und Achsen aus vergrössertem 'ReifenMitAchsen' Modul
   - Einsetzten der Reifen und Achsen mit etwas kleinerem 'ReifenMitAchsen' Modul 
   Farben werden beim Rendern nicht berücksichtigt! Sie dienen nur der Trennung der Objekte */
module halbes_busle()
{
  difference() {
    /* Karosserie */
    union()
    {
      color("Red") BusHinten(carLen = LaengeBusHinten, halfCarWidth = BusBreite/2, carHeight = BusHoehe);
      color("Yellow") translate([LaengeBusHinten,0,0]) BusVorne(frontPoly1, frontPoly2, extrusionHeight=BusBreite/2);
    }
    /* Ausschnitt der Reifen und Achsen aus dem Buskörper hinten und vorne.
       Ausschnitt muss vom Radius grösser sein als die später eingesetzten Reifen und Achsen.
       Siehe 'zwischenAbstandRadius'.
       So entsteht ein Abstand beim 3d Druck und die Reifen lassen sich bewegen. */
    translate([ReifenPosX,AchsenRadius+ReifenPosY+ReifenPosYfix,0])
      ReifenMitAchse(length=BusBreite/2, tyreR=ReifenRadius+zwischenAbstandRadius,
                tyreT=ReifenDicke, axesR=AchsenRadius+zwischenAbstandRadius,
                axesT=AchsenDicke);
    translate([xPos2,AchsenRadius+ReifenPosY+ReifenPosYfix,0])
      ReifenMitAchse(length=BusBreite/2, tyreR=ReifenRadius+zwischenAbstandRadius,
                tyreT=ReifenDicke, axesR=AchsenRadius+zwischenAbstandRadius,
                axesT=AchsenDicke);
  }
  /* Einsetzen der Reifen und der Achsen. Müssen kleiner sein als der
     Radius des Ausschnitts, sonst können sich die Räder später nicht drehen */
  color("Grey") translate([ReifenPosX,AchsenRadius+ReifenPosY+ReifenPosYfix,0])
    ReifenMitAchse(length=BusBreite/2, tyreR=ReifenRadius,
              tyreT=ReifenDicke, axesR=AchsenRadius,
              axesT=AchsenDicke);
  color("Green") translate([xPos2,AchsenRadius+ReifenPosY+ReifenPosYfix,0])
    ReifenMitAchse(length=BusBreite/2, tyreR=ReifenRadius,
              tyreT=ReifenDicke, axesR=AchsenRadius,
              axesT=AchsenDicke);
}

/* Das vollständige Model wird aus 2 Modelhälften mit 'mirror' zusammen gesetzt */
halbes_busle();
translate([0,0,BusBreite]) mirror([0,0,1]) halbes_busle();
