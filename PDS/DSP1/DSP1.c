#include <unistd.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>

FILE *abrir_archivo(char nombre[], char modo[])
{
    FILE *archivo;
    char string[100];
    char cwd[PATH_MAX];
    getcwd(cwd, sizeof(cwd));
    strcpy(string, cwd);
    strcat(string,"\\");
    strcat(string, nombre);
    archivo = fopen(string, modo);
    printf("%s\n",string);
    if (archivo == NULL)
    {
        printf("NO SE PUEDE ABRIR EL ARCHIVO ESPECIFICADO\n");
    }
    return archivo;
    fclose(archivo);
}

float valor_medio(FILE *archivo)
{
    int n = 0;
    float suma = 0, actual;
    fscanf(archivo,"%f\n", &actual);        //salta la frecuencia
    while (!feof(archivo))
    {
        fscanf(archivo, "%f\n", &actual);
        suma += actual;
        n++;
    }
    rewind(archivo);              
    return (suma/n);
}





int main() {
    FILE *arch1, *arch2, *arch3, *arch4, *arch5;
    float minimo, maximo, freq;
    //abre los archivos
    arch1 = abrir_archivo("Signal_01.txt", "r");
    arch2 = abrir_archivo("Signal_02.txt", "r");
    arch3 = abrir_archivo("Signal_03.txt", "r");
    arch4 = abrir_archivo("Signal_04.txt", "r");
    arch5 = abrir_archivo("Signal_05.txt", "r");
    //prueba del valor medio
    float medio=valor_medio(arch1);
    
    printf("vmedio= %f",medio);
    //tengo que calcular valor medio de cada archivo y restarlo
    //de cada archivo. guardarlo en un archivo nuevo.
    //el primer valor tiene la frecuencia de muestreo.
    //de ahi para abajo son las medidas en volts

    //sumar y restar dos señales y guardar resultados
    //calcular frecuencias y valores maximos y minimos
    //realizar autocorrelacion y correlacion entre 2
    //graficar en matlab xd
}