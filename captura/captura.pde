import processing.sound.*;
import gab.opencv.*;
import processing.video.*;
//objeto opencv
OpenCV opencv;
//obejeto camara 
Capture cam; 
//propiedades de la camara-resolucion vga
int ancho = 640;
int alto = 480;
int estado=0;
int colorBase=255;
int colorBase1=255;
int colorBase2=255;
int ellipse1 = color(255, 0, 0);
int ellipse2 = color(255, 0, 0);
int ellipse3 = color(255, 0, 0);
//tiempo de reinico
int tiempoR=0;
//condicion para modificar los colores de la camara
boolean invertir = true;
//fuente 
PFont nuevaFuente;
//sonidos
SoundFile miSonido;

void setup() {
  fullScreen();

  //creamos un arraylist de camaras
  String[] listaDeCamaras = Capture.list();
  printArray(listaDeCamaras);
  //incializamos el objeto camara
  int numeroCamara = 0;
  cam = new Capture (this, listaDeCamaras[numeroCamara]);
  //cam = new Capture(this , ancho, alto);
  //inicializo el objeto openCv
  opencv = new OpenCV(this, ancho, alto);
  //incio de la camara
  cam.start();
  //sonido 
  miSonido = new SoundFile(this, "Confirmacion.wav");
  //fuente
  nuevaFuente=createFont("Eye Spy.ttf", 10);
  textFont(nuevaFuente);
}
void draw() {
  frameRate(30);
  println(estado);
  int umbral = 254;//int(map(mouseX,0,width,0,256));
  //background(0);
  //pregunto por los fotogramas de la camara 
  if (cam.available()) {
    //lee el nuevo fotograma 
    cam.read();
    //pasamos a open cv la imagen de la camara 
    opencv.loadImage(cam);
    //invertimos el color de la camara

    opencv.threshold(umbral);

    //buscamos el punto mas brillante de una imagen 

    if (estado==0) {
      miSonido.stop();
      push();
      background(0);
      fill(255);
      textSize(60);
      text("El escaneo comenzara pronto", 480, 300);
      pop();
    } else if (estado==1) {
      background(255);
      tracker();
      push();
      fill(colorBase);
      ellipse(30, 500, 400, 400);
      pop();
    } else if (estado==2) {
      background(255);
      tracker();
      push();
      fill(colorBase1);
      ellipse(1920, 500, 400, 400);
      pop();
    } else if (estado==3) {
      trackerVertical();
      push();
      fill(colorBase2);
      ellipse(1000, 10, 400, 400);
      pop();
    }else if(estado==4){
      tiempoR++;
      println(tiempoR);
      push();
      background(0);
      fill(255);
      textSize(60);
      text("Proceso de escaneo finalizado con exito.", 290, 300);
      pop();
      if(tiempoR>=120){
       reinicio(); 
      }
    }
  }
}
void mousePressed() {
  println(mouseX, mouseY);
  estado=4;
}
void keyPressed() {
  if (estado==0 && key =='n') {
    estado=1;
  }
}
void tracker() {
  PVector pixelBrillante = opencv.max();
  // Escala las coordenadas del punto más brillante a la resolución de la ventana
  float escalaX = map(pixelBrillante.x, 0, ancho, 0, width);
  PImage salida = opencv.getOutput();
  pushMatrix();
  translate(width, 0);
  scale(-1, 1);
  image(salida, 0, 0, width, height);
  stroke(255, 0, 0);
  fill(255);
  // Usa las coordenadas escaladas para dibujar el ellipse
  ellipse(escalaX, 600, 100, 100);
  popMatrix();
  // Resto del código...
  if (estado ==1 && escalaX>=1800) {
    miSonido.play();
    estado=2;
    colorBase=ellipse1;
  } else if (estado==2 && pixelBrillante.x<=100) {
    miSonido.play();
    estado=3;
    colorBase1=ellipse2;
  }
}
void trackerVertical() {
  PVector pixelBrillante = opencv.max();
  // Escala las coordenadas del punto más brillante a la resolución de la ventana
  float escalaY = map(pixelBrillante.y, 0, alto, 0, height);
  PImage salida = opencv.getOutput();
  pushMatrix();
  translate(width, 0);
  scale(-1, 1);
  image(salida, 0, 0, width, height);
  stroke(255, 0, 0);
  fill(255);
  // Usa las coordenadas escaladas para dibujar el ellipse
  ellipse(900, escalaY, 100, 100);
  popMatrix();
  // Resto del código...
  if (estado ==3 && escalaY<=100) {
    miSonido.play();
    colorBase2=ellipse3;
    estado=4;
  }
}

void reinicio() {
  estado=0;
  colorBase=255;
  colorBase1=255;
  colorBase2=255;
  ellipse1 = color(255, 0, 0);
  ellipse2 = color(255, 0, 0);
  ellipse3 = color(255, 0, 0);
  tiempoR=0;
}
