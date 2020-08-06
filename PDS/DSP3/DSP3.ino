#include <math.h>
// Codigo para Arduino UNO – Simulador Tinkercad
int Ts = 1; //Tiempo de Muestreo en milisegundos
int N = 16;
int cont = 0;
float datos[N];
#define pi 3.14159265

void transformada(int N, float valores[]);
void setup()
{
	Serial.begin(57600);
	delay(10);
}
void loop()
{
	if (cont < N)
	{
		datos(cont) = (float)analogRead(A0) * 5.0 / 1023.0;
		cont++;
	}
	else
	{
		transformada(N, valores)
		cont = 0;
	}

	Serial.println(cont);


	delay(Ts); // Espera Ts
}

void transformada(int N, float valores[])
{
    float x[N], salida = 0;
    int k = 0, n = 0;
    float Im = 0, Re = 0;
    for (k = 0; k < N; k++)
    {
        for (n = 0; n < N; n++)
        {
            Im = (Im + x[n] * (sin((2 * pi * n * k) / N))); //realiza el calculo
            Re = (Re + x[n] * (cos((2 * pi * n * k) / N)));
        }
        salida = sqrt(pow(Re, 2) + pow(Im, 2));
       	Serial.print("%.3f\n", salida); //guarda el resultado en el archivo
        Im = 0;
        Re = 0;
    }
}