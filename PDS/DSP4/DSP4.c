//Juan Agustin Avila
//julio 2020
//Reg 26076 - ELO - FI UNSJ

//TODO: revisar como pasarle argumentos con getopt

#include <unistd.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <stdlib.h>

FILE *abrir_archivo(char modo[], char nombre[], char extra[]) //abre los archivos en el modo indicado, se le puede agregar un sufijo al nombre
{
	FILE *archivo;
	char string[150];
	char cwd[PATH_MAX];
	getcwd(cwd, sizeof(cwd));											  //obtiene el directorio donde se esta ejecutando
	snprintf(string, sizeof(string), "%s\\%s%s.txt", cwd, nombre, extra); //siguen el patron original, solo les cambia el numero
	archivo = fopen(string, modo);
	if (archivo == NULL)
	{
		printf("No se pudo abrir el archivo \"%s%s.txt\"\n", nombre, extra); //no tiene mucho sentido porque no hace nada
	}
	return archivo;
}

int contar_lineas(FILE *archivo)
{
	int n = 0;
	float numero;
	while (!feof(archivo))
	{
		fscanf(archivo, "%f\n", &numero);
		n++;
	}
	rewind(archivo);
	return n;
}

float *carga_filtro(FILE *archfiltro, int N, int offset)
{
	int i = 0;
	float *filtro = malloc(sizeof(float) * (N - offset));
	for (i = 0; i < offset; i++)
	{
		fscanf(archfiltro, "%f\n", &filtro[0]);
	}

	for (i = 0; i < (N - offset); i++)
	{
		fscanf(archfiltro, "%f\n", &filtro[i]);
		printf("%f\n", filtro[i]);
	}
	rewind(archfiltro);
	return filtro;
}

void filtrado(FILE *archivo_original, float num[], float den[], int N, char nombre[], char extra[])
{
	float entrada[N], freq, out = 0, salida[N];
	int k = 0;
	FILE *archivo_nuevo;
	archivo_nuevo = abrir_archivo("w+", nombre, extra); //abre un nuevo archivo
	fscanf(archivo_original, "%f\n", &freq);			//obtiene la frecuencia
	fprintf(archivo_nuevo, "%.1f\n", freq);				//y la guarda en el nuevo
	for (k = 0; k < N; k++)								//inicializa el arreglo
	{
		entrada[k] = 0; //coloca todos los valores en cero
		salida[k] = 0;
	}

	while (!feof(archivo_original)) //lee una nueva linea
	{
		out = 0;
		for (k = 1; k < N; k++)
		{
			entrada[k - 1] = entrada[k]; //desplaza los valores
			salida[k - 1] = salida[k];
		}
		salida[N - 1] = 0;	//en principio se pone en cero para que no se calcule
		fscanf(archivo_original, "%f", &entrada[N - 1]);
		for (k = 0; k < N; k++)
		{
			out = out + (num[k] * entrada[k]) - (den[k] * salida[k]); //realiza el calculo
		}
		salida[N - 1] = out;	//finalmente se asigna el valor de salida actual al arreglo
		fprintf(archivo_nuevo, "%.3f\n", out);
	}

	fclose(archivo_nuevo); //cierra el archivo nuevo
	rewind(archivo_original);
}

int main(int argc, char *argv[])
{

	int N, i;
	FILE *arch;
	FILE *filtroarch;
	float *denominador;
	//TODO: reemplazar argc por getopt
	if (argc == 3)
	{
		printf("Se aplicara el filtro %s a la senial %s\n", argv[1], argv[2]);
	}
	else if (argc > 3)
	{
		printf("Demasiados argumentos.\n");
		return (1);
	}
	else
	{
		printf("No se pasaron suficientes argumentos.\n\n");
		printf("El programa se debe correr de la siguiente manera:\n");
		printf("DSP3.exe filtro_a_aplicar archivo_a_analizar \n");
		printf("Por ejemplo para el archivo \"Tono_50Hz.txt\" con el filtro \"FiltroFIR_LP50Hz.txt\":\n");
		printf("\"DSP3.exe FiltroFIR_LP50Hz Tono_50Hz\"\n");
		printf("(No se debe incluir la terminacion .txt de los archivos)\n\n\n");
		printf("IMPORTANTE: el archivo de filtros debe tener la siguiente forma:\n");
		printf("b(n-5)\nb(n-4)\n...\nb(n)\n\nY si es IIR luego \n\na(n-5)\n...\na(n)");

		return (1);
	}
	filtroarch = abrir_archivo("r", argv[1], ""); //abre archivo del filtro
	arch = abrir_archivo("r", argv[2], "");		  //abre archivo de la señal
	N = contar_lineas(filtroarch);	//cuenta los valores del filtro

	/*ATENCION: supone siempre que el filtro es de cuarto orden, por lo tanto
	el numerador siempre tendra 5 terminos. Si es un filtro FIR, sus denominadores
	siempre seran 0, si es IIR los siguientes 5 valores del archivo del filtro seran
	el denominador. Por lo tanto, el archivo siempre debe tener 5 o 10 valores.
	Cualquier archivo con valores distintos a esto casi con seguridad fallará*/

	printf("Numerador: \n");
	float *numerador = carga_filtro(filtroarch, 5, 0);
	if (N == 5)
	{
		printf("Filtro FIR, no tiene denominador\n");
		for (i = 0; i < N; i++)
		{
			denominador[i] = 0;
		}
	}
	else
	{
		printf("Denominador:\n");
		denominador = carga_filtro(filtroarch, N, 5);
	}
	fclose(filtroarch);
	filtrado(arch, numerador, denominador, 5, argv[2], argv[1]);
	fclose(arch);
	printf("Filtro aplicado con exito.\n");
}