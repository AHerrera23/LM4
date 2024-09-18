import processing.sound.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
// Pin de la copa
int baseCopa = 9;
int estadoCopa = 0;
// Pin LED
int led = 10;
//booleanos de estadistica
boolean diez = false;
void setup() {
  size(800, 800);
  background(0);
  // Inicializamos Firmata
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(baseCopa, Arduino.INPUT);
  arduino.pinMode(led, Arduino.OUTPUT);
}

void draw() {
  estadoCopa = arduino.digitalRead(baseCopa);
  arduino.digitalWrite(led, Arduino.HIGH);
  if(diez==true){
    arduino.digitalWrite(led, Arduino.LOW);
  }
  if (estadoCopa == Arduino.HIGH) {
    background(255);
    fill(0);
    text("Funciona", mouseX, mouseY, 80);
    diez=true;
  }
}
