#include <math.h>
//Juan Agustin Avila
// Julio 2020
//Reg 26076 - ELO
const int Ts = 1; //Tiempo de Muestreo en milisegundos
const int N = 8;  //cantidad de puntos
const float pi = 3.1416;

void setup()
{
	delay(10); //solo por si el generador tiene un transitorio
	Serial.begin(57600);
}

void loop()
{
	static int cont = 0;
	static float datos[N];
	if (cont < N)
	{
		datos[cont] = (float)(analogRead(A0) - 512) * 2 / 1023.0; //genera una señal similar a la provista por la catedra
		cont++;
	}
	else
	{
		transformada(N, datos);	//cuando obtiene la cantidad de datos, calcula la transf.
		cont = 0;
	}
	delay(Ts); // Espera Ts
}

void transformada(int N, float *x)
{
	float salida = 0;
	float val = 0;
	int k = 0, n = 0;
	float Im = 0, Re = 0;
	for (k = 0; k < N; k++)
	{
		for (n = 0; n < N; n++)
		{
			val = (2 * pi * n * k) / N;
			Im = Im + (x[n] * sin(val));
			Re = Re + (x[n] * cos(val));
		}
		salida = sqrt(pow(Re, 2) + pow(Im, 2));
		Serial.println(salida);
		Im = 0;
		Re = 0;
	}
}