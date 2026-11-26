// =========================================================================
// PESTAÑA 2: PIXAGRAM INTERACTIVO, TRANSICIÓN TEMPORAL, NOVELA DE COCINA Y DIFICULTAD NV2
// (Arquitectura modular con arreglos paralelos de tamaño fijo - AyP 2)
// =========================================================================

// Cargar las seis imágenes de la comunidad desde la carpeta data.
boolean pixaImagenesComunidadCargadas = false;

void cargarFotosComunidadPixagram() {
  if (!pixaImagenesComunidadCargadas) {
    String[] archivos = {"post_clara.png", "post_leo.png", "post_michi.png", "post_sofia.png", "post_mateo.png", "post_profe.png"};
    for (int i = 0; i < TAM_PIXA_FOTOS_POSTS && i < contarCadenas(archivos); i++) {
      pixaFotosPosts[i] = null;
      try {
        if (dataFile(archivos[i]).exists()) pixaFotosPosts[i] = loadImage(archivos[i]);
        if (pixaFotosPosts[i] != null && pixaFotosPosts[i].width > 640) pixaFotosPosts[i].resize(640, 0);
      } catch (Exception error) {
        pixaFotosPosts[i] = null;
      }
    }
    pixaImagenesComunidadCargadas = true;
  }
}

void prepararPostPixagramPenaltis() {
  totalFeedPosts = 1;
  postIds[0] = 1;
  postAuthorName[0] = "Mateo y Cristian";
  postAuthorHandle[0] = "@mateo_y_cristian";
  postAvatarPath[0] = "mateo_cancha.jpg";
  postAvatarImg[0] = imgMateoCancha;
  postTimeAgo[0] = "Hace 1 min";
  postIsLiked[0] = false;
  postIsSaved[0] = false;
  postCategoryTag[0] = "Deportes";
  decisionPixagramTomada = false;
  decisionPixagramPenaltis = 0;

  if (goles >= 3) {
    postCaption[0] = "Sam nos ganó " + goles + " a " + (5 - goles) + " en los penaltis jajaja. Buena esa, crack #futbol #recreo";
    postImagePath[0] = "post_penaltis_gana.png";
    postImg[0] = imgPostGana;
    postLikes[0] = 34;
    postCommentCount[0] = 2;
    postCommentAuthor[0][0] = "Leo";
    postCommentText[0][0] = "Uy, qué golazos, Sam. Mañana quiero revancha.";
    postCommentAuthor[0][1] = "Clara";
    postCommentText[0][1] = "¿Y ahora cuál es la excusa, Cristian?";
  } else {
    // Texto adolescente natural solicitado por el usuario
    postCaption[0] = "Jajaja miren cómo quedó este man después de comerse el piso en la cancha @mateo_vlogs";
    postImagePath[0] = "post_penaltis_pierde.png";
    postImg[0] = imgPostPierde;
    postLikes[0] = 41;
    postCommentCount[0] = 2;
    postCommentAuthor[0][0] = "Sofía";
    postCommentText[0][0] = "Oigan, no sean así. Ni cuenta se dio de que le tomaron la foto.";
    postCommentAuthor[0][1] = "Clara";
    postCommentText[0][1] = "Qué boleta subir eso sin preguntarle. Bájenla.";
  }
}

void dibujarInicioPixagram() {
  cargarFotosComunidadPixagram();
  textFont(fontTitle);
  textSize(17);
  fill(COLOR_TEXT_DARK);
  textAlign(LEFT, TOP);
  text("Tu Resumen Digital", 12, 6);

  // Tarjeta del jugador más amplia para que todo respire mejor
  fill(COLOR_CARD);
  stroke(COLOR_BORDER);
  strokeWeight(1);
  rect(12, 28, pantallaW - 24, 68, 8);

  if (playerAvatar != null && playerAvatar.width > 0) {
    image(playerAvatar, 20, 38, 46, 46);
  } else {
    fill(#DDD8CD);
    ellipse(43, 61, 46, 46);
  }

  textFont(fontBold);
  textSize(15);
  fill(COLOR_TEXT_DARK);
  textAlign(LEFT, TOP);
  text(playerName + " (" + playerHandle + ")", 74, 34);

  dibujarIconoCorazon(79, 58, 5.0f, color(55, 145, 85));
  dibujarIconoEstrella(187, 58, 5.5f, color(195, 140, 20));
  textFont(fontBody);
  textSize(12);
  fill(color(55, 145, 85));
  text("Bienestar: " + round(bienestarDigital) + "%", 88, 52);
  fill(color(155, 110, 20));
  text("Reputación: " + reputacionDigital, 197, 52);

  dibujarIconoEstrella(79, 76, 5.2f, COLOR_PRIMARY);
  fill(COLOR_PRIMARY);
  textFont(fontBold);
  textSize(13);
  text("Puntos disponibles: " + puntosJugador + " pts", 88, 70);

  // Botón directo al Feed
  fill(COLOR_PRIMARY);
  noStroke();
  rect(12, 104, pantallaW - 24, 34, 7);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(14);
  if (penaltisJugados && !decisionPixagramTomada) {
    dibujarIconoAlerta(26, 121, 6.0f, color(255, 220, 70));
    text("Responder el post de penaltis", pantallaW / 2 + 6, 121);
  } else {
    text("Explorar el Feed", pantallaW / 2, 121);
  }

  // Perfiles destacados de la comunidad (más grandes aprovechando el espacio inferior)
  textFont(fontBold);
  textSize(14);
  fill(COLOR_TEXT_DARK);
  textAlign(LEFT, TOP);
  text("Perfiles de la comunidad", 12, 146);

  for (int i = 0; i < totalPixaPosts; i++) {
    int col = i % 2;
    int fila = i / 2;
    float cx = 12 + col * ((pantallaW - 30) / 2.0f + 6);
    float cy = 170 + fila * 52;
    float cw = (pantallaW - 30) / 2.0f;
    float ch = 46;

    fill(COLOR_CARD);
    stroke(pixaLikeDado[i] ? COLOR_ACCENT : COLOR_BORDER);
    strokeWeight(1);
    rect(cx, cy, cw, ch, 6);

    textFont(fontBold);
    textSize(13);
    fill(COLOR_PRIMARY_DARK);
    textAlign(LEFT, TOP);
    text(pixaUsuarios[i], cx + 8, cy + 5);

    textFont(fontBody);
    textSize(12);
    fill(COLOR_TEXT_MUTED);
    text(pixaCategorias[i], cx + 8, cy + 23);

  }
}
final float PIXA_FEED_CUERPO = 15;
final float PIXA_FEED_INTERLINEA = 19;
final float PIXA_PEN_IMAGEN_Y = 54;
final float PIXA_PEN_IMAGEN_H = 135;
final float PIXA_PEN_LIKE_Y = PIXA_PEN_IMAGEN_Y + PIXA_PEN_IMAGEN_H + 8;
final float PIXA_PEN_TEXTO_Y = PIXA_PEN_LIKE_Y + 25;
final float PIXA_COMUNIDAD_TEXTO_Y = 155;
final float PIXA_ACCION_H = 34;
final float PIXA_DECISION_BOTONES_Y = 34;
final float PIXA_DECISION_BOTON_H = 44;
final float PIXA_DECISION_PASO = 51;
final float PIXA_DECISION_PANEL_H = 190;

float pixaAnchoTextoAnterior = -1;
PFont pixaFuenteTextoAnterior;
String pixaPieAnterior;
StringList pixaLineasPie;
String[] pixaComentariosAnteriores = new String[MAX_COMMENTS_POR_POST];
StringList[] pixaLineasComentarios = new StringList[MAX_COMMENTS_POR_POST];
String[] pixaDescripcionesAnteriores = new String[TAM_PIXA_FOTOS_POSTS];
StringList[] pixaLineasDescripciones = new StringList[TAM_PIXA_FOTOS_POSTS];

StringList medirLineasPixagram(String contenido) {
  pushStyle();
  textFont(fontBody);
  textSize(PIXA_FEED_CUERPO);
  StringList lineas = new StringList();
  String linea = "";
  float ancho = pantallaW - 36;
  for (String palabra : split(contenido, ' ')) {
    String candidata = linea.isEmpty() ? palabra : linea + " " + palabra;
    if (!linea.isEmpty() && textWidth(candidata) > ancho) {
      lineas.append(linea);
      linea = palabra;
    } else {
      linea = candidata;
    }
  }
  lineas.append(linea);
  popStyle();
  return lineas;
}

void actualizarTextoPixagram() {
  if (pixaAnchoTextoAnterior != pantallaW || pixaFuenteTextoAnterior != fontBody) {
    pixaAnchoTextoAnterior = pantallaW;
    pixaFuenteTextoAnterior = fontBody;
    pixaPieAnterior = null;
    for (int c = 0; c < MAX_COMMENTS_POR_POST; c++) pixaComentariosAnteriores[c] = null;
    for (int i = 0; i < TAM_PIXA_FOTOS_POSTS; i++) pixaDescripcionesAnteriores[i] = null;
  }
  if (totalFeedPosts > 0) {
    if (pixaPieAnterior != postCaption[0]) {
      pixaPieAnterior = postCaption[0];
      pixaLineasPie = medirLineasPixagram(pixaPieAnterior);
    }
    for (int c = 0; c < postCommentCount[0]; c++) {
      String comentario = postCommentText[0][c];
      if (pixaComentariosAnteriores[c] != comentario) {
        pixaComentariosAnteriores[c] = comentario;
        pixaLineasComentarios[c] = medirLineasPixagram(comentario);
      }
    }
  }
  for (int i = 0; i < totalPixaPosts; i++) {
    if (pixaDescripcionesAnteriores[i] != pixaDescripciones[i]) {
      pixaDescripcionesAnteriores[i] = pixaDescripciones[i];
      pixaLineasDescripciones[i] = medirLineasPixagram(pixaDescripciones[i]);
    }
  }
}

void dibujarLineasPixagram(StringList lineas, float x, float y) {
  for (int i = 0; i < lineas.size(); i++) {
    String linea = lineas.get(i);
    if (!linea.isEmpty()) text(linea, x, y);
    y += PIXA_FEED_INTERLINEA;
  }
}

float posicionComentariosPixagram(float y) {
  return y + PIXA_PEN_TEXTO_Y + pixaLineasPie.size() * PIXA_FEED_INTERLINEA + 12;
}

float posicionDecisionPixagram(float y) {
  float posicion = posicionComentariosPixagram(y);
  for (int c = 0; c < postCommentCount[0]; c++) {
    posicion += 20 + pixaLineasComentarios[c].size() * PIXA_FEED_INTERLINEA + 6;
  }
  return posicion + 6;
}

float altoPostPenaltisPixagram(float y) {
  return posicionDecisionPixagram(y) - y + (decisionPixagramTomada ? 48 : PIXA_DECISION_PANEL_H + 12);
}

float posicionAccionesComunidadPixagram(float y, int perfil) {
  return y + PIXA_COMUNIDAD_TEXTO_Y + pixaLineasDescripciones[perfil].size() * PIXA_FEED_INTERLINEA + 12;
}

boolean bloqueVisiblePixagram(float y, float h, float arriba, float abajo) {
  return y + h + 4 >= arriba && y - 4 <= abajo;
}

void dibujarFeedPixagram(float contentH) {
  cargarFotosComunidadPixagram();
  actualizarTextoPixagram();
  float vistaArriba = -scrollYFeed;
  float vistaAbajo = vistaArriba + contentH;
  float curY = 8;

  // --- BLOQUE 1: PUBLICACIÓN DE PENALTIS Y DECISIÓN OBLIGATORIA ---
  if (totalFeedPosts > 0) {
    boolean esDerrota = (goles < 3);
    float postBoxH = altoPostPenaltisPixagram(curY);

    if (bloqueVisiblePixagram(curY, postBoxH, vistaArriba, vistaAbajo)) {
      fill(COLOR_CARD);
      stroke(esDerrota && !decisionPixagramTomada ? color(225, 80, 65) : COLOR_BORDER);
      strokeWeight(esDerrota && !decisionPixagramTomada ? 2 : 1);
      rect(10, curY, pantallaW - 20, postBoxH, 10);

      // Cabecera del autor
      if (postAvatarImg[0] != null && postAvatarImg[0].width > 0) {
        image(postAvatarImg[0], 18, curY + 8, 30, 30);
      } else {
        fill(#DDD8CD);
        ellipse(33, curY + 23, 30, 30);
      }

      textFont(fontBold);
      textSize(16);
      fill(COLOR_TEXT_DARK);
      textAlign(LEFT, TOP);
      text(postAuthorName[0], 54, curY + 8);
      textFont(fontBody);
      textSize(12);
      fill(COLOR_TEXT_MUTED);
      text(postAuthorHandle[0] + " • " + postTimeAgo[0], 54, curY + 29);

      // Imagen del post de penaltis
      float imgY = curY + PIXA_PEN_IMAGEN_Y;
      float imgW = pantallaW - 36;
      float imgH = PIXA_PEN_IMAGEN_H;
      if (postImg[0] != null && postImg[0].width > 0) {
        image(postImg[0], 18, imgY, imgW, imgH);
      } else {
        fill(esDerrota ? color(95, 45, 45) : color(45, 95, 65));
        rect(18, imgY, imgW, imgH, 6);
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(10.5f);
        text(esDerrota ? "[Foto de caída en la cancha]" : "[Sam y sus amigos celebrando]", 18 + imgW / 2, imgY + imgH / 2);
      }

      recDibujarMarco(18, imgY, imgW, imgH);
      // Botón de Like y contador con corazón vectorial
      float likeY = curY + PIXA_PEN_LIKE_Y;
      int colCorazonPost = postIsLiked[0] ? COLOR_ACCENT : COLOR_TEXT_DARK;
      dibujarIconoCorazon(26, likeY + 7, 5.5f, colCorazonPost);
      textFont(fontBold);
      textSize(15);
      fill(colCorazonPost);
      textAlign(LEFT, TOP);
      text(postLikes[0] + (postIsLiked[0] ? " Te gusta" : " Me gusta"), 38, likeY + 1);

      textFont(fontBody);
      textSize(PIXA_FEED_CUERPO);
      fill(COLOR_TEXT_DARK);
      dibujarLineasPixagram(pixaLineasPie, 18, curY + PIXA_PEN_TEXTO_Y);

      float comY = posicionComentariosPixagram(curY);
      for (int c = 0; c < postCommentCount[0]; c++) {
        textFont(fontBold);
        textSize(14);
        fill(COLOR_PRIMARY_DARK);
        text(postCommentAuthor[0][c] + ":", 18, comY);
        textFont(fontBody);
        textSize(PIXA_FEED_CUERPO);
        fill(COLOR_TEXT_DARK);
        dibujarLineasPixagram(pixaLineasComentarios[c], 18, comY + 20);
        comY += 20 + pixaLineasComentarios[c].size() * PIXA_FEED_INTERLINEA + 6;
      }

      // Panel de Decisión Interactiva Obligatoria Post-Penaltis
      if (!decisionPixagramTomada) {
        float decY = posicionDecisionPixagram(curY);
        fill(esDerrota ? color(255, 238, 234) : color(236, 246, 238));
        stroke(esDerrota ? color(220, 90, 75) : color(75, 165, 95));
        strokeWeight(1.2f);
        rect(16, decY, pantallaW - 32, PIXA_DECISION_PANEL_H, 8);

        textFont(fontBold);
        textSize(14);
        fill(esDerrota ? color(175, 35, 30) : color(35, 115, 55));
        textAlign(CENTER, TOP);
        if (esDerrota) {
          text("¿Qué haces con esta publicación?", pantallaW / 2, decY + 6);
        } else {
          text("¿Qué les respondes?", pantallaW / 2, decY + 6);
        }

        String[] txtBtn = new String[3];
        int[] reqPts = { 40, 15, 0 };
        if (esDerrota) {
          txtBtn[0] = "1. Pedir en los comentarios que borren la foto";
          txtBtn[1] = "2. Escribirles por privado para que la quiten";
          txtBtn[2] = "3. No decir nada y dejar pasar el post";
        } else {
          txtBtn[0] = "1. Agradecerles por el partido";
          txtBtn[1] = "2. Escribirles por privado";
          txtBtn[2] = "3. Presumir que soy el mejor";
        }

        for (int b = 0; b < 3; b++) {
          float by = decY + PIXA_DECISION_BOTONES_Y + b * PIXA_DECISION_PASO;
          boolean ok = (puntosJugador >= reqPts[b]);
          fill(ok ? COLOR_PRIMARY : color(185, 182, 190));
          noStroke();
          rect(20, by, pantallaW - 40, PIXA_DECISION_BOTON_H, 5);

          fill(ok ? 255 : color(75, 72, 82));
          textFont(fontBold);
          textSize(13.5f);
          textLeading(16);
          textAlign(CENTER, CENTER);
          if (ok) {
            text(txtBtn[b], 27, by + 2, pantallaW - 54, PIXA_DECISION_BOTON_H - 4);
          } else {
            int faltan = reqPts[b] - puntosJugador;
            dibujarIconoCandado(30, by + PIXA_DECISION_BOTON_H / 2, 8.0f, color(90, 40, 40));
            text((b + 1) + ". Requiere " + reqPts[b] + " pts · Faltan " + faltan, 44, by + 2, pantallaW - 68, PIXA_DECISION_BOTON_H - 4);
          }
        }
      } else {
        fill(45, 145, 75);
        textFont(fontBold);
        textSize(14);
        textLeading(17);
        textAlign(CENTER, TOP);
        text("Decisión registrada. Presiona 'Avanzar' o 'C'.", 20, posicionDecisionPixagram(curY), pantallaW - 40, 42);
      }
    }

    curY += postBoxH + 14;
  }

  // --- BLOQUE 2: LAS 6 PUBLICACIONES COMUNITARIAS ---
  textFont(fontTitle);
  textSize(18);
  fill(COLOR_PRIMARY_DARK);
  textAlign(LEFT, TOP);
  text("Comunidad", 12, curY);
  textFont(fontBody);
  textSize(13);
  fill(COLOR_TEXT_MUTED);
  text("Interactúa para ganar puntos y bienestar", 12, curY + 23);
  curY += 46;

  for (int i = 0; i < totalPixaPosts; i++) {
    float btnY = posicionAccionesComunidadPixagram(curY, i);
    float cardH = btnY - curY + PIXA_ACCION_H + 12;
    if (!bloqueVisiblePixagram(curY, cardH, vistaArriba, vistaAbajo)) {
      curY += cardH + 14;
      continue;
    }
    fill(COLOR_CARD);
    stroke(COLOR_BORDER);
    strokeWeight(1);
    rect(10, curY, pantallaW - 20, cardH, 9);

    // Avatar del perfil comunitario
    if (pixaAvatares[i] != null && pixaAvatares[i].width > 0) {
      image(pixaAvatares[i], 18, curY + 8, 28, 28);
    } else {
      fill(color(120 + (i * 22) % 110, 95 + (i * 35) % 120, 165));
      noStroke();
      ellipse(32, curY + 22, 28, 28);
    }

    textFont(fontBold);
    textSize(15);
    fill(COLOR_TEXT_DARK);
    textAlign(LEFT, TOP);
    text(pixaNombres[i], 52, curY + 8);
    float anchoNombre = textWidth(pixaNombres[i]);

    textFont(fontBody);
    textSize(12);
    fill(COLOR_TEXT_MUTED);
    text(pixaUsuarios[i], 60 + anchoNombre, curY + 11);
    text(pixaCategorias[i] + " · " + pixaTiempos[i], 52, curY + 28);

    // Imagen o tarjeta visual de la publicación (más grande, 95px)
    float pImgY = curY + 48;
    float pImgW = pantallaW - 36;
    float pImgH = 95;
    if (pixaFotosPosts[i] != null && pixaFotosPosts[i].width > 0) {
      dibujarFotoComunidadPixagram(pixaFotosPosts[i], 18, pImgY, pImgW, pImgH);
    } else {
      dibujarIlustracionPostComunidad(i, 18, pImgY, pImgW, pImgH);
    }

    recDibujarMarco(18, pImgY, pImgW, pImgH);
    // Texto de la publicación (más legible, 10.2f)
    textFont(fontBody);
    textSize(PIXA_FEED_CUERPO);
    fill(COLOR_TEXT_DARK);
    textAlign(LEFT, TOP);
    dibujarLineasPixagram(pixaLineasDescripciones[i], 18, curY + PIXA_COMUNIDAD_TEXTO_Y);

    // Botones interactivos
    float btnH = PIXA_ACCION_H;
    float btnLikeW = 108;
    float btnAccionX = 18 + btnLikeW + 8;
    float btnAccionW = (pantallaW - 18) - btnAccionX;

    // Botón 1: Like con icono vectorial de corazón
    fill(pixaLikeDado[i] ? COLOR_ACCENT : color(234, 230, 222));
    noStroke();
    rect(18, btnY, btnLikeW, btnH, 6);
    int colCorBtn = pixaLikeDado[i] ? color(255) : COLOR_TEXT_DARK;
    dibujarIconoCorazon(30, btnY + btnH / 2, 5.0f, colCorBtn);
    fill(colCorBtn);
    textFont(fontBold);
    textSize(13);
    textAlign(CENTER, CENTER);
    text((pixaLikeDado[i] ? "Liked (" : "Like (") + pixaLikesCount[i] + ")", 18 + btnLikeW / 2 + 7, btnY + btnH / 2);

    // Botón 2: Acción Consciente
    boolean esToxico = pixaImpactoBienestar[i] < 0;
    fill(pixaReflexionDada[i] ? color(60, 155, 85) : (esToxico ? color(215, 95, 55) : COLOR_PRIMARY));
    rect(btnAccionX, btnY, btnAccionW, btnH, 6);
    fill(255);
    String txtAccion = pixaReflexionDada[i] ? "Verificado [OK]" : (esToxico ? "Cuestionar" : "Apoyar");
    textFont(fontBold);
    textSize(13);
    text(txtAccion, btnAccionX + btnAccionW / 2.0f, btnY + btnH / 2);

    curY += cardH + 14;
  }

  maxScrollYFeed = max(0, curY - contentH + 30);
}

void dibujarIlustracionPostComunidad(int idx, float x, float y, float w, float h) {
  pushStyle();
  noStroke();
  if (idx == 0) {
    fill(45, 35, 85);
    rect(x, y, w, h, 6);
    fill(255, 210, 95);
    ellipse(x + w * 0.72f, y + h * 0.35f, 26, 26);
    fill(95, 195, 235);
    triangle(x + 10, y + h, x + w * 0.38f, y + 18, x + w * 0.72f, y + h);
    triangle(x + w * 0.32f, y + h, x + w * 0.65f, y + 35, x + w - 10, y + h);
  } else { if (idx == 1) {
    fill(65, 20, 35);
    rect(x, y, w, h, 6);
    dibujarIconoAlerta(x + 25, y + h * 0.5f, 12, color(255, 90, 60));
    fill(255, 80, 110);
    textAlign(CENTER, CENTER);
    textFont(fontBold);
    textSize(11.0f);
    text("#RETO100K - 6 HORAS SIN DORMIR", x + w / 2 + 10, y + h / 2);
  } else { if (idx == 2) {
    fill(85, 135, 110);
    rect(x, y, w, h, 6);
    fill(245, 175, 90);
    ellipse(x + w / 2, y + h / 2 + 6, 46, 36);
    triangle(x + w / 2 - 18, y + h / 2 - 4, x + w / 2 - 10, y + h / 2 - 20, x + w / 2 - 2, y + h / 2 - 4);
    triangle(x + w / 2 + 18, y + h / 2 - 4, x + w / 2 + 10, y + h / 2 - 20, x + w / 2 + 2, y + h / 2 - 4);
  } else { if (idx == 3) {
    fill(75, 115, 95);
    rect(x, y, w, h, 6);
    fill(245, 235, 210);
    rect(x + w / 2 - 38, y + h / 2 - 25, 76, 50, 4);
    stroke(120, 100, 80);
    line(x + w / 2, y + h / 2 - 25, x + w / 2, y + h / 2 + 25);
  } else { if (idx == 4) {
    fill(90, 28, 28);
    rect(x, y, w, h, 6);
    dibujarIconoAlerta(x + 28, y + h * 0.5f, 12, color(255, 215, 70));
    fill(255, 215, 70);
    textAlign(CENTER, CENTER);
    textFont(fontBold);
    textSize(10.5f);
    text("RUMOR VIRAL: EXAMEN FILTRADO", x + w / 2 + 10, y + h / 2);
  } else {
    fill(30, 65, 110);
    rect(x, y, w, h, 6);
    fill(130, 215, 255);
    textAlign(CENTER, CENTER);
    textFont(fontBold);
    textSize(10.5f);
    text("CIENCIA DEL SUEÑO Y LUZ AZUL", x + w / 2, y + h / 2);
  } } } } }
  popStyle();
}

void procesarClicFeedPixagram(float relX, float relY, float contentY, float contentH) {
  procesarClicFeedPixagram(relX, relY, contentY);
}

void procesarClicFeedPixagram(float relX, float relY, float contentY) {
  actualizarTextoPixagram();
  float feedY = relY - contentY - scrollYFeed;
  float curY = 8;

  boolean accionFeedRealizada = false;

  // 1. Interacción con el post de penaltis
  if (totalFeedPosts > 0) {
    float postBoxH = altoPostPenaltisPixagram(curY);
    float likeY = curY + PIXA_PEN_LIKE_Y;

    // Clic en Like del post de penaltis (SOLO 1 VEZ, SIN PUNTOS INFINITOS)
    if (relX >= 14 && relX <= 140 && feedY >= likeY - 4 && feedY <= likeY + 24) {
      if (!postIsLiked[0]) {
        postIsLiked[0] = true;
        postLikes[0]++;
        ganarPuntosConPopup(5, 1, "+5 PTS", telefonoX + relX, telefonoY + relY, color(255, 215, 70));
        reproducirSfx(SFX_LIKE, 0.5f);
        if (sonidoClic != null) { sonidoClic.amp(0.35f * volMaster); sonidoClic.play(); }
      } else {
        crearPopupFlotante("Ya diste Like", telefonoX + pantallaW / 2, telefonoY + relY - 18, color(200, 200, 210));
      }
      accionFeedRealizada = true;
    }

    // Clic en una de las 3 opciones de decisión post-penaltis
    if (!accionFeedRealizada && !decisionPixagramTomada) {
      float decY = posicionDecisionPixagram(curY);
      for (int b = 0; b < 3 && !accionFeedRealizada; b++) {
        float by = decY + PIXA_DECISION_BOTONES_Y + b * PIXA_DECISION_PASO;
        if (relX >= 20 && relX <= pantallaW - 20 && feedY >= by && feedY <= by + PIXA_DECISION_BOTON_H) {
          ejecutarDecisionPixagramPenaltis(b + 1);
          accionFeedRealizada = true;
        }
      }
    }

    curY += postBoxH + 14;
  }

  // Título de la comunidad
  curY += 46;

  // 2. Interacción con las 6 publicaciones de la comunidad
  for (int i = 0; i < totalPixaPosts && !accionFeedRealizada; i++) {
    float btnY = posicionAccionesComunidadPixagram(curY, i);
    float cardH = btnY - curY + PIXA_ACCION_H + 12;
    float btnH = PIXA_ACCION_H;
    float btnLikeW = 108;
    float btnAccionX = 18 + btnLikeW + 8;
    float btnAccionW = (pantallaW - 18) - btnAccionX;

    // Botón Like en post comunitario i (SOLO 1 VEZ, SIN PUNTOS INFINITOS)
    if (relX >= 18 && relX <= 18 + btnLikeW && feedY >= btnY && feedY <= btnY + btnH) {
      if (!pixaLikeDado[i]) {
        pixaLikeDado[i] = true;
        pixaLikesCount[i]++;
        int impB = pixaImpactoBienestar[i];
        int impR = pixaImpactoReputacion[i];
        modificarBienestar(impB, telefonoX + 60, telefonoY + relY);
        modificarReputacion(impR, telefonoX + 200, telefonoY + relY);
        if (impB > 0) {
          ganarPuntosConPopup(10, 1, "+10 PTS LIKE SANO", telefonoX + pantallaW / 2, telefonoY + relY - 18, color(100, 245, 140));
          desbloquearLogro(3); // Primer Like
        } else {
          crearPopupFlotante("Contenido tóxico (-Bienestar)", telefonoX + pantallaW / 2, telefonoY + relY - 18, color(255, 95, 90));
        }
        reproducirSfx(SFX_LIKE, 0.5f);
        if (sonidoClic != null) { sonidoClic.amp(0.35f * volMaster); sonidoClic.play(); }
      } else {
        crearPopupFlotante("Ya diste Like", telefonoX + pantallaW / 2, telefonoY + relY - 18, color(200, 200, 210));
      }
      accionFeedRealizada = true;
    } else { if (relX >= btnAccionX && relX <= btnAccionX + btnAccionW && feedY >= btnY && feedY <= btnY + btnH) {
      // Botón Reflexionar / Cuestionar en post comunitario i
      if (!pixaReflexionDada[i]) {
        pixaReflexionDada[i] = true;
        boolean esToxico = (pixaImpactoBienestar[i] < 0);
        if (esToxico) {
          rachaDecisionesSanas++;
          int bonus = (rachaDecisionesSanas >= 2) ? 20 : 15;
          ganarPuntosConPopup(bonus, 1, "+" + bonus + " PTS ¡CAZADOR DE BULOS!", telefonoX + pantallaW / 2, telefonoY + relY - 20, color(255, 225, 70));
          modificarBienestar(7, telefonoX + 80, telefonoY + relY);
          modificarReputacion(6, telefonoX + 220, telefonoY + relY);
          desbloquearLogro(6); // Cazador de Bulos
        } else {
          rachaDecisionesSanas++;
          ganarPuntosConPopup(10, 1, "+10 PTS ¡COMENTARIO POSITIVO!", telefonoX + pantallaW / 2, telefonoY + relY - 20, color(110, 235, 255));
          modificarBienestar(4, telefonoX + 80, telefonoY + relY);
          modificarReputacion(3, telefonoX + 220, telefonoY + relY);
        }
        if (sonidoClic != null) { sonidoClic.amp(0.45f * volMaster); sonidoClic.play(); }
      } else {
        crearPopupFlotante("Ya verificaste esta publicación", telefonoX + pantallaW / 2, telefonoY + relY - 20, color(200, 200, 210));
      }
      accionFeedRealizada = true;
    } }

    curY += cardH + 14;
  }
}


void ejecutarDecisionPixagramPenaltis(int opcion) {
  if (!decisionPixagramTomada) {
    int[] reqPts = { 40, 15, 0 };
    int req = reqPts[opcion - 1];

    if (puntosJugador < req) {
      activarScreenShake(12, 6.0f);
      crearPopupFlotante("Necesitas " + req + " pts (Faltan " + (req - puntosJugador) + " pts). Elige otra opción.", width / 2, height / 2, color(255, 95, 90));
      if (!reproducirSfx(SFX_DECISION_BLOQUEADA, 0.6f) && sonidoHover != null) { sonidoHover.amp(0.35f * volMaster); sonidoHover.play(); }
    } else {
      decisionPixagramPenaltis = opcion;
      decisionPixagramTomada = true;
      reproducirSfx(SFX_DECISION_CONFIRMADA, 0.6f);
      boolean esDerrota = (goles < 3);

      if (opcion == 1) {
        // Pedir que borren la foto / Agradecer por el partido
        modificarReputacion(20, width / 2 - 140 * escalaX, height / 2 - 40 * escalaY);
        modificarBienestar(15, width / 2 + 140 * escalaX, height / 2 - 40 * escalaY);
        ganarPuntosConPopup(30, 3, "+30 PTS ¡EMPATÍA EJEMPLAR!", width / 2, height / 2 - 80 * escalaY, color(100, 255, 145));
        if (postCommentCount[0] < MAX_COMMENTS_POR_POST) {
          int idx = postCommentCount[0];
          postCommentAuthor[0][idx] = "Sam";
          postCommentText[0][idx] = esDerrota
            ? "Jajaja muy chistoso. Ya, bajen la foto porfa, qué oso."
            : "Estuvo buenísimo el partido. Ustedes también taparon resto. Mañana repetimos.";
          postCommentCount[0]++;
        }
        desbloquearLogro(5); // Defensor Digital
      } else { if (opcion == 2) {
        // Enviar la respuesta por el chat existente de Mateo y Cristian.
        String mensajePrivado = esDerrota
          ? "Oigan, no me gustó la foto, ¿la quitan?"
          : "Gracias por invitarme a jugar :)";
        chatMensajes[4][3] = "S: " + mensajePrivado;
        chatRespuestasSam[4] = mensajePrivado;
        chatRespondido[4] = true;
        modificarReputacion(10, width / 2 - 140 * escalaX, height / 2 - 40 * escalaY);
        modificarBienestar(8, width / 2 + 140 * escalaX, height / 2 - 40 * escalaY);
        ganarPuntosConPopup(15, 3, "+15 PTS ¡MENSAJE PRIVADO SANO!", width / 2, height / 2 - 80 * escalaY, color(120, 220, 255));
        desbloquearLogro(5);
      } else {
        // Opción 3 (0 pts - Nunca bloqueada): No hacer nada / Presumir
        if (!esDerrota && postCommentCount[0] < MAX_COMMENTS_POR_POST) {
          int idxSam = postCommentCount[0];
          postCommentAuthor[0][idxSam] = "Sam";
          postCommentText[0][idxSam] = "Cuando quieran les enseño a cobrar.";
          postCommentCount[0]++;
        }
        modificarReputacion(-15, width / 2 - 140 * escalaX, height / 2 - 40 * escalaY);
        modificarBienestar(-12, width / 2 + 140 * escalaX, height / 2 - 40 * escalaY);
        activarScreenShake(10, 5.0f);
        if (postCommentCount[0] < MAX_COMMENTS_POR_POST) {
          int idx = postCommentCount[0];
          postCommentAuthor[0][idx] = "Clara";
          postCommentText[0][idx] = esDerrota
            ? "Y la foto ahí, como si nada. Qué boleta, de verdad."
            : "Uy, ganó un partido y ya le toca firmar autógrafos.";
          postCommentCount[0]++;
        }
      } }

      if (sonidoClic != null) { sonidoClic.amp(0.5f * volMaster); sonidoClic.play(); }

      // Clara escribe a Sam tras los penaltis y el post, y se activan los SMS
      desbloquearSmsPostPenaltis();
      crearPopupFlotante("¡Decisión tomada! Presiona [ENTER] o 'C' abajo para Finalizar el Día 1", width / 2, 70 * escalaY, color(52, 211, 153));
    }
  }
}

void intentarSalirDeCelular() {
  if (reproductorMp3 != null) {
    reproductorMp3.stop();
    reproduciendoMusica = false;
  }

  if (penaltisJugados) {
    if (!decisionPixagramTomada) {
      enHome = false;
      appAbierta = "Pixagram";
      currentTab = 1;
      scrollYFeed = 0;
      activarScreenShake(10, 5.0f);
      crearPopupFlotante("Elige una respuesta en el post de Penaltis", width / 2, height / 2, color(255, 210, 75));
    } else { if (!dia1Terminado) {
      // Requisito: Fin del Día 1 -> Cinemática
      timerFinDia1 = 0;
      estadoDestino = FIN_DIA_1;
      enTransicion = true;
    } else {
      // Ya terminó el día 1, vuelve a la casa
      estadoDestino = EXPLORACION;
      enTransicion = true;
    } }
  } else {
    // Flujo antes de salir al colegio: simplemente cierra el celular y vuelve a la exploración
    if (guiaPixagramVisita != GUIA_PIXAGRAM_SIN_VISITA) guiaPixagramVisita = GUIA_PIXAGRAM_COMPLETA;
    estadoDestino = EXPLORACION;
    enTransicion = true;
  }
}

// =========================================================================
// CARTEL DE TRANSICIÓN TEMPORAL («12 DÍAS DESPUÉS»)
// =========================================================================
void dibujarTransicionTemporal() {
  background(8, 10, 18);
  if (!enPausa) {
    timerTransicionTemporal++;
  }
  if (!enPausa && timerTransicionTemporal == 1) { reproducirSfx(SFX_TRANSICION_TEMPORAL, 0.7f); }

  float prog = constrain(timerTransicionTemporal / float(DURACION_TRANSICION_TEMPORAL), 0, 1);
  float alfa = 255.0f;
  if (timerTransicionTemporal < 35) {
    alfa = map(timerTransicionTemporal, 0, 35, 0, 255);
  } else { if (timerTransicionTemporal > DURACION_TRANSICION_TEMPORAL - 35) {
    alfa = map(timerTransicionTemporal, DURACION_TRANSICION_TEMPORAL - 35, DURACION_TRANSICION_TEMPORAL, 255, 0);
  } }

  pushStyle();
  // Estrellas / partículas suaves de fondo
  noStroke();
  for (int i = 0; i < 28; i++) {
    float sx = ((i * 197 + timerTransicionTemporal * 0.4f) % REF_W) * escalaX;
    float sy = ((i * 131) % REF_H) * escalaY;
    float br = 0.5f + 0.5f * sin(timerTransicionTemporal * 0.06f + i);
    fill(255, 225, 160, alfa * 0.35f * br);
    ellipse(sx, sy, 4 * escalaX, 4 * escalaY);
  }

  // Marco ornamental
  rectMode(CENTER);
  noFill();
  stroke(255, 205, 95, alfa * 0.55f);
  strokeWeight(2 * escalaX);
  rect(width / 2, height / 2, 860 * escalaX, 340 * escalaY, 24 * escalaX);

  textAlign(CENTER, CENTER);
  fill(185, 205, 240, alfa * 0.85f);
  textSize(20 * escalaX);
  text("UN FIN DE SEMANA DESPUÉS...", width / 2, height / 2 - 78 * escalaY);

  fill(255, 195, 55, alfa * 0.25f);
  textSize(68 * escalaX);
  text("« 12 DÍAS DESPUÉS »", width / 2 + 3 * escalaX, height / 2 - 8 * escalaY + 3 * escalaY);

  fill(255, 235, 145, alfa);
  textSize(66 * escalaX);
  text("« 12 DÍAS DESPUÉS »", width / 2, height / 2 - 8 * escalaY);

  stroke(255, 210, 95, alfa * 0.75f);
  strokeWeight(2.5f * escalaX);
  float wLin = 460 * escalaX * sin(prog * PI);
  line(width / 2 - wLin / 2, height / 2 + 44 * escalaY, width / 2 + wLin / 2, height / 2 + 44 * escalaY);

  fill(215, 225, 245, alfa * 0.9f);
  textSize(19 * escalaX);
  String resumenEco = (goles >= 3)
    ? "Mateo llega a casa de Sam con una bolsa de ingredientes."
    : (decisionPixagramPenaltis == 1
        ? "Mateo llega a casa de Sam. Hoy van a probar una receta juntos."
        : (decisionPixagramPenaltis == 2
            ? "Mateo toca el timbre con los ingredientes para cocinar con Sam."
            : "Mateo viene a cocinar con Sam. Todavía tienen algo pendiente de qué hablar."));
  text(resumenEco, width / 2, height / 2 + 86 * escalaY);

  if (timerTransicionTemporal > 35) {
    fill(160, 190, 230, alfa * (0.5f + 0.5f * sin(frameCount * 0.1f)));
    textSize(14 * escalaX);
    text("Haz clic o presiona [ENTER] / [ESPACIO] para continuar", width / 2, height / 2 + 142 * escalaY);
  }
  rectMode(CORNER);
  popStyle();

  if (!enPausa && timerTransicionTemporal >= DURACION_TRANSICION_TEMPORAL && !enTransicion) {
    paginaCocina = 0;
    mostrandoDecisionCocina = false;
    ultimoTextoDialogo = "";
    charsVisibles = 0;
    dialogoCompletado = false;
    estadoDestino = NOVELA_COCINA;
    enTransicion = true;
  }
}

// =========================================================================
// NUEVA SECUENCIA DE NOVELA VISUAL: COCINA CON AMIGO (PRE-NIVEL 2)
// =========================================================================
String obtenerDialogoCocina(int pag) {
  boolean gano = (goles >= 3);
  String texto = "";
  if (pag == 0) {
    texto = "Doce días después del partido, Mateo llega a casa de Sam con una bolsa. La deja sobre la mesa de la cocina y empieza a sacar los ingredientes.";
  } else { if (pag == 1) {
    texto = "Traje los tomates. Y esto también, pero no sé qué es. Mi mamá dijo que se lo echaras poquito.";
  } else { if (pag == 2) {
    if (gano) {
      texto = "Todavía me da rabia ese último penalti. Yo pensé que lo tapaba y nada... Nos metiste " + goles + " goles.";
    } else {
      texto = "Oye... lo de la foto que subimos. Te quería pedir perdón.";
    }
  } else { if (pag == 3) {
    if (gano) {
      if (decisionPixagramPenaltis == 1) texto = "Vi que nos diste las gracias en los comentarios. Pero mañana hay revancha, ¿sí?";
      else { if (decisionPixagramPenaltis == 2) texto = "Ah, sí vi tu mensaje. Iba a contestarte y se me olvidó. Mañana repetimos, ¿no?";
      else texto = "Eso sí, ¿cómo que nos vas a enseñar a cobrar? Ganaste una vez, tampoco abuses."; }
    } else {
      if (decisionPixagramPenaltis == 1) texto = "Cuando pediste que la quitáramos me dio pena. Yo ahí riéndome y tú pasando un mal rato.";
      else { if (decisionPixagramPenaltis == 2) texto = "Le mostré tu mensaje a Cristian. Nos pareció chistosa y la subimos sin preguntarte. Qué bobada.";
      else texto = "El profe vio la foto y nos hizo borrarla. Debí preguntarte antes de subir eso."; }
    }
  } else { if (pag == 4) {
    if (gano) {
      texto = "Bueno, pero hoy te toca ayudar. Lávate las manos y pásame ese tomate.";
    } else {
      texto = "Sí me dio rabia. La próxima me preguntan, ¿bueno? Ven, ayúdame con esto.";
    }
  } else { if (pag == 5) {
    texto = "¿Y este librito? ¿Venía con la olla? Parece más un manual que una receta.";
  } else { if (pag == 6) {
    texto = "Espera, ¿grabamos un poquito? ¿O guardamos los celulares y ya?";
  } else { if (pag == 7) {
    if (decisionCocinaTomada == 1) {
      texto = "Listo, lo dejo acá. Tú corta el tomate, que yo siempre lo aplasto.";
    } else {
      texto = "Bueno, al bolsillo. Pásame otro tomate, que este se me rodó.";
    }
  } else { if (pag == 8) {
    texto = "A ver, préstame... Dice que pongamos música y sigamos las marcas para echar los ingredientes. ¿Y esto sí es para hacer un estofado?";
  } else { if (pag == 9) {
    texto = "Eso dice la portada. Mira, aquí trae los pasos y unos dibujos. Dejémoslo abierto por si nos perdemos.";
  } else { if (pag == 10) {
    texto = "Bueno. Tú miras el manual y yo revuelvo. Si empieza a oler raro, me avisas.";
  } else {
    texto = "¿Y por qué yo tengo que olerlo? Ven, primero escojamos por cuál empezamos.";
  } } } } } } } } } } }
  return texto;
}

String obtenerHablanteCocina(int pag) {
  String hablante = "SAM:";
  if (pag == 0) {
    hablante = "NARRADOR:";
  } else { if (pag == 1 || pag == 2 || pag == 3 || pag == 5 || pag == 6 || pag == 7 || pag == 9 || pag == 11) {
    hablante = "MATEO:";
  } }
  return hablante;
}

void dibujarNovelaCocina() {
  // Fondo de cocina: usa imgFondoCocina si existe, o ilustración vectorial detallada de cocina cálida
  if (imgFondoCocina != null && imgFondoCocina.width > 0) {
    image(imgFondoCocina, 0, 0, width, height);
  } else {
    dibujarFondoCocinaProcedimental();
  }

  String hablante = obtenerHablanteCocina(paginaCocina);
  String texto = obtenerDialogoCocina(paginaCocina);

  // Retratos de Sam y Mateo omitidos para mostrar exclusivamente la imagen de fondo limpia
  // dibujarRetratosEscenaCocina(hablante);

  // Etiqueta superior de ubicación
  pushStyle();
  fill(0, 185);
  stroke(255, 210, 90);
  strokeWeight(1.8f * escalaX);
  rect(24 * escalaX, 18 * escalaY, 355 * escalaX, 38 * escalaY, 10 * escalaX);
  fill(255, 225, 110);
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(14.5f * escalaX);
  text("Cocina de Sam - 12 días después", (24 + 177.5f) * escalaX, (18 + 19) * escalaY);

  // Indicador de puntos en la esquina superior derecha con estrella vectorial
  fill(0, 185);
  stroke(255, 215, 70);
  strokeWeight(1.8f * escalaX);
  rect(width - 245 * escalaX, 18 * escalaY, 220 * escalaX, 38 * escalaY, 10 * escalaX);
  dibujarIconoEstrella(width - 218 * escalaX, 37 * escalaY, 7.5f * escalaX, color(255, 230, 85));
  fill(255, 230, 85);
  noStroke();
  text("Puntos: " + round(puntosMostradosLerp) + " pts", width - 125 * escalaX, 37 * escalaY);
  popStyle();

  // Cuadro de diálogo con máquina de escribir
  float cajaAncho = width * 0.86f;
  float cajaAlto = height * 0.25f;
  float cajaX = (width - cajaAncho) / 2;
  float cajaY = height - cajaAlto - 34 * escalaY;

  pushStyle();
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
    charsVisibles += velTypewriter;
    if (int(charsVisibles) >= texto.length()) {
      charsVisibles = texto.length();
      dialogoCompletado = true;
    }
  }
  String textoMostrado = texto.substring(0, int(charsVisibles));

  // Color del hablante
  if (hablante.indexOf("SAM") >= 0) fill(100, 210, 255);
  else { if (hablante.indexOf("MATEO") >= 0) fill(255, 175, 75);
  else fill(210, 215, 230); }

  textAlign(LEFT, TOP);
  textSize(22 * escalaX);
  text(hablante, cajaX + 36 * escalaX, cajaY + 22 * escalaY);

  fill(255);
  textSize(23 * escalaX);
  float margenTextoX = cajaX + 36 * escalaX;
  float margenTextoY = cajaY + 58 * escalaY;
  float anchoTextoMax = cajaAncho - 72 * escalaX;
  float altoTextoMax = cajaAlto - 90 * escalaY;
  text(textoMostrado, margenTextoX, margenTextoY, anchoTextoMax, altoTextoMax);

  fill(175, 195, 225);
  textSize(14 * escalaX);
  textAlign(RIGHT, BOTTOM);
  String piePag = (paginaCocina == 6 && decisionCocinaTomada == 0)
    ? "Haz clic o presiona [ENTER] para tomar una decisión (" + (paginaCocina + 1) + "/" + totalPaginasCocina + ")"
    : "Haz clic o presiona [ENTER] para continuar (" + (paginaCocina + 1) + "/" + totalPaginasCocina + ")";
  text(piePag, cajaX + cajaAncho - 28 * escalaX, cajaY + cajaAlto - 14 * escalaY);
  popStyle();

  if (mostrandoDecisionCocina) {
    dibujarModalDecisionCocina();
  }
}

void dibujarFondoCocinaProcedimental() {
  pushStyle();
  PImage imgNovelaFondo = null;
  if (imgFondoCocina != null && imgFondoCocina.width > 0) {
    imgNovelaFondo = imgFondoCocina;
  } else { if (imgEscenaDesayuno != null && imgEscenaDesayuno.width > 0) {
    imgNovelaFondo = imgEscenaDesayuno;
  } else { if (escenasNovela[2] != null && escenasNovela[2].width > 0) {
    imgNovelaFondo = escenasNovela[2];
  } else { if (fondoEscena != null && fondoEscena.width > 0) {
    imgNovelaFondo = fondoEscena;
  } else { if (escenasNovela[0] != null && escenasNovela[0].width > 0) {
    imgNovelaFondo = escenasNovela[0];
  } } } } }

  if (imgNovelaFondo != null && imgNovelaFondo.width > 0) {
    imageMode(CORNER);
    noTint();
    if (imgNovelaFondo.width == width && imgNovelaFondo.height == height) {
      image(imgNovelaFondo, 0, 0);
    } else {
      image(imgNovelaFondo, 0, 0, width, height);
    }
  } else {
    background(18, 22, 34);
  }
  popStyle();
}

void dibujarRetratosEscenaCocina(String hablante) {
  // Desactivado: se muestra únicamente la imagen de fondo limpia sin los sprites de personajes
}

void dibujarModalDecisionCocina() {
  pushStyle();
  fill(0, 185);
  noStroke();
  rect(0, 0, width, height);

  float mw = 780 * escalaX;
  float mh = 340 * escalaY;
  float mx = (width - mw) / 2;
  float my = (height - mh) / 2;

  fill(22, 28, 44, 248);
  stroke(255, 205, 80);
  strokeWeight(3 * escalaX);
  rect(mx, my, mw, mh, 18 * escalaX);

  fill(255, 225, 90);
  textAlign(CENTER, CENTER);
  textSize(24 * escalaX);
  text("¿GRABAMOS UN PEDACITO?", width / 2, my + 40 * escalaY);

  dibujarIconoEstrella(width / 2 - 220 * escalaX, my + 74 * escalaY, 8 * escalaX, color(205, 225, 255));
  fill(205, 225, 255);
  textSize(15.5f * escalaX);
  text("Mateo espera tu respuesta antes de empezar.", width / 2 + 8 * escalaX, my + 74 * escalaY);

  String[] tit = {
    "[1] Grabar un pedacito para Pixagram",
    "[2] Dejar los celulares guardados y cocinar"
  };
  String[] sub = {
    "Poner el celular en la mesa, lejos de la olla.",
    "Guardar los celulares y ponerse con la receta."
  };
  int[] req = { 50, 0 };

  for (int i = 0; i < 2; i++) {
    float bx = mx + 36 * escalaX;
    float by = my + 112 * escalaY + i * 96 * escalaY;
    float bw = mw - 72 * escalaX;
    float bh = 78 * escalaY;

    boolean ok = (puntosJugador >= req[i]);
    boolean hover = (mouseX >= bx && mouseX <= bx + bw && mouseY >= by && mouseY <= by + bh);

    if (!ok) {
      fill(44, 44, 54, 225);
      stroke(115, 115, 130);
    } else { if (hover) {
      fill(52, 85, 135, 245);
      stroke(255, 230, 90);
    } else {
      fill(32, 50, 82, 235);
      stroke(95, 150, 225);
    } }
    strokeWeight(2 * escalaX);
    rect(bx, by, bw, bh, 12 * escalaX);

    textAlign(LEFT, TOP);
    textSize(16.5f * escalaX);
    fill(ok ? color(255) : color(155, 158, 168));
    text(tit[i], bx + 18 * escalaX, by + 14 * escalaY);

    textSize(13.5f * escalaX);
    if (ok) {
      fill(175, 240, 195);
      text(sub[i], bx + 18 * escalaX, by + 44 * escalaY);
    } else {
      dibujarIconoCandado(bx + 26 * escalaX, by + 51 * escalaY, 13 * escalaX, color(255, 125, 115));
      fill(255, 125, 115);
      text("BLOQUEADO: Requiere " + req[i] + " pts - Te faltan " + (req[i] - puntosJugador) + " pts", bx + 42 * escalaX, by + 44 * escalaY);
    }
  }
  popStyle();
}

void procesarClicDecisionCocina() {
  float mw = 780 * escalaX;
  float mh = 340 * escalaY;
  float mx = (width - mw) / 2;
  float my = (height - mh) / 2;
  boolean opcionElegida = false;
  for (int i = 0; i < 2 && !opcionElegida; i++) {
    float bx = mx + 36 * escalaX;
    float by = my + 112 * escalaY + i * 96 * escalaY;
    float bw = mw - 72 * escalaX;
    float bh = 78 * escalaY;
    if (mouseX >= bx && mouseX <= bx + bw && mouseY >= by && mouseY <= by + bh) {
      elegirOpcionCocina(i + 1);
      opcionElegida = true;
    }
  }
}

void elegirOpcionCocina(int op) {
  int[] req = { 50, 0 };
  if (puntosJugador < req[op - 1]) {
    activarScreenShake(10, 5.0f);
    crearPopupFlotante("Te faltan " + (req[op - 1] - puntosJugador) + " pts", width / 2, height / 2, color(255, 95, 90));
    reproducirSfx(SFX_DECISION_BLOQUEADA, 0.6f);
  } else {
    decisionCocinaTomada = op;
    mostrandoDecisionCocina = false;
    reproducirSfx(SFX_DECISION_CONFIRMADA, 0.6f);
    if (op == 1) {
      modificarReputacion(12, width / 2 - 130 * escalaX, height / 2);
      modificarBienestar(10, width / 2 + 130 * escalaX, height / 2);
      ganarPuntosConPopup(25, 3, "+25 PTS ¡CREADOR POSITIVO!", width / 2, height / 2 - 40 * escalaY, color(255, 225, 70));
    } else {
      modificarBienestar(12, width / 2 - 130 * escalaX, height / 2);
      modificarReputacion(4, width / 2 + 130 * escalaX, height / 2);
      ganarPuntosConPopup(10, 3, "+10 PTS ¡CONEXIÓN REAL!", width / 2, height / 2 - 40 * escalaY, color(105, 245, 150));
    }
    paginaCocina = 7;
    ultimoTextoDialogo = "";
    charsVisibles = 0;
    dialogoCompletado = false;
    if (sonidoClic != null) { sonidoClic.amp(0.45f * volMaster); sonidoClic.play(); }
  }
}

// =========================================================================
// SELECCIÓN DE DIFICULTAD DEL NIVEL 2 (CON AVISO DE FOTOSENSIBILIDAD / EPILEPSIA)
// =========================================================================
void dibujarSeleccionDificultadNv2() {
  // Asegurar que el fondo de la cocina (bg_cocina.png) esté disponible
  if (imgFondoCocina == null || imgFondoCocina.width <= 0) {
    try {
      File fCocina = dataFile("bg_cocina.png");
      if (fCocina.exists()) {
        imgFondoCocina = loadImage("bg_cocina.png");
        if (imgFondoCocina != null && imgFondoCocina.width > 0) {
          imgFondoCocina.resize(width, height);
        }
      }
    } catch (Exception e) {}
  }

  if (imgFondoCocina != null && imgFondoCocina.width > 0) {
    pushStyle();
    imageMode(CORNER);
    noTint();
    if (imgFondoCocina.width == width && imgFondoCocina.height == height) {
      image(imgFondoCocina, 0, 0);
    } else {
      image(imgFondoCocina, 0, 0, width, height);
    }
    popStyle();
  } else {
    dibujarFondoCocinaProcedimental();
  }
  pushStyle();
  noStroke();
  fill(10, 14, 24, 205);
  rect(0, 0, width, height);

  // Franja superior elegante
  fill(18, 24, 38, 240);
  rect(0, 0, width, 118 * escalaY);
  stroke(56, 189, 248, 80);
  strokeWeight(1.5f * escalaX);
  line(0, 118 * escalaY, width, 118 * escalaY);
  noStroke();

  textAlign(CENTER, CENTER);
  fill(255, 220, 75);
  if (fontTitle != null) textFont(fontTitle);
  textSize(36 * escalaX);
  text("SELECCIONA LA DIFICULTAD - COCINA AL RITMO", width / 2, 42 * escalaY);

  fill(203, 213, 225);
  if (fontBody != null) textFont(fontBody);
  textSize(15 * escalaX);
  String tituloCancionSel = nv2TitulosPorDif[constrain(nv2Dificultad, 0, TOTAL_DIFICULTADES_NV2 - 1)];
  text("Canción Nivel " + (nv2Dificultad + 1) + ": " + tituloCancionSel + "   •   Teclas [1-4] o clic para elegir", width / 2, 84 * escalaY);

  String[] subCarriles = {
    "2 CARRILES | Teclas: A, D",
    "4 CARRILES | Teclas: D, F, J, K",
    "5 CARRILES | D, F, J, K, L (+S)",
    "9 CARRILES | A S D F [ESP] H J K L"
  };
  String[] detallesCortos = {
    "Appeal (100 BPM) • Mult x1.0",
    "Hello Juliet (132 BPM) • Mult x1.5",
    "Aoi, Koi (149 BPM) • Mult x2.2",
    "RUSH E (Black MIDI) • Mult x3.5"
  };
  int[] colCard = {
    color(56, 189, 248),
    color(251, 146, 60),
    color(248, 113, 113),
    color(192, 132, 252)
  };

  for (int i = 0; i < TOTAL_DIFICULTADES_NV2; i++) {
    float cx = width / 2 + (i - 1.5f) * 342 * escalaX;
    float cy = 375 * escalaY;
    float cardW = 320 * escalaX;
    float cardH = 415 * escalaY;

    boolean sel = (nv2Dificultad == i);
    boolean hover = (mouseX >= cx - cardW / 2 && mouseX <= cx + cardW / 2 && mouseY >= cy - cardH / 2 && mouseY <= cy + cardH / 2);

    rectMode(CENTER);
    if (sel) {
      fill(24, 32, 54, 252);
      stroke(colCard[i]);
      strokeWeight(4.5f * escalaX);
    } else { if (hover) {
      fill(20, 27, 44, 242);
      stroke(180, 205, 245);
      strokeWeight(2.4f * escalaX);
    } else {
      fill(15, 20, 32, 230);
      stroke(51, 65, 85);
      strokeWeight(1.8f * escalaX);
    } }
    rect(cx, cy, cardW, cardH, 18 * escalaX);

    // Cabecera de la tarjeta con nombre de la dificultad
    noStroke();
    fill(colCard[i], sel ? 245 : 180);
    rect(cx, cy - cardH / 2 + 32 * escalaY, cardW - 8 * escalaX, 54 * escalaY, 14 * escalaX);
    fill(255);
    if (fontBold != null) textFont(fontBold);
    textSize(21 * escalaX);
    text("[" + (i + 1) + "] " + nv2NombresDificultad[i], cx, cy - cardH / 2 + 32 * escalaY);

    // ÁREA PARA ILUSTRACIÓN PERSONALIZADA (IbisPaint: 600 x 360 px)
    float artW = cardW - 24 * escalaX;
    float artH = 158 * escalaY;
    float artY = cy - cardH / 2 + 148 * escalaY;

    if (imgDificultadNv2[i] != null && imgDificultadNv2[i].width > 0) {
      imageMode(CENTER);
      image(imgDificultadNv2[i], cx, artY, artW, artH);
      imageMode(CORNER);
      noFill();
      stroke(colCard[i], 120);
      strokeWeight(1.5f * escalaX);
      rect(cx, artY, artW, artH, 10 * escalaX);
    } else {
      // Recuadro estilizado mientras el usuario dibuja su arte
      fill(10, 14, 24, 210);
      stroke(colCard[i], 90);
      strokeWeight(1.5f * escalaX);
      rect(cx, artY, artW, artH, 10 * escalaX);

      // Ícono representativo
      noStroke();
      fill(colCard[i], 40);
      ellipse(cx, artY - 10 * escalaY, 56 * escalaX, 56 * escalaX);
      fill(colCard[i]);
      textSize(26 * escalaX);
      String ico = (i == 0) ? "NV.1" : (i == 1) ? "NV.2" : (i == 2) ? "NV.3" : "MAX";
      text(ico, cx, artY - 10 * escalaY);
      fill(148, 163, 184);
      if (fontBody != null) textFont(fontBody);
      textSize(11 * escalaX);
      text("Arte IbisPaint (600x360)", cx, artY + 34 * escalaY);
    }

    // Textos informativos limpios y compactos
    fill(255, 230, 120);
    if (fontBold != null) textFont(fontBold);
    textSize(14 * escalaX);
    text(subCarriles[i], cx, cy + 82 * escalaY);

    // Círculos de los carriles
    int numC = nv2CarrilesPorDif[i];
    float pasoMini = (numC >= 9 ? 28 : 34) * escalaX;
    float diamMini = (numC >= 9 ? 18 : 20);
    float anchoTotalMini = (numC - 1) * pasoMini;
    for (int c = 0; c < numC; c++) {
      float mcx = cx - anchoTotalMini / 2 + c * pasoMini;
      float mcy = cy + 115 * escalaY;
      fill(nv2ColoresCarril[c]);
      noStroke();
      ellipse(mcx, mcy, diamMini * escalaX, diamMini * escalaY);
    }

    fill(203, 213, 225);
    if (fontBody != null) textFont(fontBody);
    textSize(12.5f * escalaX);
    text(detallesCortos[i], cx, cy + 148 * escalaY);

    if (sel) {
      fill(colCard[i]);
      if (fontBold != null) textFont(fontBold);
      textSize(14 * escalaX);
      text(">> SELECCIONADO <<", cx, cy + cardH / 2 - 20 * escalaY);
    }
    rectMode(CORNER);
  }

  // Banner de Aviso simplificado y directo (menos texto)
  rectMode(CENTER);
  fill(45, 16, 22, 230);
  stroke(255, 185, 55);
  strokeWeight(1.8f * escalaX);
  rect(width / 2, 638 * escalaY, 940 * escalaX, 44 * escalaY, 10 * escalaX);
  rectMode(CORNER);

  dibujarIconoAlerta(width / 2 - 430 * escalaX, 638 * escalaY, 12 * escalaX, color(255, 215, 60));
  dibujarIconoAlerta(width / 2 + 430 * escalaX, 638 * escalaY, 12 * escalaX, color(255, 215, 60));
  fill(255, 225, 110);
  if (fontBody != null) textFont(fontBody);
  textSize(14.5f * escalaX);
  text("Aviso: Destellos rápidos de luz. ¡Sigue el ritmo de las notas para no quemar el estofado!", width / 2, 638 * escalaY);

  // Botón inferior "¡EMPEZAR A COCINAR!"
  float btnX = width / 2;
  float btnY = 730 * escalaY;
  boolean hoverEmpezar = (mouseX >= btnX - 220 * escalaX && mouseX <= btnX + 220 * escalaX && mouseY >= btnY - 38 * escalaY && mouseY <= btnY + 38 * escalaY);

  rectMode(CENTER);
  fill(hoverEmpezar ? color(34, 197, 94) : color(22, 163, 74));
  stroke(255, 240, 150);
  strokeWeight(3.0f * escalaX);
  rect(btnX, btnY, 440 * escalaX, 68 * escalaY, 16 * escalaX);

  fill(255);
  if (fontBold != null) textFont(fontBold);
  textSize(24 * escalaX);
  text("¡EMPEZAR A COCINAR! [ENTER]", btnX, btnY);
  rectMode(CORNER);
  popStyle();
}

// Mostrar la imagen completa sin estirarla ni aplastarla.
void dibujarFotoComunidadPixagram(PImage foto, float x, float y, float w, float h) {
  boolean flujoRetornoActivo = true;

  if (foto == null || foto.width <= 0 || foto.height <= 0) {
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    pushStyle();
    imageMode(CORNER);
    rectMode(CORNER);
    noStroke();
    fill(COLOR_CARD);
    rect(x, y, w, h);
    float proporcion = min(w / foto.width, h / foto.height);
    float ancho = foto.width * proporcion;
    float alto = foto.height * proporcion;
    image(foto, x + (w - ancho) / 2, y + (h - alto) / 2, ancho, alto);
    popStyle();

  }
}
