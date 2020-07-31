// Codigo para Arduino UNO – Simulador Tinkercad
int actual;
float valor_analogico_salida;
int previo=0,previo2=0;
int prom=0,punto4=0;
int Ts=10; //Tiempo de Muestreo en milisegundos
void setup()
{
 Serial.begin(57600);
}
void loop()
{
 actual=analogRead(A0);
 valor_analogico_entrada=(float)actual*5.0/1023.0;

//filtro promediador:
prom=(actual+previo)/2;
//punto 4:
punto4=actual+(previo*0.4)-(previo2*0.6);
previo2=previo;
previo=actual;


 //Serial.println("Valor Digital: ");
 Serial.print(prom);
 Serial.print(",");
 Serial.print(punto4);
 Serial.print(",");
 Serial.println(actual);
 //Serial.println("Valor Analogico: ");
 //Serial.println(valor_analogico_salida);

 delay(Ts); // Espera Ts
} 