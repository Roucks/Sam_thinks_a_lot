// =========================================================================
// MINIJUEGO 1: ENCUENTRA LAS PAREJAS
// Refactorizado con arreglos paralelos (
// =========================================================================

int parEstadoJuego = 0; // 0 = Inicio, 1 = Juego, 2 = Victoria, 3 = Derrota
int parNivelActual = 1;
int parMaxNiveles = 10;
int parFilas = 2, parColumnas = 2;

// arreglos paralelos para manejar todas las cartas sin usar POO xd
int[] parCartas;
boolean[] parReveladas;
boolean[] parEncontradas;
float[] parCartaAnimVolteo;
float[] parCartaOffsetY;
float[] parCartaZoom;
float[] parCartaAngulo;
float[] parCartaX;
float[] parCartaY;
float[] parCartaW;
float[] parCartaH;

int parPrimeraSeleccion = -1;
int parSegundaSeleccion = -1;
int parTimerEspera = 0;
boolean parBloqueado = false;

int parTiempoInicioGlobal;
int parLimiteTiempoGlobal = 120;
int parTiempoAcumuladoExtra = 0;
int parTiempoRestante;

int parTimerNotificacionTiempo = 0;
String parTextoNotificacion = "";
float parPosNotifX = 0;
float parPosNotifY = 0;
boolean parIniciado = false;

void iniciarJuegoParejas() {
  parEstadoJuego = 0;
  parNivelActual = 1;
  parTiempoAcumuladoExtra = 0;
  parIniciado = true;
}

// inicializa los arreglos paralelos de animacion y posicion de las cartas
void parInicializarArreglosCartas(int totalCartas) {
  parTotalCartasAnimadas = totalCartas;
  parCartaAnimVolteo = new float[totalCartas];
  parCartaOffsetY = new float[totalCartas];
  parCartaZoom = new float[totalCartas];
  parCartaAngulo = new float[totalCartas];
  parCartaX = new float[totalCartas];
  parCartaY = new float[totalCartas];
  parCartaW = new float[totalCartas];
  parCartaH = new float[totalCartas];

  for (int i = 0; i < totalCartas; i++) {
    parCartaAnimVolteo[i] = 0.0f;
    parCartaOffsetY[i] = 0.0f;
    parCartaZoom[i] = 1.0f;
    parCartaAngulo[i] = 0.0f;
    parCartaX[i] = 0.0f;
    parCartaY[i] = 0.0f;
    parCartaW[i] = 0.0f;
    parCartaH[i] = 0.0f;
  }
}

void parIniciarNivel() {
  switch(parNivelActual) {
    case 1: parFilas = 2; parColumnas = 2; break;
    case 2: parFilas = 3; parColumnas = 2; break;
    case 3: parFilas = 4; parColumnas = 2; break;
    case 4: parFilas = 4; parColumnas = 3; break;
    case 5: parFilas = 4; parColumnas = 4; break;
    case 6: parFilas = 5; parColumnas = 4; break;
    default: parFilas = 6; parColumnas = 4; break;
  }

  int totalCartas = parFilas * parColumnas;
  parCartas = new int[totalCartas];
  parReveladas = new boolean[totalCartas];
  parEncontradas = new boolean[totalCartas];

  for (int i = 0; i < totalCartas / 2; i++) {
    int idFigura = i % 15;
    parCartas[i * 2] = idFigura;
    parCartas[i * 2 + 1] = idFigura;
  }

  // mezclamos las cartas con Fisher-Yates
  for (int i = totalCartas - 1; i > 0; i--) {
    int j = int(random(i + 1));
    int temp = parCartas[i];
    parCartas[i] = parCartas[j];
    parCartas[j] = temp;
  }

  parInicializarArreglosCartas(totalCartas);

  parPrimeraSeleccion = -1;
  parSegundaSeleccion = -1;
  parBloqueado = false;
}

void parActualizarTiempo() {
  int transcurrido = (millis() - parTiempoInicioGlobal) / 1000;
  parTiempoRestante = (parLimiteTiempoGlobal + parTiempoAcumuladoExtra) - transcurrido;

  if (parTiempoRestante <= 0) {
    parTiempoRestante = 0;
    parEstadoJuego = 3;
  }
}

void parVerificarVictoriaNivel() {
  boolean nivelCompletado = true;
  for (int i = 0; i < (parFilas * parColumnas); i++) {
    if (!parEncontradas[i]) {
      nivelCompletado = false;
      break;
    }
  }

  if (nivelCompletado) {
    if (parNivelActual < parMaxNiveles) {
      parNivelActual++;
      parTiempoAcumuladoExtra += 10;
      parTextoNotificacion = "¡NIVEL SUPERADO! +10s";
      parPosNotifX = width / 2.0f;
      parPosNotifY = 62;
      parTimerNotificacionTiempo = millis() + 1500;
      parIniciarNivel();
    } else {
      parEstadoJuego = 2;
      puntosJugador += 35;
      bienestarDigital = min(100, bienestarDigital + 10);
    }
  }
}

void dibujarJuegoParejas(float w, float h) {
  pushStyle();
  if (fuenteComic != null) {
    textFont(fuenteComic);
  }
  smooth();
  try {
    if (g instanceof processing.awt.PGraphicsJava2D) {
      java.awt.Graphics2D g2 = ((processing.awt.PGraphicsJava2D) g).g2;
      if (g2 != null) {
        g2.setRenderingHint(java.awt.RenderingHints.KEY_INTERPOLATION, java.awt.RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g2.setRenderingHint(java.awt.RenderingHints.KEY_ANTIALIASING, java.awt.RenderingHints.VALUE_ANTIALIAS_ON);
      }
    }
  } catch (Exception e) {}

  if (imgFondoCartas != null) {
    imageMode(CORNER);
    image(imgFondoCartas, 0, 0, w, h);
  } else {
    if (fondoPrimerPiso != null || fondoHabitacion != null) {
      imageMode(CORNER);
      image(fondoPrimerPiso != null ? fondoPrimerPiso : fondoHabitacion, 0, 0, w, h);
      fill(15, 23, 42, 215);
      noStroke();
      rect(0, 0, w, h);
    } else {
      fill(20, 27, 45);
      noStroke();
      rect(0, 0, w, h);
    }
  }

  float btnVolverX = (w > 600) ? 35 * escalaX : 10;
  float btnVolverY = (w > 600) ? 20 * escalaY : 30;
  float btnVolverW = (w > 600) ? 210 * escalaX : 100;
  float btnVolverH = (w > 600) ? 46 * escalaY : 26;
  boolean hoverVolver = (mouseX >= btnVolverX && mouseX <= btnVolverX + btnVolverW && mouseY >= btnVolverY && mouseY <= btnVolverY + btnVolverH);

  pushStyle();
  fill(0, 70);
  noStroke();
  rect(btnVolverX + 2, btnVolverY + 3, btnVolverW, btnVolverH, (w > 600 ? 12 * escalaX : 6));

  fill(hoverVolver ? color(37, 99, 235) : color(30, 41, 59, 230));
  stroke(hoverVolver ? color(147, 197, 253) : color(71, 85, 105));
  strokeWeight((w > 600 ? 2.0f * escalaX : 1.2f));
  rect(btnVolverX, btnVolverY, btnVolverW, btnVolverH, (w > 600 ? 10 * escalaX : 6));

  fill(hoverVolver ? color(255) : color(226, 232, 240));
  textAlign(CENTER, CENTER);
  textSize((w > 600 ? 16 * escalaX : 10));
  text("< Volver al celular", btnVolverX + btnVolverW / 2.0f, btnVolverY + btnVolverH / 2.0f - 1);
  popStyle();

  if (parEstadoJuego == 0) {
    fill(255);
    textAlign(CENTER, CENTER);
    textSize((w > 600) ? 34 * escalaX : 18);
    text("¡ENCUENTRA LAS PAREJAS!", w / 2.0f, h * 0.30f);

    fill(148, 163, 184);
    textSize((w > 600) ? 18 * escalaX : 11.5f);
    text("Supera 10 niveles antes del tiempo", w / 2.0f, h * 0.38f);
    text("- +1s por cada pareja encontrada", w / 2.0f, h * 0.44f);
    text("- +10s de bonificación al pasar de nivel", w / 2.0f, h * 0.49f);

    fill(59, 130, 246);
    float btnJW = (w > 600) ? 220 * escalaX : 140;
    float btnJH = (w > 600) ? 52 * escalaY : 36;
    rect(w / 2.0f - btnJW / 2.0f, h * 0.58f, btnJW, btnJH, (w > 600 ? 12 * escalaX : 10));
    fill(255);
    textSize((w > 600) ? 19 * escalaX : 13.5f);
    text("JUGAR AHORA", w / 2.0f, h * 0.58f + btnJH / 2.0f);

    fill(51, 65, 85);
    float btnSW = (w > 600) ? 200 * escalaX : 100;
    float btnSH = (w > 600) ? 44 * escalaY : 28;
    rect(w / 2.0f - btnSW / 2.0f, h * 0.70f, btnSW, btnSH, (w > 600 ? 10 * escalaX : 8));
    fill(203, 213, 225);
    textSize((w > 600) ? 16 * escalaX : 11);
    text("< Volver al celular", w / 2.0f, h * 0.70f + btnSH / 2.0f);
  } else {
    if (parEstadoJuego == 1) {
      parActualizarTiempo();

      float headerY = (w > 600) ? 20 * escalaY : 28;
      float headerH = (w > 600) ? 46 * escalaY : 32;
      float headerW = (w > 600) ? 460 * escalaX : 180;
      float headerX = w / 2.0f - headerW / 2.0f;

      fill(22, 30, 46, 230);
      stroke(51, 65, 85);
      strokeWeight((w > 600 ? 1.6f * escalaX : 1.0f));
      rect(headerX, headerY, headerW, headerH, (w > 600 ? 22 * escalaX : 8));

      fill(226, 232, 240);
      textAlign(LEFT, CENTER);
      textSize((w > 600) ? 17 * escalaX : 11.5f);
      text("Nivel: " + parNivelActual + " / " + parMaxNiveles, headerX + (w > 600 ? 25 * escalaX : 8), headerY + headerH / 2.0f);

      textAlign(RIGHT, CENTER);
      if (parTiempoRestante <= 15) {
        fill(239, 68, 68);
      } else {
        fill(52, 211, 153);
      }
      textSize((w > 600) ? 17 * escalaX : 11.5f);
      text("Tiempo: " + parTiempoRestante + "s", headerX + headerW - (w > 600 ? 25 * escalaX : 8), headerY + headerH / 2.0f);

      float margenSuperior = (w > 600) ? 96.0f * escalaY : 66.0f;
      float margenInferior = (w > 600) ? 36.0f * escalaY : 12.0f;
      float margenLatMin = (w > 600) ? 60.0f * escalaX : 10.0f;

      float dispW = w - (margenLatMin * 2.0f);
      float dispH = h - margenSuperior - margenInferior;
      float gapX = (w > 600) ? 18.0f * escalaX : 4.0f;
      float gapY = (w > 600) ? 18.0f * escalaY : 4.0f;

      float cardRatio = (imgCartaFrente != null && imgCartaFrente.height > 0) ? ((float)imgCartaFrente.width / (float)imgCartaFrente.height) : (2.0f / 3.0f);
      float maxCw_fromW = (dispW - (parColumnas - 1) * gapX) / parColumnas;
      float maxCh_fromH = (dispH - (parFilas - 1) * gapY) / parFilas;
      float maxCw_fromH = maxCh_fromH * cardRatio;

      float anchoCarta = min(maxCw_fromW, maxCw_fromH);
      float altoCarta = anchoCarta / cardRatio;

      float maxAltoDeseado = (w > 600) ? min(300.0f * escalaY, dispH * 0.85f) : altoCarta;
      if (altoCarta > maxAltoDeseado) {
        altoCarta = maxAltoDeseado;
        anchoCarta = altoCarta * cardRatio;
      }

      float gridW = parColumnas * anchoCarta + (parColumnas - 1) * gapX;
      float gridH = parFilas * altoCarta + (parFilas - 1) * gapY;
      float inicioX = (w - gridW) / 2.0f;
      float inicioY = margenSuperior + (dispH - gridH) / 2.0f;

      if (parBloqueado && millis() > parTimerEspera) {
        if (parPrimeraSeleccion >= 0 && parPrimeraSeleccion < (parFilas * parColumnas)) {
          parReveladas[parPrimeraSeleccion] = false;
        }
        if (parSegundaSeleccion >= 0 && parSegundaSeleccion < (parFilas * parColumnas)) {
          parReveladas[parSegundaSeleccion] = false;
        }
        parPrimeraSeleccion = -1;
        parSegundaSeleccion = -1;
        parBloqueado = false;
      }

      if (parCartaAnimVolteo == null || parTotalCartasAnimadas != (parFilas * parColumnas)) {
        parInicializarArreglosCartas((parFilas * parColumnas));
      }

      for (int i = 0; i < (parFilas * parColumnas); i++) {
        int col = i % parColumnas;
        int fila = i / parColumnas;
        float cx = inicioX + col * (anchoCarta + gapX);
        float cy = inicioY + fila * (altoCarta + gapY);
        parSetBoundsCarta(i, cx, cy, anchoCarta, altoCarta);

        boolean esSeleccionada = (i == parPrimeraSeleccion || i == parSegundaSeleccion);
        boolean esEncontrada = parEncontradas[i];
        parActualizarCarta(i, esSeleccionada, esEncontrada);
      }

      for (int i = 0; i < (parFilas * parColumnas); i++) {
        boolean activa = (parCartaAnimVolteo[i] > 0.05f && (i == parPrimeraSeleccion || i == parSegundaSeleccion || abs(parCartaOffsetY[i]) > 0.5f || parCartaZoom[i] > 1.02f || !parEncontradas[i]));
        if (!activa) {
          parDibujarCarta(i);
        }
      }
      for (int i = 0; i < (parFilas * parColumnas); i++) {
        boolean activa = (parCartaAnimVolteo[i] > 0.05f && (i == parPrimeraSeleccion || i == parSegundaSeleccion || abs(parCartaOffsetY[i]) > 0.5f || parCartaZoom[i] > 1.02f || !parEncontradas[i]));
        if (activa) {
          parDibujarCarta(i);
        }
      }

      if (millis() < parTimerNotificacionTiempo) {
        fill(52, 211, 153);
        textAlign(CENTER, CENTER);
        textSize((w > 600) ? 26 * escalaX : 13.5f);
        float notifX = parTextoNotificacion.startsWith("¡NIVEL") ? (w / 2.0f) : parPosNotifX;
        float notifY = parTextoNotificacion.startsWith("¡NIVEL") ? (headerY + headerH + 34 * escalaY) : parPosNotifY;
        text(parTextoNotificacion, notifX, notifY);
        if (!parTextoNotificacion.startsWith("¡NIVEL")) {
          parPosNotifY -= 0.3f;
        }
      }
    } else {
      if (parEstadoJuego == 2) {
        fill(34, 197, 94);
        textAlign(CENTER, CENTER);
        textSize((w > 600) ? 36 * escalaX : 20);
        text("¡VICTORIA TOTAL!", w / 2.0f, h * 0.34f);

        fill(255);
        textSize((w > 600) ? 20 * escalaX : 12.5f);
        text("¡Completaste los 10 niveles a tiempo!", w / 2.0f, h * 0.43f);
        text("+35 Puntos ganados", w / 2.0f, h * 0.49f);

        fill(34, 197, 94);
        float btnVW = (w > 600) ? 220 * escalaX : 130;
        float btnVH = (w > 600) ? 50 * escalaY : 34;
        rect(w / 2.0f - btnVW / 2.0f, h * 0.58f, btnVW, btnVH, (w > 600 ? 12 * escalaX : 8));
        fill(255);
        textSize((w > 600) ? 18 * escalaX : 12);
        text("JUGAR DE NUEVO", w / 2.0f, h * 0.58f + btnVH / 2.0f);

        fill(51, 65, 85);
        float btnVSW = (w > 600) ? 200 * escalaX : 100;
        float btnVSH = (w > 600) ? 44 * escalaY : 28;
        rect(w / 2.0f - btnVSW / 2.0f, h * 0.69f, btnVSW, btnVSH, (w > 600 ? 10 * escalaX : 8));
        fill(203, 213, 225);
        textSize((w > 600) ? 16 * escalaX : 10.5f);
        text("< Volver al celular", w / 2.0f, h * 0.69f + btnVSH / 2.0f);
      } else {
        if (parEstadoJuego == 3) {
          fill(239, 68, 68);
          textAlign(CENTER, CENTER);
          textSize((w > 600) ? 36 * escalaX : 19);
          text("¡SE AGOTÓ EL TIEMPO!", w / 2.0f, h * 0.34f);

          fill(255);
          textSize((w > 600) ? 20 * escalaX : 12.5f);
          text("Llegaste hasta el Nivel " + parNivelActual, w / 2.0f, h * 0.44f);

          fill(239, 68, 68);
          float btnDW = (w > 600) ? 220 * escalaX : 130;
          float btnDH = (w > 600) ? 50 * escalaY : 34;
          rect(w / 2.0f - btnDW / 2.0f, h * 0.58f, btnDW, btnDH, (w > 600 ? 12 * escalaX : 8));
          fill(255);
          textSize((w > 600) ? 18 * escalaX : 12);
          text("REINTENTAR", w / 2.0f, h * 0.58f + btnDH / 2.0f);

          fill(51, 65, 85);
          float btnDSW = (w > 600) ? 200 * escalaX : 100;
          float btnDSH = (w > 600) ? 44 * escalaY : 28;
          rect(w / 2.0f - btnDSW / 2.0f, h * 0.69f, btnDSW, btnDSH, (w > 600 ? 10 * escalaX : 8));
          fill(203, 213, 225);
          textSize((w > 600) ? 16 * escalaX : 10.5f);
          text("< Volver al celular", w / 2.0f, h * 0.69f + btnDSH / 2.0f);
        }
      }
    }
  }
  popStyle();
}

void procesarClicParejas(float relX, float relY, float w, float h) {
  float btnVolverX = (w > 600) ? 35 * escalaX : 10;
  float btnVolverY = (w > 600) ? 20 * escalaY : 30;
  float btnVolverW = (w > 600) ? 210 * escalaX : 100;
  float btnVolverH = (w > 600) ? 46 * escalaY : 26;
  if (relX >= btnVolverX && relX <= btnVolverX + btnVolverW && relY >= btnVolverY && relY <= btnVolverY + btnVolverH) {
    enHome = true;
    if (sonidoClic != null) { sonidoClic.amp(0.35f * volMaster); sonidoClic.play(); }
  } else {
    if (parEstadoJuego == 0) {
      float btnJW = (w > 600) ? 220 * escalaX : 140;
      float btnJH = (w > 600) ? 52 * escalaY : 36;
      if (relX >= w / 2.0f - btnJW / 2.0f && relX <= w / 2.0f + btnJW / 2.0f && relY >= h * 0.58f && relY <= h * 0.58f + btnJH) {
        parEstadoJuego = 1;
        parNivelActual = 1;
        parTiempoAcumuladoExtra = 0;
        parTiempoInicioGlobal = millis();
        parIniciarNivel();
        if (sonidoClic != null) { sonidoClic.amp(0.35f * volMaster); sonidoClic.play(); }
      } else {
        float btnSW = (w > 600) ? 200 * escalaX : 100;
        float btnSH = (w > 600) ? 44 * escalaY : 28;
        if (relX >= w / 2.0f - btnSW / 2.0f && relX <= w / 2.0f + btnSW / 2.0f && relY >= h * 0.70f && relY <= h * 0.70f + btnSH) {
          enHome = true;
          if (sonidoClic != null) { sonidoClic.amp(0.3f * volMaster); sonidoClic.play(); }
        }
      }
    } else {
      if (parEstadoJuego == 2 || parEstadoJuego == 3) {
        float btnW = (w > 600) ? 220 * escalaX : 130;
        float btnH = (w > 600) ? 50 * escalaY : 34;
        if (relX >= w / 2.0f - btnW / 2.0f && relX <= w / 2.0f + btnW / 2.0f && relY >= h * 0.58f && relY <= h * 0.58f + btnH) {
          parEstadoJuego = 1;
          parNivelActual = 1;
          parTiempoAcumuladoExtra = 0;
          parTiempoInicioGlobal = millis();
          parIniciarNivel();
          if (sonidoClic != null) { sonidoClic.amp(0.35f * volMaster); sonidoClic.play(); }
        } else {
          float btnSW = (w > 600) ? 200 * escalaX : 100;
          float btnSH = (w > 600) ? 44 * escalaY : 28;
          if (relX >= w / 2.0f - btnSW / 2.0f && relX <= w / 2.0f + btnSW / 2.0f && relY >= h * 0.69f && relY <= h * 0.69f + btnSH) {
            enHome = true;
            if (sonidoClic != null) { sonidoClic.amp(0.3f * volMaster); sonidoClic.play(); }
          }
        }
      } else {
        if (parEstadoJuego == 1 && !parBloqueado) {
          float margenSuperior = (w > 600) ? 96.0f * escalaY : 66.0f;
          float margenInferior = (w > 600) ? 36.0f * escalaY : 12.0f;
          float margenLatMin = (w > 600) ? 60.0f * escalaX : 10.0f;

          float dispW = w - (margenLatMin * 2.0f);
          float dispH = h - margenSuperior - margenInferior;
          float gapX = (w > 600) ? 18.0f * escalaX : 4.0f;
          float gapY = (w > 600) ? 18.0f * escalaY : 4.0f;

          float cardRatio = (imgCartaFrente != null && imgCartaFrente.height > 0) ? ((float)imgCartaFrente.width / (float)imgCartaFrente.height) : (2.0f / 3.0f);
          float maxCw_fromW = (dispW - (parColumnas - 1) * gapX) / parColumnas;
          float maxCh_fromH = (dispH - (parFilas - 1) * gapY) / parFilas;
          float maxCw_fromH = maxCh_fromH * cardRatio;

          float anchoCarta = min(maxCw_fromW, maxCw_fromH);
          float altoCarta = anchoCarta / cardRatio;

          float maxAltoDeseado = (w > 600) ? min(300.0f * escalaY, dispH * 0.85f) : altoCarta;
          if (altoCarta > maxAltoDeseado) {
            altoCarta = maxAltoDeseado;
            anchoCarta = altoCarta * cardRatio;
          }

          float gridW = parColumnas * anchoCarta + (parColumnas - 1) * gapX;
          float gridH = parFilas * altoCarta + (parFilas - 1) * gapY;
          float inicioX = (w - gridW) / 2.0f;
          float inicioY = margenSuperior + (dispH - gridH) / 2.0f;

          boolean clicCartaHecho = false;
          for (int i = 0; i < (parFilas * parColumnas); i++) {
            if (!clicCartaHecho) {
              int col = i % parColumnas;
              int fila = i / parColumnas;
              float cx = inicioX + col * (anchoCarta + gapX);
              float cy = inicioY + fila * (altoCarta + gapY);

              if (relX >= cx && relX <= cx + anchoCarta && relY >= cy && relY <= cy + altoCarta) {
                if (!parReveladas[i] && !parEncontradas[i]) {
                  parReveladas[i] = true;
                  if (sonidoClic != null) { sonidoClic.amp(0.25f * volMaster); sonidoClic.play(); }

                  if (parPrimeraSeleccion == -1) {
                    parPrimeraSeleccion = i;
                  } else {
                    parSegundaSeleccion = i;
                    if (parCartas[parPrimeraSeleccion] == parCartas[parSegundaSeleccion]) {
                      parEncontradas[parPrimeraSeleccion] = true;
                      parEncontradas[parSegundaSeleccion] = true;

                      parTiempoAcumuladoExtra += 1;
                      parTextoNotificacion = "+1s!";
                      parPosNotifX = cx + anchoCarta / 2.0f;
                      parPosNotifY = cy - 4;
                      parTimerNotificacionTiempo = millis() + 900;

                      parPrimeraSeleccion = -1;
                      parSegundaSeleccion = -1;
                      parVerificarVictoriaNivel();
                    } else {
                      parBloqueado = true;
                      parTimerEspera = millis() + 700;
                    }
                  }
                }
                clicCartaHecho = true;
              }
            }
          }
        }
      }
    }
  }
}

// =========================================================================
// SUBRUTINAS DE LAS CARTAS (REEMPLAZO DE POO CON ARREGLOS PARALELOS)
// =========================================================================

void parSetBoundsCarta(int idx, float x, float y, float w, float h) {
  parCartaX[idx] = x;
  parCartaY[idx] = y;
  parCartaW[idx] = w;
  parCartaH[idx] = h;
}

void parActualizarCarta(int idx, boolean seleccionada, boolean encontrada) {
  float targetVolteo = (seleccionada || encontrada) ? 1.0f : 0.0f;
  float targetOffsetY = seleccionada ? -18.0f : 0.0f;
  float targetZoom = seleccionada ? 1.12f : 1.0f;
  float targetAngulo = seleccionada ? (sin(frameCount * 0.12f) * 0.05f) : 0.0f;

  parCartaAnimVolteo[idx] = lerp(parCartaAnimVolteo[idx], targetVolteo, 0.16f);
  parCartaOffsetY[idx] = lerp(parCartaOffsetY[idx], targetOffsetY, 0.18f);
  parCartaZoom[idx] = lerp(parCartaZoom[idx], targetZoom, 0.18f);
  parCartaAngulo[idx] = lerp(parCartaAngulo[idx], targetAngulo, 0.18f);

  if (abs(parCartaAnimVolteo[idx] - targetVolteo) < 0.005f) { parCartaAnimVolteo[idx] = targetVolteo; }
  if (abs(parCartaOffsetY[idx] - targetOffsetY) < 0.1f) { parCartaOffsetY[idx] = targetOffsetY; }
  if (abs(parCartaZoom[idx] - targetZoom) < 0.005f) { parCartaZoom[idx] = targetZoom; }
  if (abs(parCartaAngulo[idx] - targetAngulo) < 0.002f) { parCartaAngulo[idx] = targetAngulo; }
}

void parDibujarCarta(int idx) {
  pushMatrix();
  pushStyle();
  smooth();

  float x = parCartaX[idx];
  float y = parCartaY[idx];
  float w = parCartaW[idx];
  float h = parCartaH[idx];
  float zoom = parCartaZoom[idx];
  float offsetY = parCartaOffsetY[idx];
  float angulo = parCartaAngulo[idx];
  float animVolteo = parCartaAnimVolteo[idx];
  int id = parCartas[idx];

  float centroX = x + w / 2.0f;
  float centroY = y + h / 2.0f;

  float sombraOffset = map(zoom, 1.0f, 1.12f, 4.0f, 15.0f) - offsetY * 0.35f;
  float sombraAlpha = map(zoom, 1.0f, 1.12f, 40.0f, 95.0f);
  fill(0, sombraAlpha);
  noStroke();
  rectMode(CENTER);
  rect(centroX, centroY + sombraOffset, w * 0.94f * zoom, h * 0.94f * zoom, 10);

  translate(centroX, centroY + offsetY);
  rotate(angulo);
  scale(zoom);

  float escalaXVolteo = max(0.01f, abs(cos(animVolteo * PI)));
  scale(escalaXVolteo, 1.0f);

  imageMode(CENTER);
  rectMode(CENTER);

  if (animVolteo < 0.5f) {
    if (imgCartaReverso != null) {
      image(imgCartaReverso, 0, 0, w, h);
    } else {
      fill(45, 55, 75);
      stroke(20, 30, 45);
      strokeWeight(1.5f);
      rect(0, 0, w, h, 8);
      fill(148, 163, 184);
      textAlign(CENTER, CENTER);
      textSize(min(w, h) * 0.4f);
      text("?", 0, 0);
    }
  } else {
    if (imgCartaFrente != null) {
      image(imgCartaFrente, 0, 0, w, h);
    } else {
      fill(248, 250, 252);
      stroke(203, 213, 225);
      strokeWeight(1.5f);
      rect(0, 0, w, h, 8);
    }

    int idValido = abs(id) % 15;
    if (imgFiguras != null && idValido < TAM_IMG_FIGURAS && imgFiguras[idValido] != null) {
      float tamano = min(w, h) * 0.65f;
      image(imgFiguras[idValido], 0, 0, tamano, tamano);
    } else {
      String nombre = (idValido < TAM_NOMBRES_FIGURAS) ? nombresFiguras[idValido].toUpperCase() : "FIGURA";
      fill(78, 42, 18);
      textAlign(CENTER, CENTER);
      float tamTexto = min(w, h) * (nombre.length() > 8 ? 0.13f : 0.16f);
      textSize(tamTexto);
      text(nombre, 0, 0);
    }
  }

  popStyle();
  popMatrix();
}

PImage quitarFondoNegro(PImage img) {
  PImage res = null;
  if (img != null) {
    res = img;
    img.loadPixels();
    int w = img.width;
    int h = img.height;
    if (w > 0 && h > 0) {
      res = createImage(w, h, ARGB);
      res.copy(img, 0, 0, w, h, 0, 0, w, h);
      res.loadPixels();

      boolean[] visitado = new boolean[w * h];
      int[] cola = new int[w * h];
      int ini = 0, fin = 0;
      int umbral = 35;

      int[] semillasX = { 0, w - 1, 0, w - 1 };
      int[] semillasY = { 0, 0, h - 1, h - 1 };

      for (int k = 0; k < 4; k++) {
        int idx = semillasY[k] * w + semillasX[k];
        int c = res.pixels[idx];
        if (((c >> 16) & 0xFF) <= umbral && ((c >> 8) & 0xFF) <= umbral && (c & 0xFF) <= umbral && !visitado[idx]) {
          visitado[idx] = true;
          cola[fin++] = idx;
        }
      }

      for (int x = 0; x < w; x++) {
        int idxTop = x;
        int c = res.pixels[idxTop];
        if (!visitado[idxTop] && ((c >> 16) & 0xFF) <= umbral && ((c >> 8) & 0xFF) <= umbral && (c & 0xFF) <= umbral) {
          visitado[idxTop] = true;
          cola[fin++] = idxTop;
        }
        int idxBot = (h - 1) * w + x;
        c = res.pixels[idxBot];
        if (!visitado[idxBot] && ((c >> 16) & 0xFF) <= umbral && ((c >> 8) & 0xFF) <= umbral && (c & 0xFF) <= umbral) {
          visitado[idxBot] = true;
          cola[fin++] = idxBot;
        }
      }

      for (int y = 0; y < h; y++) {
        int idxL = y * w;
        int c = res.pixels[idxL];
        if (!visitado[idxL] && ((c >> 16) & 0xFF) <= umbral && ((c >> 8) & 0xFF) <= umbral && (c & 0xFF) <= umbral) {
          visitado[idxL] = true;
          cola[fin++] = idxL;
        }
        int idxR = y * w + (w - 1);
        c = res.pixels[idxR];
        if (!visitado[idxR] && ((c >> 16) & 0xFF) <= umbral && ((c >> 8) & 0xFF) <= umbral && (c & 0xFF) <= umbral) {
          visitado[idxR] = true;
          cola[fin++] = idxR;
        }
      }

      while (ini < fin) {
        int curr = cola[ini++];
        int cx = curr % w;
        int cy = curr / w;

        if (cx > 0) {
          int nidx = curr - 1;
          int c = res.pixels[nidx];
          if (!visitado[nidx] && ((c >> 16) & 0xFF) <= umbral && ((c >> 8) & 0xFF) <= umbral && (c & 0xFF) <= umbral) {
            visitado[nidx] = true;
            cola[fin++] = nidx;
          }
        }
        if (cx < w - 1) {
          int nidx = curr + 1;
          int c = res.pixels[nidx];
          if (!visitado[nidx] && ((c >> 16) & 0xFF) <= umbral && ((c >> 8) & 0xFF) <= umbral && (c & 0xFF) <= umbral) {
            visitado[nidx] = true;
            cola[fin++] = nidx;
          }
        }
        if (cy > 0) {
          int nidx = curr - w;
          int c = res.pixels[nidx];
          if (!visitado[nidx] && ((c >> 16) & 0xFF) <= umbral && ((c >> 8) & 0xFF) <= umbral && (c & 0xFF) <= umbral) {
            visitado[nidx] = true;
            cola[fin++] = nidx;
          }
        }
        if (cy < h - 1) {
          int nidx = curr + w;
          int c = res.pixels[nidx];
          if (!visitado[nidx] && ((c >> 16) & 0xFF) <= umbral && ((c >> 8) & 0xFF) <= umbral && (c & 0xFF) <= umbral) {
            visitado[nidx] = true;
            cola[fin++] = nidx;
          }
        }
      }

      for (int i = 0; i < w * h; i++) {
        if (visitado[i]) res.pixels[i] = 0x00000000;
      }
      res.updatePixels();
    }
  }
  return res;
}

PImage limpiarCarta(PImage img) {
  PImage res = null;
  if (img != null) {
    res = img;
    img.loadPixels();
    int w = img.width;
    int h = img.height;
    if (w > 0 && h > 0) {
      int umbral = 35;
      int minX = w, maxX = -1, minY = h, maxY = -1;

      for (int y = 0; y < h; y++) {
        int filaIdx = y * w;
        for (int x = 0; x < w; x++) {
          int c = img.pixels[filaIdx + x];
          int r = (c >> 16) & 0xFF;
          int g = (c >> 8) & 0xFF;
          int b = c & 0xFF;
          if (r > umbral || g > umbral || b > umbral) {
            if (x < minX) minX = x;
            if (x > maxX) maxX = x;
            if (y < minY) minY = y;
            if (y > maxY) maxY = y;
          }
        }
      }

      if (maxX <= minX || maxY <= minY) {
        res = quitarFondoNegro(img);
      } else {
        int cropW = maxX - minX + 1;
        int cropH = maxY - minY + 1;
        PImage recortada = img.get(minX, minY, cropW, cropH);
        res = quitarFondoNegro(recortada);
      }
    }
  }
  return res;
}

void dibujarFiguraInfantil(int id) {
  rectMode(CENTER);
  ellipseMode(CENTER);
  noStroke();

  int idValido = abs(id) % 15;
  switch(idValido) {
    case 0:
      fill(180, 100, 40); ellipse(0, 0, 50, 45);
      fill(120, 60, 20); ellipse(-22, -5, 20, 35); ellipse(22, -5, 20, 35);
      fill(0); ellipse(-10, -5, 8, 8); ellipse(10, -5, 8, 8); ellipse(0, 10, 12, 8);
      fill(255, 100, 100); ellipse(0, 18, 10, 12);
      break;
    case 1:
      fill(245, 158, 11); ellipse(0, 5, 50, 42);
      triangle(-22, -10, -10, -30, -2, -10); triangle(2, -10, 10, -30, 22, -10);
      fill(16, 185, 129); ellipse(-10, 0, 10, 12); ellipse(10, 0, 10, 12);
      fill(0); ellipse(-10, 0, 4, 8); ellipse(10, 0, 4, 8); triangle(-4, 8, 4, 8, 0, 12);
      break;
    case 2:
      fill(245, 158, 11); triangle(0, 25, -30, -25, 30, -25);
      fill(180, 80, 20); rect(0, -28, 64, 12, 4);
      fill(220, 38, 38); ellipse(-8, -5, 12, 12); ellipse(10, 5, 10, 10); ellipse(-2, -18, 10, 10);
      break;
    case 3:
      fill(239, 68, 68); ellipse(-12, 0, 32, 40); ellipse(12, 0, 32, 40);
      fill(120, 60, 20); rect(0, -22, 5, 12, 2);
      fill(34, 197, 94); ellipse(8, -22, 14, 8);
      break;
    case 4:
      fill(250, 204, 21);
      beginShape();
      for (int i = 0; i < 5; i++) {
        float aA = TWO_PI * i / 5.0f - HALF_PI;
        float aB = TWO_PI * (i + 0.5f) / 5.0f - HALF_PI;
        vertex(cos(aA) * 30, sin(aA) * 30);
        vertex(cos(aB) * 14, sin(aB) * 14);
      }
      endShape(CLOSE);
      break;
    case 5:
      fill(239, 68, 68); rect(0, 5, 54, 22, 6); rect(-4, -10, 32, 16, 4);
      fill(147, 197, 253); rect(-4, -10, 26, 10, 2);
      fill(30); ellipse(-16, 18, 16, 16); ellipse(16, 18, 16, 16);
      break;
    case 6:
      fill(250, 204, 21); ellipse(0, 0, 34, 34);
      stroke(250, 204, 21); strokeWeight(4);
      for (int i = 0; i < 8; i++) {
        float a = TWO_PI * i / 8.0f;
        line(cos(a) * 22, sin(a) * 22, cos(a) * 30, sin(a) * 30);
      }
      noStroke();
      break;
    case 7:
      fill(248, 250, 252); ellipse(0, 0, 44, 44);
      fill(241, 245, 249); ellipse(12, -8, 36, 36);
      break;
    case 8:
      fill(59, 130, 246); ellipse(-5, 0, 42, 28); triangle(12, 0, 30, -14, 30, 14);
      fill(255); ellipse(-16, -4, 10, 10); fill(0); ellipse(-17, -4, 4, 4);
      break;
    case 9:
      fill(236, 72, 153); ellipse(0, 0, 44, 44);
      fill(255); arc(0, 0, 44, 44, 0, HALF_PI); arc(0, 0, 44, 44, PI, PI + HALF_PI);
      break;
    case 10:
      fill(245, 158, 11); triangle(0, 25, -16, -5, 16, -5);
      fill(244, 114, 182); ellipse(0, -12, 36, 32);
      fill(220, 38, 38); ellipse(0, -28, 12, 12);
      break;
    case 11:
      fill(168, 85, 247); rect(0, 2, 42, 40, 12);
      fill(255); ellipse(0, -6, 20, 20); fill(0); ellipse(0, -6, 8, 8);
      fill(255); rect(0, 12, 16, 6, 2);
      break;
    case 12:
      fill(251, 146, 60); rect(0, 10, 44, 24, 4);
      fill(244, 114, 182); rect(0, -2, 44, 10, 2);
      fill(59, 130, 246); rect(0, -12, 6, 12);
      fill(250, 204, 21); ellipse(0, -20, 8, 12);
      break;
    case 13:
      fill(180, 100, 40); ellipse(0, 0, 44, 44);
      fill(244, 114, 182); ellipse(0, 0, 36, 36);
      fill(241, 245, 249); ellipse(0, 0, 16, 16);
      break;
    case 14:
      fill(241, 245, 249); ellipse(0, -6, 40, 38); rect(0, 8, 40, 16);
      fill(0); ellipse(-8, -6, 6, 8); ellipse(8, -6, 6, 8); ellipse(0, 4, 8, 10);
      break;
  }

  rectMode(CORNER);
}
