// Demostraciones cortas para visitantes. El progreso de feria es temporal.
final int FERIA_GAMER = 20;
boolean feriaActiva = false;
int feriaSeleccion = 0;
final int FERIA_RETOS = 6;
int feriaPaleta = 0;
int feriaColorFondo, feriaColorTexto, feriaColorBoton, feriaColorLuz;
int feriaColorBorde, feriaColorAcento, feriaColorSecundario;
String feriaNombrePaleta = "Miel";
String[] feriaTitulos = {"1  PENALTIS", "2  COCINA AL RITMO", "3  BARRELBOUND '81", "4  PAREJAS", "5  PIXEL ART", "6  FRUTAS"};
String[] feriaAyudas = {"Cinco tiros · ESPACIO para apuntar y disparar", "Elige dificultad y sigue las notas", "Flechas/WASD · ESPACIO · E: habilidad", "Encuentra las parejas usando el ratón", "Elige un color y completa el dibujo", "Combina frutas iguales y supera tu récord"};
boolean feriaHomePrevio;
String feriaAppPrevia;
int feriaRecordFrutaPrevio;
char[][] feriaDibujoPrevio;
int[] feriaMejoresPrevios;
boolean[] feriaCompletadosPrevios;
int feriaFiguraPrevia;
int feriaEstadoPaPrevio;
boolean feriaPixelPreparadoPrevio;
boolean feriaFrutaPreparadaPrevia;
boolean feriaPixelRevisadoPrevio;
char feriaColorPixelPrevio;
String feriaMensajePixelPrevio;
float[] feriaVistaPixelPrevia = new float[6];
int[] feriaDatosPixelPrevios = new int[2];
int feriaNivel = 0;
int feriaResultadoInicio = 0;
boolean feriaTerminoArcade = false;
int[] feriaPuntosPrevios = new int[7];
float feriaBienestarPrevio;
int feriaReputacionPrevia;
boolean feriaPenaltisPrevios;
int feriaDificultadPrevia;
boolean feriaDebugPrevio;

void feriaAbrir() {
  if (!feriaActiva) {
    feriaHomePrevio = enHome;
    feriaAppPrevia = appAbierta;
    feriaRecordFrutaPrevio = frutaPuntajeMax;
    feriaDibujoPrevio = paUser;
    feriaMejoresPrevios = paBest;
    feriaCompletadosPrevios = paDone;
    feriaFiguraPrevia = paCur;
    feriaEstadoPaPrevio = paEstadoJuego;
    feriaPixelPreparadoPrevio = paIniciado;
    feriaFrutaPreparadaPrevia = frutaIniciado;
    feriaPixelRevisadoPrevio = paChecked;
    feriaColorPixelPrevio = paSel;
    feriaMensajePixelPrevio = paMsg;
    feriaVistaPixelPrevia[0] = paPct;
    feriaVistaPixelPrevia[1] = paZoom;
    feriaVistaPixelPrevia[2] = paPanX;
    feriaVistaPixelPrevia[3] = paPanY;
    feriaVistaPixelPrevia[4] = paCs;
    feriaVistaPixelPrevia[5] = paBaseCs;
    feriaDatosPixelPrevios[0] = paPts;
    feriaDatosPixelPrevios[1] = frutaTema;
    feriaGuardarHistoria();
    feriaPuntosPrevios[0] = puntosJugador;
    feriaPuntosPrevios[1] = ptsCatExploracion;
    feriaPuntosPrevios[2] = ptsCatPenaltis;
    feriaPuntosPrevios[3] = ptsCatDecisiones;
    feriaPuntosPrevios[4] = ptsCatCocina;
    feriaPuntosPrevios[5] = ptsCatLogros;
    feriaPuntosPrevios[6] = goles;
    feriaBienestarPrevio = bienestarDigital;
    feriaReputacionPrevia = reputacionDigital;
    feriaPenaltisPrevios = penaltisJugados;
    feriaDificultadPrevia = nv2Dificultad;
    feriaDebugPrevio = modoDebug;
    feriaActiva = true;
  }
  feriaSelector();
}

void feriaRestaurarMetricas() {
  puntosJugador = feriaPuntosPrevios[0];
  ptsCatExploracion = feriaPuntosPrevios[1];
  ptsCatPenaltis = feriaPuntosPrevios[2];
  ptsCatDecisiones = feriaPuntosPrevios[3];
  ptsCatCocina = feriaPuntosPrevios[4];
  ptsCatLogros = feriaPuntosPrevios[5];
  goles = feriaPuntosPrevios[6];
  bienestarDigital = feriaBienestarPrevio;
  reputacionDigital = feriaReputacionPrevia;
  penaltisJugados = feriaPenaltisPrevios;
  nv2Dificultad = feriaDificultadPrevia;
}

void feriaSelector() {
  detenerMusicaPixelArt();
  detenerMediosParaSaltoDebug();
  t3Reiniciar();
  reiniciarHistoriaDespuesCocina();
  feriaRestaurarMetricas();
  feriaNivel = 0;
  feriaResultadoInicio = 0;
  feriaTerminoArcade = false;
  enPausa = false;
  mostrarResumenPuntos = false;
  modoDebug = false;
  estadoActual = FERIA_GAMER;
  estadoDestino = FERIA_GAMER;
  enTransicion = false;
  alphaTransicion = 0;
  nv3_limpiarControles();
}

void feriaSalir() {
  feriaSelector();
  feriaActiva = false;
  feriaRestaurarHistoria();
  enHome = feriaHomePrevio;
  appAbierta = feriaAppPrevia;
  frutaPuntajeMax = feriaRecordFrutaPrevio;
  paUser = feriaDibujoPrevio;
  paBest = feriaMejoresPrevios;
  paDone = feriaCompletadosPrevios;
  paCur = feriaFiguraPrevia;
  paEstadoJuego = feriaEstadoPaPrevio;
  paIniciado = feriaPixelPreparadoPrevio;
  frutaIniciado = feriaFrutaPreparadaPrevia;
  paChecked = feriaPixelRevisadoPrevio;
  paSel = feriaColorPixelPrevio;
  paMsg = feriaMensajePixelPrevio;
  paPct = feriaVistaPixelPrevia[0];
  paZoom = feriaVistaPixelPrevia[1];
  paPanX = feriaVistaPixelPrevia[2];
  paPanY = feriaVistaPixelPrevia[3];
  paCs = feriaVistaPixelPrevia[4];
  paBaseCs = int(feriaVistaPixelPrevia[5]);
  paPts = feriaDatosPixelPrevios[0];
  frutaTema = feriaDatosPixelPrevios[1];
  paPanning = false;
  paSpaceDown = false;
  paDraggingSlider = false;
  modoDebug = feriaDebugPrevio;
  estadoActual = MENU;
  estadoDestino = MENU;
}

void feriaJugar(int nivel) {
  feriaSelector();
  feriaNivel = nivel;
  if (nivel == 1) {
    penEstadoActual = 0;
    tiroActual = 1;
    goles = 0;
    atajadas = 0;
    fallos = 0;
    puntajePenaltis = 0;
    penaltisJugados = true;
    estadoActual = PENALTIS;
  }
  if (nivel == 2) {
    nv2AutoPlayBot = false;
    nv2Dificultad = 0;
    estadoActual = SELECCION_DIF_NV2;
  }
  if (nivel == 3) {
    t3AbrirJuegoArcade();
    nv3_pantalla = 1;
    nv3_estadoMenu = -1;
    nv3_modoDebug = false;
  }
  if (nivel >= 4 && nivel <= FERIA_RETOS) {
    estadoActual = NIVEL1;
    enHome = false;
    if (nivel == 4) {
      appAbierta = "Parejas";
      iniciarJuegoParejas();
    }
    if (nivel == 5) {
      appAbierta = "Pixel Art";
      paIniciado = false;
      initPixelArtGame();
      paEstadoJuego = 0;
    }
    if (nivel == 6) {
      appAbierta = "Frutas";
      initJuegoFrutas();
      reiniciarJuegoFrutas();
      frutaEnMenu = true;
    }
  }
  estadoDestino = estadoActual;
}

boolean feriaResultado() {
  boolean terminado = feriaTerminoArcade;
  if (feriaNivel == 1 && penEstadoActual == 4) terminado = true;
  if (feriaNivel == 3 && nv3_pantalla >= 5 && nv3_pantalla <= 7) terminado = true;
  if (feriaNivel == 2 && estadoActual == NIVEL2 && !nv2ReiniciarPartida
    && (nv2SubEstado == NV2_SUB_RESULTADOS || nv2SubEstado == NV2_SUB_DERROTA)) terminado = true;
  return terminado;
}

boolean feriaDibujar() {
  boolean atendido = false;
  if (feriaActiva) {
    feriaAplicarPaleta();
    if (estadoActual == MENU) feriaSelector();
    if (feriaNivel >= 4 && enHome) feriaSelector();
    if (feriaNivel >= 4) {
      if (feriaNivel == 4) dibujarJuegoParejas(width, height);
      if (feriaNivel == 5) dibujarJuegoPixelArt(width, height);
      if (feriaNivel == 6) dibujarJuegoFrutas(width, height);
      atendido = true;
    }
    boolean resultado = feriaResultado();
    if (resultado && feriaResultadoInicio == 0) feriaResultadoInicio = millis();
    if (resultado && millis() - feriaResultadoInicio > 9000) feriaSelector();
    if (estadoActual == FERIA_GAMER || resultado) {
      atendido = true;
      pushStyle();
      rectMode(CORNER);
      background(feriaColorFondo);
      feriaDibujarAmbiente();
      if (fuenteComic != null) textFont(fuenteComic);
      textAlign(CENTER, CENTER);
      fill(feriaColorTexto);
      textSize(40 * width / 1536.0f);
      text("FERIA GAMER", width / 2, height * 0.12f);
      textSize(20 * width / 1536.0f);
      if (!resultado) {
        text("Seis retos para explorar. Elige tu próxima partida.", width / 2, height * 0.22f);
        for (int i = 0; i < FERIA_RETOS; i++) {
          float x = width * (0.12f + i % 2 * 0.40f);
          float y = height * (0.31f + i / 2 * 0.16f);
          feriaDibujarBoton(x, y, width * 0.36f, height * 0.085f, feriaTitulos[i], feriaSeleccion == i);
          fill(feriaColorTexto);
          textAlign(CENTER, CENTER);
          textSize(14 * width / 1536.0f);
          text(feriaAyudas[i], x + width * 0.18f, y + height * 0.115f);
        }
        feriaDibujarBoton(width * 0.21f, height * 0.82f, width * 0.34f, height * 0.065f, "COLORES: " + feriaNombrePaleta + " [T]", false);
        feriaDibujarBoton(width * 0.59f, height * 0.82f, width * 0.20f, height * 0.065f, "VOLVER AL MENÚ", false);
        fill(feriaColorTexto);
        textAlign(CENTER, CENTER);
        textSize(16 * width / 1536.0f);
        text("1–6 o flechas + ENTER · T: colores · M / ESC: menú debug", width / 2, height * 0.94f);
      } else {
        String resumen = "¡Gracias por jugar!";
        if (feriaNivel == 1) resumen = "Penaltis: " + goles + " goles de 5";
        if (feriaNivel == 2) resumen = "Cocina: " + nf(nv2PrecisionFinal, 0, 1) + "% de precisión";
        if (feriaNivel == 3) resumen = "Arcade: fase " + nv3_fase + " de 3 · " + nv3_puntos + " puntos";
        text(resumen, width / 2, height * 0.45f);
        text("ENTER / clic: otro reto · M / ESC: selector", width / 2, height * 0.63f);
        text("El selector regresa automáticamente en unos segundos.", width / 2, height * 0.74f);
      }
      popStyle();
    }
  }
  return atendido;
}

boolean feriaTecla() {
  boolean atendido = false;
  if (!feriaActiva && modoDebug && estadoActual == MENU && keyCode == 120) {
    feriaAbrir();
    atendido = true;
  } else {
    if (feriaActiva) {
      boolean atras = key == 'm' || key == 'M' || keyCode == ESC;
      if (atras) {
        if (estadoActual == FERIA_GAMER) feriaSalir();
        else feriaSelector();
        key = 0;
        atendido = true;
      } else {
        if (feriaResultado()) {
          feriaSelector();
          atendido = true;
        } else {
          if (estadoActual == FERIA_GAMER) {
            if (keyCode == UP) feriaSeleccion = (feriaSeleccion + FERIA_RETOS - 2) % FERIA_RETOS;
            if (keyCode == DOWN) feriaSeleccion = (feriaSeleccion + 2) % FERIA_RETOS;
            if (keyCode == LEFT) feriaSeleccion = (feriaSeleccion + FERIA_RETOS - 1) % FERIA_RETOS;
            if (keyCode == RIGHT) feriaSeleccion = (feriaSeleccion + 1) % FERIA_RETOS;
            if (key == 't' || key == 'T') feriaPaleta = (feriaPaleta + 1) % 4;
            if (key >= '1' && key <= '6') feriaJugar(key - '0');
            if (keyCode == ENTER || key == ' ') feriaJugar(feriaSeleccion + 1);
            atendido = true;
          } else {
            // Evita abrir guardado, depuración y menús de la historia en una demo.
            if ((feriaNivel < 4 && (key == 'p' || key == 'P' || key == 'c' || key == 'C' || keyCode == TAB)) || keyCode >= 112) atendido = true;
          }
        }
      }
    }
  }
  return atendido;
}

void feriaDibujarAmbiente() {
  pushStyle();
  rectMode(CORNER);
  ellipseMode(CENTER);
  float tiempo = millis() * 0.001f;
  float unidad = min(width / 1536.0f, height / 864.0f);
  noStroke();

  // Cintas suaves que recorren los bordes y dejan libre la lectura central.
  for (int banda = 0; banda < 3; banda++) {
    fill(feriaColorSecundario, 16 + banda * 5);
    beginShape();
    vertex(0, height);
    for (int paso = 0; paso <= 40; paso++) {
      float x = width * paso / 40.0f;
      float y = height * (0.88f + banda * 0.035f)
        + sin(x / width * TWO_PI + tiempo * 0.24f + banda) * height * 0.035f;
      vertex(x, y);
    }
    vertex(width, height);
    endShape(CLOSE);
  }

  // Dos grupos de órbitas con brillo respirado.
  for (int grupo = 0; grupo < 2; grupo++) {
    float cx = width * 0.96f;
    float cy = height * 0.07f;
    if (grupo == 1) { cx = width * 0.02f; cy = height * 0.77f; }
    noFill();
    for (int aro = 0; aro < 5; aro++) {
      noFill();
      float radio = (75 + aro * 32 + sin(tiempo * 0.35f + aro) * 7) * unidad;
      stroke(feriaColorSecundario, 30 + 12 * sin(tiempo * 0.6f + aro));
      strokeWeight(1.5f * unidad);
      ellipse(cx, cy, radio * 2, radio * 2);
      float angulo = tiempo * (0.12f + aro * 0.025f) + aro * 1.8f + grupo;
      noStroke();
      fill(feriaColorSecundario, 75);
      ellipse(cx + cos(angulo) * radio, cy + sin(angulo) * radio, 6 * unidad, 6 * unidad);
    }
  }

  // Confeti de tres profundidades: cuadrados, rombos y pequeños destellos.
  for (int i = 0; i < 100; i++) {
    float semillaX = sin(i * 127.1f + 3) * 43758.5f;
    float semillaY = sin(i * 269.5f + 9) * 18341.3f;
    float x = ((semillaX - floor(semillaX)) * width + sin(tiempo * 0.24f + i) * 24 + width) % width;
    float y = (((semillaY - floor(semillaY)) * height - tiempo * (8 + i % 3 * 7)) % height + height) % height;
    float pulso = 0.5f + 0.5f * sin(tiempo * 1.2f + i);
    float lado = (3 + i % 5) * unidad;
    noStroke();
    fill(feriaColorSecundario, 40 + pulso * 55);
    if (i % 3 == 1) fill(feriaColorBorde, 25 + pulso * 30);
    if (i % 3 == 2) fill(feriaColorLuz, 60 + pulso * 45);
    if (i % 4 == 0) {
      rect(x - lado, y - lado * 0.22f, lado * 2, lado * 0.44f);
      rect(x - lado * 0.22f, y - lado, lado * 0.44f, lado * 2);
    } else {
      if (i % 4 == 1) {
        quad(x, y - lado, x + lado, y, x, y + lado, x - lado, y);
      } else {
        rect(x, y, lado, lado);
      }
    }
  }

  // Emblemas de juego flotando por los márgenes: balón, música y mando.
  for (int i = 0; i < 8; i++) {
    float x = width * (0.045f + (i % 2) * 0.91f);
    float y = height * (0.16f + (i / 2) * 0.23f) + sin(tiempo * 0.65f + i) * 13 * unidad;
    pushMatrix();
    translate(x, y);
    rotate(sin(tiempo * 0.3f + i) * 0.16f);
    feriaDibujarEmblema(i % 3, unidad);
    popMatrix();
  }
  popStyle();
}

void feriaDibujarEmblema(int tipo, float unidad) {
  stroke(feriaColorBorde, 75);
  strokeWeight(2.2f * unidad);
  noFill();
  if (tipo == 0) {
    ellipse(0, 0, 42 * unidad, 42 * unidad);
    beginShape();
    for (int i = 0; i < 5; i++) {
      float a = -HALF_PI + i * TWO_PI / 5;
      vertex(cos(a) * 9 * unidad, sin(a) * 9 * unidad);
    }
    endShape(CLOSE);
    for (int i = 0; i < 5; i++) {
      float a = -HALF_PI + i * TWO_PI / 5;
      line(cos(a) * 9 * unidad, sin(a) * 9 * unidad, cos(a) * 21 * unidad, sin(a) * 21 * unidad);
    }
  }
  if (tipo == 1) {
    line(-9 * unidad, 12 * unidad, -9 * unidad, -17 * unidad);
    line(13 * unidad, 7 * unidad, 13 * unidad, -22 * unidad);
    line(-9 * unidad, -17 * unidad, 13 * unidad, -22 * unidad);
    fill(feriaColorSecundario, 65);
    ellipse(-15 * unidad, 13 * unidad, 13 * unidad, 9 * unidad);
    ellipse(7 * unidad, 8 * unidad, 13 * unidad, 9 * unidad);
  }
  if (tipo == 2) {
    rect(-25 * unidad, -15 * unidad, 50 * unidad, 31 * unidad, 10 * unidad);
    line(-17 * unidad, 0, -5 * unidad, 0);
    line(-11 * unidad, -6 * unidad, -11 * unidad, 6 * unidad);
    ellipse(10 * unidad, -4 * unidad, 4 * unidad, 4 * unidad);
    ellipse(17 * unidad, 4 * unidad, 4 * unidad, 4 * unidad);
  }
  noStroke();
}

boolean feriaClic() {
  boolean atendido = false;
  if (feriaActiva) {
    if (feriaResultado()) {
      feriaSelector();
      atendido = true;
    } else {
      if (estadoActual == FERIA_GAMER) {
        // Se resuelve primero la acción para no evaluar otros botones al abrir un reto.
        int reto = 0;
        for (int i = 0; i < FERIA_RETOS; i++) {
          float x = width * (0.12f + i % 2 * 0.40f);
          float y = height * (0.31f + i / 2 * 0.16f);
          if (feriaDentro(x, y, width * 0.36f, height * 0.085f)) reto = i + 1;
        }
        if (feriaDentro(width * 0.21f, height * 0.82f, width * 0.34f, height * 0.065f)) feriaPaleta = (feriaPaleta + 1) % 4;
        if (feriaDentro(width * 0.59f, height * 0.82f, width * 0.20f, height * 0.065f)) feriaSalir();
        if (reto > 0) feriaJugar(reto);
        atendido = true;
      }
    }
  }
  return atendido;
}

boolean feriaDentro(float x, float y, float w, float h) {
  boolean dentro = mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  return dentro;
}

void feriaAplicarPaleta() {
  feriaNombrePaleta = "Miel";
  feriaColorFondo = color(255, 246, 219);
  feriaColorTexto = color(88, 45, 20);
  feriaColorBoton = color(177, 119, 58);
  feriaColorLuz = color(201, 151, 87);
  feriaColorBorde = color(109, 65, 28);
  feriaColorAcento = color(255, 223, 103);
  feriaColorSecundario = color(204, 155, 59);
  if (feriaPaleta == 1) {
    feriaNombrePaleta = "Lavanda";
    feriaColorFondo = color(239, 232, 253);
    feriaColorTexto = color(64, 39, 91);
    feriaColorBoton = color(116, 82, 155);
    feriaColorLuz = color(145, 112, 184);
    feriaColorBorde = color(77, 48, 111);
    feriaColorAcento = color(211, 189, 247);
    feriaColorSecundario = color(163, 125, 208);
  }
  if (feriaPaleta == 2) {
    feriaNombrePaleta = "Océano";
    feriaColorFondo = color(223, 244, 246);
    feriaColorTexto = color(20, 66, 79);
    feriaColorBoton = color(29, 122, 140);
    feriaColorLuz = color(58, 151, 166);
    feriaColorBorde = color(17, 83, 101);
    feriaColorAcento = color(151, 229, 219);
    feriaColorSecundario = color(58, 167, 182);
  }
  if (feriaPaleta == 3) {
    feriaNombrePaleta = "Coral";
    feriaColorFondo = color(255, 233, 225);
    feriaColorTexto = color(108, 43, 43);
    feriaColorBoton = color(178, 78, 77);
    feriaColorLuz = color(207, 110, 100);
    feriaColorBorde = color(127, 55, 52);
    feriaColorAcento = color(255, 185, 153);
    feriaColorSecundario = color(220, 133, 110);
  }
}

void feriaDibujarBoton(float x, float y, float w, float h, String etiqueta, boolean seleccionado) {
  boolean iluminar = seleccionado || feriaDentro(x, y, w, h);
  stroke(feriaColorBorde);
  strokeWeight(max(2, width / 512.0f));
  fill(feriaColorBoton);
  if (iluminar) fill(feriaColorAcento);
  rect(x, y, w, h, 8);
  noStroke();
  fill(feriaColorLuz);
  if (iluminar) fill(255, 90);
  rect(x + 4, y + 4, w - 8, h * 0.43f, 4);
  fill(255);
  if (iluminar) fill(feriaColorTexto);
  textAlign(CENTER, CENTER);
  textSize(18 * width / 1536.0f);
  text(etiqueta, x + w / 2, y + h / 2);
}

// Copia temporal de las variables narrativas que toca una demostración.
int[] feriaHistoriaint = new int[17];
float[] feriaHistoriafloat = new float[1];
boolean[] feriaHistoriaboolean = new boolean[18];
String[] feriaHistoriaString = new String[1];
void feriaGuardarHistoria() {
  feriaHistoriaint[0] = penEstadoActual;
  feriaHistoriaint[1] = penSubEstadoApuntado;
  feriaHistoriaint[2] = penDificultadActual;
  feriaHistoriaint[3] = tiroActual;
  feriaHistoriaint[4] = puntajePenaltis;
  feriaHistoriaint[5] = nv2SubEstado;
  feriaHistoriaint[6] = paginaActual;
  feriaHistoriaint[7] = paginaEscuela;
  feriaHistoriaint[8] = paginaCocina;
  feriaHistoriaint[9] = decisionCocinaTomada;
  feriaHistoriaint[10] = finalNivel3Pagina;
  feriaHistoriaint[11] = t3Etapa;
  feriaHistoriaint[12] = t3Pagina;
  feriaHistoriaint[13] = t3SaludLlegada;
  feriaHistoriaint[14] = hcDecision;
  feriaHistoriaint[15] = hcEtapa;
  feriaHistoriaint[16] = hcPagina;
  feriaHistoriafloat[0] = charsVisibles;
  feriaHistoriaboolean[0] = dialogoCompletado;
  feriaHistoriaboolean[1] = nv2Completado;
  feriaHistoriaboolean[2] = nv2ReiniciarPartida;
  feriaHistoriaboolean[3] = decisionPixagramTomada;
  feriaHistoriaboolean[4] = juegosDesbloqueados;
  feriaHistoriaboolean[5] = dia1Terminado;
  feriaHistoriaboolean[6] = finalNivel3Activo;
  feriaHistoriaboolean[7] = finalNivel3Bueno;
  feriaHistoriaboolean[8] = finalNivel3Creditos;
  feriaHistoriaboolean[9] = t3Activa;
  feriaHistoriaboolean[10] = t3ChatAbierto;
  feriaHistoriaboolean[11] = hcActiva;
  feriaHistoriaboolean[12] = hcBuena;
  feriaHistoriaboolean[13] = hcGrabaron;
  feriaHistoriaboolean[14] = hcPublicada;
  feriaHistoriaboolean[15] = hcMeGusta;
  feriaHistoriaboolean[16] = nv2AutoPlayBot;
  feriaHistoriaboolean[17] = t3IntroActiva;
  feriaHistoriaString[0] = ultimoTextoDialogo;
}
void feriaRestaurarHistoria() {
  penEstadoActual = feriaHistoriaint[0];
  penSubEstadoApuntado = feriaHistoriaint[1];
  penDificultadActual = feriaHistoriaint[2];
  tiroActual = feriaHistoriaint[3];
  puntajePenaltis = feriaHistoriaint[4];
  nv2SubEstado = feriaHistoriaint[5];
  paginaActual = feriaHistoriaint[6];
  paginaEscuela = feriaHistoriaint[7];
  paginaCocina = feriaHistoriaint[8];
  decisionCocinaTomada = feriaHistoriaint[9];
  finalNivel3Pagina = feriaHistoriaint[10];
  t3Etapa = feriaHistoriaint[11];
  t3Pagina = feriaHistoriaint[12];
  t3SaludLlegada = feriaHistoriaint[13];
  hcDecision = feriaHistoriaint[14];
  hcEtapa = feriaHistoriaint[15];
  hcPagina = feriaHistoriaint[16];
  charsVisibles = feriaHistoriafloat[0];
  dialogoCompletado = feriaHistoriaboolean[0];
  nv2Completado = feriaHistoriaboolean[1];
  nv2ReiniciarPartida = feriaHistoriaboolean[2];
  decisionPixagramTomada = feriaHistoriaboolean[3];
  juegosDesbloqueados = feriaHistoriaboolean[4];
  dia1Terminado = feriaHistoriaboolean[5];
  finalNivel3Activo = feriaHistoriaboolean[6];
  finalNivel3Bueno = feriaHistoriaboolean[7];
  finalNivel3Creditos = feriaHistoriaboolean[8];
  t3Activa = feriaHistoriaboolean[9];
  t3ChatAbierto = feriaHistoriaboolean[10];
  hcActiva = feriaHistoriaboolean[11];
  hcBuena = feriaHistoriaboolean[12];
  hcGrabaron = feriaHistoriaboolean[13];
  hcPublicada = feriaHistoriaboolean[14];
  hcMeGusta = feriaHistoriaboolean[15];
  nv2AutoPlayBot = feriaHistoriaboolean[16];
  t3IntroActiva = feriaHistoriaboolean[17];
  ultimoTextoDialogo = feriaHistoriaString[0];
}
