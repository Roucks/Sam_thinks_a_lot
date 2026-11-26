// Decisión del dormitorio, con las medidas de dibujo y clic en la misma cuadrícula.
boolean mostrandoModalDormir = false;
int hoverOpcionModalDormir = 0;

final float MODAL_DORMIR_W = 664;
final float MODAL_DORMIR_H = 420;
final float MODAL_DORMIR_OP_X = 36;
final float MODAL_DORMIR_OP_W = 592;
final float MODAL_DORMIR_OP_H = 86;
final float MODAL_DORMIR_JUGAR_Y = 184;
final float MODAL_DORMIR_DORMIR_Y = 284;
final float MODAL_DORMIR_CERRAR_X = 608;
final float MODAL_DORMIR_CERRAR_Y = 24;
final float MODAL_DORMIR_CERRAR_LADO = 32;

float origenModalDormirX() { return (width - MODAL_DORMIR_W * escalaX) / 2; }
float origenModalDormirY() { return (height - MODAL_DORMIR_H * escalaY) / 2; }

int zonaModalDormir() {
  float x = (mouseX - origenModalDormirX()) / escalaX;
  float y = (mouseY - origenModalDormirY()) / escalaY;
  if (x < 0 || x > MODAL_DORMIR_W || y < 0 || y > MODAL_DORMIR_H) return -1;
  if (x >= MODAL_DORMIR_CERRAR_X && x <= MODAL_DORMIR_CERRAR_X + MODAL_DORMIR_CERRAR_LADO
      && y >= MODAL_DORMIR_CERRAR_Y && y <= MODAL_DORMIR_CERRAR_Y + MODAL_DORMIR_CERRAR_LADO) return 3;
  if (x >= MODAL_DORMIR_OP_X && x <= MODAL_DORMIR_OP_X + MODAL_DORMIR_OP_W) {
    if (y >= MODAL_DORMIR_JUGAR_Y && y <= MODAL_DORMIR_JUGAR_Y + MODAL_DORMIR_OP_H) return 1;
    if (y >= MODAL_DORMIR_DORMIR_Y && y <= MODAL_DORMIR_DORMIR_Y + MODAL_DORMIR_OP_H) return 2;
  }
  return 0;
}

void dibujarModalDormir() {
  if (!mostrandoModalDormir) return;
  int zona = zonaModalDormir();
  hoverOpcionModalDormir = zona == 1 || zona == 2 ? zona : 0;
  pushStyle();
  pushMatrix();
  rectMode(CORNER);
  noStroke();
  fill(10, 14, 31, 184);
  rect(0, 0, width, height);
  translate(origenModalDormirX(), origenModalDormirY());
  scale(escalaX, escalaY);

  fill(5, 10, 24, 170);
  rect(9, 12, MODAL_DORMIR_W, MODAL_DORMIR_H);
  fill(76, 44, 40);
  dibujarCajaPixel(0, 0, MODAL_DORMIR_W, MODAL_DORMIR_H, 8);
  fill(223, 163, 90);
  dibujarCajaPixel(4, 4, MODAL_DORMIR_W - 8, MODAL_DORMIR_H - 8, 6);
  fill(124, 77, 57);
  dibujarCajaPixel(9, 9, MODAL_DORMIR_W - 18, MODAL_DORMIR_H - 18, 4);
  fill(20, 28, 53);
  rect(14, 14, MODAL_DORMIR_W - 28, MODAL_DORMIR_H - 28);
  fill(34, 46, 77);
  rect(14, 14, MODAL_DORMIR_W - 28, 141);
  fill(65, 68, 93);
  rect(34, 154, MODAL_DORMIR_W - 68, 2);

  for (int i = 0; i < 12; i++) {
    float x = 44 + (i * 91) % 532;
    float y = 30 + (i * 29) % 35;
    fill(255, 215, 141, 100 + 85 * sin(millis() * 0.003f + i));
    rect(x, y, 3, 3);
  }
  fill(255, 212, 128);
  rect(74, 70, 4, 16);
  rect(68, 76, 16, 4);
  rect(586, 74, 4, 12);
  rect(582, 78, 12, 4);

  if (fuenteComic != null) textFont(fuenteComic);
  textAlign(CENTER, CENTER);
  textSize(33);
  fill(12, 18, 35);
  text("¿UNA PARTIDA MÁS?", MODAL_DORMIR_W / 2 + 2, 77);
  fill(255, 228, 165);
  text("¿UNA PARTIDA MÁS?", MODAL_DORMIR_W / 2, 74);

  if (fontBody != null) textFont(fontBody);
  fill(249, 240, 229);
  textSize(17);
  String escena = dia1Terminado ? "Sam se acomoda en la cama con el celular." : "Sam se mete bajo las cobijas con su celular nuevo.";
  text(escena, MODAL_DORMIR_W / 2, 114);
  fill(191, 205, 228);
  textSize(15);
  text("Todavía queda un juego por probar… aunque ya le da sueño.", MODAL_DORMIR_W / 2, 139);

  fill(zona == 3 ? color(161, 82, 65) : color(51, 60, 83));
  dibujarCajaPixel(MODAL_DORMIR_CERRAR_X, MODAL_DORMIR_CERRAR_Y,
    MODAL_DORMIR_CERRAR_LADO, MODAL_DORMIR_CERRAR_LADO, 4);
  fill(255, 231, 188);
  if (fuenteComic != null) textFont(fuenteComic);
  textSize(17);
  text("×", MODAL_DORMIR_CERRAR_X + 16, MODAL_DORMIR_CERRAR_Y + 15);

  dibujarOpcionModalDormir(MODAL_DORMIR_JUGAR_Y, true, zona == 1);
  dibujarOpcionModalDormir(MODAL_DORMIR_DORMIR_Y, false, zona == 2);
  popMatrix();
  popStyle();
}

void dibujarCajaPixel(float x, float y, float w, float h, float esquina) {
  rect(x, y + esquina, w, h - esquina * 2);
  rect(x + esquina, y, w - esquina * 2, esquina);
  rect(x + esquina, y + h - esquina, w - esquina * 2, esquina);
}

void dibujarOpcionModalDormir(float y, boolean jugar, boolean resaltada) {
  float x = MODAL_DORMIR_OP_X;
  int acento = jugar ? color(255, 199, 110) : color(127, 222, 197);
  fill(8, 14, 31);
  dibujarCajaPixel(x, y + 5, MODAL_DORMIR_OP_W, MODAL_DORMIR_OP_H, 6);
  fill(resaltada ? acento : color(70, 90, 124));
  dibujarCajaPixel(x, y, MODAL_DORMIR_OP_W, MODAL_DORMIR_OP_H, 6);
  fill(resaltada ? color(51, 66, 101) : color(32, 44, 74));
  dibujarCajaPixel(x + 2, y + 2, MODAL_DORMIR_OP_W - 4, MODAL_DORMIR_OP_H - 4, 5);
  fill(acento);
  rect(x + 2, y + 9, 3, MODAL_DORMIR_OP_H - 18);
  fill(18, 27, 52);
  dibujarCajaPixel(x + 18, y + 16, 54, 54, 6);
  dibujarIconoModalDormir(x + 45, y + 43, jugar, acento);

  if (fuenteComic != null) textFont(fuenteComic);
  textAlign(LEFT, CENTER);
  fill(acento);
  textSize(23);
  text(jugar ? "Jugar un rato más" : "Irse a dormir", x + 88, y + 27);
  if (fontBody != null) textFont(fontBody);
  fill(218, 228, 243);
  textSize(16);
  String dormir = dia1Terminado ? "«Ya me dio sueño. Mañana sigo.»" : "«Mañana hay colegio. Mejor me duermo.»";
  text(jugar ? "«Una más y ya. Esta sí es la última.»" : dormir, x + 88, y + 57);
  fill(18, 27, 52);
  rect(x + MODAL_DORMIR_OP_W - 50, y + 27, 32, 32);
  fill(acento);
  textAlign(CENTER, CENTER);
  textSize(15);
  text(jugar ? "1" : "2", x + MODAL_DORMIR_OP_W - 34, y + 43);
}

void dibujarIconoModalDormir(float x, float y, boolean jugar, int acento) {
  pushMatrix();
  translate(x, y);
  fill(acento);
  if (jugar) {
    dibujarCajaPixel(-19, -11, 38, 22, 5);
    fill(42, 49, 80);
    rect(-13, -2, 14, 4);
    rect(-8, -7, 4, 14);
    fill(237, 115, 107);
    rect(6, 1, 4, 4);
    fill(231, 250, 227);
    rect(11, -5, 4, 4);
  } else {
    dibujarCajaPixel(-13, -14, 25, 26, 5);
    fill(18, 27, 52);
    rect(-2, -16, 17, 13);
    rect(4, -3, 12, 6);
    fill(255, 228, 154);
    rect(10, -11, 4, 4);
    rect(15, 5, 3, 3);
  }
  popMatrix();
}

boolean procesarClicModalDormir() {
  boolean consumido = false;
  if (mostrandoModalDormir) {
    consumido = true; // Bloquea los clics al fondo del juego mientras el modal esté abierto xd

    int zona = zonaModalDormir();
    if (zona == 3) {
      mostrandoModalDormir = false;
      if (sonidoClic != null) { sonidoClic.amp(0.3f * volMaster); sonidoClic.play(); }
    } else {
      if (zona == 1) {
        mostrandoModalDormir = false;
        modificarBienestar(-15, width / 2.0f, height / 2.0f - 40.0f * escalaY);
        modificarReputacion(-8, width / 2.0f, height / 2.0f - 80.0f * escalaY);
        activarScreenShake(10, 5.0f);
        crearPopupFlotante("Sam vuelve a abrir el juego.", width / 2.0f, height / 2.0f - 120.0f * escalaY, color(96, 165, 250));
        
        if (sonidoClic != null) { sonidoClic.amp(0.35f * volMaster); sonidoClic.play(); }
        
        if (estadoActual == EXPLORACION) {
          estadoDestino = NIVEL1;
          enHome = true;
          appAbierta = "";
          enTransicion = true;
        }
      } else {
        // Clic en Opción 2: "Irse a dormir"
        if (zona == 2) {
          mostrandoModalDormir = false;
          bienestarDigital = min(100, bienestarDigital + 25);
          puntosJugador += 25;
          generarParticulasCelebracion(width / 2.0f, height / 2.0f, color(52, 211, 153), 20);
          
          if (sonidoClic != null) { sonidoClic.amp(0.4f * volMaster); sonidoClic.play(); }

          if (!penaltisJugados) {
            paginaEscuela = 0;
            ultimoTextoDialogo = "";
            charsVisibles = 0;
            dialogoCompletado = false;
            crearPopupFlotante("Sam deja el celular en la mesita y cierra los ojos.", width / 2.0f, 100.0f * escalaY, color(52, 211, 153));
            estadoDestino = NOVELA_ESCUELA;
            enTransicion = true;
          } else { if (!dia1Terminado) {
            timerFinDia1 = 0;
            estadoDestino = FIN_DIA_1;
            enTransicion = true;
          } else {
            // Acostado en la cama al final del día 1: pasa a transición temporal y Nivel 2
            timerTransicionTemporal = 0;
            crearPopupFlotante("Sam deja el celular en la mesita y cierra los ojos.", width / 2.0f, height / 2.0f, color(52, 211, 153));
            estadoDestino = TRANSICION_TEMPORAL;
            enTransicion = true;
          } }
        } else {
          // Clic fuera de la tarjeta: cerrar sin realizar acción
          if (zona < 0) {
            mostrandoModalDormir = false;
          }
        }
      }
    }
  }

  return consumido;
}
