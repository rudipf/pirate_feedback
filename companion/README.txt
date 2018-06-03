Der Companion Ordner enthält die Scripte, um aus der Liste der Mitgliederverwaltung
die entsprechenden Pirate Feedback Einladungsschlüssel zu generieren und einzuspielen.

.../www/ enthält ein einfaches HTML Formular und ein CGI Script damit die
MV die Listen hochladen kann. Der Ordnder sollte seinen eigenen Vhost bekommen
und ggf über .htaccess abgesichert werden.

.../files/ enthält die hochgeladenen Dateien und sollte nicht nach aussen zugänglich sein

.../code/ enthält
 createdb.sql mit dem die companion datenbank gefüllt werden kann
   Hinweis: die import Tabelle dort enthält die Kontaktinfos, stimmberechtigungen,
   registrierungsschlüssel der Mitglieder. Sie benötigt ein OFFsite Backup !
 import.sh liest die Datei der MV, gleicht sie mit der companion db ab
   und schreibt eine liste der regkeys für den nächsten schritt

Danach muß (entsprechend der letzten Melduzng von import.sh) util.import_members
(Teil von Piratefeedback) ausgeführt werden, um die regkeys zu importieren
bzw accounts zu deaktivieren.

 mail.sh Schickt den heute importierten Mitgliedern, eine Mail mit Ihrem Registrierungsschlüssel

Achtung ! Alle Scripte vorher mal durchlesen bevor man sie in Produktion ausführt.
Da ist das eine oder andere hartcodiert, was man vielleicht ändern möchte.

