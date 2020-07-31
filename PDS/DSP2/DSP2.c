#include <unistd.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <stdlib.h>
//#include <stdin.h>

FILE *abrir_archivo(char modo[], char extra[]) //abre los archivos en el modo indicado, se le puede agregar un sufijo al nombre
{
    FILE *archivo;
    char string[100];
    char cwd[PATH_MAX];
    getcwd(cwd, sizeof(cwd));                                                //obtiene el directorio donde se esta ejecutando
    snprintf(string, sizeof(string), "%s\\OndaCuadrada%s.txt", cwd, extra); //siguen el patron original, solo les cambia el numero
    archivo = fopen(string, modo);
    if (archivo == NULL)
    {
        printf("NO SE PUEDE ABRIR EL ARCHIVO ESPECIFICADO\n"); //no tiene mucho sentido porque no hace nada
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
        n++; //aumenta el contador por cada linea leida
    }
    rewind(archivo);
    return n;
}
float valor_medio(FILE *arch) //devuelve el promedio del archivo
{
    int n = 0;
    float suma = 0, actual = 0;
    fscanf(arch, "%f\n", &actual); //omite la frecuencia
    while (!feof(arch))
    {
        fscanf(arch, "%f\n", &actual);
        suma += actual; //suma recursivamente todos los valores
        n++;            //y lleva un contador para el promedio
    }
    rewind(arch);
    return (suma / n); //devuelve el promedio
}
void promedio(FILE *archivo_original) //resta el promedio a todo el archivo
{
    float actual=0,previo=0,salida=0;
    FILE *archivo_nuevo;
    archivo_nuevo = abrir_archivo("w+", "Promedio"); //abre un nuevo archivo
    fscanf(archivo_original, "%f\n", &previo);         //obtiene la frecuencia
	fprintf(archivo_nuevo, "%.1f\n", previo);          //y la guarda en el nuevo
	fscanf(archivo_original, "%f\n", &previo);		//lee el primer valor para obtener el promedio
    fprintf(archivo_nuevo, "%.2f\n", previo);          //y la guarda en el nuevo

    while (!feof(archivo_original))
    {
        fscanf(archivo_original, "%f\n", &actual);     //a cada valor le resta el Vmedio
		salida=(actual+previo)/2;
		previo=actual;
        fprintf(archivo_nuevo, "%.2f\n", salida); //y lo guarda en el nuevo archivo
    }
    fclose(archivo_nuevo); //cierra el archivo original
    rewind(archivo_original);
}
void funcion4(FILE *archivo_original) //resta el promedio a todo el archivo
{
    float actual=0,previo=0,salida=0,previo2=0,freq;
    FILE *archivo_nuevo;
    archivo_nuevo = abrir_archivo("w+", "Punto4"); //abre un nuevo archivo
    fscanf(archivo_original, "%f\n", &freq);         //obtiene la frecuencia
	fprintf(archivo_nuevo, "%.1f\n", freq);          //y la guarda en el nuevo

    while (!feof(archivo_original))
    {
        fscanf(archivo_original, "%f\n", &actual);     //a cada valor le resta el Vmedio
		salida=actual+(0.4*previo)-(0.6*previo2);
		previo2=previo;
		previo=actual;
        fprintf(archivo_nuevo, "%.2f\n", salida); //y lo guarda en el nuevo archivo
    }
    fclose(archivo_nuevo); //cierra el archivo original
    rewind(archivo_original);
}
int main()
{
	int N;
    FILE *arch;
    arch = abrir_archivo("r","");  //abre archivo
	promedio(arch);
	funcion4(arch);
    fclose(arch);
    printf("\nPresione una tecla para terminar");
    getch();
}