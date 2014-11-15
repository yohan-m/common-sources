Pour utiliser le script Decode.py :
- Aller dans le dossier Python Lib et suivre les instructions.
- Copier le script dans le dossier qui contiendra le fichier "capture.txt"
- Double cliquer sur le script pour le lancer
- A chaque fois qu'on fait une nouvelle acquisition sous realterm (mode binaire) il suffit de rentrer le nom de l'acquisition et d'appuyer sur <entrée>.
- Automatiquement le script va faire la conversion depuis le fichier capture.txt, puis va :
	* Créer un fichier XXhYYmZZs_votreNom.txt contenant la traduction en ascii du fichier capture.txt
	* Enregistrer une figure Matlab en XXhYYmZZs_votreNom.png
	* Affichera également la figure pour un rendu rapide
- Pour une nouvelle acquisition, il suffit de fermer la figure.