Der Companion Ordner enth�lt die Scripte, um aus der Liste der Mitgliederverwaltung
die entsprechenden Pirate Feedback Einladungsschl�ssel zu generieren und einzuspielen.

.../www/ enth�lt ein einfaches HTML Formular und ein CGI Script damit die
MV die Listen hochladen kann. Der Ordnder sollte seinen eigenen Vhost bekommen
und ggf �ber .htaccess abgesichert werden.

.../files/ enth�lt die hochgeladenen Dateien und sollte nicht nach aussen zug�nglich sein

.../code/ enth�lt
 createdb.sql mit dem die companion datenbank gef�llt werden kann
   Hinweis: die import Tabelle dort enth�lt die Kontaktinfos, stimmberechtigungen,
   registrierungsschl�ssel der Mitglieder. Sie ben�tigt ein OFFsite Backup !
 import.sh liest die Datei der MV, gleicht sie mit der companion db ab
   und schreibt eine liste der regkeys f�r den n�chsten schritt

Danach mu� (entsprechend der letzten Melduzng von import.sh) util.import_members
(Teil von Piratefeedback) ausgef�hrt werden, um die regkeys zu importieren
bzw accounts zu deaktivieren.

 mail.sh Schickt den heute importierten Mitgliedern, eine Mail mit Ihrem Registrierungsschl�ssel

Achtung ! Alle Scripte vorher mal durchlesen bevor man sie in Produktion ausf�hrt.
Da ist das eine oder andere hartcodiert, was man vielleicht �ndern m�chte.

