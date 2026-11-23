// =========================================================================
// PESTAÑA: Minijuego_pixelart.pde
// PIXEL ART - RELLENA EL MOLDE (9 NIVELES, DOBLE VISOR, LUPA Y CALIFICADOR)
// Refactorizado con arreglos paralelos (cero clases y cero else-if xd)
// =========================================================================
int paEstadoJuego = 0; // 0 = Inicio, 1 = Juego activo
final float PA_LOGICO_W = 1120.0f;
final float PA_LOGICO_H = 780.0f;

// arreglos paralelos para guardar los 9 niveles sin usar POO xd
final int PA_TOTAL_LEVELS = 9;
String[] paLevelName = new String[PA_TOTAL_LEVELS];
String[] paLevelKeys = new String[PA_TOTAL_LEVELS];
int[][] paLevelCols = new int[PA_TOTAL_LEVELS][];
String[][] paLevelRows = new String[PA_TOTAL_LEVELS][];
int[] paLevelW = new int[PA_TOTAL_LEVELS];
int[] paLevelH = new int[PA_TOTAL_LEVELS];

char[][] paUser;
char paSel;
int paCur = 0;
boolean paChecked = false;
float paPct = 0.0f;
int paPts = 0;
int[] paBest;
boolean[] paDone;
String paMsg = "";

// Visores del Molde y Lienzo
final int PA_VX1 = 40, PA_VX2 = 600, PA_VY = 130, PA_VW = 480, PA_VH = 440;
final float PA_ZMIN = 1.0f;
final int PA_SLX = 660, PA_SLY = 71, PA_SLW = 150;

int paBaseCs;
float paCs;
float paZoom = 1.0f;
float paPanX = 0.0f, paPanY = 0.0f;
boolean paPanning = false, paSpaceDown = false, paDraggingSlider = false;

// Coordenadas globales en pantalla completa
float paEscalaV = 1.0f, paOffX = 0.0f, paOffY = 0.0f;
boolean paIniciado = false;

// funcion auxiliar para llenar cada posicion de los arreglos paralelos de niveles
void paRegistrarNivel(int idx, String name, String keys, String hexCols, String[] rows) {
  paLevelName[idx] = name;
  paLevelKeys[idx] = keys;
  paLevelRows[idx] = rows;
  String[] hx = split(hexCols, ',');
  paLevelCols[idx] = new int[contarCadenas(hx)];
  for (int i = 0; i < contarCadenas(hx); i++) {
    paLevelCols[idx][i] = unhex("FF" + hx[i]);
  }
  paLevelH[idx] = contarCadenas(rows);
  paLevelW[idx] = rows[0].length();
}

// devuelve el color asociado a una letra en el nivel indicado
int paColorOf(int lvlIdx, char c) {
  int k = paLevelKeys[lvlIdx].indexOf(c);
  int col = color(236);
  if (k >= 0) {
    col = paLevelCols[lvlIdx][k];
  }
  return col;
}

// -------------------------------------------------------------------------
// INICIALIZACIÓN
// -------------------------------------------------------------------------
void initPixelArtGame() {
  if (!paIniciado) {
    paInitLevels();
    paBest = new int[PA_TOTAL_LEVELS];
    paDone = new boolean[PA_TOTAL_LEVELS];
    paLoadLevel(0);
    paIniciado = true;
  } else {
    if (paMusicaNiveles != null && paCur >= 0 && paCur < 9 && paMusicaNiveles[paCur] != null) {
      if (!paMusicaNiveles[paCur].isPlaying()) {
        paMusicaNiveles[paCur].loop();
        paMusicaNiveles[paCur].amp(volMaster * 0.65f);
      }
    }
  }
}

void paLoadLevel(int i) {
  // 1. Detener la música del nivel anterior si estaba sonando
  if (paMusicaNiveles != null && paMusicaNiveles[paCur] != null) {
    paMusicaNiveles[paCur].stop();
  }

  paCur = i;
  int lw = paLevelW[i];
  int lh = paLevelH[i];
  paUser = new char[lh][lw];
  for (int y = 0; y < lh; y++) {
    for (int x = 0; x < lw; x++) {
      paUser[y][x] = '.';
    }
  }
  paSel = leerCaracter(paLevelKeys[i], 0);
  paChecked = false;
  paPct = 0.0f;
  paPts = 0;
  paMsg = "";
  paBaseCs = max(4, min(PA_VW / lw, PA_VH / lh));
  paZoom = 1.0f;
  paPanX = 0.0f;
  paPanY = 0.0f;
  paUpdateCs();

  // 2. Asegurar musicaFondo apagada y reproducir la musica del nuevo nivel de Pixel Art xd
  if (musicaFondo != null && (musicaFondoDeberiaSonar || musicaFondo.isPlaying())) {
    musicaFondo.stop();
    musicaFondoDeberiaSonar = false;
  }
  if (paMusicaNiveles != null && paCur >= 0 && paCur < 9 && paMusicaNiveles[paCur] != null) {
    paMusicaNiveles[paCur].loop();
    paMusicaNiveles[paCur].amp(volMaster * 0.65f);
  }
}

void paUpdateCs() {
  paCs = paBaseCs * paZoom;
}

float paZMax() {
  return max(2.0f, min(5.0f, 64.0f / (float)paBaseCs));
}

float paBoardW() { return paLevelW[paCur] * paCs; }
float paBoardH() { return paLevelH[paCur] * paCs; }

void paClampPan() {
  paPanX = constrain(paPanX, 0.0f, max(0.0f, paBoardW() - PA_VW));
  paPanY = constrain(paPanY, 0.0f, max(0.0f, paBoardH() - PA_VH));
}

float paOriginX(int vx) {
  return paBoardW() <= PA_VW ? vx + (PA_VW - paBoardW()) / 2.0f : vx - paPanX;
}

float paOriginY() {
  return paBoardH() <= PA_VH ? PA_VY + (PA_VH - paBoardH()) / 2.0f : PA_VY - paPanY;
}

void paSetZoom(float z, float lx, float ly) {
  z = constrain(z, PA_ZMIN, paZMax());
  if (z != paZoom) {
    float oxl = paBoardW() <= PA_VW ? (PA_VW - paBoardW()) / 2.0f : -paPanX;
    float oyl = paBoardH() <= PA_VH ? (PA_VH - paBoardH()) / 2.0f : -paPanY;
    float u = (lx - oxl) / paCs;
    float v = (ly - oyl) / paCs;
    paZoom = z;
    paUpdateCs();
    paPanX = u * paCs - lx;
    paPanY = v * paCs - ly;
    paClampPan();
  }
}

void paZoomCenter(float z) {
  paSetZoom(z, PA_VW / 2.0f, PA_VH / 2.0f);
}

void paSliderToMouse() {
  float logMX = paMX();
  float t = constrain((logMX - PA_SLX) / (float)PA_SLW, 0.0f, 1.0f);
  paZoomCenter(PA_ZMIN + t * (paZMax() - PA_ZMIN));
}

float paMX() { return (mouseX - paOffX) / paEscalaV; }
float paMY() { return (mouseY - paOffY) / paEscalaV; }

boolean paInside(float x, float y, float w, float h) {
  float lx = paMX();
  float ly = paMY();
  return lx >= x && lx < x + w && ly >= y && ly < y + h;
}

int paTotalScore() {
  int t = 0;
  for (int i = 0; i < PA_TOTAL_LEVELS; i++) t += paBest[i];
  return t;
}

// -------------------------------------------------------------------------
// RENDERIZADO
// -------------------------------------------------------------------------
void dibujarJuegoPixelArt(float w, float h) {
  initPixelArtGame();

  paEscalaV = min(w / PA_LOGICO_W, h / PA_LOGICO_H);
  paOffX = (w - PA_LOGICO_W * paEscalaV) / 2.0f;
  paOffY = (h - PA_LOGICO_H * paEscalaV) / 2.0f;

  pushStyle();

  // 1. Fondo de la habitación con capa oscura uniforme
  if (fondoHabitacion != null && fondoHabitacion.width > 0) {
    image(fondoHabitacion, 0, 0, w, h);
  }
  noStroke();
  fill(15, 23, 42, 215);
  rect(0, 0, w, h);

  if (fuenteComic != null) textFont(fuenteComic);

  // =========================================================================
  // PANTALLA 0: MENÚ DE INICIO IDÉNTICO A PAREJAS
  // =========================================================================
  if (paEstadoJuego == 0) {
    fill(255);
    textAlign(CENTER, CENTER);
    textSize((w > 600) ? 34 * escalaX : 18);
    text("¡PIXEL ART - RELLENA EL MOLDE!", w / 2.0f, h * 0.30f);

    fill(148, 163, 184);
    textSize((w > 600) ? 18 * escalaX : 11.5f);
    text("Pinta las figuras guiándote con los números de la paleta", w / 2.0f, h * 0.38f);
    text("- 9 niveles con figuras pixel art clásicas", w / 2.0f, h * 0.44f);
    text("- Relájate mientras juegas", w / 2.0f, h * 0.49f);

    // Botón JUGAR AHORA
    float btnJW = (w > 600) ? 220 * escalaX : 140;
    float btnJH = (w > 600) ? 52 * escalaY : 36;
    float btnJX = w / 2.0f - btnJW / 2.0f;
    float btnJY = h * 0.58f;
    boolean hoverJ = (mouseX >= btnJX && mouseX <= btnJX + btnJW && mouseY >= btnJY && mouseY <= btnJY + btnJH);

    fill(hoverJ ? color(65, 145, 250) : color(59, 130, 246));
    noStroke();
    rect(btnJX, btnJY, btnJW, btnJH, (w > 600 ? 12 * escalaX : 10));
    fill(255);
    textSize((w > 600) ? 19 * escalaX : 13.5f);
    text("JUGAR AHORA", w / 2.0f, btnJY + btnJH / 2.0f);

    // Botón Volver al celular
    float btnSW = (w > 600) ? 200 * escalaX : 100;
    float btnSH = (w > 600) ? 44 * escalaY : 28;
    float btnSX = w / 2.0f - btnSW / 2.0f;
    float btnSY = h * 0.70f;
    boolean hoverS = (mouseX >= btnSX && mouseX <= btnSX + btnSW && mouseY >= btnSY && mouseY <= btnSY + btnSH);

    fill(hoverS ? color(71, 85, 105) : color(51, 65, 85));
    rect(btnSX, btnSY, btnSW, btnSH, (w > 600 ? 10 * escalaX : 8));
    fill(203, 213, 225);
    textSize((w > 600) ? 16 * escalaX : 11);
    text("< Volver al celular", w / 2.0f, btnSY + btnSH / 2.0f);

    popStyle();
  } else {
    // =========================================================================
    // PANTALLA 1: JUEGO ACTIVO
    // =========================================================================
    noStroke();
    fill(250, 248, 243, 215);
    rect(0, 0, w, h);

  String lKeys = paLevelKeys[paCur];
  int[] lCols = paLevelCols[paCur];

  pushMatrix();
  translate(paOffX, paOffY);
  scale(paEscalaV);

  fill(30);
  textAlign(LEFT, CENTER);
  textSize(24);
  text("Pixel Art: rellena el molde", 40, 28);
  textSize(15);
  textAlign(RIGHT, CENTER);
  text("Nivel " + (paCur + 1) + ": " + paLevelName[paCur] + "   |   Total: " + paTotalScore(), PA_LOGICO_W - 40, 28);

  for (int i = 0; i < PA_TOTAL_LEVELS; i++) {
    int bx = 40 + i * 42;
    stroke(200);
    fill(i == paCur ? color(232, 89, 12) : color(255));
    rect(bx, 56, 36, 30, 6);
    fill(i == paCur ? 255 : 40);
    textAlign(CENTER, CENTER);
    textSize(15);
    text(str(i + 1), bx + 18, 70);
    if (paDone[i]) {
      fill(245, 166, 35);
      textSize(14);
      text("*", bx + 30, 64);
    }
  }

  fill(90);
  textAlign(LEFT, CENTER);
  textSize(14);
  text("MOLDE", 40, 108);
  text("TU DIBUJO", 600, 108);
  fill(130);
  textAlign(RIGHT, CENTER);
  textSize(12);
  text("Rueda: zoom  |  Espacio + arrastrar: mover (o WASD)", PA_VX2 + PA_VW, 108);

  stroke(60);
  strokeWeight(2);
  noFill();
  ellipse(616, 68, 16, 16);
  line(622, 74, 629, 81);

  stroke(200);
  strokeWeight(4);
  line(PA_SLX, PA_SLY, PA_SLX + PA_SLW, PA_SLY);
  strokeWeight(1);
  float kx = PA_SLX + PA_SLW * (paZoom - PA_ZMIN) / (paZMax() - PA_ZMIN);
  stroke(190);
  fill(232, 89, 12);
  ellipse(kx, PA_SLY, 18, 18);
  fill(60);
  textAlign(LEFT, CENTER);
  textSize(14);
  text("x" + nf(paZoom, 1, 1), PA_SLX + PA_SLW + 16, PA_SLY - 1);
  paBoton("AJUSTAR", PA_SLX + PA_SLW + 70, 56, 90, 30, color(255), 40);

  textAlign(CENTER, CENTER);
  for (int i = 0; i < lKeys.length(); i++) {
    int px = 40 + i * 58;
    boolean on = (leerCaracter(lKeys, i) == paSel);
    stroke(on ? color(232, 89, 12) : color(190));
    strokeWeight(on ? 4 : 1);
    fill(lCols[i]);
    rect(px, 650, 48, 48, 8);
    strokeWeight(1);
    fill(brightness(lCols[i]) > 140 ? 0 : 255);
    textSize(14);
    text(str(i + 1), px + 24, 674);
  }

  int ex = 40 + lKeys.length() * 58;
  stroke(paSel == '.' ? color(232, 89, 12) : color(190));
  strokeWeight(paSel == '.' ? 4 : 1);
  fill(255);
  rect(ex, 650, 48, 48, 8);
  strokeWeight(1);
  fill(60);
  textSize(14);
  text("0", ex + 24, 670);
  textSize(10);
  text("borrar", ex + 24, 688);

  paBoton("CALIFICAR", 700, 650, 150, 48, color(232, 89, 12), 255);
  paBoton("LIMPIAR", 860, 650, 110, 48, color(255), 40);
  paBoton(paCur < PA_TOTAL_LEVELS - 1 ? "SIGUIENTE >" : "FIN", 980, 650, 120, 48,
          paDone[paCur] ? color(60, 160, 80) : color(215), paDone[paCur] ? 255 : 120);

  if (paChecked) {
    fill(30);
    textSize(22);
    textAlign(CENTER, CENTER);
    text("Similitud: " + nf(paPct, 0, 1) + "%     Puntaje: " + paPts + " / 1000", PA_LOGICO_W / 2.0f - 60, 735);
    int st = paPct >= 95.0f ? 3 : paPct >= 75.0f ? 2 : paPct >= 50.0f ? 1 : 0;
    fill(245, 166, 35);
    textSize(22);
    text("Estrellas: " + st + "/3", PA_LOGICO_W / 2.0f + 330, 735);
  }
  fill(120);
  textSize(13);
  textAlign(CENTER, CENTER);
  text(paMsg, PA_LOGICO_W / 2.0f, 764);

  popMatrix();

  clip(paOffX + PA_VX1 * paEscalaV, paOffY + PA_VY * paEscalaV, PA_VW * paEscalaV, PA_VH * paEscalaV);
  pushMatrix();
  translate(paOffX, paOffY);
  scale(paEscalaV);
  paDibujarTablero(PA_VX1, paCur, null, false, false);
  popMatrix();
  noClip();

  clip(paOffX + PA_VX2 * paEscalaV, paOffY + PA_VY * paEscalaV, PA_VW * paEscalaV, PA_VH * paEscalaV);
  pushMatrix();
  translate(paOffX, paOffY);
  scale(paEscalaV);
  paDibujarTablero(PA_VX2, paCur, paUser, paChecked, true);
  popMatrix();
  noClip();

  pushMatrix();
  translate(paOffX, paOffY);
  scale(paEscalaV);
  noFill();
  stroke(200);
  strokeWeight(1);
  rect(PA_VX1 - 1, PA_VY - 1, PA_VW + 2, PA_VH + 2);
  rect(PA_VX2 - 1, PA_VY - 1, PA_VW + 2, PA_VH + 2);
  popMatrix();

  paDibujarBotonVolver(w, h);
  popStyle();
  }
}

void paDibujarBotonVolver(float w, float h) {
  float btnX = 24.0f;
  float btnY = 16.0f;
  float btnW = 180.0f;
  float btnH = 34.0f;
  boolean hover = mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= btnY && mouseY <= btnY + btnH;

  pushStyle();
  fill(0, 40);
  noStroke();
  rect(btnX + 2, btnY + 2, btnW, btnH, 8);

  fill(hover ? color(232, 89, 12) : color(255));
  stroke(hover ? color(232, 89, 12) : color(200));
  strokeWeight(1.5f);
  rect(btnX, btnY, btnW, btnH, 8);

  fill(hover ? color(255) : color(50));
  textAlign(CENTER, CENTER);
  textSize(14);
  text("< Volver al celular", btnX + btnW / 2.0f, btnY + btnH / 2.0f - 1);
  popStyle();
}

void paDibujarTablero(int vx, int lvlIdx, char[][] data, boolean showWrong, boolean showNums) {
  int lw = paLevelW[lvlIdx];
  int lh = paLevelH[lvlIdx];
  String[] lRows = paLevelRows[lvlIdx];
  String lKeys = paLevelKeys[lvlIdx];

  float ox = paOriginX(vx), oy = paOriginY();
  int x0 = max(0, floor((vx - ox) / paCs));
  int x1 = min(lw - 1, floor((vx + PA_VW - ox) / paCs));
  int y0 = max(0, floor((PA_VY - oy) / paCs));
  int y1 = min(lh - 1, floor((PA_VY + PA_VH - oy) / paCs));

  stroke(0, 45);
  strokeWeight(1);
  for (int y = y0; y <= y1; y++) {
    for (int x = x0; x <= x1; x++) {
      char c = (data == null) ? leerCaracter(lRows[y], x) : data[y][x];
      fill(c == '.' ? color(236) : paColorOf(lvlIdx, c));
      rect(ox + x * paCs, oy + y * paCs, paCs, paCs);
    }
  }

  if (showNums) {
    textAlign(CENTER, CENTER);
    textSize(constrain(paCs * 0.6f, 8.0f, 30.0f));
    for (int y = y0; y <= y1; y++) {
      for (int x = x0; x <= x1; x++) {
        char t = leerCaracter(lRows[y], x);
        if (t == '.') continue;
        char c = data[y][x];
        if (c == '.') {
          fill(110);
        } else {
          int fc = paColorOf(lvlIdx, c);
          float lum = 0.299f * red(fc) + 0.587f * green(fc) + 0.114f * blue(fc);
          fill(lum > 140.0f ? color(0, 150) : color(255, 190));
        }
        text(str(lKeys.indexOf(t) + 1), ox + x * paCs + paCs / 2.0f, oy + y * paCs + paCs / 2.0f - 1);
      }
    }
  }

  if (showWrong) {
    noFill();
    stroke(224, 49, 49);
    strokeWeight(2);
    for (int y = y0; y <= y1; y++) {
      for (int x = x0; x <= x1; x++) {
        if (data[y][x] != leerCaracter(lRows[y], x)) {
          rect(ox + x * paCs + 2, oy + y * paCs + 2, paCs - 4, paCs - 4);
        }
      }
    }
    strokeWeight(1);
  }
}

void paBoton(String t, int x, int y, int w, int h, int bg, int fg) {
  stroke(190);
  fill(bg);
  rect(x, y, w, h, 10);
  fill(fg);
  textAlign(CENTER, CENTER);
  textSize(15);
  text(t, x + w / 2.0f, y + h / 2.0f);
}

// -------------------------------------------------------------------------
// LÓGICA DE CALIFICACIÓN Y PINTADO
// -------------------------------------------------------------------------
void paGrade() {
  int lw = paLevelW[paCur];
  int lh = paLevelH[paCur];
  String[] lRows = paLevelRows[paCur];

  int ok = 0, target = 0, extra = 0;
  for (int y = 0; y < lh; y++) {
    for (int x = 0; x < lw; x++) {
      char t = leerCaracter(lRows[y], x);
      char u = paUser[y][x];
      if (t != '.') {
        target++;
        if (u == t) ok++;
      } else {
        if (u != '.') {
          extra++;
        }
      }
    }
  }
  paPct = 100.0f * ok / (float)(target + extra);
  paPts = round(paPct * 10.0f);
  paChecked = true;
  if (paPts > paBest[paCur]) paBest[paCur] = paPts;
  if (paPct >= 50.0f) {
    if (!paDone[paCur]) puntosJugador += 20;
    paDone[paCur] = true;
    paMsg = paCur < PA_TOTAL_LEVELS - 1 ? "Nivel superado. Pulsa SIGUIENTE (N)." : "Completaste todos los niveles. Total: " + paTotalScore();
  } else {
    paMsg = "Necesitas al menos 50% para avanzar. Los cuadros rojos son errores.";
  }
  if (extra > 0) paMsg += "  (" + extra + " casillas pintadas fuera del molde)";
}

void paNextLevel() {
  if (paDone[paCur] && paCur < PA_TOTAL_LEVELS - 1) paLoadLevel(paCur + 1);
}

void paPaint(int btn) {
  int lw = paLevelW[paCur];
  int lh = paLevelH[paCur];
  if (paInside(PA_VX2, PA_VY, PA_VW, PA_VH)) {
    int cx = floor((paMX() - paOriginX(PA_VX2)) / paCs);
    int cy = floor((paMY() - paOriginY()) / paCs);
    if (cx >= 0 && cy >= 0 && cx < lw && cy < lh) {
      char v = (btn == RIGHT) ? '.' : paSel;
      if (paUser[cy][cx] != v) {
        paUser[cy][cx] = v;
        paChecked = false;
        paMsg = "";
      }
    }
  }
}

// -------------------------------------------------------------------------
// EVENTOS PIXEL ART
// -------------------------------------------------------------------------
void procesarClicPixelArt(int btn) {
  boolean clicHecho = false;
  if (paEstadoJuego == 0) {
    float btnJW = (width > 600) ? 220 * escalaX : 140;
    float btnJH = (width > 600) ? 52 * escalaY : 36;
    float btnJX = width / 2.0f - btnJW / 2.0f;
    float btnJY = height * 0.58f;
    if (mouseX >= btnJX && mouseX <= btnJX + btnJW && mouseY >= btnJY && mouseY <= btnJY + btnJH) {
      paEstadoJuego = 1;
      if (sonidoClic != null) { sonidoClic.amp(0.35f * volMaster); sonidoClic.play(); }
      clicHecho = true;
    } else {
      float btnSW = (width > 600) ? 200 * escalaX : 100;
      float btnSH = (width > 600) ? 44 * escalaY : 28;
      float btnSX = width / 2.0f - btnSW / 2.0f;
      float btnSY = height * 0.70f;
      if (mouseX >= btnSX && mouseX <= btnSX + btnSW && mouseY >= btnSY && mouseY <= btnSY + btnSH) {
        enHome = true;
        appAbierta = "";
        detenerMusicaPixelArt();
        if (sonidoClic != null) { sonidoClic.amp(0.3f * volMaster); sonidoClic.play(); }
        clicHecho = true;
      }
    }
  } else {
    // Si está en la esquina durante el juego: Volver al celular
    if (mouseX >= 24 && mouseX <= 204 && mouseY >= 16 && mouseY <= 50) {
      paEstadoJuego = 0;
      enHome = true;
      appAbierta = "";
      detenerMusicaPixelArt();
      if (sonidoClic != null) { sonidoClic.amp(0.35f * volMaster); sonidoClic.play(); }
      clicHecho = true;
    } else {
      String lKeys = paLevelKeys[paCur];
      for (int i = 0; i < PA_TOTAL_LEVELS; i++) {
        if (!clicHecho && paInside(40 + i * 42, 56, 36, 30)) {
          paLoadLevel(i);
          clicHecho = true;
        }
      }
      for (int i = 0; i < lKeys.length(); i++) {
        if (!clicHecho && paInside(40 + i * 58, 650, 48, 48)) {
          paSel = leerCaracter(lKeys, i);
          clicHecho = true;
        }
      }
      if (!clicHecho && paInside(40 + lKeys.length() * 58, 650, 48, 48)) {
        paSel = '.';
        clicHecho = true;
      }
      if (!clicHecho && paInside(700, 650, 150, 48)) {
        paGrade();
        clicHecho = true;
      }
      if (!clicHecho && paInside(860, 650, 110, 48)) {
        paLoadLevel(paCur);
        clicHecho = true;
      }
      if (!clicHecho && paInside(980, 650, 120, 48)) {
        paNextLevel();
        clicHecho = true;
      }

      if (!clicHecho && paInside(PA_SLX - 10, PA_SLY - 12, PA_SLW + 20, 24)) {
        paDraggingSlider = true;
        paSliderToMouse();
        clicHecho = true;
      }
      if (!clicHecho && paInside(PA_SLX + PA_SLW + 70, 56, 90, 30)) {
        paZoomCenter(1.0f);
        clicHecho = true;
      }

      if (!clicHecho) {
        if (btn == CENTER || paSpaceDown) {
          if (paInside(PA_VX1, PA_VY, PA_VW, PA_VH) || paInside(PA_VX2, PA_VY, PA_VW, PA_VH)) {
            paPanning = true;
          }
        } else {
          paPaint(btn);
        }
      }
    }
  }
}

void procesarArrastrePixelArt(int btn) {
  if (paDraggingSlider) {
    paSliderToMouse();
  } else {
    if (paPanning) {
      paPanX -= (mouseX - pmouseX) / paEscalaV;
      paPanY -= (mouseY - pmouseY) / paEscalaV;
      paClampPan();
    } else {
      if (btn != CENTER && !paSpaceDown) {
        paPaint(btn);
      }
    }
  }
}

void procesarSoltarPixelArt() {
  paPanning = false;
  paDraggingSlider = false;
}

void procesarRuedaPixelArt(float count) {
  float f = pow(1.12f, -count);
  float lx = PA_VW / 2.0f, ly = PA_VH / 2.0f;
  if (paInside(PA_VX1, PA_VY, PA_VW, PA_VH)) {
    lx = paMX() - PA_VX1;
    ly = paMY() - PA_VY;
  } else {
    if (paInside(PA_VX2, PA_VY, PA_VW, PA_VH)) {
      lx = paMX() - PA_VX2;
      ly = paMY() - PA_VY;
    }
  }
  paSetZoom(paZoom * f, lx, ly);
}

void procesarTeclasPixelArt(char k, int kCode) {
  String lKeys = paLevelKeys[paCur];
  if (k == ENTER || k == RETURN) {
    paGrade();
  }
  if (k == ' ') {
    paSpaceDown = true;
  }
  if (k == '+' || k == '=') {
    paZoomCenter(paZoom * 1.25f);
  }
  if (k == '-' || k == '_') {
    paZoomCenter(paZoom / 1.25f);
  }
  if (k == 'w' || k == 'W') {
    paPanY -= 40.0f;
    paClampPan();
  }
  if (k == 's' || k == 'S') {
    paPanY += 40.0f;
    paClampPan();
  }
  if (k == 'a' || k == 'A') {
    paPanX -= 40.0f;
    paClampPan();
  }
  if (k == 'd' || k == 'D') {
    paPanX += 40.0f;
    paClampPan();
  }
  if (k == 'c' || k == 'C') {
    paLoadLevel(paCur);
  }
  if (k == 'n' || k == 'N' || kCode == RIGHT) {
    paNextLevel();
  }
  if ((k == 'p' || k == 'P' || kCode == LEFT) && paCur > 0) {
    paLoadLevel(paCur - 1);
  }
  if (k == '0' || k == 'e' || k == 'E') {
    paSel = '.';
  }
  if (k >= '1' && k <= '9') {
    int i = k - '1';
    if (i < lKeys.length()) {
      paSel = leerCaracter(lKeys, i);
    }
  }
}

void procesarSoltarTeclasPixelArt(char k) {
  if (k == ' ') paSpaceDown = false;
}

// -------------------------------------------------------------------------
// MATRICES COMPLETAS DE LOS 9 NIVELES (EN ARREGLOS PARALELOS)
// -------------------------------------------------------------------------
void paInitLevels() {
  paRegistrarNivel(0, "Hamburguesa", "WKYPNGR", "FFFFFF,404040,FFCC66,FF679A,C55912,92D04F,FD0101", new String[] {
    "....KKKKKKKKKK....",
    "...KYYYYYYYYYYK...",
    "..KYYWKYYYYWKYYK..",
    ".KYYYKKYYYYKKYYYK.",
    ".KYYPPYYKKYYPPYYK.",
    ".KYYYYYYYYYYYYYYK.",
    "KKKKKKKKKKKKKKKKKK",
    "KNNNNNNNNNNNNNNNNK",
    ".KKKKKKKKKKKKKKKK.",
    "KGGGGGGGGGGGGGGGGK",
    ".KKRRRKRRRRKRRRKK.",
    ".KYKKKYKKKKYKKKYK.",
    ".KYYYYYYYYYYYYYYK.",
    "..KKKKKKKKKKKKKK.."
  });

  paRegistrarNivel(1, "Sushi", "KSWP", "1A1A1A,FACBA7,FFFFFF,E2B1B5", new String[] {
    ".................KKKKKKK...........",
    "...............KKKKKKKKKKKK........",
    "...KKKK....KKKKKKKKKKKKKKKKKK......",
    "..KSSSSK.KKWSKKKKKKKKKSSWWWSSKK....",
    "...KSSSSKSWSKKKKKKKKSSWWSSSSWWWK...",
    "..KKKKKSSWSSKKKKKKSSSWSSSSWWSSSSK..",
    ".KSSSSSSWSSKKKKKKSSSWSSSSWSSSSSSK..",
    "KSSSSSSSWSSKKKKKSSSWSSSSWSSSSSSWWK.",
    ".KSSSSKWSSKKKKKKSSWSSSSWSSSSSWWSSK.",
    "..KKKKWKSSKKKKKSSSWSSSWSSSSSWSSSSK.",
    ".....KWWKSKKKKKSSWSSSSWSSSSWSSSSSK.",
    ".....KWWWKKKKKSSSWSSSWSSSSWSSSSSK..",
    "......KWWWKKKKSSSSSSSWSSSSWSSSSKWK.",
    "......KWWWKKKKSSSWSSSWSSSWSSSSKWWWK",
    "......KWWWKKKKKKSWSSSWSSSWSSKKWWWWK",
    ".......KWWKKKKWWKKKSSWSSSKKKWWWWWWK",
    "......KWWWKKKKWWWWWKKKKKKWWWWWWWWK.",
    "......KWWWKKKKWWWWWWWWWWWWWWWWWWWWK",
    ".......KWWKKKKWWWWWKKWWWWWWWKKWWWWK",
    ".......KWWKKKKWWWWKWWKWWWWWKWWKWWWK",
    "........KKKKKKWWWWWWWWWKWKWWWWWWWK.",
    "..........KKKKWWWPPWWWWWKWWWWWPPK..",
    "............KKWWWPPWWWWWWWWWWWPPK..",
    "..............KWWWWWWWWWWWWWWWWK...",
    "...............KKKWWWWWWWWWWWKK....",
    "..................KWWKWWWKWWK......",
    "...................KK.KKK.KK......."
  });

  paRegistrarNivel(2, "Sonic", "KBSWGR", "1A1612,3C73C8,EBA25F,F2EFE8,B9B5AC,C0182F", new String[] {
    "..KKKKKKKK......",
    ".KKBBBKSBBKKKK..",
    "..KBBBKSSBBKKBK.",
    "...KBBKSBBBBKBK.",
    "....KBBBBBBBBBK.",
    "...KBBBBBWWBBBK.",
    "..KBBBBBWWWBBBKK",
    ".KBBBBBBWKWWBKBK",
    "KBBBBBBBWKWWBKGK",
    "KKKKKBBBWKWWBKK.",
    "...KBBBSSSWGKKK.",
    "..KBBBBSSSSSSKK.",
    ".KKKKKKKSSSSKK..",
    "...KKSSSKKKKK...",
    "..KSSKKKSSKK....",
    ".KSKGWKKSSKK....",
    ".KKGWWWBSKGWK...",
    "..KGWWGBKKWWK...",
    "...KGGKKKGWK....",
    "...KKKKKBKK.....",
    ".....KKKBK......",
    ".....KKKBKK.....",
    "....KRGWKGWK....",
    "....KRRRKRRKKK..",
    "...KRGWWRKRRRRK.",
    "..KRRRRRWKRRRRRK",
    "..KKKKKKKKKKKKKK"
  });

  paRegistrarNivel(3, "Pikachu", "KYRO", "171818,FFEF1B,FF4D2A,FEA91E", new String[] {
    "..................KKKKKKK...............",
    "...............KKKKKKKKKKKKK............",
    "..............KKKKYYYYYYYKKKKK.K........",
    "..........KKKKKYYYYYYYYYYYYYKKKKKK......",
    "........KKKYYYYYYYYYYYYYYYYYYYYYKKK.....",
    "......KKKYYYYYYYYYYYYYYYYYYYYYYYYYKKK...",
    ".....KKYYYYYKYYYYYYYYYYYYYYYYYKYYYYYKK..",
    ".....KKYYYYYKYYYKKYYYYYYYKKYYYKYYYYYKKK.",
    "....KKKKYYKKYYKKYYYYYKYYYYYKKYYKKYYKKKK.",
    "...KKKKKKKKKYYYYYYYYYYYYYYYYYYYKKKKKKKKK",
    "...KKKKKKKKKYYYYYYYYKKKYYYYYYYYKKKKKK...",
    "..........KYYRRYYYYKKKKKYYYYRRYYKK......",
    "KKKKKKK...KYRRRRYYYKRRRKYYYRRRRYKK......",
    "KYYYYYKKKKKYRRRRYYYKRRRKYYYRRRRYKK......",
    "KYYYYYYYYKKYYRRYYYYKRRRKKKYYRRYYKK......",
    "KYYYYYYYYYKYYYYYYYYYKKKKYYKYYYYYK.......",
    "KYYYYYYYYYYKYYYYYYYYYYYKYYYKYYYKK.......",
    "KYYYYYYYYYYKYYYYYYYYYYYYKYYYKYYK........",
    "KKKKYYYYYYYKKYYYYYYYYYYYYKYYYKKK........",
    "KKKKKKKYYYYKYYYYYYYOOOOOYKYYYKYK........",
    ".....KKKKYYKYYYYKYYYOOOYYYKYYYYK........",
    ".....KKYYYKKYYYYKYYYYYYYYYKYYYYK........",
    "...KKYYYKKKYYYYYKYYYYYYYYYYYYYYYK.......",
    "..KYYYKKKKKYYKYYYKYYYYYYYYYYYYYYK.......",
    "...KKYYYKKKYYKYYYKYYYYYYYYYYYYYYK.......",
    ".....KKYYYKYYYKYYKYYYYYYYYYYYYYYK......."
  });

  paRegistrarNivel(4, "Hongo", "WKR", "F2F2F2,000000,FF0000", new String[] {
    ".....KKKKKK.....",
    "...KKRRRRWWKK...",
    "..KWWRRRRWWWWK..",
    ".KWRRRRRRRWWWWK.",
    ".KWRRWWWWRRRWWK.",
    "KRRRWWWWWWRRRRRK",
    "KRRRWWWWWWRRWWRK",
    "KWRRWWWWWWRWWWWK",
    "KWWRRWWWWRRWWWWK",
    "KWWRRRRRRRRRWWRK",
    "KWRRKKKKKKKKRRRK",
    ".KKKWWKWWKWWKKK.",
    "..KWWWKWWKWWWK..",
    "..KWWWWWWWWWWK..",
    "...KWWWWWWWWK...",
    "....KKKKKKKK...."
  });

  paRegistrarNivel(5, "Gatito gris", "KGP", "000000,848285,DC9A95", new String[] {
    "....KKKK..........",
    "...KGGGGKKK.......",
    "...KKGGGGGGKK.....",
    "...KGGGGGGGGGK....",
    "..KGGGGGGGGGGGKK..",
    "..KGGKKGGGGGGGGGK.",
    ".KGPPKKGGGGGGGGGGK",
    "KKKPPGGGKGGKKGGGGK",
    ".KGGGGGGGGGKKGGKK.",
    "KKGGGGGGGGGGPPGK..",
    "..KGKKKGGGKGPPKK..",
    "...KGGGKGGGKGGGKK.",
    "..KGGGGKGGGKGGK...",
    "..KGGKKGKKGGKK..K.",
    ".KGGGKGGGKGGK..KGK",
    ".KGGGGGGGGGGGK.KGK",
    ".KGGGGGGGGGGGK.KGK",
    "..KGGGGGGGGGGKKGK.",
    "..KGGGGGGGGGGKGK..",
    "...KGGGKKGGGKKK...",
    "....KKK..KKKK....."
  });

  paRegistrarNivel(6, "Pollito", "KYO", "2B2E2D,F9D030,E18526", new String[] {
    "......KKKKK......",
    ".....KYYYYYK.....",
    "....KYYYYYYYK....",
    "...KYYYYYYYYYK...",
    "...KYYYYYYYYYK...",
    "...KYKYYYYYKYK...",
    "...KYKYOOOYKYK...",
    ".KKKYYYYOYYYYKKK.",
    "KYYYYYYYYYYYYYYYK",
    ".KYYYYYYYYYYYYYK.",
    "..KYYYYYYYYYYYK..",
    "...KYYYYYYYYYK...",
    "...KYYYYYYYYYK...",
    "....KYYYYYYYK....",
    ".....KOKKKOK.....",
    ".....OO...OO....."
  });

  paRegistrarNivel(7, "Stitch", "KBLPW", "1E2024,2A8FD8,8FD0F0,F0829F,FFFFFF", new String[] {
    "........K..................",
    "........KK.................",
    "........KBK................",
    "........KBBK..KKKKKKK......",
    "........KBBBKKBBBBBBBKK....",
    ".KK.....KBBBKBBBBBBBBBBK...",
    "KBBKK....KBKBBBBBKKKBBBBK..",
    "KBBBBK...KKBBBBBKKLLLBBBKKK",
    ".KKKBBK...KBBBBBKLLLLLBBBKK",
    "KKPKKBBKK.KBBBBBKLLKKWLBBKK",
    "KKPPPKBBLKBBBBBBBLLKKKKLBKK",
    "KKPPPPKKBBBBBBBBBLLKKKKLBBK",
    "..KPPPPPKBBBBBBBBBLKKKKLBK.",
    "...KPPPPPKKBBBBBBBBLLLLBK..",
    "....KKPPPPPKBKBBBBBBBBKK...",
    "......KKKKKKKBKKKKKKKK.....",
    "...........KKBBBBKLLLK.....",
    "..........KBBBBBBBKLK......",
    ".........KBBBBKBBBKBK......",
    ".........KBBBBLKBBBKBKKK...",
    "........KBBBKKBKKBBKBKKBK..",
    "........KBBKBKKBBKBKBKBBK..",
    ".......KBBBBBKBBBKBKKKBBK..",
    ".......KBBBBBBBBBKBBKKKKK..",
    "........KKBBBKKKKKKKKKKK...",
    "..........KKKKKKKKKKKKKK..."
  });

  paRegistrarNivel(8, "Gatito con flor", "KGWPLOYN", "333333,8A8F90,FFFFFF,F080B0,F6C6E0,E8A020,F5E616,3DB84A", new String[] {
    "................KK....P..PPP..",
    "...............KWKK..PLPPLLPPP",
    "..............KWWWGKPLLLWLLLLP",
    "....KGGK.....KWWWWWKPLLOOOOLPP",
    "...KGWWGK..KKKWWWWWKPLLOYYOLPP",
    "..KGWWWWWKKKWGWWWWWPLLLOOOPLLP",
    "..KWWWWWWKWKWKWWWWWPLLLLOPLLLP",
    "..KWWWWWWKWKWWWWWWWPPPPLLLLPPP",
    ".........KWWWWWWWGG.PNNPLLPL..",
    "KKKWWWWWWWWWWWWWWKK..NNNPPP...",
    "GGWWWWWWWWWWWWKWWGG..KKKPL....",
    "KKKWWKKWWKGKKKK.....KWWWK.....",
    ".....KKWWWKKPKWWWWWKKWWWK.....",
    "..GPWWWWWWWKKKWWWWWKWWWWWKK...",
    "..KKWWWWWWWWKKWWWWWKWWWWWKK...",
    "...GKKKGWWWWWWWWWWWKWWWWWKK...",
    "....KK..............KWWWGK....",
    "....KK..............GKKKKN....",
    ".....GKWWWWWWWWGKGG..KKNNN....",
    ".....GKWWWWWWWWKKKKG.KNNNN....",
    ".....KKWWWWGKKKW...GK..NNN....",
    ".....KKWWKKK...........NNN....",
    ".....KKWWK..............N.....",
    "......GKK....................."
  });
}

void procesarClicPixelArt(float relX, float relY, float w, float h) {
  procesarClicPixelArt(mouseButton);
}

void detenerMusicaPixelArt() {
  if (paMusicaNiveles != null && paCur >= 0 && paCur < 9 && paMusicaNiveles[paCur] != null) {
    paMusicaNiveles[paCur].stop();
  }
}
