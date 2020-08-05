#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <complex.h>
#define pi 3.1416
#define ORIGEN "..\\tono 100.txt"
#define DESTINO "..\\TFtono 100.txt"
int TamanoArch(char *c);
float *CargaArch(char *c, int *NN);
int EscribeTXT(char *c, float *A, int N);
int transformada(float *datos, int cantpuntos);
//-------------------MAIN-------------------------------
int main(void)
{
	int n = 0;
	float *A;
	int cantpuntos = 64;	   //cantidad de puntos transformada
	A = CargaArch(ORIGEN, &n); //cargo archivo
	if (A == NULL)
	{
		puts("hubo un error en la lectur A es NULL");
		return -11;
	}
	else
	{
		puts("Archivo cargado con exito\n\n");
	}
	if (transformada(A, cantpuntos) < 0)
	{ //calcula la transformada
		puts("hubo error en la transformada");
		return -12;
	}
	else
	{
		puts("Archivo exportado con exito\n\n");
	}
	system("pause");
	return (0);
} //end main
//--------------------FUNCIONES------------------------
int TamanoArch(char *c)
{
	FILE *arch;
	float d;
	int N = 0;
	arch = fopen(c, "r");
	if (arch == NULL)
	{
		puts("No se abrio el archivo");
		return -1;
	}
	while (!feof(arch))
	{
		fscanf(arch, "%f", &d);
		N++;
	} //end while
	fclose(arch);
	return (N - 1);
} // end tamano archivo
float *CargaArch(char *c, int *NN)
{
	FILE *arch;
	int N, i = 0;
	float *A;
	N = TamanoArch(c);
	*(NN) = N;
	if (N < 0)
	{
		puts("Hubo un error en el tamano de la lectura");
		return NULL;
	}
	A = (float *)malloc(N * sizeof(float)); // fabrico arreglo de tamano deseado
	if (A == NULL)
		return NULL;
	arch = fopen(c, "rt");
	//--------------lectura
	while (!feof(arch))
	{
		fscanf(arch, "%f", &A[i]);
		i++;
	} //end while feof
	fclose(arch);
	return A;
} //end carga archivo
int EscribeTXT(char *c, float *A, int N)
{
	FILE *arch;
	int i = 0;
	arch = fopen(c, "wt");
	if (arch == NULL)
	{
		puts("Error al abrir archivo de escritura");
		return (-1);
	}
	for (i = 0; i < N; i++)
	{
		//printf("\nDato %d: %f",i+1,A[i]);
		fprintf(arch, "%f\n", A[i]);
	} //end while feof
	fclose(arch);
	return (1);
} // end escribe txt
int transformada(float *A, int N)
{
	int k = 0, n = 0;
	float Im = 0, Re = 0;
	float *X;
	X = (float *)calloc(N - 1, sizeof(float));
	if (X == NULL)
		return -2;
	for (k = 0; k < N; k++)
	{
		for (n = 0; n < (N); n++)
		{
			Im = (float)(Im + A[n] * (sin((-2 * pi * n * k) / N)));
			Re = (float)(Re + A[n] * (cos((-2 * pi * n * k) / N)));
		} //end for n
		//X[k]=abs(Im+Re);
		//X[k]=(float)sqrt((Im*Im)+(Re*Re));
		X[k] = sqrt(pow(Re, 2) + pow(Im, 2)); //Calcula la transformada discreta de Fourier
		Im = 0;
		Re = 0;
	} //end for k
	return EscribeTXT(DESTINO, X, N - 1);
}