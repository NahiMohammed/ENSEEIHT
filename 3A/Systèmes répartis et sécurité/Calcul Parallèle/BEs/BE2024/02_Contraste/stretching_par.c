#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include "stretching_util.h"

#define M 255

int main(int argc, char** argv) {
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank); 
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    const char* filename = "Maupiti.jpg";
    int nblines = 0, nbcolumns = 0, nbpixels, local_nbpixels;
    int *pixels = NULL, *local_pixels = NULL;
    int local_pix_min, local_pix_max, global_pix_min, global_pix_max;
    float alpha;
    // Début chargement de l'image 
    // (en parallèle, seul le processus 0 fera cette action)
    if (rank == 0) {
        printf("Appuyez sur une touche...\n");
        // récupération de la taille de l'image
        getImageDimensions(filename, &nblines, &nbcolumns);

        // nombre de pixels (en parallèle seul le processus 0 aura cette information)
        nbpixels = nblines * nbcolumns;
    }

    // Diffuser les dimensions de l'image
    MPI_Bcast(&nblines, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&nbcolumns, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Barrier(MPI_COMM_WORLD);
    nbpixels = nblines * nbcolumns;
    local_nbpixels = nbpixels / size;

    // Allocation mémoire pour la portion locale des pixels
    local_pixels = (int*) malloc(local_nbpixels * sizeof(int));
    if (local_pixels == NULL) {
        printf("Erreur : allocation mémoire échouée.\n");
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    // Processus 0 Alloue de la mémoire pour le tableau et les distribue
    if (rank == 0) {
        pixels = (int*) malloc(nbpixels * sizeof(int));
        if (pixels == NULL) {
            printf("Erreur : allocation mémoire échouée.\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }
        fillPixels(filename, pixels, nblines, nbcolumns);
    }
    // Fin du chargement de l'image

    
    MPI_Scatter(pixels, local_nbpixels, MPI_INT, local_pixels, local_nbpixels, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Barrier(MPI_COMM_WORLD);


    // Calcul local des min et max  locaux
    local_pix_min = local_pixels[0];
    local_pix_max = local_pixels[0];
    for (int i = 1; i < local_nbpixels; i++) {
        if (local_pixels[i] < local_pix_min) local_pix_min = local_pixels[i];
        if (local_pixels[i] > local_pix_max) local_pix_max = local_pixels[i];
    }

    // Réduction pour obtenir le min et le max globaux
    MPI_Reduce(&local_pix_min, &global_pix_min, 1, MPI_INT, MPI_MIN, 0, MPI_COMM_WORLD);
    MPI_Reduce(&local_pix_max, &global_pix_max, 1, MPI_INT, MPI_MAX, 0, MPI_COMM_WORLD);

    // Calcul de alpha par le processus 0 et diffusion
    if (rank == 0) {
        alpha = 1 + (float)(global_pix_max - global_pix_min) / M;
    }
    MPI_Bcast(&alpha, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);

    // Étirement du contraste pour tous les pixels avec la méthode choisie
    // (en parallèle, processus pairs => f_one, processus impairs => f_two)
    for (int i = 0; i < local_nbpixels; i++) {
        if (rank % 2 == 0) {
            local_pixels[i] = f_one(local_pixels[i], alpha);
        } else {
            local_pixels[i] = f_two(local_pixels[i], alpha);
        }
    }

    // Rassemblement des résultats
    MPI_Gather(local_pixels, local_nbpixels, MPI_INT, pixels, local_nbpixels, MPI_INT, 0, MPI_COMM_WORLD);

     // Sauvegarde de l'image (en parallèle seul le processus 0 effectuera cette action)
    if (rank == 0) {
        printf("Appuyez sur une touche...\n");
        saveImage(pixels, nblines, nbcolumns, "image-grey2-stretched.png");
        free(pixels);
    }

    free(local_pixels);
    MPI_Finalize(); // Finalisation MPI

    return 0;
}
