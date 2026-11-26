final int TRANSICION_CIERRE_MS = 210;
final int TRANSICION_APERTURA_MS = 260;
final int TAM_APPS_CELULAR = 10;

int escenaDibujada = -1;
int inicioFundido = -1;
float opacidadInicioFundido = 0;
boolean cerrandoFundido = false;
PImage fotogramaSalida = null;

int seccionVisualActual() {
  if (feriaActiva && feriaResultado()) return 99;
  if (estadoActual == JUEGO) return mostrarSaltarIntro ? 0 : 1;
  if (estadoActual == EXPLORACION) return pisoActual;
  if (estadoActual == NOVELA_ESCUELA) return escenaPorPaginaEscuela[paginaEscuela];
  if (estadoActual == RECUERDOS) return recSeccion;
  if (estadoActual == PENALTIS) {
    if (penEstadoActual == 0 || penEstadoActual == 4) return penEstadoActual;
    return 1; // Apuntar, patear y ver el resultado del tiro forman una sola escena.
  }
  if (estadoActual == NIVEL1 && !enHome) {
    for (int i = 0; i < TAM_APPS_CELULAR; i++) {
      if (nombresApps[i].equals(appAbierta)) {
        int subpantalla = 0;
        if (appAbierta.equals("Parejas")) {
          subpantalla = parEstadoJuego == 1 ? parNivelActual : parMaxNiveles + parEstadoJuego;
        }
        if (appAbierta.equals("Pixel Art") && paEstadoJuego == 1) subpantalla = paCur + 1;
        if (appAbierta.equals("Frutas") && frutaEstadoJuego == 1) {
          subpantalla = frutaEnMenu ? 1 : (frutaPerdio ? 3 : 2);
        }
        return (i + 1) * 32 + subpantalla;
      }
    }
  }
  if (hcActiva) return 10 + hcEtapa;
  if (estadoActual == NIVEL2) return nv2ReiniciarPartida ? NV2_SUB_JUGANDO : nv2SubEstado;
  if (t3Activa) {
    if (t3IntroActiva) return 10;
    if (finalNivel3Activo) return finalNivel3Creditos ? 12 : 11;
    if (t3Etapa != 4) return t3Etapa;
    // El acercamiento a la máquina conserva su propia animación de cámara.
    if (nv3_estadoMenu >= 0) return 20;
    return 30 + nv3_pantalla;
  }
  return 0;
}

int escenaVisualActual() {
  return estadoActual * 1000 + seccionVisualActual();
}

boolean transicionBloqueaEntrada() {
  return enTransicion || alphaTransicion > 0 || fotogramaSalida != null
    || (escenaDibujada >= 0 && escenaDibujada != escenaVisualActual());
}

void prepararTransicionVisual(int escena) {
  if (escenaDibujada >= 0 && escena != escenaDibujada && fotogramaSalida == null
      && alphaTransicion < 255) {
    // JAVA2D conserva el fotograma anterior hasta que dibujamos la escena nueva.
    // Solo se copia al cambiar de escena por una ruta de cambio inmediato.
    fotogramaSalida = get();
    alphaTransicion = 0;
    inicioFundido = -1;
  }
}

void dibujarTransicionGlobal() {
  boolean cerrar = enTransicion || fotogramaSalida != null;
  if (!cerrar && alphaTransicion <= 0) return;

  int ahora = millis();
  if (inicioFundido < 0 || cerrar != cerrandoFundido) {
    inicioFundido = ahora;
    opacidadInicioFundido = alphaTransicion;
    cerrandoFundido = cerrar;
  }
  int duracion = cerrar ? TRANSICION_CIERRE_MS : TRANSICION_APERTURA_MS;
  float t = constrain((ahora - inicioFundido) / float(duracion), 0, 1);
  float curva = t * t * (3 - 2 * t);
  alphaTransicion = lerp(opacidadInicioFundido, cerrar ? 255 : 0, curva);

  pushStyle();
  rectMode(CORNER);
  imageMode(CORNER);
  noTint();
  if (fotogramaSalida != null) image(fotogramaSalida, 0, 0);
  if (alphaTransicion > 0) {
    noStroke();
    fill(9, 12, 24, alphaTransicion);
    rect(0, 0, width, height);
  }
  popStyle();

  if (t >= 1) {
    inicioFundido = -1;
    if (cerrar) {
      if (enTransicion) confirmarCambioDeEstado();
      fotogramaSalida = null;
      escenaDibujada = escenaVisualActual();
    }
  }
}

void confirmarCambioDeEstado() {
  if (animandoEscalera && faseEscalera == 1) iniciarSalidaEscalera();
  if (estadoActual == JUEGO && estadoDestino == EXPLORACION) prepararPresentacionClip();
  if (estadoActual == PADRES && estadoDestino == NIVEL1) {
    reiniciarGuiaCelular();
    guiaPixagramVisita = GUIA_PIXAGRAM_SIN_VISITA;
    enHome = true;
    appAbierta = "";
  }

  // autoguardamos en el archivo plano antes de cambiar de pantalla si estabamos en la historia xd
  if (!skipAutoSaveEnMenu && estadoDestino == MENU && (estadoActual == JUEGO || estadoActual == EXPLORACION || estadoActual == PADRES || estadoActual == DESAYUNO
      || estadoActual == NIVEL1 || estadoActual == NOVELA_ESCUELA || estadoActual == FIN_DIA_1 || estadoActual == TRANSICION_TEMPORAL
      || estadoActual == NOVELA_COCINA || estadoActual == SELECCION_DIF_NV2 || estadoActual == NIVEL2)) {
    guardarPartidaEnArchivo(estadoActual);
  }

  estadoActual = estadoDestino;
  enTransicion = false;

  // si acabamos de avanzar a una nueva escena de la historia, actualizamos el archivo plano
  if (estadoActual == EXPLORACION || estadoActual == PADRES || estadoActual == DESAYUNO || estadoActual == NOVELA_ESCUELA
      || estadoActual == FIN_DIA_1 || estadoActual == TRANSICION_TEMPORAL || estadoActual == NOVELA_COCINA
      || estadoActual == SELECCION_DIF_NV2) {
    guardarPartidaEnArchivo(estadoActual);
  }

  if (estadoActual == MENU) {
    reiniciarPresentacionesClip();
    reiniciarReaccionClip();
    skipAutoSaveEnMenu = false;
    t3Reiniciar();
    reiniciarHistoriaDespuesCocina();
    faseCamaraMenu = 0;
    progresoCamaraCielo = 0.0f;
    escribiendoNombrePartida = false;
    cargarPartidasDesdeArchivo();
    tieneCelular = false;
    paginaPadres = 0;
    feedbackPadresActivo = false;
    habloConPadresPostCelular = false;
    mostrandoDecisionPadres = false;
    decisionPadresDesayuno = 0;
    penaltisJugados = false;
    decisionPixagramTomada = false;
    decisionPixagramPenaltis = 0;
    desayunoComido = false;
    paginaDesayuno = 0;
    dia1Terminado = false;
    timerFinDia1 = 0;
    samCercaDeMesa = false;
    samCercaDeCama = false;
    mostrandoModalDormir = false;
    inicializarChatsDia1();
    paginaCocina = 0;
    mostrandoDecisionCocina = false;
    decisionCocinaTomada = 0;
    totalFeedPosts = 0;
    bienestarDigital = 100.0f;
    reputacionDigital = 15;
    horaReloj = 9;
    minutoReloj = 41;
    desayunoLlamado = false;
    desayunoTarde = false;
    pisoActual = 2;
    pjX = 500;
    pjY = 500;
    direccionSam = "sur";
    samCaminando = false;
    animandoEscalera = false;
    faseEscalera = 0;
    escalaSamEscalera = 1;
    leyendoMensaje = false;
    enPausa = false;
    mostrarOpciones = false;
    mostrarResumenPuntos = false;
    opcionPausaSeleccionada = 0;
    if (reproductorMp3 != null) {
      reproductorMp3.stop();
      reproduciendoMusica = false;
    }
    detenerYReiniciarTodosLosAudiosNv2();
    if (videoCreditos != null) {
      videoCreditos.pause();
    }
    if (videoFondo != null) {
      videoFondo.jump(0.0f);
      videoFondo.play();
      videoFondo.volume(0);
      ultimoReinicioVideo = millis();
    }
  } else {
    if (videoFondo != null) {
      videoFondo.pause();
    }
  }

  if (estadoActual == JUEGO) {
    mostrarSaltarIntro = true;
    opcionSaltarIntro = 1;
  }

  if (estadoActual == CREDITOS) {
    if (videoCreditos != null) {
      videoCreditos.play();
      videoCreditos.volume(volMaster);
    }
  }

  actualizarMusicaFondoPorEstado();
}
