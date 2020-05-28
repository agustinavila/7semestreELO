#include <unistd.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <stdlib.h>

FILE *abrir_archivo(int i, char modo[], char extra[])
{
    FILE *archivo;
    char string[100];
    char cwd[PATH_MAX];
    getcwd(cwd, sizeof(cwd)); //\\PDS\\DSP1
    snprintf(string, sizeof(string), "%s\\Signal_0%d%s.txt", cwd, i, extra);
    archivo = fopen(string, modo);
    if (archivo == NULL)
    {
        printf("NO SE PUEDE ABRIR EL ARCHIVO ESPECIFICADO\n");
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
float valor_medio(FILE *arch)
{
    int n = 0;
    float suma = 0, actual = 0;
    fscanf(arch, "%f\n", &actual); //salta la frecuencia
    while (!feof(arch))
    {
        fscanf(arch, "%f\n", &actual);
        suma += actual;
        n++;
    }
    rewind(arch);
    return (suma / n);
}
void resta_vmedio(FILE *archivo_original, int i, float vm)
{
    float valor;
    FILE *archivo_nuevo;
    archivo_nuevo = abrir_archivo(i, "w+", "Vmedio");
    fscanf(archivo_original, "%f\n", &valor);
    fprintf(archivo_nuevo, "%.1f\n", valor); //las frecuencias
    while (!feof(archivo_original))
    {
        fscanf(archivo_original, "%f\n", &valor);
        fprintf(archivo_nuevo, "%.1f\n", valor - vm);
    }
    fclose(archivo_nuevo);
    rewind(archivo_original);
}
float interpola_lineal(float x1, float x2, float y1, float y2, float x)
{
    return ((((y2 - y1) * (x - x1)) / (x2 - x1)) + y1);
}
void adapta_signals(FILE *arch1, FILE *arch2, float **out_s1, float **out_s2, int *cant_muestras, float *freq_muestreo)
{
    int cant1, cant2;                 //variables para determinar longitudes
    long i, j = 0;                    //contadores auxiliares
    float freq1, freq2, *sig1, *sig2; //ambas frecuencias y señales "auxiliares"
    float *n1, *n2, tmin, t1, t2;     //n es vector temporal, los t son tiempos finales
    cant1 = contar_lineas(arch1) - 1; //cuenta la cantidad de valores que tiene menos el de frecuencia
    cant2 = contar_lineas(arch2) - 1;
    fscanf(arch1, "%f\n", &freq1);                     //leo frecuencia 1
    fscanf(arch2, "%f\n", &freq2);                     //leo frecuencia 2
    *freq_muestreo = (freq1 >= freq2) ? freq1 : freq2; //la frecuencia de muestreo es la maximo de las dos
    printf("%f\n", *freq_muestreo);
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
    printf("frecuencia:%f\t cant_muestras:%d\t tmin:%f, %f, %f\n", *freq_muestreo, *cant_muestras, tmin, t1, t2);
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
                //printf("%d\n",i);
                while ((n2[j] >= n1[i]) && (n2[j] <= n1[i + 1]))
                {
                    tmp1[j] = interpola_lineal(n1[i], n1[i + 1], sig1[i], sig1[i + 1], n2[j]);
                    tmp2[j] = sig2[j];
                    //printf("%f\n", out_s1);
                    j++;
                }
            }
        }
        else //si f1 es mayor que f2
        {
            j = 0;
            for (i = 0; n2[i] < tmin; i++) //genera el bucle mientras el valor temporal sea menor al tmin
            {
                //printf("%d\n", i);
                while ((n1[j] >= n2[i]) && (n1[j] < n2[i + 1]))
                {
                    tmp2[j] = interpola_lineal(n2[i], n2[i + 1], sig2[i], sig2[i + 1], n1[j]);
                    tmp1[j] = sig1[j];
                    //printf("%f\n", out_s2);
                    j++;
                }
            }
        }
    }
    *out_s1 = tmp1;
    *out_s2 = tmp2;
    free(n1);
    free(n2);
    free(sig1);
    free(sig2);
}
void Suma_Resta(FILE *archivo1, FILE *archivo2, char nombre[])
{
    int cant_muestras, i;
    float freq_muestreo;
    float *signal1, *signal2;
    FILE *suma, *resta;
    suma = abrir_archivo(nombre, "w+", "Suma");
    resta = abrir_archivo(nombre, "w+", "Resta");
    adapta_signals(archivo1, archivo2, &signal1, &signal2, &cant_muestras, &freq_muestreo);
    fprintf(suma, "%.1f\n", freq_muestreo);
    fprintf(resta, "%.1f\n", freq_muestreo);
    printf("cant muestras: %d\n", cant_muestras);
    for (i = 0; i < cant_muestras; i++)
    {
        //printf("%f\t%f\n",signal1[i],signal2[i]);
        fprintf(suma, "%.1f\n", signal1[i] + signal2[i]);
        fprintf(resta, "%.1f\n", signal1[i] - signal2[i]);
    }
    fclose(resta);
    fclose(suma);
    free(signal1);
    free(signal2);
}
float freq_analogica(FILE *arch, float mayor, float menor)
{
    int n = 0, bandera = 0; // n es la frecuencia digital
    float valor, Fs;
    fscanf(arch, "%f\n", &Fs); //frecuencia de muestreo

    while ((!feof(arch)) && (!bandera))
    {
        fscanf(arch, "%f\n", &valor);
        if (valor == mayor)
        {

            bandera = 1; //indico que encontre el 1er maximo
            n++;
            while ((!feof(arch)) && bandera)
            { //cuento hasta encontrar el primer minimo y salgo del bucle
                fscanf(arch, "%f\n", &valor);
                if (valor == menor)
                    bandera = 0; //indico que encontre el minimo consecutivo al mayor
                n++;
            }

            while ((!feof(arch)) && (!bandera))
            { //sigo contando hasta encontrar nuevamente el 1er maximo
                fscanf(arch, "%f\n", &valor);
                if (valor == mayor)
                    bandera = 1;
                n++;
            }

        } //terino el ciclo de cuenta
    }
    rewind(arch);
    return (Fs / (n - 1));
}
void max_min_freq(FILE *arch, int i)
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
    freq_analog = freq_analogica(arch, maximo, minimo);
    printf("MIN: %.1fV\tMAX: %.1fV\tFREQ ANALOG: %.1fHz\n", minimo, maximo, freq_analog);
}
void correlacion(FILE *arch1, FILE *arch2, char nombre[])
{
    int cant_muestras, i, k, n1, n2;
    float *s1, *s2, freq_muestreo, freq1, freq2;
    double correlacion;
    FILE *arch_corr;
    n1 = contar_lineas(arch1) - 1;
    n2 = contar_lineas(arch2) - 1;    
    arch_corr = abrir_archivo(nombre, "w+","correlacion");
    adapta_signals(arch1, arch2, &s1, &s2, &cant_muestras, &freq_muestreo);
    fprintf(arch_corr, "%.1f\n", freq_muestreo); // guardo la freq de muestreo

    for (k = 0; k < cant_muestras; k++)
    {
        correlacion = 0;
        for (i = 0; i < cant_muestras - k; i++)
            correlacion += s1[i] * s2[i + k];
        fprintf(arch_corr, "%lf\n", correlacion); //guardo el coeficiente de autocorrelacion para el elemento [i]
    }
    free(s1);
    free(s2);
    fclose(arch_corr);
}

int main()
{
    FILE *arch, *arch2;
    float medio;
    int i;
    //abre los archivos
    for (i = 1; i < 6; i++)
    {
        printf("\nSignal %d\n", i);
        arch = abrir_archivo(i, "r", "");
        medio = valor_medio(arch);
        printf("v%imedio= %f\n", i, medio);
        resta_vmedio(arch, i, medio);
        max_min_freq(arch, i);
        fclose(arch);
    }

    arch = abrir_archivo(1, "r", "");
    arch2 = abrir_archivo(2, "r", "");
    Suma_Resta(arch, arch2,12);
    correlacion(arch2, arch2, 2);
    correlacion(arch, arch2, 12);
    fclose(arch);
    fclose(arch2);
}