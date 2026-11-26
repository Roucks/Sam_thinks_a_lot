String[] penFasesMira = {"Dirección", "Altura", "Potencia"};
String[] penDetalleDificultad = {"5 s · 20 pts por gol", "3,5 s · 35 pts por gol", "2,5 s · 55 pts por gol"};

void iniciarDibujoPanelPenaltis() {
  pushStyle();
  pushMatrix();
  scale(escalaX, escalaY);
  rectMode(CORNER);
  imageMode(CORNER);
  noStroke();
  if (fuenteComic != null) textFont(fuenteComic);
}

void terminarDibujoPanelPenaltis() {
  popMatrix();
  popStyle();
}

void dibujarPanelPenaltis(float x, float y, float w, float h, int borde) {
  fill(7, 12, 28, 180);
  dibujarCajaPixel(x + 4, y + 5, w, h, 5);
  fill(borde);
  dibujarCajaPixel(x, y, w, h, 5);
  fill(20, 28, 53);
  dibujarCajaPixel(x + 3, y + 3, w - 6, h - 6, 4);
}

void dibujarRetratoPenaltis(PImage retrato, float x, float y, float w, float h, int borde) {
  fill(borde);
  dibujarCajaPixel(x, y, w, h, 4);
  fill(11, 19, 36);
  rect(x + 3, y + 3, w - 6, h - 6);
  if (retrato != null && retrato.width > 0 && retrato.height > 0) {
    float escala = min((w - 6) / retrato.width, (h - 6) / retrato.height);
    float ancho = retrato.width * escala;
    float alto = retrato.height * escala;
    image(retrato, x + (w - ancho) / 2, y + (h - alto) / 2, ancho, alto);
  }
}

void dibujarMarcadorPenaltis(boolean turnoMateo) {
  iniciarDibujoPanelPenaltis();
  int dorado = color(255, 212, 137);
  int azul = color(146, 217, 245);
  dibujarPanelPenaltis(24, 18, 465, 152, dorado);
  dibujarRetratoPenaltis(imgSamCancha, 38, 37, 126, 76, azul);
  textAlign(CENTER, CENTER);
  textSize(15);
  fill(azul);
  text("PATEA · SAM", 101, 134);
  textAlign(LEFT, CENTER);
  textSize(21);
  fill(dorado);
  text("Tiro " + tiroActual + " / " + TOTAL_TIROS, 183, 43);
  textSize(14);
  fill(214, 225, 246);
  text(penNombresDificultad[penDificultadActual], 348, 43);
  dibujarDatoPenaltis("Goles", str(goles), 177, 66, 64, color(127, 222, 197));
  dibujarDatoPenaltis("Atajadas", str(atajadas), 247, 66, 74, azul);
  dibujarDatoPenaltis("Fallos", str(fallos), 327, 66, 62, color(255, 162, 150));
  dibujarDatoPenaltis("Puntos", str(round(puntosMostradosLerp)), 395, 66, 80, dorado);
  fill(230, 219, 202);
  textAlign(LEFT, CENTER);
  textSize(14);
  text(turnoMateo ? "Mateo · tiros 1, 3 y 5" : "Cristian · tiros 2 y 4", 183, 139);

  float xArq = REF_W - 465;
  int acento = turnoMateo ? color(255, 185, 106) : color(208, 173, 255);
  dibujarPanelPenaltis(xArq, 18, 441, 148, acento);
  dibujarRetratoPenaltis(turnoMateo ? imgMateoCancha : imgCristianCancha, xArq + 303, 37, 124, 76, acento);
  fill(acento);
  textSize(20);
  text(turnoMateo ? "Arquero · Mateo" : "Arquero · Cristian", xArq + 17, 44);
  fill(220, 228, 246);
  textSize(14);
  text(turnoMateo ? "+25 % vuelo · Alcance 70" : "+8 % adivinar · Alcance 90 · Vuelo −15 %", xArq + 17, 72);
  for (int i = 0; i < TOTAL_TIROS; i++) {
    float bx = xArq + 17 + i * 52;
    int fondo = color(44, 58, 86);
    if (i < tiroActual - 1 || penEstadoActual == 4) fondo = color(66, 155, 139);
    if (i == tiroActual - 1 && penEstadoActual != 4) fondo = dorado;
    fill(fondo);
    dibujarCajaPixel(bx, 95, 40, 33, 3);
    fill(i == tiroActual - 1 && penEstadoActual != 4 ? color(20, 28, 53) : color(245, 245, 253));
    textAlign(CENTER, CENTER);
    textSize(15);
    text(i % 2 == 0 ? "M" : "C", bx + 20, 111);
  }
  terminarDibujoPanelPenaltis();
}

void dibujarDatoPenaltis(String etiqueta, String valor, float x, float y, float w, int acento) {
  fill(33, 46, 77);
  rect(x, y, w, 54);
  fill(acento);
  rect(x, y, w, 2);
  textAlign(CENTER, CENTER);
  textSize(20);
  text(valor, x + w / 2, y + 19);
  fill(223, 230, 245);
  textSize(12);
  text(etiqueta, x + w / 2, y + 40);
}

void dibujarIndicacionesPenaltis() {
  iniciarDibujoPanelPenaltis();
  int dorado = color(255, 212, 137);
  float mitad = REF_W / 2;
  float y = REF_H - 87;
  dibujarPanelPenaltis(mitad - 340, y, 680, 67, dorado);
  for (int i = 0; i < 3; i++) {
    float x = mitad - 324 + i * 160;
    boolean activa = i == penSubEstadoApuntado;
    fill(activa ? dorado : color(42, 54, 84));
    dibujarCajaPixel(x, y + 17, 150, 33, 3);
    fill(activa ? color(25, 29, 46) : color(210, 221, 242));
    textAlign(CENTER, CENTER);
    textSize(17);
    text((i + 1) + "  " + penFasesMira[i], x + 75, y + 33);
  }
  fill(223, 236, 250);
  textSize(14);
  text(penSubEstadoApuntado == 2 ? "Patea con" : "Fija con", mitad + 247, y + 20);
  dibujarTeclaGuia("CLIC / ESPACIO", mitad + 176, y + 34, 143, 1);

  float t = constrain(penTiempoRestanteAccion / float(penTiempoLimiteFrames), 0, 1);
  int colorTiempo = lerpColor(color(255, 128, 102), color(127, 222, 197), t);
  dibujarPanelPenaltis(mitad - 224, 18, 448, 63, colorTiempo);
  textAlign(LEFT, CENTER);
  textSize(15);
  fill(235, 240, 250);
  text("Tiempo para apuntar", mitad - 210, 37);
  textAlign(RIGHT, CENTER);
  fill(colorTiempo);
  text(ceil(penTiempoRestanteAccion / 60.0f) + " s", mitad + 210, 37);
  for (int i = 0; i < 20; i++) {
    float x = mitad - 210 + i * 21;
    fill(44, 58, 86);
    rect(x, 54, 18, 13);
    fill(colorTiempo);
    rect(x, 54, 18 * constrain(t * 20 - i, 0, 1), 13);
  }
  if (penSubEstadoApuntado == 2) {
    float x = puntoPenaltiX / escalaX + 130;
    float potenciaY = puntoPenaltiY / escalaY - 200;
    float p = constrain(porcentajePotencia, 0, 1);
    dibujarPanelPenaltis(x, potenciaY, 36, 220, dorado);
    for (int i = 0; i < 16; i++) {
      float barraY = potenciaY + 200 - i * 12;
      fill(44, 58, 86);
      rect(x + 8, barraY, 20, 9);
      float alto = 9 * constrain(p * 16 - i, 0, 1);
      fill(lerpColor(color(127, 222, 197), color(255, 130, 97), i / 15.0f));
      rect(x + 8, barraY + 9 - alto, 20, alto);
    }
    textAlign(CENTER, CENTER);
    fill(20, 28, 53);
    dibujarCajaPixel(x - 4, potenciaY + 225, 44, 22, 3);
    fill(dorado);
    textSize(14);
    text(round(p * 100) + "%", x + 18, potenciaY + 237);
  }
  terminarDibujoPanelPenaltis();
}

boolean ratonSobreBotonPenaltis(float cx, float cy, float w, float h) {
  return abs(mouseX - cx * escalaX) <= w * escalaX / 2
    && abs(mouseY - cy * escalaY) <= h * escalaY / 2;
}

void dibujarInicioPenaltis() {
  iniciarDibujoPanelPenaltis();
  float centro = REF_W / 2;
  int dorado = color(255, 212, 137);
  fill(9, 15, 33, 175);
  rect(0, 0, REF_W, REF_H);
  dibujarPanelPenaltis(centro - 490, 121, 980, 575, dorado);
  fill(34, 46, 77);
  rect(centro - 487, 124, 974, 84);
  textAlign(CENTER, CENTER);
  textSize(42);
  fill(dorado);
  text("¡DUELO DE PENALTIS!", centro, 169);
  dibujarRetratoPenaltis(imgSamCancha, centro - 322, 222, 144, 79, color(146, 217, 245));
  dibujarRetratoPenaltis(imgMateoCancha, centro - 72, 222, 144, 79, color(255, 185, 106));
  dibujarRetratoPenaltis(imgCristianCancha, centro + 178, 222, 144, 79, color(208, 173, 255));
  fill(226, 233, 247);
  textSize(16);
  text("SAM", centro - 250, 319);
  text("MATEO", centro, 319);
  text("CRISTIAN", centro + 250, 319);
  textSize(19);
  text("Fija dirección, altura y potencia. Marca 3 goles en 5 tiros.", centro, 362);
  for (int i = 0; i < TOTAL_DIFICULTADES_PEN; i++) {
    float cx = centro + (i - 1) * 290;
    boolean elegida = penDificultadActual == i;
    boolean hover = ratonSobreBotonPenaltis(cx, 455, 260, 100);
    dibujarPanelPenaltis(cx - 130, 405, 260, 100, elegida || hover ? dorado : color(76, 98, 136));
    fill(elegida ? dorado : color(228, 236, 250));
    textSize(22);
    text(penNombresDificultad[i], cx, 440);
    fill(208, 221, 245);
    textSize(16);
    text(penDetalleDificultad[i], cx, 471);
  }
  dibujarBotonPenaltis("Jugar", centro, 615, 360, 84, color(127, 222, 197));
  terminarDibujoPanelPenaltis();
}

void dibujarBotonPenaltis(String titulo, float cx, float cy, float w, float h, int acento) {
  boolean hover = ratonSobreBotonPenaltis(cx, cy, w, h);
  dibujarPanelPenaltis(cx - w / 2, cy - h / 2, w, h, acento);
  if (hover) {
    fill(acento);
    dibujarCajaPixel(cx - w / 2 + 4, cy - h / 2 + 4, w - 8, h - 8, 3);
  }
  fill(hover ? color(20, 28, 53) : acento);
  textAlign(CENTER, CENTER);
  textSize(25);
  text(titulo, cx, cy);
}

void dibujarAvisoTiroPenaltis() {
  iniciarDibujoPanelPenaltis();
  float cx = REF_W / 2;
  float cy = REF_H / 2 - 40;
  dibujarPanelPenaltis(cx - 340, cy - 52, 680, 104, colorResultado);
  textAlign(CENTER, CENTER);
  textSize(38);
  fill(colorResultado);
  text(mensajeResultado, cx, cy);
  terminarDibujoPanelPenaltis();
}

void dibujarResumenPenaltis() {
  iniciarDibujoPanelPenaltis();
  float cx = REF_W / 2;
  int acento = goles >= 3 ? color(127, 222, 197) : color(255, 162, 150);
  fill(9, 15, 33, 194);
  rect(0, 0, REF_W, REF_H);
  dibujarPanelPenaltis(cx - 430, 152, 860, 510, color(255, 212, 137));
  textAlign(CENTER, CENTER);
  fill(acento);
  textSize(37);
  text(goles >= 3 ? "¡VICTORIA EN LOS PENALTIS!" : "FIN DE LA TANDA", cx, 216);
  dibujarDatoPenaltis("Goles", goles + " / " + TOTAL_TIROS, cx - 323, 270, 148, acento);
  dibujarDatoPenaltis("Atajadas", str(atajadas), cx - 157, 270, 148, color(146, 217, 245));
  dibujarDatoPenaltis("Fallos", str(fallos), cx + 9, 270, 148, color(255, 162, 150));
  dibujarDatoPenaltis("Puntos ganados", "+" + puntajePenaltis, cx + 175, 270, 148, color(255, 212, 137));
  fill(34, 46, 77);
  dibujarCajaPixel(cx - 357, 361, 714, 110, 5);
  fill(255, 212, 137);
  textSize(18);
  text("Nueva publicación en Pixagram", cx, 385);
  fill(227, 235, 249);
  textSize(16);
  String aviso = goles >= 3
    ? "Mateo y Cristian publicaron una foto celebrando tu victoria.\nEntra al feed para decidir cómo responder."
    : "Mateo y Cristian publicaron una foto burlándose de la caída en la cancha.\nEntra al feed para decidir cómo responder.";
  text(aviso, cx, 430);
  dibujarBotonPenaltis("Ver publicación en Pixagram", cx, 555, 440, 80, color(146, 217, 245));
  terminarDibujoPanelPenaltis();
}
