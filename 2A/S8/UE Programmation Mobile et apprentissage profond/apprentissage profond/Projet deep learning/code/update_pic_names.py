import os
import sys

def rename_photos(nomfolder, ensdonnees):
    repertoire = f"/home/zaid/Bureau/S8/ProjectDL/data/{ensdonnees}/{nomfolder}"
    extension = "jpg"

    # Check if the directory exists
    if os.path.exists(repertoire) and os.path.isdir(repertoire):
        os.chdir(repertoire)

        # List photos in the directory
        photos = [f for f in os.listdir(repertoire)]

        # Sort photos based on the index after '_'
        photos_sorted = sorted(photos, key=lambda x: int(x.split('_')[1].split('.')[0]))

        # Initialize index
        index = 1

        # Rename each photo
        for ancien_nom in photos_sorted:
            nouvel_nom = f"{nomfolder}_{index}.{extension}"
            os.rename(ancien_nom, nouvel_nom)
            index += 1

        print("Renaming completed.")
    else:
        print(f"The directory {repertoire} does not exist.")

# Vérifie si des arguments ont été fournis en ligne de commande
if len(sys.argv) > 2:
    # Récupère le premier argument passé en ligne de commande
    nom_du_dossier = sys.argv[1]
    ensemble_donnees = sys.argv[2]

    # Appelle la fonction avec le nom du dossier récupéré
    rename_photos(nom_du_dossier, ensemble_donnees)
else:
    print("Veuillez fournir le nom du dossier en argument lors de l'exécution.")

