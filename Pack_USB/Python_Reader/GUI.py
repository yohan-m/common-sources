"""GUI d'acquisition sous realterm.

Après une acquisition, un fichier capture.txt est créé.
Cette interface demande le nom de l'acquisition (exemple : vol_agite_2).
Le programme va transformer les valeurs binaires du fichier source.
Les valeurs décodées seront :
- Enregistrées en ASCII dans XXhYYmZZs_vol_agite_2.txt
- Plottées
- Le graphique plotté sera enregistré dans XXhYYmZZs_vol_agite_2.png
"""

# -*-coding:Latin-1 -*

# GUI
from tkinter import *
# Heure
import datetime as dt
# Fichiers
import os
# Plot
import matplotlib.pyplot as plt
import numpy as np

def lancerEntree(event):
    """Lancement de l'operation sur appui de la touche "entrée"
    """
    lancement()

def lancement():
    """Lancement du décodage (appui sur "entrée" ou click sur le bouton)
    """
    nomOut = str(dt.datetime.today().hour) + "h"
    nomOut += str(dt.datetime.today().minute) + "m"
    nomOut += str(dt.datetime.today().second) + "s_"
    nomOut += str(ligne_nomOutput.get())
    decoder(nomOut)

def decoder(nomOut):
    """Décodage du fichier capture.txt
    """
    print("Opening capture.txt...")
    capture = open("capture.txt", "rb")
    print("Opening " + nomOut + ".txt")
    out = open(nomOut + ".txt", "w")

    print("Start of conversion...")
    valeurs = list()
    try:
        while True:
            octets = capture.read(4)    # Lecture de 4 octets
            if len(octets) != 4:        # Vérification fin de fichier
                break;
            val  = int(octets[0]) << 0  # Conversion en 32 bits
            val += int(octets[1]) << 8
            val += int(octets[2]) << 16
            val += int(octets[3]) << 24
            valeurs.append(val)         # Enregistrement en mémoire
            out.write(str(val) + " ")


        if plotOn.get():
            print("Plotting...")
            plt.plot(valeurs)
        if savePlotOn.get():
            print("Saving picture...")
            plt.savefig(nomOut + ".png")
        print("Done !")
        if plotOn.get():
            plt.show()

    except IOError:
            # Handler d'erreur
            pass
        
    finally:
        capture.close()
        out.close()
        if not saveFileOn.get():
            os.remove(nomOut + ".txt")
    

    
# Création de la fenêtre racine de l'interface
fenetre = Tk()
frame = Frame(fenetre, relief=RAISED, borderwidth=1)
frameWrite = Frame(frame)

# Un prompt demande le nom de l'enregistrement
label_nomFichier = Label(frameWrite, text="Save under ")
label_extension = Label(frameWrite, text=".txt/.png")

# Ligne de réception du nom avec focus et déclenchement du décodage par <Enter>
nomOutput = StringVar()
ligne_nomOutput = Entry(frameWrite, textvariable=nomOutput, width=35, justify=RIGHT)
ligne_nomOutput.bind("<Return>", lancerEntree)
ligne_nomOutput.focus_set()
# Options en checkbox
plotOn = IntVar()
savePlotOn = IntVar()
saveFileOn = IntVar()
checkButtPlotOn = Checkbutton(frame, text="Plot", variable=plotOn)
checkButtPlotOn.select()
checkButtSavePlotOn = Checkbutton(frame, text="Autosave plot", variable=savePlotOn)
checkButtSaveFileOn = Checkbutton(frame, text="Save Ascii file", variable=saveFileOn)
# Bouton de lancement et d'arrêt
bouton_Decode = Button(fenetre, text="Decode", command=lancement)
bouton_Close = Button(fenetre, text="Close", command=fenetre.quit)

# On affiche les widgets dans la fenêtre
frame.pack(fill=BOTH, expand=1)
frameWrite.pack(fill=BOTH, expand=1)
label_nomFichier.pack(side=LEFT, padx=5, pady=5)
ligne_nomOutput.pack(side=LEFT, padx=0, pady=5)
label_extension.pack(side=LEFT, padx=0, pady=5)
checkButtPlotOn.pack(side=LEFT, padx=20, pady=5)
checkButtSavePlotOn.pack(side=LEFT, padx=20, pady=5)
checkButtSaveFileOn.pack(side=LEFT, padx=20, pady=5)
bouton_Close.pack(side=RIGHT, padx=5, pady=5)
bouton_Decode.pack(side=RIGHT, padx=5, pady=5)

# On démarre la boucle Tkinter qui s'interompt quand on ferme la fenêtre
fenetre.mainloop()


    
