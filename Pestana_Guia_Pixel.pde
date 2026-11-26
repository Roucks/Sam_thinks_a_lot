final int GUIA_TECLA = 112; // F1
final int GUIA_DURACION_MS = 7800;
final int GUIA_TOTAL = 14;
final int GUIA_CELULAR = 4;
final int GUIA_PRESENTACION_MS = 5000;
final int GUIA_ETAPAS_PRESENTACION = 4;
final int GUIA_CLIP_COLUMNAS = 16;
final int GUIA_CLIP_FILAS = 20;

boolean[] guiaYaMostrada = new boolean[GUIA_TOTAL];
int guiaContextoVisible = -1;
int guiaInicio = -GUIA_DURACION_MS;
boolean guiaF1Presionada = false;
float guiaDesvioX, guiaDesvioY;
float guiaDestinoDesvioX, guiaDestinoDesvioY;
int guiaUltimoMovimiento = -1;
boolean guiaPresentacionPendiente = false;
int guiaPresentacionInicio = -1;
int guiaPresentacionFin = -GUIA_DURACION_MS;
int guiaNivelPresentado = 0;
boolean[] guiaIntroduccionVista = new boolean[GUIA_ETAPAS_PRESENTACION];
String[][] guiaPresentaciones = {
  {"¡Soy Clip!", "Sam, me escabullí de tu cuaderno. Ven, te muestro por dónde empezar."},
  {"Nivel 1 · Penaltis", "Tres pulsaciones: dirección, altura y potencia. Marca tres goles. Si le pegas a la luna, yo no voy por el balón."},
  {"Nivel 2 · Cocina al ritmo", "Pulsa la tecla del carril cuando llegue la nota. Si es larga, mantenla. El guiso no se remueve con clics desesperados."},
  {"Nivel 3 · Arcade", "Elige personaje, recoge fichas y llega a la salida. Salta con Espacio. Los barriles no aceptan disculpas."}
};

String[][] guiaTextos = {
  {"Habitación de Sam", "Camina hasta la escalera. Usa E cuando aparezca el aviso.", "WASD", "↑ ↓ ← →", "E"},
  {"Sala y comedor", "Acércate a tus padres y pulsa E para hablar.", "WASD", "E", ""},
  {"Hora de desayunar", "Acércate a la mesa y pulsa E para sentarte.", "E", "", ""},
  {"A descansar", "Sube al cuarto y pulsa E junto a la cama.", "WASD", "E", ""},
  {"", "", "", "", ""}, // El inicio del celular usa su propio recorrido.
  {"Penaltis", "Fija dirección, altura y potencia. Pulsa una vez por cada paso.", "CLIC", "ESPACIO", ""},
  {"Cocina al ritmo", "Toca la tecla del carril cuando llegue la nota. En las largas, mantenla pulsada.", "", "", ""},
  {"Parejas", "Voltea dos cartas iguales. Cada tablero superado suma 10 segundos.", "CLIC", "", ""},
  {"Frutas en la jarra", "Mueve el ratón y suelta frutas iguales juntas. Cuida la línea de peligro.", "CLIC", "ESPACIO", ""},
  {"Pixel Art", "Elige un color y pinta su número. Usa el clic derecho para borrar.", "CLIC", "CLIC DER.", ""},
  {"Arcade", "", "WASD", "ESPACIO", "E"},
  {"Arcade", "Elige un personaje para ver su habilidad. Confirma para entrar.", "1–4", "ENTER", ""},
  {"La historia de Sam", "Completa el texto y vuelve a pulsar para pasar de página.", "CLIC", "ENTER", ""},
  {"A cocinar", "Mira las teclas de la dificultad elegida antes de empezar la canción.", "", "", ""}
};

// Silueta de un clip de cobre y menta, con el rostro animado por separado.
String[] guiaClipPixeles = {
  ".....oooooo.....",
  "....ohhhhhso....",
  "...ohhsssssso...",
  "..ohsoooooosso..",
  "..ohso....osso..",
  "..ohso....osso..",
  "..ohso....osso..",
  "..ohso....osso..",
  "..ohso....osso..",
  "..ohso....ossoo.",
  "..ohso....osshso",
  "..ohso.oo.osshso",
  "..ohso.ohsosshso",
  "..ohso.ohsss.hso",
  "..ohso..osso.hso",
  "..ohso.......hso",
  "...ohso.....hso.",
  "....ohsoooohso..",
  ".....ohhhhsso...",
  "......oooooo...."
};

int obtenerContextoGuia() {
  if (enPausa || mostrarOpciones || mostrarResumenPuntos || dialogoCamaActivo) return -1;
  if (feriaActiva && feriaResultado()) return -1;
  if (t3Activa) {
    if (t3IntroActiva || finalNivel3Activo || nv3_pausa) return -1;
    if (t3Etapa == 4 && nv3_estadoMenu < 0) {
      if (nv3_pantalla == 1) return 11;
      if (nv3_pantalla == 2) return 10;
    }
    return -1;
  }
  if (hcActiva) return -1;
  if (estadoActual == EXPLORACION) {
    if (animandoEscalera || leyendoMensaje || mostrandoModalDormir) return -1;
    if (dia1Terminado || desayunoComido) return 3;
    if (pisoActual == 2) return 0;
    if (!tieneCelular) return 1;
    return 2;
  }
  if (estadoActual == NIVEL1) {
    if (enHome) return GUIA_CELULAR;
    if (appAbierta.equals("Parejas") && parEstadoJuego <= 1) return 7;
    if (appAbierta.equals("Frutas") && !frutaPerdio) return 8;
    if (appAbierta.equals("Pixel Art") && !paChecked) return 9;
  }
  if (estadoActual == PENALTIS && penEstadoActual < 4) return 5;
  if (estadoActual == SELECCION_DIF_NV2) return 13;
  if (estadoActual == NIVEL2 && nv2SubEstado == NV2_SUB_JUGANDO && !nv2ExtremoFaseAlerta) return 6;
  if (estadoActual == NOVELA_ESCUELA || (estadoActual == JUEGO && !mostrarSaltarIntro)) return 12;
  return -1;
}

void actualizarContextoGuia(int contexto, int ahora) {
  if (contexto != guiaContextoVisible) {
    guiaContextoVisible = contexto;
    guiaInicio = ahora - GUIA_DURACION_MS;
    guiaDesvioX = 0;
    guiaDesvioY = 0;
    guiaDestinoDesvioX = 0;
    guiaDestinoDesvioY = 0;
    guiaUltimoMovimiento = -1;
  }
}

void alternarGuia() {
  int contexto = obtenerContextoGuia();
  if (contexto >= 0) {
    int ahora = millis();
    actualizarContextoGuia(contexto, ahora);
    if (ahora - guiaInicio < GUIA_DURACION_MS) guiaInicio = ahora - GUIA_DURACION_MS;
    else guiaInicio = ahora;
    guiaYaMostrada[contexto] = true;
  }
}

void prepararPresentacionClip() {
  iniciarPresentacionClip(0);
}

void iniciarPresentacionClip(int nivel) {
  guiaNivelPresentado = nivel;
  guiaIntroduccionVista[nivel] = true;
  guiaPresentacionPendiente = true;
  guiaPresentacionInicio = -1;
}

int nivelEnEntradaDeJuego() {
  if (estadoActual == PENALTIS && penEstadoActual == 0) return 1;
  if (estadoActual == SELECCION_DIF_NV2) return 2;
  if (t3Activa && !t3IntroActiva && !finalNivel3Activo && t3Etapa == 4
      && nv3_estadoMenu < 0 && nv3_pantalla == 1) return 3;
  return 0;
}

void prepararPresentacionDeNivelClip() {
  int nivel = nivelEnEntradaDeJuego();
  if (!guiaPresentacionPendiente && nivel > 0 && !enPausa && !guiaIntroduccionVista[nivel]) {
    iniciarPresentacionClip(nivel);
  }
}

void reiniciarPresentacionesClip() {
  guiaPresentacionPendiente = false;
  reiniciarGuiaCelular();
  for (int i = 0; i < GUIA_ETAPAS_PRESENTACION; i++) guiaIntroduccionVista[i] = false;
}

void terminarPresentacionClip() {
  guiaPresentacionPendiente = false;
  if (guiaNivelPresentado == 0) {
    guiaPresentacionFin = millis();
    guiaContextoVisible = -1;
    guiaYaMostrada[0] = false;
  } else {
    int contexto = obtenerContextoGuia();
    if (contexto >= 0) guiaYaMostrada[contexto] = true;
  }
}

void dibujarPresentacionClip(int ahora) {
  if (guiaPresentacionInicio < 0) guiaPresentacionInicio = ahora;
  int edad = ahora - guiaPresentacionInicio;
  if (guiaNivelPresentado == 0 && edad >= GUIA_PRESENTACION_MS) {
    terminarPresentacionClip();
    return;
  }
  float entrada = constrain(edad / 480.0f, 0, 1);
  entrada = entrada * entrada * (3 - 2 * entrada);
  pushStyle();
  pushMatrix();
  scale(escalaX, escalaY);
  rectMode(CORNER);
  noStroke();
  fill(9, 17, 35, 160 * entrada);
  rect(0, 0, REF_W, REF_H);
  float centroX = REF_W / 2;
  float pixel = lerp(17, 28, entrada);
  float y = 304 - 10 * pixel + 8 * sin(ahora * 0.004f);
  dibujarClipPixel(centroX - 8 * pixel, y, pixel, ahora, true, entrada);
  dibujarBurbujaClip(centroX - 344, 631, 688, 157, centroX, 600,
    guiaPresentaciones[guiaNivelPresentado][0], guiaPresentaciones[guiaNivelPresentado][1], 23, entrada);
  fill(22, 67, 78, 255 * entrada);
  textAlign(CENTER, CENTER);
  textSize(15);
  text("Clic, Enter o Espacio para seguir", centroX, 767);
  popMatrix();
  popStyle();
}

void dibujarGuiaDeJuego() {
  int contexto = obtenerContextoGuia();
  int ahora = millis();
  if (enTransicion || alphaTransicion > 0) return;
  prepararPresentacionDeNivelClip();
  if (guiaPresentacionPendiente) {
    dibujarPresentacionClip(ahora);
    return;
  }
  if (guiaPixagramDentro()) {
    dibujarGuiaDentroDePixagram(ahora);
    return;
  }
  if (contexto == GUIA_CELULAR) {
    dibujarGuiaCelular(ahora);
    return;
  }
  if (contexto < 0) {
    if (estadoActual == EXPLORACION && !enPausa && !mostrarResumenPuntos) dibujarClipEnEsquina(ahora, false);
    return;
  }

  actualizarContextoGuia(contexto, ahora);
  if (!guiaYaMostrada[contexto]) {
    guiaYaMostrada[contexto] = true;
    guiaInicio = ahora;
  }
  int edad = ahora - guiaInicio;
  float entrada = constrain(edad / 220.0f, 0, 1);
  float salida = constrain((GUIA_DURACION_MS - edad) / 350.0f, 0, 1);
  float opacidad = entrada * salida;
  if (edad >= GUIA_DURACION_MS) {
    if (contexto != 6) dibujarClipEnEsquina(ahora, true);
    return;
  }

  float ancho = 300;
  float y = 112;
  if (contexto == 7 || contexto == 9 || contexto == 12 || contexto == 13) y = 16;
  if (contexto == 9) ancho = 285;
  if (contexto == 10 || contexto == 11) ancho = 216;
  if (contexto == 6) {
    y = 202;
    float bordeCarril = nv2CarrilBaseX[max(0, nv2NumCarrilesActivos - 1)] + 74;
    ancho = constrain(REF_W - bordeCarril - 20, 190, 300);
  }
  float x = REF_W - ancho - 16;
  if (estadoActual == EXPLORACION) x = 16;
  boolean senala = estadoActual == EXPLORACION;
  float objetivoX = 0;
  float objetivoY = 0;
  if (estadoActual == EXPLORACION) {
    objetivoX = escaleraAccesoX() / escalaX;
    objetivoY = escaleraAccesoY() / escalaY - 22;
    if (contexto == 1) {
      objetivoX = (padresX + padresSep / 2 + pjW / 2) / escalaX;
      objetivoY = max(76, padresY / escalaY - 18);
    }
    if (contexto == 2 || (contexto == 3 && pisoActual == 2)) {
      objetivoX = (obsX[1] + obsW[1] / 2) / escalaX;
      objetivoY = obsY[1] / escalaY + 28;
    }
  }
  if (senala) {
    dibujarClipSenalando(x, y, ancho, objetivoX, objetivoY, contexto, edad, ahora,
      estadoActual == EXPLORACION ? entrada : opacidad);
    return;
  }

  pushStyle();
  pushMatrix();
  scale(escalaX, escalaY);
  translate(x, y);
  rectMode(CORNER);
  noStroke();
  if (fontBody != null) textFont(fontBody);
  translate(0, round((1 - entrada) * -8));
  fill(8, 12, 26, 125 * opacidad);
  rect(4, 128, ancho - 4, 6);
  rect(ancho, 6, 4, 122);
  fill(18, 27, 52, 216 * opacidad);
  rect(0, 4, ancho, 120);
  rect(4, 0, ancho - 8, 4);
  rect(4, 124, ancho - 8, 4);
  fill(113, 222, 196, 225 * opacidad);
  rect(4, 0, ancho - 8, 2);
  rect(0, 4, 2, 16);
  if (contexto != 6) dibujarClipPixel(10, 1, 2.4f, ahora, edad < 2600, opacidad);

  if (fuenteComic != null) textFont(fuenteComic);
  textAlign(LEFT, CENTER);
  textSize(17);
  fill(250, 224, 174, 255 * opacidad);
  text(guiaTextos[contexto][0], contexto == 6 ? 12 : 54, 24);
  if (fontBody != null) textFont(fontBody);
  textAlign(LEFT, TOP);
  textSize(14);
  textLeading(16);
  fill(245, 247, 254, 255 * opacidad);
  String consejo = guiaTextos[contexto][1];
  if (contexto == 10) {
    consejo = "Recoge fichas y llega a la salida. " + nv3_ayudaHabilidad[nv3_personaje] + ".";
  }
  text(consejo, 12, 51, ancho - 24, 50);
  float teclaX = 12;
  for (int i = 2; i < 5; i++) {
    String etiqueta = guiaTextos[contexto][i];
    if (!etiqueta.isEmpty()) {
      textSize(11);
      float teclaW = max(22, ceil(textWidth(etiqueta)) + 12);
      dibujarTeclaGuia(etiqueta, teclaX, 103, teclaW, opacidad);
      teclaX += teclaW + 4;
    }
  }
  dibujarTeclaGuia("F1", ancho - 40, 103, 28, opacidad * 0.80f);
  popMatrix();
  popStyle();

}

void dibujarClipSenalando(float panelX, float panelY, float ancho, float objetivoX,
    float objetivoY, int contexto, int edad, int ahora, float opacidad) {
  int lado = objetivoX < panelX ? -1 : 1;
  boolean desdeCentro = contexto == 0 && ahora - guiaPresentacionFin < GUIA_DURACION_MS;
  float viaje = constrain(edad / (desdeCentro ? 940.0f : 720.0f), 0, 1);
  viaje = viaje * viaje * (3 - 2 * viaje);
  float partidaX = lado == 1 ? panelX + ancho : panelX;
  float centroX = lerp(desdeCentro ? REF_W / 2 : partidaX, objetivoX - 70 * lado, viaje);
  float centroY = lerp(desdeCentro ? 304 : panelY + 25, objetivoY - 16, viaje);
  centroY -= 45 * sin(PI * viaje);
  float pixel = lerp(desdeCentro ? 28 : 3.1f, 4.1f, viaje);
  float burbujaW = desdeCentro ? lerp(604, 328, viaje) : 328;
  float burbujaX = constrain(centroX - burbujaW / 2, 18, REF_W - burbujaW - 18);
  float burbujaY = max(16, centroY - 10 * pixel - 108);
  if (desdeCentro) burbujaY = centroY + 10 * pixel + lerp(61, 16, viaje);
  float puntaX = objetivoX - 5 * lado;
  float opacidadBurbuja = opacidad;
  boolean enDesvio = false;
  if (estadoActual == EXPLORACION) {
    moverClipAlApartarse(centroX, centroY, pixel, burbujaX, burbujaY, burbujaW, ahora);
    centroX += guiaDesvioX;
    centroY += guiaDesvioY;
    burbujaX = constrain(burbujaX + guiaDesvioX, 18, REF_W - burbujaW - 18);
    burbujaY = constrain(burbujaY + guiaDesvioY, 16, REF_H - 106);
    enDesvio = abs(guiaDesvioX) + abs(guiaDesvioY) > 6;
    float retiro = constrain((edad - (GUIA_DURACION_MS - 520)) / 520.0f, 0, 1);
    retiro = retiro * retiro * (3 - 2 * retiro);
    centroX = lerp(centroX, clipXEnEsquina() + 16, retiro);
    centroY = lerp(centroY, 40, retiro);
    pixel = lerp(pixel, 2, retiro);
    opacidadBurbuja *= 1 - retiro;
  }
  pushStyle();
  pushMatrix();
  scale(escalaX, escalaY);
  rectMode(CORNER);
  noStroke();
  dibujarBurbujaClip(burbujaX, burbujaY, burbujaW, 90, centroX,
    burbujaY > centroY ? centroY + 10 * pixel + 5 : centroY - 10 * pixel - 3,
    guiaTextos[contexto][0], guiaTextos[contexto][1], 16, opacidadBurbuja);
  dibujarClipPixel(centroX - 8 * pixel, centroY - 10 * pixel, pixel, ahora, edad < 4000, opacidad);

  float alfa = 255 * opacidadBurbuja * constrain((edad - 440) / 190.0f, 0, 1);
  if (enDesvio) {
    pushMatrix();
    translate(centroX, centroY);
    rotate(atan2(objetivoY - centroY, objetivoX - centroX));
    translate(8 * pixel + 33, 0);
    dibujarFlechaClip(0, 0, 1, alfa);
    popMatrix();
  } else {
    dibujarFlechaClip(puntaX, objetivoY, lado, alfa);
  }
  popMatrix();
  popStyle();
}

void dibujarFlechaClip(float puntaX, float objetivoY, int lado, float alfa) {
  fill(13, 37, 57, alfa);
  rect(min(puntaX, puntaX - 27 * lado) - 2, objetivoY - 12, 31, 24);
  fill(255, 211, 122, alfa);
  rect(min(puntaX, puntaX - 24 * lado), objetivoY - 2, 24, 4);
  for (int paso = 0; paso < 3; paso++) {
    float puntaPaso = puntaX - (paso + 1) * 4 * lado;
    rect(puntaPaso - 2, objetivoY - 2 - paso * 3, 4, 4);
    rect(puntaPaso - 2, objetivoY - 2 + paso * 3, 4, 4);
  }
}

float espacioParaClip(float centroX, float centroY, float pixel,
    float burbujaX, float burbujaY, float burbujaW, float dx, float dy) {
  float xTexto = constrain(burbujaX + dx, 18, REF_W - burbujaW - 18);
  float yTexto = constrain(burbujaY + dy, 16, REF_H - 106);
  return min(distanciaSamALaGuia(xTexto, yTexto, burbujaW, 90),
    distanciaSamALaGuia(centroX + dx - 8 * pixel - 26, centroY + dy - 10 * pixel - 26,
      16 * pixel + 52, 20 * pixel + 52));
}

void moverClipAlApartarse(float centroX, float centroY, float pixel, float burbujaX,
    float burbujaY, float burbujaW, int ahora) {
  float espacioOriginal = espacioParaClip(centroX, centroY, pixel, burbujaX, burbujaY, burbujaW, 0, 0);
  if (espacioOriginal > 120) {
    guiaDestinoDesvioX = 0;
    guiaDestinoDesvioY = 0;
  }
  if (espacioOriginal <= 120 && espacioParaClip(centroX, centroY, pixel, burbujaX, burbujaY, burbujaW,
      guiaDestinoDesvioX, guiaDestinoDesvioY) < 86) {
    float mejor = -10000;
    for (int fila = -1; fila <= 1; fila++) {
      for (int columna = -1; columna <= 1; columna++) {
        if (columna != 0 || fila != 0) {
          float dx = constrain(centroX + columna * 250, 8 * pixel + 22, REF_W - 8 * pixel - 22) - centroX;
          float dy = constrain(centroY + fila * 205, 10 * pixel + 18, REF_H - 10 * pixel - 18) - centroY;
          float espacio = espacioParaClip(centroX, centroY, pixel, burbujaX, burbujaY, burbujaW, dx, dy);
          float valor = min(espacio, 150) - 0.16f * dist(guiaDesvioX, guiaDesvioY, dx, dy);
          if (valor > mejor) {
            mejor = valor;
            guiaDestinoDesvioX = dx;
            guiaDestinoDesvioY = dy;
          }
        }
      }
    }
  }
  int dt = guiaUltimoMovimiento < 0 ? 16 : constrain(ahora - guiaUltimoMovimiento, 0, 50);
  guiaUltimoMovimiento = ahora;
  float avance = 1 - exp(-dt / 92.0f);
  guiaDesvioX = lerp(guiaDesvioX, guiaDestinoDesvioX, avance);
  guiaDesvioY = lerp(guiaDesvioY, guiaDestinoDesvioY, avance);
}

float distanciaSamALaGuia(float x, float y, float ancho, float alto) {
  float izqSam = pjX / escalaX;
  float derSam = (pjX + pjW) / escalaX;
  float arribaSam = pjY / escalaY;
  float abajoSam = (pjY + pjH) / escalaY;
  float dx = max(0, max(x - derSam, izqSam - x - ancho));
  float dy = max(0, max(y - abajoSam, arribaSam - y - alto));
  return sqrt(dx * dx + dy * dy);
}

float clipXEnEsquina() {
  float x = REF_W - 54;
  if (estadoActual == EXPLORACION && distanciaSamALaGuia(x - 8, 20, 50, 68) < 42) x = 18;
  return x;
}

void dibujarClipEnEsquina(int ahora, boolean mostrarTecla) {
  float x = clipXEnEsquina();
  float y = 20;
  if (t3Activa && t3Etapa == 4) y = 76;
  pushStyle();
  pushMatrix();
  scale(escalaX, escalaY);
  rectMode(CORNER);
  noStroke();
  fill(18, 40, 61, 200);
  rect(x - 5, y - 3, 42, mostrarTecla ? 63 : 45, 8);
  dibujarClipPixel(x, y, 2, ahora, false, 1);
  if (mostrarTecla) {
    if (fontBody != null) textFont(fontBody);
    dibujarTeclaGuia("F1", x + 3, y + 41, 26, 0.8f);
  }
  popMatrix();
  popStyle();
}

void dibujarBurbujaClip(float x, float y, float ancho, float alto, float puntaX,
    float puntaY, String titulo, String mensaje, float tamTexto, float opacidad) {
  float bordeY = puntaY < y ? y : y + alto;
  float colaX = constrain(puntaX, x + 30, x + ancho - 30);
  float colaY = constrain(puntaY, bordeY - 30, bordeY + 30);
  stroke(18, 43, 56, 255 * opacidad);
  strokeWeight(3);
  fill(250, 245, 220, 255 * opacidad);
  rect(x, y, ancho, alto, 12);
  noStroke();
  triangle(colaX - 12, bordeY + (puntaY < y ? 3 : -3),
    colaX + 12, bordeY + (puntaY < y ? 3 : -3), colaX, colaY);
  if (fuenteComic != null) textFont(fuenteComic);
  fill(19, 67, 72, 255 * opacidad);
  textAlign(LEFT, TOP);
  textSize(tamTexto + 4);
  text(titulo, x + 18, y + 10);
  if (fontBody != null) textFont(fontBody);
  fill(19, 34, 50, 255 * opacidad);
  textSize(tamTexto);
  textLeading(tamTexto + 3);
  text(mensaje, x + 18, y + tamTexto + 20, ancho - 36, alto - tamTexto - 24);
}

void dibujarTeclaGuia(String etiqueta, float x, float y, float ancho, float opacidad) {
  fill(71, 104, 135, 230 * opacidad);
  rect(x, y + 2, ancho, 16);
  fill(23, 40, 65, 255 * opacidad);
  rect(x + 2, y, ancho - 4, 15);
  fill(207, 251, 240, 255 * opacidad);
  textSize(11);
  textAlign(CENTER, CENTER);
  text(etiqueta, x + ancho / 2, y + 7);
}

void dibujarClipPixel(float x, float y, float pixel, int ahora, boolean hablando, float opacidad) {
  pushMatrix();
  translate(x, y + round(3 * sin(ahora * 0.004f)));
  scale(pixel);
  noStroke();
  for (int fila = 0; fila < GUIA_CLIP_FILAS; fila++) {
    for (int columna = 0; columna < GUIA_CLIP_COLUMNAS; columna++) {
      char tono = guiaClipPixeles[fila].charAt(columna);
      if (tono != '.') {
        if (tono == 'o') fill(24, 60, 83, 255 * opacidad);
        if (tono == 's') fill(67, 151, 157, 255 * opacidad);
        if (tono == 'h') fill(148, 238, 215, 255 * opacidad);
        rect(columna, fila, 1, 1);
      }
    }
  }

  boolean parpadeo = ahora % 3300 > 3160;
  int gesto = hablando ? (ahora / 145) % 3 : 0;
  for (int ojo = 0; ojo < 2; ojo++) {
    int ojoX = 3 + ojo * 6;
    int ojoY = 6 + ojo;
    fill(13, 33, 51, 255 * opacidad);
    rect(ojoX - 1, ojoY - 1, 6, 6);
    if (parpadeo) {
      fill(151, 235, 217, 255 * opacidad);
      rect(ojoX, ojoY + 2, 4, 1);
    } else {
      fill(252, 245, 221, 255 * opacidad);
      rect(ojoX, ojoY, 4, 4);
      fill(24, 46, 65, 255 * opacidad);
      rect(ojoX + 2, ojoY + 1, 2, 2);
    }
    fill(255, 191, 120, 255 * opacidad);
    rect(ojoX, ojoY - 2 - (gesto == 2 ? 1 : 0), 3, 1);
  }
  fill(247, 186, 124, 255 * opacidad);
  rect(6, 12, 2 + gesto, 1);
  if (gesto > 0) rect(7, 13, 2, gesto);
  popMatrix();
}
