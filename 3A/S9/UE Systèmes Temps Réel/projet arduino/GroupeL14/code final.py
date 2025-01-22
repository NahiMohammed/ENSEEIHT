import sys
sys.path.append('/usr/lib/python3/dist-packages')
import cv2
from picamera2 import Picamera2
from PIL import Image
import pytesseract
import subprocess
import pyttsx3
import RPi.GPIO as GPIO
import time

import os

# Configuration GPIO
BUTTON_PIN = 17
GPIO.setmode(GPIO.BCM)
GPIO.setup(BUTTON_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

# Initialisation de la caméra
picam2 = Picamera2()
picam2.start_preview()  # Démarre un aperçu en direct
picam2.configure(picam2.create_still_configuration())  # Configuration pour la capture d'images
picam2.start()

def capture_image(image_path):
    """Capture une image avec Picamera2."""
    print(f"Capturing image to {image_path}...")
    picam2.capture_file(image_path)
    if not os.path.exists(image_path):
        raise FileNotFoundError(f"Error: Image file {image_path} not found!")
    print(f"Image saved to {image_path}")



def detect_text(image_path):
    """Détecte le texte dans une image."""
    print("Detecting text...")
    # Lire l'image
    img = cv2.imread(image_path)

    # Convertir en niveaux de gris pour améliorer la détection
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Appliquer un filtrage pour réduire le bruit
    gray = cv2.medianBlur(gray, 3)

    # Sauvegarder l'image pré-traitée (optionnel)
    preprocessed_path = "preprocessed_image.jpg"
    cv2.imwrite(preprocessed_path, gray)

    # Utiliser Tesseract pour détecter le texte
    text = pytesseract.image_to_string(Image.open(preprocessed_path))
    print("Text detected:")
    print(text)

    return text

def speak_text(text):
    """Lit le texte à haute voix en utilisant espeak."""
    print("Speaking text...")
    try:
        # Appeler espeak pour lire le texte
        subprocess.run(["espeak", text], check=True)
        print("Finished speaking.")
    except subprocess.CalledProcessError as e:
        print("Error during text-to-speech:", e)
        sys.exit(1)

if __name__ == "__main__":
    # Chemin pour sauvegarder l'image capturée
    image_path = "captured_image.jpg"

    try:
        while True:
            button_state = GPIO.input(BUTTON_PIN)
            #print("Waiting for button press...")
            # Attendre que le bouton soit pressé
            if button_state == GPIO.LOW:
                print("Button pressed!")

                # Étape 1 : Capture une image
                capture_image(image_path)

                # Étape 2 : Détecte le texte dans l'image
                detected_text = detect_text(image_path)

                # Étape 3 : Lire le texte à haute voix
                if detected_text.strip():
                    speak_text(detected_text)
                else:
                    print("No text detected.")

                # Petite pause pour éviter les rebonds du bouton
                time.sleep(0.5)

    except KeyboardInterrupt:
        print("Exiting program.")

    finally:
        GPIO.cleanup()