//Juan Agustin Avila
// Julio 2020
//Reg 26076 - ELO

//TODO: comprobar que el offset y la cantidad de puntos
//TODO: no exceda el largo total del archivo

#include <unistd.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <stdlib.h>
//#include <stdin.h>
//#include <math.h>
#define pi 3.14159265

FILE *abrir_archivo(char modo[], char nombre[], char extra[]) //abre los archivos en el modo indicado, se le puede agregar un sufijo al nombre
{
    FILE *archivo;
    char string[150];
    char cwd[PATH_MAX];
    getcwd(cwd, sizeof(cwd));                                             //obtiene el directorio donde se esta ejecutando
    snprintf(string, sizeof(string), "%s\\%s%s.txt", cwd, nombre, extra); //siguen el patron original, solo les cambia el numero
    archivo = fopen(string, modo);
    if (archivo == NULL)
    {
        printf("No se pudo abrir el archivo \"%s%s.txt\"\n", nombre, extra); //no tiene mucho sentido porque no hace nada
    }
    return archivo;
}
void transformada(FILE *archivo_original, int offset, int N, char nombre[])
// Los argumentos son: *archivo_original es el archivo a analizar
// offset es un offset a partir del cual se toman los datos
// N es la cantidad de puntos con los cuales realiza la transformada
// nombre es el nombre del archivo original
{
    float x[N], freq, salida = 0;
    int k = 0, n = 0;
    float Im = 0, Re = 0;
    FILE *archivo_nuevo;
    char extra[50];
    snprintf(extra, sizeof(extra), "_Transformada%dPuntos", N);
    archivo_nuevo = abrir_archivo("w+", nombre, extra); //abre un nuevo archivo
    fscanf(archivo_original, "%f\n", &freq);            //obtiene la frecuencia
    fprintf(archivo_nuevo, "%.1f\n", freq);             //y la guarda en el nuevo
    for (n = 0; n < offset; n++)
    {
        x[0] = 0;
        fscanf(archivo_original, "%f\n", &x[0]); //lee el arreglo con los valores
    }
    for (n = 0; n < N; n++)
    {
        x[n] = 0;
        fscanf(archivo_original, "%f\n", &x[n]); //guarda los valores en el arreglo
    }

    //a partir de este punto es la transformada propiamente dicha
    for (k = 0; k < N; k++)
    {
        for (n = 0; n < N; n++)
        {
            Im = (Im + x[n] * (sin((2 * pi * n * k) / N))); //realiza el calculo
            Re = (Re + x[n] * (cos((2 * pi * n * k) / N)));
        }
        salida = sqrt(pow(Re, 2) + pow(Im, 2));
        fprintf(archivo_nuevo, "%.2f\n", salida); //guarda el resultado en el archivo
        Im = 0;
        Re = 0;
    }
    fclose(archivo_nuevo); //cierra el archivo nuevo
    rewind(archivo_original);
}
int main(int argc, char *argv[])
{

    int N, offset;
    FILE *arch;
    if (argc == 4)
    {
        N = atoi(argv[2]);
        offset = atoi(argv[3]);
        printf("Se calculara la TDF del archivo %s con %d muestras y un offset de %d\n", argv[1], N, offset);
    }
    else if (argc > 4)
    {
        printf("Demasiados argumentos.\n");
        return (1);
    }
    else
    {
        printf("No se pasaron suficientes argumentos.\n\n");
        printf("El programa se debe correr de la siguiente manera:\n");
        printf("DSP3.exe archivo_a_analizar cant_muestras offset\n");
        printf("Por ejemplo para el archivo \"Tono_50Hz.txt\" con 16 muestras y un offset de 200:\n");
        printf("\"DSP3.exe Tono_50Hz 16 200\"\n");
        printf("(No se debe incluir la terminacion .txt del archivo)\n");
        return (1);
    }
    arch = abrir_archivo("r", argv[1], ""); //abre archivo
    transformada(arch, offset, N, argv[1]);
    fclose(arch);
    printf("Transformada calculada con exito.\n");
}