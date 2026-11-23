// =========================================================================
// PESTANA: GUARDADO EN ARCHIVOS PLANOS Y MENU DE PARTIDAS EN EL CIELO
// Algoritmia y Programacion II - Cero clases (puros arreglos paralelos xd)
// y cero else-if (solo condicionales anidados como pidio el profe)
// =========================================================================

// nombre del archivo plano donde guardamos todo en la carpeta data
String ARCHIVO_PARTIDAS = "data/partidas_guardadas.txt";

// =========================================================================
// 1. CATALOGO ESCALABLE DE ESCENAS (ARREGLOS PARALELOS)
// Si mas adelante agregamos el capitulo final de la historia, solo metemos
// el numero de estado y el nombre aca y el guardado sigue funcionando solo xd
// =========================================================================
int totalEscenasCatalogo = 14;
int[] catalogoEscenaId = {
  2,   // JUEGO (Intro cumpleanos)
  4,   // EXPLORACION (Casa de Sam)
  6,   // PADRES (Sala con mama y papa)
  17,  // DESAYUNO (Comedor familiar)
  7,   // NIVEL1 (Celular de Sam)
  8,   // NOVELA_ESCUELA (Camino al colegio)
  9,   // NIVEL1_INTRO (Intro cancha)
  10,  // PENALTIS (Minijuego penaltis)
  16,  // FIN_DIA_1 (Cierre del dia 1)
  13,  // TRANSICION_TEMPORAL (12 dias despues)
  14,  // NOVELA_COCINA (Historia en la cocina)
  15,  // SELECCION_DIF_NV2 (Selector de receta/dificultad)
  11,  // NIVEL2_INTRO (Intro nivel 2)
  12   // NIVEL2 (Minijuego cocina al ritmo)
};

String[] catalogoEscenaNombre = {
  "Cap. 1: El Cumpleaños",
  "Casa de Sam (Exploración)",
  "Sala: Charla con Padres",
  "Comedor: Desayuno Familiar",
  "Explorar el Celular",
  "Colegio: Conversación",
  "Cancha del Colegio",
  "Nivel 1: Tanda de Penaltis",
  "Fin del Primer Día",
  "12 Días Después...",
  "Cap. 2: Tarde en la Cocina",
  "Preparando la Receta",
  "Antes de Cocinar",
  "Nivel 2: Cocina al Ritmo"
};

// =========================================================================
// 2. ARREGLOS PARALELOS DE LAS PARTIDAS GUARDADAS
// =========================================================================
final int MAX_SLOTS_PARTIDA = 2;
boolean[] slotPartidaOcupado = new boolean[MAX_SLOTS_PARTIDA];
String[] slotNombreJugador = new String[MAX_SLOTS_PARTIDA];
int[] slotEstadoEscena = new int[MAX_SLOTS_PARTIDA];
int[] slotSubProgreso = new int[MAX_SLOTS_PARTIDA];
int[] slotPuntajeGuardado = new int[MAX_SLOTS_PARTIDA];
int[] slotBienestarGuardado = new int[MAX_SLOTS_PARTIDA];
int[] slotReputacionGuardada = new int[MAX_SLOTS_PARTIDA];
String[] slotLogroDestacado = new String[MAX_SLOTS_PARTIDA];
String[] slotBanderasExtra = new String[MAX_SLOTS_PARTIDA];

boolean sistemaGuardadoInicializado = false;

// modal sencillo para ponerle nombre a la partida nueva y para confirmar si quiere borrar xd
boolean escribiendoNombrePartida = false;
boolean confirmandoBorrarPartida = false;
String nombreTemporalPartida = "Sam";

// =========================================================================
// 3. VARIABLES DE LA TRANSICION ESTILO STARDEW VALLEY (CAMARA AL CIELO)
// faseCamaraMenu: 0 = menu normal abajo, 1 = subiendo al cielo,
//                 2 = en el cielo (seleccion de partida), 3 = bajando al menu
// =========================================================================
int faseCamaraMenu = 0;
float progresoCamaraCielo = 0.0f;
int ultimoMillisCielo = 0;
int ultimoReinicioVideo = 0;

// =========================================================================
// 4. ARREGLOS PARALELOS DE LOS RECUADROS FLOTANTES EN EL CIELO
// Indice 0: Recuadro Partida Guardada
// Indice 1: Recuadro '+' Nueva Partida
// Indice 2: Boton Volver al Menu Principal
// =========================================================================
final int TOTAL_CARDS_CIELO = 3;
float[] cardCieloX = new float[TOTAL_CARDS_CIELO];
float[] cardCieloY = new float[TOTAL_CARDS_CIELO];
float[] cardCieloW = new float[TOTAL_CARDS_CIELO];
float[] cardCieloH = new float[TOTAL_CARDS_CIELO];
float[] cardCieloEscala = { 1.0f, 1.0f, 1.0f };
float[] cardCieloHoverLerp = { 0.0f, 0.0f, 0.0f };
float[] cardCieloFaseSin = { 0.0f, 1.85f, 3.40f };
int cardCieloSeleccionada = -1;
int ultimaCardCieloHover = -1;

// =========================================================================
// 5. BUFFERS PGRAPHICS PRE-RENDERIZADOS PARA 60 FPS CLAVADOS EN JAVA2D
// Se dibujan una sola vez (o cuando cambia la partida) y en draw() solo se
// hace image(pg, x, y) de 3 parametros sin calcular bordes ni textos por frame xd
// =========================================================================
PGraphics pgFondoCieloCache = null;
boolean fondoCieloCacheListo = false;

PGraphics pgCartelTituloCielo = null;
PGraphics pgCardGuardadaNormal = null;
PGraphics pgCardGuardadaHover = null;
PGraphics pgCardNuevaNormal = null;
PGraphics pgCardNuevaHover = null;
PGraphics pgBtnVolverNormal = null;
PGraphics pgBtnVolverHover = null;
PGraphics pgBtnBorrarNormal = null;
PGraphics pgBtnBorrarHover = null;
PGraphics pgAvisoEliminada = null;
boolean cacheTarjetasCieloListo = false;
boolean ultimoEstadoHayPartidaCache = false;

boolean hoverBtnBorrarPartida = false;
boolean ultimoHoverBtnBorrar = false;
float btnBorrarX = 0;
float btnBorrarY = 0;
float btnBorrarW = 0;
float btnBorrarH = 0;
int tiempoAvisoPartidaEliminada = -10000;


// =========================================================================
// FUNCIONES DE INICIALIZACION Y ARCHIVOS PLANOS (saveStrings / loadStrings)
// =========================================================================

void inicializarSistemaGuardadoYCielo() {
  // inicializamos los arreglos paralelos por defecto para evitar nulls xd
  for (int i = 0; i < MAX_SLOTS_PARTIDA; i++) {
    slotPartidaOcupado[i] = false;
    slotNombreJugador[i] = "Sam";
    slotEstadoEscena[i] = JUEGO;
    slotSubProgreso[i] = 0;
    slotPuntajeGuardado[i] = 0;
    slotBienestarGuardado[i] = 100;
    slotReputacionGuardada[i] = 15;
    slotLogroDestacado[i] = "Bienestar: 100% | Logros: 0/" + totalLogros;
    slotBanderasExtra[i] = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,000000000";
  }

  cargarPartidasDesdeArchivo();
  sistemaGuardadoInicializado = true;
}

// busca el nombre de la escena en el catalogo paralelo para que sea escalable
String obtenerNombreEscenaCatalogo(int idEstado, int subProg) {
  String nombreEncontrado = "Capítulo Nuevo (Escena " + idEstado + ")";

  for (int i = 0; i < totalEscenasCatalogo; i++) {
    if (catalogoEscenaId[i] == idEstado) {
      nombreEncontrado = catalogoEscenaNombre[i];
    }
  }

  // detalle extra por si esta en la casa de noche o en el segundo piso xd
  if (idEstado == EXPLORACION) {
    if (subProg == 1) {
      nombreEncontrado = "Casa de Sam (Primer Piso)";
    } else {
      nombreEncontrado = "Casa de Sam (Habitación)";
    }
  }
  return nombreEncontrado;
}

// cuenta cuantos logros lleva desbloqueados el jugador
int contarLogrosDesbloqueadosActuales() {
  int cant = 0;
  for (int i = 0; i < totalLogros; i++) {
    if (logrosDesbloqueados[i]) {
      cant++;
    }
  }
  return cant;
}

// guarda los datos actuales de la partida en el slot 0 y escribe el archivo .txt
void guardarPartidaEnArchivo(int estadoParaGuardar) {
  if (!feriaActiva) {

  if (!sistemaGuardadoInicializado) {
    inicializarSistemaGuardadoYCielo();
  }

  // si se guarda desde el celular o algo intermedio, aseguramos un estado valido
  int estReal = estadoParaGuardar;
  if (estReal == CARGA || estReal == MENU || estReal == CREDITOS || estReal == LOGROS) {
    estReal = EXPLORACION;
  }

  // calculamos el sub-progreso dependiendo de la escena donde este Sam
  int subProg = 0;
  if (estReal == JUEGO) {
    subProg = paginaActual;
  } else {
    if (estReal == EXPLORACION) {
      subProg = pisoActual;
    } else {
      if (estReal == PADRES) {
        subProg = paginaPadres;
      } else {
        if (estReal == DESAYUNO) {
          subProg = paginaDesayuno;
        } else {
          if (estReal == NOVELA_ESCUELA) {
            subProg = paginaEscuela;
          } else {
            if (estReal == NOVELA_COCINA) {
              subProg = paginaCocina;
            }
          }
        }
      }
    }
  }

  slotPartidaOcupado[0] = true;
  if (playerName != null && playerName.trim().length() > 0) {
    slotNombreJugador[0] = playerName.trim();
  } else {
    if (slotNombreJugador[0] == null || slotNombreJugador[0].trim().length() == 0) {
      slotNombreJugador[0] = "Sam";
    }
  }

  slotEstadoEscena[0] = estReal;
  slotSubProgreso[0] = subProg;
  slotPuntajeGuardado[0] = puntosJugador;
  slotBienestarGuardado[0] = round(constrain(bienestarDigital, 0, 100));
  slotReputacionGuardada[0] = reputacionDigital;

  int cantLogros = contarLogrosDesbloqueadosActuales();
  slotLogroDestacado[0] = "Bienestar: " + slotBienestarGuardado[0] + "%  |  Logros: " + cantLogros + "/" + totalLogros;

  // armamos la cadena de banderas de historia para que al cargar todo siga igualito
  String bitsLogros = "";
  for (int i = 0; i < totalLogros; i++) {
    if (logrosDesbloqueados[i]) {
      bitsLogros = bitsLogros + "1";
    } else {
      bitsLogros = bitsLogros + "0";
    }
  }

  String extra = (tieneCelular ? "1" : "0") + ","
               + (desayunoComido ? "1" : "0") + ","
               + (penaltisJugados ? "1" : "0") + ","
               + (dia1Terminado ? "1" : "0") + ","
               + (juegosDesbloqueados ? "1" : "0") + ","
               + (habloConPadresPostCelular ? "1" : "0") + ","
               + (feedbackPadresActivo ? "1" : "0") + ","
               + decisionPadresDesayuno + ","
               + (decisionPixagramTomada ? "1" : "0") + ","
               + decisionPixagramPenaltis + ","
               + decisionCocinaTomada + ","
               + goles + ","
               + nv2Dificultad + ","
               + ptsCatExploracion + ","
               + ptsCatPenaltis + ","
               + ptsCatDecisiones + ","
               + ptsCatCocina + ","
               + ptsCatLogros + ","
               + bitsLogros;

  slotBanderasExtra[0] = extra;
  cacheTarjetasCieloListo = false;

  escribirArreglosEnTxt();

  }
}

// limpia todos los datos del slot en los arreglos paralelos y actualiza el archivo .txt
void borrarPartidaGuardada(int slotIdx) {
  if (slotIdx >= 0 && slotIdx < MAX_SLOTS_PARTIDA) {
    slotPartidaOcupado[slotIdx] = false;
    slotNombreJugador[slotIdx] = "Sam";
    slotEstadoEscena[slotIdx] = JUEGO;
    slotSubProgreso[slotIdx] = 0;
    slotPuntajeGuardado[slotIdx] = 0;
    slotBienestarGuardado[slotIdx] = 100;
    slotReputacionGuardada[slotIdx] = 15;
    slotLogroDestacado[slotIdx] = "Bienestar: 100% | Logros: 0/" + totalLogros;
    slotBanderasExtra[slotIdx] = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,000000000";

    escribirArreglosEnTxt();

    hoverBtnBorrarPartida = false;
    ultimoHoverBtnBorrar = false;
    confirmandoBorrarPartida = false;
    cardCieloSeleccionada = -1;
    cacheTarjetasCieloListo = false;
    tiempoAvisoPartidaEliminada = millis();
  }
}

// pasa los arreglos paralelos al archivo plano usando saveStrings
void escribirArreglosEnTxt() {
  try {
    // primera linea: encabezado explicativo, siguientes lineas: slots separados por ';'
    String[] lineasArchivo = new String[MAX_SLOTS_PARTIDA + 1];
    lineasArchivo[0] = "# ARCHIVO DE PARTIDAS SAM THINKS A LOT: ocupado;nombre;escenaId;subProgreso;puntaje;bienestar;reputacion;estadisticaClave;banderasExtra";

    for (int i = 0; i < MAX_SLOTS_PARTIDA; i++) {
      String ocup = slotPartidaOcupado[i] ? "1" : "0";
      String nomLimpio = slotNombreJugador[i].replace(";", ",");
      String estLimpia = slotLogroDestacado[i].replace(";", ",");
      lineasArchivo[i + 1] = ocup + ";"
                           + nomLimpio + ";"
                           + slotEstadoEscena[i] + ";"
                           + slotSubProgreso[i] + ";"
                           + slotPuntajeGuardado[i] + ";"
                           + slotBienestarGuardado[i] + ";"
                           + slotReputacionGuardada[i] + ";"
                           + estLimpia + ";"
                           + slotBanderasExtra[i];
    }

    saveStrings(dataPath("partidas_guardadas.txt"), lineasArchivo);
  } catch (Exception e) {
    println("Uy hubo un problema guardando partidas_guardadas.txt: " + e.getMessage());
  }
}

// lee el archivo plano con loadStrings y llena los arreglos paralelos
void cargarPartidasDesdeArchivo() {
  try {
    File f = dataFile("partidas_guardadas.txt");
    if (f.exists()) {
      String[] lineas = loadStrings("partidas_guardadas.txt");
      if (lineas != null && contarCadenas(lineas) > 0) {
        int slotIdx = 0;
        for (int i = 0; i < contarCadenas(lineas); i++) {
          String lin = trim(lineas[i]);
          if (lin.length() > 0 && !lin.startsWith("#") && slotIdx < MAX_SLOTS_PARTIDA) {
            String[] partes = split(lin, ';');
            if (partes != null && contarCadenas(partes) >= 9) {
              slotPartidaOcupado[slotIdx] = partes[0].equals("1");
              slotNombreJugador[slotIdx] = partes[1];
              slotEstadoEscena[slotIdx] = int(partes[2]);
              slotSubProgreso[slotIdx] = int(partes[3]);
              slotPuntajeGuardado[slotIdx] = int(partes[4]);
              slotBienestarGuardado[slotIdx] = int(partes[5]);
              slotReputacionGuardada[slotIdx] = int(partes[6]);
              slotLogroDestacado[slotIdx] = partes[7];
              slotBanderasExtra[slotIdx] = partes[8];
              slotIdx++;
            }
          }
        }
      }
    }
    cacheTarjetasCieloListo = false;
  } catch (Exception e) {
    println("No se pudo leer partidas_guardadas.txt (se creara uno nuevo): " + e.getMessage());
  }
}

// restaura en el juego todas las variables guardadas en el slot 0
void aplicarPartidaCargadaAlJuego(int slotIdx) {
  if (slotIdx >= 0 && slotIdx < MAX_SLOTS_PARTIDA) {
    if (slotPartidaOcupado[slotIdx]) {
      detenerMediosParaSaltoDebug();
      inicializarChatsDia1();
      mostrandoModalDormir = false;
      dialogoCamaActivo = false;
      leyendoMensaje = false;
      mostrandoDecisionPadres = false;
      mostrandoDecisionCocina = false;
      playerName = slotNombreJugador[slotIdx];
      puntosJugador = slotPuntajeGuardado[slotIdx];
      puntosMostradosLerp = puntosJugador;
      bienestarDigital = slotBienestarGuardado[slotIdx];
      bienestarVisualLerp = bienestarDigital;
      reputacionDigital = slotReputacionGuardada[slotIdx];
      reputacionVisualLerp = reputacionDigital;

      // restauramos las banderas de progreso desde el arreglo paralelo
      String[] ext = split(slotBanderasExtra[slotIdx], ',');
      if (ext != null && contarCadenas(ext) >= 19) {
        tieneCelular = ext[0].equals("1");
        desayunoComido = ext[1].equals("1");
        penaltisJugados = ext[2].equals("1");
        dia1Terminado = ext[3].equals("1");
        juegosDesbloqueados = ext[4].equals("1");
        habloConPadresPostCelular = ext[5].equals("1");
        feedbackPadresActivo = ext[6].equals("1");
        decisionPadresDesayuno = int(ext[7]);
        decisionPixagramTomada = ext[8].equals("1");
        decisionPixagramPenaltis = int(ext[9]);
        decisionCocinaTomada = int(ext[10]);
        goles = int(ext[11]);
        nv2Dificultad = constrain(int(ext[12]), 0, 3);
        ptsCatExploracion = int(ext[13]);
        ptsCatPenaltis = int(ext[14]);
        ptsCatDecisiones = int(ext[15]);
        ptsCatCocina = int(ext[16]);
        ptsCatLogros = int(ext[17]);

        String bitsLog = ext[18];
        for (int l = 0; l < totalLogros && l < bitsLog.length(); l++) {
          logrosDesbloqueados[l] = (leerCaracter(bitsLog, l) == '1');
        }
        cargarLogrosGlobales();
        guardarLogrosGlobales();
      }

      int escenaDestino = slotEstadoEscena[slotIdx];
      int subProg = slotSubProgreso[slotIdx];

      // configuramos el punto exacto de la escena cargada
      ultimoTextoDialogo = "";
      charsVisibles = 0;
      dialogoCompletado = false;
      enPausa = false;
      mostrarOpciones = false;

      if (escenaDestino == JUEGO) {
        paginaActual = constrain(subProg, 0, totalPaginasLore - 1);
        mostrarSaltarIntro = (paginaActual == 0);
      } else {
        if (escenaDestino == EXPLORACION) {
          pisoActual = (subProg == 1) ? 1 : 2;
          animandoEscalera = false;
          faseEscalera = 0;
          samCaminando = false;
          direccionSam = "sur";
          if (pisoActual == 1) {
            // aparecemos en la zona libre al pie de la escalera (lejos de la hitbox de la mesa obs[1] xd)
            pjX = width * 0.68f;
            pjY = height * 0.28f;
          } else {
            // posicion libre en la habitacion (lejos de la cama obs[1])
            pjX = width * 0.35f;
            pjY = height * 0.48f;
          }
        } else {
          if (escenaDestino == PADRES) {
            int limitePadres = totalPaginasPadresInicial;
            if (feedbackPadresActivo) limitePadres = totalPaginasPadresFeedback;
            paginaPadres = constrain(subProg, 0, limitePadres - 1);
          } else {
            if (escenaDestino == DESAYUNO) {
              paginaDesayuno = constrain(subProg, 0, TOTAL_PAGS_DESAYUNO - 1);
            } else {
              if (escenaDestino == NOVELA_ESCUELA) {
                paginaEscuela = constrain(subProg, 0, totalPaginasEscuela - 1);
              } else {
                if (escenaDestino == NOVELA_COCINA) {
                  paginaCocina = constrain(subProg, 0, totalPaginasCocina - 1);
                } else {
                  if (escenaDestino == NIVEL2) {
                    nv2ReiniciarPartida = true;
                  }
                }
              }
            }
          }
        }
      }

      if (penaltisJugados) {
        desbloquearSmsPostPenaltis();
        if (!decisionPixagramTomada) {
          prepararPostPixagramPenaltis();
        }
      }

      faseCamaraMenu = 0;
      progresoCamaraCielo = 0.0f;
      estadoDestino = escenaDestino;
      enTransicion = true;
    }
  }
}

// reinicia las variables para empezar una partida desde cero y la guarda en el archivo
void iniciarNuevaPartidaDesdeCielo(String nombreElegido) {
  String nomFinal = trim(nombreElegido);
  if (nomFinal.length() == 0) {
    nomFinal = "Sam";
  }

  playerName = nomFinal;
  slotNombreJugador[0] = nomFinal;
  detenerMediosParaSaltoDebug();
  mostrandoModalDormir = false;
  dialogoCamaActivo = false;
  leyendoMensaje = false;
  paginaEscuela = 0;
  penEstadoActual = 0;
  tiroActual = 1;
  goles = 0;
  atajadas = 0;
  fallos = 0;
  nv2ReiniciarPartida = false;
  nv2AutoPlayBot = false;
  recompensaNivel2Otorgada = false;
  paIniciado = false;
  parIniciado = false;
  frutaIniciado = false;
  horaReloj = 9;
  minutoReloj = 41;
  desayunoLlamado = false;
  desayunoTarde = false;
  cantTeclasDir = 0;

  // reseteamos el progreso de la historia para empezar limpio
  puntosJugador = 0;
  puntosMostradosLerp = 0;
  ptsCatExploracion = 0;
  ptsCatPenaltis = 0;
  ptsCatDecisiones = 0;
  ptsCatCocina = 0;
  ptsCatLogros = 0;
  bienestarDigital = 100.0f;
  bienestarVisualLerp = 100.0f;
  reputacionDigital = 15;
  reputacionVisualLerp = 15.0f;

  tieneCelular = false;
  paginaActual = 0;
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
  juegosDesbloqueados = false;
  timerFinDia1 = 0;
  paginaCocina = 0;
  mostrandoDecisionCocina = false;
  decisionCocinaTomada = 0;
  pisoActual = 2;
  animandoEscalera = false;
  faseEscalera = 0;
  samCaminando = false;
  direccionSam = "sur";
  pjX = width * 0.35f;
  pjY = height * 0.48f;
  ultimoTextoDialogo = "";
  charsVisibles = 0;
  dialogoCompletado = false;
  inicializarChatsDia1();

  // guardamos el estado inicial en el archivo .txt
  guardarPartidaEnArchivo(JUEGO);

  escribiendoNombrePartida = false;
  faseCamaraMenu = 0;
  progresoCamaraCielo = 0.0f;
  estadoDestino = JUEGO;
  enTransicion = true;
}


// =========================================================================
// DIBUJO DE LA TRANSICION ESTILO STARDEW VALLEY Y EL MENU EN EL CIELO
// (Optimizado a 60 FPS: sin tint(), con pushMatrix/scale y sin deriveFont xd)
// =========================================================================

void actualizarCamaraMenuCielo() {
  if (!sistemaGuardadoInicializado) {
    inicializarSistemaGuardadoYCielo();
  }

  int ahora = millis();
  float dt = 0.016f;
  if (ultimoMillisCielo > 0) {
    dt = constrain((ahora - ultimoMillisCielo) / 1000.0f, 0.001f, 0.08f);
  }
  ultimoMillisCielo = ahora;

  // actualizamos el progreso de la camara basado en millis() y lerp agil (~0.5s de recorrido)
  if (faseCamaraMenu == 1) {
    progresoCamaraCielo = lerp(progresoCamaraCielo, 1.0f, 0.16f) + (dt * 1.15f);
    if (progresoCamaraCielo >= 0.99f) {
      progresoCamaraCielo = 1.0f;
      faseCamaraMenu = 2;
    }
  } else {
    if (faseCamaraMenu == 3) {
      escribiendoNombrePartida = false;
      confirmandoBorrarPartida = false;
      progresoCamaraCielo = lerp(progresoCamaraCielo, 0.0f, 0.16f) - (dt * 1.20f);
      if (progresoCamaraCielo <= 0.01f) {
        progresoCamaraCielo = 0.0f;
        faseCamaraMenu = 0;
      }
    }
  }
}

// curva smoothstep para que el movimiento de camara empiece y termine suavecito
float obtenerCurvaSuaveCielo() {
  float t = constrain(progresoCamaraCielo, 0.0f, 1.0f);
  return t * t * (3.0f - 2.0f * t);
}

// dibuja el video de fondo aplicando el zoom y paneo hacia la esquina superior derecha
// optimizado para JAVA2D: sin Bicubic lento y actualizando pgFondoCieloCache solo cuando llega frame nuevo xd
void dibujarVideoFondoConCamaraCielo() {
  actualizarCamaraMenuCielo();
  float curva = obtenerCurvaSuaveCielo();

  noTint();
  imageMode(CORNER);

  if (videoFondo != null) {
    // reiniciamos el video cada 8.7s usando millis() sin llamar a time()/duration() para no dar lag en GStreamer xd
    if (ultimoReinicioVideo == 0 || millis() - ultimoReinicioVideo > 8700) {
      videoFondo.jump(0.0f);
      videoFondo.play();
      ultimoReinicioVideo = millis();
    }

    // leemos frame nuevo solo cuando este disponible en cualquier fase para que las nubes y el sol sigan animados
    if (videoFondo.available()) {
      videoFondo.read();
      fondoCieloCacheListo = false;
    }

    if (videoFondo.width > 0 && videoFondo.height > 0) {
      if (curva <= 0.001f) {
        noSmooth();
        image(videoFondo, 0, 0, width, height);
        smooth(2);
      } else {
        if (faseCamaraMenu == 2) {
          // en el cielo: actualizamos pgFondoCieloCache con noSmooth() cada vez que llega un frame nuevo del video
          // y en los demas frames de draw() dibujamos la cache 1:1 en <0.2ms para mantener 60 FPS con nubes animadas
          if (!fondoCieloCacheListo || pgFondoCieloCache == null || pgFondoCieloCache.width != width || pgFondoCieloCache.height != height) {
            if (pgFondoCieloCache == null || pgFondoCieloCache.width != width || pgFondoCieloCache.height != height) {
              pgFondoCieloCache = createGraphics(width, height);
            }
            float vw = videoFondo.width;
            float vh = videoFondo.height;
            float cropW = vw * 0.45f;
            float cropH = vh * 0.45f;
            int sx1 = int((vw - cropW) * 0.88f);
            int sy1 = int((vh - cropH) * 0.06f);
            int sx2 = int(sx1 + cropW);
            int sy2 = int(sy1 + cropH);

            pgFondoCieloCache.beginDraw();
            pgFondoCieloCache.noSmooth();
            pgFondoCieloCache.noTint();
            pgFondoCieloCache.imageMode(CORNER);
            pgFondoCieloCache.image(videoFondo, 0, 0, width, height, sx1, sy1, sx2, sy2);
            pgFondoCieloCache.endDraw();
            fondoCieloCacheListo = true;
          }
          image(pgFondoCieloCache, 0, 0);
        } else {
          // durante el paneo de 0.5s desactivamos el filtro bicubico de JAVA2D para que escale instantaneo
          float vw = videoFondo.width;
          float vh = videoFondo.height;
          float cropW = lerp(vw, vw * 0.45f, curva);
          float cropH = lerp(vh, vh * 0.45f, curva);

          int sx1 = int((vw - cropW) * 0.88f);
          int sy1 = int((vh - cropH) * 0.06f);
          int sx2 = int(sx1 + cropW);
          int sy2 = int(sy1 + cropH);

          noSmooth();
          image(videoFondo, 0, 0, width, height, sx1, sy1, sx2, sy2);
          smooth(2);
        }
      }
    } else {
      background(95, 165, 235);
    }
  } else {
    background(95, 165, 235);
  }
}

// pre-renderiza todas las tarjetas en objetos PGraphics una sola vez para no dibujar rect() ni text() en cada frame
void construirCacheTarjetasCielo() {
  boolean hayPartida = slotPartidaOcupado[0];

  cardCieloW[0] = 470 * escalaX;
  cardCieloH[0] = 360 * escalaY;
  if (!hayPartida) {
    cardCieloW[1] = 360 * escalaX;
    cardCieloH[1] = 350 * escalaY;
  } else {
    cardCieloW[1] = 320 * escalaX;
    cardCieloH[1] = 360 * escalaY;
  }
  cardCieloW[2] = 280 * escalaX;
  cardCieloH[2] = 58 * escalaY;

  // 1. Pre-renderizar cartel de titulo superior
  int titW = max(20, int(470 * escalaX));
  int titH = max(20, int(62 * escalaY));
  pgCartelTituloCielo = createGraphics(titW + 8, titH + 8);
  pgCartelTituloCielo.beginDraw();
  pgCartelTituloCielo.smooth(2);
  if (fuenteComic != null) {
    pgCartelTituloCielo.textFont(fuenteComic);
  }
  dibujarCajaMaderaEnPG(pgCartelTituloCielo, 4, 4, titW, titH, false);
  pgCartelTituloCielo.textAlign(CENTER, CENTER);
  pgCartelTituloCielo.textSize(max(12, int(25 * escalaX)));
  pgCartelTituloCielo.fill(100, 50, 20);
  pgCartelTituloCielo.text("SELECCIÓN DE PARTIDA", 4 + titW / 2.0f + 2, 4 + titH / 2.0f + 2);
  pgCartelTituloCielo.fill(255);
  pgCartelTituloCielo.text("SELECCIÓN DE PARTIDA", 4 + titW / 2.0f, 4 + titH / 2.0f);
  pgCartelTituloCielo.endDraw();

  // 2. Pre-renderizar tarjeta de Partida Guardada (Normal y Hover)
  if (hayPartida) {
    pgCardGuardadaNormal = crearPGCardGuardada(cardCieloW[0], cardCieloH[0], false);
    pgCardGuardadaHover = crearPGCardGuardada(cardCieloW[0] * 1.045f, cardCieloH[0] * 1.045f, true);
  }

  // 3. Pre-renderizar tarjeta '+' Nueva Partida (Normal y Hover)
  pgCardNuevaNormal = crearPGCardNueva(cardCieloW[1], cardCieloH[1], false, hayPartida);
  pgCardNuevaHover = crearPGCardNueva(cardCieloW[1] * 1.045f, cardCieloH[1] * 1.045f, true, hayPartida);

  // 4. Pre-renderizar boton Volver al Menu (Normal y Hover)
  pgBtnVolverNormal = crearPGBtnVolver(cardCieloW[2], cardCieloH[2], false);
  pgBtnVolverHover = crearPGBtnVolver(cardCieloW[2] * 1.045f, cardCieloH[2] * 1.045f, true);

  // 5. Pre-renderizar boton de Borrar Partida (papelera estilizada Normal y Hover terracota)
  btnBorrarW = 42 * escalaX;
  btnBorrarH = 42 * escalaY;
  pgBtnBorrarNormal = crearPGBtnBorrar(btnBorrarW, btnBorrarH, false);
  pgBtnBorrarHover = crearPGBtnBorrar(btnBorrarW * 1.08f, btnBorrarH * 1.08f, true);

  // 6. Pre-renderizar cartelito flotante de "Partida eliminada"
  int avW = max(20, int(310 * escalaX));
  int avH = max(20, int(48 * escalaY));
  pgAvisoEliminada = createGraphics(avW + 8, avH + 8);
  pgAvisoEliminada.beginDraw();
  pgAvisoEliminada.smooth(2);
  if (fuenteComic != null) {
    pgAvisoEliminada.textFont(fuenteComic);
  }
  pgAvisoEliminada.rectMode(CORNER);
  pgAvisoEliminada.fill(175, 72, 48);
  pgAvisoEliminada.stroke(95, 35, 18);
  pgAvisoEliminada.strokeWeight(3.5f);
  pgAvisoEliminada.rect(4, 4, avW, avH, 8);
  pgAvisoEliminada.noStroke();
  pgAvisoEliminada.fill(205, 98, 72);
  pgAvisoEliminada.rect(8, 8, avW - 8, avH * 0.42f, 4);
  pgAvisoEliminada.textAlign(CENTER, CENTER);
  pgAvisoEliminada.textSize(max(11, int(19 * escalaX)));
  pgAvisoEliminada.fill(75, 25, 10);
  pgAvisoEliminada.text("Partida eliminada", 4 + avW / 2.0f + 1.5f, 4 + avH / 2.0f + 1.5f);
  pgAvisoEliminada.fill(255, 245, 230);
  pgAvisoEliminada.text("Partida eliminada", 4 + avW / 2.0f, 4 + avH / 2.0f);
  pgAvisoEliminada.endDraw();

  ultimoEstadoHayPartidaCache = hayPartida;
  cacheTarjetasCieloListo = true;
}

void dibujarCajaMaderaEnPG(PGraphics pg, float x, float y, float w, float h, boolean resaltado) {
  pg.rectMode(CORNER);
  if (resaltado) {
    pg.fill(255, 220, 100);
  } else {
    pg.fill(180, 120, 60);
  }
  pg.stroke(100, 50, 20);
  pg.strokeWeight(4);
  pg.rect(x, y, w, h, 8);

  pg.noStroke();
  if (resaltado) {
    pg.fill(255, 232, 130);
  } else {
    pg.fill(192, 138, 78);
  }
  pg.rect(x + 4, y + 4, w - 8, min(h * 0.42f, 38 * escalaY), 4);
}

PGraphics crearPGCardGuardada(float wF, float hF, boolean esHover) {
  int w = max(20, int(wF));
  int h = max(20, int(hF));
  float factorEsc = esHover ? 1.045f : 1.0f;
  PGraphics pg = createGraphics(w + 8, h + 8);
  pg.beginDraw();
  pg.smooth(2);
  if (fuenteComic != null) {
    pg.textFont(fuenteComic);
  }
  float x = 4;
  float y = 4;

  if (esHover) {
    pg.fill(235, 190, 85);
    pg.stroke(140, 70, 20);
  } else {
    pg.fill(180, 120, 60);
    pg.stroke(100, 50, 20);
  }
  pg.strokeWeight(4);
  pg.rect(x, y, w, h, 10);

  pg.noStroke();
  if (esHover) {
    pg.fill(250, 222, 125);
  } else {
    pg.fill(192, 138, 78);
  }
  pg.rect(x + 5, y + 5, w - 10, 46 * escalaY * factorEsc, 6);

  float pad = 20 * escalaX * factorEsc;
  float innerX = x + pad;
  float innerY = y + 58 * escalaY * factorEsc;
  float innerW = w - (pad * 2.0f);
  float innerH = h - (118 * escalaY * factorEsc);

  pg.fill(112, 64, 28);
  pg.stroke(80, 40, 15);
  pg.strokeWeight(2);
  pg.rect(innerX, innerY, innerW, innerH, 8);

  pg.textAlign(CENTER, CENTER);
  pg.textSize(max(12, int(21 * escalaX * factorEsc)));
  pg.fill(80, 35, 10);
  pg.text("PARTIDA GUARDADA", x + w / 2.0f + 1.5f, y + 29 * escalaY * factorEsc + 1.5f);
  pg.fill(255, 248, 220);
  pg.text("PARTIDA GUARDADA", x + w / 2.0f, y + 29 * escalaY * factorEsc);

  pg.textAlign(LEFT, TOP);
  pg.textSize(max(12, int(23 * escalaX * factorEsc)));
  pg.fill(255, 225, 110);
  pg.text("Jugador: " + slotNombreJugador[0], innerX + 18 * escalaX * factorEsc, innerY + 14 * escalaY * factorEsc);

  String nomEscena = obtenerNombreEscenaCatalogo(slotEstadoEscena[0], slotSubProgreso[0]);
  pg.textSize(max(11, int(17 * escalaX * factorEsc)));
  pg.fill(255);
  pg.text("Progreso: " + nomEscena, innerX + 18 * escalaX * factorEsc, innerY + 52 * escalaY * factorEsc);

  pg.textSize(max(11, int(18 * escalaX * factorEsc)));
  pg.fill(150, 245, 165);
  pg.text("Puntaje Total: " + slotPuntajeGuardado[0] + " pts", innerX + 18 * escalaX * factorEsc, innerY + 86 * escalaY * factorEsc);

  int cantLogros = contarLogrosDesbloqueadosActuales();
  int bienGuardado = constrain(slotBienestarGuardado[0], 0, 100);
  pg.textSize(max(10, int(15 * escalaX * factorEsc)));
  pg.fill(245, 230, 200);
  pg.text("Bienestar Digital: " + bienGuardado + "%   |   Logros: " + cantLogros + "/" + totalLogros, innerX + 18 * escalaX * factorEsc, innerY + 122 * escalaY * factorEsc);

  float bx = innerX + 18 * escalaX * factorEsc;
  float by = innerY + 152 * escalaY * factorEsc;
  float bw = innerW - 36 * escalaX * factorEsc;
  float bh = 16 * escalaY * factorEsc;

  pg.fill(60, 30, 12);
  pg.stroke(140, 85, 40);
  pg.strokeWeight(1.5f);
  pg.rect(bx, by, bw, bh, 5);

  pg.noStroke();
  if (bienGuardado >= 60) {
    pg.fill(100, 225, 125);
  } else {
    if (bienGuardado >= 35) {
      pg.fill(255, 205, 70);
    } else {
      pg.fill(245, 85, 85);
    }
  }
  pg.rect(bx + 2, by + 2, max(0, (bw - 4) * (bienGuardado / 100.0f)), bh - 4, 4);

  pg.textAlign(CENTER, CENTER);
  pg.textSize(max(11, int(18 * escalaX * factorEsc)));
  if (esHover) {
    pg.fill(50, 20, 0);
    pg.text("» CLIC PARA CONTINUAR PARTIDA «", x + w / 2.0f, y + h - 28 * escalaY * factorEsc);
  } else {
    pg.fill(90, 42, 15);
    pg.text("CLIC PARA CONTINUAR PARTIDA", x + w / 2.0f + 1.5f, y + h - 28 * escalaY * factorEsc + 1.5f);
    pg.fill(255, 250, 230);
    pg.text("CLIC PARA CONTINUAR PARTIDA", x + w / 2.0f, y + h - 28 * escalaY * factorEsc);
  }

  pg.endDraw();
  return pg;
}

PGraphics crearPGCardNueva(float wF, float hF, boolean esHover, boolean hayPartida) {
  int w = max(20, int(wF));
  int h = max(20, int(hF));
  float factorEsc = esHover ? 1.045f : 1.0f;
  PGraphics pg = createGraphics(w + 8, h + 8);
  pg.beginDraw();
  pg.smooth(2);
  if (fuenteComic != null) {
    pg.textFont(fuenteComic);
  }
  float x = 4;
  float y = 4;

  if (esHover) {
    pg.fill(255, 220, 100);
    pg.stroke(140, 70, 20);
  } else {
    pg.fill(180, 120, 60);
    pg.stroke(100, 50, 20);
  }
  pg.strokeWeight(4);
  pg.rect(x, y, w, h, 10);

  pg.noStroke();
  if (esHover) {
    pg.fill(255, 232, 130);
  } else {
    pg.fill(192, 138, 78);
  }
  pg.rect(x + 5, y + 5, w - 10, 46 * escalaY * factorEsc, 6);

  float marcoTam = 146 * escalaY * factorEsc;
  float mcx = x + w / 2.0f;
  float mcy = y + (h * 0.43f);

  if (esHover) {
    pg.fill(135, 82, 36);
  } else {
    pg.fill(115, 65, 28);
  }
  pg.stroke(85, 42, 15);
  pg.strokeWeight(3.5f);
  pg.rectMode(CENTER);
  pg.rect(mcx, mcy, marcoTam, marcoTam, 16);

  pg.noFill();
  pg.stroke(255, 225, 130);
  pg.strokeWeight(2);
  pg.rect(mcx, mcy, marcoTam - 12 * escalaX * factorEsc, marcoTam - 12 * escalaY * factorEsc, 12);

  float brazoLargo = 58 * escalaX * factorEsc;
  float brazoGrosor = 16 * escalaX * factorEsc;
  pg.noStroke();
  pg.fill(70, 30, 10);
  pg.rect(mcx + 2, mcy + 3, brazoLargo, brazoGrosor, 5);
  pg.rect(mcx + 2, mcy + 3, brazoGrosor, brazoLargo, 5);

  if (esHover) {
    pg.fill(255, 250, 210);
  } else {
    pg.fill(255, 235, 165);
  }
  pg.rect(mcx, mcy, brazoLargo, brazoGrosor, 5);
  pg.rect(mcx, mcy, brazoGrosor, brazoLargo, 5);

  pg.rectMode(CORNER);
  pg.textAlign(CENTER, CENTER);
  pg.textSize(max(12, int(22 * escalaX * factorEsc)));
  if (esHover) {
    pg.fill(50, 20, 0);
    pg.text("+ NUEVA PARTIDA", mcx, y + h - 58 * escalaY * factorEsc);
  } else {
    pg.fill(95, 45, 15);
    pg.text("+ NUEVA PARTIDA", mcx + 1.5f, y + h - 58 * escalaY * factorEsc + 1.5f);
    pg.fill(255);
    pg.text("+ NUEVA PARTIDA", mcx, y + h - 58 * escalaY * factorEsc);
  }

  pg.textSize(max(10, int(14 * escalaX * factorEsc)));
  if (esHover) {
    pg.fill(80, 35, 10);
  } else {
    pg.fill(245, 225, 190);
  }
  if (hayPartida) {
    pg.text("Empezar historia desde cero", mcx, y + h - 26 * escalaY * factorEsc);
  } else {
    pg.text("Haz clic para comenzar la aventura", mcx, y + h - 26 * escalaY * factorEsc);
  }

  pg.endDraw();
  return pg;
}

PGraphics crearPGBtnVolver(float wF, float hF, boolean esHover) {
  int w = max(20, int(wF));
  int h = max(20, int(hF));
  float factorEsc = esHover ? 1.045f : 1.0f;
  PGraphics pg = createGraphics(w + 8, h + 8);
  pg.beginDraw();
  pg.smooth(2);
  if (fuenteComic != null) {
    pg.textFont(fuenteComic);
  }
  dibujarCajaMaderaEnPG(pg, 4, 4, w, h, esHover);
  pg.textAlign(CENTER, CENTER);
  pg.textSize(max(12, int(20 * escalaX * factorEsc)));
  if (!esHover) {
    pg.fill(100, 50, 20);
    pg.text("< VOLVER AL MENÚ", 4 + w / 2.0f + 2, 4 + h / 2.0f + 2);
    pg.fill(255);
  } else {
    pg.fill(50, 20, 0);
  }
  pg.text("< VOLVER AL MENÚ", 4 + w / 2.0f, 4 + h / 2.0f);
  pg.endDraw();
  return pg;
}

// pre-renderiza el botoncito de borrar partida con icono de papelera y tono rojizo calido/terracota
PGraphics crearPGBtnBorrar(float wF, float hF, boolean esHover) {
  int w = max(16, int(wF));
  int h = max(16, int(hF));
  float esc = esHover ? 1.08f : 1.0f;
  PGraphics pg = createGraphics(w + 8, h + 8);
  pg.beginDraw();
  pg.smooth(2);
  pg.rectMode(CORNER);

  if (esHover) {
    pg.fill(228, 86, 62);
    pg.stroke(115, 32, 18);
  } else {
    pg.fill(168, 76, 52);
    pg.stroke(95, 40, 18);
  }
  pg.strokeWeight(3.2f);
  pg.rect(4, 4, w, h, 8);

  // brillo superior terracota
  pg.noStroke();
  if (esHover) {
    pg.fill(248, 128, 102);
  } else {
    pg.fill(192, 98, 72);
  }
  pg.rect(7, 7, w - 6, h * 0.38f, 4);

  // icono de papelera dibujado por codigo en el centro del boton
  float cx = 4 + w / 2.0f;
  float cy = 4 + h / 2.0f + (1.5f * escalaY * esc);
  float bw = 15.0f * escalaX * esc;
  float bh = 16.0f * escalaY * esc;

  pg.rectMode(CENTER);
  // sombra del icono
  pg.noStroke();
  pg.fill(75, 22, 10);
  pg.rect(cx + 1, cy + 2.5f * escalaY * esc, bw, bh, 3);
  pg.rect(cx + 1, cy - bh * 0.48f + 1, bw + 4 * escalaX * esc, 3.5f * escalaY * esc, 2);

  // cuerpo y tapa de la papelera
  if (esHover) {
    pg.fill(255, 250, 240);
  } else {
    pg.fill(250, 232, 215);
  }
  pg.rect(cx, cy + 1.5f * escalaY * esc, bw, bh, 3);
  pg.rect(cx, cy - bh * 0.48f, bw + 4 * escalaX * esc, 3.5f * escalaY * esc, 2);
  pg.rect(cx, cy - bh * 0.66f, bw * 0.42f, 2.8f * escalaY * esc, 1);

  // ranuras verticales de la papelera
  if (esHover) {
    pg.stroke(195, 62, 42);
  } else {
    pg.stroke(145, 58, 38);
  }
  pg.strokeWeight(max(1.2f, 1.8f * escalaX * esc));
  pg.line(cx - bw * 0.22f, cy - bh * 0.12f, cx - bw * 0.22f, cy + bh * 0.36f);
  pg.line(cx + bw * 0.22f, cy - bh * 0.12f, cx + bw * 0.22f, cy + bh * 0.36f);

  pg.endDraw();
  return pg;
}

// dibuja los recuadros flotantes usando los PGraphics pre-renderizados (0 calculos de geometria/texto por frame)
void dibujarMenuPartidasEnElCielo() {
  float curva = obtenerCurvaSuaveCielo();
  if (curva >= 0.25f) {
    boolean hayPartida = slotPartidaOcupado[0];
    if (!cacheTarjetasCieloListo || ultimoEstadoHayPartidaCache != hayPartida) {
      construirCacheTarjetasCielo();
    }

    float progEntrada = constrain(map(curva, 0.25f, 0.94f, 0.0f, 1.0f), 0.0f, 1.0f);
    float offsetDeslizarCielo = (1.0f - progEntrada) * (-height * 0.65f);
    float tiempoOnda = millis() * 0.0045f;

    imageMode(CORNER);
    noTint();

    // 1. Cartel superior pre-renderizado
    if (pgCartelTituloCielo != null) {
      float floatTituloY = sin(tiempoOnda) * (6.0f * escalaY);
      int titX = int((width - pgCartelTituloCielo.width) / 2.0f);
      int titY = int((height * 0.08f) + floatTituloY + offsetDeslizarCielo);
      image(pgCartelTituloCielo, titX, titY);
    }

    // 2. Posiciones centrales de las tarjetas
    if (!hayPartida) {
      cardCieloX[1] = width * 0.50f;
      cardCieloY[1] = height * 0.47f;
    } else {
      cardCieloX[0] = width * 0.35f;
      cardCieloY[0] = height * 0.47f;
      cardCieloX[1] = width * 0.71f;
      cardCieloY[1] = height * 0.47f;
    }
    cardCieloX[2] = width * 0.50f;
    cardCieloY[2] = height * 0.86f;

    // 3. Deteccion de hover (con prioridad para el boton de borrar partida si existe)
    int hoverDetectado = -1;
    hoverBtnBorrarPartida = false;

    if (hayPartida) {
      float flotY0 = sin(tiempoOnda + cardCieloFaseSin[0]) * (7.5f * escalaY);
      btnBorrarX = cardCieloX[0] + (cardCieloW[0] / 2.0f) - (34 * escalaX);
      btnBorrarY = cardCieloY[0] + flotY0 + offsetDeslizarCielo - (cardCieloH[0] / 2.0f) + (29 * escalaY);
    }

    if (faseCamaraMenu == 2 && !escribiendoNombrePartida && !confirmandoBorrarPartida && !mostrarOpciones) {
      if (hayPartida && mouseX >= btnBorrarX - btnBorrarW / 2.0f && mouseX <= btnBorrarX + btnBorrarW / 2.0f && mouseY >= btnBorrarY - btnBorrarH / 2.0f && mouseY <= btnBorrarY + btnBorrarH / 2.0f) {
        hoverBtnBorrarPartida = true;
      } else {
        for (int i = 0; i < TOTAL_CARDS_CIELO; i++) {
          boolean evaluarEstaCard = true;
          if (i == 0 && !hayPartida) {
            evaluarEstaCard = false;
          }

          if (evaluarEstaCard) {
            float ampFlot = (i == 2) ? (6.0f * escalaY) : (7.5f * escalaY);
            float flotY = sin(tiempoOnda + cardCieloFaseSin[i]) * ampFlot;
            float cx = cardCieloX[i];
            float cy = cardCieloY[i] + flotY;
            float cw = cardCieloW[i];
            float ch = cardCieloH[i];

            if (mouseX >= cx - cw / 2.0f && mouseX <= cx + cw / 2.0f && mouseY >= cy - ch / 2.0f && mouseY <= cy + ch / 2.0f) {
              hoverDetectado = i;
            }
          }
        }
      }
    }

    if (hoverBtnBorrarPartida && !ultimoHoverBtnBorrar) {
      if (sonidoHover != null) {
        sonidoHover.amp(0.15f * volMaster);
        sonidoHover.play();
      }
    }
    ultimoHoverBtnBorrar = hoverBtnBorrarPartida;

    if (hoverDetectado != -1 && hoverDetectado != ultimaCardCieloHover) {
      if (sonidoHover != null) {
        sonidoHover.amp(0.15f * volMaster);
        sonidoHover.play();
      }
      ultimaCardCieloHover = hoverDetectado;
    } else {
      if (hoverDetectado == -1) {
        ultimaCardCieloHover = -1;
      }
    }
    cardCieloSeleccionada = hoverDetectado;

    // 4. Dibujar PGraphics de Partida Guardada y su boton de Borrar en la esquina superior derecha (blit 1:1 directo)
    if (hayPartida) {
      PGraphics pg0 = (cardCieloSeleccionada == 0) ? pgCardGuardadaHover : pgCardGuardadaNormal;
      if (pg0 != null) {
        float flotY0 = sin(tiempoOnda + cardCieloFaseSin[0]) * (7.5f * escalaY);
        int x0 = int(cardCieloX[0] - pg0.width / 2.0f);
        int y0 = int(cardCieloY[0] + flotY0 + offsetDeslizarCielo - pg0.height / 2.0f);
        image(pg0, x0, y0);
      }

      PGraphics pgB = hoverBtnBorrarPartida ? pgBtnBorrarHover : pgBtnBorrarNormal;
      if (pgB != null) {
        int xb = int(btnBorrarX - pgB.width / 2.0f);
        int yb = int(btnBorrarY - pgB.height / 2.0f);
        image(pgB, xb, yb);
      }
    }

    // 5. Dibujar PGraphics de '+' Nueva Partida (blit 1:1 directo)
    PGraphics pg1 = (cardCieloSeleccionada == 1) ? pgCardNuevaHover : pgCardNuevaNormal;
    if (pg1 != null) {
      float flotY1 = sin(tiempoOnda + cardCieloFaseSin[1]) * (7.5f * escalaY);
      int x1 = int(cardCieloX[1] - pg1.width / 2.0f);
      int y1 = int(cardCieloY[1] + flotY1 + offsetDeslizarCielo - pg1.height / 2.0f);
      image(pg1, x1, y1);
    }

    // 6. Dibujar PGraphics de Boton Volver (blit 1:1 directo)
    PGraphics pg2 = (cardCieloSeleccionada == 2) ? pgBtnVolverHover : pgBtnVolverNormal;
    if (pg2 != null) {
      float flotY2 = sin(tiempoOnda + cardCieloFaseSin[2]) * (6.0f * escalaY);
      int x2 = int(cardCieloX[2] - pg2.width / 2.0f);
      int y2 = int(cardCieloY[2] + flotY2 - (offsetDeslizarCielo * 0.45f) - pg2.height / 2.0f);
      image(pg2, x2, y2);
    }

    // 7. Aviso flotante corto cuando se elimina una partida ("Partida eliminada")
    if (pgAvisoEliminada != null && millis() - tiempoAvisoPartidaEliminada < 2200) {
      float flotAv = sin(tiempoOnda * 1.4f) * (4.0f * escalaY);
      int avX = int((width - pgAvisoEliminada.width) / 2.0f);
      int avY = int((height * 0.175f) + flotAv + offsetDeslizarCielo);
      image(pgAvisoEliminada, avX, avY);
    }

    // 8. Si el jugador dio clic en '+', mostrar mini cartel de nombre
    if (escribiendoNombrePartida) {
      dibujarModalNombreNuevaPartida();
    }

    // 9. Si el jugador dio clic en la papelera, mostrar ventana flotante de confirmacion
    if (confirmandoBorrarPartida) {
      dibujarModalConfirmarBorradoPartida();
    }
  }
}

// funcion auxiliar que dibuja una tarjeta con la paleta exacta de los botones del menu
void dibujarCajaMaderaEstilizada(float x, float y, float w, float h, boolean resaltado) {
  rectMode(CORNER);

  if (resaltado) {
    fill(255, 220, 100);
  } else {
    fill(180, 120, 60);
  }

  stroke(100, 50, 20);
  strokeWeight(4);
  rect(x, y, w, h, 8);

  noStroke();
  if (resaltado) {
    fill(255, 232, 130);
  } else {
    fill(192, 138, 78);
  }
  rect(x + 4, y + 4, w - 8, min(h * 0.42f, 38 * escalaY), 4);
}

// modal con la misma estetica madera/dorado para confirmar o escribir nombre de la nueva partida
void dibujarModalNombreNuevaPartida() {
  rectMode(CORNER);

  float mw = 520 * escalaX;
  float mh = 290 * escalaY;
  float mx = (width - mw) / 2.0f;
  float my = (height - mh) / 2.0f;

  dibujarCajaMaderaEstilizada(mx, my, mw, mh, false);

  textAlign(CENTER, CENTER);
  textSize(max(12, int(23 * escalaX)));
  fill(90, 42, 15);
  text("CREAR NUEVA PARTIDA", mx + mw / 2.0f + 2, my + 38 * escalaY + 2);
  fill(255, 248, 220);
  text("CREAR NUEVA PARTIDA", mx + mw / 2.0f, my + 38 * escalaY);

  textSize(max(11, int(16 * escalaX)));
  fill(255, 238, 205);
  text("Escribe el nombre de tu partida (o deja Sam):", mx + mw / 2.0f, my + 84 * escalaY);

  // cajita de texto para el nombre
  float inW = 360 * escalaX;
  float inH = 50 * escalaY;
  float inX = mx + (mw - inW) / 2.0f;
  float inY = my + 112 * escalaY;

  fill(85, 42, 16);
  stroke(255, 220, 100);
  strokeWeight(3);
  rect(inX, inY, inW, inH, 8);

  String cursorParpadeo = ((frameCount / 25) % 2 == 0) ? "|" : "";
  fill(255, 250, 220);
  textSize(max(12, int(22 * escalaX)));
  text(nombreTemporalPartida + cursorParpadeo, inX + inW / 2.0f, inY + inH / 2.0f);

  // botones de Comenzar y Cancelar
  float bW = 190 * escalaX;
  float bH = 48 * escalaY;
  float bY = my + mh - bH - 24 * escalaY;
  float b1X = mx + mw * 0.27f - bW / 2.0f;
  float b2X = mx + mw * 0.73f - bW / 2.0f;

  boolean hov1 = (mouseX >= b1X && mouseX <= b1X + bW && mouseY >= bY && mouseY <= bY + bH);
  boolean hov2 = (mouseX >= b2X && mouseX <= b2X + bW && mouseY >= bY && mouseY <= bY + bH);

  dibujarCajaMaderaEstilizada(b1X, bY, bW, bH, hov1);
  dibujarCajaMaderaEstilizada(b2X, bY, bW, bH, hov2);

  textAlign(CENTER, CENTER);
  textSize(max(11, int(18 * escalaX)));
  if (hov1) {
    fill(50, 20, 0);
  } else {
    fill(255);
  }
  text("¡COMENZAR!", b1X + bW / 2.0f, bY + bH / 2.0f);

  if (hov2) {
    fill(50, 20, 0);
  } else {
    fill(255);
  }
  text("CANCELAR", b2X + bW / 2.0f, bY + bH / 2.0f);
}

// ventana flotante para confirmar si el jugador de verdad quiere eliminar la partida guardada
void dibujarModalConfirmarBorradoPartida() {
  rectMode(CORNER);

  float mw = 520 * escalaX;
  float mh = 265 * escalaY;
  float mx = (width - mw) / 2.0f;
  float my = (height - mh) / 2.0f;

  dibujarCajaMaderaEstilizada(mx, my, mw, mh, false);

  textAlign(CENTER, CENTER);
  textSize(max(12, int(23 * escalaX)));
  fill(90, 30, 12);
  text("¿ELIMINAR PARTIDA?", mx + mw / 2.0f + 2, my + 38 * escalaY + 2);
  fill(255, 235, 215);
  text("¿ELIMINAR PARTIDA?", mx + mw / 2.0f, my + 38 * escalaY);

  // recuadro interior oscuro para el mensaje de advertencia
  float inW = mw - 48 * escalaX;
  float inH = 92 * escalaY;
  float inX = mx + 24 * escalaX;
  float inY = my + 68 * escalaY;

  fill(98, 48, 22);
  stroke(75, 32, 12);
  strokeWeight(2);
  rect(inX, inY, inW, inH, 8);

  textSize(max(11, int(17 * escalaX)));
  fill(255, 245, 220);
  text("¿Seguro que deseas borrar la partida de \"" + slotNombreJugador[0] + "\"?", mx + mw / 2.0f, inY + 32 * escalaY);

  textSize(max(10, int(14 * escalaX)));
  fill(255, 195, 165);
  text("Se perderá el progreso guardado y no se podrá deshacer.", mx + mw / 2.0f, inY + 64 * escalaY);

  // botones de "SI, ELIMINAR" (terracota) y "NO, CANCELAR" (madera/dorado)
  float bW = 200 * escalaX;
  float bH = 48 * escalaY;
  float bY = my + mh - bH - 22 * escalaY;
  float b1X = mx + mw * 0.27f - bW / 2.0f;
  float b2X = mx + mw * 0.73f - bW / 2.0f;

  boolean hovSi = (mouseX >= b1X && mouseX <= b1X + bW && mouseY >= bY && mouseY <= bY + bH);
  boolean hovNo = (mouseX >= b2X && mouseX <= b2X + bW && mouseY >= bY && mouseY <= bY + bH);

  // boton izquierdo rojizo/terracota para confirmar borrado
  if (hovSi) {
    fill(230, 88, 62);
    stroke(115, 32, 18);
  } else {
    fill(172, 74, 50);
    stroke(95, 38, 18);
  }
  strokeWeight(4);
  rect(b1X, bY, bW, bH, 8);
  noStroke();
  if (hovSi) {
    fill(248, 128, 102);
  } else {
    fill(196, 96, 70);
  }
  rect(b1X + 4, bY + 4, bW - 8, bH * 0.40f, 4);

  // boton derecho normal para cancelar
  dibujarCajaMaderaEstilizada(b2X, bY, bW, bH, hovNo);

  textAlign(CENTER, CENTER);
  textSize(max(11, int(17 * escalaX)));
  if (hovSi) {
    fill(255, 250, 235);
  } else {
    fill(65, 20, 10);
    text("SÍ, ELIMINAR", b1X + bW / 2.0f + 1.5f, bY + bH / 2.0f + 1.5f);
    fill(255, 240, 225);
  }
  text("SÍ, ELIMINAR", b1X + bW / 2.0f, bY + bH / 2.0f);

  if (hovNo) {
    fill(50, 20, 0);
  } else {
    fill(100, 50, 20);
    text("NO, CANCELAR", b2X + bW / 2.0f + 1.5f, bY + bH / 2.0f + 1.5f);
    fill(255);
  }
  text("NO, CANCELAR", b2X + bW / 2.0f, bY + bH / 2.0f);
}


// =========================================================================
// INTERACCION DE MOUSE Y TECLADO EN EL MENU DEL CIELO
// =========================================================================

boolean procesarClicMenuCielo() {
  boolean consumido = true;

  if (faseCamaraMenu == 0) {
    consumido = false;
  } else {
    if (faseCamaraMenu == 1 || faseCamaraMenu == 3) {
      // mientras la camara va subiendo o bajando consumimos el clic para no bugear
      consumido = true;
    } else {
      // si esta abierta la ventana flotante de confirmar eliminacion de partida
      if (confirmandoBorrarPartida) {
        float mw = 520 * escalaX;
        float mh = 265 * escalaY;
        float mx = (width - mw) / 2.0f;
        float my = (height - mh) / 2.0f;
        float bW = 200 * escalaX;
        float bH = 48 * escalaY;
        float bY = my + mh - bH - 22 * escalaY;
        float b1X = mx + mw * 0.27f - bW / 2.0f;
        float b2X = mx + mw * 0.73f - bW / 2.0f;

        // clic en "SI, ELIMINAR"
        if (mouseX >= b1X && mouseX <= b1X + bW && mouseY >= bY && mouseY <= bY + bH) {
          if (sonidoClic != null) {
            sonidoClic.amp(0.5f * volMaster);
            sonidoClic.play();
          }
          borrarPartidaGuardada(0);
        } else {
          // clic en "NO, CANCELAR"
          if (mouseX >= b2X && mouseX <= b2X + bW && mouseY >= bY && mouseY <= bY + bH) {
            if (sonidoClic != null) {
              sonidoClic.amp(0.4f * volMaster);
              sonidoClic.play();
            }
            confirmandoBorrarPartida = false;
          }
        }
      } else {
        // si esta abierto el cuadrito de escribir el nombre de la nueva partida
        if (escribiendoNombrePartida) {
          float mw = 520 * escalaX;
          float mh = 290 * escalaY;
          float mx = (width - mw) / 2.0f;
          float my = (height - mh) / 2.0f;
          float bW = 190 * escalaX;
          float bH = 48 * escalaY;
          float bY = my + mh - bH - 24 * escalaY;
          float b1X = mx + mw * 0.27f - bW / 2.0f;
          float b2X = mx + mw * 0.73f - bW / 2.0f;

          if (mouseX >= b1X && mouseX <= b1X + bW && mouseY >= bY && mouseY <= bY + bH) {
            if (sonidoClic != null) {
              sonidoClic.amp(0.5f * volMaster);
              sonidoClic.play();
            }
            iniciarNuevaPartidaDesdeCielo(nombreTemporalPartida);
          } else {
            if (mouseX >= b2X && mouseX <= b2X + bW && mouseY >= bY && mouseY <= bY + bH) {
              if (sonidoClic != null) {
                sonidoClic.amp(0.4f * volMaster);
                sonidoClic.play();
              }
              escribiendoNombrePartida = false;
            }
          }
        } else {
          // prioridad: clic en el boton de borrar partida (abre la ventana de confirmacion antes de borrar)
          if (slotPartidaOcupado[0] && (hoverBtnBorrarPartida || (mouseX >= btnBorrarX - btnBorrarW / 2.0f && mouseX <= btnBorrarX + btnBorrarW / 2.0f && mouseY >= btnBorrarY - btnBorrarH / 2.0f && mouseY <= btnBorrarY + btnBorrarH / 2.0f))) {
            if (sonidoClic != null) {
              sonidoClic.amp(0.5f * volMaster);
              sonidoClic.play();
            }
            confirmandoBorrarPartida = true;
            hoverBtnBorrarPartida = false;
          } else {
            // clic sobre las tarjetas flotantes en el cielo
            if (cardCieloSeleccionada != -1) {
              if (sonidoClic != null) {
                sonidoClic.amp(0.5f * volMaster);
                sonidoClic.play();
              }

              if (cardCieloSeleccionada == 0 && slotPartidaOcupado[0]) {
                // cargar la partida guardada del archivo
                aplicarPartidaCargadaAlJuego(0);
              } else {
                if (cardCieloSeleccionada == 1) {
                  // abrir el cuadrito para crear nueva partida (o iniciar)
                  nombreTemporalPartida = "Sam";
                  escribiendoNombrePartida = true;
                } else {
                  if (cardCieloSeleccionada == 2) {
                    // volver al menu principal haciendo la transicion inversa bajando de las nubes
                    faseCamaraMenu = 3;
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  return consumido;
}

boolean procesarTeclaMenuCielo(char k, int kCode, boolean botonAtras) {
  boolean consumido = true;

  if (faseCamaraMenu == 0) {
    consumido = false;
  } else {
    if (confirmandoBorrarPartida) {
      if (kCode == ESC || k == 'n' || k == 'N' || k == 'm' || k == 'M') {
        confirmandoBorrarPartida = false;
      } else {
        if (kCode == ENTER || k == RETURN) {
          if (sonidoClic != null) {
            sonidoClic.amp(0.5f * volMaster);
            sonidoClic.play();
          }
          borrarPartidaGuardada(0);
        }
      }
    } else {
      if (escribiendoNombrePartida) {
        if (kCode == ESC || (k == 'm' && nombreTemporalPartida.length() == 0)) {
          escribiendoNombrePartida = false;
        } else {
          if (kCode == ENTER || k == RETURN) {
            if (sonidoClic != null) {
              sonidoClic.amp(0.5f * volMaster);
              sonidoClic.play();
            }
            iniciarNuevaPartidaDesdeCielo(nombreTemporalPartida);
          } else {
            if (k == BACKSPACE) {
              if (nombreTemporalPartida.length() > 0) {
                nombreTemporalPartida = nombreTemporalPartida.substring(0, nombreTemporalPartida.length() - 1);
              }
            } else {
              if (k >= 32 && k <= 126 && k != ';' && k != ',') {
                if (nombreTemporalPartida.length() < 14) {
                  nombreTemporalPartida = nombreTemporalPartida + k;
                }
              }
            }
          }
        }
      } else {
        if (botonAtras) {
          if (sonidoClic != null) {
            sonidoClic.amp(0.4f * volMaster);
            sonidoClic.play();
          }
          faseCamaraMenu = 3;
        } else {
          if (faseCamaraMenu == 2 && (kCode == ENTER || k == RETURN || k == ' ')) {
            if (sonidoClic != null) {
              sonidoClic.amp(0.5f * volMaster);
              sonidoClic.play();
            }
            if (slotPartidaOcupado[0]) {
              aplicarPartidaCargadaAlJuego(0);
            } else {
              nombreTemporalPartida = "Sam";
              escribiendoNombrePartida = true;
            }
          }
        }
      }
    }
  }

  return consumido;
}
