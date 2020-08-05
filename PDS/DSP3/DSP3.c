#include <unistd.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <stdlib.h>
//#include <stdin.h>
//#include <math.h>
#define pi 3.14159265

FILE *abrir_archivo(char modo[], int f, char extra[]) //abre los archivos en el modo indicado, se le puede agregar un sufijo al nombre
{
    FILE *archivo;
    char string[100];
    char cwd[PATH_MAX];
    getcwd(cwd, sizeof(cwd));                                               //obtiene el directorio donde se esta ejecutando
    snprintf(string, sizeof(string), "%s\\Tono_%dHz%s.txt", cwd, f, extra); //siguen el patron original, solo les cambia el numero
    archivo = fopen(string, modo);
    if (archivo == NULL)
    {
        printf("NO SE PUEDE ABRIR EL ARCHIVO ESPECIFICADO\n"); //no tiene mucho sentido porque no hace nada
    }
    return archivo;
}

void transformada(FILE *archivo_original,int offset,int N, int f) //resta el promedio a todo el archivo
{
    float x[N], freq, salida = 0;
    int k = 0, n = 0;
    float Im = 0, Re = 0;
    FILE *archivo_nuevo;
    char extra[25];
    snprintf(extra, sizeof(extra), "_Transformada%d", N);
    archivo_nuevo = abrir_archivo("w+", f, extra); //abre un nuevo archivo
    fscanf(archivo_original, "%f\n", &freq);       //obtiene la frecuencia
    fprintf(archivo_nuevo, "%.1f\n", freq);        //y la guarda en el nuevo
       for (n = 0; n < offset; n++)
    {
        x[0] = 0;
        fscanf(archivo_original, "%f\n", &x[0]); //lee el arreglo con los valores
    }
    for (n = 0; n < N; n++)
    {
        x[n] = 0;
        fscanf(archivo_original, "%f\n", &x[n]); //lee el arreglo con los valores
    }
    for (k = 0; k < N; k++)
    {
        for (n = 0; n < N; n++)
        {
            Im = (Im + x[n] * (sin((2 * pi * n * k) / N)));
            Re = (Re + x[n] * (cos((2 * pi * n * k) / N)));
        }
        salida = sqrt(pow(Re, 2) + pow(Im, 2));
        fprintf(archivo_nuevo, "%.2f\n", salida);
        Im = 0;
        Re = 0;
    }
    fclose(archivo_nuevo); //cierra el archivo nuevo
    rewind(archivo_original);
}
int main()
{
    int N, i;
    int f[] = {20, 50, 200};
    FILE *arch;
    for (i = 0; i < 3; i++)
    {
        arch = abrir_archivo("r", f[i], ""); //abre archivo
        transformada(arch,10, 8, f[i]);
        transformada(arch,10, 16, f[i]);
        transformada(arch,10, 256, f[i]);
        fclose(arch);
    }
        arch = abrir_archivo("r",11025, "Perro"); //abre archivo
        transformada(arch,1000, 8, 11025);
        transformada(arch,1000, 16, 11025);
        transformada(arch,1000, 4096, 11025);
        fclose(arch);
}