// Silueta reducida para dibujar el resplandor sin procesar la imagen cada frame.
void nv3_prepararResplandor() {
  nv3_siluetaLuz = nv3_maquina.get();
  nv3_siluetaLuz.resize(220, 0);
  nv3_siluetaLuz.loadPixels();
  nv3_totalBordes = 0;
  int ancho = nv3_siluetaLuz.width;
  int alto = nv3_siluetaLuz.height;
  for (int y = 2; y < alto - 2; y += 2) {
    for (int x = 2; x < ancho - 2; x += 2) {
      int indice = y * ancho + x;
      int opacidad = (nv3_siluetaLuz.pixels[indice] >>> 24) & 255;
      int vecinoIzq = (nv3_siluetaLuz.pixels[indice - 2] >>> 24) & 255;
      int vecinoDer = (nv3_siluetaLuz.pixels[indice + 2] >>> 24) & 255;
      if (opacidad > 180 && (vecinoIzq < 60 || vecinoDer < 60) && nv3_totalBordes < TAM_NV3_BORDE_X) {
        nv3_bordeX[nv3_totalBordes] = x;
        nv3_bordeY[nv3_totalBordes] = y;
        nv3_totalBordes++;
      }
    }
  }
  for (int i = 0; i < (nv3_siluetaLuz.width * nv3_siluetaLuz.height); i++) {
    nv3_siluetaLuz.pixels[i] = (nv3_siluetaLuz.pixels[i] & 0xff000000) | 0x00ffffff;
  }
  nv3_siluetaLuz.updatePixels();
}

void nv3_dibujarResplandor() {
  if (nv3_siluetaLuz != null) {
    pushStyle();
    imageMode(CORNER);
    float ancho = nv3_maquina.width * nv3_escalaActual;
    float alto = nv3_maquina.height * nv3_escalaActual;
    float pulso = 0.5f + 0.5f * sin(millis() * 0.0025f);
    float atenuacion = 1 - constrain(nv3_suavizadoZoom, 0, 1);
    for (int capa = 4; capa >= 1; capa--) {
      float margen = capa * (4 + 2 * pulso);
      tint(255, 190 + 45 * pulso, 65, (8 + 5 * pulso) * atenuacion);
      image(nv3_siluetaLuz, nv3_imagenXActual - margen, nv3_imagenYActual - margen,
        ancho + margen * 2, alto + margen * 2);
    }
    popStyle();
  }
}

void nv3_dibujarDestellosBorde() {
  if (nv3_siluetaLuz != null && nv3_totalBordes > 0) {
    pushStyle();
    rectMode(CENTER);
    noStroke();
    float ancho = nv3_maquina.width * nv3_escalaActual;
    float alto = nv3_maquina.height * nv3_escalaActual;
    float atenuacion = 1 - constrain(nv3_suavizadoZoom, 0, 1);
    float tiempo = millis() * 0.001f;
    for (int i = 0; i < 22; i++) {
      int indice = (i * 73 + int(tiempo / 1.4f) * 37) % nv3_totalBordes;
      float x = nv3_imagenXActual + ancho * nv3_bordeX[indice] / nv3_siluetaLuz.width;
      float y = nv3_imagenYActual + alto * nv3_bordeY[indice] / nv3_siluetaLuz.height;
      float brillo = pow(max(0, sin(tiempo * 3.5f + i * 1.8f)), 3);
      float tam = (2 + brillo * 4) * min(1.5f, nv3_escalaActual * nv3_maquina.width / 350.0f);
      fill(255, 204, 70, 110 * brillo * atenuacion);
      rect(x, y, tam * 3, tam);
      rect(x, y, tam, tam * 3);
      fill(255, 252, 200, 235 * brillo * atenuacion);
      rect(x, y, tam, tam);
    }
    popStyle();
  }
}
