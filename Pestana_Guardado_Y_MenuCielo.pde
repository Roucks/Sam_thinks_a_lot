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
int totalEscenasCatalogo = 16;
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
  12,  // NIVEL2 (Minijuego cocina al ritmo)
  21,  // HISTORIA_POST_COCINA (Consecuencia despues de cocinar)
  18   // HISTORIA3_ARCADE (Nivel 3: cuarto y arcade)
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
  "Nivel 2: Cocina al Ritmo",
  "Cap. 2: Después de Cocinar",
  "Cap. 3: El Arcade"
};

// =========================================================================
// 2. ARREGLOS PARALELOS DE LAS PARTIDAS GUARDADAS
// =========================================================================
final int MAX_SLOTS_PARTIDA = 3;
boolean[] slotPartidaOcupado = new boolean[MAX_SLOTS_PARTIDA];
String[] slotNombreJugador = new String[MAX_SLOTS_PARTIDA];
int[] slotEstadoEscena = new int[MAX_SLOTS_PARTIDA];
int[] slotSubProgreso = new int[MAX_SLOTS_PARTIDA];
int[] slotPuntajeGuardado = new int[MAX_SLOTS_PARTIDA];
int[] slotBienestarGuardado = new int[MAX_SLOTS_PARTIDA];
int[] slotReputacionGuardada = new int[MAX_SLOTS_PARTIDA];
String[] slotLogroDestacado = new String[MAX_SLOTS_PARTIDA];
String[] slotBanderasExtra = new String[MAX_SLOTS_PARTIDA];
int slotPartidaActiva = 0;
boolean[] logrosPartidaActual = new boolean[21];

boolean sistemaGuardadoInicializado = false;

// modal sencillo para ponerle nombre a la partida nueva y para confirmar si quiere borrar xd
boolean escribiendoNombrePartida = false;
boolean confirmandoBorrarPartida = false;
int slotConfirmandoBorrar = -1;
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
// Indices 0..MAX_SLOTS_PARTIDA-1: Partidas guardadas
// Indice MAX_SLOTS_PARTIDA (3): Recuadro '+' Nueva Partida
// Indice MAX_SLOTS_PARTIDA + 1 (4): Boton Volver al Menu Principal
// =========================================================================
final int MAX_CARDS_CIELO = 5;
float[] cardCieloX = new float[MAX_CARDS_CIELO];
float[] cardCieloY = new float[MAX_CARDS_CIELO];
float[] cardCieloW = new float[MAX_CARDS_CIELO];
float[] cardCieloH = new float[MAX_CARDS_CIELO];
float[] cardCieloEscala = { 1.0f, 1.0f, 1.0f, 1.0f, 1.0f };
float[] cardCieloHoverLerp = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
float[] cardCieloFaseSin = { 0.0f, 1.35f, 2.70f, 1.85f, 3.40f };
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
PGraphics[] pgCardGuardadaNormalSlot = new PGraphics[MAX_SLOTS_PARTIDA];
PGraphics[] pgCardGuardadaHoverSlot = new PGraphics[MAX_SLOTS_PARTIDA];
PGraphics pgCardNuevaNormal = null;
PGraphics pgCardNuevaHover = null;
PGraphics pgBtnVolverNormal = null;
PGraphics pgBtnVolverHover = null;
PGraphics pgBtnBorrarNormal = null;
PGraphics pgBtnBorrarHover = null;
PGraphics pgAvisoEliminada = null;
boolean cacheTarjetasCieloListo = false;
int ultimoConteoPartidasCache = -1;

int slotHoverBorrar = -1;
int ultimoSlotHoverBorrar = -1;
float[] btnBorrarSlotX = new float[MAX_SLOTS_PARTIDA];
float[] btnBorrarSlotY = new float[MAX_SLOTS_PARTIDA];
float btnBorrarW = 0;
float btnBorrarH = 0;
int tiempoAvisoPartidaEliminada = -10000;


// =========================================================================
// FUNCIONES DE INICIALIZACION Y ARCHIVOS PLANOS (saveStrings / loadStrings)
// =========================================================================

String crearBitsLogrosCero() {
  String bits = "";
  for (int i = 0; i < totalLogros; i++) {
    bits = bits + "0";
  }
  return bits;
}

String obtenerBitsLogrosDeSlot(int slotIdx) {
  String res = crearBitsLogrosCero();
  if (slotIdx >= 0 && slotIdx < MAX_SLOTS_PARTIDA && slotBanderasExtra[slotIdx] != null) {
    String[] ext = split(slotBanderasExtra[slotIdx], ',');
    if (ext != null && contarCadenas(ext) >= 19) {
      String bits = ext[18];
      String armado = "";
      for (int i = 0; i < totalLogros; i++) {
        if (i < bits.length() && leerCaracter(bits, i) == '1') {
          armado = armado + "1";
        } else {
          armado = armado + "0";
        }
      }
      res = armado;
    }
  }
  return res;
}

int contarLogrosDeSlot(int slotIdx) {
  int cant = 0;
  String bits = obtenerBitsLogrosDeSlot(slotIdx);
  for (int i = 0; i < totalLogros && i < bits.length(); i++) {
    if (leerCaracter(bits, i) == '1') {
      cant++;
    }
  }
  return cant;
}

int contarLogrosPartidaActual() {
  int cant = 0;
  for (int i = 0; i < totalLogros; i++) {
    if (logrosPartidaActual[i]) {
      cant++;
    }
  }
  return cant;
}

int contarPartidasOcupadas() {
  int cant = 0;
  for (int i = 0; i < MAX_SLOTS_PARTIDA; i++) {
    if (slotPartidaOcupado[i]) {
      cant++;
    }
  }
  return cant;
}

int obtenerPrimerSlotLibre() {
  int res = -1;
  boolean encontrado = false;
  for (int i = 0; i < MAX_SLOTS_PARTIDA && !encontrado; i++) {
    if (!slotPartidaOcupado[i]) {
      res = i;
      encontrado = true;
    }
  }
  return res;
}

int obtenerPrimerSlotOcupado() {
  int res = -1;
  boolean encontrado = false;
  for (int i = 0; i < MAX_SLOTS_PARTIDA && !encontrado; i++) {
    if (slotPartidaOcupado[i]) {
      res = i;
      encontrado = true;
    }
  }
  return res;
}

// Recalcula la union general de logros a partir de todas las partidas guardadas existentes.
void recalcularLogrosReunidos() {
  for (int i = 0; i < totalLogros; i++) {
    logrosDesbloqueados[i] = false;
  }
  for (int s = 0; s < MAX_SLOTS_PARTIDA; s++) {
    if (slotPartidaOcupado[s]) {
      String bits = obtenerBitsLogrosDeSlot(s);
      for (int i = 0; i < totalLogros && i < bits.length(); i++) {
        if (leerCaracter(bits, i) == '1') {
          logrosDesbloqueados[i] = true;
        }
      }
    }
  }
}

void sincronizarLogrosEnSlotActivo() {
  int target = -1;
  if (slotPartidaActiva >= 0 && slotPartidaActiva < MAX_SLOTS_PARTIDA && slotPartidaOcupado[slotPartidaActiva]) {
    target = slotPartidaActiva;
  } else {
    target = obtenerPrimerSlotOcupado();
  }
  if (target >= 0 && slotBanderasExtra[target] != null) {
    String[] ext = split(slotBanderasExtra[target], ',');
    if (ext != null && contarCadenas(ext) >= 19) {
      String bitsPrev = ext[18];
      String bitsNuevos = "";
      for (int i = 0; i < totalLogros; i++) {
        boolean tiene = logrosPartidaActual[i];
        if (!tiene && i < bitsPrev.length() && leerCaracter(bitsPrev, i) == '1') {
          tiene = true;
        }
        bitsNuevos = bitsNuevos + (tiene ? "1" : "0");
      }
      ext[18] = bitsNuevos;
      String reconstruida = ext[0];
      for (int j = 1; j < 19; j++) {
        reconstruida = reconstruida + "," + ext[j];
      }
      slotBanderasExtra[target] = reconstruida;
      int cantSlot = contarLogrosDeSlot(target);
      int bienSlot = constrain(slotBienestarGuardado[target], 0, 100);
      slotLogroDestacado[target] = "Bienestar: " + bienSlot + "%  |  Logros: " + cantSlot + "/" + totalLogros;
      cacheTarjetasCieloListo = false;
      escribirArreglosEnTxt();
    }
  }
}

void inicializarSistemaGuardadoYCielo() {
  if (!sistemaGuardadoInicializado) {
    String ceros = crearBitsLogrosCero();
    for (int i = 0; i < MAX_SLOTS_PARTIDA; i++) {
      slotPartidaOcupado[i] = false;
      slotNombreJugador[i] = "Sam";
      slotEstadoEscena[i] = JUEGO;
      slotSubProgreso[i] = 0;
      slotPuntajeGuardado[i] = 0;
      slotBienestarGuardado[i] = 100;
      slotReputacionGuardada[i] = 15;
      slotLogroDestacado[i] = "Bienestar: 100% | Logros: 0/" + totalLogros;
      slotBanderasExtra[i] = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," + ceros;
    }
    for (int l = 0; l < totalLogros; l++) {
      logrosPartidaActual[l] = false;
    }

    cargarPartidasDesdeArchivo();
    int primeroOcup = obtenerPrimerSlotOcupado();
    if (primeroOcup >= 0) {
      slotPartidaActiva = primeroOcup;
      String bitsAct = obtenerBitsLogrosDeSlot(slotPartidaActiva);
      for (int l = 0; l < totalLogros && l < bitsAct.length(); l++) {
        logrosPartidaActual[l] = (leerCaracter(bitsAct, l) == '1');
      }
    } else {
      slotPartidaActiva = 0;
    }
    recalcularLogrosReunidos();
    guardarLogrosGlobales();
    sistemaGuardadoInicializado = true;
  }
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

// guarda los datos actuales de la partida en el slot activo y escribe el archivo .txt
void guardarPartidaEnArchivo(int estadoParaGuardar) {
  if (!feriaActiva) {

  if (!sistemaGuardadoInicializado) {
    inicializarSistemaGuardadoYCielo();
  }

  int sIdx = slotPartidaActiva;
  if (sIdx < 0 || sIdx >= MAX_SLOTS_PARTIDA) {
    sIdx = 0;
    slotPartidaActiva = 0;
  }

  // si se guarda desde el celular o algo intermedio, aseguramos un estado valido
  int estReal = estadoParaGuardar;
  if (estReal == CARGA || estReal == MENU || estReal == CREDITOS || estReal == LOGROS || estReal == RECUERDOS) {
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
            } else {
              if (estReal == HISTORIA_POST_COCINA) {
                subProg = (hcBuena ? 100 : 0) + (hcEtapa * 20) + hcPagina;
              } else {
                if (estReal == HISTORIA3_ARCADE) {
                  subProg = t3Etapa;
                }
              }
            }
          }
        }
      }
    }
  }

  slotPartidaOcupado[sIdx] = true;
  if (playerName != null && playerName.trim().length() > 0) {
    slotNombreJugador[sIdx] = playerName.trim();
  } else {
    if (slotNombreJugador[sIdx] == null || slotNombreJugador[sIdx].trim().length() == 0) {
      slotNombreJugador[sIdx] = "Sam";
    }
  }

  slotEstadoEscena[sIdx] = estReal;
  slotSubProgreso[sIdx] = subProg;
  slotPuntajeGuardado[sIdx] = puntosJugador;
  slotBienestarGuardado[sIdx] = round(constrain(bienestarDigital, 0, 100));
  slotReputacionGuardada[sIdx] = reputacionDigital;

  int cantLogros = contarLogrosPartidaActual();
  slotLogroDestacado[sIdx] = "Bienestar: " + slotBienestarGuardado[sIdx] + "%  |  Logros: " + cantLogros + "/" + totalLogros;

  // armamos la cadena de banderas de historia usando unicamente los logros propios de esta partida
  String bitsLogros = "";
  for (int i = 0; i < totalLogros; i++) {
    if (logrosPartidaActual[i]) {
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

  slotBanderasExtra[sIdx] = extra;
  cacheTarjetasCieloListo = false;

  escribirArreglosEnTxt();
  recalcularLogrosReunidos();
  guardarLogrosGlobales();

  }
}

// limpia todos los datos del slot en los arreglos paralelos, actualiza el .txt y recalcula los logros reunidos
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
    slotBanderasExtra[slotIdx] = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," + crearBitsLogrosCero();

    escribirArreglosEnTxt();

    if (slotIdx == slotPartidaActiva) {
      for (int i = 0; i < totalLogros; i++) {
        logrosPartidaActual[i] = false;
      }
      puntosJugador = 0;
      puntosMostradosLerp = 0;
      int otroOcup = obtenerPrimerSlotOcupado();
      slotPartidaActiva = (otroOcup >= 0) ? otroOcup : 0;
    }

    recalcularLogrosReunidos();
    guardarLogrosGlobales();
    recValidarPreferenciasContraLogros();

    slotHoverBorrar = -1;
    ultimoSlotHoverBorrar = -1;
    slotConfirmandoBorrar = -1;
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
        String ceros = crearBitsLogrosCero();
        for (int k = 0; k < MAX_SLOTS_PARTIDA; k++) {
          slotPartidaOcupado[k] = false;
          slotNombreJugador[k] = "Sam";
          slotEstadoEscena[k] = JUEGO;
          slotSubProgreso[k] = 0;
          slotPuntajeGuardado[k] = 0;
          slotBienestarGuardado[k] = 100;
          slotReputacionGuardada[k] = 15;
          slotLogroDestacado[k] = "Bienestar: 100% | Logros: 0/" + totalLogros;
          slotBanderasExtra[k] = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," + ceros;
        }
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
    recalcularLogrosReunidos();
    cacheTarjetasCieloListo = false;
  } catch (Exception e) {
    println("No se pudo leer partidas_guardadas.txt (se creara uno nuevo): " + e.getMessage());
  }
}

// restaura en el juego todas las variables guardadas en el slot elegido
void aplicarPartidaCargadaAlJuego(int slotIdx) {
  if (slotIdx >= 0 && slotIdx < MAX_SLOTS_PARTIDA) {
    if (slotPartidaOcupado[slotIdx]) {
      slotPartidaActiva = slotIdx;
      detenerMediosParaSaltoDebug();
      t3Reiniciar();
      reiniciarHistoriaDespuesCocina();
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

      for (int l = 0; l < totalLogros; l++) {
        logrosPartidaActual[l] = false;
      }

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
          logrosPartidaActual[l] = (leerCaracter(bitsLog, l) == '1');
        }
      }
      recalcularLogrosReunidos();
      guardarLogrosGlobales();

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

      if (escenaDestino == HISTORIA_POST_COCINA) {
        boolean eraBuena = (subProg >= 100);
        int resto = subProg % 100;
        int etapaGuardada = constrain(resto / 20, 0, 2);
        int pagGuardada = max(0, resto % 20);
        hcSaltarDebug(eraBuena);
        hcEtapa = etapaGuardada;
        if (hcEtapa >= 1) {
          hcPrepararPublicacion();
        }
        hcPagina = constrain(pagGuardada, 0, max(0, hcTotalPaginas() - 1));
        hcReiniciarTexto();
      } else {
        if (escenaDestino == HISTORIA3_ARCADE) {
          if (subProg == 4) {
            t3AbrirJuegoArcade();
            nv3_prepararMenu();
          } else {
            t3EmpezarCuarto();
            if (subProg == 1 || subProg == 3 || subProg == 5) {
              t3CambiarEscena(subProg);
            }
          }
        } else {
          estadoDestino = escenaDestino;
          enTransicion = true;
        }
      }
    }
  }
}

// reinicia las variables para empezar una partida desde cero y la guarda en el primer slot libre
void iniciarNuevaPartidaDesdeCielo(String nombreElegido) {
  String nomFinal = trim(nombreElegido);
  if (nomFinal.length() == 0) {
    nomFinal = "Sam";
  }

  int destino = obtenerPrimerSlotLibre();
  if (destino < 0) {
    destino = 0;
  }
  slotPartidaActiva = destino;

  playerName = nomFinal;
  slotNombreJugador[slotPartidaActiva] = nomFinal;
  detenerMediosParaSaltoDebug();
  t3Reiniciar();
  reiniciarHistoriaDespuesCocina();
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

  for (int i = 0; i < totalLogros; i++) {
    logrosPartidaActual[i] = false;
  }

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

  // guardamos el estado inicial en el archivo .txt (con 0 logros propios)
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
            pgFondoCieloCache.beginDraw();
            pgFondoCieloCache.noSmooth();
            pgFondoCieloCache.noTint();
            pgFondoCieloCache.imageMode(CORNER);
            dibujarRecorteCielo(pgFondoCieloCache, 1);
            pgFondoCieloCache.endDraw();
            fondoCieloCacheListo = true;
          }
          image(pgFondoCieloCache, 0, 0);
        } else {
          // durante el paneo de 0.5s desactivamos el filtro bicubico de JAVA2D para que escale instantaneo
          noSmooth();
          dibujarRecorteCielo(g, curva);
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

// El menú y la carga comparten el encuadre del cielo del video.
void dibujarRecorteCielo(PGraphics destino, float curva) {
  float vw = videoFondo.width;
  float vh = videoFondo.height;
  float cropW = lerp(vw, vw * 0.45f, curva);
  float cropH = lerp(vh, vh * 0.45f, curva);
  int sx = int((vw - cropW) * 0.88f);
  int sy = int((vh - cropH) * 0.06f);
  destino.image(videoFondo, 0, 0, destino.width, destino.height, sx, sy,
    int(sx + cropW), int(sy + cropH));
}

void actualizarLayoutCardsCielo() {
  int cantOcup = contarPartidasOcupadas();
  boolean mostrarNueva = (cantOcup < MAX_SLOTS_PARTIDA);
  int[] filaIdx = new int[MAX_SLOTS_PARTIDA + 1];
  int totalFila = 0;

  for (int s = 0; s < MAX_SLOTS_PARTIDA; s++) {
    if (slotPartidaOcupado[s]) {
      filaIdx[totalFila] = s;
      totalFila++;
    }
  }
  if (mostrarNueva) {
    filaIdx[totalFila] = MAX_SLOTS_PARTIDA;
    totalFila++;
  }

  if (totalFila == 1) {
    int c0 = filaIdx[0];
    cardCieloW[c0] = 360 * escalaX;
    cardCieloH[c0] = 350 * escalaY;
    cardCieloX[c0] = width * 0.50f;
    cardCieloY[c0] = height * 0.47f;
  } else {
    if (totalFila == 2) {
      int c0 = filaIdx[0];
      int c1 = filaIdx[1];
      float w0 = 450 * escalaX;
      float w1 = (c1 == MAX_SLOTS_PARTIDA) ? (330 * escalaX) : (450 * escalaX);
      float gap = 70 * escalaX;
      float startX = (width - (w0 + gap + w1)) * 0.5f;
      cardCieloW[c0] = w0;
      cardCieloH[c0] = 360 * escalaY;
      cardCieloX[c0] = startX + w0 * 0.5f;
      cardCieloY[c0] = height * 0.47f;
      cardCieloW[c1] = w1;
      cardCieloH[c1] = 360 * escalaY;
      cardCieloX[c1] = startX + w0 + gap + w1 * 0.5f;
      cardCieloY[c1] = height * 0.47f;
    } else {
      float wCard = 410 * escalaX;
      float hCard = 360 * escalaY;
      float gap = 38 * escalaX;
      float totalW = (wCard * totalFila) + (gap * max(0, totalFila - 1));
      float startX = (width - totalW) * 0.5f;
      for (int k = 0; k < totalFila; k++) {
        int ci = filaIdx[k];
        cardCieloW[ci] = wCard;
        cardCieloH[ci] = hCard;
        cardCieloX[ci] = startX + (wCard * 0.5f) + k * (wCard + gap);
        cardCieloY[ci] = height * 0.47f;
      }
    }
  }

  cardCieloW[MAX_SLOTS_PARTIDA + 1] = 280 * escalaX;
  cardCieloH[MAX_SLOTS_PARTIDA + 1] = 58 * escalaY;
  cardCieloX[MAX_SLOTS_PARTIDA + 1] = width * 0.50f;
  cardCieloY[MAX_SLOTS_PARTIDA + 1] = height * 0.86f;
}

// pre-renderiza todas las tarjetas en objetos PGraphics una sola vez para no dibujar rect() ni text() en cada frame
void construirCacheTarjetasCielo() {
  int cantOcup = contarPartidasOcupadas();
  boolean hayPartida = (cantOcup > 0);
  actualizarLayoutCardsCielo();

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

  // 2. Pre-renderizar tarjetas de Partidas Guardadas (Normal y Hover)
  for (int s = 0; s < MAX_SLOTS_PARTIDA; s++) {
    if (slotPartidaOcupado[s]) {
      pgCardGuardadaNormalSlot[s] = crearPGCardGuardada(s, cardCieloW[s], cardCieloH[s], false);
      pgCardGuardadaHoverSlot[s] = crearPGCardGuardada(s, cardCieloW[s] * 1.045f, cardCieloH[s] * 1.045f, true);
    } else {
      pgCardGuardadaNormalSlot[s] = null;
      pgCardGuardadaHoverSlot[s] = null;
    }
  }

  // 3. Pre-renderizar tarjeta '+' Nueva Partida (Normal y Hover) si hay espacio disponible
  if (cantOcup < MAX_SLOTS_PARTIDA) {
    pgCardNuevaNormal = crearPGCardNueva(cardCieloW[MAX_SLOTS_PARTIDA], cardCieloH[MAX_SLOTS_PARTIDA], false, hayPartida);
    pgCardNuevaHover = crearPGCardNueva(cardCieloW[MAX_SLOTS_PARTIDA] * 1.045f, cardCieloH[MAX_SLOTS_PARTIDA] * 1.045f, true, hayPartida);
  } else {
    pgCardNuevaNormal = null;
    pgCardNuevaHover = null;
  }

  // 4. Pre-renderizar boton Volver al Menu (Normal y Hover)
  pgBtnVolverNormal = crearPGBtnVolver(cardCieloW[MAX_SLOTS_PARTIDA + 1], cardCieloH[MAX_SLOTS_PARTIDA + 1], false);
  pgBtnVolverHover = crearPGBtnVolver(cardCieloW[MAX_SLOTS_PARTIDA + 1] * 1.045f, cardCieloH[MAX_SLOTS_PARTIDA + 1] * 1.045f, true);

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

  ultimoConteoPartidasCache = cantOcup;
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

PGraphics crearPGCardGuardada(int slotIdx, float wF, float hF, boolean esHover) {
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

  float pad = 18 * escalaX * factorEsc;
  float innerX = x + pad;
  float innerY = y + 58 * escalaY * factorEsc;
  float innerW = w - (pad * 2.0f);
  float innerH = h - (118 * escalaY * factorEsc);

  pg.fill(112, 64, 28);
  pg.stroke(80, 40, 15);
  pg.strokeWeight(2);
  pg.rect(innerX, innerY, innerW, innerH, 8);

  pg.textAlign(CENTER, CENTER);
  pg.textSize(max(12, int(20 * escalaX * factorEsc)));
  pg.fill(80, 35, 10);
  pg.text("PARTIDA GUARDADA", x + w / 2.0f + 1.5f, y + 29 * escalaY * factorEsc + 1.5f);
  pg.fill(255, 248, 220);
  pg.text("PARTIDA GUARDADA", x + w / 2.0f, y + 29 * escalaY * factorEsc);

  pg.textAlign(LEFT, TOP);
  pg.textSize(max(12, int(22 * escalaX * factorEsc)));
  pg.fill(255, 225, 110);
  pg.text("Jugador: " + slotNombreJugador[slotIdx], innerX + 16 * escalaX * factorEsc, innerY + 14 * escalaY * factorEsc);

  String nomEscena = obtenerNombreEscenaCatalogo(slotEstadoEscena[slotIdx], slotSubProgreso[slotIdx]);
  pg.textSize(max(10, int(15.5f * escalaX * factorEsc)));
  pg.fill(255);
  pg.text("Progreso: " + nomEscena, innerX + 16 * escalaX * factorEsc, innerY + 52 * escalaY * factorEsc);

  pg.textSize(max(11, int(17.5f * escalaX * factorEsc)));
  pg.fill(150, 245, 165);
  pg.text("Puntaje Total: " + slotPuntajeGuardado[slotIdx] + " pts", innerX + 16 * escalaX * factorEsc, innerY + 86 * escalaY * factorEsc);

  int cantLogros = contarLogrosDeSlot(slotIdx);
  int bienGuardado = constrain(slotBienestarGuardado[slotIdx], 0, 100);
  pg.textSize(max(10, int(14.5f * escalaX * factorEsc)));
  pg.fill(245, 230, 200);
  pg.text("Bienestar Digital: " + bienGuardado + "%   |   Logros: " + cantLogros + "/" + totalLogros, innerX + 16 * escalaX * factorEsc, innerY + 122 * escalaY * factorEsc);

  float bx = innerX + 16 * escalaX * factorEsc;
  float by = innerY + 152 * escalaY * factorEsc;
  float bw = innerW - 32 * escalaX * factorEsc;
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
  pg.textSize(max(11, int(17 * escalaX * factorEsc)));
  if (esHover) {
    pg.fill(50, 20, 0);
    pg.text("» CLIC PARA CONTINUAR «", x + w / 2.0f, y + h - 28 * escalaY * factorEsc);
  } else {
    pg.fill(90, 42, 15);
    pg.text("CLIC PARA CONTINUAR", x + w / 2.0f + 1.5f, y + h - 28 * escalaY * factorEsc + 1.5f);
    pg.fill(255, 250, 230);
    pg.text("CLIC PARA CONTINUAR", x + w / 2.0f, y + h - 28 * escalaY * factorEsc);
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
  pg.textSize(max(12, int(21 * escalaX * factorEsc)));
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
    int cantOcup = contarPartidasOcupadas();
    if (!cacheTarjetasCieloListo || ultimoConteoPartidasCache != cantOcup) {
      construirCacheTarjetasCielo();
    } else {
      actualizarLayoutCardsCielo();
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

    // 2. Posicion de botones de borrado por slot ocupado
    for (int s = 0; s < MAX_SLOTS_PARTIDA; s++) {
      if (slotPartidaOcupado[s]) {
        float flotYS = sin(tiempoOnda + cardCieloFaseSin[s]) * (7.5f * escalaY);
        btnBorrarSlotX[s] = cardCieloX[s] + (cardCieloW[s] / 2.0f) - (34 * escalaX);
        btnBorrarSlotY[s] = cardCieloY[s] + flotYS + offsetDeslizarCielo - (cardCieloH[s] / 2.0f) + (29 * escalaY);
      }
    }

    // 3. Deteccion de hover (prioridad a los botones de borrar partida)
    int hoverDetectado = -1;
    slotHoverBorrar = -1;

    if (faseCamaraMenu == 2 && !escribiendoNombrePartida && !confirmandoBorrarPartida && !mostrarOpciones) {
      for (int s = 0; s < MAX_SLOTS_PARTIDA && slotHoverBorrar == -1; s++) {
        if (slotPartidaOcupado[s] && mouseX >= btnBorrarSlotX[s] - btnBorrarW / 2.0f && mouseX <= btnBorrarSlotX[s] + btnBorrarW / 2.0f
            && mouseY >= btnBorrarSlotY[s] - btnBorrarH / 2.0f && mouseY <= btnBorrarSlotY[s] + btnBorrarH / 2.0f) {
          slotHoverBorrar = s;
        }
      }
      if (slotHoverBorrar == -1) {
        for (int i = 0; i < MAX_CARDS_CIELO; i++) {
          boolean evaluarEstaCard = false;
          if (i < MAX_SLOTS_PARTIDA) {
            evaluarEstaCard = slotPartidaOcupado[i];
          } else {
            if (i == MAX_SLOTS_PARTIDA) {
              evaluarEstaCard = (cantOcup < MAX_SLOTS_PARTIDA);
            } else {
              evaluarEstaCard = true;
            }
          }

          if (evaluarEstaCard) {
            float ampFlot = (i == MAX_SLOTS_PARTIDA + 1) ? (6.0f * escalaY) : (7.5f * escalaY);
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

    if (slotHoverBorrar != -1 && slotHoverBorrar != ultimoSlotHoverBorrar) {
      if (sonidoHover != null) {
        sonidoHover.amp(0.15f * volMaster);
        sonidoHover.play();
      }
    }
    ultimoSlotHoverBorrar = slotHoverBorrar;

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

    // 4. Dibujar PGraphics de Partidas Guardadas ocupadas y sus botones de Borrar
    for (int s = 0; s < MAX_SLOTS_PARTIDA; s++) {
      if (slotPartidaOcupado[s]) {
        PGraphics pgS = (cardCieloSeleccionada == s) ? pgCardGuardadaHoverSlot[s] : pgCardGuardadaNormalSlot[s];
        if (pgS != null) {
          float flotYS = sin(tiempoOnda + cardCieloFaseSin[s]) * (7.5f * escalaY);
          int xs = int(cardCieloX[s] - pgS.width / 2.0f);
          int ys = int(cardCieloY[s] + flotYS + offsetDeslizarCielo - pgS.height / 2.0f);
          image(pgS, xs, ys);
        }

        PGraphics pgB = (slotHoverBorrar == s) ? pgBtnBorrarHover : pgBtnBorrarNormal;
        if (pgB != null) {
          int xb = int(btnBorrarSlotX[s] - pgB.width / 2.0f);
          int yb = int(btnBorrarSlotY[s] - pgB.height / 2.0f);
          image(pgB, xb, yb);
        }
      }
    }

    // 5. Dibujar PGraphics de '+' Nueva Partida si hay espacio
    if (cantOcup < MAX_SLOTS_PARTIDA) {
      int idxNueva = MAX_SLOTS_PARTIDA;
      PGraphics pg1 = (cardCieloSeleccionada == idxNueva) ? pgCardNuevaHover : pgCardNuevaNormal;
      if (pg1 != null) {
        float flotY1 = sin(tiempoOnda + cardCieloFaseSin[idxNueva]) * (7.5f * escalaY);
        int x1 = int(cardCieloX[idxNueva] - pg1.width / 2.0f);
        int y1 = int(cardCieloY[idxNueva] + flotY1 + offsetDeslizarCielo - pg1.height / 2.0f);
        image(pg1, x1, y1);
      }
    }

    // 6. Dibujar PGraphics de Boton Volver (blit 1:1 directo)
    int idxVolver = MAX_SLOTS_PARTIDA + 1;
    PGraphics pg2 = (cardCieloSeleccionada == idxVolver) ? pgBtnVolverHover : pgBtnVolverNormal;
    if (pg2 != null) {
      float flotY2 = sin(tiempoOnda + cardCieloFaseSin[idxVolver]) * (6.0f * escalaY);
      int x2 = int(cardCieloX[idxVolver] - pg2.width / 2.0f);
      int y2 = int(cardCieloY[idxVolver] + flotY2 - (offsetDeslizarCielo * 0.45f) - pg2.height / 2.0f);
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

  int idxModal = (slotConfirmandoBorrar >= 0 && slotConfirmandoBorrar < MAX_SLOTS_PARTIDA) ? slotConfirmandoBorrar : 0;

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
  text("¿Seguro que deseas borrar la partida de \"" + slotNombreJugador[idxModal] + "\"?", mx + mw / 2.0f, inY + 32 * escalaY);

  textSize(max(10, int(14 * escalaX)));
  fill(255, 195, 165);
  text("Se perderá su progreso y los logros propios de esta partida.", mx + mw / 2.0f, inY + 64 * escalaY);

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
          if (slotConfirmandoBorrar >= 0 && slotConfirmandoBorrar < MAX_SLOTS_PARTIDA) {
            borrarPartidaGuardada(slotConfirmandoBorrar);
          } else {
            confirmandoBorrarPartida = false;
          }
        } else {
          // clic en "NO, CANCELAR"
          if (mouseX >= b2X && mouseX <= b2X + bW && mouseY >= bY && mouseY <= bY + bH) {
            if (sonidoClic != null) {
              sonidoClic.amp(0.4f * volMaster);
              sonidoClic.play();
            }
            confirmandoBorrarPartida = false;
            slotConfirmandoBorrar = -1;
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
          // prioridad: clic en el boton de borrar partida de cualquier slot ocupado
          int slotClicBorrar = slotHoverBorrar;
          for (int s = 0; s < MAX_SLOTS_PARTIDA && slotClicBorrar == -1; s++) {
            if (slotPartidaOcupado[s] && mouseX >= btnBorrarSlotX[s] - btnBorrarW / 2.0f && mouseX <= btnBorrarSlotX[s] + btnBorrarW / 2.0f
                && mouseY >= btnBorrarSlotY[s] - btnBorrarH / 2.0f && mouseY <= btnBorrarSlotY[s] + btnBorrarH / 2.0f) {
              slotClicBorrar = s;
            }
          }
          if (slotClicBorrar != -1 && slotPartidaOcupado[slotClicBorrar]) {
            if (sonidoClic != null) {
              sonidoClic.amp(0.5f * volMaster);
              sonidoClic.play();
            }
            slotConfirmandoBorrar = slotClicBorrar;
            confirmandoBorrarPartida = true;
            slotHoverBorrar = -1;
          } else {
            // clic sobre las tarjetas flotantes en el cielo
            if (cardCieloSeleccionada != -1) {
              if (sonidoClic != null) {
                sonidoClic.amp(0.5f * volMaster);
                sonidoClic.play();
              }

              if (cardCieloSeleccionada >= 0 && cardCieloSeleccionada < MAX_SLOTS_PARTIDA && slotPartidaOcupado[cardCieloSeleccionada]) {
                // cargar la partida guardada del slot elegido
                aplicarPartidaCargadaAlJuego(cardCieloSeleccionada);
              } else {
                if (cardCieloSeleccionada == MAX_SLOTS_PARTIDA && contarPartidasOcupadas() < MAX_SLOTS_PARTIDA) {
                  // abrir el cuadrito para crear nueva partida
                  nombreTemporalPartida = "Sam";
                  escribiendoNombrePartida = true;
                } else {
                  if (cardCieloSeleccionada == MAX_SLOTS_PARTIDA + 1) {
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
        slotConfirmandoBorrar = -1;
      } else {
        if (kCode == ENTER || k == RETURN) {
          if (sonidoClic != null) {
            sonidoClic.amp(0.5f * volMaster);
            sonidoClic.play();
          }
          if (slotConfirmandoBorrar >= 0 && slotConfirmandoBorrar < MAX_SLOTS_PARTIDA) {
            borrarPartidaGuardada(slotConfirmandoBorrar);
          } else {
            confirmandoBorrarPartida = false;
          }
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
            if (cardCieloSeleccionada >= 0 && cardCieloSeleccionada < MAX_SLOTS_PARTIDA && slotPartidaOcupado[cardCieloSeleccionada]) {
              aplicarPartidaCargadaAlJuego(cardCieloSeleccionada);
            } else {
              if (cardCieloSeleccionada == MAX_SLOTS_PARTIDA && contarPartidasOcupadas() < MAX_SLOTS_PARTIDA) {
                nombreTemporalPartida = "Sam";
                escribiendoNombrePartida = true;
              } else {
                if (cardCieloSeleccionada == MAX_SLOTS_PARTIDA + 1) {
                  faseCamaraMenu = 3;
                } else {
                  int priOcup = obtenerPrimerSlotOcupado();
                  if (priOcup >= 0) {
                    aplicarPartidaCargadaAlJuego(priOcup);
                  } else {
                    nombreTemporalPartida = "Sam";
                    escribiendoNombrePartida = true;
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
