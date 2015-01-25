Deux scripts sont possibles :
- File_Ready.py : Lecture d'un fichier binaire et traduction dans un fichier en ascii.
- Serial_coefficients_reader : Lecture de 4 coefficients non signés sur 32 bits et possibilité d'enregistrer le fichier en ascii, d'afficher un graphique et d'enregistrer ce même grpahique automatiquement. Il est possible et facile en regardant rapidement le code de n'enregistrer qu'un seul coefficient sur 32bits (ou moins) à la fois.

Pour utiliser les scripts :
- Aller dans le dossier Python Lib et suivre les instructions pour installer les dépendances Python nécessaires.
- Pour que le file reader fonctionne : copier le script dans le dossier qui contiendra le fichier "capture.txt"
- Double cliquer sur le script pour le lancer. Faire un clic droit "Editer with Idle" pour le modifier.
- Pour que le serial reader fonctionne : choisir un port série sur lequel lire, cliquer sur "ouvrir" puis choisir le nombre de samples et enfin lancer l'acquisition
- Automatiquement le script va faire la conversion depuis le fichier capture.txt ou depuis le port série choisi, puis peut :
	* Créer un fichier XXhYYmZZs_votreNom.txt contenant la traduction en ascii du fichier capture.txt ou du contenu du port série
	* Enregistrer une figure Matlab en XXhYYmZZs_votreNom.png
	* Afficher également la figure pour un rendu rapide
- Pour une nouvelle acquisition, il suffit de fermer la figure.