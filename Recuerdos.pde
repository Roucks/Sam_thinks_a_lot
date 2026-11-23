// Colección vinculada a los logros globales. Preferencias independientes de la partida.
final int RECUERDOS = 19;
final int REC_TOTAL = 9;
final int REC_TEMAS = 3;
final int REC_MARCOS = 3;
int recSeccion = 0;
int recSeleccion = 0;
int recLinea = 0;
int recTema = 0;
int recMarco = 0;
boolean recCargado = false;
PImage recFondoMenu;
PImage[] recImagen = new PImage[REC_TOTAL];
int[] recLogro = {1, 7, 9, 16, 8, 5, 19, 20, 0};
String[] recNombres = {"El desayuno", "Una tarde en la cancha", "La primera receta", "Un récord entre amigos", "Un acuerdo en casa", "Antes de compartir", "Una buena tarde", "Tiempo para escuchar", "Detrás de los dibujos"};
String[] recArchivos = {"escena_desayuno.png", "post_penaltis_gana.png", "comida_cocina_buena.png", "recuerdo_arcade.png", "recuerdo_acuerdo.png", "recuerdo_defensor.png", "final_bueno.png", "final_malo.png", "borrador_01.png"};
String[][] recDialogos = {
  {"MAMÁ: ¿Otro poquito? Esta vez todavía están calientes.", "SAM: Sí. Hoy el celular puede esperar.", "PAPÁ: Entonces pásame el jugo antes de que se lo acaben."},
  {"MATEO: El último penalti casi lo saco, ¿sí viste?", "SAM: Casi. Eso también cuenta como elogio.", "CRISTIAN: La revancha queda pendiente. ¡Y ahora sí salgo bien en la foto!"},
  {"MATEO: Yo dije que necesitaba más sal.", "SAM: Tú dijiste que le echáramos todo el frasco.", "MATEO: Por eso. Menos mal no me hiciste caso."},
  {"CLARA: La próxima te toca mirar mientras jugamos nosotros.", "SAM: Listo, pero yo hago la barra.", "CRISTIAN: Y sin decirnos cuándo saltar cada dos segundos."},
  {"SAM: ¿Y si dejo el celular en la sala mientras comemos?", "PAPÁ: Me parece justo. Yo también dejo el mío.", "MAMÁ: Trato hecho. Esto es un acuerdo de todos."},
  {"MATEO: Gracias por preguntar antes de subir la foto.", "SAM: Mejor que cada uno decida cómo quiere aparecer.", "MATEO: Entonces repitamos esa. En esta salí con los ojos cerrados."},
  {"CLARA: ¿Otra máquina o algo de comer?", "SAM: Algo de comer. Esta vez invito yo a conversar.", "MATEO: Perfecto. Cristian lleva media hora hablando de papas."},
  {"MATEO: Mañana podemos volver a hablar, si quieres.", "SAM: Sí... hoy no supe escuchar muy bien.", "MATEO: Aquí seguimos. No tienes que arreglarlo todo en una tarde."},
  {"Un personaje empieza con una idea, un trazo y muchas correcciones.", "Estos dibujos guardan parte del proceso de crear el mundo de Sam.", "Gracias por explorar, equivocarte y volver a intentarlo con nosotros."}
};
String[] recTemas = {"Lavanda", "Cian neón", "Atardecer"};
int[] recTemaLogro = {-1, 3, 9};
String[] recMarcos = {"Sin marco", "Circuito cian", "Récord dorado"};
int[] recMarcoLogro = {-1, 14, 16};

boolean recDisponible(int logro) {
  boolean disponible = logro < 0;
  if (logro >= 0 && logro < totalLogros) disponible = logrosDesbloqueados[logro];
  return disponible;
}

void recAbrir() {
  recSeccion = 0;
  recSeleccion = 0;
  recLinea = 0;
  mostrarResumenPuntos = false;
  if (!recCargado) {
    if (dataFile("menu_juego.png").exists()) recFondoMenu = loadImage("menu_juego.png");
    for (int i = 0; i < REC_TOTAL; i++) {
      try {
        if (dataFile(recArchivos[i]).exists()) recImagen[i] = loadImage(recArchivos[i]);
        if (recImagen[i] != null && recImagen[i].width > 640) recImagen[i].resize(640, 0);
      } catch (Exception error) {
        recImagen[i] = null;
      }
    }
    recCargado = true;
  }
  estadoDestino = RECUERDOS;
  enTransicion = true;
}

void recAplicarTema() {
  COLOR_PRIMARY = color(88, 77, 130);
  COLOR_PRIMARY_DARK = color(53, 46, 82);
  COLOR_ACCENT = color(217, 107, 82);
  if (recTema == 1) {
    COLOR_PRIMARY = color(23, 123, 143);
    COLOR_PRIMARY_DARK = color(17, 66, 87);
    COLOR_ACCENT = color(18, 156, 168);
  }
  if (recTema == 2) {
    COLOR_PRIMARY = color(166, 76, 100);
    COLOR_PRIMARY_DARK = color(96, 39, 67);
    COLOR_ACCENT = color(205, 109, 47);
  }
}

void recGuardarPreferencias() {
  try {
    saveStrings(dataPath("recuerdos_config.txt"), new String[] {str(recTema), str(recMarco)});
  } catch (Exception error) {
    println("No se pudieron guardar los colores y marcos: " + error.getMessage());
  }
}

void recCargarPreferencias() {
  try {
    if (dataFile("recuerdos_config.txt").exists()) {
      String[] datos = loadStrings("recuerdos_config.txt");
      if (contarCadenas(datos) >= 2) {
        int tema = int(datos[0]);
        int marco = int(datos[1]);
        if (tema >= 0 && tema < REC_TEMAS && recDisponible(recTemaLogro[tema])) recTema = tema;
        if (marco >= 0 && marco < REC_MARCOS && recDisponible(recMarcoLogro[marco])) recMarco = marco;
      }
    }
  } catch (Exception error) {
    println("No se pudieron leer los colores y marcos: " + error.getMessage());
  }
  recAplicarTema();
}

void recDibujarMarco(float x, float y, float w, float h) {
  if (recMarco > 0) {
    pushStyle();
    rectMode(CORNER);
    noFill();
    int tono = color(52, 201, 219);
    if (recMarco == 2) tono = color(239, 183, 62);
    stroke(tono);
    strokeWeight(2);
    rect(x + 1, y + 1, w - 2, h - 2, 3);
    noStroke();
    fill(tono);
    for (int i = 0; i < 4; i++) {
      float px = x + 4;
      float py = y + 4;
      if (i % 2 == 1) px = x + w - 10;
      if (i >= 2) py = y + h - 10;
      rect(px, py, 6, 6);
    }
    popStyle();
  }
}

void recDibujarBordeCelular() {
  if (recTema > 0) {
    pushStyle();
    rectMode(CORNER);
    noFill();
    stroke(COLOR_PRIMARY, 190);
    strokeWeight(max(2, 3 * escalaX));
    rect(telefonoX + 3, telefonoY + 3, telefonoAncho - 6, telefonoAlto - 6, telefonoAncho * 0.1f);
    popStyle();
  }
}

void recDibujarFoto(int indice, float x, float y, float w, float h) {
  noStroke();
  fill(241, 225, 191);
  rect(x, y, w, h, 8);
  if (recDisponible(recLogro[indice])) {
    PImage foto = recImagen[indice];
    if (foto != null && foto.width > 0 && foto.height > 0) {
      float tiempo = millis() * 0.001f;
      float fase = indice * 0.83f;
      float escala = min((w - 12 * escalaX) / foto.width, (h - 10 * escalaY) / foto.height);
      escala *= 0.97f + 0.008f * sin(tiempo * 0.65f + fase);
      float dx = sin(tiempo * 0.4f + fase) * 1.5f * escalaX;
      float dy = sin(tiempo * 0.75f + fase) * 2 * escalaY;
      image(foto, x + (w - foto.width * escala) / 2 + dx, y + (h - foto.height * escala) / 2 + dy, foto.width * escala, foto.height * escala);
    } else {
      fill(115, 72, 35);
      textAlign(CENTER, CENTER);
      textSize(16 * escalaX);
      text("Recuerdo desbloqueado\nIlustración por añadir", x + w / 2, y + h / 2);
    }
  } else {
    dibujarIconoCandado(x + w / 2, y + h / 2, 30 * escalaX, color(147, 115, 77));
  }
}

void recDibujarBotonMenu(float x, float y, float w, float h, String etiqueta, boolean elegido) {
  boolean hover = mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  boolean iluminado = elegido || hover;
  fill(iluminado ? color(255, 220, 100) : color(180, 120, 60));
  stroke(100, 50, 20);
  strokeWeight(max(2, 3 * escalaX));
  rect(x, y, w, h, 8);
  noStroke();
  fill(iluminado ? color(255, 232, 130) : color(192, 138, 78));
  rect(x + 4, y + 4, w - 8, h / 2 - 4, 4);
  fill(iluminado ? color(50, 20, 0) : color(255));
  textAlign(CENTER, CENTER);
  textSize(17 * escalaX);
  text(etiqueta, x + w / 2, y + h / 2);
}

void recDibujar() {
  pushStyle();
  rectMode(CORNER);
  imageMode(CORNER);
  background(135, 195, 229);
  if (recFondoMenu != null && recFondoMenu.width > 0) {
    float zoom = 1.03f;
    float dx = sin(millis() * 0.00012f) * width * 0.003f;
    image(recFondoMenu, (width - width * zoom) / 2 + dx, (height - height * zoom) / 2, width * zoom, height * zoom);
  }
  noStroke();
  fill(255, 247, 225, 205);
  rect(0, 0, width, height);
  if (fuenteComic != null) textFont(fuenteComic);
  else {
    if (fontBody != null) textFont(fontBody);
  }
  textAlign(LEFT, CENTER);
  fill(86, 47, 23);
  textSize(34 * escalaX);
  text("RECUERDOS", width * 0.05f, height * 0.075f);
  int desbloqueados = 0;
  for (int i = 0; i < REC_TOTAL; i++) {
    if (recDisponible(recLogro[i])) desbloqueados++;
  }
  fill(111, 81, 51);
  textSize(16 * escalaX);
  text(desbloqueados + " / " + REC_TOTAL + " recuerdos · Tu colección se conserva entre partidas", width * 0.05f, height * 0.13f);
  for (int tab = 0; tab < 2; tab++) {
    recDibujarBotonMenu(width * (0.05f + tab * 0.21f), height * 0.175f, width * 0.19f, height * 0.055f, tab == 0 ? "GALERÍA" : "PERSONALIZACIÓN", recSeccion == tab);
  }
  recDibujarBotonMenu(width * 0.81f, height * 0.175f, width * 0.14f, height * 0.055f, "VOLVER", false);
  if (recSeccion == 0) {
    for (int i = 0; i < REC_TOTAL; i++) {
      float x = width * (0.05f + (i % 3) * 0.18f);
      float y = height * (0.27f + (i / 3) * 0.20f);
      float w = width * 0.165f;
      noStroke();
      fill(255, 245, 220, 245);
      rect(x, y, w, height * 0.185f, 8);
      recDibujarFoto(i, x, y, w, height * 0.145f);
      noFill();
      stroke(recSeleccion == i ? color(213, 144, 38) : color(171, 126, 73));
      strokeWeight(recSeleccion == i ? 3 : 1);
      rect(x, y, w, height * 0.185f, 8);
      fill(recDisponible(recLogro[i]) ? color(82, 48, 25) : color(139, 110, 77));
      textAlign(CENTER, CENTER);
      textSize(13 * escalaX);
      text(recNombres[i], x + w / 2, y + height * 0.165f);
    }
    float x = width * 0.62f;
    float w = width * 0.33f;
    noStroke();
    fill(255, 247, 226, 238);
    rect(x - 12 * escalaX, height * 0.255f, w + 24 * escalaX, height * 0.65f, 10);
    recDibujarFoto(recSeleccion, x, height * 0.27f, w, height * 0.32f);
    textAlign(LEFT, TOP);
    fill(103, 58, 24);
    textSize(23 * escalaX);
    text(recNombres[recSeleccion], x, height * 0.62f, w, height * 0.07f);
    fill(83, 62, 44);
    textSize(18 * escalaX);
    String mensaje = "Desbloquea el logro «" + logros[recLogro[recSeleccion]][1] + "».\n" + logros[recLogro[recSeleccion]][2];
    if (recDisponible(recLogro[recSeleccion])) mensaje = recDialogos[recSeleccion][recLinea];
    text(mensaje, x, height * 0.71f, w, height * 0.18f);
  }
  if (recSeccion == 1) {
    for (int i = 0; i < REC_TEMAS + REC_MARCOS; i++) {
      int opcion = i % 3;
      int logro = recTemaLogro[opcion];
      String nombre = "Celular · " + recTemas[opcion];
      boolean equipado = recTema == opcion;
      if (i >= REC_TEMAS) {
        logro = recMarcoLogro[opcion];
        nombre = "Pixagram · " + recMarcos[opcion];
        equipado = recMarco == opcion;
      }
      float x = width * (0.05f + (i / 3) * 0.46f);
      float y = height * (0.29f + opcion * 0.19f);
      fill(255, 245, 220, 245);
      stroke(recSeleccion == i ? color(213, 144, 38) : color(171, 126, 73));
      strokeWeight(recSeleccion == i ? 3 : 1);
      rect(x, y, width * 0.43f, height * 0.16f, 10);
      fill(recDisponible(logro) ? color(82, 48, 25) : color(139, 110, 77));
      textAlign(LEFT, TOP);
      textSize(22 * escalaX);
      text(nombre, x + 18 * escalaX, y + 14 * escalaY);
      textSize(16 * escalaX);
      fill(111, 81, 51);
      String detalle = "ENTER o clic para equipar";
      if (equipado) detalle = "EQUIPADO";
      if (!recDisponible(logro)) detalle = "Requiere: " + logros[logro][1];
      text(detalle, x + 18 * escalaX, y + height * 0.09f);
      int muestra = color(88, 77, 130);
      if (opcion == 1) muestra = color(23, 123, 143);
      if (opcion == 2) muestra = color(166, 76, 100);
      if (!recDisponible(logro)) muestra = color(65, 69, 85);
      float miniX = x + width * 0.355f;
      float miniY = y + height * 0.035f;
      noStroke();
      fill(muestra);
      rect(miniX, miniY, width * 0.055f, height * 0.08f, 6);
      if (i >= REC_TEMAS) {
        fill(21, 27, 42);
        rect(miniX, miniY, width * 0.055f, height * 0.08f, 3);
        noFill();
        int borde = color(81, 90, 110);
        if (opcion == 1) borde = color(52, 201, 219);
        if (opcion == 2) borde = color(239, 183, 62);
        if (!recDisponible(logro)) borde = color(65, 69, 85);
        stroke(borde);
        strokeWeight(2);
        rect(miniX, miniY, width * 0.055f, height * 0.08f, 3);
      }
    }
    textAlign(CENTER, CENTER);
    fill(COLOR_PRIMARY);
    noStroke();
    rect(width * 0.4f, height * 0.87f, width * 0.2f, height * 0.035f, 6);
    recDibujarMarco(width * 0.4f, height * 0.87f, width * 0.2f, height * 0.035f);
  }
  noStroke();
  fill(255, 247, 226, 220);
  rect(width * 0.12f, height * 0.93f, width * 0.76f, height * 0.055f, 8);
  fill(100, 67, 37);
  textAlign(CENTER, CENTER);
  textSize(15 * escalaX);
  String ayuda = "Flechas: seleccionar · ENTER / clic: leer · TAB: cambiar sección · M / ESC: menú";
  if (recSeccion == 1) ayuda = "Flechas: seleccionar · ENTER / clic: equipar · TAB: galería · M / ESC: menú";
  text(ayuda, width / 2, height * 0.96f);
  popStyle();
}

void recActivarSeleccion() {
  if (recSeccion == 0 && recDisponible(recLogro[recSeleccion])) recLinea = (recLinea + 1) % 3;
  if (recSeccion == 1) {
    int opcion = recSeleccion % 3;
    boolean aplicado = false;
    if (recSeleccion < REC_TEMAS && recDisponible(recTemaLogro[opcion])) {
      recTema = opcion;
      recAplicarTema();
      aplicado = true;
    }
    if (recSeleccion >= REC_TEMAS && recDisponible(recMarcoLogro[opcion])) {
      recMarco = opcion;
      aplicado = true;
    }
    if (aplicado) recGuardarPreferencias();
  }
}

void recClic() {
  if (!enTransicion && alphaTransicion <= 0 && mouseButton == LEFT) {
    if (mouseX >= width * 0.81f && mouseX <= width * 0.95f && mouseY >= height * 0.175f && mouseY <= height * 0.23f) {
      estadoDestino = MENU;
      enTransicion = true;
    }
    for (int tab = 0; tab < 2; tab++) {
      if (mouseX >= width * (0.05f + tab * 0.21f) && mouseX <= width * (0.24f + tab * 0.21f) && mouseY >= height * 0.175f && mouseY <= height * 0.23f) {
        recSeccion = tab;
        recSeleccion = 0;
        recLinea = 0;
      }
    }
    int total = REC_TOTAL;
    if (recSeccion == 1) total = REC_TEMAS + REC_MARCOS;
    for (int i = 0; i < total; i++) {
      float x = width * (0.05f + (i % 3) * 0.18f);
      float y = height * (0.27f + (i / 3) * 0.20f);
      float w = width * 0.165f;
      float h = height * 0.185f;
      if (recSeccion == 1) {
        x = width * (0.05f + (i / 3) * 0.46f);
        y = height * (0.29f + (i % 3) * 0.19f);
        w = width * 0.43f;
        h = height * 0.16f;
      }
      if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
        boolean misma = recSeleccion == i;
        recSeleccion = i;
        if (!misma) recLinea = 0;
        if (recSeccion == 1 || misma) recActivarSeleccion();
      }
    }
    if (recSeccion == 0 && mouseX >= width * 0.62f && mouseY >= height * 0.62f && mouseY <= height * 0.90f) recActivarSeleccion();
  }
}

void recTecla(boolean atras) {
  if (!enTransicion && alphaTransicion <= 0) {
    if (atras) {
      estadoDestino = MENU;
      enTransicion = true;
    }
    if (keyCode == TAB) {
      recSeccion = 1 - recSeccion;
      recSeleccion = 0;
      recLinea = 0;
    }
    int total = REC_TOTAL;
    if (recSeccion == 1) total = REC_TEMAS + REC_MARCOS;
    int salto = 0;
    if (keyCode == RIGHT) salto = 1;
    if (keyCode == LEFT) salto = -1;
    if (keyCode == DOWN) salto = 3;
    if (keyCode == UP) salto = -3;
    if (recSeccion == 1) {
      if (keyCode == RIGHT) salto = 3;
      if (keyCode == LEFT) salto = -3;
      if (keyCode == DOWN) salto = 1;
      if (keyCode == UP) salto = -1;
    }
    if (salto != 0) {
      recSeleccion = (recSeleccion + salto + total) % total;
      recLinea = 0;
    }
    if (key == ENTER || key == RETURN || key == ' ') recActivarSeleccion();
  }
}
