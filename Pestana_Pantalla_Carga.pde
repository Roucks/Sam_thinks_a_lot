final int CARGA_ESPERA_COMPLETA_MS = 420;
int cargaCompletaDesde = -1;

void dibujarPantallaCarga() {
  int ahora = millis();
  float progreso = constrain((pasoCarga + 1) / float(totalPasosCarga + 1), 0, 1);
  dibujarCieloDeCarga(ahora);

  pushStyle();
  pushMatrix();
  scale(escalaX, escalaY);
  rectMode(CORNER);
  noStroke();
  textAlign(CENTER, CENTER);
  textFont(fuenteComic);
  fill(19, 30, 59, 180);
  textSize(42);
  text("Sam Thinks a Lot", 770, 140);
  fill(255, 246, 215);
  text("Sam Thinks a Lot", 768, 137);

  dibujarCelularCarga(ahora);

  float x = 502;
  float y = 514;
  fill(13, 24, 52, 110);
  rect(x + 6, y + 9, 532, 140);
  fill(17, 27, 55, 228);
  rect(x, y + 5, 532, 130);
  rect(x + 5, y, 522, 140);
  fill(118, 223, 205);
  rect(x + 5, y, 522, 3);

  textFont(fuenteComic);
  textAlign(LEFT, CENTER);
  textSize(23);
  fill(250, 242, 221);
  text("Cargando", x + 28, y + 32);
  float puntosX = x + 34 + textWidth("Cargando");
  int puntos = 1 + (ahora / 260) % 3;
  if (progreso >= 1) puntos = 3;
  for (int i = 0; i < puntos; i++) rect(puntosX + i * 9, y + 40, 4, 4);
  textAlign(RIGHT, CENTER);
  fill(174, 247, 222);
  text(round(progreso * 100) + "%", x + 504, y + 32);

  final int segmentos = 24;
  float llenos = progreso * segmentos;
  fill(8, 14, 32);
  rect(x + 24, y + 61, 484, 30);
  for (int i = 0; i < segmentos; i++) {
    float bloqueX = x + 28 + i * 20;
    fill(45, 62, 90);
    rect(bloqueX, y + 65, 16, 22);
    float anchoLleno = floor(16 * constrain(llenos - i, 0, 1));
    if (anchoLleno > 0) {
      float brillo = 0.5f + 0.5f * sin(ahora * 0.005f - i * 0.45f);
      fill(86 + 57 * brillo, 197 + 35 * brillo, 179 + 30 * brillo);
      rect(bloqueX, y + 65, anchoLleno, 22);
      fill(207, 253, 222, 145);
      rect(bloqueX, y + 65, anchoLleno, 3);
    }
  }

  textFont(fuenteComic);
  fill(218, 225, 246);
  textSize(15);
  textAlign(CENTER, CENTER);
  String detalle = "Abriendo el cuarto de Sam";
  if (pasoCarga >= 6) detalle = "Preparando la historia y el celular";
  if (pasoCarga >= 12) detalle = "Preparando los minijuegos";
  if (progreso >= 1) detalle = "¡Todo listo!";
  text(detalle, 768, y + 114);

  popMatrix();
  popStyle();
}

void dibujarCieloDeCarga(int ahora) {
  pushStyle();
  rectMode(CORNER);
  noStroke();
  for (int fila = 0; fila < 36; fila++) {
    fill(lerpColor(color(35, 85, 152), color(134, 201, 225), fila / 35.0f));
    rect(0, floor(fila * height / 36.0f), width, ceil(height / 36.0f));
  }

  pushMatrix();
  scale(escalaX, escalaY);
  for (int i = 0; i < 8; i++) {
    float x = ((i * 391 + ahora * (0.015f + i % 3 * 0.007f)) % 1944) - 240;
    float y = 76 + (i * 127) % 680;
    dibujarNubeCarga(floor(x / 8) * 8, y, 8 + (i % 3) * 4, 112);
  }
  for (int i = 0; i < 44; i++) {
    float x = (i * 149 + ahora * 0.026f) % REF_W;
    float y = 40 + (i * 73) % 784 + 8 * sin(ahora * 0.0018f + i);
    float brillo = 0.5f + 0.5f * sin(ahora * 0.003f + i * 0.7f);
    fill(255, 238, 195, 30 + 100 * brillo);
    float tam = i % 5 == 0 ? 8 : 4;
    rect(round(x / 4) * 4, round(y / 4) * 4, tam, tam);
  }
  popMatrix();
  popStyle();
}

void dibujarNubeCarga(float x, float y, float lado, float opacidad) {
  fill(167, 206, 234, opacidad);
  rect(x + lado, y + 4 * lado, lado * 15, lado * 2);
  fill(233, 246, 255, opacidad);
  rect(x, y + 2 * lado, lado * 17, lado * 2);
  rect(x + 3 * lado, y + lado, lado * 12, lado);
  rect(x + 6 * lado, y, lado * 5, lado);
}

void dibujarCelularCarga(int ahora) {
  pushMatrix();
  translate(768, 317 + round(8 * sin(ahora * 0.003f)));
  fill(18, 32, 62, 150);
  rect(-56, -85, 122, 190);
  fill(28, 40, 69);
  rect(-64, -88, 128, 176);
  rect(-56, -96, 112, 192);
  fill(223, 183, 139);
  rect(-56, -88, 112, 176);
  fill(42, 79, 110);
  rect(-48, -68, 96, 136);
  fill(89, 154, 170);
  rect(-48, -68, 96, 8);
  fill(42, 60, 82);
  rect(-20, -82, 40, 6);
  rect(-12, 75, 24, 6);
  dibujarClipPixel(-32, -40, 4, ahora, true, 1);
  fill(251, 207, 133);
  rect(100, -72, 8, 24);
  rect(92, -64, 24, 8);
  fill(211, 247, 234);
  rect(-112, 21, 6, 18);
  rect(-118, 27, 18, 6);
  popMatrix();
}
