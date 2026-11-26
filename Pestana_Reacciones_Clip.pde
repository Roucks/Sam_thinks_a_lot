final int CLIP_REACCION_MS = 2200;
final int CLIP_CONFETIS = 24;
final int CLIP_GOTAS = 9;
int clipInicioReaccion = -1;
int clipEscenaReaccion = -1;
boolean clipReaccionPendiente = false;
boolean clipResultadoBueno = false;

void reaccionClipAlResultado(boolean bueno) {
  clipResultadoBueno = bueno;
  clipReaccionPendiente = true;
}

void reiniciarReaccionClip() {
  clipInicioReaccion = -1;
  clipEscenaReaccion = -1;
  clipReaccionPendiente = false;
}

boolean mostrarReaccionClip() {
  if (estadoActual == MENU) {
    reiniciarReaccionClip();
    return false;
  }
  if (enPausa || enTransicion || alphaTransicion > 0 || mostrarResumenPuntos) return false;
  if (clipReaccionPendiente) {
    clipInicioReaccion = millis();
    clipEscenaReaccion = escenaVisualActual();
    clipReaccionPendiente = false;
  }
  return clipInicioReaccion >= 0 && clipEscenaReaccion == escenaVisualActual()
    && millis() - clipInicioReaccion < CLIP_REACCION_MS;
}

void dibujarReaccionClip() {
  float edad = (millis() - clipInicioReaccion) / 1000.0f;
  float opacidad = min(constrain(edad / 0.14f, 0, 1),
    constrain((CLIP_REACCION_MS / 1000.0f - edad) / 0.40f, 0, 1));
  float x = REF_W - 72;
  float y = 110;
  if (t3Activa) y = 126;
  pushMatrix();
  pushStyle();
  scale(escalaX, escalaY);
  rectMode(CORNER);
  noStroke();
  fill(16, 28, 55, 208 * opacidad);
  dibujarCajaPixel(x - 15, y - 14, 64, 61, 5);
  int tiempoClip = clipResultadoBueno ? millis() : 3240;
  float salto = clipResultadoBueno ? abs(sin(edad * 15)) * 12 * max(0, 1 - edad) : 3;
  dibujarClipPixel(x - 4, y - 6 - salto, 2.3f, tiempoClip, clipResultadoBueno, opacidad);
  if (clipResultadoBueno) dibujarConfetiClip(x + 12, y + 8, edad, opacidad);
  else dibujarNubeDeClip(x, y, edad, opacidad);
  popStyle();
  popMatrix();
}

void dibujarConfetiClip(float x, float y, float edad, float opacidad) {
  for (int i = 0; i < CLIP_CONFETIS; i++) {
    float t = edad - (i % 6) * 0.055f;
    if (t >= 0) {
      float vx = -18 - (i * 13 % 128);
      float vy = -94 - (i * 17 % 59);
      float px = x + vx * t + 9 * sin(i + t * 5);
      float py = y + vy * t + 128 * t * t;
      float lado = 4 + (i % 3) * 2;
      int tono = color(255, 214, 126);
      if (i % 3 == 1) tono = color(116, 229, 198);
      if (i % 3 == 2) tono = color(249, 145, 181);
      pushMatrix();
      translate(round(px), round(py));
      rotate((i % 2 == 0 ? 1 : -1) * t * 5 + i);
      fill(tono, 255 * opacidad);
      rect(-lado / 2, -2, lado, 4);
      popMatrix();
    }
  }
}

void dibujarNubeDeClip(float x, float y, float edad, float opacidad) {
  float nubeY = y - 18 + 2 * sin(edad * 4);
  fill(86, 105, 144, 245 * opacidad);
  rect(x - 9, nubeY, 43, 9);
  rect(x - 2, nubeY - 6, 28, 7);
  rect(x + 3, nubeY - 10, 16, 4);
  for (int i = 0; i < CLIP_GOTAS; i++) {
    float fase = (edad * 64 + i * 13) % 74;
    fill(153, 199, 238, (1 - fase / 74) * 225 * opacidad);
    rect(x - 15 + (i * 31) % 49, nubeY + 10 + fase, 3, 7);
  }
}

void dibujarClipBailando(int tiempoMs, int periodoBeat) {
  float fase = max(0, tiempoMs) / float(periodoBeat);
  float paso = sin(fase * PI);
  float pulso = 1 - (fase - floor(fase));
  float rebote = pulso * pulso;
  float x = REF_W - 74;
  float y = 150;
  pushMatrix();
  pushStyle();
  scale(escalaX, escalaY);
  rectMode(CORNER);
  noStroke();
  fill(15, 24, 44, 202);
  dibujarCajaPixel(x - 31, y - 36, 71, 72, 5);
  translate(x + paso * 9, y - 9 * rebote);
  rotate(0.20f * paso);
  fill(107, 211, 191);
  rect(-24, -1 - 8 * paso, 10, 4);
  rect(15, -1 + 8 * paso, 10, 4);
  rect(-25, -5 - 8 * paso, 4, 8);
  rect(23, -5 + 8 * paso, 4, 8);
  dibujarClipPixel(-18, -22, 2.25f, tiempoMs, false, 1);
  popStyle();
  popMatrix();
}
