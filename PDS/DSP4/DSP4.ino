//Juan Agustin Avila
//Julio 2020
//Reg 26076 - ELO
const int Ts = 1; //Tiempo de Muestreo en milisegundos
const int N = 5;  //cantidad de puntos
//numerador y denominador del filtro IIR pasabajo de 40Hz:
const float num[N] = {0.0001832160, 0.0007328641, 0.0010992961, 0.0007328641, 0.0001832160};
const float den[N] = {0.5174781998, -2.4093428566, 4.2388639509, -3.3440678377, 1.0000000000};
//Filtro IIR pasabanda:
//0.0278597661, 0.0000000000, -0.0557195322, 0.0000000000, 0.0278597661
//0.5869195081, -2.4404021492, 4.0739405159, -3.2014145794, 1.0000000000

//Filtro IIR pasa alto
//0.2754132881, -1.1016531523, 1.6524797284, -1.1016531523, 0.2754132881
//0.0761970646, -0.4844033683, 1.2756133250, -1.5703988512, 1.0000000000
void setup()
{
	delay(10); //solo por si el generador tiene un transitorio
	Serial.begin(57600);
}

void loop()
{
	int k;
	static float entrada[N] = {0, 0, 0, 0, 0};
	static float salida[N] = {0, 0, 0, 0, 0};
	float out = 0;
	for (k = 1; k < N; k++)
	{
		entrada[k - 1] = entrada[k]; //desplaza los valores
		salida[k - 1] = salida[k];
	}
	salida[N - 1] = 0;											 //en principio se pone en cero para que no se calcule
	entrada[N - 1] = (float)(analogRead(A0) - 512) * 2 / 1023.0; //genera una señal similar a la provista por la catedra
	for (k = 0; k < N; k++)
	{
		out = out + (num[k] * entrada[k]) - (den[k] * salida[k]); //realiza el calculo
	}
	salida[N - 1] = out; //finalmente se asigna el valor de salida actual al arreglo
	Serial.println(out);
	delay(Ts); // Espera Ts
}
