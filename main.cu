#include <iostream>
#include <math.h>
#include <time.h>

using namespace std;

// Kernel function to add the elements of two arrays
__global__
void dijkstra(int N, int *hasil_gabung, int *graph)
{
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for (int src = index; src < N; src += stride){
    const int N_const = N;
    int dist[106]; // Ganti ini juga sesuai dengan nilai N 
    int sptSet[106]; // Ganti ini juga sesuai dengan nilai N

    for (int i = 0; i < N; i++) 
      dist[i] = INT_MAX, sptSet[i] = 0; 

    dist[src] = 0; 

    for (int count = 0; count < N - 1; count++) { 
      int min = INT_MAX, min_index; 
      for (int v = 0; v < N; v++) 
        if (sptSet[v] == 0 && dist[v] <= min) min = dist[v], min_index = v;
      int u = min_index; 
  
      sptSet[u] = 1; 

      for (int v = 0; v < N; v++) 
        if (!sptSet[v] && graph[u*N+v] && dist[u] != INT_MAX 
          && dist[u] + graph[u*N+v] < dist[v]) 
          dist[v] = dist[u] + graph[u*N+v]; 
    }

    for (int i=0; i<N; i++) {
          hasil_gabung[src*N+i] = dist[i];
      }
    }
}

