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
# Port série
import serial
# Plot
import matplotlib.pyplot as plt
import numpy as np

### Methods

def serial_ports():
    """Lists serial ports
    :returns:
        A list of available serial ports
    """

    ports = ['COM' + str(i + 1) for i in range(256)]
    result = []
    for port in ports:
        try:
            s = serial.Serial(port)
            s.close()
            result.append(port)
        except (OSError, serial.SerialException):
            pass
    return result

def ouvrir_port():
    """Ouverture d'un port COM"""
    print("Opening " + liste_portsCom.get(ACTIVE) + "...")
    try:
        global serialPortOpened
        serialPortOpened = serial.Serial(liste_portsCom.get(ACTIVE))
        #test = serialPortOpened.read(1)
        #print(test)
        #if test == b'S':
        #    print("ok")
        if serialPortOpened.isOpen():
            label_portOpened.config(text="Opened", fg="green")
            bouton_Start.config(state="normal")
        else:
            label_portOpened.config(text="Closed", fg="red")
            bouton_Start.config(state="disabled")
    except (OSError, serial.SerialException):
            label_portOpened.config(text="Closed", fg="red")
            bouton_Start.config(state="disabled")
            pass

def start():
    """Lancement du décodage (appui sur "entrée" ou click sur le bouton)
    """
    plt.close()
    serialPortOpened.flushInput()
    nomOut = str(dt.datetime.today().hour) + "h"
    nomOut += str(dt.datetime.today().minute) + "m"
    nomOut += str(dt.datetime.today().second) + "s_"
    nomOut += str(ligne_nomOutput.get())
    lecture(nomOut)
    
def lecture(nomOut):
    """Lecture sur le port série
    """
    global serialPortOpened
    global nbSamples
    
    if not serialPortOpened.isOpen:
        return -1

    if saveFileOn.get():
        print("Opening " + nomOut + ".txt")
        out = open(nomOut + ".txt", "w")

    print("Start reading on COM port...")
    valeursB1 = list()
    valeursB2 = list()
    valeursB3 = list()
    valeursB4 = list()
    valeurs = list()#[valeursB1, valeursB2, valeursB3, valeursB4]
    try:
        for i in range (int(nbSamples.get())):            
            octets = serialPortOpened.read(2)           # Lecture de 1 octets
            val = 0
            for byte in range(2):
                #print(str(byte) + ": " + str(int(octets[byte+4*beacon])))
                val += int(octets[byte]) << (8 * byte)
            #if val > 1e8:
            #    val = -1
            valeurs.append(val)              # Enregistrement en mémoire
                #print(val)
            if saveFileOn.get():
                out.write(str(val) + " ")
        if saveFileOn.get():
            out.write("\n")

        if saveFileOn.get():
            out.close()

        if plotOn.get():
            print("Plotting...")
            plt.plot(valeurs, 'x-')
            plt.legend(["DMA output"])
            plt.title("Output of the four filters from each beacon")
            plt.xlabel("Time (samples of 2ms)")
            plt.ylabel("Output value of the filters")
            
            
        if savePlotOn.get():
            print("Saving picture...")
            plt.savefig(nomOut + ".png")
        print("Done !")
        if plotOn.get():
            plt.show()

    except IOError:
            # Handler d'erreur
            pass
        
    #finally:
    #    if not saveFileOn.get():
    #        os.remove(nomOut + ".txt")
    
### Création de la fenêtre racine de l'interface

# Fenetre
fenetre = Tk()

# Global variables

serialPortOpened = serial.Serial()

# Frame Port
framePort = Frame(fenetre, relief=RAISED, borderwidth=1)
framePort.pack(fill=BOTH, expand=1)

# Frame Save
frameSave = Frame(fenetre, relief=RAISED, borderwidth=1)
frameSave.pack(fill=BOTH, expand=1)

# Frame Decode
frameDecode = Frame(fenetre, relief=RAISED, borderwidth=1)
frameDecode.pack(fill=BOTH, expand=1)

### Frame Port

# Label demandant le port COM
label_choosePort = Label(framePort, text="Serial COM port :")

# Liste déroulante contenant les ports
portsCom = serial_ports()
selectedPort = StringVar()
liste_portsCom = Listbox(framePort, height=2, )
for port in portsCom:
    liste_portsCom.insert(END,port)
    
# Bouton d'ouverture du port
bouton_openPort = Button(framePort, text="Open", command=ouvrir_port)

# Label indiquant la bonne ouverture
label_portOpened = Label(framePort, text="Closed", fg="red")

# Packing
label_choosePort.pack(side=LEFT, padx=5, pady=5)
liste_portsCom.pack(side=LEFT, padx=5, pady=5)
bouton_openPort.pack(side=LEFT, padx=5, pady=5)
label_portOpened.pack(side=LEFT, padx=5, pady=5)

### Frame Save

# Un label demande le nom de l'enregistrement
label_nomFichier = Label(frameSave, text="Save under ")
label_extension = Label(frameSave, text=".txt/.png")

# Ligne de réception du nom avec focus
nomOutput = StringVar()
ligne_nomOutput = Entry(frameSave, textvariable=nomOutput, width=35, justify=RIGHT)

# Packing
label_nomFichier.pack(side=LEFT, padx=5, pady=5)
ligne_nomOutput.pack(side=LEFT, padx=0, pady=5)
label_extension.pack(side=LEFT, padx=0, pady=5)

### Frame Decode

# Nombre d'échantillons
nbSamples = StringVar()
ligne_nbSamples = Entry(frameDecode, textvariable=nbSamples, width=6, justify=RIGHT)
ligne_nbSamples.insert(0, "650")
label_samples = Label(frameDecode, text="samples ")

# Options en checkbox
plotOn = IntVar()
savePlotOn = IntVar()
saveFileOn = IntVar()
checkButtPlotOn = Checkbutton(frameDecode, text="Plot", variable=plotOn)
checkButtPlotOn.select()
checkButtSavePlotOn = Checkbutton(frameDecode, text="Autosave plot", variable=savePlotOn)
checkButtSaveFileOn = Checkbutton(frameDecode, text="Save Ascii file", variable=saveFileOn)

# Packing
ligne_nbSamples.pack(side=LEFT, padx=2, pady=5)
label_samples.pack(side=LEFT, padx=0, pady=5)
checkButtPlotOn.pack(side=LEFT, padx=7, pady=5)
checkButtSavePlotOn.pack(side=LEFT, padx=7, pady=5)
checkButtSaveFileOn.pack(side=LEFT, padx=7, pady=5)

### Fenetre

# Boutons de lancement et d'arrêt
bouton_Start = Button(fenetre, text="Start", command=start)
bouton_Start.config(state="disabled")
bouton_Close = Button(fenetre, text="Close", command=fenetre.quit)
bouton_Close.pack(side=RIGHT, padx=5, pady=5)
bouton_Start.pack(side=RIGHT, padx=5, pady=5)

# On démarre la boucle Tkinter qui s'interompt quand on ferme la fenêtre
fenetre.mainloop()

