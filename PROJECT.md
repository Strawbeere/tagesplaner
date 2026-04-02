# Projektkonzept: Tagesplaner-App

## 1. Projektidee

Die App ist ein persoenlicher Planungs- und Fortschrittstracker mit Fokus auf die Strukturierung des Alltags. Nutzer sollen ihren Tag zeitlich planen, Aufgaben und Termine eintragen, erledigte Punkte abhaken und ihren Fortschritt ueber Diagramme und Statistiken verfolgen koennen.

Der Schwerpunkt liegt klar auf dem **einzelnen Tag**. Wochen-, Monats- und Jahresansichten sind als Ergaenzung gedacht, um einen besseren Ueberblick und langfristige Entwicklungen sichtbar zu machen.

## 2. Ziel der App

Die App soll Nutzern helfen:

- ihren Tag klar zu strukturieren
- Aufgaben und Termine zeitlich zu planen
- erledigte Punkte abzuhaken
- wiederkehrende Aufgaben einfach zu verwalten
- Fortschritte langfristig sichtbar zu machen
- Notizen, Gedanken und Rueckblicke festzuhalten

## 3. Kernkonzept

Im Mittelpunkt steht die **Tagesansicht**.

Aufbau der Tagesansicht:

- links: Uhrzeiten
- Mitte: geplanter Eintrag oder Aufgabe
- rechts: Status bzw. Checkbox zum Abhaken
- unter dem geplanten Tagesverlauf: ein festes Notizfeld fuer jeden Tag mit Platz fuer Tageseindruecke, Erinnerungen und persoenliches Feedback zum Tag

Beispiel:

- 07:00 Aufstehen
- 08:00 Lernen
- 10:00 Sport
- 14:00 Termin
- 20:00 Tagesrueckblick

## 4. Hauptfunktionen

### 4.1 Tagesplanung

- Aufgaben und Termine eintragen
- Uhrzeit oder Zeitblock festlegen (z. B. 08:00 bis 09:30 Lernen)
- fuer jede Aufgabe einen Status festlegen: geplant, erledigt, teilweise erledigt, verschoben, nicht erledigt oder fremdverschoben
- Eintraege bearbeiten oder loeschen
- nicht erledigte Aufgaben verschieben
- Schnelleintrag / Quick-Add: ueber einen "+" Button (Floating Action Button) koennen Aufgaben direkt in der Tagesansicht schnell hinzugefuegt werden, ohne eine extra Seite oeffnen zu muessen
- Drag & Drop: Aufgaben koennen per Gedruechthalten auf einen anderen Tag oder Zeitslot gezogen werden, besonders nuetzlich beim Verschieben

### 4.2 Wiederkehrende Aufgaben

Unterstuetzung fuer:

- taeglich
- woechentlich
- monatlich
- bestimmte Wochentage, z. B. jeden Dienstag
- alle X Tage oder Wochen
- optional mit Start- und Enddatum

### 4.3 Notizen und Reflexion

- Tagesnotizen
- Wochennotizen
- Monatsnotizen
- Jahresnotizen
- freie Gedanken, Eindruecke, Erkenntnisse
- taegliche Selbsteinschaetzung:
  - Motivation (1–10): 1 = unmotiviert, 10 = sehr motiviert
  - Gefuehlslage (1–10): 1 = schlecht, 10 = gut

### 4.4 Kategorien

Jede Aufgabe kann einer Kategorie zugeordnet werden. Die App liefert folgende Beispielkategorien mit:

- Arbeit
- Schule / Studium
- Haushalt
- Gesundheit / Sport
- Ernaehrung
- Finanzen
- Soziales (Familie, Freunde, Termine mit anderen)
- Hobbys / Freizeit
- Selbstentwicklung (Lesen, Lernen, Weiterbildung)
- Administratives (Behoerdengaenge, Papierkram, Versicherungen)

Der Nutzer kann jederzeit eigene Kategorien hinzufuegen, bestehende umbenennen oder loeschen.

### 4.5 Statistiken und Diagramme

Diagramme:

- Balkendiagramm: erledigt vs. teilweise erledigt vs. nicht erledigt pro Tag/Woche — zeigt auf einen Blick, wie die Aufgaben verteilt sind
- Fortschrittsring (Donut): Tages-Erfuellungsquote — z. B. "7 von 10 erledigt", motivierend und sofort erfassbar
- Liniendiagramm: Erfuellungsquote ueber Zeit (Wochen/Monate) — zeigt langfristige Entwicklung und ob man sich verbessert

Kennzahlen:

- geplante Aufgaben pro Zeitraum
- erledigte Aufgaben pro Zeitraum
- Erfuellungsquote (gesamt und pro Kategorie)
- Entwicklung ueber Tage, Wochen und Monate
- Auswertung wiederkehrender Aufgaben
- Kategorie-Auswertung: Erfuellungsquote je Kategorie, um zu sehen, in welchen Lebensbereichen man produktiv ist und wo nicht

### 4.6 Tagesvorschau am Abend

Abends zeigt die App automatisch eine Vorschau auf den naechsten Tag: z. B. "Morgen hast du 5 Aufgaben geplant". Der Nutzer kann direkt noch Anpassungen vornehmen. Das macht die App zur taeglichen Gewohnheit.

### 4.7 Streak-Anzeige

Die App zeigt an, seit wie vielen Tagen der Nutzer in Folge aktiv geplant hat, z. B. "Du planst seit 14 Tagen in Folge". Einfache Gamification, die motiviert dranzubleiben.

### 4.8 Onboarding

Beim ersten Start zeigt die App eine kurze Einfuehrung (3–4 Screens), die erklaert, wie die App funktioniert: Aufgaben anlegen, Statuswerte verstehen, Tagesabschluss nutzen. So werden Nutzer nicht von den vielen Funktionen ueberwaeltigt.

### 4.9 Dark Mode

Die App bietet einen dunklen Modus an, besonders angenehm abends beim Tagesabschluss. Das blau-weisse Design laesst sich gut in Dunkelblau/Grau umwandeln.

### 4.10 Push-Benachrichtigungen

- Erinnerungen an anstehende Aufgaben
- Abends Erinnerung an den Tagesabschluss (Motivation und Gefuehlslage eintragen)
- optional und vom Nutzer konfigurierbar

### 4.11 Offline-First

Die App muss vollstaendig ohne Internetverbindung funktionieren. Alle Daten werden lokal gespeichert. Spaeter kann optional eine Cloud-Synchronisation ergaenzt werden.

### 4.12 Ergaenzende Uebersichten

- Wochenansicht
- Monatsansicht
- Jahresansicht

## 5. Staerken der Idee

- klare Alltagsrelevanz
- Kombination aus Zeitplanung, To-do-Verwaltung und Fortschrittstracking
- Fokus auf den Tag macht die App leicht verstaendlich
- Diagramme und Auswertungen koennen motivierend wirken
- Wiederholungen machen die App alltagstauglich
- Notizen und Rueckblicke geben der App mehr Tiefe als einer einfachen To-do-Liste

## 6. Verbesserungsvorschlaege

### 6.1 Feste Termine und flexible Aufgaben trennen

Es ist sinnvoll, zwischen zwei Arten von Eintraegen zu unterscheiden:

- feste Termine, z. B. Arzttermin um 14:00 Uhr
- flexible Aufgaben, z. B. Lernen oder Haushalt

Das macht die Tagesplanung realistischer und uebersichtlicher.

### 6.2 Mehr als nur "erledigt" oder "nicht erledigt"

Sinnvolle Statuswerte waeren:

- geplant: Aufgabe steht an, noch offen (Statistik: neutral)
- erledigt: Aufgabe abgeschlossen (Statistik: positiv)
- teilweise erledigt: angefangen, aber nicht komplett fertig (Statistik: teilweise positiv)
- verschoben: selbst auf einen anderen Tag verlegt (Statistik: neutral)
- nicht erledigt: nicht geschafft, eigene Verantwortung (Statistik: negativ)
- fremdverschoben: nicht geschafft, weil aeussere Umstaende dazwischenkamen, z. B. ungeplante Pflichten oder Notfaelle (Statistik: neutral)

Der Status "fremdverschoben" sorgt dafuer, dass Situationen, in denen der Nutzer nichts dafuer konnte, die Statistik nicht negativ beeinflussen. So bildet die App den echten Alltag realistischer und fairer ab.

### 6.3 Zeitbloecke unterstuetzen

Viele Aufgaben dauern laenger als nur einen Zeitpunkt. Deshalb sollten auch Zeitraeume moeglich sein, z. B.:

- 08:00 bis 09:30 Lernen
- 18:00 bis 19:00 Sport

### 6.4 Prioritaeten einfuehren

Moegliche Prioritaeten:

- hoch
- mittel
- niedrig

So wird klarer, was wirklich wichtig ist.

### 6.5 Kategorien einfuehren

Beispiele:

- Arbeit
- Schule/Studium
- Gesundheit
- Haushalt
- Freizeit
- Persoenlich

Kategorien verbessern sowohl die Planung als auch die spaeteren Diagramme.

### 6.6 Aufgaben verschieben statt nur offen lassen

Wenn etwas nicht geschafft wurde, sollte es leicht auf einen anderen Tag uebernommen werden koennen. Das ist im Alltag oft wichtiger als nur ein unerledigter Status.

### 6.7 Reflexion staerker strukturieren

Neben freien Notizen koennte es kurze Leitfragen geben:

- Was lief heute gut?
- Was habe ich nicht geschafft?
- Warum?
- Was will ich morgen besser machen?

### 6.8 Diagramme bewusst einfach halten

Zu viele Auswertungen machen die App schnell unklar. Besser sind wenige, aussagekraeftige Kennzahlen:

- geplante Aufgaben
- erledigte Aufgaben
- Erfuellungsquote
- aktive Tage
- Einhaltung wiederkehrender Aufgaben

### 6.9 Optionales Tagesgefuehl oder Energielevel

Ein einfacher zusaetzlicher Wert pro Tag, z. B. Stimmung oder Energie, koennte spaeter interessante Zusammenhaenge sichtbar machen.

## 7. Seiten- und Funktionsstruktur

### Navigation (Bottom-Bar)

Von links nach rechts: Monat | Woche | **Tag** (Mitte, Fokus) | Statistik | Tagesnotiz

Oben rechts: Hamburger-Menue (drei Striche) mit Profil, Einstellungen und Hilfe

### 7.1 Tagesansicht (Hauptseite)

- wichtigste Seite der App, zentraler Tab in der Navigation
- Uhrzeiten links
- Eintraege in der Mitte
- Status oder Checkbox rechts
- Floating Action Button (+) fuer Schnelleintrag
- Drag & Drop zum Verschieben von Aufgaben

### 7.2 Wochenansicht

- Ueberblick ueber mehrere Tage
- wiederkehrende Aufgaben sichtbar
- Wochennotiz oder Wochenziel

### 7.3 Monatsansicht

- kalenderartige Darstellung
- zeigt aktive und produktive Tage
- hilft beim Erkennen von Mustern

### 7.4 Statistik-Seite

- Diagramme (Balken, Donut, Linie)
- Erfuellungsquote gesamt und pro Kategorie
- Entwicklung nach Zeitraum
- Streak-Anzeige
- Auswertung nach Kategorien

### 7.5 Tagesnotiz

- Tagesnotizen, Wochennotizen, Monatsnotizen, Jahresnotizen
- taegliche Selbsteinschaetzung (Motivation und Gefuehlslage)
- freie Gedanken, Eindruecke, Erkenntnisse

### 7.6 Profil, Einstellungen und Hilfe (Hamburger-Menue)

- Profil: Nutzerdaten und Streak-Uebersicht
- Einstellungen: Kategorien verwalten, Dark Mode, Benachrichtigungen, Farben und Design, Sprache
- Hilfe: Onboarding erneut anzeigen, FAQ, Kontakt

## 8. Datenmodell auf hoher Ebene

### 8.1 Aufgabe / Eintrag

Ein Eintrag koennte folgende Eigenschaften haben:

- Titel
- Beschreibung
- Datum
- Uhrzeit oder Zeitspanne
- Kategorie
- Prioritaet
- Status
- wiederholend oder nicht
- Notiz

### 8.2 Wiederholung

- Typ: taeglich, woechentlich, monatlich
- Wochentage
- Intervall
- Startdatum
- Enddatum

### 8.3 Notizen

- Tagesnotiz
- Wochennotiz
- Monatsnotiz
- Jahresnotiz

### 8.4 Statistikdaten

- Anzahl geplanter Eintraege
- Anzahl erledigter Eintraege
- Erfuellungsquote
- Serienstaende oder Regelmaessigkeit

## 9. MVP (erste sinnvolle Version)

Um die App nicht zu gross zu starten, sollte die erste Version nur den Kern abdecken.

Empfohlene MVP-Funktionen:

- Tagesansicht
- Aufgaben mit Uhrzeit anlegen
- Aufgaben abhaken
- Eintraege bearbeiten und loeschen
- einfache Tagesnotizen
- einfache wiederkehrende Aufgaben
- einfache Statistik: geplant vs. erledigt

Dieser Umfang reicht aus, um die Hauptidee nutzbar zu machen und frueh Feedback zu sammeln.

## 10. Erweiterungen fuer spaetere Versionen

- Wochen-, Monats- und Jahresrueckblicke
- Kategorien mit Auswertung
- Prioritaeten
- Erinnerungen und Benachrichtigungen
- Drag-and-drop zum Verschieben von Aufgaben
- Tagesbewertung oder Stimmung
- Ziele und Gewohnheiten
- Export als PDF oder CSV
- Synchronisation zwischen Geraeten
- Cloud-Speicherung
- gemeinsames Planen mit anderen

## 11. Moegliche Diagramme

- geplante vs. erledigte Aufgaben pro Tag
- Wochen-Erfuellungsquote
- produktive Tage im Monat
- erledigte Aufgaben pro Kategorie
- Einhaltung wiederkehrender Aufgaben
- Entwicklung ueber mehrere Wochen oder Monate

Wichtig: Die Diagramme sollten leicht verstaendlich und nicht ueberladen sein.

## 12. Zielgruppe

Die App eignet sich besonders fuer:

- Schueler
- Studierende
- Berufstaetige
- Menschen mit festen Routinen
- Menschen, die mehr Struktur in ihren Alltag bringen wollen

## 13. Positionierung der App

Die App sollte nicht nur als Kalender oder To-do-Liste gesehen werden, sondern als:

**Tagesplaner + Fortschrittstracker + Reflexions-App**

Das ist ein staerkeres und klareres Profil als eine reine Planungs-App.

## 14. Empfohlene Entwicklungsreihenfolge

1. Tagesansicht
2. Aufgaben anlegen, bearbeiten und abhaken
3. Tagesnotizen
4. wiederkehrende Aufgaben
5. einfache Statistiken
6. Wochen- und Monatsansicht
7. Jahresansicht
8. erweiterte Diagramme und Feinschliff

## 15. Kurzbeschreibung des Produkts

Die App hilft Nutzern, ihren Alltag strukturiert zu planen und ihren Fortschritt sichtbar zu machen. Im Mittelpunkt steht die Tagesansicht, in der Aufgaben und Termine zeitlich eingetragen, abgehakt und bei Bedarf verschoben werden koennen. Ergaenzt wird dies durch wiederkehrende Aufgaben, Notizen und Reflexionen sowie Statistiken und Diagramme fuer Woche, Monat und Jahr.

## 16. Fazit

Die Idee hat klare Staerken und einen guten praktischen Nutzen. Besonders stark ist der Fokus auf die **taegliche Planung mit Fortschrittstracking**. Woche, Monat und Jahr sollten zunaechst nur ergaenzende Ebenen bleiben, damit die App nicht unnoetig komplex wird. Wenn der Fokus sauber auf der Tagesplanung bleibt, kann daraus eine klare und sehr nuetzliche Anwendung entstehen.
