// Capas de profundidad: arreglos paralelos de capacidad fija, sin objetos por frame.
final int FA_TOTAL_ESTRELLAS = 260;
float[] faEstrellaX = new float[FA_TOTAL_ESTRELLAS];
float[] faEstrellaY = new float[FA_TOTAL_ESTRELLAS];
float[] faEstrellaFase = new float[FA_TOTAL_ESTRELLAS];
int[] faEstrellaCapa = new int[FA_TOTAL_ESTRELLAS];
int[] faEstrellaColor = new int[FA_TOTAL_ESTRELLAS];
final int FA_TOTAL_COMETAS = 3;
float[] faCometaX = new float[FA_TOTAL_COMETAS];
float[] faCometaY = new float[FA_TOTAL_COMETAS];
float[] faCometaVX = new float[FA_TOTAL_COMETAS];
float[] faCometaVY = new float[FA_TOTAL_COMETAS];
float[] faCometaInicio = new float[FA_TOTAL_COMETAS];
float[] faCometaVida = new float[FA_TOTAL_COMETAS];
int[] faCometaColor = new int[FA_TOTAL_COMETAS];
boolean[] faCometaActiva = new boolean[FA_TOTAL_COMETAS];
boolean faPreparado = false;
float faTiempo = 0;
float faProximoCometa = 2.5f;
int faUltimoMs = 0;
int faUltimoFrame = -2;

void faPrepararEspacio() {
  for (int i = 0; i < FA_TOTAL_ESTRELLAS; i++) {
    faEstrellaX[i] = random(1);
    faEstrellaY[i] = random(1);
    faEstrellaFase[i] = random(TWO_PI);
    faEstrellaCapa[i] = 0;
    if (i >= 140) faEstrellaCapa[i] = 1;
    if (i >= 220) faEstrellaCapa[i] = 2;
    faEstrellaColor[i] = color(192, 213, 255);
    if (i % 4 == 1) faEstrellaColor[i] = color(94, 225, 244);
    if (i % 4 == 2) faEstrellaColor[i] = color(230, 107, 203);
    if (i % 4 == 3) faEstrellaColor[i] = color(255, 219, 124);
    if (faEstrellaCapa[i] == 0) faEstrellaColor[i] = color(177 + i % 60, 203 + i % 40, 255);
  }
  faPreparado = true;
}

// Fondo a pantalla completa; solo se invoca antes del zoom de la máquina.
void dibujarFondoArcadeAnimado() {
  if (!faPreparado) faPrepararEspacio();
  int ahora = millis();
  if (frameCount == faUltimoFrame + 1) faTiempo += constrain((ahora - faUltimoMs) / 1000.0f, 0, 0.05f);
  faUltimoMs = ahora;
  faUltimoFrame = frameCount;
  pushStyle();
  rectMode(CORNER);
  noStroke();
  background(15, 12, 40);
  float tiempo = faTiempo;
  float celda = max(28, width / 38.0f);
  int columnas = ceil(width / celda) + 1;
  int filas = ceil(height / celda) + 1;

  // Mosaico animado que cubre también los bordes de la pantalla.
  for (int fila = 0; fila < filas; fila++) {
    for (int columna = 0; columna < columnas; columna++) {
      float onda = sin(columna * 0.42f + fila * 0.31f - tiempo * 0.35f);
      float brillo = 0.5f + 0.5f * onda;
      fill(19 + 17 * brillo, 16 + 13 * brillo, 46 + 29 * brillo);
      rect(columna * celda, fila * celda, celda + 1, celda + 1);
      fill(105, 78, 167, 35 + 25 * brillo);
      rect(columna * celda, fila * celda, celda - 2, 2);
    }
  }

  faDibujarCosmos(tiempo);
  faDibujarEstrellas(tiempo);

  // Franjas diagonales de luz que recorren la pared.
  pushMatrix();
  translate(width * 0.5f, height * 0.5f);
  rotate(-0.32f);
  for (int i = -8; i <= 8; i++) {
    float x = i * width * 0.17f + (tiempo * 45) % (width * 0.17f);
    float pulso = 0.5f + 0.5f * sin(tiempo * 0.6f + i * 0.8f);
    fill(233, 75, 187, 12 + 12 * pulso);
    rect(x - 12, -height, 24, height * 2);
    fill(100, 237, 235, 25 + 20 * pulso);
    rect(x - 2, -height, 4, height * 2);
  }
  popMatrix();

  // Chispas, cruces y fichas de píxeles con velocidades distintas.
  for (int i = 0; i < 45; i++) {
    float x = (i * 137.0f + sin(i * 2.1f) * 40 + tiempo * (8 + i % 5 * 4)) % (width + 50) - 25;
    float y = (i * 83.0f + tiempo * (12 + i % 7 * 3)) % (height + 50) - 25;
    float tam = (5 + i % 4 * 3) * width / 1536.0f;
    float alfa = 55 + 70 * (0.5f + 0.5f * sin(tiempo * 1.1f + i));
    if (i % 3 == 0) fill(255, 210, 95, alfa);
    if (i % 3 == 1) fill(109, 239, 229, alfa);
    if (i % 3 == 2) fill(255, 105, 186, alfa);
    rect(x, y, tam, tam);
    if (i % 4 == 0) {
      rect(x - tam, y, tam * 3, tam);
      rect(x, y - tam, tam, tam * 3);
    }
  }

  // Aros de fichas y pequeños destellos que pulsan detrás de la máquina.
  noFill();
  for (int i = 0; i < 14; i++) {
    float x = width * ((i * 0.173f + 0.04f) % 1.0f);
    float y = height * ((i * 0.317f + 0.08f) % 1.0f);
    float pulso = 0.5f + 0.5f * sin(tiempo * 0.8f + i);
    stroke(255, 195, 82, 40 + pulso * 70);
    strokeWeight(max(2, width / 600.0f));
    float lado = (18 + pulso * 10) * width / 1536.0f;
    rect(x, y, lado, lado);
  }
  faDibujarCometas(tiempo);
  // Halo oscuro por bandas: evita filtros y deja contraste detrás del gabinete.
  noStroke();
  rectMode(CENTER);
  for (int i = 0; i < 16; i++) {
    fill(10, 8, 28, 8);
    rect(width * 0.5f, height * 0.5f, width * (0.48f - i * 0.018f), height * 1.1f);
  }
  popStyle();
}

void faDibujarEstrellas(float tiempo) {
  noStroke();
  float pixel = max(1, width / 960.0f);
  for (int i = 0; i < FA_TOTAL_ESTRELLAS; i++) {
    int capa = faEstrellaCapa[i];
    float velocidad = 0.002f;
    if (capa == 1) velocidad = 0.009f;
    if (capa == 2) velocidad = 0.026f;
    float x = ((faEstrellaX[i] + tiempo * velocidad) % 1.0f) * width;
    float y = ((faEstrellaY[i] + tiempo * velocidad * 0.3f) % 1.0f) * height;
    x = floor(x / pixel) * pixel;
    y = floor(y / pixel) * pixel;
    float titileo = 0.5f + 0.5f * sin(frameCount * (0.012f + i % 5 * 0.002f) + faEstrellaFase[i]);
    float alfa = 28 + titileo * 44;
    float lado = pixel;
    if (capa > 0) {
      alfa = 55 + titileo * 110;
      lado = pixel * (1 + floor(titileo * 1.9f));
    }
    fill(faEstrellaColor[i], alfa);
    rect(x, y, lado, lado);
    if (capa == 1) {
      rect(x - pixel, y, lado + pixel * 2, pixel);
      rect(x, y - pixel, pixel, lado + pixel * 2);
      if (i % 2 == 0 && titileo > 0.65f) {
        rect(x - pixel, y - pixel, pixel, pixel);
        rect(x + pixel, y + pixel, pixel, pixel);
      }
    }
    if (capa == 2) rect(x - pixel * 3, y - pixel, pixel * 2, pixel);
  }
}

void faDibujarCosmos(float tiempo) {
  noStroke();
  float pixel = max(2, width / 500.0f);
  // Dos nubes lejanas; patrones estables con deriva lenta, sin imágenes ni blur.
  for (int nube = 0; nube < 2; nube++) {
    float centroX = width * (0.17f + nube * 0.66f) + sin(tiempo * 0.018f + nube * 2) * width * 0.025f;
    float centroY = height * (0.23f + nube * 0.43f) + sin(tiempo * 0.025f + nube) * height * 0.025f;
    for (int i = 0; i < 95; i++) {
      float angulo = i * 2.39996f;
      float radio = sqrt(i / 95.0f);
      float x = centroX + cos(angulo) * radio * width * 0.13f;
      float y = centroY + sin(angulo) * radio * height * 0.11f;
      fill(90 + i % 3 * 24, 45 + nube * 10, 170, (1 - radio) * 22 + 3);
      rect(floor(x / pixel) * pixel, floor(y / pixel) * pixel, pixel * (4 + i % 5), pixel * (3 + i % 4));
    }
  }
  // Planeta anillado en el lateral superior, construido con una rejilla de bloques.
  float cx = width * 0.81f + sin(tiempo * 0.014f) * width * 0.015f;
  float cy = height * 0.20f + cos(tiempo * 0.018f) * height * 0.015f;
  for (int y = -7; y <= 7; y++) {
    for (int x = -7; x <= 7; x++) {
      if (x * x + y * y <= 49) {
        fill(88 + (x + 7) * 5, 66 + (y + 7) * 3, 155 + (x + 7) * 3, 95);
        rect(cx + x * pixel, cy + y * pixel, pixel, pixel);
      }
    }
  }
  for (int i = -14; i <= 14; i++) {
    float y = round(sin(i * 0.12f) * 3 - i * 0.25f);
    fill(147, 189, 234, 100);
    rect(cx + i * pixel, cy + y * pixel, pixel * 2, pixel);
  }
}

void faDibujarCometas(float tiempo) {
  // Cupo fijo y sin acumular eventos cuando el fondo está detenido por el zoom.
  if (tiempo >= faProximoCometa) {
    boolean creado = false;
    for (int i = 0; i < FA_TOTAL_COMETAS; i++) {
      if (!creado && !faCometaActiva[i]) {
        faCometaActiva[i] = true;
        faCometaX[i] = -0.12f;
        faCometaY[i] = random(-0.1f, 0.38f);
        faCometaVX[i] = random(0.65f, 0.9f);
        faCometaVY[i] = random(0.25f, 0.4f);
        if (random(1) > 0.5f) {
          faCometaX[i] = 1.12f;
          faCometaVX[i] *= -1;
        }
        faCometaInicio[i] = tiempo;
        faCometaVida[i] = random(1.5f, 1.9f);
        int tono = int(random(3));
        faCometaColor[i] = color(90, 237, 255);
        if (tono == 1) faCometaColor[i] = color(255, 216, 110);
        if (tono == 2) faCometaColor[i] = color(255, 110, 204);
        creado = true;
      }
    }
    faProximoCometa = tiempo + random(3.5f, 6.5f);
  }
  noStroke();
  float pixel = max(2, width / 640.0f);
  for (int i = 0; i < FA_TOTAL_COMETAS; i++) {
    if (faCometaActiva[i]) {
      float edad = tiempo - faCometaInicio[i];
      if (edad >= faCometaVida[i]) faCometaActiva[i] = false;
      if (faCometaActiva[i]) {
        float alfa = min(1, edad / 0.15f) * constrain((faCometaVida[i] - edad) / 0.4f, 0, 1);
        for (int cola = 18; cola >= 0; cola--) {
          float t = edad - cola * 0.014f;
          float x = (faCometaX[i] + faCometaVX[i] * t) * width;
          float y = (faCometaY[i] + faCometaVY[i] * t) * height;
          float brillo = 1 - cola / 19.0f;
          fill(faCometaColor[i], alfa * brillo * brillo * 180);
          rect(floor(x / pixel) * pixel, floor(y / pixel) * pixel, pixel * (1 + brillo), pixel);
          if (cola == 0) {
            fill(235, 250, 255, alfa * 220);
            rect(floor(x / pixel) * pixel, floor(y / pixel) * pixel, pixel * 2, pixel * 2);
          }
        }
      }
    }
  }
}
