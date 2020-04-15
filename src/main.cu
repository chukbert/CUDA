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
    int dist[110]; // Ganti ini juga sesuai dengan nilai N 
    int sptSet[110]; // Ganti ini juga sesuai dengan nilai N

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


int main(int argc, char** argv)
{
  int N = stoi(argv[1]);
  int *hasil_gabung;
  int *graph;

  cudaMallocManaged(&hasil_gabung, N*N*sizeof(int));  
  cudaMallocManaged(&graph, N*N*sizeof(int));

  srand(13517093);
  for(int i = 0;i<N;i++) {
      graph[i*N+i] = 0;
      for(int j = i+1;j<N;j++) {
          graph[i*N+j] = rand() % 23;
          if(graph[i*N+j] == 0) graph[i*N+j] = 1;
          graph[j*N+i] = graph[i*N+j];
      }
  }
  struct timeval start, end;
  // gettimeofday(&start, NULL);
  
  int blockSize = stoi(argv[2]);  
  int numBlocks = (N + blockSize - 1) / blockSize;

  clock_t tStart = clock();
  dijkstra<<<numBlocks , blockSize>>>(N, hasil_gabung, graph);

  cudaDeviceSynchronize();

  //for (int i = 0;i < N;i++) {
    // for (int j = 0;j < N; j++) {
      // cout << graph[i*N+j];
       // if(j != N-1) {
         // cout << " ";
      // }
     //}
     //cout << endl;
  // }

  cout << "------DIJKSTRA-------" << endl;

   for (int i = 0;i < N;i++) {
     for (int j = 0;j < N; j++) {
       cout << hasil_gabung[i*N+j];
         if(j != N-1) {
            cout << " ";
          }
     }
     cout << endl;
  }
  // gettimeofday(&end, NULL);

  // double delta = ((end.tv_sec  - start.tv_sec) * 1000000u + end.tv_usec - start.tv_usec) / 1.e6;
  // printf("Time execution : %lf", delta);
  printf("Time taken: %.2f microsekon\n", (double)(clock() - tStart)/CLOCKS_PER_SEC*1000000 );
  // https://www.geeksforgeeks.org/clock-function-in-c-c/
  // Free memory
  cudaFree(hasil_gabung);
  cudaFree(graph);
  
  return 0;
}