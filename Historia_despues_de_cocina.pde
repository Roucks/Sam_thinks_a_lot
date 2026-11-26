// CONTINUACIÓN DESPUÉS DEL MINIJUEGO DE COCINA.
// Pestaña: Historia_Despues_Cocina.pde. Imágenes en data/.
// Ver LEEME_Continuacion_Cocina.txt para las conexiones.
// Solo funciones, arreglos, variables e instrucciones usadas en el proyecto.

final int HISTORIA_POST_COCINA = 21;
PFont hcFuenteTexto;
PImage hcImagenBuena;
PImage hcImagenMala;
boolean hcImagenesCargadas = false;
int hcDecision = 0;
float hcScrollCelular = 0;
float hcAltoPost = 0;
float hcDecisionY = 0;
float[] hcComentarioY = new float[3];
float[] hcComentarioTextoY = new float[3];
float[] hcBotonY = new float[3];
float[] hcBotonAlto = new float[3];
String[] hcOpcionesBuenas = {
  "1. Invitar al grupo a probarlo otro día",
  "2. Compartir la receta",
  "3. Decir que yo hice todo"
};
String[] hcOpcionesMalas = {
  "1. Contar qué salió mal",
  "2. Pedir consejos para intentarlo otra vez",
  "3. Echarle la culpa a Mateo"
};
boolean hcActiva = false;
boolean hcBuena = false;
boolean hcGrabaron = false;
boolean hcPublicada = false;
boolean hcMeGusta = false;
int hcEtapa = 0; // 0 = cocina, 1 = publicación, 2 = sobremesa
int hcPagina = 0;
String hcTextoPost = "";
String hcTipoPost = "";
String[] hcAutoresComentarios = { "Clara", "Cristian", "Sam" };
String[] hcComentarios = new String[3];
String[] hcHablantesBueno = {
  "NARRADOR",
  "MATEO",
  "SAM",
  "MATEO",
  "SAM",
  "MAMÁ",
  "MATEO",
  "SAM",
  "MAMÁ",
  "NARRADOR",
  "MATEO",
  "SAM"
};
String[] hcPaginasBueno = {
  "Sam apaga la música. Durante un momento, los dos se quedan mirando la olla.",
  "Bueno... huele a comida. Eso ya es algo.",
  "Prueba. Pero sopla, que está caliente.",
  "¡Ah! Sí, sí estaba caliente. Espera... Oye, quedó rico.",
  "¿Sí? A ver... ¡Uy, sí! Guarda un poquito para mi mamá.",
  "¿Un poquito? Con ese olor yo venía por un plato entero.",
  "Sí alcanza. Creo. Sam ya probó como cuatro veces.",
  "¡Estaba revisando la sal!",
  "Ajá. Bueno, señores cocineros, yo pongo los platos. Ustedes despejen la mesa.",
  "Mateo junta las cáscaras mientras Sam pasa un trapo. Entre los dos hacen espacio para servir.",
  "Esto toca repetirlo. Pero la próxima tú picas la cebolla.",
  "Listo. Tú lavas la olla."
};

String[] hcHablantesMalo = {
  "NARRADOR",
  "MATEO",
  "SAM",
  "MATEO",
  "MAMÁ",
  "NARRADOR",
  "MAMÁ",
  "SAM",
  "MATEO",
  "SAM",
  "MAMÁ",
  "MATEO",
  "SAM",
  "NARRADOR"
};
String[] hcPaginasMalo = {
  "Sam apaga la música. Un olor amargo sale de la olla. Mateo se acerca y arruga la nariz.",
  "Dime que eso no es el estofado.",
  "Espera, de pronto solo es abajo... No. Sí se pegó.",
  "¿Y si sacamos lo de encima?",
  "A ver, déjenme mirar. No raspen el fondo.",
  "Mamá revisa la olla y deja la cuchara sobre un plato.",
  "No, mis amores. Esto ya sabe a quemado. ¿Se les olvidó revolver?",
  "Yo pensé que Mateo estaba mirando la olla.",
  "Y yo pensé que tú. Ni siquiera te pregunté.",
  "Bueno... hacemos otra cosa. ¿Hay huevos?",
  "Hay. Yo los preparo mientras ustedes recogen esto. La olla la dejamos en remojo.",
  "Te ayudo con los platos, Sam. No te voy a dejar todo a ti.",
  "Dale. Pero la próxima empezamos con algo que no tenga nombre de rey.",
  "Con la mesa despejada, se sientan a comer huevos con pan. La olla se queda en el fregadero."
};

String[] hcHablantesCierreBueno = {
  "NARRADOR",
  "MATEO",
  "SAM",
  "MATEO",
  "SAM"
};
String[] hcPaginasCierreBueno = {
  "Sam deja el celular junto al plato. Mateo se inclina para ver la pantalla.",
  "Clara ya comentó. ¿Cómo escribe tan rápido?",
  "Y Cristian está pidiendo que le guardemos. Ya casi no queda.",
  "Mándale foto de la olla vacía.",
  "No, después nos toca cocinarle otra. Come antes de que se enfríe."
};

String[] hcHablantesCierreMalo = {
  "NARRADOR",
  "MATEO",
  "SAM",
  "MATEO",
  "SAM"
};
String[] hcPaginasCierreMalo = {
  "Mateo lee los comentarios por encima del hombro de Sam.",
  "Clara dice que a ella también se le quemó uno. Estamos formando equipo.",
  "Sí, pero nadie de este equipo sabe cocinar.",
  "Por eso mismo. Empezamos con un sándwich.",
  "Sin tostar. Por si acaso."
};


boolean hcPuedeContinuar() {
  return !feriaActiva && estadoActual == NIVEL2 && !enTransicion && !enPausa
    && !nv2ReiniciarPartida
    && (nv2SubEstado == NV2_SUB_RESULTADOS || nv2SubEstado == NV2_SUB_DERROTA);
}

void hcIniciar() {
  detenerYReiniciarTodosLosAudiosNv2();
  nv2AutoPlayBot = false;
  nv2TimerAutoAvanceBot = 0;
  nv2ReiniciarPartida = false;
  hcBuena = nv2SubEstado == NV2_SUB_RESULTADOS && nv2PrecisionFinal >= 60.0f;
  hcGrabaron = decisionCocinaTomada == 1;
  hcActiva = true;
  hcEtapa = 0;
  hcPagina = 0;
  hcDecision = 0;
  hcScrollCelular = 0;
  hcReiniciarTexto();
  hcPublicada = false;
  hcMeGusta = false;
}

int hcTotalPaginas() {
  int total = TAM_HC_PAGINAS_MALO + 3;
  if (hcBuena) total = TAM_HC_PAGINAS_BUENO + 3;
  if (hcEtapa == 2) {
    total = TAM_HC_PAGINAS_CIERRE_MALO;
    if (hcBuena) total = TAM_HC_PAGINAS_CIERRE_BUENO;
  }
  return total;
}

String hcHablante() {
  String nombre = "SAM";
  if (hcEtapa == 2) {
    if (hcBuena) nombre = hcHablantesCierreBueno[hcPagina];
    else nombre = hcHablantesCierreMalo[hcPagina];
  } else {
    int limite = TAM_HC_PAGINAS_MALO;
    if (hcBuena) limite = TAM_HC_PAGINAS_BUENO;
    if (hcPagina < limite) {
      if (hcBuena) nombre = hcHablantesBueno[hcPagina];
      else nombre = hcHablantesMalo[hcPagina];
    } else {
      if (hcPagina == limite) nombre = "MATEO";
      if (hcPagina == limite + 2) nombre = "MATEO";
    }
  }
  if (hcEtapa == 2 && hcDecision == 3) {
    nombre = "NARRADOR";
    if (hcPagina == 1 || hcPagina == 3) nombre = "MATEO";
  }
  return nombre;
}

String hcDialogo() {
  String linea = "";
  if (hcEtapa == 2) {
    if (hcBuena) linea = hcPaginasCierreBueno[hcPagina];
    else linea = hcPaginasCierreMalo[hcPagina];
  } else {
    int limite = TAM_HC_PAGINAS_MALO;
    if (hcBuena) limite = TAM_HC_PAGINAS_BUENO;
    if (hcPagina < limite) {
      if (hcBuena) linea = hcPaginasBueno[hcPagina];
      else linea = hcPaginasMalo[hcPagina];
    } else {
      if (hcPagina == limite) {
        if (hcGrabaron) {
          if (hcBuena) linea = "A ver qué quedó grabado... ¡Se oye cuando me quemé! Esa parte no la subas.";
          else linea = "El video quedó hasta cuando dejaste el celular. ¿De verdad vamos a subir esto?";
        } else {
          if (hcBuena) linea = "Oye, tomémosle una foto antes de acabárnoslo. Ahora sí vale la pena sacar el celular.";
          else linea = "¿Le tomamos una foto? Cristian lleva toda la tarde preguntando cómo quedó.";
        }
      }
      if (hcPagina == limite + 1) {
        if (hcGrabaron) {
          if (hcBuena) linea = "Jajaja, listo. Corto esa parte y dejamos cuando servimos. ¿Así sí?";
          else linea = "Podemos dejar un pedacito del principio y contar lo que pasó. Te lo muestro antes de subirlo.";
        } else {
          if (hcBuena) linea = "De una. Solo al plato, que tengo la camiseta llena de tomate.";
          else linea = "Bueno, pero solo la olla. Y ponemos que al final comimos huevos.";
        }
      }
      if (hcPagina == limite + 2) {
        if (hcGrabaron) linea = "A ver... Sí, así está bien. Súbelo y pásame el pan, que no alcanzo.";
        else linea = "Listo, esa quedó bien. Súbela y me etiquetas.";
      }
    }
  }
  if (hcEtapa == 2 && hcDecision == 3) {
    if (hcPagina == 0) linea = "Mateo lee el comentario. Deja el pan en el plato y se queda mirando a Sam.";
    if (hcPagina == 1) {
      if (hcBuena) linea = "¿Cómo que lo hiciste todo tú? Yo también estuve aquí. No pongas eso.";
      else linea = "¿En serio me vas a echar toda la culpa? Los dos dejamos la olla sola, Sam.";
    }
    if (hcPagina == 2) linea = "Sam baja la mirada. Borra su comentario, pero Mateo ya no tiene ganas de seguir bromeando.";
    if (hcPagina == 3) linea = "Me voy. Otro día hablamos.";
    if (hcPagina == 4) linea = "Sam se queda recogiendo la mesa. Esta vez, Mateo no se queda a ayudar.";
  }
  return linea;
}

void hcPrepararPublicacion() {
  hcPublicada = true;
  if (hcGrabaron) {
    hcTipoPost = "Video de la receta";
    if (hcBuena) hcTextoPost = "Nos salió el estofado jajaja. Mateo casi no deja para la foto. @mateo_y_cristian";
    else hcTextoPost = "El video empezó bien. El estofado no tanto. Terminamos comiendo huevos con pan jajaja @mateo_y_cristian";
  } else {
    hcTipoPost = "Foto después de cocinar";
    if (hcBuena) hcTextoPost = "No grabamos nada, pero quedó esta foto antes de acabárnoslo. Primera receta con Mateo :)";
    else hcTextoPost = "La olla después de nuestro primer estofado. La cena fueron huevos con pan. Otro día intentamos otra vez jajaja";
  }
  if (hcBuena) {
    hcComentarios[0] = "Clara: ¿Eso lo hicieron ustedes? A ver cuándo invitan";
    hcComentarios[1] = "Cristian: Guarden un poquito, no sean así";
    hcComentarios[2] = "";
  } else {
    hcComentarios[0] = "Clara: A mí se me quemó uno y la casa olió como dos días jajaja";
    hcComentarios[1] = "Cristian: Yo llevo el pan para la próxima, mejor";
    hcComentarios[2] = "";
  }
}

void hcAvanzar() {
  boolean flujoRetornoActivo = true;

  if (hcEtapa == 1) {
    if (hcDecision == 0) {
      flujoRetornoActivo = false;
    }
    if (flujoRetornoActivo) {

      hcEtapa = 2;
      hcPagina = 0;

    }
  } else {
    if (!dialogoCompletado) {
      charsVisibles = hcDialogo().length();
      dialogoCompletado = true;
      {
        flujoRetornoActivo = false;
      }
    }
    if (flujoRetornoActivo) {

      if (hcPagina + 1 < hcTotalPaginas())
        hcPagina++;
      else {
        if (hcEtapa == 0) {
          hcPrepararPublicacion();
          hcEtapa = 1;
          hcPagina = 0;
        } else {
          hcActiva = false;
          t3EmpezarTransicion();
        }
      }

    }
  }
  if (flujoRetornoActivo) {

    hcReiniciarTexto();

  }
}

// Devuelve la altura ocupada. También se puede mostrar en el Feed existente.
float hcDibujarPublicacion(float x, float y, float ancho) {
  hcDistribuirPublicacion();
  float factor = ancho / 320.0f;
  pushStyle();
  pushMatrix();
  translate(x, y);
  scale(factor);
  rectMode(CORNER);
  imageMode(CORNER);
  noStroke();
  fill(COLOR_CARD);
  rect(0, 0, 320, hcAltoPost, 10);
  hcUsarFuente();
  textAlign(LEFT, TOP);
  if (playerAvatar != null && playerAvatar.width > 0) image(playerAvatar, 12, 12, 32, 32);
  if (fontBold != null) textFont(fontBold);
  fill(COLOR_TEXT_DARK);
  textSize(15);
  text("Sam", 52, 10);
  hcUsarFuente();
  textSize(11.5f);
  fill(COLOR_TEXT_MUTED);
  text("@sam_adventures · Hace un momento", 52, 30);
  hcCargarImagenes();
  PImage foto = hcImagenMala;
  if (hcBuena) foto = hcImagenBuena;
  fill(231, 216, 190);
  rect(12, 58, 296, 166.5f, 5);
  if (foto != null && foto.width > 0) image(foto, 12, 58, 296, 166.5f);
  recDibujarMarco(12, 58, 296, 166.5f);
  textSize(13);
  fill(COLOR_PRIMARY_DARK);
  String gusta = "Me gusta";
  if (hcMeGusta) gusta = "Te gusta";
  dibujarIconoCorazon(20, 241, 5.5f, COLOR_ACCENT);
  text(gusta, 33, 233);
  textSize(13.5f);
  fill(COLOR_TEXT_DARK);
  hcTextoEnLineas(hcTextoPost, 12, 262, 288, 18);
  for (int i = 0; i < 3; i++) {
    if (hcComentarios[i].length() > 0) {
      int separador = hcComentarios[i].indexOf(":");
      String autor = hcComentarios[i].substring(0, separador + 1);
      String comentario = hcComentarios[i].substring(separador + 2);
      if (fontBold != null) textFont(fontBold);
      textSize(13.5f);
      fill(COLOR_PRIMARY_DARK);
      text(autor, 12, hcComentarioY[i]);
      hcUsarFuente();
      textSize(13.5f);
      fill(COLOR_TEXT_DARK);
      hcTextoEnLineas(comentario, 12, hcComentarioTextoY[i], 288, 18);
    }
  }
  if (hcDecision == 0) {
    fill(COLOR_PRIMARY_DARK);
    if (fontBold != null) textFont(fontBold);
    textSize(14);
    text("¿Qué respondes a esta publicación?", 12, hcDecisionY);
    for (int i = 0; i < 3; i++) {
      fill(COLOR_PRIMARY);
      rect(10, hcBotonY[i], 300, hcBotonAlto[i], 7);
      fill(255);
      hcUsarFuente();
      textSize(14);
      String opcion = hcOpcionesMalas[i];
      if (hcBuena) opcion = hcOpcionesBuenas[i];
      hcTextoEnLineas(opcion, 22, hcBotonY[i] + 14, 276, 19);
    }
  } else {
    fill(COLOR_PRIMARY_DARK);
    textSize(13);
    text("Respuesta publicada", 12, hcDecisionY);
  }
  popMatrix();
  popStyle();
  return hcAltoPost * factor;
}

// Conexión 1: al principio de draw().
boolean dibujarHistoriaDespuesCocina() {
  boolean flujoRetornoActivo = true;
  boolean flujoRetornoValor = false;

  if (!hcActiva) {
    flujoRetornoValor = false;
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    escalaX = width / REF_W;
    escalaY = height / REF_H;
    hcCargarImagenes();
    pushStyle();
    imageMode(CORNER);
    rectMode(CORNER);
    PImage fondo = hcImagenMala;
    if (hcBuena)
      fondo = hcImagenBuena;
    if (fondo != null && fondo.width > 0)
      image(fondo, 0, 0, width, height);
    else {
      if (imgFondoCocina != null && imgFondoCocina.width > 0)
        image(imgFondoCocina, 0, 0, width, height);
      else
        dibujarFondoCocinaProcedimental();
    }
    // Misma fuente, etiqueta y caja de la novela visual anterior.
    if (fuenteComic != null)
      textFont(fuenteComic);
    fill(0, 185);
    stroke(255, 210, 90);
    strokeWeight(1.8f * escalaX);
    rect(24 * escalaX, 18 * escalaY, 355 * escalaX, 38 * escalaY, 10 * escalaX);
    fill(255, 225, 110);
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(14.5f * escalaX);
    text("Cocina de Sam", 201.5f * escalaX, 37 * escalaY);
    fill(0, 185);
    stroke(255, 215, 70);
    rect(width - 245 * escalaX, 18 * escalaY, 220 * escalaX, 38 * escalaY, 10 * escalaX);
    dibujarIconoEstrella(width - 218 * escalaX, 37 * escalaY, 7.5f * escalaX, color(255, 230, 85));
    noStroke();
    fill(255, 230, 85);
    text("Puntos: " + puntosJugador + " pts", width - 125 * escalaX, 37 * escalaY);
    if (hcEtapa == 1)
      hcDibujarCelular();
    else
      hcDibujarDialogo();
    popStyle();
    if (enPausa && estadoPermitePausaGlobal()) {
      dibujarMenuPausaGlobal();
      if (mostrarOpciones) {
        dibujarPanelOpcionesGlobal();
      }
    }
    actualizarYDibujarPopupsYParticulas();
    dibujarAvisoLogro();
    {
      flujoRetornoValor = true;
      flujoRetornoActivo = false;
    }

  }

  return flujoRetornoValor;
}

// Conexión 2: al principio de mousePressed().
boolean clicHistoriaDespuesCocina() {
  boolean flujoRetornoActivo = true;
  boolean flujoRetornoValor = false;

  if (hcActiva) {
    if (hcEtapa == 1) {
      hcMedidasCelular();
      hcDistribuirPublicacion();
      float x = (mouseX - pantallaX) * 320.0f / pantallaW;
      float y = (mouseY - pantallaY) * 500.0f / pantallaH;
      if (x >= 0 && x <= 320) {
        if (y >= 32 && y <= 454) {
          float postY = y - 32 + hcScrollCelular;
          if (x >= 12 && x <= 160 && postY >= 230 && postY <= 254)
            hcMeGusta = !hcMeGusta;
          if (hcDecision == 0 && x >= 10 && x <= 310) {
            for (int i = 0; i < 3; i++) {
              if (postY >= hcBotonY[i] && postY <= hcBotonY[i] + hcBotonAlto[i])
                hcElegirDecision(i + 1);
            }
          }
        }
        if (x >= 8 && x <= 312 && y >= 464 && y <= 492) {
          if (hcDecision == 0)
            hcMostrarRespuestas();
          else
            hcAvanzar();
        }
      }
    } else
      hcAvanzar();
    {
      flujoRetornoValor = true;
      flujoRetornoActivo = false;
    }
  }
  if (flujoRetornoActivo) {

    if (hcPuedeContinuar()) {
      hcIniciar();
      {
        flujoRetornoValor = true;
        flujoRetornoActivo = false;
      }
    }
    if (flujoRetornoActivo) {

      {
        flujoRetornoValor = false;
        flujoRetornoActivo = false;
      }

    }

  }

  return flujoRetornoValor;
}

// Conexión 3: al principio de keyPressed().
boolean teclaHistoriaDespuesCocina() {
  boolean flujoRetornoActivo = true;
  boolean flujoRetornoValor = false;

  if (hcProcesarAtajoDebug(key, keyCode)) {
    flujoRetornoValor = true;
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    if (hcActiva) {
      if (key == ESC)
        key = 0;
      if (hcEtapa == 1 && keyCode == DOWN)
        hcDesplazar(60);
      if (hcEtapa == 1 && keyCode == UP)
        hcDesplazar(-60);
      if (hcEtapa == 1 && key >= '1' && key <= '3')
        hcElegirDecision(key - '0');
      if (keyCode == ENTER || key == RETURN || key == ' ') {
        if (hcEtapa == 1 && hcDecision == 0)
          hcMostrarRespuestas();
        else
          hcAvanzar();
      }
      {
        flujoRetornoValor = true;
        flujoRetornoActivo = false;
      }
    }
    if (flujoRetornoActivo) {

      if (hcPuedeContinuar()) {
        hcIniciar();
        {
          flujoRetornoValor = true;
          flujoRetornoActivo = false;
        }
      }
      if (flujoRetornoActivo) {

        {
          flujoRetornoValor = false;
          flujoRetornoActivo = false;
        }

      }

    }

  }

  return flujoRetornoValor;
}

// Conexión 4: dibujarFeedPixagram(), justo después de float curY = 8;.
// Esta tarjeta se conserva en memoria hasta salir del programa o iniciar otra receta.
float dibujarPostCocinaEnFeed(float curY) {
  if (hcPublicada) {
    curY += hcDibujarPublicacion(10, curY, pantallaW - 20) + 14;
  }
  return curY;
}

// Captura los clics dentro de la tarjeta nueva para que no activen posts de abajo.
boolean clicPostCocinaEnFeed(float x, float y, float inicioY) {
  boolean flujoRetornoActivo = true;
  boolean flujoRetornoValor = false;

  hcDistribuirPublicacion();
  if (hcPublicada) {
    float factor = (pantallaW - 20) / 320.0f;
    if (x >= 10 && x <= pantallaW - 10 && y >= inicioY && y <= inicioY + hcAltoPost * factor) {
      float localX = (x - 10) / factor;
      float localY = (y - inicioY) / factor;
      if (localX >= 12 && localX <= 160 && localY >= 230 && localY <= 254)
        hcMeGusta = !hcMeGusta;
      {
        flujoRetornoValor = true;
        flujoRetornoActivo = false;
      }
    }
  }
  if (flujoRetornoActivo) {

    {
      flujoRetornoValor = false;
      flujoRetornoActivo = false;
    }

  }

  return flujoRetornoValor;
}

float alturaPostCocinaEnFeed() {
  hcDistribuirPublicacion();
  float altura = 0;
  if (hcPublicada) altura = hcAltoPost * ((pantallaW - 20) / 320.0f) + 14;
  return altura;
}

void reiniciarHistoriaDespuesCocina() {
  hcActiva = false;
  hcPublicada = false;
  hcMeGusta = false;
  hcPagina = 0;
  hcEtapa = 0;
  hcDecision = 0;
  hcScrollCelular = 0;
  hcReiniciarTexto();
}

// La historia entra aquí al terminar cualquier resultado del minijuego.
boolean hcContinuarAlTerminar() {
  if (!hcActiva && hcPuedeContinuar()) hcIniciar();
  return dibujarHistoriaDespuesCocina();
}

void hcUsarFuente() {
  if (fuenteCelular != null) textFont(fuenteCelular);
  else { if (fontBody != null) textFont(fontBody); }
}

// Dibuja líneas completas, con separación fija y sin depender de cajas que recortan texto.
void hcTextoEnLineas(String contenido, float x, float y, float ancho, float salto) {
  String[] palabras = split(contenido, ' ');
  String linea = "";
  float lineaY = y;
  for (int i = 0; i < contarCadenas(palabras); i++) {
    String candidata = palabras[i];
    if (linea.length() > 0) candidata = linea + " " + palabras[i];
    if (textWidth(candidata) > ancho && linea.length() > 0) {
      text(linea, x, lineaY);
      lineaY += salto;
      linea = palabras[i];
    } else {
      linea = candidata;
    }
  }
  if (linea.length() > 0) text(linea, x, lineaY);
}

boolean hcProcesarAtajoDebug(char k, int codigo) {
  boolean flujoRetornoActivo = true;
  boolean flujoRetornoValor = false;

  if (hcActiva && codigo == 114) {
    modoDebug = !modoDebug;
    {
      flujoRetornoValor = true;
      flujoRetornoActivo = false;
    }
  }
  if (flujoRetornoActivo) {

    if (modoDebug && estadoActual != CARGA) {
      if (k == 'U') {
        abrirFinalNivel3Debug(true);
        {
          flujoRetornoValor = true;
          flujoRetornoActivo = false;
        }
      }
      if (flujoRetornoActivo) {

        if (k == 'I') {
          abrirFinalNivel3Debug(false);
          {
            flujoRetornoValor = true;
            flujoRetornoActivo = false;
          }
        }
        if (flujoRetornoActivo) {

          if (k == 'H') {
            hcSaltarDebug(true);
            {
              flujoRetornoValor = true;
              flujoRetornoActivo = false;
            }
          }
          if (flujoRetornoActivo) {

            if (k == 'J') {
              hcSaltarDebug(false);
              {
                flujoRetornoValor = true;
                flujoRetornoActivo = false;
              }
            }

          }

        }

      }
    }
    if (flujoRetornoActivo) {

      {
        flujoRetornoValor = false;
        flujoRetornoActivo = false;
      }

    }

  }

  return flujoRetornoValor;
}

void hcSaltarDebug(boolean finalBueno) {
  detenerMediosParaSaltoDebug();
  reiniciarHistoriaDespuesCocina();
  nv2ReiniciarPartida = false;
  nv2AutoPlayBot = false;
  estadoActual = NIVEL2;
  estadoDestino = NIVEL2;
  enTransicion = false;
  alphaTransicion = 0;
  // Mantiene la decisión de grabar si ya existía. Por defecto prueba con video.
  if (decisionCocinaTomada == 0) decisionCocinaTomada = 1;
  if (finalBueno) {
    nv2SubEstado = NV2_SUB_RESULTADOS;
    nv2PrecisionFinal = 85.0f;
  } else {
    nv2SubEstado = NV2_SUB_DERROTA;
    nv2PrecisionFinal = 0.0f;
  }
  hcIniciar();
}

void hcCargarImagenes() {
  if (!hcImagenesCargadas) {
    hcImagenesCargadas = true;
    hcImagenBuena = loadImage("comida_cocina_buena.png");
    hcImagenMala = loadImage("comida_cocina_mala.png");
  }
}

void hcReiniciarTexto() {
  ultimoTextoDialogo = "";
  charsVisibles = 0;
  dialogoCompletado = false;
}

void hcDibujarDialogo() {
  String hablante = hcHablante() + ":";
  String texto = hcDialogo();
  float cajaAncho = width * 0.86f;
  float cajaAlto = height * 0.25f;
  float cajaX = (width - cajaAncho) / 2;
  float cajaY = height - cajaAlto - 34 * escalaY;
  fill(0, 210);
  noStroke();
  rectMode(CORNER);
  rect(cajaX, cajaY, cajaAncho, cajaAlto, 16 * escalaX);
  if (!texto.equals(ultimoTextoDialogo)) {
    ultimoTextoDialogo = texto;
    charsVisibles = 0;
    dialogoCompletado = false;
  }
  if (!dialogoCompletado && !enPausa) {
    charsVisibles = min(texto.length(), charsVisibles + velTypewriter);
    if (int(charsVisibles) >= texto.length()) dialogoCompletado = true;
  }
  String parcial = texto.substring(0, int(charsVisibles));
  fill(210, 215, 230);
  if (hablante.indexOf("SAM") >= 0) fill(100, 210, 255);
  if (hablante.indexOf("MATEO") >= 0) fill(255, 175, 75);
  if (hablante.indexOf("MAMÁ") >= 0) fill(255, 160, 195);
  textAlign(LEFT, TOP);
  textSize(22 * escalaX);
  text(hablante, cajaX + 36 * escalaX, cajaY + 22 * escalaY);
  fill(255);
  textSize(23 * escalaX);
  text(parcial, cajaX + 36 * escalaX, cajaY + 58 * escalaY,
    cajaAncho - 72 * escalaX, cajaAlto - 90 * escalaY);
  fill(175, 195, 225);
  textSize(14 * escalaX);
  textAlign(RIGHT, BOTTOM);
  String pie = "Haz clic o presiona [ENTER] para continuar";
  if (hcEtapa == 0 && hcPagina + 1 == hcTotalPaginas()) pie = "Haz clic o presiona [ENTER] para abrir Pixagram";
  if (hcEtapa == 2 && hcPagina + 1 == hcTotalPaginas()) pie = "Haz clic o presiona [ENTER] para finalizar";
  text(pie + " (" + (hcPagina + 1) + "/" + hcTotalPaginas() + ")",
    cajaX + cajaAncho - 28 * escalaX, cajaY + cajaAlto - 14 * escalaY);
}

void hcMedidasCelular() {
  telefonoAlto = min(980, height * 0.98f);
  telefonoAncho = telefonoAlto * (888.0f / 1600.0f);
  telefonoX = (width - telefonoAncho) / 2;
  telefonoY = (height - telefonoAlto) / 2;
  pantallaW = telefonoAncho * (660.0f / 888.0f);
  pantallaH = telefonoAlto * (1020.0f / 1600.0f);
  pantallaX = telefonoX + telefonoAncho * (114.0f / 888.0f);
  pantallaY = telefonoY + telefonoAlto * (294.0f / 1600.0f);
}

void hcDibujarCelular() {
  hcMedidasCelular();
  hcDistribuirPublicacion();
  hcScrollCelular = constrain(hcScrollCelular, 0, hcMaxScroll());
  fill(0, 160);
  noStroke();
  rect(0, 0, width, height);
  // Una sola publicación desplazable: foto, comentarios y decisiones juntos.
  clip(pantallaX, pantallaY + pantallaH * (32.0f / 500.0f), pantallaW, pantallaH * (422.0f / 500.0f));
  pushMatrix();
  translate(pantallaX, pantallaY);
  scale(pantallaW / 320.0f, pantallaH / 500.0f);
  fill(COLOR_APP_BG);
  rect(0, 32, 320, 422);
  hcDibujarPublicacion(0, 32 - hcScrollCelular, 320);
  if (hcMaxScroll() > 0) {
    noStroke();
    fill(190, 183, 196);
    rect(315, 36, 3, 410, 2);
    fill(COLOR_PRIMARY);
    float largoBarra = max(36, 410 * 422 / hcAltoPost);
    float barraY = 36 + (410 - largoBarra) * hcScrollCelular / hcMaxScroll();
    rect(315, barraY, 3, largoBarra, 2);
  }
  popMatrix();
  noClip();
  pushMatrix();
  translate(pantallaX, pantallaY);
  scale(pantallaW / 320.0f, pantallaH / 500.0f);
  noStroke();
  fill(COLOR_APP_BG);
  rect(0, 0, 320, 32);
  rect(0, 454, 320, 46);
  hcUsarFuente();
  fill(COLOR_PRIMARY_DARK);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("Pixagram", 160, 16);
  // Sin logo de Pixagram. El marco ilustrado original se conserva.
  fill(COLOR_PRIMARY);
  rect(8, 464, 304, 28, 5);
  fill(255);
  textSize(12.5f);
  String boton = "GUARDAR CELULAR [ENTER]";
  if (hcDecision == 0) boton = "IR A LAS RESPUESTAS [ENTER]";
  text(boton, 160, 478);
  popMatrix();
  imageMode(CORNER);
  if (marcoCelular != null && marcoCelular.width > 0) image(marcoCelular, telefonoX, telefonoY, telefonoAncho, telefonoAlto);
  else {
    noFill();
    stroke(15);
    strokeWeight(6);
    rect(telefonoX, telefonoY, telefonoAncho, telefonoAlto, 16);
  }
}

void hcElegirDecision(int opcion) {
  boolean flujoRetornoActivo = true;

  if (hcEtapa != 1 || hcDecision != 0 || opcion < 1 || opcion > 3) {
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    hcDecision = opcion;
    int premio = 0;
    if (opcion == 1) {
      premio = 30;
      if (hcBuena)
        hcComentarios[2] = "Sam: Otro día hacemos más y vienen :)";
      else
        hcComentarios[2] = "Sam: Se nos olvidó revolver. La próxima nos turnamos.";
    }
    if (opcion == 2) {
      premio = 20;
      if (hcBuena)
        hcComentarios[2] = "Sam: Ya les paso la receta. La hicimos entre los dos.";
      else
        hcComentarios[2] = "Sam: ¿Algún truco para que no se pegue? Queremos repetir.";
    }
    if (opcion == 3) {
      if (hcBuena)
        hcComentarios[2] = "Sam: Todo lo hice yo, Mateo solo vino a comer jajaja";
      else
        hcComentarios[2] = "Sam: Fue Mateo, se suponía que él miraba la olla.";
      modificarReputacion(-25, width / 2 - 150 * escalaX, 100 * escalaY);
      modificarBienestar(-20, width / 2 + 150 * escalaX, 100 * escalaY);
      ganarPuntosConPopup(-30, 3, "-30 PTS", width / 2, 145 * escalaY, color(255, 90, 90));
    }
    if (premio > 0)
      ganarPuntosConPopup(premio, 3, "+" + premio + " PTS", width / 2, 110 * escalaY, color(100, 255, 145));
    if (sonidoClic != null) {
      sonidoClic.amp(0.4f * volMaster);
      sonidoClic.play();
    }

  }
}

int hcContarLineas(String contenido, float ancho) {
  String[] palabras = split(contenido, ' ');
  String linea = "";
  int lineas = 1;
  for (int i = 0; i < contarCadenas(palabras); i++) {
    String candidata = palabras[i];
    if (linea.length() > 0) candidata = linea + " " + palabras[i];
    if (textWidth(candidata) > ancho && linea.length() > 0) {
      lineas++;
      linea = palabras[i];
    } else linea = candidata;
  }
  return lineas;
}

void hcDistribuirPublicacion() {
  pushStyle();
  hcUsarFuente();
  textSize(13.5f);
  float y = 262 + hcContarLineas(hcTextoPost, 288) * 18 + 20;
  for (int i = 0; i < 3; i++) {
    hcComentarioY[i] = y;
    hcComentarioTextoY[i] = y + 20;
    if (hcComentarios[i] != null && hcComentarios[i].length() > 0) {
      int separador = hcComentarios[i].indexOf(":");
      String comentario = hcComentarios[i].substring(separador + 2);
      y += 20 + hcContarLineas(comentario, 288) * 18 + 20;
    }
  }
  hcDecisionY = y;
  y += 32;
  if (hcDecision == 0) {
    textSize(14);
    for (int i = 0; i < 3; i++) {
      String opcion = hcOpcionesMalas[i];
      if (hcBuena) opcion = hcOpcionesBuenas[i];
      hcBotonY[i] = y;
      hcBotonAlto[i] = max(62, hcContarLineas(opcion, 276) * 19 + 28);
      y += hcBotonAlto[i] + 10;
    }
  }
  hcAltoPost = y + 14;
  popStyle();
}

float hcMaxScroll() {
  return max(0, hcAltoPost - 422);
}

void hcMostrarRespuestas() {
  hcDistribuirPublicacion();
  hcScrollCelular = constrain(hcDecisionY - 18, 0, hcMaxScroll());
}

void hcDesplazar(float cantidad) {
  hcDistribuirPublicacion();
  hcScrollCelular = constrain(hcScrollCelular + cantidad, 0, hcMaxScroll());
}

boolean ruedaHistoriaDespuesCocina(float cantidad) {
  boolean flujoRetornoActivo = true;
  boolean flujoRetornoValor = false;

  if (hcActiva && hcEtapa == 1) {
    if (mouseX >= pantallaX && mouseX <= pantallaX + pantallaW && mouseY >= pantallaY && mouseY <= pantallaY + pantallaH)
      hcDesplazar(cantidad * 36);
    {
      flujoRetornoValor = true;
      flujoRetornoActivo = false;
    }
  }
  if (flujoRetornoActivo) {

    {
      flujoRetornoValor = false;
      flujoRetornoActivo = false;
    }

  }

  return flujoRetornoValor;
}
