// Secuencia procedural: título, negro, colonias de píxeles y explosión.
boolean t3IntroActiva = false;
int t3IntroInicio = 0;
float t3PixelLado;
final int T3_MAX_PIXELES = 8192;
final int T3_MAX_FRAGMENTOS = 16384;
final float T3_INICIO_CIERRE = 5.0f;
final float T3_INICIO_EXPLOSION = 10.0f;
final float T3_FIN_TRANSICION = 11.8f;
int t3CantidadPixeles = 0;
int t3CantidadFragmentos = 0;
boolean t3SonidoCierreDisparado = false;
boolean t3SonidoExplosionDisparado = false;
float[] t3PixelX = new float[T3_MAX_PIXELES];
float[] t3PixelY = new float[T3_MAX_PIXELES];
float[] t3PixelFase = new float[T3_MAX_PIXELES];
float[] t3PixelLlegada = new float[T3_MAX_PIXELES];
int[] t3PixelColor = new int[T3_MAX_PIXELES];
int[] t3Paleta = new int[4];
float[] t3PartX = new float[T3_MAX_FRAGMENTOS];
float[] t3PartY = new float[T3_MAX_FRAGMENTOS];
float[] t3PartVX = new float[T3_MAX_FRAGMENTOS];
float[] t3PartVY = new float[T3_MAX_FRAGMENTOS];
float[] t3PartTam = new float[T3_MAX_FRAGMENTOS];
float[] t3PartVida = new float[T3_MAX_FRAGMENTOS];
float[] t3PartOpacidad = new float[T3_MAX_FRAGMENTOS];
int[] t3PartColor = new int[T3_MAX_FRAGMENTOS];
boolean[] t3PartActiva = new boolean[T3_MAX_FRAGMENTOS];

void t3IniciarTituloNivel3() {
  detenerMediosParaSaltoDebug();
  t3Reiniciar();
  hcActiva = false;
  t3Activa = true;
  t3Etapa = 4;
  t3IntroActiva = true;
  estadoActual = HISTORIA3_ARCADE;
  estadoDestino = HISTORIA3_ARCADE;
  enTransicion = false;
  alphaTransicion = 0;
  t3IntroInicio = millis();
  t3SonidoCierreDisparado = false;
  t3SonidoExplosionDisparado = false;
  t3CantidadFragmentos = 0;
  reproducirSfx(SFX_INTRO_NIVEL, 0.7f);

  // Límite fijo de 120 x 68 celdas, incluso con pantallas altas o 4K.
  t3PixelLado = max(4, max(width / 120.0f, height / 68.0f));
  int columnas = ceil(width / t3PixelLado);
  int filas = ceil(height / t3PixelLado);
  t3CantidadPixeles = min(columnas * filas, T3_MAX_PIXELES);
  t3Paleta[0] = color(65, 220, 235);
  t3Paleta[1] = color(225, 65, 175);
  t3Paleta[2] = color(255, 211, 80);
  t3Paleta[3] = color(100, 65, 175);
  for (int fila = 0; fila < filas; fila++) {
    for (int columna = 0; columna < columnas; columna++) {
      int i = fila * columnas + columna;
      if (i < t3CantidadPixeles) {
        float x = (columna + 0.5f) * t3PixelLado;
        float y = (fila + 0.5f) * t3PixelLado;
        t3PixelX[i] = x;
        t3PixelY[i] = y;
        t3PixelFase[i] = random(TWO_PI);
        // La distancia a la esquina más cercana cierra cuatro colonias hacia el centro.
        float distancia = min(x, width - x) / width + min(y, height - y) / height;
        t3PixelLlegada[i] = max(0, distancia * 2.4f + random(0.12f));
        t3PixelColor[i] = t3Paleta[int(random(4))];
      }
    }
  }
}

void t3DibujarTransicion() {
  float segundos = ((enPausa ? pausaInicioMs : millis()) - t3IntroInicio) / 1000.0f;
  background(0);
  pushStyle();
  rectMode(CENTER);
  if (fuenteComic != null) textFont(fuenteComic);

  // Mismo título dorado y línea animada de las transiciones anteriores.
  if (segundos < 3) {
    float alfa = 255 * min(constrain(segundos / 0.5f, 0, 1), constrain((3 - segundos) / 0.5f, 0, 1));
    textAlign(CENTER, CENTER);
    fill(255, 190, 40, alfa * 0.25f);
    textSize(86 * escalaX);
    text("NIVEL 3", width / 2 + 4, height / 2 - 20 * escalaY + 4);
    fill(255, 220, 70, alfa);
    textSize(84 * escalaX);
    text("NIVEL 3", width / 2, height / 2 - 20 * escalaY);
    fill(220, 235, 255, alfa * 0.9f);
    textSize(26 * escalaX);
    text("UNA TARDE EN EL ARCADE", width / 2, height / 2 + 52 * escalaY);
    stroke(255, 200, 60, alfa * 0.8f);
    strokeWeight(3);
    float linea = 340 * escalaX * sin(segundos / 3 * PI);
    line(width / 2 - linea / 2, height / 2 + 18 * escalaY, width / 2 + linea / 2, height / 2 + 18 * escalaY);
  }

  // Cada evento se dispara una sola vez, incluso si se saltan fotogramas.
  if (segundos >= T3_INICIO_CIERRE && !t3SonidoCierreDisparado) {
    t3SonidoCierreDisparado = true;
    reproducirSfx(SFX_NV3_PIXELES_CIERRE, 0.65f);
  }
  if (segundos >= T3_INICIO_EXPLOSION && !t3SonidoExplosionDisparado) {
    t3SonidoExplosionDisparado = true;
    t3PrepararExplosion();
    reproducirSfx(SFX_NV3_PIXELES_EXPLOSION, 0.8f);
  }
  // Dos segundos de negro; cierre fino, movimiento orgánico y pantalla cubierta.
  if (segundos >= T3_INICIO_CIERRE && segundos < T3_INICIO_EXPLOSION) {
    noStroke();
    for (int i = 0; i < t3CantidadPixeles; i++) {
      float edad = segundos - T3_INICIO_CIERRE - t3PixelLlegada[i];
      if (edad >= 0) {
        float crecimiento = constrain(edad / 0.3f, 0, 1);
        float fase = t3PixelFase[i];
        float x = t3PixelX[i] + sin(segundos * 3 + fase) * t3PixelLado * 0.1f;
        float y = t3PixelY[i] + cos(segundos * 2.6f + fase) * t3PixelLado * 0.1f;
        float lado = t3PixelLado * 1.35f * crecimiento;
        fill(t3PixelColor[i]);
        rect(x, y, lado, lado);
      }
    }
  }
  if (segundos >= T3_INICIO_EXPLOSION) {
    t3DibujarExplosion(segundos - T3_INICIO_EXPLOSION);
  }
  popStyle();
  if (!enPausa && segundos >= T3_FIN_TRANSICION) {
    t3EntrarArcade();
  }
}

void t3PrepararExplosion() {
  t3CantidadFragmentos = 0;
  float escala = max(width, height) / 1920.0f;
  // Cada celda se rompe en dos fragmentos pequeños; no se crean objetos por frame.
  for (int i = 0; i < t3CantidadPixeles; i++) {
    for (int fragmento = 0; fragmento < 2; fragmento++) {
      if (t3CantidadFragmentos < T3_MAX_FRAGMENTOS) {
        int p = t3CantidadFragmentos;
        float fase = t3PixelFase[i];
        t3PartX[p] = t3PixelX[i] + sin(T3_INICIO_EXPLOSION * 3 + fase) * t3PixelLado * 0.1f + random(-0.25f, 0.25f) * t3PixelLado;
        t3PartY[p] = t3PixelY[i] + cos(T3_INICIO_EXPLOSION * 2.6f + fase) * t3PixelLado * 0.1f + random(-0.25f, 0.25f) * t3PixelLado;
        float angulo = atan2(t3PartY[p] - height * 0.5f, t3PartX[p] - width * 0.5f) + random(-0.8f, 0.8f);
        float velocidad = random(280, 1150) * escala;
        t3PartVX[p] = cos(angulo) * velocidad;
        t3PartVY[p] = sin(angulo) * velocidad;
        t3PartTam[p] = t3PixelLado * random(0.22f, 0.52f);
        t3PartVida[p] = random(1.0f, 1.8f);
        t3PartOpacidad[p] = 255;
        t3PartColor[p] = t3PixelColor[i];
        t3PartActiva[p] = true;
        t3CantidadFragmentos++;
      }
    }
  }
}

void t3DibujarExplosion(float edad) {
  noStroke();
  float gravedad = height * 0.12f;
  // Posición por tiempo absoluto: la velocidad no depende de los FPS.
  for (int p = 0; p < t3CantidadFragmentos; p++) {
    if (t3PartActiva[p]) {
      float progreso = constrain(edad / t3PartVida[p], 0, 1);
      t3PartOpacidad[p] = 255 * (1 - progreso) * (1 - progreso);
      if (progreso >= 1) t3PartActiva[p] = false;
      if (t3PartActiva[p]) {
        float recorrido = edad + 0.28f * edad * edad;
        float x = t3PartX[p] + t3PartVX[p] * recorrido;
        float y = t3PartY[p] + t3PartVY[p] * recorrido + gravedad * edad * edad;
        float lado = t3PartTam[p] * (1 - progreso * 0.85f);
        if (x > -lado && x < width + lado && y > -lado && y < height + lado) {
          fill(t3PartColor[p], t3PartOpacidad[p]);
          rect(x, y, lado, lado);
        }
      }
    }
  }
}

// Compatibilidad: cocina todavía puede llamar al nombre original.
// Ahora comienza la historia completa antes de mostrar el título del nivel.
void t3EmpezarTransicion() {
  t3EmpezarCuarto();
}
