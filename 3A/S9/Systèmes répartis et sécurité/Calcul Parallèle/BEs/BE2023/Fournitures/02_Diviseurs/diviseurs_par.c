#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>

#define couleur(param) printf("\033[%sm", param)

// fonction calculant le nombre de diviseurs d'un entier (1 exclu)
int primes(int n) 
{
  int nb_divisors, i;

  nb_divisors = 1;
  for (i = 2; i <= n / 2; i++)
  {
    if (n % i == 0) {
      // printf("%d divise %d\n", i, n);
      nb_divisors++;
    }
  }
  return nb_divisors;
}

int main(int argc, char *argv[]) {

  if (argc != 2) {
    couleur("31");
    printf("usage : diviseurs_par <borne sup> \n");
    couleur("30");
    return EXIT_FAILURE;
  }

  // plus grand entier considéré
  int n = atoi(argv[1]);

  // variables MPI
  int my_rank, size;
  // variables pour prendre le temps global
  double start, stop;

  // Initialisation de MPI
  MPI_Init(NULL, NULL);

  // Récupération des informations MPI
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  // le nombre de processus doit diviser la borne sup de l'intervalle de recherche
  if (n % size != 0) {
    couleur("31");
    printf("Cette application doit s'exécuter avec un nombre de processus MPI qui divise %d\n", n);
    couleur("30");
    MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE);
  }

  // nombre ayant le plus de diviseurs et ce nombre max de diviseurs
  int local_nb_max, local_max;
  int range_start,range_end;
  range_start=my_rank*(n/size)+1;
  range_end=(my_rank+1)*(n/size);
  
  local_max = 1;
  local_nb_max = 1;
  
  // prise du temps total par le processeur 0
  if (my_rank == 0) {
    start = MPI_Wtime();
  }
  

  // prise de temps de chaque processus
  double p_time_start = MPI_Wtime();

  for (int i = range_start; i <= range_end; i++) {
    int nb = primes(i);
    // printf("[%d] le nombre de diviseurs de %d est %d\n", my_rank, i, nb);
    if (nb > local_max) {
      local_max = nb;
      local_nb_max = i;
    }
  }


  // durée calcul processus
  double p_time_stop = MPI_Wtime();
  double p_time = p_time_stop - p_time_start;
  printf("\n[%d] mon plus petit nombre qui possède le plus de diviseurs (%d) est %d - temps %e\n", my_rank, local_max, local_nb_max, p_time);
    int *all_local_max = malloc(size * sizeof(int));
  int *all_local_nb_max = malloc(size * sizeof(int));
  int global_max, global_nb_max;
  global_max = 0;
  global_nb_max = 0;
  MPI_Allgather(&local_max, 1, MPI_INT, all_local_max, 1, MPI_INT, MPI_COMM_WORLD);
  MPI_Allgather(&local_nb_max, 1, MPI_INT, all_local_nb_max, 1, MPI_INT, MPI_COMM_WORLD);  
  // le zéro termine la prise du temps total
  if (my_rank == 0) {
    for (int i = 0; i < size; i++) {
      if (all_local_max[i] > global_max) {
        global_max = all_local_max[i];
        global_nb_max = all_local_nb_max[i];
      }
    }
    stop = MPI_Wtime();
    printf("temps total %e\n", stop - start);
  }
  
  MPI_Bcast(&global_max, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast(&global_nb_max, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Barrier(MPI_COMM_WORLD);
  printf("\n[%d] le nombre qui possède le plus de diviseurs est %d (%d)\n", my_rank, global_nb_max, global_max);

  MPI_Finalize();

  return 0;
}