boolean finalNivel3Activo = false;
boolean finalNivel3Bueno = false;
int finalNivel3ForzadoDebug = -1;
final float UMBRAL_BIENESTAR_FINAL = 70;
final int UMBRAL_REPUTACION_FINAL = 15;
int finalNivel3Pagina = 0;
boolean finalNivel3Creditos = false;
int finalNivel3InicioCreditos = 0;
PImage finalNivel3Imagen;
PImage[] finalNivel3Borradores = new PImage[6];
int[] finalNivel3BorradoresDisponibles = new int[6];
int finalNivel3TotalBorradores = 0;
String[] finalNivel3LineasCreditos = {
  "#SAM THINKS A LOT",
  "#EQUIPO DE DESARROLLO",
  "Sebastian Andrés Pimienta Sánchez",
  "Andrés Felipe Escorcia Sánchez",
  "Juan Pablo Pineda Jimenez",
  "Abraham David Orozco Celedón",
  "#ARTE Y DISEÑO",
  "Andrés Felipe Escorcia Sánchez",
  "Sebastian Andrés Pimienta Sánchez",
  "#MÚSICA",
  "Devonshire Waltz Andante — Kevin MacLeod",
  "Boogie Party — Kevin MacLeod",
  "Teddy Bear Waltz — Kevin MacLeod",
  "Unholy Knight — Kevin MacLeod",
  "Miami Nights — Kevin MacLeod",
  "Wholesome — Kevin MacLeod",
  "Street Party — Kevin MacLeod",
  "RUSH E — Sheet Music Boss",
  "#MÚSICA DEL JUEGO",
  "appeal_100bpm · Hello-juliet · Aoi",
  "doki · tengo-mucho-drip",
  "Perfecto-Miserable",
  "musica_sala · musica_juego",
  "#MINIJUEGO PIXEL ART",
  "cancion_hamburguesa · cancion_sushi",
  "cancion_sonic · cancion_pikachu",
  "cancion_hongo · cancion_gato_gris",
  "cancion_pollito · cancion_stitch",
  "cancion_gato_flor",
  "#EFECTOS DE SONIDO",
  "Algunos efectos creados con ElevenLabs",
  "Otros efectos obtenidos de OpenGameArt.org",
  "#HERRAMIENTAS",
  "Creado con Processing",
  "#GRACIAS POR JUGAR"
};
String[] finalNivel3TextoBueno = {
  "Sam se aparta de la máquina y les da el turno a sus amigos.",
  "Entre risas, hablan de la tarde y Sam escucha a sus amigos. Les pregunta antes de compartir cualquier foto.",
  "Sam guarda el celular y se une a ellos para buscar otra máquina. Todavía queda mucho por compartir."
};
String[] finalNivel3TextoMalo = {
  "Sam se queda mirando la máquina, pensando en todo lo que pudo haber hecho mejor.",
  "Sus amigos intentan animarlo, pero él se aparta y tarda en escuchar lo que le dicen.",
  "Al salir, Mateo le recuerda que no tienen que ganar para pasarla bien. Sam guarda silencio; necesita tiempo para escucharlo."
};

void iniciarFinalNivel3(boolean ganoArcade) {
  if (!feriaActiva) {

  finalNivel3Activo = true;
  finalNivel3Pagina = 0;
  finalNivel3Creditos = false;
  nv3_detenerTodaLaMusica();
  if (ganoArcade) {
    modificarBienestar(8, width / 2, height / 2);
    modificarReputacion(10, width / 2, height / 2 - 40 * escalaY);
  }
  finalNivel3Bueno = bienestarDigital >= UMBRAL_BIENESTAR_FINAL && reputacionDigital >= UMBRAL_REPUTACION_FINAL;
  if (finalNivel3ForzadoDebug == 0) finalNivel3Bueno = false;
  if (finalNivel3ForzadoDebug == 1) finalNivel3Bueno = true;
  reaccionClipAlResultado(finalNivel3Bueno);
  if (finalNivel3ForzadoDebug < 0 && finalNivel3Bueno && ganoArcade) desbloquearLogro(19);
  if (finalNivel3ForzadoDebug < 0 && !finalNivel3Bueno && !ganoArcade && nv3_fase == 3 && nv3_intentosFase >= 2) desbloquearLogro(20);
  finalNivel3ForzadoDebug = -1;
  String archivo = "final_malo.png";
  if (finalNivel3Bueno) archivo = "final_bueno.png";
  finalNivel3Imagen = null;
  if (dataFile(archivo).exists()) finalNivel3Imagen = loadImage(archivo);
  finalNivel3TotalBorradores = 0;
  for (int i = 0; i < TAM_FINAL_NIVEL3_BORRADORES; i++) {
    String nombre = "borrador_" + nf(i + 1, 2) + ".png";
    finalNivel3Borradores[i] = null;
    if (dataFile(nombre).exists()) {
      finalNivel3Borradores[i] = loadImage(nombre);
      if (finalNivel3Borradores[i] != null && finalNivel3Borradores[i].width > 0) {
        finalNivel3BorradoresDisponibles[finalNivel3TotalBorradores] = i;
        finalNivel3TotalBorradores++;
      }
    }
  }

  } else {
    feriaTerminoArcade = true;
    reaccionClipAlResultado(ganoArcade);
  }
}

void abrirFinalNivel3Debug(boolean bueno) {
  detenerMediosParaSaltoDebug();
  t3Reiniciar();
  reiniciarHistoriaDespuesCocina();
  t3Activa = true;
  t3Etapa = 4;
  estadoActual = HISTORIA3_ARCADE;
  estadoDestino = HISTORIA3_ARCADE;
  enTransicion = false;
  alphaTransicion = 0;
  finalNivel3ForzadoDebug = 0;
  if (bueno) finalNivel3ForzadoDebug = 1;
  iniciarFinalNivel3(false);
}

void avanzarFinalNivel3() {
  if (!finalNivel3Creditos) {
    finalNivel3Pagina++;
    if (finalNivel3Pagina >= TAM_FINAL_NIVEL3_TEXTO_BUENO) {
      finalNivel3Creditos = true;
      finalNivel3InicioCreditos = millis();
    }
  }
}

void dibujarFinalNivel3() {
  pushStyle();
  rectMode(CORNER);
  imageMode(CORNER);
  background(12, 15, 30);
  if (!finalNivel3Creditos) {
    if (finalNivel3Imagen != null) image(finalNivel3Imagen, 0, 0, width, height);
    noStroke();
    fill(5, 8, 20, 210);
    rect(width * 0.06f, height * 0.70f, width * 0.88f, height * 0.23f, 12);
    fill(255, 220, 120);
    textAlign(LEFT, TOP);
    textSize(24 * escalaX);
    text("SAM", width * 0.09f, height * 0.73f);
    fill(255);
    textSize(24 * escalaX);
    String linea = finalNivel3TextoMalo[finalNivel3Pagina];
    if (finalNivel3Bueno) linea = finalNivel3TextoBueno[finalNivel3Pagina];
    text(linea, width * 0.09f, height * 0.78f, width * 0.82f, height * 0.11f);
    fill(200);
    textAlign(RIGHT, BOTTOM);
    textSize(15 * escalaX);
    text("ENTER / ESPACIO / CLIC para continuar", width * 0.91f, height * 0.91f);
  } else {
    float transcurrido = ((enPausa ? pausaInicioMs : millis()) - finalNivel3InicioCreditos) / 1000.0f;
    dibujarFondoCreditosFinal(transcurrido);
    dibujarBorradorCreditos(transcurrido);
    textAlign(CENTER, CENTER);
    float paso = 44 * escalaY;
    float y = height - transcurrido * 38 * escalaY;
    for (int i = 0; i < TAM_FINAL_NIVEL3_LINEAS_CREDITOS; i++) {
      float lineaY = y + i * paso;
      if (lineaY > -40 * escalaY && lineaY < height + 40 * escalaY) {
        String linea = finalNivel3LineasCreditos[i];
        boolean titulo = linea.startsWith("#");
        if (titulo) {
          linea = linea.substring(1);
          fill(255, 220, 150);
          textSize(23 * escalaX);
        } else {
          fill(255);
          textSize(18 * escalaX);
        }
        text(linea, width * 0.26f, lineaY);
      }
    }
    if (!enPausa && transcurrido >= duracionCreditosFinal()) {
      t3Reiniciar();
      estadoActual = MENU;
      estadoDestino = MENU;
    }
  }
  popStyle();
}

float duracionCreditosFinal() {
  float distancia = height + 40 * escalaY + (TAM_FINAL_NIVEL3_LINEAS_CREDITOS - 1) * 44 * escalaY;
  float duracion = distancia / (38 * escalaY) + 4;
  return max(60, duracion);
}

void dibujarFondoCreditosFinal(float tiempo) {
  pushStyle();
  noStroke();
  rectMode(CORNER);
  if (finalNivel3Bueno) background(23, 21, 43);
  else background(12, 20, 38);

  // Bandas de luz que respiran lentamente, con colores propios de cada final.
  for (int i = 0; i < 8; i++) {
    float pulso = 0.5f + 0.5f * sin(tiempo * 0.45f + i * 0.7f);
    if (finalNivel3Bueno) fill(133 + i * 7, 79 + i * 4, 92 + i * 3, 5 + pulso * 5);
    else fill(43 + i * 3, 78 + i * 4, 132 + i * 5, 4 + pulso * 5);
    float bandaY = height * (0.10f + i * 0.11f) + sin(tiempo * 0.22f + i) * 12 * escalaY;
    rect(0, bandaY, width, height * 0.17f);
  }

  // Final bueno: motas cálidas que suben. Final malo: lluvia azul pausada.
  for (int i = 0; i < 70; i++) {
    float x = ((i * 149.0f + sin(i * 3.1f) * 65) % width + width) % width;
    float velocidad = (finalNivel3Bueno ? 9 : 23) + (i % 5) * 4;
    float baseY = (i * 83.0f + tiempo * velocidad) % (height + 40);
    float y = baseY - 20;
    if (finalNivel3Bueno) {
      y = height + 20 - baseY;
      float brillo = 0.5f + 0.5f * sin(tiempo * 1.6f + i);
      fill(255, 205 + (i % 3) * 15, 120, 35 + brillo * 100);
      float tam = (2 + i % 4) * escalaX;
      rect(x + sin(tiempo * 0.6f + i) * 12 * escalaX, y, tam, tam);
    } else {
      fill(128, 180, 225, 25 + (i % 4) * 12);
      rect(x + sin(tiempo * 0.3f + i) * 5 * escalaX, y, 2 * escalaX, (8 + i % 5 * 3) * escalaY);
    }
  }
  // La columna de nombres permanece legible sobre la animación.
  fill(5, 9, 22, 115);
  rect(0, 0, width * 0.52f, height);
  popStyle();
}

void dibujarBorradorCreditos(float tiempo) {
  if (finalNivel3TotalBorradores > 0) {
    float duracion = duracionCreditosFinal() / finalNivel3TotalBorradores;
    int posicion = min(finalNivel3TotalBorradores - 1, int(tiempo / duracion));
    PImage borrador = finalNivel3Borradores[finalNivel3BorradoresDisponibles[posicion]];
    float local = tiempo - posicion * duracion;
    float alfa = min(constrain(local / 0.8f, 0, 1), constrain((duracion - local) / 0.8f, 0, 1));
    float escala = min(width * 0.40f / borrador.width, height * 0.53f / borrador.height);
    float w = borrador.width * escala;
    float h = borrador.height * escala;
    float flotar = sin(tiempo * 0.8f) * 8 * escalaY;
    pushStyle();
    pushMatrix();
    translate(width * 0.75f, height * 0.48f + flotar);
    rotate(sin(tiempo * 0.45f) * 0.012f);
    rectMode(CENTER);
    noStroke();
    fill(0, 0, 0, 75 * alfa);
    rect(9 * escalaX, 12 * escalaY, w + 30 * escalaX, h + 30 * escalaY, 7);
    if (finalNivel3Bueno) fill(232, 207, 173, 235 * alfa);
    else fill(159, 181, 204, 225 * alfa);
    rect(0, 0, w + 22 * escalaX, h + 22 * escalaY, 5);
    imageMode(CENTER);
    tint(255, 255 * alfa);
    image(borrador, 0, 0, w, h);
    popMatrix();
    popStyle();
  }
}
