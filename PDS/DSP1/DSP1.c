#include <unistd.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <stdlib.h>

FILE *abrir_archivo(int i, char modo[], char extra[]) //abre los archivos en el modo indicado, se le puede agregar un sufijo al nombre
{
    FILE *archivo;
    char string[100];
    char cwd[PATH_MAX];
    getcwd(cwd, sizeof(cwd));                                                //obtiene el directorio donde se esta ejecutando
    snprintf(string, sizeof(string), "%s\\Signal_0%d%s.txt", cwd, i, extra); //siguen el patron original, solo les cambia el numero
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
void resta_vmedio(FILE *archivo_original, int i, float vm) //resta el promedio a todo el archivo
{
    float valor;
    FILE *archivo_nuevo;
    archivo_nuevo = abrir_archivo(i, "w+", "Vmedio"); //abre un nuevo archivo
    fscanf(archivo_original, "%f\n", &valor);         //obtiene la frecuencia
    fprintf(archivo_nuevo, "%.1f\n", valor);          //y la guarda en el nuevo
    while (!feof(archivo_original))
    {
        fscanf(archivo_original, "%f\n", &valor);     //a cada valor le resta el Vmedio
        fprintf(archivo_nuevo, "%.1f\n", valor - vm); //y lo guarda en el nuevo archivo
    }
    fclose(archivo_nuevo); //cierra el archivo original
    rewind(archivo_original);
}
float interpola_lineal(float x1, float x2, float y1, float y2, float x) //realiza la interpolacion de un punto
{
    //siendo y2 e y1 las amplitudes de los dos puntos de referencia
    //y x1 y x2 las posiciones horizontales
    //la interpolacion lineal obtiene una recta entre los dos puntos conocidos,
    //y analiza el valor para el punto requerido (se le suma y1)
    return ((((y2 - y1) * (x - x1)) / (x2 - x1)) + y1);
}
void adapta_signals(FILE *arch1, FILE *arch2, float **out_s1, float **out_s2, int *cant_muestras, float *freq_muestreo) //analiza duracion y frecuencia para que sean similares
{
    //esta funcion "acorta" la señal mas duradera al tiempo de la mas corta,
    //y muestrea ambas a la mayor frecuencia de las dos.
    //para esto, se interpola la de menor frecuencia a los tiempos de la de mayor frecuencia.

    int cant1, cant2;                 //variables para determinar longitudes(cantidad de datos)
    long i, j = 0;                    //contadores auxiliares
    float freq1, freq2, *sig1, *sig2; //ambas frecuencias y señales "auxiliares"
    float *n1, *n2, tmin, t1, t2;     //n es vector temporal, los t son tiempos finales
    cant1 = contar_lineas(arch1) - 1; //cuenta la cantidad de valores que tiene menos el de frecuencia
    cant2 = contar_lineas(arch2) - 1;
    fscanf(arch1, "%f\n", &freq1);                     //leo frecuencia 1
    fscanf(arch2, "%f\n", &freq2);                     //leo frecuencia 2
    *freq_muestreo = (freq1 >= freq2) ? freq1 : freq2; //la frecuencia de muestreo es la mayor de las dos
    n1 = (float *)malloc((cant1) * sizeof(float)); // reservo memoria para estos arrays
    sig1 = (float *)malloc((cant1) * sizeof(float));
    n2 = (float *)malloc((cant2) * sizeof(float));
    sig2 = (float *)malloc((cant2) * sizeof(float));

    for (i = 0; i < cant1; i++) //carga los datos de la señal los arreglos
    {
        n1[i] = i / freq1;               //genero el vector de tiempo
        fscanf(arch1, "%f\n", &sig1[i]); //guardo el valor en sig1
    }
    rewind(arch1); //vuelve el puntero a su posicion original

    for (i = 0; i < cant2; i++) //idem al anterior
    {
        n2[i] = i / freq2; //genero el vector de tiempo
        fscanf(arch2, "%f\n", &sig2[i]);
    }
    rewind(arch2);

    t1 = n1[cant1 - 1];                         //tiempo final 1
    t2 = n2[cant2 - 1];                         //tiempo final 2
    tmin = (t1 <= t2) ? t1 : t2;                //el tiempo total sera el minimo de los dos
    *cant_muestras = (tmin) * (*freq_muestreo); //la cant de muestras es el menor tiempo / mayor frecuencia
    printf("frecuencia:%f\t cant_muestras:%d\t tmin:%f\n", *freq_muestreo, *cant_muestras, tmin);
    //se usan estas variables temporales ya que en c no se pueden pasar punteros por referencia.
    //entonces se debe pasar punteros a las direcciones de los punteros
    float *tmp1 = (float *)malloc(*cant_muestras * sizeof(*tmp1)); //reserva memoria, no se si esta bien
    float *tmp2 = (float *)malloc(*cant_muestras * sizeof(*tmp2)); //same

    //de aca en adelante, comienza a comparar las frecuencias para interpolar
    if (freq1 == freq2) //si son iguales, no hace falta interpolar
    {
        for (i = 0; i < *cant_muestras; i++) //asigna hasta la cantidad de muestras
        {
            tmp1[i] = sig1[i]; //simplemente asigna valores
            tmp2[i] = sig2[i];
        }
    }
    else
    {
        if (freq2 > freq1) //si la frecuencia 2 es mayor a freq1, hay que interpolar la señal 1
        {
            j = 0;
            for (i = 0; n1[i] < tmin; i++) //es medio un enrosque esto
            {
                while ((n2[j] >= n1[i]) && (n2[j] <= n1[i + 1])) //todo: esto podria ser mas elegante
                {
                    tmp1[j] = interpola_lineal(n1[i], n1[i + 1], sig1[i], sig1[i + 1], n2[j]);
                    tmp2[j] = sig2[j];
                    j++;
                }
            }
        }
        else //si f1 es mayor que f2
        {
            j = 0;
            for (i = 0; n2[i] < tmin; i++) //genera el bucle mientras el valor temporal sea menor al tmin
            {
                while ((n1[j] >= n2[i]) && (n1[j] < n2[i + 1])) //todo: esto podria ser mas elegante
                {
                    tmp2[j] = interpola_lineal(n2[i], n2[i + 1], sig2[i], sig2[i + 1], n1[j]);
                    tmp1[j] = sig1[j];
                    j++;
                }
            }
        }
    }
    *out_s1 = tmp1; //se le asigna las variables temporales al valor del puntero del puntero (?)
    *out_s2 = tmp2;
    free(n1);
    free(n2);
    free(sig1);
    free(sig2); //se libera la memoria de las demas variables
}
void Suma_Resta(FILE *archivo1, FILE *archivo2, char nombre[]) //realiza suma y resta de dos funciones
{
    int cant_muestras, i;
    float freq_muestreo;
    float *signal1, *signal2;
    FILE *suma, *resta;
    suma = abrir_archivo(nombre, "w+", "Suma");                                             //abre el archivo que contendra la suma
    resta = abrir_archivo(nombre, "w+", "Resta");                                           //abre el de la resta
    adapta_signals(archivo1, archivo2, &signal1, &signal2, &cant_muestras, &freq_muestreo); //se asegura que sean similares las señales
    fprintf(suma, "%.1f\n", freq_muestreo);
    fprintf(resta, "%.1f\n", freq_muestreo);
    for (i = 0; i < cant_muestras; i++)
    {
        //printf("%f\t%f\n",signal1[i],signal2[i]);
        fprintf(suma, "%.1f\n", signal1[i] + signal2[i]); //realiza las operaciones linea por linea
        fprintf(resta, "%.1f\n", signal1[i] - signal2[i]);
    }
    fclose(resta); //cuerra archivos
    fclose(suma);
    free(signal1); //libera memoria
    free(signal2);
}
float freq_analogica(FILE *arch, float mayor, float menor) //obtiene la frecuencia analogica d ela señal
{
    int n = 0, bandera = 0; // n es la frecuencia digital
    float valor, Fs;
    fscanf(arch, "%f\n", &Fs); //frecuencia de muestreo

    while ((!feof(arch)) && (!bandera))
    {
        fscanf(arch, "%f\n", &valor);
        if (valor == mayor) //esta resolucion tampoco es muy elegante
        {
            bandera = 1; //indico que encontre el 1er maximo
            n++;
            while ((!feof(arch)) && bandera)
            {
                fscanf(arch, "%f\n", &valor);
                if (valor == menor)
                    bandera = 0;
                n++;
            }
            while ((!feof(arch)) && (!bandera))
            { //sigo contando hasta encontrar nuevamente el 1er maximo
                fscanf(arch, "%f\n", &valor);
                if (valor == mayor)
                    bandera = 1;
                n++;
            }

        } //termina el ciclo de cuenta
    }
    rewind(arch);
    return (Fs / (n - 1));
}
void max_min_freq(FILE *arch, int i) //obtiene valores maximos, minimos y frecuencia
{
    float maximo = -10000.0, minimo = 10000.0;
    float valor, Fs, freq_analog;
    fscanf(arch, "%f\n", &Fs); //guardo la frecuencia de muestreado
    while (!feof(arch))
    {
        fscanf(arch, "%f\n", &valor);
        if (valor >= maximo)
            maximo = valor;
        if (valor <= minimo)
            minimo = valor;
    }
    rewind(arch);
    freq_analog = 1;
    freq_analog = freq_analogica(arch, maximo, minimo); //obtiene la freq analogica
    printf("MIN: %.1fV\tMAX: %.1fV\tFREQ ANALOG: %.1fHz\n", minimo, maximo, freq_analog);
}
void correlacion(FILE *arch1, FILE *arch2, char nombre[]) //realiza correlacion entre dos archivos
{
    int cant_muestras, i, k;
    float *s1, *s2, freq_muestreo;
    double correlacion;
    FILE *arch_corr;
    arch_corr = abrir_archivo(nombre, "w+", "correlacion");
    adapta_signals(arch1, arch2, &s1, &s2, &cant_muestras, &freq_muestreo); //se asegura que sean similares
    fprintf(arch_corr, "%.1f\n", freq_muestreo);                            // freq de muestreo
    for (k = 0; k < cant_muestras; k++)                                     //realiza la correlacion propiamente dicha
    {
        correlacion = 0;
        for (i = 0; i < cant_muestras - k; i++)
            correlacion += s1[i] * s2[i + k];
        fprintf(arch_corr, "%lf\n", correlacion); //guardo el coeficiente de autocorrelacion para el elemento [i]
    }
    free(s1); //libera memoria
    free(s2);
    fclose(arch_corr);
}

int main()
{
    FILE *arch, *arch2;
    float medio;
    int i;
    //abre los archivos
    for (i = 1; i < 6; i++) //realiza las acciones comunes para los 5 archivos
    {
        printf("\nSignal %d\n", i);
        arch = abrir_archivo(i, "r", "");
        medio = valor_medio(arch);
        printf("v%imedio= %f\n", i, medio);
        resta_vmedio(arch, i, medio);
        max_min_freq(arch, i);
        fclose(arch);
    }

    arch = abrir_archivo(1, "r", "");  //abre dos señales para realizar
    arch2 = abrir_archivo(2, "r", ""); //suma, resta y correlacion
    Suma_Resta(arch, arch2, 12);
    correlacion(arch2, arch2, 2);
    correlacion(arch, arch2, 12);
    fclose(arch);
    fclose(arch2);
}