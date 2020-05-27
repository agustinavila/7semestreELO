#include <unistd.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
//char *getcwd(char *buf, size_t size);
FILE *abrir_archivo(char nombre[], char modo[])
{
    FILE *arch;
    char string[100];
    char cwd[PATH_MAX];
   if (getcwd(cwd, sizeof(cwd)) != NULL) {
       printf("Current working dir: %s\n", cwd);
   } else {
       perror("getcwd() error");
   }
    strcpy(string, cwd);
    strcat(string,"\\");
    strcat(string, nombre);
    arch = fopen(string, modo);
    printf("%s\n",string);
    if (arch == NULL)
    {
        puts("NO SE PUEDE ABRIR EL ARCHIVO ESPECIFICADO\n");
    }
    return arch;
    fclose(arch);
}







int main() {
    FILE *arch1, *arch2, *arch3, *arch4, *arch5;
    float minimo, maximo, freq;
    arch1 = abrir_archivo("Signal_01.txt", "r");
    arch2 = abrir_archivo("Signal_02.txt", "r");
    arch3 = abrir_archivo("Signal_03.txt", "r");
    arch4 = abrir_archivo("Signal_04.txt", "r");
    arch5 = abrir_archivo("Signal_05.txt", "r");
}