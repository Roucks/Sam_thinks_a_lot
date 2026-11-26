boolean nv3PresentacionVista = false;
// BARRELBOUND '81: adaptación del Prueba_imagen.pde enviado por el usuario.
// Conserva las tres fases, físicas, habilidades y controles originales.
// Solo se aislaron los nombres para convivir con las otras pestañas y se adaptó el contexto al celular.
int nv3Ancho = 960;
int nv3Alto = 800;
int nv3MouseX = 0;
int nv3MouseY = 0;

/*
  BARRELBOUND '81
  Processing 3/4 — modo Java.

  Bibliotecas:
    Video
    Sound

  Conserva tu carpeta data con:
    maquina_retro_hd_transparente.png
    video_fondo.mp4
    musica_sala.mp3 o .wav
    musica_juego.mp3 o .wav
    musica_victoria.mp3 o .wav
    Tus archivos sfx_...

  Orden:
    Historia -> maquina -> zoom -> titulo y dialogos
    -> seleccion de personaje -> juego.

  Habilidades:
    Sam: segundo salto con recarga de 3 segundos.
    Mateo: velocidad durante 2 segundos; recarga posterior de 10.
    Cristian: agarre automatico.
    Clara: escudo; recarga posterior de 10 segundos.

  Controles:
    WASD / flechas: movimiento y escaleras.
    ESPACIO: salto.
    E: habilidad.
    ENTER: avanzar / confirmar.
    P: pausa.
    R: reiniciar.
    M: volver a la maquina.
    7 / 8 / 9: debug de fases.
*/


// ============================================================
// RECURSOS Y AUDIO
// ============================================================

PImage nv3_maquina;
PImage nv3_siluetaLuz;
int[] nv3_bordeX = new int[1800];
int[] nv3_bordeY = new int[1800];
int nv3_totalBordes = 0;
Movie nv3_videoFondo;
PFont nv3_fuenteJuego;

SoundFile nv3_musicaSala;
SoundFile nv3_musicaJuego;
SoundFile nv3_musicaVictoria;

SoundFile nv3_sfxDialogo;
SoundFile nv3_sfxMoneda;
SoundFile nv3_sfxZoom;
SoundFile nv3_sfxSalto;
SoundFile nv3_sfxDobleSalto;
SoundFile nv3_sfxFicha;
SoundFile nv3_sfxVidaExtra;
SoundFile nv3_sfxVelocidad;
SoundFile nv3_sfxEscudo;
SoundFile nv3_sfxAgarre;
SoundFile nv3_sfxAturdido;
SoundFile nv3_sfxGolpe;
SoundFile nv3_sfxMeta;
SoundFile nv3_sfxGameover;
SoundFile nv3_sfxFoto;

int nv3_pistaActual = 0;

// ============================================================
// ESTADOS GENERALES
// ============================================================

// -1: historia, seleccion o juego.
//  0: maquina.
//  1: zoom.
//  2: titulo y nuevos dialogos.

int nv3_estadoMenu = -1;

int nv3_pantalla = 0;
int nv3_personaje = 0;
int nv3_fase = 1;

boolean nv3_imagenLista = false;
boolean nv3_videoListo = false;
boolean nv3_cursorSobreBoton = false;

boolean nv3_modoDebug = false;
boolean nv3_pausa = false;

int nv3_vidas = 4;
boolean nv3PerdioVidaEnIntento = false;
int nv3_intentosFase = 0;
int nv3_puntosCheckpoint = 0;
int nv3_puntos = 0;
int nv3_recordPuntos = 0;
int nv3_dialogo = 0;
int nv3_decision = 0;
int nv3_reloj = 0;
int nv3_tiempoFase = 0;

int nv3_esperaBarril = 143;
int nv3_numeroBarriles = 0;

final int nv3_LIMITE_TIEMPO = 4500;
final float nv3_PASO = 1000.0 / 60.0;

int nv3_tiempoRestante = nv3_LIMITE_TIEMPO;
int nv3_avisoFichas = 0;
int nv3_sacudida = 0;
int nv3_ultimoTiempo = 0;

boolean nv3_bonoFichas = false;

float nv3_acumulado = 0;

// ============================================================
// CONTROLES
// ============================================================

boolean[] nv3_teclas = new boolean[8];
boolean[] nv3_retenidas = new boolean[256];

int[] nv3_codigosFlecha = {
  LEFT, RIGHT, UP, DOWN
};

boolean nv3_saltoPulsado = false;
boolean nv3_especialPulsado = false;

// ============================================================
// JUGADOR Y HABILIDADES
// ============================================================

float nv3_px = 105;
float nv3_py = 700;
float nv3_vx = 0;
float nv3_vy = 0;

float nv3_anteriorX = 0;
float nv3_anteriorY = 0;

float nv3_gravedad = 0.68;
float nv3_impulso = 7.5;
float nv3_rapidez = 2.4;
final float nv3_CONTROL_AIRE = 0.55;

int nv3_suelo = -1;
int nv3_escalera = -1;
int nv3_saltos = 0;
int nv3_mirada = 1;

int nv3_bufferSalto = 0;
int nv3_aturdimiento = 0;
int nv3_invulnerable = 0;

int nv3_recarga = 0;
int nv3_recargaTotal = 600;
int nv3_brilloRecarga = 0;

int nv3_velocidadExtra = 0;
int nv3_escudo = 0;

int nv3_agarre = 0;
int nv3_bloqueoAgarre = 0;
int nv3_tipoAgarre = 0;
int nv3_objetivoAgarre = -1;

float nv3_agarreX = 0;
float nv3_agarreY = 0;

String[] nv3_nombres = {
  "SAM", "MATEO", "CRISTIAN", "CLARA"
};

int[][] nv3_colores = {
  {88, 205, 255},
  {255, 181, 77},
  {167, 139, 250},
  {105, 238, 178}
};

String[][] nv3_habilidades = {
  {"DOBLE SALTO", "Espacio en el aire", "Recarga: 3 segundos"},
  {"SUPER VELOCIDAD", "E: dura 2 segundos", "Recarga: 10 segundos"},
  {"AGARRE DE EMERGENCIA", "Automatico: max. 2s", "Espacio para subir"},
  {"ESCUDO PROTECTOR", "E: 1 impacto / 2.5s", "Recarga: 10 segundos"}
};

String[] nv3_ayudaHabilidad = {
  "ESPACIO x2 | doble salto cada 3s",
  "E: velocidad 2s",
  "Agarre automatico | ESPACIO: subir | S: soltar",
  "E: escudo 1 golpe / 2.5s"
};

// ============================================================
// MAPAS
// Plataforma: inicioX, finX, alturaInicial, alturaFinal, fila.
// ============================================================

String[] nv3_nombresFase = {
  "RAMPAS CLASICAS",
  "FABRICA DE JUGUETES",
  "PARKOUR FINAL"
};

float[][][] nv3_mapas = {
  {
    {55, 905, 700, 675, 0},
    {55, 905, 569, 594, 1},
    {55, 905, 488, 463, 2},
    {55, 905, 357, 382, 3},
    {55, 905, 276, 251, 4},
    {55, 905, 170, 195, 5}
  },
  {
    {55, 905, 700, 700, 0},
    {55, 455, 594, 594, 1},
    {495, 905, 594, 594, 1},
    {55, 905, 488, 488, 2},
    {55, 435, 382, 382, 3},
    {475, 905, 382, 382, 3},
    {55, 905, 276, 276, 4},
    {55, 905, 170, 170, 5}
  },
  {
    {55, 320, 700, 700, 0},
    {358, 620, 692, 692, 0},
    {658, 905, 700, 700, 0},

    {55, 195, 594, 594, 1},
    {233, 373, 586, 586, 1},
    {411, 551, 594, 594, 1},
    {589, 729, 586, 586, 1},
    {767, 905, 594, 594, 1},

    {55, 180, 488, 488, 2},
    {218, 358, 480, 480, 2},
    {396, 536, 488, 488, 2},
    {574, 714, 480, 480, 2},
    {752, 905, 488, 488, 2},

    {55, 205, 382, 382, 3},
    {243, 383, 374, 374, 3},
    {421, 561, 382, 382, 3},
    {599, 739, 374, 374, 3},
    {777, 905, 382, 382, 3},

    {55, 185, 276, 276, 4},
    {223, 363, 268, 268, 4},
    {401, 541, 276, 276, 4},
    {579, 719, 268, 268, 4},
    {757, 905, 276, 276, 4},

    {55, 255, 170, 170, 5},
    {293, 493, 162, 162, 5},
    {531, 731, 170, 170, 5},
    {769, 905, 170, 170, 5}
  }
};

// Escalera: x, plataformaBase, plataformaSuperior, rota.

int[][][] nv3_mapasEscaleras = {
  {
    {820, 0, 1, 0},
    {140, 1, 2, 0},
    {820, 2, 3, 0},
    {140, 3, 4, 0},
    {820, 4, 5, 0},
    {480, 0, 1, 1},
    {480, 1, 2, 1},
    {480, 2, 3, 1}
  },
  {
    {820, 0, 2, 0},
    {140, 1, 3, 0},
    {820, 3, 5, 0},
    {140, 4, 6, 0},
    {820, 6, 7, 0},
    {650, 0, 2, 1},
    {310, 1, 3, 1},
    {650, 3, 5, 1}
  },
  {
    {820, 2, 7, 0},
    {140, 3, 8, 0},
    {820, 12, 17, 0},
    {140, 13, 18, 0},
    {820, 22, 26, 0}
  }
};

float[][][] nv3_mapasCintas = {
  {},
  {
    {0, 250, 700, 2.6},
    {3, 230, 740, -2.6},
    {6, 270, 730, 2.6}
  },
  {}
};

int[][] nv3_mapasFichas = {
  {0, 1, 2, 3, 4, 5},
  {0, 1, 3, 5, 6, 7},
  {1, 4, 10, 15, 21, 24}
};

int[][] nv3_mapasFuegos = {
  {2},
  {2, 4},
  {10, 16}
};

int[] nv3_metas = {
  5, 7, 23
};

float[][] nv3_plataformas = nv3_mapas[0];
int[][] nv3_escaleras = nv3_mapasEscaleras[0];
float[][] nv3_cintas = nv3_mapasCintas[0];

int[] nv3_pisosFicha = nv3_mapasFichas[0];
int[] nv3_pisosFuego = nv3_mapasFuegos[0];

boolean[] nv3_fichas = new boolean[6];

// ============================================================
// GENERADORES, BARRILES Y FUEGOS
// ============================================================

int[][] nv3_generadoresParkour = {
  {26, 787, 1},
  {23, 237, -1},
  {25, 549, 1},
  {22, 887, -1},
  {18, 73, 1},
  {16, 721, -1},
  {11, 592, 1},
  {6, 711, -1},
  {20, 470, 0},
  {14, 313, 0},
  {9, 340, -1}
};

int[] nv3_contadorSalidas = new int[TAM_NV3_GENERADORES_PARKOUR];

final int nv3_MAX_BARRILES = 16;

float[] nv3_barrilX = new float[nv3_MAX_BARRILES];
float[] nv3_barrilY = new float[nv3_MAX_BARRILES];
float[] nv3_barrilVX = new float[nv3_MAX_BARRILES];
float[] nv3_barrilVY = new float[nv3_MAX_BARRILES];

int[] nv3_pisoBarril = new int[nv3_MAX_BARRILES];
int[] nv3_omitirBarril = new int[nv3_MAX_BARRILES];
int[] nv3_escaleraBarril = new int[nv3_MAX_BARRILES];
int[] nv3_ladoBarril = new int[nv3_MAX_BARRILES];

boolean[] nv3_barrilActivo = new boolean[nv3_MAX_BARRILES];
boolean[] nv3_barrilPuntuado = new boolean[nv3_MAX_BARRILES];
boolean[] nv3_barrilBota = new boolean[nv3_MAX_BARRILES];

float[] nv3_fuegoX = new float[2];
int[] nv3_fuegoDir = new int[2];
boolean[] nv3_fuegoPersigue = new boolean[2];

// ============================================================
// HISTORIA
// ============================================================

String[][][] nv3_conversaciones = {
  {
    {
      "MATEO",
      "Es esta. Miren ese joystick,",
      "está todo torcido."
    },
    {
      "CRISTIAN",
      "Mientras funcione... ¿Quién tiene la ficha?",
      "Yo solo traje billete."
    },
    {
      "CLARA",
      "Yo tengo una. Pero me dejan jugar también.",
      "Nada de quedarse pegados toda la tarde."
    },
    {
      "SAM",
      "¿Me dejan empezar?",
      "Después sigo mirando mientras juegan ustedes."
    },
    {
      "MATEO",
      "Dale. Ponemos la ficha y miramos.",
      "Si se queda con la plata, le hablamos al señor."
    }
  },
  {
    {
      "MATEO",
      "¡Subiste! Yo pensé que ese último",
      "barril sí te iba a dar."
    },
    {
      "CRISTIAN",
      "Pásate para acá, que ahora voy yo.",
      "Ya vi por dónde hay que subir."
    },
    {
      "CLARA",
      "Esperen, no toquen. Salió la foto.",
      "Acérquense que Cristian no cabe."
    },
    {
      "SAM",
      "Córrete un poquito, Mateo.",
      "Ahí sí. No se muevan."
    }
  }
};

String[] nv3_opcionesFoto = {
  "Publicar la fotografia ahora",
  "Preguntarles antes de compartirla",
  "Guardarla como recuerdo sin publicarla"
};

String[][] nv3_cierres = {
  {
    "Clara: Oye, ya la subiste? Yo queria recortarla un poco.",
    "Sam: Cierto, perdon. La quito y elegimos una juntos.",
    "Mateo: Una donde no parezca que el barril me gano."
  },
  {
    "Sam: Les gusta esta para compartirla?",
    "Clara: Si! Etiquetame. Cristian: Espera, dejame verla... vale.",
    "Mateo: Pon que yo fui el entrenador. Es un dato importante."
  },
  {
    "Sam: Esta me la guardo. Me gusta tenerla para nosotros.",
    "Clara: Pasamela despues. Cristian: A mi tambien.",
    "Mateo: Perfecto. Ahora vamos por el record de la otra maquina."
  }
};

String[][] nv3_consejos = {
  {
    "La fabrica mueve el suelo bajo tus pies.",
    "Cruza huecos cortos. Las cintas empujan con fuerza."
  },
  {
    "21 huecos de 38px. Salta cerca del borde.",
    "Puedes ajustar el salto en el aire. Mira los generadores."
  }
};

// ============================================================
// CONVERSACION NUEVA DEL TITULO
// ============================================================

int nv3_dialogoArcade = 0;
boolean nv3_dialogosArcadeTerminados = false;

int[] nv3_hablantesArcade = {
  0, 3, 1, 2, 0, 1, 2, 3, 0, 1
};

String[][] nv3_charlaArcade = {
  {
    "¿Le damos de una o miramos cómo se juega?",
    "No he tocado una máquina de estas."
  },
  {
    "Mira primero. No nos gastes la ficha",
    "en dos segundos, ¿sí?"
  },
  {
    "Es una ficha entre todos.",
    "Tampoco me lo pongan nervioso."
  },
  {
    "Sam empieza. Cuando pierda, me toca a mí.",
    "Yo ya voy pidiendo turno."
  },
  {
    "Ah, ya me estás echando",
    "y ni he tocado nada."
  },
  {
    "Primero escoge. Tranquilo,",
    "no te vamos a quitar el puesto."
  },
  {
    "Bueno, pero no te quedes toda",
    "la tarde escogiendo."
  },
  {
    "Déjalo. Las instrucciones están al lado.",
    "Si no entiende algo, miramos ahí."
  },
  {
    "Ya. Voy con este. Pero no me hablen",
    "todos al tiempo que me desconcentro."
  },
  {
    "Listo, listo. Ya nos callamos.",
    "A ver cuánto duras."
  }
};

// ============================================================
// MAQUINA, ZOOM Y FUENTE PIXELADA
// ============================================================

float nv3_escalaInicial, nv3_imagenXInicial, nv3_imagenYInicial;
float nv3_escalaActual, nv3_imagenXActual, nv3_imagenYActual;
float nv3_escalaFinal, nv3_imagenXFinal, nv3_imagenYFinal;

float nv3_pantallaX = 0.305;
float nv3_pantallaY = 0.280;
float nv3_pantallaAncho = 0.390;
float nv3_pantallaAlto = 0.310;

float nv3_botonX, nv3_botonY, nv3_botonAncho, nv3_botonAlto;
float nv3_escalaHover = 1;
float nv3_escalaBotonBase = 1;

int nv3_inicioZoom;
int nv3_duracionZoom = 1700;

float nv3_progresoZoom = 0;
float nv3_suavizadoZoom = 0;

String nv3_caracteresArcade = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789:! ";

String[] nv3_glifosCompactos = {
  "01110110111101111111110111101111011",
  "11110110111101111110110111101111110",
  "01111110001100011000110001100001111",
  "11110110111101111011110111101111110",
  "11111110001100011110110001100011111",
  "11111110001100011110110001100011000",
  "01111110001100011011110111101101111",
  "11011110111101111111110111101111011",
  "01110001000010000100001000010001110",
  "00111000110001100011110111101101110",
  "11011110111111011100111101101111011",
  "11000110001100011000110001100011111",
  "11011111111111111011110111101111011",
  "11011111111111111111110111101111011",
  "01110110111101111011110111101101110",
  "11110110111101111110110001100011000",
  "01110110111101111011111110111000011",
  "11110110111101111110110111101111011",
  "01111110001100001110000110001111110",
  "11111001000010000100001000010000100",
  "11011110111101111011110111101101110",
  "11011110111101111011110110111000100",
  "11011110111101111011111111111111011",
  "11011110110111000100011101101111011",
  "11011110111101101110001000010000100",
  "11111000110011001100110001100011111",
  "01110110111101111011110111101101110",
  "00110011100011000110001100011001111",
  "01110110110001101110110001100011111",
  "11110000110001101110000110001111110",
  "11011110111101111111000110001100011",
  "11111110001100011110000110001111110",
  "01111110001100011110110111101101110",
  "11111000110001100110011000110001100",
  "01110110111101101110110111101101110",
  "01110110111101101111000110001111110",
  "00000001100011000000001100011000000",
  "00110001100011000110000000011000110",
  "00000000000000000000000000000000000",
  "00110001100010000000000000000000000"
};

// ============================================================
// MOTOR DE AUDIO
// ============================================================

SoundFile nv3_cargarSonido(String nv3_nombreBase) {
  SoundFile archivo = null;

  String rutaWav = nv3_nombreBase + ".wav";
  String rutaMp3 = nv3_nombreBase + ".mp3";

  if (dataFile(rutaWav).exists()) {
    archivo = new SoundFile(this, rutaWav);
    println("Audio cargado: " + rutaWav);
  }

  if (archivo == null && dataFile(rutaMp3).exists()) {
    archivo = new SoundFile(this, rutaMp3);
    println("Audio cargado: " + rutaMp3);
  }

  return archivo;
}

void nv3_inicializarAudios() {
  nv3_musicaSala = nv3_cargarSonido("musica_sala");
  nv3_musicaJuego = nv3_cargarSonido("musica_juego");
  nv3_musicaVictoria = nv3_cargarSonido("musica_victoria");

  nv3_sfxDialogo = nv3_cargarSonido("sfx_dialogo");
  nv3_sfxMoneda = nv3_cargarSonido("sfx_moneda");
  nv3_sfxZoom = nv3_cargarSonido("sfx_zoom");
  nv3_sfxSalto = nv3_cargarSonido("sfx_salto");
  nv3_sfxDobleSalto = nv3_cargarSonido("sfx_doble_salto");
  nv3_sfxFicha = nv3_cargarSonido("sfx_ficha");
  nv3_sfxVidaExtra = nv3_cargarSonido("sfx_vida_extra");
  nv3_sfxVelocidad = nv3_cargarSonido("sfx_velocidad");
  nv3_sfxEscudo = nv3_cargarSonido("sfx_escudo");
  nv3_sfxAgarre = nv3_cargarSonido("sfx_agarre");
  nv3_sfxAturdido = nv3_cargarSonido("sfx_aturdido");
  nv3_sfxGolpe = nv3_cargarSonido("sfx_golpe");
  nv3_sfxMeta = nv3_cargarSonido("sfx_meta");
  nv3_sfxGameover = nv3_cargarSonido("sfx_gameover");
  nv3_sfxFoto = nv3_cargarSonido("sfx_foto");
}

void nv3_sonar(SoundFile nv3_sfx) {
  if (nv3_sfx != null) {
    if (nv3_sfx.isPlaying()) {
      nv3_sfx.stop();
    }
    nv3_sfx.amp(constrain(volMaster, 0, 1));
    nv3_sfx.play();
  }
}

void nv3_detenerTodaLaMusica() {
  if (nv3_musicaSala != null && nv3_musicaSala.isPlaying()) {
    nv3_musicaSala.stop();
  }
  if (nv3_musicaJuego != null && nv3_musicaJuego.isPlaying()) {
    nv3_musicaJuego.stop();
  }
  if (nv3_musicaVictoria != null && nv3_musicaVictoria.isPlaying()) {
    nv3_musicaVictoria.stop();
  }
  nv3_pistaActual = 0;
}

void nv3_cambiarMusica(int nv3_nuevaPista) {
  if (nv3_pistaActual != nv3_nuevaPista) {
    nv3_detenerTodaLaMusica();
    nv3_pistaActual = nv3_nuevaPista;

    if (nv3_nuevaPista == 1 && nv3_musicaSala != null) {
      nv3_musicaSala.amp(0.45f * volMaster);
      nv3_musicaSala.loop();
    }
    if (nv3_nuevaPista == 2 && nv3_musicaJuego != null) {
      nv3_musicaJuego.amp(0.50f * volMaster);
      nv3_musicaJuego.loop();
    }
    if (nv3_nuevaPista == 3 && nv3_musicaVictoria != null) {
      nv3_musicaVictoria.amp(0.50f * volMaster);
      nv3_musicaVictoria.loop();
    }
  }
}

void nv3_actualizarMusicaSegunEstado() {
  if (nv3_musicaSala != null) nv3_musicaSala.amp(0.45f * volMaster);
  if (nv3_musicaJuego != null) nv3_musicaJuego.amp(0.50f * volMaster);
  if (nv3_musicaVictoria != null) nv3_musicaVictoria.amp(0.50f * volMaster);

  if (enPausa) {
    if (nv3_musicaSala != null && nv3_musicaSala.isPlaying()) nv3_musicaSala.pause();
    if (nv3_musicaJuego != null && nv3_musicaJuego.isPlaying()) nv3_musicaJuego.pause();
    if (nv3_musicaVictoria != null && nv3_musicaVictoria.isPlaying()) nv3_musicaVictoria.pause();
  } else {
    int deseada = 1;

    if (nv3_estadoMenu < 0) {
      if (nv3_pantalla == 2 || nv3_pantalla == 3) {
        deseada = 2;
      }
      if (nv3_pantalla == 4) {
        deseada = 0;
      }
      if (nv3_pantalla >= 5) {
        deseada = 3;
      }
    }

    nv3_cambiarMusica(deseada);

    if (nv3_estadoMenu < 0 && nv3_pantalla == 2 && nv3_pausa) {
      if (nv3_musicaJuego != null && nv3_musicaJuego.isPlaying()) {
        nv3_musicaJuego.pause();
      }
    } else {
      if (nv3_pistaActual == 1 && nv3_musicaSala != null && !nv3_musicaSala.isPlaying()) {
        nv3_musicaSala.loop();
      }
      if (nv3_pistaActual == 2 && nv3_musicaJuego != null && !nv3_musicaJuego.isPlaying()) {
        nv3_musicaJuego.loop();
      }
      if (nv3_pistaActual == 3 && nv3_musicaVictoria != null && !nv3_musicaVictoria.isPlaying()) {
        nv3_musicaVictoria.loop();
      }
    }
  }
}

// ============================================================
// SETUP Y DRAW
// ============================================================

void nv3_setup() {




  imageMode(CORNER);
  rectMode(CORNER);

  nv3_fuenteJuego = createFont("Monospaced", 16);
  textFont(nv3_fuenteJuego);

  nv3_maquina = loadImage("maquina_retro_hd_transparente.png");

  if (nv3_maquina == null) {
    nv3_maquina = loadImage("maquina_retro.png");
  }
  if (nv3_maquina == null) {
    nv3_maquina = loadImage("maquina_retro.jpeg");
  }

  nv3_imagenLista = nv3_maquina != null;
  if (nv3_imagenLista) nv3_prepararResplandor();

  if (dataFile("video_fondo.mp4").exists()) {
    nv3_videoFondo = new Movie(this, "video_fondo.mp4");
    nv3_videoListo = true;
  }

  if (nv3_imagenLista) {
    nv3_calcularEncuadres();
  }

  nv3_inicializarAudios();
  nv3_reiniciarPartida();

  nv3_pantalla = 0;
  nv3_estadoMenu = -1;
  nv3_ultimoTiempo = millis();
}

void nv3_draw() {
  int ahora = millis();

  nv3_actualizarMusicaSegunEstado();

  if (nv3_estadoMenu >= 0) {
    nv3_ultimoTiempo = ahora;

    if (!nv3_imagenLista) {
      nv3_dibujarErrorImagen();
    }

    if (nv3_imagenLista) {
      if (nv3_estadoMenu == 0) {
        if (!enPausa) {
          nv3_actualizarBoton();
        }
        nv3_dibujarResplandor();
        nv3_dibujarVideoPantalla();
        nv3_dibujarMaquina();
        nv3_dibujarDestellosBorde();
        nv3_dibujarBoton();
      }

      if (nv3_estadoMenu == 1) {
        if (!enPausa) {
          nv3_actualizarZoom();
        }

        if (nv3_estadoMenu == 1) {
          nv3_dibujarVideoPantalla();
          nv3_dibujarMaquina();
        }
      }

      if (nv3_estadoMenu == 2) {
        nv3_dibujarPantallaTituloVideo();
        nv3_dibujarEfectoCRT();
      }
    }
  }

  if (nv3_estadoMenu < 0) {
    int pantallaDibujadaArcade = nv3_pantalla;
    textFont(nv3_fuenteJuego);

    if (!enPausa) {
      nv3_avanzarTiempo(constrain(ahora - nv3_ultimoTiempo, 0, 100));
    }
    nv3_ultimoTiempo = ahora;

    background(13, 15, 32);

    if (pantallaDibujadaArcade == 0) nv3_dibujarHistoria(false);
    if (pantallaDibujadaArcade == 1) nv3_dibujarSeleccion();

    if (pantallaDibujadaArcade == 2) {
      nv3_dibujarJuego();
      if (nv3_pausa && !enPausa) nv3_dibujarPausa();
    }

    if (pantallaDibujadaArcade == 3) nv3_dibujarTransicion();
    if (pantallaDibujadaArcade == 4) nv3_dibujarDerrota();
    if (pantallaDibujadaArcade == 5) nv3_dibujarHistoria(true);
    if (pantallaDibujadaArcade == 6) nv3_dibujarFoto();
    if (pantallaDibujadaArcade == 7) nv3_dibujarCierre();

    if (pantallaDibujadaArcade >= 1 && pantallaDibujadaArcade <= 4) {
      nv3_dibujarEfectoCRT();
    }
  }
}

void nv3_movieEvent(Movie nv3_m) {
  nv3_m.read();
}

// ============================================================
// EFECTO CRT
// ============================================================

void nv3_dibujarEfectoCRT() {
  // Los reflejos y el marco se dibujan directamente sobre la escena.
  noStroke();
  fill(0, 0, 0, 22);

  int sy = 0;

  while (sy < nv3Alto) {
    rect(0, sy, nv3Ancho, 1);
    sy += 3;
  }

  noFill();
  stroke(255, 255, 255, 8);
  strokeWeight(22);

  float des = (millis() * 0.025) % 200;
  int b = -1;

  while (b < 5) {
    float by = b * 200 + des;

    bezier(
      0, by,
      nv3Ancho * 0.35, by - 28,
      nv3Ancho * 0.65, by + 28,
      nv3Ancho, by
    );

    b++;
  }

  noStroke();

  fill(255, 255, 255, 16);
  quad(0, 0, 350, 0, 140, nv3Alto, 0, nv3Alto);

  fill(255, 255, 255, 12);
  quad(380, 0, 445, 0, 235, nv3Alto, 170, nv3Alto);

  noFill();

  stroke(0, 0, 0, 75);
  strokeWeight(20);
  nv3_trazarContornoTubo(14, 42);

  stroke(0, 0, 0, 150);
  strokeWeight(14);
  nv3_trazarContornoTubo(16, 46);

  noStroke();
  fill(12, 12, 16);

  beginShape();

  vertex(0, 0);
  vertex(nv3Ancho, 0);
  vertex(nv3Ancho, nv3Alto);
  vertex(0, nv3Alto);

  beginContour();

  vertex(58, 14);
  bezierVertex(16, 14, 14, 16, 14, 58);

  bezierVertex(
    4, nv3Alto * 0.33,
    4, nv3Alto * 0.67,
    14, nv3Alto - 58
  );

  bezierVertex(
    14, nv3Alto - 16,
    16, nv3Alto - 14,
    58, nv3Alto - 14
  );

  bezierVertex(
    nv3Ancho * 0.33, nv3Alto - 4,
    nv3Ancho * 0.67, nv3Alto - 4,
    nv3Ancho - 58, nv3Alto - 14
  );

  bezierVertex(
    nv3Ancho - 16, nv3Alto - 14,
    nv3Ancho - 14, nv3Alto - 16,
    nv3Ancho - 14, nv3Alto - 58
  );

  bezierVertex(
    nv3Ancho - 4, nv3Alto * 0.67,
    nv3Ancho - 4, nv3Alto * 0.33,
    nv3Ancho - 14, 58
  );

  bezierVertex(
    nv3Ancho - 14, 16,
    nv3Ancho - 16, 14,
    nv3Ancho - 58, 14
  );

  bezierVertex(
    nv3Ancho * 0.67, 4,
    nv3Ancho * 0.33, 4,
    58, 14
  );

  endContour();
  endShape(CLOSE);

  noFill();

  stroke(46, 48, 58);
  strokeWeight(7);
  nv3_trazarContornoTubo(14, 58);

  stroke(18, 20, 26);
  strokeWeight(3);
  nv3_trazarContornoTubo(16, 58);

  stroke(255, 255, 255, 38);
  strokeWeight(3);
  bezier(62, 16, 22, 16, 16, 22, 16, 62);

  noStroke();
}

void nv3_trazarContornoTubo(float nv3_m, float nv3_c) {
  float arco = nv3_m - 10;

  beginShape();

  vertex(nv3_c, nv3_m);

  bezierVertex(
    nv3Ancho * 0.33, arco,
    nv3Ancho * 0.67, arco,
    nv3Ancho - nv3_c, nv3_m
  );

  bezierVertex(
    nv3Ancho - nv3_m, nv3_m,
    nv3Ancho - nv3_m, nv3_m,
    nv3Ancho - nv3_m, nv3_c
  );

  bezierVertex(
    nv3Ancho - arco, nv3Alto * 0.33,
    nv3Ancho - arco, nv3Alto * 0.67,
    nv3Ancho - nv3_m, nv3Alto - nv3_c
  );

  bezierVertex(
    nv3Ancho - nv3_m, nv3Alto - nv3_m,
    nv3Ancho - nv3_m, nv3Alto - nv3_m,
    nv3Ancho - nv3_c, nv3Alto - nv3_m
  );

  bezierVertex(
    nv3Ancho * 0.67, nv3Alto - arco,
    nv3Ancho * 0.33, nv3Alto - arco,
    nv3_c, nv3Alto - nv3_m
  );

  bezierVertex(
    nv3_m, nv3Alto - nv3_m,
    nv3_m, nv3Alto - nv3_m,
    nv3_m, nv3Alto - nv3_c
  );

  bezierVertex(
    arco, nv3Alto * 0.67,
    arco, nv3Alto * 0.33,
    nv3_m, nv3_c
  );

  bezierVertex(nv3_m, nv3_m, nv3_m, nv3_m, nv3_c, nv3_m);

  endShape(CLOSE);
}

// ============================================================
// MAQUINA Y ZOOM
// ============================================================

void nv3_calcularEncuadres() {
  nv3_escalaInicial = min(
    nv3Ancho / float(nv3_maquina.width),
    nv3Alto / float(nv3_maquina.height)
  ) * 0.96;

  float anchoVisible = nv3_maquina.width * nv3_escalaInicial;
  float altoVisible = nv3_maquina.height * nv3_escalaInicial;

  nv3_imagenXInicial = (nv3Ancho - anchoVisible) / 2.0;
  nv3_imagenYInicial = (nv3Alto - altoVisible) / 2.0;

  nv3_botonX = nv3_imagenXInicial + anchoVisible * 0.5;
  nv3_botonY = nv3_imagenYInicial + altoVisible * 0.692;

  nv3_botonAncho = nv3_maquina.width * 0.21;
  nv3_botonAlto = nv3_maquina.height * 0.036;

  float monitorX = nv3_maquina.width * nv3_pantallaX;
  float monitorY = nv3_maquina.height * nv3_pantallaY;

  float monitorAncho = nv3_maquina.width * nv3_pantallaAncho;
  float monitorAlto = nv3_maquina.height * nv3_pantallaAlto;

  float monitorCentroX = monitorX + monitorAncho / 2.0;
  float monitorCentroY = monitorY + monitorAlto / 2.0;

  nv3_escalaFinal = max(
    nv3Ancho / monitorAncho,
    nv3Alto / monitorAlto
  );

  nv3_imagenXFinal = nv3Ancho / 2.0 - monitorCentroX * nv3_escalaFinal;
  nv3_imagenYFinal = nv3Alto / 2.0 - monitorCentroY * nv3_escalaFinal;
}

void nv3_prepararMenu() {
  nv3_estadoMenu = 0;

  nv3_escalaActual = nv3_escalaInicial;
  nv3_imagenXActual = nv3_imagenXInicial;
  nv3_imagenYActual = nv3_imagenYInicial;

  nv3_escalaHover = 1;
  nv3_progresoZoom = 0;
  nv3_suavizadoZoom = 0;

  nv3_cursorSobreBoton = false;

  nv3_limpiarControles();

  if (nv3_videoListo) {
    nv3_videoFondo.loop();
    nv3_videoFondo.volume(0);
  }

  cursor(ARROW);
}

void nv3_dibujarVideoPantalla() {
  float nv3_x = nv3_imagenXActual + nv3_maquina.width * nv3_pantallaX * nv3_escalaActual;
  float nv3_y = nv3_imagenYActual + nv3_maquina.height * nv3_pantallaY * nv3_escalaActual;
  float nv3_w = nv3_maquina.width * nv3_pantallaAncho * nv3_escalaActual;
  float nv3_h = nv3_maquina.height * nv3_pantallaAlto * nv3_escalaActual;

  noStroke();
  fill(13, 18, 34);
  rect(nv3_x, nv3_y, nv3_w, nv3_h);

  if (nv3_videoListo) {
    image(nv3_videoFondo, nv3_x, nv3_y, nv3_w, nv3_h);
  }

  fill(0, 0, 0, 38);

  float sy = nv3_y;

  while (sy < nv3_y + nv3_h) {
    rect(nv3_x, sy, nv3_w, 1.5);
    sy += 3.5;
  }

  fill(255, 255, 255, 18);

  quad(
    nv3_x, nv3_y,
    nv3_x + nv3_w * 0.42, nv3_y,
    nv3_x + nv3_w * 0.16, nv3_y + nv3_h,
    nv3_x, nv3_y + nv3_h
  );

  noFill();
  stroke(0, 0, 0, 120);
  strokeWeight(6);

  rect(nv3_x + 2, nv3_y + 2, nv3_w - 4, nv3_h - 4, 10);

  noStroke();
}

void nv3_dibujarMaquina() {
  image(
    nv3_maquina,
    nv3_imagenXActual,
    nv3_imagenYActual,
    nv3_maquina.width * nv3_escalaActual,
    nv3_maquina.height * nv3_escalaActual
  );
}

void nv3_iniciarZoom() {
  nv3_sonar(nv3_sfxMoneda);
  nv3_sonar(nv3_sfxZoom);

  nv3_estadoMenu = 1;
  nv3_inicioZoom = millis();

  nv3_progresoZoom = 0;
  nv3_suavizadoZoom = 0;

  cursor(ARROW);
}

void nv3_actualizarZoom() {
  boolean flujoRetornoActivo = true;

  nv3_progresoZoom = constrain((millis() - nv3_inicioZoom) / PApplet.parseFloat(nv3_duracionZoom), 0, 1);

  float t = nv3_progresoZoom;
  nv3_suavizadoZoom = t * t * t * (t * (t * 6 - 15) + 10);

  nv3_escalaActual = lerp(nv3_escalaInicial, nv3_escalaFinal, nv3_suavizadoZoom);
  nv3_imagenXActual = lerp(nv3_imagenXInicial, nv3_imagenXFinal, nv3_suavizadoZoom);
  nv3_imagenYActual = lerp(nv3_imagenYInicial, nv3_imagenYFinal, nv3_suavizadoZoom);

  if (nv3_progresoZoom >= 1) {
    nv3_escalaActual = nv3_escalaFinal;
    nv3_imagenXActual = nv3_imagenXFinal;
    nv3_imagenYActual = nv3_imagenYFinal;

    nv3_estadoMenu = 2;
    if (nv3PresentacionVista) {
      nv3_irASeleccionDePersonaje();
      {
        flujoRetornoActivo = false;
      }
    }
    if (flujoRetornoActivo) {

      nv3_dialogoArcade = 0;
      nv3_dialogosArcadeTerminados = false;
      nv3_escalaHover = 1;

    }
  }
}

// ============================================================
// BOTON JUGAR
// ============================================================

void nv3_actualizarDisposicionBoton() {
  if (nv3_estadoMenu == 0) {
    nv3_botonX = nv3_imagenXInicial + nv3_maquina.width * nv3_escalaInicial * 0.5;
    nv3_botonY = nv3_imagenYInicial + nv3_maquina.height * nv3_escalaInicial * 0.692;

    nv3_botonAncho = nv3_maquina.width * 0.21;
    nv3_botonAlto = nv3_maquina.height * 0.036;

    nv3_escalaBotonBase = nv3_escalaInicial;
  }

  if (nv3_estadoMenu == 2) {
    nv3_botonX = nv3Ancho / 2.0;
    nv3_botonY = nv3Alto * 0.56;

    nv3_botonAncho = 280;
    nv3_botonAlto = 64;

    nv3_escalaBotonBase = 1;
  }
}

void nv3_comprobarCursorBoton() {
  nv3_actualizarDisposicionBoton();

  float anchoVisible = nv3_botonAncho * nv3_escalaBotonBase * nv3_escalaHover;
  float altoVisible = nv3_botonAlto * nv3_escalaBotonBase * nv3_escalaHover;

  nv3_cursorSobreBoton =
    nv3MouseX >= nv3_botonX - anchoVisible / 2.0 &&
    nv3MouseX <= nv3_botonX + anchoVisible / 2.0 &&
    nv3MouseY >= nv3_botonY - altoVisible / 2.0 &&
    nv3MouseY <= nv3_botonY + altoVisible / 2.0;

  if (nv3_estadoMenu == 2 && !nv3_dialogosArcadeTerminados) {
    nv3_cursorSobreBoton = false;
  }
}

void nv3_actualizarBoton() {
  nv3_comprobarCursorBoton();

  float nv3_objetivo = 1;

  if (nv3_cursorSobreBoton) {
    nv3_objetivo = 1.08;
    cursor(HAND);
  }

  if (!nv3_cursorSobreBoton) {
    cursor(ARROW);
  }

  nv3_escalaHover = lerp(nv3_escalaHover, nv3_objetivo, 0.2);
  nv3_comprobarCursorBoton();
}

void nv3_dibujarBoton() {
  pushMatrix();

  translate(nv3_botonX, nv3_botonY);
  scale(nv3_escalaBotonBase * nv3_escalaHover);

  float nv3_w = nv3_botonAncho;
  float nv3_h = nv3_botonAlto;
  float pixel = 4;

  int nv3_borde = color(35, 16, 28);
  int fondo = color(255, 165, 25);
  int brillo = color(255, 230, 115);
  int sombra = color(185, 70, 20);

  if (nv3_cursorSobreBoton) {
    nv3_borde = color(255, 240, 150);
    fondo = color(255, 205, 55);
    brillo = color(255, 252, 195);
    sombra = color(225, 115, 25);
  }

  if (nv3_estadoMenu == 2 && !nv3_dialogosArcadeTerminados) {
    nv3_borde = color(37, 41, 56);
    fondo = color(85, 88, 104);
    brillo = color(128, 133, 150);
    sombra = color(49, 53, 69);
  }

  noStroke();

  fill(25, 12, 22, 200);
  rect(-nv3_w / 2 + pixel, -nv3_h / 2 + pixel, nv3_w - pixel * 2, nv3_h);

  fill(nv3_borde);
  rect(-nv3_w / 2 + pixel, -nv3_h / 2, nv3_w - pixel * 2, nv3_h);
  rect(-nv3_w / 2, -nv3_h / 2 + pixel, nv3_w, nv3_h - pixel * 2);

  fill(fondo);
  rect(
    -nv3_w / 2 + pixel,
    -nv3_h / 2 + pixel,
    nv3_w - pixel * 2,
    nv3_h - pixel * 2
  );

  fill(brillo);
  rect(-nv3_w / 2 + pixel, -nv3_h / 2 + pixel, nv3_w - pixel * 2, pixel);
  rect(-nv3_w / 2 + pixel, -nv3_h / 2 + pixel, pixel, nv3_h - pixel * 2);

  fill(sombra);
  rect(
    -nv3_w / 2 + pixel,
    nv3_h / 2 - pixel * 2,
    nv3_w - pixel * 2,
    pixel
  );

  float tamPixelTexto = nv3_h * 0.46 / 7.0;

  int colorArriba = color(255, 248, 170);
  int colorAbajo = color(255, 195, 50);

  if (nv3_cursorSobreBoton) {
    colorArriba = color(255, 255, 235);
    colorAbajo = color(255, 235, 110);
  }

  nv3_dibujarTextoArcade(
    "JUGAR",
    0, -tamPixelTexto * 0.35, tamPixelTexto,
    colorArriba, colorAbajo,
    color(165, 55, 45), color(25, 12, 28)
  );

  popMatrix();
}

// ============================================================
// TEXTO PIXELADO
// ============================================================

void nv3_dibujarTextoArcade(
  String nv3_texto,
  float nv3_centroX,
  float nv3_centroY,
  float nv3_p,
  int nv3_colSuperior,
  int nv3_colInferior,
  int nv3_colRelieve,
  int nv3_colContorno
) {
  String mayus = nv3_texto.toUpperCase();
  int n = mayus.length();

  float anchoTotal = (n * 6 - 1) * nv3_p;
  float altoTotal = 7 * nv3_p;
  float nv3_inicioX = nv3_centroX - anchoTotal / 2;
  float inicioY = nv3_centroY - altoTotal / 2;

  noStroke();

  int nv3_i = 0;

  while (nv3_i < n) {
    char nv3_c = leerCaracter(mayus, nv3_i);
    int idx = nv3_caracteresArcade.indexOf(nv3_c);

    if (int(nv3_c) == 39) idx = 39;
    if (idx < 0) idx = 38;

    float letraX = nv3_inicioX + nv3_i * 6 * nv3_p;
    String mapa = nv3_glifosCompactos[idx];

    int k = 0;

    while (k < 35) {
      if (leerCaracter(mapa, k) == '1') {
        int fila = k / 5;
        int col = k % 5;

        float nv3_x = letraX + col * nv3_p;
        float nv3_y = inicioY + fila * nv3_p;

        fill(nv3_colContorno);
        rect(nv3_x - nv3_p * 0.85, nv3_y, nv3_p * 2.7, nv3_p);
        rect(nv3_x, nv3_y - nv3_p * 0.85, nv3_p, nv3_p * 3.2);
        rect(nv3_x - nv3_p * 0.6, nv3_y - nv3_p * 0.6, nv3_p * 2.2, nv3_p * 2.8);
      }
      k++;
    }
    nv3_i++;
  }

  nv3_i = 0;

  while (nv3_i < n) {
    char nv3_c = leerCaracter(mayus, nv3_i);
    int idx = nv3_caracteresArcade.indexOf(nv3_c);

    if (int(nv3_c) == 39) idx = 39;
    if (idx < 0) idx = 38;

    float letraX = nv3_inicioX + nv3_i * 6 * nv3_p;
    String mapa = nv3_glifosCompactos[idx];

    int k = 0;

    while (k < 35) {
      if (leerCaracter(mapa, k) == '1') {
        int fila = k / 5;
        int col = k % 5;

        float nv3_x = letraX + col * nv3_p;
        float nv3_y = inicioY + fila * nv3_p;

        fill(nv3_colRelieve);
        rect(nv3_x, nv3_y + nv3_p * 0.85, nv3_p, nv3_p);
      }
      k++;
    }

    k = 0;

    while (k < 35) {
      if (leerCaracter(mapa, k) == '1') {
        int fila = k / 5;
        int col = k % 5;

        float nv3_x = letraX + col * nv3_p;
        float nv3_y = inicioY + fila * nv3_p;

        if (fila < 3) fill(nv3_colSuperior);
        if (fila >= 3) fill(nv3_colInferior);

        rect(nv3_x, nv3_y, nv3_p, nv3_p);
      }
      k++;
    }
    nv3_i++;
  }
}

// ============================================================
// TITULO Y DIALOGOS
// ============================================================

void nv3_dibujarPantallaTituloVideo() {
  nv3_dibujarVideoPantalla();
  nv3_dibujarMaquina();

  noStroke();
  fill(13, 18, 34, 170);
  rect(0, 0, nv3Ancho, nv3Alto);

  nv3_dibujarTextoArcade(
    "BARRELBOUND '81",
    nv3Ancho / 2.0, nv3Alto * 0.24, 5,
    color(255, 230, 90), color(255, 140, 40),
    color(150, 45, 70), color(20, 10, 25)
  );

  nv3_dibujarTextoArcade(
    "CUATRO AMIGOS. UN RECORD",
    nv3Ancho / 2.0, nv3Alto * 0.37, 2.5,
    color(150, 255, 240), color(70, 200, 210),
    color(30, 90, 110), color(15, 20, 35)
  );

  nv3_actualizarBoton();
  nv3_dibujarBoton();

  textFont(nv3_fuenteJuego);

  nv3_centrado(
    "M: volver a la maquina",
    nv3Alto * 0.69, 13, color(190, 202, 230)
  );

  float nv3_y = nv3Alto * 0.76;

  fill(20, 25, 47);
  rect(32, nv3_y, nv3Ancho - 64, nv3Alto - nv3_y - 26);

  fill(91, 111, 153);
  rect(32, nv3_y, nv3Ancho - 64, 3);

  if (!nv3_dialogosArcadeTerminados) {
    int quien = nv3_hablantesArcade[nv3_dialogoArcade];

    nv3_rotulo(
      nv3_nombres[quien],
      52, nv3_y + 29, 16, nv3_colorPersonaje(quien)
    );

    nv3_rotulo(
      nv3_charlaArcade[nv3_dialogoArcade][0],
      52, nv3_y + 65, 16, color(239, 241, 255)
    );

    nv3_rotulo(
      nv3_charlaArcade[nv3_dialogoArcade][1],
      52, nv3_y + 96, 16, color(200, 212, 236)
    );

    nv3_rotulo(
      "ENTER / ESPACIO o clic aqui: continuar  " +
      (nv3_dialogoArcade + 1) + "/" + TAM_NV3_CHARLA_ARCADE,
      52, nv3_y + 137, 12, color(255, 212, 100)
    );
  }

  if (nv3_dialogosArcadeTerminados) {
    nv3_rotulo(
      "LOS CUATRO ESTAN LISTOS",
      52, nv3_y + 32, 16, color(117, 231, 220)
    );

    nv3_rotulo(
      "Pulsa JUGAR o ENTER para elegir quien toma el mando.",
      52, nv3_y + 75, 16, color(239, 241, 255)
    );

    nv3_rotulo(
      "Un personaje por partida. Despues pueden turnarse.",
      52, nv3_y + 110, 16, color(200, 212, 236)
    );
  }
}

void nv3_avanzarDialogoArcade() {
  if (!nv3_dialogosArcadeTerminados) {
    nv3_sonar(nv3_sfxDialogo);
    nv3_dialogoArcade++;

    if (nv3_dialogoArcade >= TAM_NV3_CHARLA_ARCADE) {
      nv3_dialogosArcadeTerminados = true;
    }
  }
}

void nv3_irASeleccionDePersonaje() {
  nv3PresentacionVista = true;
  nv3_sonar(nv3_sfxDialogo);
  nv3_estadoMenu = -1;

  if (nv3_videoListo) {
    nv3_videoFondo.pause();
  }

  nv3_pantalla = 1;
  nv3_acumulado = 0;

  nv3_limpiarControles();

  nv3_ultimoTiempo = millis();
  cursor(ARROW);
}

void nv3_dibujarErrorImagen() {
  nv3_dibujarTextoArcade(
    "NO SE PUDO CARGAR LA IMAGEN",
    nv3Ancho / 2.0, nv3Alto / 2.0 - 25, 3,
    color(255, 150, 130), color(230, 90, 80),
    color(110, 30, 35), color(20, 10, 15)
  );

  nv3_dibujarTextoArcade(
    "GUARDA EL PNG EN CARPETA DATA",
    nv3Ancho / 2.0, nv3Alto / 2.0 + 25, 2.2,
    color(240), color(190, 190, 200),
    color(80, 80, 95), color(20, 10, 15)
  );
}

// ============================================================
// CONTROLES UNIFICADOS
// ============================================================

int nv3_codigoMovimiento() {
  int resultado = -1;

  if (key == CODED) {
    int nv3_i = 0;

    while (nv3_i < TAM_NV3_CODIGOS_FLECHA) {
      if (keyCode == nv3_codigosFlecha[nv3_i]) {
        resultado = nv3_i + 4;
      }
      nv3_i++;
    }
  }

  if (key != CODED) {
    resultado = "adws".indexOf(str(key).toLowerCase());
  }

  return resultado;
}

int nv3_codigoAccion() {
  int resultado = -1;

  if (key != CODED) {
    int codigo = leerCaracter(str(key).toLowerCase(), 0);

    if (codigo < TAM_NV3_RETENIDAS) {
      resultado = codigo;
    }
  }

  return resultado;
}

void nv3_keyPressed() {
  boolean eventoAtendido = false;

  if (nv3_estadoMenu == 2) {
    eventoAtendido = true;

    int accion = nv3_codigoAccion();

    if (accion >= 0 && !nv3_retenidas[accion]) {
      nv3_retenidas[accion] = true;

      if (key == 'm' || key == 'M') {
        nv3_sonar(nv3_sfxDialogo);
        nv3_prepararMenu();
      }

      if (key == ENTER || key == RETURN || key == ' ') {
        boolean habiaTerminado = nv3_dialogosArcadeTerminados;

        if (!habiaTerminado) {
          nv3_avanzarDialogoArcade();
        }

        if (habiaTerminado) {
          nv3_irASeleccionDePersonaje();
        }
      }
    }
  }

  if (!eventoAtendido && nv3_estadoMenu < 0) {
    boolean procesado = false;

    if (nv3_pantalla >= 1 && (key == 'm' || key == 'M')) {
      nv3_sonar(nv3_sfxDialogo);
      nv3_prepararMenu();
      procesado = true;
    }

    if (!procesado && nv3_modoDebug && key >= '7' && key <= '9') {
      if (!nv3_retenidas[key]) {
        nv3_retenidas[key] = true;
        nv3_iniciarNivelDebug(key - '6');
      }
      procesado = true;
    }

    int nv3_m = nv3_codigoMovimiento();

    if (!procesado && nv3_m >= 0) {
      nv3_teclas[nv3_m] = true;

      if (nv3_pantalla == 1) {
        if (nv3_m == 0 || nv3_m == 4) {
          nv3_personaje = (nv3_personaje + 3) % TAM_NV3_NOMBRES;
          nv3_sonar(nv3_sfxDialogo);
        }

        if (nv3_m == 1 || nv3_m == 5) {
          nv3_personaje = (nv3_personaje + 1) % TAM_NV3_NOMBRES;
          nv3_sonar(nv3_sfxDialogo);
        }
      }

      procesado = true;
    }

    int nv3_c = nv3_codigoAccion();

    if (!procesado && nv3_c >= 0 && !nv3_retenidas[nv3_c]) {
      nv3_retenidas[nv3_c] = true;

      if (nv3_pantalla == 1 && key >= '1' && key <= '4') {
        nv3_personaje = key - '1';
        nv3_sonar(nv3_sfxDialogo);
      }

      if (nv3_pantalla == 6 && key >= '1' && key <= '3') {
        nv3_decision = key - '1';
        nv3_sonar(nv3_sfxDialogo);
        nv3_pantalla = 7;
        procesado = true;
      }

      if (!procesado && nv3_c == 'p' && nv3_pantalla == 2) {
        nv3_pausa = !nv3_pausa;
        nv3_sonar(nv3_sfxDialogo);

        nv3_acumulado = 0;
        nv3_ultimoTiempo = millis();

        nv3_saltoPulsado = false;
        nv3_especialPulsado = false;
        procesado = true;
      }

      if (!procesado && nv3_c == 'r' && nv3_pantalla >= 2) {
        nv3_sonar(nv3_sfxDialogo);
        nv3_reiniciarPartida();
        nv3_pantalla = 1;
        procesado = true;
      }

      if (!procesado && (key == ENTER || key == RETURN)) {
        nv3_continuar();
        procesado = true;
      }

      if (!procesado && nv3_pantalla == 2 && !nv3_pausa) {
        if (nv3_c == ' ') nv3_saltoPulsado = true;
        if (nv3_c == 'e') nv3_especialPulsado = true;
      }
    }
  }
}

void nv3_keyReleased() {
  int nv3_m = nv3_codigoMovimiento();

  if (nv3_m >= 0) {
    nv3_teclas[nv3_m] = false;
  }

  if (nv3_m < 0) {
    int nv3_c = nv3_codigoAccion();

    if (nv3_c >= 0) {
      nv3_retenidas[nv3_c] = false;
    }
  }
}

void nv3_mousePressed() {
  boolean clickProcesado = false;

  if (nv3_imagenLista && nv3_estadoMenu == 0 && mouseButton == LEFT) {
    nv3_comprobarCursorBoton();

    if (nv3_cursorSobreBoton) {
      nv3_iniciarZoom();
      clickProcesado = true;
    }
  }

  if (!clickProcesado && nv3_estadoMenu == 2 && mouseButton == LEFT) {
    clickProcesado = true;

    boolean enDialogo =
      nv3MouseX >= 32 &&
      nv3MouseX <= nv3Ancho - 32 &&
      nv3MouseY >= nv3Alto * 0.76 &&
      nv3MouseY <= nv3Alto - 26;

    if (enDialogo) {
      nv3_avanzarDialogoArcade();
    }

    if (!enDialogo && nv3_dialogosArcadeTerminados) {
      nv3_comprobarCursorBoton();

      if (nv3_cursorSobreBoton) {
        nv3_irASeleccionDePersonaje();
      }
    }
  }

  if (!clickProcesado && nv3_estadoMenu < 0) {
    if (nv3_pantalla == 1 && nv3MouseY >= 255 && nv3MouseY <= 566) {
      for (int nv3_i = 0; nv3_i < TAM_NV3_NOMBRES; nv3_i++) {
        if (
          nv3MouseX >= 48 + nv3_i * 222 &&
          nv3MouseX <= 248 + nv3_i * 222
        ) {
          nv3_personaje = nv3_i;
          nv3_sonar(nv3_sfxDialogo);
        }
      }
    }

    if (nv3_pantalla == 6) {
      for (int nv3_i = 0; nv3_i < TAM_NV3_OPCIONES_FOTO; nv3_i++) {
        if (
          nv3MouseX >= 120 &&
          nv3MouseX <= 840 &&
          nv3MouseY >= 475 + nv3_i * 68 &&
          nv3MouseY <= 531 + nv3_i * 68
        ) {
          nv3_decision = nv3_i;
          nv3_sonar(nv3_sfxDialogo);
          nv3_pantalla = 7;
        }
      }
    }
  }
}

int nv3_ejeX() {
  int eje = 0;

  if (nv3_teclas[0] || nv3_teclas[4]) eje--;
  if (nv3_teclas[1] || nv3_teclas[5]) eje++;

  return eje;
}

int nv3_ejeY() {
  int eje = 0;

  if (nv3_teclas[2] || nv3_teclas[6]) eje--;
  if (nv3_teclas[3] || nv3_teclas[7]) eje++;

  return eje;
}

void nv3_limpiarControles() {
  for (int nv3_i = 0; nv3_i < TAM_NV3_TECLAS; nv3_i++) {
    nv3_teclas[nv3_i] = false;
  }

  nv3_saltoPulsado = false;
  nv3_especialPulsado = false;
}

// ============================================================
// PANTALLAS Y REINICIO
// ============================================================

void nv3_continuar() {
  boolean hecho = false;

  if (nv3_pantalla == 0) {
    nv3_sonar(nv3_sfxDialogo);
    nv3_dialogo++;

    if (nv3_dialogo >= 5) {
      if (nv3_imagenLista) {
        nv3_prepararMenu();
      }

      if (!nv3_imagenLista) {
        nv3_pantalla = 1;
        nv3_limpiarControles();
      }
    }

    hecho = true;
  }

  if (!hecho && nv3_pantalla == 1) {
    nv3_sonar(nv3_sfxMoneda);
    nv3_iniciarFase();
    nv3_pantalla = 2;
    hecho = true;
  }

  if (!hecho && nv3_pantalla == 3) {
    nv3_sonar(nv3_sfxDialogo);
    nv3_fase++;
    nv3_intentosFase = 0;
    nv3_puntosCheckpoint = nv3_puntos;
    nv3_vidas = 4;
    nv3_iniciarFase();
    nv3_pantalla = 2;
    hecho = true;
  }

  if (!hecho && nv3_pantalla == 4) {
    nv3_sonar(nv3_sfxDialogo);
    nv3_vidas = 4;
    nv3_puntos = nv3_puntosCheckpoint;
    nv3_iniciarFase();
    nv3_pantalla = 2;
    hecho = true;
  }
  if (!hecho && nv3_pantalla == 7) {
    iniciarFinalNivel3(true);
    hecho = true;
  }

  if (!hecho && nv3_pantalla == 5) {
    nv3_sonar(nv3_sfxDialogo);
    nv3_dialogo++;

    if (nv3_dialogo >= 4) {
      nv3_sonar(nv3_sfxFoto);
      nv3_pantalla = 6;
    }
  }
}

void nv3_reiniciarPartida() {
  nv3_fase = 1;
  nv3_vidas = 4;
  nv3_intentosFase = 0;
  nv3_puntosCheckpoint = 0;
  nv3_puntos = 0;
  nv3_dialogo = 0;
  nv3_reloj = 0;

  nv3_pausa = false;
  nv3_acumulado = 0;
  nv3_ultimoTiempo = millis();

  nv3_limpiarControles();
}

void nv3_iniciarNivelDebug(int nv3_numeroNivel) {
  if (nv3_numeroNivel >= 1 && nv3_numeroNivel <= TAM_NV3_MAPAS) {
    nv3_estadoMenu = -1;

    if (nv3_videoListo) {
      nv3_videoFondo.pause();
    }

    nv3_reiniciarPartida();

    nv3_fase = nv3_numeroNivel;

    nv3_iniciarFase();
    nv3_pantalla = 2;

    println("DEBUG: iniciada la fase " + nv3_fase);
  }
}

void nv3_iniciarFase() {
  nv3PerdioVidaEnIntento = false;
  nv3_plataformas = nv3_mapas[nv3_fase - 1];
  nv3_escaleras = nv3_mapasEscaleras[nv3_fase - 1];
  nv3_cintas = nv3_mapasCintas[nv3_fase - 1];

  nv3_pisosFicha = nv3_mapasFichas[nv3_fase - 1];
  nv3_pisosFuego = nv3_mapasFuegos[nv3_fase - 1];

  nv3_tiempoFase = 0;
  nv3_tiempoRestante = nv3_LIMITE_TIEMPO;

  nv3_esperaBarril = nv3_intervaloBarriles();
  nv3_numeroBarriles = 0;

  nv3_bonoFichas = false;
  nv3_avisoFichas = 0;
  nv3_sacudida = 0;
  nv3_acumulado = 0;

  nv3_ultimoTiempo = millis();

  for (int nv3_i = 0; nv3_i < TAM_NV3_FICHAS; nv3_i++) {
    nv3_fichas[nv3_i] = false;
  }

  for (int nv3_i = 0; nv3_i < TAM_NV3_BARRIL_ACTIVO; nv3_i++) {
    nv3_barrilActivo[nv3_i] = false;
  }

  for (int nv3_i = 0; nv3_i < cant_nv3_pisosFuego[nv3_fase - 1]; nv3_i++) {
    int nv3_p = nv3_pisosFuego[nv3_i];

    nv3_fuegoX[nv3_i] = lerp(
      nv3_inicioX(nv3_p) + 25,
      nv3_finX(nv3_p) - 25,
      0.3
    );

    nv3_fuegoDir[nv3_i] = 1;
    nv3_fuegoPersigue[nv3_i] = false;

    if (nv3_i % 2 == 1) {
      nv3_fuegoDir[nv3_i] = -1;
    }
  }

  nv3_reaparecer();

  for (int nv3_i = 0; nv3_i < TAM_NV3_CONTADOR_SALIDAS; nv3_i++) {
    nv3_contadorSalidas[nv3_i] = 0;
  }
}

void nv3_reaparecer() {
  nv3_px = 105;
  nv3_py = nv3_alturaPlataforma(0, nv3_px);

  nv3_vx = 0;
  nv3_vy = 0;

  nv3_suelo = 0;
  nv3_escalera = -1;
  nv3_saltos = 0;

  nv3_invulnerable = 150;

  nv3_recarga = 0;
  nv3_recargaTotal = 600;
  nv3_brilloRecarga = 0;

  nv3_velocidadExtra = 0;
  nv3_escudo = 0;

  nv3_bufferSalto = 0;
  nv3_aturdimiento = 0;

  nv3_mirada = 1;

  nv3_agarre = 0;
  nv3_bloqueoAgarre = 0;
  nv3_objetivoAgarre = -1;

  for (int nv3_i = 0; nv3_i < TAM_NV3_BARRIL_ACTIVO; nv3_i++) {
    if (
      nv3_barrilActivo[nv3_i] &&
      abs(nv3_barrilX[nv3_i] - nv3_px) < 140 &&
      abs(nv3_barrilY[nv3_i] - (nv3_py - 11)) < 90
    ) {
      nv3_barrilActivo[nv3_i] = false;
    }
  }

  nv3_limpiarControles();
}

// ============================================================
// CONSULTAS DEL MAPA
// ============================================================

float nv3_inicioX(int nv3_p) {
  return nv3_plataformas[nv3_p][0];
}

float nv3_finX(int nv3_p) {
  return nv3_plataformas[nv3_p][1];
}

int nv3_filaPlataforma(int nv3_p) {
  return int(nv3_plataformas[nv3_p][4]);
}

float nv3_alturaPlataforma(int nv3_p, float nv3_x) {
  return lerp(
    nv3_plataformas[nv3_p][2],
    nv3_plataformas[nv3_p][3],
    (nv3_x - nv3_inicioX(nv3_p)) / (nv3_finX(nv3_p) - nv3_inicioX(nv3_p))
  );
}

float nv3_xEscalera(int nv3_e) {
  return nv3_escaleras[nv3_e][0];
}

int nv3_baseEscalera(int nv3_e) {
  return nv3_escaleras[nv3_e][1];
}

int nv3_cimaEscalera(int nv3_e) {
  return nv3_escaleras[nv3_e][2];
}

boolean nv3_escaleraRota(int nv3_e) {
  return nv3_escaleras[nv3_e][3] == 1;
}

float nv3_techoEscalera(int nv3_e) {
  return nv3_alturaPlataforma(nv3_cimaEscalera(nv3_e), nv3_xEscalera(nv3_e));
}

float nv3_pieEscalera(int nv3_e) {
  return nv3_alturaPlataforma(nv3_baseEscalera(nv3_e), nv3_xEscalera(nv3_e));
}

float nv3_finTramoAlto(int nv3_e) {
  return nv3_techoEscalera(nv3_e) + 28;
}

float nv3_inicioTramoBajo(int nv3_e) {
  return nv3_techoEscalera(nv3_e) + 72;
}

boolean nv3_dentroEscalera(int nv3_e, float nv3_y) {
  boolean dentro = true;

  if (
    nv3_y < nv3_techoEscalera(nv3_e) - 6 ||
    nv3_y > nv3_pieEscalera(nv3_e) + 5
  ) {
    dentro = false;
  }

  if (dentro && nv3_escaleraRota(nv3_e)) {
    dentro = nv3_y <= nv3_finTramoAlto(nv3_e) || nv3_y >= nv3_inicioTramoBajo(nv3_e);
  }

  return dentro;
}

float nv3_cinta(int nv3_p, float nv3_x) {
  float fuerza = 0;

  for (int nv3_i = 0; nv3_i < cant_nv3_cintas[nv3_fase - 1]; nv3_i++) {
    if (
      nv3_p == int(nv3_cintas[nv3_i][0]) &&
      nv3_x > nv3_cintas[nv3_i][1] &&
      nv3_x < nv3_cintas[nv3_i][2]
    ) {
      fuerza = nv3_cintas[nv3_i][3];
    }
  }

  return fuerza;
}

int nv3_aterrizaje(
  float nv3_x,
  float nv3_antesX,
  float nv3_antesY,
  float nv3_ahoraY,
  int nv3_omitir
) {
  float mejorY = 10000;
  int mejor = -1;

  for (int nv3_p = 0; nv3_p < cant_nv3_plataformas[nv3_fase - 1]; nv3_p++) {
    if (
      nv3_p != nv3_omitir &&
      nv3_x >= nv3_inicioX(nv3_p) &&
      nv3_x <= nv3_finX(nv3_p)
    ) {
      float nv3_y = nv3_alturaPlataforma(nv3_p, nv3_x);

      if (
        nv3_antesY <= nv3_alturaPlataforma(nv3_p, nv3_antesX) + 1 &&
        nv3_ahoraY >= nv3_y - 0.001 &&
        nv3_y < mejorY
      ) {
        mejorY = nv3_y;
        mejor = nv3_p;
      }
    }
  }

  return mejor;
}

int nv3_signo(float nv3_valor) {
  int resultado = 0;

  if (nv3_valor < 0) resultado = -1;
  if (nv3_valor > 0) resultado = 1;

  return resultado;
}

// ============================================================
// TIEMPO, PUNTOS Y ACTUALIZACION GENERAL
// ============================================================

void nv3_avanzarTiempo(float nv3_transcurrido) {
  if (nv3_pantalla != 2 || nv3_pausa) {
    nv3_acumulado = 0;
    nv3_saltoPulsado = false;
    nv3_especialPulsado = false;
  }

  if (nv3_pantalla == 2 && !nv3_pausa) {
    nv3_acumulado += nv3_transcurrido;

    while (
      nv3_acumulado >= nv3_PASO &&
      nv3_pantalla == 2 &&
      !nv3_pausa
    ) {
      nv3_acumulado -= nv3_PASO;

      nv3_actualizarJuego();

      nv3_saltoPulsado = false;
      nv3_especialPulsado = false;
    }
  }
}

void nv3_actualizarJuego() {
  nv3_reloj++;
  nv3_tiempoFase++;

  if (nv3_sacudida > 0) nv3_sacudida--;
  if (nv3_avisoFichas > 0) nv3_avisoFichas--;
  if (nv3_invulnerable > 0) nv3_invulnerable--;

  nv3_actualizarRecargas();

  if (nv3_bloqueoAgarre > 0) nv3_bloqueoAgarre--;

  nv3_tiempoRestante--;

  boolean abortarPaso = false;

  if (nv3_tiempoRestante <= 0) {
    nv3_recibirGolpe(true);
    nv3_tiempoRestante = nv3_LIMITE_TIEMPO;
    abortarPaso = true;
  }

  if (!abortarPaso) {
    nv3_actualizarJugador();

    if (nv3_py > 775) {
      nv3_recibirGolpe(true);
      abortarPaso = true;
    }
  }

  if (!abortarPaso) {
    nv3_actualizarBarriles();

    if (nv3_pantalla != 2) {
      abortarPaso = true;
    }
  }

  if (!abortarPaso) {
    nv3_actualizarFuegos();

    if (nv3_pantalla != 2) {
      abortarPaso = true;
    }
  }

  if (!abortarPaso) {
    for (int nv3_i = 0; nv3_i < TAM_NV3_FICHAS; nv3_i++) {
      int nv3_p = nv3_pisosFicha[nv3_i];

      float nv3_x = (nv3_inicioX(nv3_p) + nv3_finX(nv3_p)) / 2.0;
      float nv3_y = nv3_alturaPlataforma(nv3_p, nv3_x) - 28;

      if (
        !nv3_fichas[nv3_i] &&
        abs(nv3_px - nv3_x) < 23 &&
        abs(nv3_py - 18 - nv3_y) < 28
      ) {
        nv3_fichas[nv3_i] = true;
        if (nv3_contarFichas() >= 3 && nv3_tiempoFase <= 45 * 60) desbloquearLogro(12);
        nv3_sonar(nv3_sfxFicha);
        nv3_sumarPuntos(150);
      }
    }

    nv3_comprobarFichas();

    if (
      nv3_suelo == nv3_metas[nv3_fase - 1] &&
      abs(nv3_px - 105) < 27
    ) {
      nv3_sonar(nv3_sfxMeta);
      if (nv3_contarFichas() == TAM_NV3_FICHAS && !nv3PerdioVidaEnIntento) desbloquearLogro(13);
      if (nv3_fase == 1 && nv3_tiempoFase < 45 * 60) desbloquearLogro(14);
      if (nv3_fase == 2 && nv3_vidas >= 3) desbloquearLogro(15);
      if (nv3_fase == 3 && nv3_contarFichas() == TAM_NV3_FICHAS) desbloquearLogro(16);
      if (nv3_fase == 3 && !nv3PerdioVidaEnIntento) desbloquearLogro(17);
      if (nv3_intentosFase > 0 && !nv3PerdioVidaEnIntento) desbloquearLogro(18);
      nv3_sumarPuntos(1000 + nv3_tiempoRestante / 6);
      nv3_limpiarControles();

      nv3_pantalla = 3;
      reaccionClipAlResultado(true);

      if (nv3_fase == TAM_NV3_MAPAS) {
        nv3_pantalla = 5;
        nv3_dialogo = 0;
      }
    }
  }
}

void nv3_sumarPuntos(int nv3_cantidad) {
  nv3_puntos += nv3_cantidad;
  nv3_recordPuntos = max(nv3_recordPuntos, nv3_puntos);
}

int nv3_contarFichas() {
  int total = 0;

  for (int nv3_i = 0; nv3_i < TAM_NV3_FICHAS; nv3_i++) {
    if (nv3_fichas[nv3_i]) total++;
  }

  return total;
}

void nv3_comprobarFichas() {
  if (!nv3_bonoFichas && nv3_contarFichas() == TAM_NV3_FICHAS) {
    nv3_bonoFichas = true;

    nv3_vidas++;

    nv3_sonar(nv3_sfxVidaExtra);
    nv3_sumarPuntos(600);

    nv3_avisoFichas = 150;
  }
}

// ============================================================
// RECARGAS
// ============================================================

void nv3_iniciarRecarga(int nv3_cuadros) {
  nv3_recarga = nv3_cuadros;
  nv3_recargaTotal = nv3_cuadros;
  nv3_brilloRecarga = 0;
}

void nv3_actualizarRecargas() {
  if (nv3_brilloRecarga > 0) nv3_brilloRecarga--;

  if (nv3_recarga > 0) {
    nv3_recarga--;

    if (nv3_recarga == 0) {
      nv3_brilloRecarga = 45;
    }
  }

  if (nv3_velocidadExtra > 0) {
    nv3_velocidadExtra--;

    if (nv3_velocidadExtra == 0) {
      nv3_iniciarRecarga(600);
    }
  }

  if (nv3_escudo > 0) {
    nv3_escudo--;

    if (nv3_escudo == 0) {
      nv3_iniciarRecarga(600);
    }
  }
}

// ============================================================
// MOVIMIENTO DEL JUGADOR
// ============================================================

void nv3_actualizarJugador() {
  nv3_anteriorX = nv3_px;
  nv3_anteriorY = nv3_py;

  if (nv3_bufferSalto > 0) nv3_bufferSalto--;

  boolean aturdido = nv3_aturdimiento > 0;

  if (aturdido) {
    nv3_aturdimiento--;
    nv3_bufferSalto = 0;
    nv3_vx = 0;
  }

  if (nv3_saltoPulsado && !aturdido && nv3_escalera < 0) {
    nv3_bufferSalto = 7;
  }

  if (
    nv3_especialPulsado &&
    !aturdido &&
    nv3_recarga == 0 &&
    nv3_agarre == 0 &&
    nv3_velocidadExtra == 0 &&
    nv3_escudo == 0
  ) {
    if (nv3_personaje == 1) {
      nv3_velocidadExtra = 120;
      nv3_recarga = 0;
      nv3_sonar(nv3_sfxVelocidad);
    }

    if (nv3_personaje == 3) {
      nv3_escudo = 150;
      nv3_recarga = 0;
      nv3_sonar(nv3_sfxEscudo);
    }
  }

  boolean jugadorListo = false;

  if (nv3_agarre > 0) {
    nv3_bufferSalto = 0;

    nv3_actualizarAgarre();
    jugadorListo = true;
  }

  if (!jugadorListo) {
    float velocidad = nv3_rapidez;

    if (nv3_velocidadExtra > 0) {
      velocidad = 3.8;
    }

    int nv3_horizontal = nv3_ejeX();
    int nv3_vertical = nv3_ejeY();

    if (aturdido) {
      nv3_horizontal = 0;
      nv3_vertical = 0;
    }

    if (nv3_suelo >= 0 && !aturdido) {
      nv3_vx = nv3_horizontal * velocidad;
    }

    if (nv3_suelo < 0 && nv3_escalera < 0 && !aturdido) {
      float ajuste = nv3_horizontal * velocidad - nv3_vx;
      nv3_vx += constrain(ajuste, -nv3_CONTROL_AIRE, nv3_CONTROL_AIRE);
    }

    if (nv3_horizontal != 0) nv3_mirada = nv3_horizontal;

    if (nv3_escalera < 0 && nv3_vertical != 0) {
      int nv3_e = 0;

      while (nv3_e < cant_nv3_escaleras[nv3_fase - 1] && nv3_escalera < 0) {
        if (
          abs(nv3_px - nv3_xEscalera(nv3_e)) <= 17 &&
          nv3_dentroEscalera(nv3_e, nv3_py)
        ) {
          if (
            (nv3_vertical < 0 && nv3_py > nv3_techoEscalera(nv3_e) + 2) ||
            (nv3_vertical > 0 && nv3_py < nv3_pieEscalera(nv3_e) - 2)
          ) {
            nv3_escalera = nv3_e;
            nv3_suelo = -1;

            nv3_vy = 0;
            nv3_vx = 0;

            nv3_saltos = 0;
            nv3_bufferSalto = 0;
          }
        }

        nv3_e++;
      }
    }

    if (nv3_escalera >= 0) {
      nv3_moverEnEscalera(nv3_horizontal, nv3_vertical);
      jugadorListo = true;
    }

    if (!jugadorListo) {
      boolean saltoNormal =
        !aturdido &&
        nv3_suelo >= 0 &&
        nv3_bufferSalto > 0;

      if (saltoNormal) {
        nv3_saltarDesdeSuelo();
      }

      // Sam: solo el segundo salto necesita recarga.
      if (
        !saltoNormal &&
        !aturdido &&
        nv3_saltoPulsado &&
        nv3_personaje == 0 &&
        nv3_suelo < 0 &&
        nv3_saltos < 2 &&
        nv3_vy < 6.0 &&
        nv3_recarga == 0
      ) {
        nv3_vy = -4.8;
        nv3_saltos = 2;
        nv3_bufferSalto = 0;

        nv3_iniciarRecarga(180);
        nv3_sonar(nv3_sfxDobleSalto);
      }

      float empuje = 0;

      if (nv3_suelo >= 0 && !aturdido) {
        empuje = constrain(nv3_cinta(nv3_suelo, nv3_px), -2, 2);
      }

      nv3_px = constrain(nv3_px + nv3_vx + empuje, 32, 928);

      if (nv3_suelo >= 0) {
        if (nv3_px >= nv3_inicioX(nv3_suelo) && nv3_px <= nv3_finX(nv3_suelo)) {
          nv3_py = nv3_alturaPlataforma(nv3_suelo, nv3_px);
          nv3_vy = 0;
          nv3_saltos = 0;
          jugadorListo = true;
        }

        if (!jugadorListo) {
          nv3_vx += empuje;

          nv3_suelo = -1;
          nv3_saltos = 1;
        }
      }

      if (!jugadorListo) {
        float velocidadAnterior = nv3_vy;

        nv3_vy = min(nv3_vy + nv3_gravedad, 12);
        nv3_py += (velocidadAnterior + nv3_vy) / 2.0;

        int nv3_p = -1;

        if (nv3_vy >= 0) {
          nv3_p = nv3_aterrizaje(
            nv3_px, nv3_anteriorX, nv3_anteriorY, nv3_py, -1
          );
        }

        if (nv3_p >= 0) {
          float impacto = nv3_vy;

          nv3_py = nv3_alturaPlataforma(nv3_p, nv3_px);
          nv3_vy = 0;

          nv3_suelo = nv3_p;
          nv3_saltos = 0;

          if (impacto > 9.5) {
            nv3_aturdimiento = 14;
            nv3_vx = 0;
            nv3_bufferSalto = 0;

            nv3_sonar(nv3_sfxAturdido);

            jugadorListo = true;
          }

          if (!jugadorListo && !aturdido && nv3_bufferSalto > 0) {
            nv3_saltarDesdeSuelo();
          }

          jugadorListo = true;
        }

        if (
          !jugadorListo &&
          !aturdido &&
          nv3_personaje == 2 &&
          nv3_vy > 0 &&
          nv3_bloqueoAgarre == 0
        ) {
          nv3_buscarAgarre();
        }
      }
    }
  }
}

void nv3_saltarDesdeSuelo() {
  nv3_vy = -nv3_impulso;

  nv3_suelo = -1;
  nv3_saltos = 1;
  nv3_bufferSalto = 0;

  nv3_sonar(nv3_sfxSalto);
}

void nv3_moverEnEscalera(int nv3_horizontal, int nv3_vertical) {
  int nv3_e = nv3_escalera;

  nv3_px = nv3_xEscalera(nv3_e);
  nv3_vx = 0;
  nv3_vy = 0;

  nv3_bufferSalto = 0;

  boolean salioDeEscalera = false;

  if (nv3_horizontal != 0 && nv3_vertical == 0) {
    float candidato = nv3_px + nv3_horizontal * nv3_rapidez;
    int nv3_p = 0;

    while (nv3_p < cant_nv3_plataformas[nv3_fase - 1] && !salioDeEscalera) {
      if (
        candidato >= nv3_inicioX(nv3_p) &&
        candidato <= nv3_finX(nv3_p) &&
        abs(nv3_py - nv3_alturaPlataforma(nv3_p, candidato)) <= 4
      ) {
        nv3_px = candidato;
        nv3_py = nv3_alturaPlataforma(nv3_p, nv3_px);

        nv3_suelo = nv3_p;
        nv3_escalera = -1;
        nv3_saltos = 0;

        salioDeEscalera = true;
      }

      nv3_p++;
    }
  }

  if (!salioDeEscalera) {
    float nuevaY = nv3_py + nv3_vertical * 2.6;

    if (nv3_escaleraRota(nv3_e)) {
      if (
        nv3_py >= nv3_inicioTramoBajo(nv3_e) &&
        nuevaY < nv3_inicioTramoBajo(nv3_e)
      ) {
        nuevaY = nv3_inicioTramoBajo(nv3_e);
      }

      if (
        nv3_py <= nv3_finTramoAlto(nv3_e) &&
        nuevaY > nv3_finTramoAlto(nv3_e)
      ) {
        nuevaY = nv3_finTramoAlto(nv3_e);
      }
    }

    nv3_py = nuevaY;

    if (nv3_py <= nv3_techoEscalera(nv3_e)) {
      nv3_py = nv3_techoEscalera(nv3_e);

      nv3_suelo = nv3_cimaEscalera(nv3_e);
      nv3_escalera = -1;
      nv3_saltos = 0;

      salioDeEscalera = true;
    }

    if (!salioDeEscalera && nv3_py >= nv3_pieEscalera(nv3_e)) {
      nv3_py = nv3_pieEscalera(nv3_e);

      nv3_suelo = nv3_baseEscalera(nv3_e);
      nv3_escalera = -1;
      nv3_saltos = 0;
    }
  }
}

// ============================================================
// AGARRE DE CRISTIAN
// ============================================================

void nv3_actualizarAgarre() {
  nv3_agarre--;

  nv3_px = nv3_agarreX;
  nv3_py = nv3_agarreY + 30;

  nv3_vx = 0;
  nv3_vy = 0;

  boolean resuelto = false;

  if (nv3_saltoPulsado) {
    nv3_agarre = 0;
    nv3_bloqueoAgarre = 30;
    nv3_saltos = 0;

    nv3_sonar(nv3_sfxSalto);

    if (nv3_tipoAgarre == 0) {
      int nv3_p = nv3_objetivoAgarre;

      nv3_px = constrain(
        nv3_agarreX,
        nv3_inicioX(nv3_p) + 13,
        nv3_finX(nv3_p) - 13
      );

      nv3_py = nv3_alturaPlataforma(nv3_p, nv3_px);
      nv3_suelo = nv3_p;

      resuelto = true;
    }

    if (!resuelto) {
      nv3_escalera = nv3_objetivoAgarre;
      nv3_py = nv3_agarreY - 2;
      nv3_suelo = -1;

      resuelto = true;
    }
  }

  if (!resuelto && (nv3_ejeY() > 0 || nv3_agarre == 0)) {
    nv3_agarre = 0;
    nv3_bloqueoAgarre = 55;

    nv3_escalera = -1;
    nv3_suelo = -1;

    nv3_vy = 1;
    nv3_saltos = 1;
  }
}

void nv3_buscarAgarre() {
  float manos = nv3_py - 30;

  boolean encontrado = false;
  int nv3_p = 0;

  while (nv3_p < cant_nv3_plataformas[nv3_fase - 1] && !encontrado) {
    int lado = 0;

    while (lado < 2 && !encontrado) {
      float nv3_x = nv3_plataformas[nv3_p][lado];
      float nv3_y = nv3_alturaPlataforma(nv3_p, nv3_x);

      boolean fuera = nv3_px < nv3_inicioX(nv3_p) || nv3_px > nv3_finX(nv3_p);

      if (
        fuera &&
        abs(nv3_px - nv3_x) <= 20 &&
        abs(manos - nv3_y) <= 12 &&
        nv3_anteriorY - 30 <= nv3_y + 12
      ) {
        nv3_iniciarAgarre(nv3_x, nv3_y, 0, nv3_p);
        encontrado = true;
      }

      lado++;
    }

    nv3_p++;
  }

  int nv3_e = 0;

  while (nv3_e < cant_nv3_escaleras[nv3_fase - 1] && !encontrado) {
    float nv3_y = nv3_finTramoAlto(nv3_e);

    if (
      nv3_escaleraRota(nv3_e) &&
      abs(nv3_px - nv3_xEscalera(nv3_e)) <= 17 &&
      abs(manos - nv3_y) <= 12 &&
      nv3_anteriorY - 30 <= nv3_y + 12
    ) {
      nv3_iniciarAgarre(nv3_xEscalera(nv3_e), nv3_y, 1, nv3_e);
      encontrado = true;
    }

    nv3_e++;
  }
}

void nv3_iniciarAgarre(float nv3_x, float nv3_y, int nv3_tipo, int nv3_objetivo) {
  nv3_agarre = 120;
  nv3_bufferSalto = 0;

  nv3_agarreX = nv3_x;
  nv3_agarreY = nv3_y;

  nv3_tipoAgarre = nv3_tipo;
  nv3_objetivoAgarre = nv3_objetivo;

  nv3_suelo = -1;
  nv3_escalera = -1;

  nv3_vx = 0;
  nv3_vy = 0;

  nv3_px = nv3_x;
  nv3_py = nv3_y + 30;

  nv3_sonar(nv3_sfxAgarre);
}

// ============================================================
// GOLPES Y VIDAS
// ============================================================

void nv3_recibirGolpe(boolean nv3_caida) {
  nv3_recibirGolpe(nv3_caida, nv3_px - nv3_mirada);
}

void nv3_recibirGolpe(boolean nv3_caida, float nv3_origenX) {
  boolean ignorar = false;

  if (nv3_vidas <= 0) ignorar = true;
  if (!nv3_caida && nv3_invulnerable > 0) ignorar = true;

  if (!ignorar) {
    nv3_sacudida = 6;

    boolean absorbidoPorEscudo = false;

    if (!nv3_caida && nv3_escudo > 0) {
      nv3_escudo = 0;
      nv3_iniciarRecarga(600);

      nv3_invulnerable = 20;
      nv3_sonar(nv3_sfxEscudo);

      int direccion = nv3_signo(nv3_px - nv3_origenX);

      if (direccion == 0) {
        direccion = -nv3_mirada;
      }

      nv3_px = constrain(nv3_px + direccion * 35, 32, 928);

      nv3_vx = 0;

      if (nv3_escalera >= 0) {
        nv3_escalera = -1;
        nv3_suelo = -1;
        nv3_vy = 0;
        nv3_saltos = 1;
      }

      if (nv3_suelo >= 0) {
        if (nv3_px < nv3_inicioX(nv3_suelo) || nv3_px > nv3_finX(nv3_suelo)) {
          nv3_suelo = -1;
          nv3_vy = 0;
          nv3_saltos = 1;
        }

        if (nv3_suelo >= 0) {
          nv3_py = nv3_alturaPlataforma(nv3_suelo, nv3_px);
        }
      }

      absorbidoPorEscudo = true;
    }

    if (!absorbidoPorEscudo) {
      nv3_vidas--;
      nv3PerdioVidaEnIntento = true;

      if (nv3_vidas == 0) {
        nv3_sonar(nv3_sfxGameover);
        nv3_intentosFase++;
        if (nv3_intentosFase < 2) {
          nv3_pantalla = 4;
          reaccionClipAlResultado(false);
        }
        if (nv3_intentosFase >= 2) iniciarFinalNivel3(false);
        nv3_limpiarControles();
      }

      if (nv3_vidas > 0) {
        nv3_sonar(nv3_sfxGolpe);
        nv3_reaparecer();
      }
    }
  }
}

// ============================================================
// BARRILES
// ============================================================

int nv3_intervaloBarriles() {
  return 158 - nv3_fase * 15;
}

void nv3_actualizarBarriles() {
  nv3_esperaBarril--;

  if (nv3_esperaBarril <= 0) {
    int b = 0;
    boolean creado = false;

    while (b < TAM_NV3_BARRIL_ACTIVO && !creado) {
      if (!nv3_barrilActivo[b]) {
        nv3_crearBarril(b);
        creado = true;
      }
      b++;
    }

    nv3_esperaBarril = nv3_intervaloBarriles();
  }

  int nv3_i = 0;

  while (nv3_i < TAM_NV3_BARRIL_ACTIVO && nv3_pantalla == 2) {
    if (nv3_barrilActivo[nv3_i]) {
      nv3_moverBarril(nv3_i);

      if (nv3_barrilActivo[nv3_i]) {
        float nv3_y = nv3_yVisibleBarril(nv3_i);

        if (
          abs(nv3_px - nv3_barrilX[nv3_i]) < 17 &&
          abs((nv3_py - 16) - nv3_y) < 18 &&
          nv3_invulnerable == 0
        ) {
          nv3_recibirGolpe(false, nv3_barrilX[nv3_i]);
          nv3_barrilActivo[nv3_i] = false;
        }

        if (nv3_pantalla == 2 && nv3_barrilActivo[nv3_i]) {
          int lado = nv3_signo(nv3_px - nv3_barrilX[nv3_i]);

          boolean cruzo =
            lado != 0 &&
            nv3_ladoBarril[nv3_i] != 0 &&
            lado != nv3_ladoBarril[nv3_i];

          if (
            !nv3_barrilPuntuado[nv3_i] &&
            cruzo &&
            abs(nv3_px - nv3_barrilX[nv3_i]) < 20 &&
            nv3_suelo < 0 &&
            nv3_escalera < 0 &&
            nv3_agarre == 0 &&
            nv3_py <= nv3_y - 2 &&
            nv3_py >= nv3_y - 60
          ) {
            nv3_sonar(nv3_sfxFicha);
            nv3_sumarPuntos(100);
            nv3_barrilPuntuado[nv3_i] = true;
          }

          if (lado != 0) {
            nv3_ladoBarril[nv3_i] = lado;
          }
        }
      }
    }

    nv3_i++;
  }
}

void nv3_crearBarril(int nv3_i) {
  int nv3_p = cant_nv3_plataformas[nv3_fase - 1] - 1;

  nv3_numeroBarriles++;

  nv3_barrilActivo[nv3_i] = true;
  nv3_barrilPuntuado[nv3_i] = false;
  nv3_barrilBota[nv3_i] = nv3_numeroBarriles % 3 == 0;

  nv3_pisoBarril[nv3_i] = nv3_p;
  nv3_omitirBarril[nv3_i] = -1;
  nv3_escaleraBarril[nv3_i] = -1;

  nv3_barrilX[nv3_i] = nv3_xGenerador();
  nv3_barrilY[nv3_i] = nv3_alturaPlataforma(nv3_p, nv3_barrilX[nv3_i]) - 11;

  nv3_barrilVX[nv3_i] = 2.1 + nv3_fase * 0.2;
  nv3_barrilVY[nv3_i] = 0;

  if (nv3_fase == 3) {
    int nv3_turno = (nv3_numeroBarriles - 1) % TAM_NV3_GENERADORES_PARKOUR;

    nv3_p = nv3_generadoresParkour[nv3_turno][0];

    int direccion = nv3_generadoresParkour[nv3_turno][2];

    if (direccion == 0) {
      direccion = 1;

      if (nv3_contadorSalidas[nv3_turno] % 2 == 1) {
        direccion = -1;
      }
    }

    nv3_contadorSalidas[nv3_turno]++;

    nv3_pisoBarril[nv3_i] = nv3_p;
    nv3_barrilX[nv3_i] = nv3_xOrigenParkour(nv3_turno);
    nv3_barrilY[nv3_i] = nv3_alturaPlataforma(nv3_p, nv3_barrilX[nv3_i]) - 11;

    nv3_barrilVX[nv3_i] = abs(nv3_barrilVX[nv3_i]) * direccion;
  }

  nv3_ladoBarril[nv3_i] = nv3_signo(nv3_px - nv3_barrilX[nv3_i]);
}

float nv3_yVisibleBarril(int nv3_i) {
  float bote = 0;

  if (nv3_barrilBota[nv3_i] && nv3_pisoBarril[nv3_i] >= 0) {
    bote = abs(sin(nv3_reloj * 0.2)) * 8;
  }

  return nv3_barrilY[nv3_i] - bote;
}

void nv3_moverBarril(int nv3_i) {
  boolean movido = false;

  if (nv3_escaleraBarril[nv3_i] >= 0) {
    int nv3_e = nv3_escaleraBarril[nv3_i];
    int base = nv3_baseEscalera(nv3_e);

    nv3_barrilX[nv3_i] = nv3_xEscalera(nv3_e);

    nv3_barrilY[nv3_i] = min(
      nv3_barrilY[nv3_i] + 2.6,
      nv3_pieEscalera(nv3_e) - 11
    );

    nv3_barrilVY[nv3_i] = 0;

    if (nv3_barrilY[nv3_i] >= nv3_pieEscalera(nv3_e) - 11) {
      nv3_pisoBarril[nv3_i] = base;
      nv3_omitirBarril[nv3_i] = -1;
      nv3_escaleraBarril[nv3_i] = -1;

      nv3_barrilVX[nv3_i] *= -1;

      float pendiente =
        nv3_plataformas[base][3] - nv3_plataformas[base][2];

      if (pendiente != 0) {
        nv3_barrilVX[nv3_i] = abs(nv3_barrilVX[nv3_i]) * nv3_signo(pendiente);
      }
    }

    movido = true;
  }

  if (!movido) {
    float nv3_antesY = nv3_barrilY[nv3_i] + 11;
    float nv3_antesX = nv3_barrilX[nv3_i];

    int nv3_p = nv3_pisoBarril[nv3_i];

    if (nv3_p >= 0) {
      float empuje = nv3_cinta(nv3_p, nv3_barrilX[nv3_i]) * 0.3;

      if (nv3_signo(empuje) != nv3_signo(nv3_barrilVX[nv3_i])) {
        empuje = 0;
      }

      nv3_barrilX[nv3_i] += nv3_barrilVX[nv3_i] + empuje;
      nv3_barrilY[nv3_i] = nv3_alturaPlataforma(nv3_p, nv3_barrilX[nv3_i]) - 11;

      int nv3_e = 0;

      while (nv3_e < cant_nv3_escaleras[nv3_fase - 1] && !movido) {
        if (
          nv3_cimaEscalera(nv3_e) == nv3_p &&
          abs(nv3_barrilX[nv3_i] - nv3_xEscalera(nv3_e)) < 8 &&
          abs(nv3_antesX - nv3_xEscalera(nv3_e)) >= 8 &&
          random(1) < 0.30
        ) {
          nv3_escaleraBarril[nv3_i] = nv3_e;
          nv3_pisoBarril[nv3_i] = -1;
          nv3_omitirBarril[nv3_i] = nv3_p;

          nv3_barrilX[nv3_i] = nv3_xEscalera(nv3_e);
          nv3_barrilY[nv3_i] = nv3_techoEscalera(nv3_e) - 8;
          nv3_barrilVY[nv3_i] = 0;

          movido = true;
        }

        nv3_e++;
      }

      if (!movido) {
        if (
          nv3_barrilX[nv3_i] < nv3_inicioX(nv3_p) ||
          nv3_barrilX[nv3_i] > nv3_finX(nv3_p)
        ) {
          nv3_barrilX[nv3_i] = constrain(
            nv3_barrilX[nv3_i],
            nv3_inicioX(nv3_p),
            nv3_finX(nv3_p)
          );

          nv3_barrilY[nv3_i] =
            nv3_alturaPlataforma(nv3_p, nv3_barrilX[nv3_i]) - 11;

          nv3_omitirBarril[nv3_i] = nv3_p;
          nv3_pisoBarril[nv3_i] = -1;
          nv3_barrilVY[nv3_i] = 0;
        }

        movido = true;
      }
    }

    if (!movido) {
      // Caida vertical: no se cambia la X.
      nv3_barrilVY[nv3_i] = min(nv3_barrilVY[nv3_i] + nv3_gravedad, 10);
      nv3_barrilY[nv3_i] += nv3_barrilVY[nv3_i];

      int nuevo = nv3_aterrizaje(
        nv3_barrilX[nv3_i],
        nv3_barrilX[nv3_i],
        nv3_antesY,
        nv3_barrilY[nv3_i] + 11,
        nv3_omitirBarril[nv3_i]
      );

      if (nuevo >= 0) {
        nv3_pisoBarril[nv3_i] = nuevo;
        nv3_omitirBarril[nv3_i] = -1;
        nv3_escaleraBarril[nv3_i] = -1;

        nv3_barrilVY[nv3_i] = 0;
        nv3_barrilY[nv3_i] = nv3_alturaPlataforma(nuevo, nv3_barrilX[nv3_i]) - 11;

        nv3_barrilVX[nv3_i] *= -1;

        float pendiente =
          nv3_plataformas[nuevo][3] - nv3_plataformas[nuevo][2];

        if (pendiente != 0) {
          nv3_barrilVX[nv3_i] = abs(nv3_barrilVX[nv3_i]) * nv3_signo(pendiente);
        }
      }

      if (nv3_barrilY[nv3_i] > 780) {
        nv3_barrilActivo[nv3_i] = false;
      }
    }
  }
}

float nv3_xGenerador() {
  return max(190, nv3_inicioX(cant_nv3_plataformas[nv3_fase - 1] - 1) + 40);
}

float nv3_xOrigenParkour(int nv3_turno) {
  return nv3_generadoresParkour[nv3_turno][1];
}

// ============================================================
// FUEGOS
// ============================================================

void nv3_actualizarFuegos() {
  int nv3_i = 0;

  while (nv3_i < cant_nv3_pisosFuego[nv3_fase - 1] && nv3_pantalla == 2) {
    int nv3_p = nv3_pisosFuego[nv3_i];

    float velocidad = 1.6 + nv3_fase * 0.35;

    nv3_fuegoPersigue[nv3_i] = nv3_fase >= 2 && nv3_suelo == nv3_p;

    if (nv3_fuegoPersigue[nv3_i]) {
      if (abs(nv3_px - nv3_fuegoX[nv3_i]) > 10) {
        nv3_fuegoDir[nv3_i] = nv3_signo(nv3_px - nv3_fuegoX[nv3_i]);
      }

      velocidad *= 1.16;
    }

    nv3_fuegoX[nv3_i] += nv3_fuegoDir[nv3_i] * velocidad;

    if (nv3_fuegoX[nv3_i] < nv3_inicioX(nv3_p) + 25) {
      nv3_fuegoX[nv3_i] = nv3_inicioX(nv3_p) + 25;
      nv3_fuegoDir[nv3_i] = 1;
    }

    if (nv3_fuegoX[nv3_i] > nv3_finX(nv3_p) - 25) {
      nv3_fuegoX[nv3_i] = nv3_finX(nv3_p) - 25;
      nv3_fuegoDir[nv3_i] = -1;
    }

    float nv3_y = nv3_alturaPlataforma(nv3_p, nv3_fuegoX[nv3_i]);

    if (
      abs(nv3_px - nv3_fuegoX[nv3_i]) < 18 &&
      abs(nv3_py - 16 - (nv3_y - 13)) < 22
    ) {
      nv3_recibirGolpe(false, nv3_fuegoX[nv3_i]);
    }

    nv3_i++;
  }
}

// ============================================================
// UTILIDADES DE DIBUJO
// ============================================================

int nv3_colorPersonaje(int nv3_id) {
  return color(nv3_colores[nv3_id][0], nv3_colores[nv3_id][1], nv3_colores[nv3_id][2]);
}

String nv3_nombrePersonaje(int nv3_id) {
  return nv3_nombres[nv3_id];
}

String nv3_nombreFase() {
  return nv3_nombresFase[nv3_fase - 1];
}

void nv3_rotulo(String nv3_mensaje, float nv3_x, float nv3_y, int nv3_tam, int nv3_tinta) {
  fill(nv3_tinta);
  textSize(nv3_tam);
  textAlign(LEFT, BASELINE);
  text(nv3_mensaje, nv3_x, nv3_y);
}

void nv3_centrado(String nv3_mensaje, float nv3_y, int nv3_tam, int nv3_tinta) {
  fill(nv3_tinta);
  textSize(nv3_tam);
  textAlign(CENTER, BASELINE);
  text(nv3_mensaje, nv3Ancho / 2.0, nv3_y);
  textAlign(LEFT, BASELINE);
}

void nv3_panel(float nv3_x, float nv3_y, float nv3_w, float nv3_h, int nv3_borde) {
  noStroke();
  fill(20, 25, 47);
  rect(nv3_x, nv3_y, nv3_w, nv3_h);

  stroke(nv3_borde);
  strokeWeight(2);
  noFill();
  rect(nv3_x, nv3_y, nv3_w, nv3_h);

  noStroke();
}

void nv3_fondoDecorativo() {
  noStroke();

  final int fondoX = 30, fondoY = 117, fondoW = 900, fondoH = 620;
  fill(28, 33, 56);
  for (int nv3_x = 24; nv3_x < nv3Ancho; nv3_x += 32) {
    boolean columnaInterior = nv3_x > fondoX && nv3_x + 2 < fondoX + fondoW;
    for (int nv3_y = 20; nv3_y < 745; nv3_y += 32) {
      if (!columnaInterior || nv3_y <= fondoY || nv3_y + 2 >= fondoY + fondoH) {
        rect(nv3_x, nv3_y, 2, 2);
      }
    }
  }

  fill(18, 21, 40);
  rect(fondoX, fondoY, fondoW, fondoH);

  if (nv3_fase == 2) {
    stroke(37, 53, 78);
    strokeWeight(12);

    line(76, 136, 76, 722);
    line(880, 136, 880, 722);
    line(76, 715, 880, 715);

    noStroke();

    for (int nv3_i = 0; nv3_i < 5; nv3_i++) {
      float nv3_x = 190 + nv3_i * 145;

      fill(31, 39, 65);
      ellipse(nv3_x, 325, 64, 64);

      fill(13, 15, 32);
      ellipse(nv3_x, 325, 32, 32);

      for (int j = 0; j < 8; j++) {
        float a = j * TWO_PI / 8.0 + nv3_reloj * 0.008;

        fill(31, 39, 65);
        rect(
          nv3_x + cos(a) * 34 - 6,
          325 + sin(a) * 34 - 6,
          12, 12
        );
      }
    }
  }
}

// ============================================================
// DIBUJO DE LA PARTIDA
// ============================================================

void nv3_dibujarJuego() {
  pushMatrix();

  if (nv3_sacudida > 0 && !nv3_pausa) {
    translate(random(-4, 4), random(-4, 4));
  }

  nv3_fondoDecorativo();

  for (int nv3_e = 0; nv3_e < cant_nv3_escaleras[nv3_fase - 1]; nv3_e++) {
    nv3_dibujarEscalera(nv3_e);
  }

  for (int nv3_p = 0; nv3_p < cant_nv3_plataformas[nv3_fase - 1]; nv3_p++) {
    nv3_dibujarPlataforma(nv3_p);
  }

  for (int nv3_i = 0; nv3_i < TAM_NV3_FICHAS; nv3_i++) {
    if (!nv3_fichas[nv3_i]) {
      int nv3_p = nv3_pisosFicha[nv3_i];

      float nv3_x = (nv3_inicioX(nv3_p) + nv3_finX(nv3_p)) / 2.0;
      float nv3_y = nv3_alturaPlataforma(nv3_p, nv3_x) - 27;

      fill(255, 210, 88);
      rect(nv3_x - 7, nv3_y - 9, 14, 18);

      fill(255, 242, 177);
      rect(nv3_x - 3, nv3_y - 5, 3, 10);
    }
  }

  nv3_dibujarGeneradoresParkour();
  nv3_dibujarMeta();

  for (int nv3_i = 0; nv3_i < TAM_NV3_BARRIL_ACTIVO; nv3_i++) {
    if (nv3_barrilActivo[nv3_i]) {
      nv3_dibujarBarril(nv3_barrilX[nv3_i], nv3_yVisibleBarril(nv3_i));
    }
  }

  for (int nv3_i = 0; nv3_i < cant_nv3_pisosFuego[nv3_fase - 1]; nv3_i++) {
    nv3_dibujarFuego(
      nv3_fuegoX[nv3_i],
      nv3_alturaPlataforma(nv3_pisosFuego[nv3_i], nv3_fuegoX[nv3_i]),
      nv3_fuegoPersigue[nv3_i]
    );
  }

  if (nv3_velocidadExtra > 0) {
    fill(255, 181, 77, 80);

    rect(nv3_px - nv3_mirada * 29 - 10, nv3_py - 21, 18, 12);
    rect(nv3_px - nv3_mirada * 47 - 6, nv3_py - 16, 12, 5);
  }

  if (nv3_invulnerable == 0 || nv3_reloj % 12 < 7) {
    nv3_dibujarPersonaje(
      nv3_px, nv3_py, nv3_personaje, 1,
      nv3_vx != 0 && nv3_suelo >= 0, nv3_mirada
    );
  }

  if (nv3_escudo > 0) {
    noFill();
    stroke(105, 238, 178);
    strokeWeight(3);

    ellipse(nv3_px, nv3_py - 18, 51, 58);

    noStroke();
  }

  if (nv3_agarre > 0) {
    nv3_rotulo(
      "AGARRE " + nf(nv3_agarre / 60.0, 1, 1) + "s",
      nv3_px - 55, nv3_py - 53, 12, color(216, 199, 255)
    );
  }

  if (nv3_aturdimiento > 0) {
    nv3_rotulo("!", nv3_px - 5, nv3_py - 48, 18, color(255, 212, 100));
  }

  nv3_dibujarIndicadorRecarga();

  popMatrix();

  nv3_dibujarHUD();
}

void nv3_dibujarPlataforma(int nv3_p) {
  float x1 = nv3_inicioX(nv3_p);
  float x2 = nv3_finX(nv3_p);
  float y1 = nv3_plataformas[nv3_p][2];
  float y2 = nv3_plataformas[nv3_p][3];

  int base = color(236, 89, 132);
  int luz = color(255, 163, 190);

  if (nv3_fase == 2) {
    base = color(153, 94, 212);
    luz = color(226, 160, 255);
  }

  if (nv3_fase == 3) {
    base = color(81, 125, 226);
    luz = color(139, 189, 255);
  }

  noStroke();
  fill(base);

  quad(x1, y1, x2, y2, x2, y2 + 13, x1, y1 + 13);

  stroke(luz);
  strokeWeight(3);
  line(x1, y1, x2, y2);

  noStroke();

  for (float nv3_x = x1 + 13; nv3_x < x2 - 4; nv3_x += 30) {
    fill(26, 28, 49);
    rect(nv3_x, nv3_alturaPlataforma(nv3_p, nv3_x) + 6, 4, 4);
  }

  for (int nv3_i = 0; nv3_i < cant_nv3_cintas[nv3_fase - 1]; nv3_i++) {
    if (int(nv3_cintas[nv3_i][0]) == nv3_p) {
      float inicio = nv3_cintas[nv3_i][1];
      float fin = nv3_cintas[nv3_i][2];
      float nv3_y = nv3_alturaPlataforma(nv3_p, inicio);

      int nv3_dir = nv3_signo(nv3_cintas[nv3_i][3]);

      fill(39, 128, 203);
      rect(inicio, nv3_y - 1, fin - inicio, 12);

      for (float nv3_x = inicio + 15; nv3_x < fin - 12; nv3_x += 32) {
        float a = nv3_x + nv3_dir * (nv3_reloj % 24) / 3.0;

        fill(255, 216, 94);

        triangle(
          a - nv3_dir * 5, nv3_y + 2,
          a + nv3_dir * 3, nv3_y + 6,
          a - nv3_dir * 5, nv3_y + 10
        );
      }
    }
  }
}

void nv3_dibujarEscalera(int nv3_id) {
  float nv3_x = nv3_xEscalera(nv3_id);
  float cima = nv3_techoEscalera(nv3_id);
  float base = nv3_pieEscalera(nv3_id);

  for (float nv3_y = cima; nv3_y < base; nv3_y += 3) {
    if (
      !nv3_escaleraRota(nv3_id) ||
      nv3_y <= nv3_finTramoAlto(nv3_id) ||
      nv3_y >= nv3_inicioTramoBajo(nv3_id)
    ) {
      fill(64, 191, 196);
      rect(nv3_x - 12, nv3_y, 4, 3);
      rect(nv3_x + 8, nv3_y, 4, 3);
    }
  }

  for (float nv3_y = cima + 8; nv3_y < base; nv3_y += 13) {
    if (
      !nv3_escaleraRota(nv3_id) ||
      nv3_y <= nv3_finTramoAlto(nv3_id) ||
      nv3_y >= nv3_inicioTramoBajo(nv3_id)
    ) {
      fill(120, 239, 224);
      rect(nv3_x - 9, nv3_y, 18, 3);
    }
  }

  if (nv3_escaleraRota(nv3_id)) {
    fill(255, 193, 97);
    rect(nv3_x - 13, nv3_finTramoAlto(nv3_id) - 2, 26, 4);
    rect(nv3_x - 13, nv3_inicioTramoBajo(nv3_id), 26, 4);
  }
}

void nv3_dibujarGeneradoresParkour() {
  if (nv3_fase == 3) {
    int proximo = nv3_numeroBarriles % TAM_NV3_GENERADORES_PARKOUR;

    for (int nv3_i = 0; nv3_i < TAM_NV3_GENERADORES_PARKOUR; nv3_i++) {
      int nv3_p = nv3_generadoresParkour[nv3_i][0];
      int direccion = nv3_generadoresParkour[nv3_i][2];

      float nv3_x = nv3_xOrigenParkour(nv3_i);
      float nv3_y = nv3_alturaPlataforma(nv3_p, nv3_x);

      noStroke();

      fill(65, 53, 85);
      rect(nv3_x - 10, nv3_y - 22, 20, 22);

      fill(150, 109, 88);
      rect(nv3_x - 8, nv3_y - 18, 16, 5);

      fill(91, 116, 130);

      if (nv3_i == proximo && nv3_esperaBarril <= 30) {
        fill(255, 211, 80);
      }

      rect(nv3_x - 3, nv3_y - 29, 6, 5);

      fill(255, 211, 80);

      if (direccion <= 0) {
        triangle(
          nv3_x - 19, nv3_y - 11,
          nv3_x - 13, nv3_y - 15,
          nv3_x - 13, nv3_y - 7
        );
      }

      if (direccion >= 0) {
        triangle(
          nv3_x + 19, nv3_y - 11,
          nv3_x + 13, nv3_y - 15,
          nv3_x + 13, nv3_y - 7
        );
      }
    }
  }
}

void nv3_dibujarMeta() {
  int nv3_p = nv3_metas[nv3_fase - 1];
  float nv3_y = nv3_alturaPlataforma(nv3_p, 105);

  fill(82, 244, 188);
  rect(85, nv3_y - 48, 40, 48);

  fill(18, 43, 51);
  rect(91, nv3_y - 42, 28, 42);

  fill(82, 244, 188);
  triangle(98, nv3_y - 30, 111, nv3_y - 23, 98, nv3_y - 16);

  nv3_rotulo("META", 135, nv3_y - 29, 12, color(134, 252, 207));

  if (nv3_fase != 3) {
    int barrilP = cant_nv3_plataformas[nv3_fase - 1] - 1;

    float nv3_x = nv3_xGenerador();
    float by = nv3_alturaPlataforma(barrilP, nv3_x);

    fill(125, 89, 143);
    rect(nv3_x - 17, by - 28, 34, 28);

    fill(249, 186, 100);
    rect(nv3_x - 13, by - 24, 26, 6);
  }
}

// ============================================================
// PERSONAJES Y EFECTOS DE RECARGA
// ============================================================

void nv3_dibujarPersonaje(
  float nv3_x,
  float nv3_y,
  int nv3_id,
  float nv3_escala,
  boolean nv3_andando,
  int nv3_dir
) {
  pushMatrix();

  translate(round(nv3_x), round(nv3_y));
  scale(nv3_dir * nv3_escala, nv3_escala);

  noStroke();

  int paso = 0;

  if (nv3_andando && nv3_reloj % 20 < 10) {
    paso = 3;
  }

  fill(29, 35, 67);
  rect(-9, -12, 7, 9 - paso);
  rect(3, -12, 7, 9 + paso);

  // Zapatos de Mateo durante la recuperacion.
  fill(230, 239, 251);

  if (
    nv3_id == 1 &&
    nv3_personaje == 1 &&
    nv3_pantalla == 2 &&
    nv3_recarga > 0 &&
    nv3_velocidadExtra == 0
  ) {
    fill(240, 68, 74);
  }

  rect(-11, -4 - paso, 10, 4);
  rect(2, -4 + paso, 11, 4);

  fill(nv3_colorPersonaje(nv3_id));
  rect(-11, -25, 22, 15);

  fill(245, 186, 141);
  rect(-15, -24, 4, 12);
  rect(11, -24, 4, 12);

  if (nv3_id == 2) {
    fill(174, 113, 78);
  }

  rect(-9, -38, 18, 15);

  fill(53, 37, 48);
  rect(-10, -40, 20, 6);
  rect(-10, -35, 4, 5);

  if (nv3_id == 0) {
    rect(-1, -43, 7, 6);

    fill(246, 246, 255);
    rect(-4, -21, 8, 3);
  }

  if (nv3_id == 1) {
    fill(237, 100, 72);
    rect(-12, -40, 24, 5);
    rect(8, -38, 8, 4);
  }

  if (nv3_id == 2) {
    noFill();
    stroke(219, 229, 255);
    strokeWeight(1);

    rect(-8, -32, 7, 5);
    rect(1, -32, 7, 5);
    line(-1, -30, 1, -30);

    noStroke();
  }

  if (nv3_id == 3) {
    fill(53, 37, 48);
    rect(-14, -34, 6, 17);

    fill(243, 126, 181);
    rect(-14, -35, 5, 4);
  }

  fill(24, 26, 48);
  rect(4, -31, 3, 3);

  popMatrix();
}

void nv3_dibujarIndicadorRecarga() {
  if (
    nv3_personaje == 3 &&
    (nv3_recarga > 0 || nv3_brilloRecarga > 0)
  ) {
    float avance = 1;

    if (nv3_recarga > 0) {
      avance = 1 - nv3_recarga / float(nv3_recargaTotal);
    }

    noFill();
    strokeWeight(3);
    stroke(49, 65, 88);

    ellipse(nv3_px, nv3_py - 18, 57, 64);

    stroke(115, 219, 205);

    if (nv3_brilloRecarga > 0) {
      stroke(190, 255, 205);
      strokeWeight(4);
    }

    for (int nv3_i = 0; nv3_i < 24; nv3_i++) {
      if (nv3_i / 24.0 < avance) {
        float a = -HALF_PI + nv3_i * TWO_PI / 24;

        point(
          round(nv3_px + cos(a) * 28),
          round(nv3_py - 18 + sin(a) * 32)
        );
      }
    }

    noStroke();
  }
}

void nv3_dibujarBarril(float nv3_x, float nv3_y) {
  pushMatrix();

  translate(nv3_x, nv3_y);
  rotate(nv3_reloj * 0.09);

  fill(197, 117, 63);
  rect(-10, -10, 20, 20);

  fill(255, 196, 108);
  rect(-11, -7, 22, 3);
  rect(-11, 4, 22, 3);

  fill(100, 63, 65);
  rect(-3, -9, 5, 18);

  popMatrix();
}

void nv3_dibujarFuego(float nv3_x, float nv3_y, boolean nv3_persigue) {
  float salto = 0;

  if (nv3_reloj % 24 < 12) {
    salto = 3;
  }

  noStroke();

  fill(255, 114, 77);

  if (nv3_persigue) {
    fill(166, 82, 244);
  }

  rect(nv3_x - 11, nv3_y - 20, 22, 18);

  triangle(
    nv3_x - 11, nv3_y - 19,
    nv3_x - 9, nv3_y - 30 - salto,
    nv3_x - 1, nv3_y - 19
  );

  triangle(
    nv3_x - 2, nv3_y - 18,
    nv3_x + 4, nv3_y - 33 + salto,
    nv3_x + 10, nv3_y - 18
  );

  fill(255, 208, 90);

  if (nv3_persigue) {
    fill(228, 166, 255);
  }

  rect(nv3_x - 6, nv3_y - 16, 13, 13);

  fill(36, 27, 47);
  rect(nv3_x - 6, nv3_y - 18, 3, 4);
  rect(nv3_x + 3, nv3_y - 18, 3, 4);
}

// ============================================================
// HUD Y PAUSA
// ============================================================

void nv3_dibujarHUD() {
  noStroke();
  fill(13, 15, 32);

  rect(0, 0, nv3Ancho, 111);
  rect(0, 744, nv3Ancho, 56);

  nv3_rotulo(
    "BARRELBOUND '81",
    46, 36, 16, color(117, 231, 220)
  );

  nv3_rotulo(
    "RECORD " + nf(nv3_recordPuntos, 6),
    380, 36, 14, color(255, 212, 100)
  );

  nv3_rotulo(
    "FASE " + nv3_fase + " / 3   " + nv3_nombreFase(),
    46, 60, 18, color(239, 241, 255)
  );

  nv3_rotulo(
    "PUNTOS " + nf(nv3_puntos, 6),
    637, 36, 18, color(255, 212, 100)
  );

  nv3_rotulo(
    "VIDAS " + nv3_vidas,
    637, 60, 13, color(195, 200, 222)
  );

  for (int nv3_i = 0; nv3_i < min(nv3_vidas, 5); nv3_i++) {
    fill(255, 117, 157);
    rect(750 + nv3_i * 24, 48, 16, 13);
    rect(753 + nv3_i * 24, 61, 10, 3);
  }

  nv3_rotulo(
    nv3_nombrePersonaje(nv3_personaje),
    46, 92, 16, nv3_colorPersonaje(nv3_personaje)
  );

  String estado = nv3_ayudaHabilidad[nv3_personaje];

  if (nv3_recarga > 0) {
    estado = "RECARGA " + nf(nv3_recarga / 60.0, 1, 1) + "s";
  }

  if (nv3_velocidadExtra > 0) {
    estado =
      "SUPER VELOCIDAD " +
      nf(nv3_velocidadExtra / 60.0, 1, 1) + "s";
  }

  if (nv3_escudo > 0) {
    estado =
      "ESCUDO " +
      nf(nv3_escudo / 60.0, 1, 1) + "s | 1 impacto";
  }

  nv3_rotulo(estado, 156, 92, 13, color(195, 205, 231));

  int tintaTiempo = color(159, 173, 204);

  if (nv3_tiempoRestante < 900 && nv3_reloj % 30 < 15) {
    tintaTiempo = color(255, 96, 121);
  }

  nv3_rotulo(
    "TIEMPO " + (nv3_tiempoRestante + 59) / 60 + "s",
    767, 92, 13, tintaTiempo
  );

  String premio = "FICHAS " + nv3_contarFichas() + "/" + TAM_NV3_FICHAS;

  if (nv3_avisoFichas > 0) {
    premio = "6 FICHAS: +1 VIDA / +600 PUNTOS";
  }

  nv3_centrado(premio, 725, 12, color(255, 212, 100));

  nv3_centrado(
    "FLECHAS / WASD  mover y trepar    ESPACIO  saltar    E  habilidad",
    746, 13, color(197, 207, 231)
  );

  nv3_centrado(
    "P  pausa     R  reiniciar     M  maquina arcade     Fichas +150 / barril +100",
    765, 12, color(155, 175, 210)
  );
}

void nv3_dibujarPausa() {
  fill(8, 11, 25, 215);
  rect(0, 111, nv3Ancho, 633);

  nv3_panel(230, 260, 500, 260, color(117, 231, 220));

  nv3_centrado("PAUSA", 319, 34, color(239, 241, 255));

  nv3_centrado(
    "La maquina puede esperar.",
    363, 17, color(186, 201, 226)
  );

  nv3_centrado(
    "P  continuar",
    419, 19, color(117, 231, 220)
  );

  nv3_centrado(
    "R  volver a seleccion  |  M  volver a la maquina",
    470, 13, color(255, 193, 113)
  );
}

// ============================================================
// SALA DE LA NOVELA VISUAL
// ============================================================

void nv3_dibujarSala() {
  pushStyle();
  noStroke();
  rectMode(CORNER);

  // Pared de ladrillos oscuros y zócalo iluminado.
  background(15, 14, 34);
  fill(27, 24, 53);
  rect(0, 115, nv3Ancho, 397);
  for (int fila = 0; fila < 7; fila++) {
    float y = 154 + fila * 48;
    fill(37, 32, 70);
    rect(0, y, nv3Ancho, 2);
    for (int col = 0; col < 9; col++) {
      float x = col * 120 + (fila % 2) * 60;
      rect(x, y + 2, 2, 46);
    }
  }
  fill(46, 37, 82);
  rect(0, 116, nv3Ancho, 20);
  fill(125, 255, 216, 160);
  rect(0, 135, nv3Ancho, 3);
  fill(10, 13, 30);
  rect(0, 503, nv3Ancho, 137);
  fill(90, 77, 130);
  rect(0, 502, nv3Ancho, 4);

  // Baldosas regulares: evitan las diagonales que cruzaban la sala.
  for (int fila = 0; fila < 5; fila++) {
    for (int col = 0; col < 16; col++) {
      fill((fila + col) % 2 == 0 ? color(17, 24, 48) : color(22, 29, 54));
      rect(col * 60, 508 + fila * 27, 59, 26);
    }
  }

  // Tubos de neón y carteles entre las máquinas.
  for (int i = 0; i < 3; i++) {
    float x = 169 + i * 305;
    fill(70, 44, 110, 110);
    rect(x - 115, 145, 230, 7);
    fill(i == 1 ? color(117, 231, 220) : color(237, 96, 181));
    rect(x - 101, 147, 202, 3);
    fill(8, 12, 30);
    rect(x - 24, 145, 48, 16);
    fill(255, 212, 100);
    rect(x - 17, 151, 34, 3);
  }
  for (int i = 0; i < 2; i++) {
    float x = 305 + i * 305;
    fill(8, 13, 31);
    rect(x - 20, 213, 42, 157);
    fill(95, 68, 150);
    rect(x - 16, 217, 34, 149);
    fill(15, 21, 42);
    rect(x - 11, 225, 24, 104);
    fill(255, 211, 110);
    rect(x - 7, 232, 16, 15);
    fill(120, 238, 216);
    rect(x - 7, 259, 16, 46);
  }

  for (int nv3_i = 0; nv3_i < 3; nv3_i++) {
    float nv3_x = 80 + nv3_i * 305;

    fill(7, 10, 23, 170);
    rect(nv3_x + 10, 183, 181, 325);
    fill(29, 27, 59);
    rect(nv3_x - 4, 179, 186, 329);
    fill(67, 49, 105);
    rect(nv3_x, 172, 178, 330);
    fill(93, 69, 142);
    rect(nv3_x + 5, 178, 168, 6);

    fill(91, 71, 133);
    rect(nv3_x - 10, 172, 198, 43);
    fill(157, 115, 205);
    rect(nv3_x - 10, 172, 198, 4);
    fill(17, 16, 42);
    rect(nv3_x + 5, 222, 168, 145);

    fill(15, 20, 40);
    rect(nv3_x + 16, 236, 146, 120);

    fill(35, 78, 106);
    rect(nv3_x + 26, 246, 126, 100);
    fill(255, 255, 255, 14);
    rect(nv3_x + 30, 250, 116, 92);
    for (int j = 0; j < 7; j++) {
      fill((j + nv3_i) % 2 == 0 ? color(117, 231, 220) : color(234, 107, 187));
      rect(nv3_x + 34 + j * 16, 316 - ((j * 17 + nv3_i * 13) % 52), 10, 12);
    }
    fill(255, 212, 100);
    rect(nv3_x + 55, 262, 69, 3);

    fill(27, 34, 61);

    quad(
      nv3_x + 8, 369,
      nv3_x + 170, 369,
      nv3_x + 182, 405,
      nv3_x - 4, 405
    );

    fill(255, 126, 162);
    ellipse(nv3_x + 53, 385, 16, 16);

    fill(255, 212, 100);
    ellipse(nv3_x + 122, 387, 12, 12);

    fill(15, 18, 34);
    rect(nv3_x + 71, 445, 36, 12);
    fill(14, 18, 36);
    rect(nv3_x + 13, 466, 150, 21);
    fill(117, 231, 220, 125);
    rect(nv3_x + 25, 476, 126, 3);
    fill(255, 212, 100);
    rect(nv3_x + 143, 427, 8, 8);
  }

  nv3_rotulo("NEON CLUB", 93, 201, 19, color(255, 179, 217));
  nv3_rotulo("BARREL '81", 393, 201, 20, color(125, 255, 216));
  nv3_rotulo("TOY BOX", 705, 201, 22, color(255, 212, 100));

  for (int nv3_i = 0; nv3_i < 4; nv3_i++) {
    nv3_dibujarPersonaje(320 + nv3_i * 104, 559, nv3_i, 2.1, false, 1);
  }
  popStyle();
}

void nv3_dibujarHistoria(boolean nv3_finalJuego) {
  nv3_dibujarSala();

  nv3_centrado(
    "BARRELBOUND '81",
    57, 32, color(240, 244, 255)
  );

  nv3_centrado(
    "NIVEL 3 / UNA TARDE EN EL ARCADE",
    87, 15, color(117, 231, 220)
  );

  nv3_panel(50, 599, 860, 158, color(87, 127, 156));

  int escena = 0;

  if (nv3_finalJuego) {
    escena = 1;
  }

  String[] lineas = nv3_conversaciones[escena][nv3_dialogo];

  nv3_rotulo(lineas[0], 76, 630, 16, color(117, 231, 220));
  nv3_rotulo(lineas[1], 76, 665, 17, color(239, 241, 255));
  nv3_rotulo(lineas[2], 76, 696, 17, color(200, 212, 236));

  nv3_rotulo(
    "ENTER  continuar",
    704, 737, 13, color(255, 212, 100)
  );
}

// ============================================================
// SELECCION DE PERSONAJE
// ============================================================

void nv3_dibujarSeleccion() {
  nv3_fondoDecorativo();

  nv3_centrado(
    "ELIGE QUIEN TOMA EL MANDO",
    102, 29, color(241, 242, 255)
  );

  nv3_centrado(
    "Cuatro amigos. Una partida. El mismo camino hasta la cima.",
    143, 16, color(169, 189, 216)
  );

  nv3_centrado(
    "RECORD " + nf(nv3_recordPuntos, 6),
    199, 16, color(255, 212, 100)
  );

  for (int nv3_i = 0; nv3_i < 4; nv3_i++) {
    float nv3_x = 48 + nv3_i * 222;
    int nv3_borde = color(57, 66, 96);

    if (nv3_personaje == nv3_i) {
      nv3_borde = nv3_colorPersonaje(nv3_i);
    }

    nv3_panel(nv3_x, 255, 200, 311, nv3_borde);

    nv3_rotulo("0" + (nv3_i + 1), nv3_x + 16, 284, 14, nv3_borde);

    nv3_dibujarPersonaje(nv3_x + 100, 390, nv3_i, 2.4, false, 1);

    fill(nv3_colorPersonaje(nv3_i));
    textAlign(CENTER);
    textSize(21);

    text(nv3_nombrePersonaje(nv3_i), nv3_x + 100, 435);

    textSize(13);
    fill(224, 231, 247);

    text(nv3_habilidades[nv3_i][0], nv3_x + 100, 471);
    text(nv3_habilidades[nv3_i][1], nv3_x + 100, 500);
    text(nv3_habilidades[nv3_i][2], nv3_x + 100, 522);

    textAlign(LEFT, BASELINE);
  }

  nv3_centrado(
    "1 - 4 / flechas / clic   elegir",
    627, 17, color(177, 197, 224)
  );

  nv3_centrado(
    "ENTER  EMPEZAR",
    675, 25, nv3_colorPersonaje(nv3_personaje)
  );

  nv3_centrado(
    "75s por fase. Las 6 fichas dan +1 vida y +600 puntos. (M: volver a la maquina)",
    722, 14, color(145, 164, 195)
  );
}

// ============================================================
// TRANSICION Y DERROTA
// ============================================================

void nv3_dibujarTransicion() {
  nv3_fondoDecorativo();

  nv3_centrado(
    "FASE " + nv3_fase + " SUPERADA",
    240, 36, color(117, 231, 220)
  );

  nv3_centrado(
    "PUNTUACION " + nf(nv3_puntos, 6),
    306, 23, color(255, 212, 100)
  );

  nv3_centrado(
    "SIGUIENTE: FASE " + (nv3_fase + 1),
    392, 19, color(241, 242, 255)
  );

  for (int nv3_i = 0; nv3_i < 2; nv3_i++) {
    nv3_centrado(
      nv3_consejos[nv3_fase - 1][nv3_i],
      441 + nv3_i * 32, 16, color(195, 208, 233)
    );
  }

  nv3_centrado(
    "Checkpoint guardado: la siguiente fase empieza con 4 vidas.",
    547, 16, color(168, 191, 219)
  );

  nv3_centrado(
    "ENTER  CONTINUAR",
    620, 24, color(117, 231, 220)
  );
}

void nv3_dibujarDerrota() {
  nv3_fondoDecorativo();

  nv3_centrado(
    "FIN DE LA PARTIDA",
    281, 38, color(255, 125, 161)
  );

  nv3_centrado(
    "PUNTOS " + nf(nv3_puntos, 6) + "  /  FASE " + nv3_fase,
    345, 23, color(255, 212, 100)
  );

  nv3_centrado(
    "RECORD " + nf(nv3_recordPuntos, 6),
    385, 17, color(255, 212, 100)
  );

  nv3_centrado(
    "Mateo: \"Era calentamiento, obviamente.\"",
    432, 17, color(213, 221, 243)
  );

  nv3_centrado(
    "Sam: \"Entonces vamos con la de verdad.\"",
    470, 17, color(213, 221, 243)
  );

  nv3_centrado(
    "ENTER  REINTENTAR ESTA FASE (ULTIMO INTENTO)",
    591, 20, color(117, 231, 220)
  );
}

// ============================================================
// FOTO Y FINAL
// ============================================================

void nv3_dibujarFoto() {
  nv3_centrado(
    "NUEVO RECUERDO DESBLOQUEADO",
    84, 29, color(117, 231, 220)
  );

  fill(236, 235, 244);
  rect(230, 120, 500, 293);

  fill(53, 44, 84);
  rect(245, 135, 470, 225);

  nv3_rotulo(
    "BARRELBOUND '81",
    365, 174, 22, color(255, 212, 100)
  );

  for (int nv3_i = 0; nv3_i < 4; nv3_i++) {
    nv3_dibujarPersonaje(315 + nv3_i * 110, 331, nv3_i, 2.5, false, 1);
  }

  nv3_rotulo(
    "NEON CLUB  /  LOS CUATRO",
    259, 391, 17, color(42, 38, 65)
  );

  nv3_centrado(
    "Sam abre Pixagram. La foto salio bastante bien.",
    451, 16, color(220, 228, 247)
  );

  for (int nv3_i = 0; nv3_i < 3; nv3_i++) {
    nv3_panel(
      120,
      475 + nv3_i * 68,
      720,
      56,
      color(69, 94, 128)
    );

    String opcion = (nv3_i + 1) + "  " + nv3_opcionesFoto[nv3_i];

    nv3_rotulo(
      opcion,
      145, 510 + nv3_i * 68, 17,
      color(224, 233, 250)
    );
  }

  nv3_centrado(
    "Elige con 1, 2, 3 o haz clic.",
    737, 14, color(145, 164, 195)
  );
}

void nv3_dibujarCierre() {
  nv3_dibujarSala();

  nv3_centrado(
    "VICTORIA / " + nf(nv3_puntos, 6) + " PUNTOS",
    68, 28, color(255, 212, 100)
  );

  nv3_panel(
    45, 589, 870, 176,
    color(117, 231, 220)
  );

  for (int nv3_i = 0; nv3_i < 3; nv3_i++) {
    nv3_rotulo(
      nv3_cierres[nv3_decision][nv3_i],
      65, 620 + nv3_i * 28, 15,
      color(209, 225, 245)
    );
  }

  nv3_rotulo(
    "Sam guarda el celular y los alcanza, sonriendo. \"Voy con ustedes.\"",
    65, 716, 15, color(117, 231, 220)
  );

  nv3_rotulo(
    "ENTER  continuar",
    560, 749, 14, color(255, 212, 100)
  );
}
