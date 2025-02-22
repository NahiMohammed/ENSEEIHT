#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>

#define couleur(param) printf("\033[%sm", param)

int main(int argc, char *argv[])
{

  int depth;
  int my_rank, size;
  MPI_Status status;
  int parent, left, right;
  int value;

  parent = left = right = 99;
  
  if (argc != 2)
  {
    couleur("31");
    printf("usage : bintree_leavesD <depth>\n");
    couleur("0");
    return EXIT_FAILURE;
  }

  couleur("34");

  depth = atoi(argv[1]);
  //printf("depth = %d\n", depth);

  // MPI Initialization
  MPI_Init(NULL, NULL);

  // Get number of processes
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  if (size != pow(2, depth) - 1)
  {
    couleur("31");
    printf("This application is meant to be run with a number of MPI processes coherent with the depth of the tree (#n == 2**depth-1)\n");
    couleur("0");
    MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE);
  }

  // determine my neighbors (parent node, left child, right child) according to my rank
  //
  parent = ((my_rank+1) >> 1)-1;
  left=((my_rank+1)<<1)-1;
  right=((my_rank+1)<<1);
  

  printf("my_rank = %d -- parent = %d -- left = %d -- right = %d\n", my_rank, parent, left, right);

  // my value
  value = my_rank;

  // The nodes, starting with leaves nodes transmit their value to their respective parents.
  //
  // The intermediate nodes receive the value of their children, multiply them and add their value
  // and transmit those values to their parent.
  //
  // Node 0 receives the two values of its children, multiplies them and prints it.
  //
  // At the end of the transmission (tree of depth 3), node 0 should print 416 = (3*4+1)*(5*6+2)
  //
  // Instruction: before each 'send' and after each 'receive', each node displays:
  //   - its rank
  //   - the type communication (send, recv)
  //   - the value
  //   - the correspondant
  
  int left_value, right_value;
  if (my_rank >= pow(2, depth - 1) - 1)
  {
    // I am a leaf
    // I send my value to my parent
    printf("Leaf %d -- send %d to %d\n", my_rank, value, parent);
    MPI_Send(&value, 1, MPI_INT, parent, 0, MPI_COMM_WORLD);
  }
  else if (my_rank != 0)
  {
    // I am an intermediate node
    // I receive the values of my children
    MPI_Recv(&left_value, 1, MPI_INT, left, 0, MPI_COMM_WORLD, &status);
    printf("Node %d -- recv %d from %d\n", my_rank, left_value, left);
    MPI_Recv(&right_value, 1, MPI_INT, right, 0, MPI_COMM_WORLD, &status);
    printf("Node %d -- recv %d from %d\n", my_rank, right_value, right);

    // I multiply the values of my children and add my value
    value = (left_value * right_value) + value;

    // I send the result to my parent
    printf("Node %d -- send %d to %d\n", my_rank, value, parent);
    MPI_Send(&value, 1, MPI_INT, parent, 0, MPI_COMM_WORLD);
  }
  else if (my_rank == 0)
  {
    // I am the root
    // I receive the values of my children
    MPI_Recv(&left_value, 1, MPI_INT, left, 0, MPI_COMM_WORLD, &status);
    printf("Root %d -- recv %d from %d\n", my_rank, left_value, left);
    MPI_Recv(&right_value, 1, MPI_INT, right, 0, MPI_COMM_WORLD, &status);
    printf("Root %d -- recv %d from %d\n", my_rank, right_value, right);

    // I multiply the values of my children and add my value
    value = (left_value * right_value) + value;

    // I print the result
    printf("Root %d -- value = %d\n", my_rank, value);
  }

  printf("The End\n");

  MPI_Finalize();

  couleur("0");

  return EXIT_SUCCESS;
}
