// =========================================================================
// PESTAÑA 1: HUD, ICONOS VECTORIALES, SISTEMA DE PUNTOS, POPUPS Y DECISIONES
// (Arquitectura modular con arreglos paralelos de tamaño fijo - AyP 2)
// =========================================================================

float escalaPulsoPuntos = 1.0f;

// Vértices unitarios precalculados para estrella de 5 puntas (10 vértices alternando radio externo e interno 0.44)
final float[] ESTRELLA_UNIT_X = {
  0.0f, 0.2586255f, 0.9510565f, 0.3559675f, 0.5877852f,
  0.0f, -0.5877852f, -0.3559675f, -0.9510565f, -0.2586255f
};
final float[] ESTRELLA_UNIT_Y = {
  -1.0f, -0.3559675f, -0.3090170f, 0.1359675f, 0.8090170f,
  0.44f, 0.8090170f, 0.1359675f, -0.3090170f, -0.3559675f
};

// -------------------------------------------------------------------------
// ICONOS VECTORIALES DIBUJADOS CON CÓDIGO (Reemplazan ♥, ★, 🔒, ⚠ sin cuadros rotos)
// (Sin pushStyle/popStyle redundantes para evitar llamadas ocultas a deriveFont en JAVA2D)
// -------------------------------------------------------------------------
void dibujarIconoCorazon(float cx, float cy, float r, int col) {
  noStroke();
  fill(col);
  ellipse(cx - r * 0.48f, cy - r * 0.25f, r * 1.05f, r * 1.05f);
  ellipse(cx + r * 0.48f, cy - r * 0.25f, r * 1.05f, r * 1.05f);
  triangle(cx - r * 0.98f, cy - r * 0.05f, cx + r * 0.98f, cy - r * 0.05f, cx, cy + r * 1.05f);
  fill(255, 130);
  ellipse(cx - r * 0.52f, cy - r * 0.38f, r * 0.32f, r * 0.32f);
}

void dibujarIconoEstrella(float cx, float cy, float rExt, int col) {
  fill(col);
  stroke(255, 150);
  strokeWeight(max(1.0f, rExt * 0.1f));
  beginShape();
  for (int i = 0; i < 10; i++) {
    vertex(cx + ESTRELLA_UNIT_X[i] * rExt, cy + ESTRELLA_UNIT_Y[i] * rExt);
  }
  endShape(CLOSE);
  noStroke();
}

void dibujarIconoEstrellaRotada(float cx, float cy, float rExt, float ang, int col) {
  float cosA = cos(ang);
  float sinA = sin(ang);
  fill(col);
  noStroke();
  beginShape();
  for (int i = 0; i < 10; i++) {
    float ux = ESTRELLA_UNIT_X[i];
    float uy = ESTRELLA_UNIT_Y[i];
    vertex(cx + (ux * cosA - uy * sinA) * rExt, cy + (ux * sinA + uy * cosA) * rExt);
  }
  endShape(CLOSE);
}

void dibujarIconoCandado(float cx, float cy, float tam, int col) {
  pushStyle();
  noFill();
  stroke(col);
  strokeWeight(max(1.6f, tam * 0.18f));
  arc(cx, cy - tam * 0.18f, tam * 0.72f, tam * 0.78f, PI, TWO_PI);
  noStroke();
  fill(col);
  rectMode(CENTER);
  rect(cx, cy + tam * 0.22f, tam * 1.05f, tam * 0.82f, tam * 0.18f);
  fill(20, 22, 32);
  ellipse(cx, cy + tam * 0.18f, tam * 0.22f, tam * 0.22f);
  rect(cx, cy + tam * 0.34f, tam * 0.12f, tam * 0.24f);
  rectMode(CORNER);
  popStyle();
}

void dibujarIconoAlerta(float cx, float cy, float tam, int col) {
  pushStyle();
  fill(col);
  stroke(20, 15, 10, 190);
  strokeWeight(max(1.2f, tam * 0.1f));
  triangle(cx, cy - tam * 0.9f, cx - tam * 0.92f, cy + tam * 0.78f, cx + tam * 0.92f, cy + tam * 0.78f);
  fill(25, 18, 12);
  noStroke();
  rectMode(CENTER);
  rect(cx, cy - tam * 0.08f, tam * 0.18f, tam * 0.62f, 2);
  ellipse(cx, cy + tam * 0.45f, tam * 0.22f, tam * 0.22f);
  rectMode(CORNER);
  popStyle();
}

// -------------------------------------------------------------------------
// HUD DE EXPLORACIÓN (Bienestar Digital, Reputación Digital y Puntos Animados)
// -------------------------------------------------------------------------
void dibujarHUDExploracion() {
  pushStyle();
  float hudX = 18 * escalaX;
  float hudY = 14 * escalaY;
  float hudW = 475 * escalaX;
  float hudH = 82 * escalaY;

  escalaPulsoPuntos = lerp(escalaPulsoPuntos, 1.0f, 0.14f);

  // Fondo principal del HUD
  fill(14, 18, 28, 225);
  stroke(75, 115, 180, 200);
  strokeWeight(2 * escalaX);
  rect(hudX, hudY, hudW, hudH, 14 * escalaX);

  // --- 1. Barra de Bienestar Digital (Icono Corazón Vectorial) ---
  float bX = hudX + 16 * escalaX;
  float bY = hudY + 14 * escalaY;
  float barW = 142 * escalaX;
  float barH = 12 * escalaY;

  int colBienestar = color(70, 220, 115);
  if (bienestarVisualLerp < 35) colBienestar = color(245, 70, 75);
  else { if (bienestarVisualLerp < 65) colBienestar = color(250, 190, 55); }

  if (flashBienestarTimer > 0) {
    flashBienestarTimer--;
    if ((flashBienestarTimer / 3) % 2 == 0) colBienestar = colorFlashBienestar;
  }

  dibujarIconoCorazon(bX + 7 * escalaX, bY + 6 * escalaY, 6.5f * escalaX, colBienestar);
  fill(colBienestar);
  textAlign(LEFT, TOP);
  textSize(max(10, round(13 * escalaX)));
  text("Bienestar: " + round(bienestarVisualLerp) + "%", bX + 19 * escalaX, bY - 2 * escalaY);

  noStroke();
  fill(35, 42, 58);
  rect(bX, bY + 17 * escalaY, barW, barH, 6 * escalaX);
  fill(colBienestar);
  float wBien = constrain(map(bienestarVisualLerp, 0, 100, 0, barW), 0, barW);
  rect(bX, bY + 17 * escalaY, wBien, barH, 6 * escalaX);

  // --- 2. Barra de Reputación Digital (Icono Estrella Vectorial) ---
  float rX = hudX + 174 * escalaX;
  float rY = hudY + 14 * escalaY;

  int colRep = color(95, 185, 255);
  if (reputacionVisualLerp < 0) colRep = color(245, 95, 80);
  else { if (reputacionVisualLerp >= 40) colRep = color(255, 215, 65); }

  if (flashReputacionTimer > 0) {
    flashReputacionTimer--;
    if ((flashReputacionTimer / 3) % 2 == 0) colRep = colorFlashReputacion;
  }

  dibujarIconoEstrella(rX + 7 * escalaX, rY + 6 * escalaY, 7.2f * escalaX, colRep);
  fill(colRep);
  textAlign(LEFT, TOP);
  textSize(max(10, round(13 * escalaX)));
  String signoRep = (round(reputacionVisualLerp) > 0) ? "+" : "";
  text("Reputación: " + signoRep + round(reputacionVisualLerp), rX + 19 * escalaX, rY - 2 * escalaY);

  noStroke();
  fill(35, 42, 58);
  rect(rX, rY + 17 * escalaY, barW, barH, 6 * escalaX);
  fill(colRep);
  float wRep = constrain(map(reputacionVisualLerp, -50, 100, 0, barW), 0, barW);
  rect(rX, rY + 17 * escalaY, wRep, barH, 6 * escalaX);

  // --- 3. Contador Animado de Puntos del Jugador ---
  float pX = hudX + 334 * escalaX;
  float pY = hudY + 10 * escalaY;
  float pW = 126 * escalaX;
  float pH = 44 * escalaY;

  int colBordePts = color(255, 205, 60);
  if (flashPuntosTimer > 0) {
    flashPuntosTimer--;
    colBordePts = (flashPuntosTimer % 4 < 2) ? color(255, 255, 190) : color(255, 195, 40);
  }

  float cxPts = pX + pW * 0.5f;
  float cyPts = pY + pH * 0.5f;
  fill(28, 32, 48, 240);
  stroke(colBordePts);
  strokeWeight(2 * escalaX);
  rectMode(CENTER);
  rect(cxPts, cyPts, pW * escalaPulsoPuntos, pH * escalaPulsoPuntos, 10 * escalaX);
  rectMode(CORNER);

  dibujarIconoEstrella(cxPts - pW * 0.36f, cyPts - 8 * escalaY, 5.5f * escalaX, color(255, 220, 95));
  fill(255, 220, 95);
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(max(9, round(11 * escalaX)));
  text("PUNTOS", cxPts + 6 * escalaX, cyPts - 9 * escalaY);

  fill(flashPuntosTimer > 0 ? color(255, 255, 180) : color(255, 240, 110));
  textSize(max(12, round(18 * escalaX * escalaPulsoPuntos)));
  text(round(puntosMostradosLerp) + " pts", cxPts, cyPts + 9 * escalaY);

  // Pie informativo en el HUD
  fill(175, 195, 225);
  textAlign(LEFT, CENTER);
  textSize(max(9, round(11 * escalaX)));
  text("TAB: Resumen de Puntos   |   C: Celular / Pixagram", hudX + 16 * escalaX, hudY + 66 * escalaY);

  popStyle();
}

void ganarPuntosConPopup(int cantidad, int categoria, String etiqueta, float px, float py, int col) {
  if (cantidad != 0) {
    puntosJugador += cantidad;
    if (puntosJugador < 0) puntosJugador = 0;

    if (categoria == 1) ptsCatExploracion += cantidad;
    else { if (categoria == 2) ptsCatPenaltis += cantidad;
    else { if (categoria == 3) ptsCatDecisiones += cantidad;
    else { if (categoria == 4) ptsCatCocina += cantidad;
    else { if (categoria == 5) ptsCatLogros += cantidad; } } } }

    flashPuntosTimer = 32;
    if (cantidad > 0 && categoria != 5 && !(estadoActual == NIVEL2 && nv2SubEstado == NV2_SUB_JUGANDO)) {
      reproducirSfx(SFX_PUNTOS, 0.45f);
    } // Los logros tienen su propio sonido y en Nivel 2 jugando no suena para no ensuciar la canción
    escalaPulsoPuntos = 1.28f;

    String txtPop = (etiqueta != null && etiqueta.length() > 0) ? etiqueta : ((cantidad > 0 ? "+" : "") + cantidad + " PTS");
    crearPopupFlotante(txtPop, px, py, col);
    if (cantidad > 0) {
      generarParticulasCelebracion(px, py, col, 14);
    }
  }
}

void ganarPuntosConPopup(int cantidad, String etiqueta, float px, float py) {
  ganarPuntosConPopup(cantidad, 1, etiqueta, px, py, color(255, 225, 70));
}

void modificarBienestar(float delta, String razon) {
  modificarBienestar(delta, width * 0.5f - 100 * escalaX, height * 0.25f);
}

void modificarBienestar(float delta, float px, float py) {
  if (abs(delta) >= 0.1f) {
    bienestarDigital = constrain(bienestarDigital + delta, 0, 100);
    flashBienestarTimer = 28;
    reproducirSfx(delta > 0 ? SFX_BIENESTAR_SUBE : SFX_BIENESTAR_BAJA, 0.5f);
    int col = (delta > 0) ? color(80, 240, 130) : color(255, 85, 85);
    colorFlashBienestar = col;
    String signo = (delta > 0) ? "+" : "";
    crearPopupFlotante(signo + round(delta) + " Bienestar", px, py, col);
  }
}

void modificarReputacion(int delta, String razon) {
  modificarReputacion(delta, width * 0.5f + 100 * escalaX, height * 0.25f);
}

void modificarReputacion(int delta, float px, float py) {
  if (delta != 0) {
    reputacionDigital = constrain(reputacionDigital + delta, -50, 100);
    flashReputacionTimer = 28;
    int col = (delta > 0) ? color(255, 220, 70) : color(255, 105, 75);
    colorFlashReputacion = col;
    String signo = (delta > 0) ? "+" : "";
    crearPopupFlotante(signo + delta + " Reputación", px, py, col);
  }
}

void crearPopupFlotante(String texto, float x, float y, int col) {
  boolean asignado = false;
  for (int i = 0; i < MAX_POPUPS_FX && !asignado; i++) {
    if (!popupFxActivo[i]) {
      popupFxActivo[i] = true;
      popupFxX[i] = constrain(x, 120 * escalaX, width - 120 * escalaX);
      popupFxY[i] = constrain(y, 70 * escalaY, height - 70 * escalaY);
      popupFxVY[i] = -1.6f * escalaY;
      popupFxAlfa[i] = 255.0f;
      popupFxEscala[i] = 1.35f;
      popupFxTexto[i] = texto;
      popupFxColor[i] = col;
      asignado = true;
    }
  }
  if (!asignado) {
    // Si todos están ocupados, reutilizar el primero
    popupFxActivo[0] = true;
    popupFxX[0] = constrain(x, 120 * escalaX, width - 120 * escalaX);
    popupFxY[0] = constrain(y, 70 * escalaY, height - 70 * escalaY);
    popupFxVY[0] = -1.6f * escalaY;
    popupFxAlfa[0] = 255.0f;
    popupFxEscala[0] = 1.35f;
    popupFxTexto[0] = texto;
    popupFxColor[0] = col;
  }
}

void generarParticulasCelebracion(float x, float y, int col, int cantidad) {
  int creadas = 0;
  for (int i = 0; i < MAX_PARTICULAS_FX && creadas < cantidad; i++) {
    if (!partFxActiva[i]) {
      partFxActiva[i] = true;
      partFxX[i] = x;
      partFxY[i] = y;
      float ang = random(TWO_PI);
      float vel = random(2.2f, 7.5f);
      partFxVX[i] = cos(ang) * vel * escalaX;
      partFxVY[i] = sin(ang) * vel * escalaY - 1.5f * escalaY;
      partFxTam[i] = random(5.0f, 11.0f) * escalaX;
      partFxAlfa[i] = 255.0f;
      partFxColor[i] = col;
      creadas++;
    }
  }
}

void activarScreenShake(int frames, float intensidad) {
  shakeTimer = max(shakeTimer, frames);
  shakeIntensidad = max(shakeIntensidad, intensidad);
}

void desbloquearLogro(int idx) {
  if (!feriaActiva && idx >= 0 && idx < totalLogros && !logrosDesbloqueados[idx]) {
    logrosDesbloqueados[idx] = true;
    guardarLogrosGlobales();
    int pts = int(logros[idx][3]);
    logroNotifTexto = "¡Logro desbloqueado: " + logros[idx][1] + "! (+" + pts + " pts)";
    logroNotifFinTiempo = millis() + 4000;
    ganarPuntosConPopup(pts, 5, "LOGRO: +" + pts + " PTS", width / 2, 110 * escalaY, color(255, 225, 75));
    if (!(estadoActual == NIVEL2 && nv2SubEstado == NV2_SUB_JUGANDO)) {
      if (!reproducirSfx(SFX_LOGRO, 0.6f) && sonidoClic != null) {
        sonidoClic.amp(0.55f * volMaster);
        sonidoClic.play();
      }
    }
  }
}

// El progreso de logros se comparte entre partidas y finales.
void dibujarAvisoLogro() {
  if (millis() < logroNotifFinTiempo) {
    pushStyle();
    rectMode(CORNER);
    if (fuenteComic != null) textFont(fuenteComic);
    float notifAncho = width * 0.28f;
    float notifAlto = height * 0.12f;
    float notifX = width - notifAncho - width * 0.02f;
    float notifY = height - notifAlto - height * 0.02f;
    fill(0, 200);
    stroke(255, 220, 100);
    strokeWeight(3);
    rect(notifX, notifY, notifAncho, notifAlto, 12);
    noStroke();
    fill(255, 220, 100);
    textAlign(CENTER, CENTER);
    textSize(20 * escalaX);
    text("LOGRO DESBLOQUEADO", notifX + notifAncho / 2, notifY + notifAlto * 0.35f);
    fill(255);
    textSize(16 * escalaX);
    text(logroNotifTexto, notifX + notifAncho / 2, notifY + notifAlto * 0.7f);
    popStyle();
  }
}

void guardarLogrosGlobales() {
  String bits = "";
  for (int i = 0; i < totalLogros; i++) {
    if (logrosDesbloqueados[i]) bits += "1";
    else bits += "0";
  }
  try {
    saveStrings(dataPath("logros_globales.txt"), new String[] {bits});
  } catch (Exception error) {
    println("No se pudieron guardar los logros: " + error.getMessage());
  }
}

void cargarLogrosGlobales() {
  try {
    if (dataFile("logros_globales.txt").exists()) {
      String[] lineas = loadStrings("logros_globales.txt");
      if (lineas != null && contarCadenas(lineas) > 0) {
        for (int i = 0; i < totalLogros && i < lineas[0].length(); i++) {
          if (leerCaracter(lineas[0], i) == '1') logrosDesbloqueados[i] = true;
        }
      }
    }
  } catch (Exception error) {
    println("No se pudieron leer los logros: " + error.getMessage());
  }
}

void actualizarYDibujarPopupsYParticulas() {
  // Partículas (usando rect sin borde en vez de ellipse para usar FillRect directo en JAVA2D)
  noStroke();
  rectMode(CORNER);
  for (int i = 0; i < MAX_PARTICULAS_FX; i++) {
    if (partFxActiva[i]) {
      partFxX[i] += partFxVX[i];
      partFxY[i] += partFxVY[i];
      partFxVY[i] += 0.18f * escalaY;
      partFxAlfa[i] -= 5.8f;
      if (partFxAlfa[i] <= 0) {
        partFxActiva[i] = false;
      } else {
        fill(red(partFxColor[i]), green(partFxColor[i]), blue(partFxColor[i]), partFxAlfa[i]);
        rect(partFxX[i], partFxY[i], partFxTam[i], partFxTam[i]);
      }
    }
  }

  // Pop-ups flotantes de texto (tamaño entero fijo fuera del bucle para 100% acierto de caché de glifos)
  boolean fuenteConfigurada = false;
  int tamPopFijo = max(12, round(19 * escalaX));
  for (int i = 0; i < MAX_POPUPS_FX; i++) {
    if (popupFxActivo[i]) {
      popupFxY[i] += popupFxVY[i];
      popupFxVY[i] *= 0.96f;
      popupFxAlfa[i] -= 5.0f;
      if (popupFxAlfa[i] <= 0) {
        popupFxActivo[i] = false;
      } else {
        if (!fuenteConfigurada) {
          textAlign(CENTER, CENTER);
          textSize(tamPopFijo);
          fuenteConfigurada = true;
        }
        int px = round(popupFxX[i]);
        int py = round(popupFxY[i]);
        fill(0, popupFxAlfa[i] * 0.85f);
        text(popupFxTexto[i], px + 2, py + 2);
        fill(red(popupFxColor[i]), green(popupFxColor[i]), blue(popupFxColor[i]), popupFxAlfa[i]);
        text(popupFxTexto[i], px, py);
      }
    }
  }
}

void dibujarPanelResumenPuntos() {
  pushStyle();
  fill(0, 195);
  noStroke();
  rect(0, 0, width, height);

  float pw = 680 * escalaX;
  float ph = 490 * escalaY;
  float px = (width - pw) / 2;
  float py = (height - ph) / 2;

  fill(18, 24, 38, 248);
  stroke(255, 210, 75);
  strokeWeight(3 * escalaX);
  rect(px, py, pw, ph, 20 * escalaX);


  fill(255, 220, 80);
  textAlign(CENTER, CENTER);
  textSize(28 * escalaX);
  text("RESUMEN DE PUNTUACIÓN Y MÉTRICAS", width / 2, py + 42 * escalaY);

  stroke(70, 95, 145);
  strokeWeight(1.5f * escalaX);
  line(px + 36 * escalaX, py + 74 * escalaY, px + pw - 36 * escalaX, py + 74 * escalaY);

  String[] nombresCat = {
    "Exploración e Interacción en Red Social:",
    "Minijuego Nivel 1 (Penaltis y Rachas):",
    "Decisiones Narrativas y Ciudadanía Digital:",
    "Minijuego Nivel 2 (Cocina al Ritmo):",
    "Logros y Descubrimientos Desbloqueados:"
  };
  int[] valoresCat = {
    ptsCatExploracion,
    ptsCatPenaltis,
    ptsCatDecisiones,
    ptsCatCocina,
    ptsCatLogros
  };

  textAlign(LEFT, CENTER);
  textSize(17.5f * escalaX);
  for (int i = 0; i < 5; i++) {
    float filaY = py + 112 * escalaY + i * 44 * escalaY;
    fill(28, 36, 56, 200);
    noStroke();
    rect(px + 36 * escalaX, filaY - 17 * escalaY, pw - 72 * escalaX, 34 * escalaY, 8 * escalaX);

    fill(220, 230, 250);
    textAlign(LEFT, CENTER);
    text(nombresCat[i], px + 52 * escalaX, filaY);

    fill(255, 225, 85);
    textAlign(RIGHT, CENTER);
    text(valoresCat[i] + " pts", px + pw - 52 * escalaX, filaY);
  }

  // Total acumulado y barras de estado
  float totY = py + 345 * escalaY;
  fill(35, 50, 82, 230);
  stroke(255, 215, 70);
  strokeWeight(2 * escalaX);
  rect(px + 36 * escalaX, totY - 22 * escalaY, pw - 72 * escalaX, 46 * escalaY, 10 * escalaX);

  fill(255);
  textAlign(LEFT, CENTER);
  textSize(21 * escalaX);
  text("PUNTOS TOTALES DISPONIBLES:", px + 54 * escalaX, totY);
  fill(255, 235, 90);
  textAlign(RIGHT, CENTER);
  text(puntosJugador + " PTS", px + pw - 54 * escalaX, totY);

  // Estado actual de Bienestar y Reputación con iconos vectoriales
  fill(175, 235, 195);
  textAlign(CENTER, CENTER);
  textSize(16 * escalaX);
  text("Bienestar Digital: " + round(bienestarDigital) + "%        Reputación Digital: " + reputacionDigital, width / 2 + 8 * escalaX, py + 408 * escalaY);

  fill(170, 190, 220);
  textSize(14 * escalaX);
  text("Presiona [TAB], [ENTER] o haz clic fuera para cerrar este panel", width / 2, py + ph - 28 * escalaY);
  popStyle();
}

// =========================================================================
// DECISIÓN CON PADRES EN EL DESAYUNO (CON BLOQUEO VISUAL POR PUNTOS)
// =========================================================================
void dibujarModalDecisionPadres() {
  pushStyle();
  fill(0, 185);
  noStroke();
  rect(0, 0, width, height);

  float mw = 820 * escalaX;
  float mh = 430 * escalaY;
  float mx = (width - mw) / 2;
  float my = (height - mh) / 2;

  fill(20, 26, 42, 248);
  stroke(255, 205, 80);
  strokeWeight(3 * escalaX);
  rect(mx, my, mw, mh, 18 * escalaX);

  fill(255, 225, 90);
  textAlign(CENTER, CENTER);
  textSize(25 * escalaX);
  text("COMPROMISO FAMILIAR DE USO DEL CELULAR", width / 2, my + 40 * escalaY);

  dibujarIconoEstrella(width / 2 - 245 * escalaX, my + 74 * escalaY, 8 * escalaX, color(200, 220, 255));
  fill(200, 220, 255);
  textSize(16 * escalaX);
  text("Tus padres esperan una respuesta madura. Tienes " + puntosJugador + " pts disponibles.", width / 2 + 8 * escalaX, my + 74 * escalaY);

  String[] titOpts = {
    "[1] Proponer un Acuerdo Familiar de Horarios y Mesa Libre de Pantallas",
    "[2] Activar una alarma de límite diario en la app de Ajustes",
    "[3] Decir 'Sí, ya entendí' rápidamente para irse pronto al colegio"
  };
  String[] subOpts = {
    "Ideal: +15 Bienestar, +8 Reputación, +20 pts bonus y Logro 'Acuerdo en Casa'",
    "Equilibrado: +8 Bienestar, +4 Reputación, +10 pts bonus",
    "Sin costo (0 pts): -6 Bienestar, -4 Reputación (Camino alternativo sin bloqueo)"
  };
  int[] reqPts = { 30, 15, 0 };

  for (int i = 0; i < 3; i++) {
    float bx = mx + 38 * escalaX;
    float by = my + 110 * escalaY + i * 92 * escalaY;
    float bw = mw - 76 * escalaX;
    float bh = 76 * escalaY;

    boolean desbloqueada = (puntosJugador >= reqPts[i]);
    boolean hover = (mouseX >= bx && mouseX <= bx + bw && mouseY >= by && mouseY <= by + bh);

    if (!desbloqueada) {
      fill(42, 44, 52, 220);
      stroke(110, 110, 125);
    } else { if (hover) {
      fill(48, 78, 128, 245);
      stroke(255, 230, 95);
    } else {
      fill(30, 46, 78, 235);
      stroke(95, 145, 220);
    } }
    strokeWeight(2 * escalaX);
    rect(bx, by, bw, bh, 12 * escalaX);

    textAlign(LEFT, TOP);
    textSize(16.5f * escalaX);
    fill(desbloqueada ? color(255) : color(155, 158, 168));
    text(titOpts[i], bx + 18 * escalaX, by + 12 * escalaY);

    textSize(13.5f * escalaX);
    if (desbloqueada) {
      fill(175, 235, 195);
      String reqTxt = (reqPts[i] > 0) ? ("Requiere " + reqPts[i] + " pts (DESBLOQUEADO) - ") : "";
      text(reqTxt + subOpts[i], bx + 18 * escalaX, by + 42 * escalaY);
    } else {
      int faltan = reqPts[i] - puntosJugador;
      dibujarIconoCandado(bx + 26 * escalaX, by + 50 * escalaY, 13 * escalaX, color(255, 125, 115));
      fill(255, 125, 115);
      text("BLOQUEADO: Requiere " + reqPts[i] + " pts - Te faltan " + faltan + " pts (Gana puntos en el celular/logros)", bx + 42 * escalaX, by + 42 * escalaY);
    }
  }
  popStyle();
}

void procesarClicDecisionPadres() {
  float mw = 820 * escalaX;
  float mh = 430 * escalaY;
  float mx = (width - mw) / 2;
  float my = (height - mh) / 2;
  boolean opcionElegida = false;
  for (int i = 0; i < 3 && !opcionElegida; i++) {
    float bx = mx + 38 * escalaX;
    float by = my + 110 * escalaY + i * 92 * escalaY;
    float bw = mw - 76 * escalaX;
    float bh = 76 * escalaY;
    if (mouseX >= bx && mouseX <= bx + bw && mouseY >= by && mouseY <= by + bh) {
      elegirOpcionPadres(i + 1);
      opcionElegida = true;
    }
  }
}

void elegirOpcionPadres(int opcion) {
  int[] reqPts = { 30, 15, 0 };
  int req = reqPts[opcion - 1];
  if (puntosJugador < req) {
    activarScreenShake(12, 6.0f);
    crearPopupFlotante("Te faltan " + (req - puntosJugador) + " pts", width / 2, height / 2, color(255, 95, 95));
    if (!reproducirSfx(SFX_DECISION_BLOQUEADA, 0.6f) && sonidoHover != null) { sonidoHover.amp(0.3f * volMaster); sonidoHover.play(); }
  } else {
    decisionPadresDesayuno = opcion;
    reproducirSfx(SFX_DECISION_CONFIRMADA, 0.6f);
    mostrandoDecisionPadres = false;
    habloConPadresPostCelular = true;

    if (opcion == 1) {
      modificarBienestar(15, width / 2 - 140 * escalaX, height / 2);
      modificarReputacion(8, width / 2 + 140 * escalaX, height / 2);
      ganarPuntosConPopup(20, 3, "+20 PTS ¡ACUERDO SANO!", width / 2, height / 2 - 40 * escalaY, color(100, 255, 140));
      desbloquearLogro(8); // Acuerdo en Casa
    } else { if (opcion == 2) {
      modificarBienestar(8, width / 2 - 120 * escalaX, height / 2);
      modificarReputacion(4, width / 2 + 120 * escalaX, height / 2);
      ganarPuntosConPopup(10, 3, "+10 PTS ¡BUEN LÍMITE!", width / 2, height / 2 - 40 * escalaY, color(120, 220, 255));
    } else {
      modificarBienestar(-6, width / 2 - 120 * escalaX, height / 2);
      modificarReputacion(-4, width / 2 + 120 * escalaX, height / 2);
    } }

    if (!desayunoTarde) {
      desbloquearLogro(1); // Buen Despertar
    }
    estadoDestino = EXPLORACION;
    enTransicion = true;
  }
}

// =========================================================================
// MODO DEBUG DESARROLLADOR (F3): SALTOS RÁPIDOS ENTRE NIVELES Y PRUEBAS
// =========================================================================
String[] debugOpcionesSalto = {
  "[F4  / Shift+1] Ir a Exploración (Habitación / Casa)",
  "[F5  / Shift+2] Ir a Nivel 1: Celular y Pixagram",
  "[F6  / Shift+3] Ir a Novela Visual: Escuela",
  "[F7  / Shift+4] Ir a Nivel 1: Duelo de Penaltis",
  "[F8  / Shift+5] Ir a Pixagram Post-Penaltis (Decisiones)",
  "[F9  / Shift+6] Ir a Novela Visual: Cocina con Mateo",
  "[F10 / Shift+7] Ir a Selección de Dificultad Nivel 2",
  "[F11 / Shift+8] Ir Directo a Nivel 2 In-Game (Cocina)",
  "[F12 / Shift+9] Nivel 2 Extremo -> Evento Alerta Mamá (99%)",
  "[+   / Shift+P] Sumar +100 Puntos (Probar Decisiones)",
  "[B   / Shift+B] Bot Auto-Play Nivel 2",
  "[Shift+H] Historia tras cocina: final bueno",
  "[Shift+J] Historia tras cocina: final malo",
  "[Shift+K] Novela visual del nivel 3",
  "[Shift+L] Nivel 3: máquina arcade",
  "[Shift+U] Ver final bueno",
  "[Shift+I] Ver final malo"
};
final int TOTAL_OPCIONES_DEBUG = TAM_DEBUG_OPCIONES_SALTO;

void detenerMediosParaSaltoDebug() {
  if (nv2Audio != null && nv2Audio.isPlaying()) {
    nv2Audio.stop();
  }
  if (reproductorMp3 != null && reproduciendoMusica) {
    reproductorMp3.stop();
    reproduciendoMusica = false;
  }
  if (videoCreditos != null) {
    videoCreditos.pause();
  }
  if (videoFondo != null) {
    videoFondo.pause();
  }
  if (musicaFondo != null) {
    musicaFondo.stop();
  }
  musicaFondoDeberiaSonar = false;
  detenerMusicaPixelArt();
  enPausa = false;
  mostrarOpciones = false;
  mostrarResumenPuntos = false;
}

void ejecutarSaltoDebugDesarrollador(int idx) {
  boolean flujoRetornoActivo = true;

  if (idx == 15) {
    abrirFinalNivel3Debug(true);
    {
      flujoRetornoActivo = false;
    }
  }
  if (flujoRetornoActivo) {

    if (idx == 16) {
      abrirFinalNivel3Debug(false);
      {
        flujoRetornoActivo = false;
      }
    }
    if (flujoRetornoActivo) {

      if (idx == 13) {
        t3EntrarArcade();
        {
          flujoRetornoActivo = false;
        }
      }
      if (flujoRetornoActivo) {

        if (idx == 14) {
          t3EntrarArcadeDebug();
          {
            flujoRetornoActivo = false;
          }
        }
        if (flujoRetornoActivo) {

          t3Reiniciar();
          if (idx == 11 || idx == 12) {
            hcSaltarDebug(idx == 11);
            {
              flujoRetornoActivo = false;
            }
          }
          if (flujoRetornoActivo) {

            reiniciarHistoriaDespuesCocina();
            if (idx == 9) {
              ganarPuntosConPopup(100, 1, "+100 PTS [DEBUG DEV]", width / 2, height / 2, color(100, 255, 160));
              if (sonidoClic != null) {
                sonidoClic.amp(0.4f * volMaster);
                sonidoClic.play();
              }
            } else {
              if (idx == 10) {
                nv2AutoPlayBot = !nv2AutoPlayBot;
                nv2TimerAutoAvanceBot = 0;
                if (!nv2AutoPlayBot) {
                  for (int c = 0; c < MAX_CARRILES_NV2; c++)
                    nv2TeclaCarrilPresionada[c] = false;
                }
                if (estadoActual != NIVEL2) {
                  detenerMediosParaSaltoDebug();
                  nv2AutoPlayBot = true;
                  estadoActual = NIVEL2;
                  alphaTransicion = 0;
                  enTransicion = false;
                  iniciarPartidaNivel2();
                  crearPopupFlotante("BOT AUTO-PLAY ACTIVADO -> Jugando los 4 niveles solos [1-4]", width / 2, 145 * escalaY, color(85, 255, 195));
                } else {
                  crearPopupFlotante(nv2AutoPlayBot ? "BOT AUTO-PLAY NIVEL 2: ACTIVADO [B]" : "BOT AUTO-PLAY NIVEL 2: DESACTIVADO", width / 2,
                      145 * escalaY, color(85, 255, 195));
                }
              } else {
                detenerMediosParaSaltoDebug();
                if (sonidoClic != null) {
                  sonidoClic.amp(0.4f * volMaster);
                  sonidoClic.play();
                }

                if (idx == 0) {
                  tieneCelular = true;
                  leyendoMensaje = false;
                  animandoEscalera = false;
                  estadoActual = EXPLORACION;
                  alphaTransicion = 0;
                  enTransicion = false;
                  crearPopupFlotante("DEBUG -> Exploración Casa", width / 2, 120 * escalaY, color(110, 255, 160));
                } else {
                  if (idx == 1) {
                    tieneCelular = true;
                    enHome = true;
                    appAbierta = "";
                    estadoActual = NIVEL1;
                    alphaTransicion = 0;
                    enTransicion = false;
                    crearPopupFlotante("DEBUG -> Celular / Pixagram", width / 2, 120 * escalaY, color(110, 255, 160));
                  } else {
                    if (idx == 2) {
                      paginaEscuela = 0;
                      ultimoTextoDialogo = "";
                      charsVisibles = 0;
                      dialogoCompletado = false;
                      estadoActual = NOVELA_ESCUELA;
                      alphaTransicion = 0;
                      enTransicion = false;
                      crearPopupFlotante("DEBUG -> Novela Escuela", width / 2, 120 * escalaY, color(110, 255, 160));
                    } else {
                      if (idx == 3) {
                        penEstadoActual = 0;
                        tiroActual = 1;
                        goles = 0;
                        atajadas = 0;
                        fallos = 0;
                        estadoActual = PENALTIS;
                        alphaTransicion = 0;
                        enTransicion = false;
                        crearPopupFlotante("DEBUG -> Minijuego Penaltis", width / 2, 120 * escalaY, color(110, 255, 160));
                      } else {
                        if (idx == 4) {
                          tieneCelular = true;
                          penaltisJugados = true;
                          decisionPixagramTomada = false;
                          dia1Terminado = false;
                          juegosDesbloqueados = false;
                          goles = 1; // Simula derrota para probar las 3 decisiones éticas del post
                          prepararPostPixagramPenaltis();
                          enHome = false;
                          appAbierta = "Pixagram";
                          currentTab = 1;
                          scrollYFeed = 0;
                          estadoActual = NIVEL1;
                          alphaTransicion = 0;
                          enTransicion = false;
                          crearPopupFlotante("DEBUG -> Pixagram Post-Penaltis", width / 2, 120 * escalaY, color(110, 255, 160));
                        } else {
                          if (idx == 5) {
                            paginaCocina = 0;
                            mostrandoDecisionCocina = false;
                            ultimoTextoDialogo = "";
                            charsVisibles = 0;
                            dialogoCompletado = false;
                            estadoActual = NOVELA_COCINA;
                            alphaTransicion = 0;
                            enTransicion = false;
                            crearPopupFlotante("DEBUG -> Novela Cocina", width / 2, 120 * escalaY, color(110, 255, 160));
                          } else {
                            if (idx == 6) {
                              estadoActual = SELECCION_DIF_NV2;
                              alphaTransicion = 0;
                              enTransicion = false;
                              crearPopupFlotante("DEBUG -> Selección Dificultad Nivel 2", width / 2, 120 * escalaY, color(110, 255, 160));
                            } else {
                              if (idx == 7) {
                                estadoActual = NIVEL2;
                                alphaTransicion = 0;
                                enTransicion = false;
                                iniciarPartidaNivel2();
                                crearPopupFlotante("DEBUG -> Nivel 2 Directo (" + nv2NombresDificultad[nv2Dificultad] + ")", width / 2, 140 * escalaY,
                                    color(110, 255, 160));
                              } else {
                                if (idx == 8) {
                                  nv2Dificultad = NV2_DIF_EXTREMO;
                                  estadoActual = NIVEL2;
                                  alphaTransicion = 0;
                                  enTransicion = false;
                                  iniciarPartidaNivel2();
                                  // Adelantar el reloj a 1.5s antes del 100% para que salte la alerta dinámica de Mamá y la 6ta tecla S
                                  int tSaltoMs = max(1000, nv2DuracionTotalActivaMs - 1500);
                                  nv2TiempoInicioMs = millis() - tSaltoMs;
                                  for (int i = 0; i < totalNotasNv2; i++) {
                                    if (nv2NotaTiempoMs[i] < tSaltoMs) {
                                      nv2NotaCompletada[i] = true;
                                    }
                                  }
                                  crearPopupFlotante("DEBUG -> Nivel 2 Extremo (99% - ¡Lista Alerta de Mamá!)", width / 2, 140 * escalaY,
                                      color(255, 110, 110));
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }

          }

        }

      }

    }

  }
}

boolean procesarTeclaDebugDesarrollador(char k, int kCode) {
  boolean flujoRetornoActivo = true;
  boolean flujoRetornoValor = false;

  if (modoDebug && estadoActual != CARGA && k == 'U') {
    abrirFinalNivel3Debug(true);
    {
      flujoRetornoValor = true;
      flujoRetornoActivo = false;
    }
  }
  if (flujoRetornoActivo) {

    if (modoDebug && estadoActual != CARGA && k == 'I') {
      abrirFinalNivel3Debug(false);
      {
        flujoRetornoValor = true;
        flujoRetornoActivo = false;
      }
    }
    if (flujoRetornoActivo) {

      if (modoDebug && estadoActual != CARGA && k == 'K') {
        t3EntrarArcade();
        {
          flujoRetornoValor = true;
          flujoRetornoActivo = false;
        }
      }
      if (flujoRetornoActivo) {

        if (modoDebug && estadoActual != CARGA && k == 'L') {
          t3EntrarArcadeDebug();
          {
            flujoRetornoValor = true;
            flujoRetornoActivo = false;
          }
        }
        if (flujoRetornoActivo) {

          if (hcProcesarAtajoDebug(k, kCode)) {
            flujoRetornoValor = true;
            flujoRetornoActivo = false;
          }
          if (flujoRetornoActivo) {

            boolean procesado = false;
            if (kCode == 114) { // F3 activa/desactiva el Modo Debug en cualquier pantalla
              modoDebug = !modoDebug;
              crearPopupFlotante(modoDebug ? "MODO DEBUG ACTIVADO [F3]" : "MODO DEBUG DESACTIVADO", width / 2, 90 * escalaY, color(90, 255, 145));
              procesado = true;
            } else {
              if (modoDebug) {
                // Teclas de función F4 (115) a F12 (123)
                if (kCode >= 115 && kCode <= 123) {
                  ejecutarSaltoDebugDesarrollador(kCode - 115);
                  procesado = true;
                } else {
                  if (k == '!') {
                    ejecutarSaltoDebugDesarrollador(0);
                    procesado = true;
                  } else {
                    if (k == '"' || k == '@') {
                      ejecutarSaltoDebugDesarrollador(1);
                      procesado = true;
                    } else {
                      if (k == '#' || k == 183) {
                        ejecutarSaltoDebugDesarrollador(2);
                        procesado = true;
                      } else {
                        if (k == '$') {
                          ejecutarSaltoDebugDesarrollador(3);
                          procesado = true;
                        } else {
                          if (k == '%') {
                            ejecutarSaltoDebugDesarrollador(4);
                            procesado = true;
                          } else {
                            if (k == '&' || k == '^') {
                              ejecutarSaltoDebugDesarrollador(5);
                              procesado = true;
                            } else {
                              if (k == '/') {
                                ejecutarSaltoDebugDesarrollador(6);
                                procesado = true;
                              } else {
                                if (k == '(' || k == '*') {
                                  ejecutarSaltoDebugDesarrollador(7);
                                  procesado = true;
                                } else {
                                  if (k == ')') {
                                    ejecutarSaltoDebugDesarrollador(8);
                                    procesado = true;
                                  } else {
                                    if (k == '+' || (k == 'P' && estadoActual != NIVEL1)) {
                                      ejecutarSaltoDebugDesarrollador(9);
                                      procesado = true;
                                    } else {
                                      if ((k == 'b' || k == 'B') && estadoActual != NIVEL1) {
                                        ejecutarSaltoDebugDesarrollador(10);
                                        procesado = true;
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
            {
              flujoRetornoValor = procesado;
              flujoRetornoActivo = false;
            }

          }

        }

      }

    }

  }

  return flujoRetornoValor;
}

boolean procesarClicDebugDesarrollador() {
  boolean procesado = false;
  if (modoDebug) {
    float px = 16 * escalaX;
    float py = height - (TOTAL_OPCIONES_DEBUG * 28 + 76) * escalaY;
    float pw = 375 * escalaX;
    float filaH = 26 * escalaY;
    float inicioFilasY = py + 52 * escalaY;

    for (int i = 0; i < TOTAL_OPCIONES_DEBUG && !procesado; i++) {
      float ry = inicioFilasY + i * (filaH + 2 * escalaY);
      if (mouseX >= px + 8 * escalaX && mouseX <= px + pw - 8 * escalaX && mouseY >= ry && mouseY <= ry + filaH) {
        ejecutarSaltoDebugDesarrollador(i);
        procesado = true;
      }
    }
  }
  return procesado;
}

void dibujarPanelDebugDesarrollador() {
  if (modoDebug) {
    pushStyle();
    rectMode(CORNER);

    float px = 16 * escalaX;
    float py = height - (TOTAL_OPCIONES_DEBUG * 28 + 76) * escalaY;
    float pw = 375 * escalaX;
    float ph = (TOTAL_OPCIONES_DEBUG * 28 + 62) * escalaY;

    fill(8, 14, 24, 232);
    stroke(80, 255, 140, 220);
    strokeWeight(2 * escalaX);
    rect(px, py, pw, ph, 12 * escalaX);

    fill(80, 255, 140);
    textAlign(LEFT, TOP);
    textSize(13.5f * escalaX);
    text("DEBUG [F3] | FERIA: F9 desde menú", px + 12 * escalaX, py + 8 * escalaY);

    // Información de estado y FPS en tiempo real
    fill(190, 225, 255);
    textSize(11.5f * escalaX);
    text("Estado ID: " + estadoActual + "  |  FPS: " + round(frameRate) + "  |  Pts: " + puntosJugador, px + 12 * escalaX, py + 28 * escalaY);

    float filaH = 26 * escalaY;
    float inicioFilasY = py + 52 * escalaY;

    for (int i = 0; i < TOTAL_OPCIONES_DEBUG; i++) {
      float ry = inicioFilasY + i * (filaH + 2 * escalaY);
      boolean hover = (mouseX >= px + 8 * escalaX && mouseX <= px + pw - 8 * escalaX && mouseY >= ry && mouseY <= ry + filaH);

      fill(hover ? color(40, 110, 75, 240) : color(20, 32, 48, 210));
      stroke(hover ? color(120, 255, 165) : color(55, 85, 120));
      strokeWeight(1.2f * escalaX);
      rect(px + 8 * escalaX, ry, pw - 16 * escalaX, filaH, 6 * escalaX);

      fill(hover ? color(255, 255, 190) : color(220, 240, 230));
      textAlign(LEFT, CENTER);
      textSize(11.5f * escalaX);
      text(debugOpcionesSalto[i], px + 15 * escalaX, ry + filaH * 0.5f);
    }
    popStyle();
  }
}
