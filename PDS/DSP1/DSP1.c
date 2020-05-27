#include <unistd.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>

FILE *abrir_archivo(int i, char modo[],char extra[])
{
    FILE *archivo;
    char string[100];
    char cwd[PATH_MAX];
    getcwd(cwd, sizeof(cwd));
    snprintf(string, sizeof(string), "%s\\Signal_0%d%s.txt",cwd,i,extra);
    archivo = fopen(string, modo);
    printf("%s\n",string);
    if (archivo == NULL)
    {
        printf("NO SE PUEDE ABRIR EL ARCHIVO ESPECIFICADO\n");
    }
    //fclose(archivo); //tengo que cerrarlo?
    return archivo;
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

void resta_vmedio(FILE *archivo_original,int i, float vm){
    float valor;
    FILE *archivo_nuevo;
    archivo_nuevo=abrir_archivo(i,"w+","Vmedio");
    fscanf(archivo_original,"%f\n", &valor);
    fprintf(archivo_nuevo, "%.1f\n", valor);    //las frecuencias
    while (!feof(archivo_original))
    {
        fscanf(archivo_original, "%f\n", &valor);
        fprintf(archivo_nuevo, "%.1f\n", valor-vm);
    }
    fclose(archivo_nuevo);
    rewind(archivo_original);
}




int main() {
    FILE *archivo;
    float medio;
    int i;
    //abre los archivos
    for(i=1;i<6;i++){
        archivo=abrir_archivo(i,"r","");
        medio=valor_medio(archivo);
        printf("v%imedio= %f\n",i,medio);
        resta_vmedio(archivo,i,medio);
    }
      //el primer valor tiene la frecuencia de muestreo.
    //de ahi para abajo son las medidas en volts

    //sumar y restar dos señales y guardar resultados
    //calcular frecuencias y valores maximos y minimos
    //realizar autocorrelacion y correlacion entre 2
    //graficar en matlab xd
}