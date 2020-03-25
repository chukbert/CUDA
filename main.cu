#include <iostream>
#include <math.h>

void Dijkstra(int src);
// Kernel function to add the elements of two arrays
__global__
void Dijkstra(int src) {
    int dist[V + 5];
	int sptSet[V + 5];

	for (int i = 0; i < V; i++) 
		dist[i] = INT_MAX, sptSet[i] = 0; 

	dist[src] = 0; 

	for (int count = 0; count < V - 1; count++) { 
		int min = INT_MAX, min_index; 
        for (int v = 0; v < V; v++) 
            if (sptSet[v] == 0 && dist[v] <= min) 
                min = dist[v], min_index = v;
        int u = min_index; 
 
		sptSet[u] = 1; 

		for (int v = 0; v < V; v++) 
			if (!sptSet[v] && graph[u][v] && dist[u] != INT_MAX 
				&& dist[u] + graph[u][v] < dist[v]) 
				dist[v] = dist[u] + graph[u][v]; 
	}

	for (int i=0; i<V; i++) {
        hasil_gabung[src][i] = dist[i];
    }
}


void add(int n, float *x, float *y)
{
  for (int i = 0; i < n; i++)
    y[i] = x[i] + y[i];
}


int main(void)
{
  int N = 1<<20;
  float *x, *y;

    // Allocate Unified Memory – accessible from CPU or GPU
    cudaMallocManaged(&x, N*sizeof(float));
    cudaMallocManaged(&y, N*sizeof(float));

    // initialize map
    srand(13517093);
    for(int i = 0;i<V;i++) {
        graph[i][i] = 0;
        for(int j = i+1;j<V;j++) {
            graph[i][j] = rand() % 23;
            if(graph[i][j] == 0) graph[i][j] = 1;
            graph[j][i] = graph[i][j];
        }
    }


  // Run kernel on 1M elements on the GPU
    dijkstra<<<1, 1>>>(N, x, y);

  // Wait for GPU to finish before accessing on host
  cudaDeviceSynchronize();

  // Check for errors (all values should be 3.0f)
  float maxError = 0.0f;
  for (int i = 0; i < N; i++)
    maxError = fmax(maxError, fabs(y[i]-3.0f));
  std::cout << "Max error: " << maxError << std::endl;

  // Free memory
  cudaFree(x);
  cudaFree(y);
  
  return 0;
}