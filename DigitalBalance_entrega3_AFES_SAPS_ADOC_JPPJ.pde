import processing.video.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import processing.sound.*;

// Capacidades explícitas: no se consulta la longitud de los arreglos.
final int TAM_FRUTA_RADIOS = 10;
final int TAM_DEBUG_OPCIONES_SALTO = 17;
final int TAM_ESCENAS_NOVELA = 5;
final int TAM_FINAL_NIVEL3_BORRADORES = 6;
final int TAM_FINAL_NIVEL3_LINEAS_CREDITOS = 35;
final int TAM_FINAL_NIVEL3_TEXTO_BUENO = 3;
final int TAM_FRUTA_NUEVA_TIPO = 80;
final int TAM_HC_PAGINAS_BUENO = 12;
final int TAM_HC_PAGINAS_CIERRE_BUENO = 5;
final int TAM_HC_PAGINAS_CIERRE_MALO = 5;
final int TAM_HC_PAGINAS_MALO = 14;
final int TAM_IMG_FIGURAS = 15;
final int TAM_NOMBRES_FIGURAS = 15;
final int TAM_NV3_BARRIL_ACTIVO = 16;
final int TAM_NV3_BORDE_X = 1800;
final int TAM_NV3_CHARLA_ARCADE = 10;
final int TAM_NV3_CODIGOS_FLECHA = 4;
final int TAM_NV3_CONTADOR_SALIDAS = 11;
final int TAM_NV3_FICHAS = 6;
final int TAM_NV3_GENERADORES_PARKOUR = 11;
final int TAM_NV3_MAPAS = 3;
final int TAM_NV3_NOMBRES = 4;
final int TAM_NV3_OPCIONES_FOTO = 3;
final int TAM_NV3_RETENIDAS = 256;
final int TAM_NV3_TECLAS = 8;
final int TAM_PAGINAS_ESCUELA = 66;
final int TAM_PIXA_FOTOS_POSTS = 6;
final int TAM_T3_TEXTO_MANANA = 11;
final int TAM_T3_TEXTO_NOCHE = 8;

// =====================================================
// RESOLUCION BASE (todo se escala a partir de esto)
// =====================================================
float REF_W = 1536.0;
float REF_H = 864.0;
float escalaX, escalaY;

// =====================================================
// PANTALLAS
// =====================================================
int CARGA = 0;
int MENU = 1;
int JUEGO = 2;
int CREDITOS = 3;
int EXPLORACION = 4;
int LOGROS = 5;
int PADRES = 6;
int NIVEL1 = 7;
int NOVELA_ESCUELA = 8;
int NIVEL1_INTRO = 9;
int PENALTIS = 10;
int NIVEL2_INTRO = 11;
int NIVEL2 = 12;
int TRANSICION_TEMPORAL = 13;
int NOVELA_COCINA = 14;
int SELECCION_DIF_NV2 = 15;
int FIN_DIA_1 = 16;
int DESAYUNO = 17;
int estadoActual = CARGA;
int estadoDestino = MENU;

// =====================================================
// CARGA Y TRANSICION
// =====================================================
final int totalPasosCarga = 16;
int pasoCarga = -2;
float alphaTransicion = 0;
boolean enTransicion = false;
PFont fuenteComic;
PFont fuenteCelular;
PFont fontTitle;
PFont fontBold;
PFont fontBody;

// =====================================================
// EFECTO MAQUINA DE ESCRIBIR (TYPEWRITER)
// =====================================================
float charsVisibles = 0;
float velTypewriter = 2.2;
String ultimoTextoDialogo = "";
boolean dialogoCompletado = false;

// =====================================================
// PANTALLA DE TRANSICION "NIVEL 1" Y MINIJUEGO PENALTIS
// =====================================================
int timerNivel1Intro = 0;
final int DURACION_NIVEL1_INTRO = 90; // ~1.5 segundos en pantalla negra

// Estados Penaltis: 0 = INICIO/DIFICULTAD, 1 = APUNTAR, 2 = DISPARAR, 3 = RESULTADO, 4 = FIN
int penEstadoActual = 0;
int penSubEstadoApuntado = 0; // 0 = DIRECCION, 1 = ALTURA, 2 = POTENCIA
int penDificultadActual = 0;  // 0 = NORMAL, 1 = DIFICIL, 2 = EXTREMO
String[] penNombresDificultad = { "NORMAL", "DIFÍCIL", "EXTREMO" };
final int TOTAL_DIFICULTADES_PEN = 3;

int penTiempoLimiteFrames = 300;
int penTiempoRestanteAccion = 300;
float penMultVelocidadMira = 1.0f;
float penBaseProbabilidadArquero = 0.35f;

final int TOTAL_TIROS = 5;
int tiroActual = 1;

public int goles = 0;
public int atajadas = 0;
public int fallos = 0;
int puntajePenaltis = 0;
boolean penaltisJugados = false;

float arcoX, arcoY, arcoAncho, arcoAlto;
float grosorPostes = 24;
float puntoPenaltiX, puntoPenaltiY;

float anguloDireccion = 0;
float anguloAltura = 0;
float porcentajePotencia = 0;
float apTargetX, apTargetY;

float balonX, balonY;
float balonOrigenX, balonOrigenY;
float balonDestinoX, balonDestinoY;
float balonTamanoInicial = 54;
float balonTamanoFinal = 26;
float balonTamanoActual = 54;
float tBalon = 0;
float velocidadBalon = 0.035f;

float arqueroX, arqueroY;
float arqueroOrigenX, arqueroOrigenY;
float arqueroDestinoX, arqueroDestinoY;
float arqueroAncho = 76;
float arqueroAlto = 175;
float radioAtajada = 70;
float velocidadArquero = 0.07f;

float pateadorBaseX, pateadorBaseY;
float pateadorX, pateadorY;

String mensajeResultado = "";
int colorResultado;
int tiempoResultadoFrames = 0;
final int DURACION_PAUSA_RESULTADO = 95;
boolean accionApuntadoDisparada = false;

PImage imgFondoCancha;
PImage imgSamQuieto, imgSamPatada;
PImage imgMateoQuieto, imgMateoIzq, imgMateoDer;
PImage imgCristianQuieto, imgCristianIzq, imgCristianDer;
PImage imgBalon;
PImage imgSamCancha, imgMateoCancha, imgCristianCancha;
PImage imgPostGana, imgPostPierde;
PImage imgMama, imgPapa, imgEscenaDesayuno;
PImage imgFondoCocina;
PImage imgSamChefFeliz, imgSamChefPensativo;
PImage imgMateoCasualApena, imgMateoChefEntusiasmado;
PImage imgPlatoMichelin, imgPlatoQuemado;
PImage imgNotaNv2, imgReceptorNv2;
PImage[] imgDificultadNv2 = new PImage[4];

// =====================================================
// PANTALLA DE TRANSICION "NIVEL 2" Y MINIJUEGO DE COCINA AL RITMO
// =====================================================
int timerNivel2Intro = 0;
final int DURACION_NIVEL2_INTRO = 155; // ~2.5 segundos con aviso de fotosensibilidad

// Sub-estados Nivel 2: 0 = JUGANDO, 1 = RESULTADOS, 2 = DERROTA
final int NV2_SUB_JUGANDO = 0;
final int NV2_SUB_RESULTADOS = 1;
final int NV2_SUB_DERROTA = 2;
int nv2SubEstado = NV2_SUB_JUGANDO;

// Dificultades Nivel 2: 0 = INTERMEDIO, 1 = DIFICIL, 2 = EXTREMO, 3 = INJUGABLE
final int NV2_DIF_NORMAL = 0;
final int NV2_DIF_INTERMEDIO = 0;
final int NV2_DIF_DIFICIL = 1;
final int NV2_DIF_EXTREMO = 2;
final int NV2_DIF_INJUGABLE = 3;
final int TOTAL_DIFICULTADES_NV2 = 4;
int nv2Dificultad = NV2_DIF_INTERMEDIO;
String[] nv2NombresDificultad = { "INTERMEDIO", "DIFÍCIL", "EXTREMO", "INJUGABLE" };
String[] nv2DescripcionesDif = {
  "2 Carriles (A, D / Flechas) - Ritmo amigable - Mult. x1.0",
  "4 Carriles Progresivos (D, F, J, K) - Reto activo - Mult. x1.5",
  "5 Carriles (D, F, J, K, L) - Notas dobles y rápidas - Mult. x2.2",
  "9 Carriles (A, S, D, F, ESPACIO, H, J, K, L) - Velocidad brutal - Mult. x3.5"
};
float[] nv2MultiplicadorDif = { 1.0f, 1.5f, 2.2f, 3.5f };
int[] nv2CarrilesPorDif = { 2, 4, 5, 9 };

// Audio del Nivel 2
SoundFile nv2Audio;
String nv2ArchivoAudio = "appeal_100bpm.mp3";
String nv2CancionTitulo = "Phantastic Beats - Appeal (1:31)";
String nv2RecetaNombre = "Estofado Real del Chef";

// Resultados
public float nv2PrecisionFinal = 0.0f;
public String nv2CategoriaResultado = "";
boolean nv2Completado = false;

// Velocidad y sincronización (calibrados sobre REF_W=1536, REF_H=864)
int nv2OffsetMs = -8380;
float nv2ScrollSpeed = 1050.0f;
int nv2SpawnAnticipacionMs = 1100;
int nv2VentanaPerfectoMs = 75;
int nv2VentanaBuenoMs = 145;

// Marcadores y Combos
int nv2TiempoInicioMs = 0;
int nv2PuntosObtenidos = 0;
int nv2ComboActual = 0;
int nv2MaxCombo = 0;
int nv2ConteoPerfecto = 0;
int nv2ConteoBueno = 0;
int nv2ConteoFallo = 0;
String nv2FeedbackVisual = "";
int nv2FeedbackTimer = 0;
int nv2ColorFeedback = color(255);
float nv2ProgresoLerp = 0.0f;

// Geometría base de carriles (se escala con escalaX / escalaY)
float nv2CarrilIzqBaseX = 580.0f;
float nv2CarrilDerBaseX = 956.0f;
float nv2ZonaImpactoBaseY = 730.0f;
float nv2RadioNotaBase = 36.0f;

// Arreglos paralelos de carriles activos (hasta 9 carriles: A, S, D, F, ESPACIO, H, J, K, L)
final int MAX_CARRILES_NV2 = 9;
int nv2NumCarrilesActivos = 2;
float[] nv2CarrilBaseX = { 580.0f, 956.0f, 700.0f, 836.0f, 972.0f, 1108.0f, 1180.0f, 1250.0f, 1320.0f };
boolean[] nv2TeclaCarrilPresionada = new boolean[MAX_CARRILES_NV2];
int[] nv2FlashCarril = new int[MAX_CARRILES_NV2];
String[] nv2EtiquetasCarril = { "A / IZQ", "D / DER", "J", "K", "L", "", "", "", "" };
int[] nv2ColoresCarril = {
  color(240, 65, 65),
  color(55, 165, 250),
  color(70, 220, 105),
  color(255, 195, 45),
  color(195, 95, 250),
  color(255, 125, 45),
  color(45, 225, 215),
  color(255, 95, 185),
  color(170, 235, 60)
};

// Estado continuo de controles (compatibilidad 2 carriles iniciales)
boolean nv2TeclaIzqPresionada = false;
boolean nv2TeclaDerPresionada = false;

// Animación de impacto en carriles
int nv2FlashIzq = 0;
int nv2FlashDer = 0;
boolean nv2ReiniciarPartida = false;

// Arreglos paralelos para notas
final int MAX_NOTAS_NV2 = 4500;
int totalNotasNv2 = 0;
int[] nv2NotaTiempoMs = new int[MAX_NOTAS_NV2];
int[] nv2NotaCarril = new int[MAX_NOTAS_NV2]; // 0..5 según carril activo
boolean[] nv2NotaEsSostenida = new boolean[MAX_NOTAS_NV2];
int[] nv2NotaDuracionMs = new int[MAX_NOTAS_NV2];
boolean[] nv2NotaImpactada = new boolean[MAX_NOTAS_NV2];
boolean[] nv2NotaManteniendo = new boolean[MAX_NOTAS_NV2];
boolean[] nv2NotaCompletada = new boolean[MAX_NOTAS_NV2];
boolean[] nv2NotaFallada = new boolean[MAX_NOTAS_NV2];

// =====================================================
// RECURSOS
// =====================================================
Movie videoFondo;
Movie videoCreditos;
SoundFile musicaFondo;
boolean musicaFondoDeberiaSonar = false;
int ultimoEstadoAudioControl = -1;
SoundFile sonidoHover;
SoundFile sonidoClic;
SoundFile sfxFrutaFusion;
SoundFile sfxFrutaCaida;
SoundFile[] paMusicaNiveles = new SoundFile[9];
String[] paArchivosMusica = {
  "cancion_hamburguesa.mp3", // Nivel 1
  "cancion_sushi.mp3",       // Nivel 2
  "cancion_sonic.mp3",       // Nivel 3
  "cancion_pikachu.mp3",     // Nivel 4
  "cancion_hongo.mp3",       // Nivel 5
  "cancion_gato_gris.mp3",   // Nivel 6
  "cancion_pollito.mp3",     // Nivel 7
  "cancion_stitch.mp3",      // Nivel 8
  "cancion_gato_flor.mp3"    // Nivel 9
};
PImage logoMenu;
PImage fondoEscena;
PImage fondoHabitacion;
PImage fondoPrimerPiso;
PImage indicativoDireccion, indicativoGuardar, indicativoPendiente;
PImage marcoCelular;

// =====================================================
// MINIJUEGO MEMORIA / PAREJAS 
// =====================================================
PImage imgCartaReverso = null;
PImage imgCartaFrente = null;
PImage imgFondoCartas = null;
PImage[] imgFiguras = new PImage[15];
String[] nombresFiguras = {
  "perrito", "gato", "pizza", "manzana", "estrella",
  "carrito", "sol", "luna", "pez", "pelota",
  "helado", "monstruito", "pastel", "dona", "fantasma"
};

// =====================================================
// VOLUMEN
// =====================================================
float volMaster = 1.0;
int nivelVolumen = 10;
boolean mostrarOpciones = false;

// =====================================================
// MENU PRINCIPAL
// =====================================================
String[] nombresBotones = {"JUGAR", "OPCIONES", "CRÉDITOS", "SALIR", "LOGROS", "RECUERDOS"};
int totalBotones = 6;
int botonesVisibles = 4;
int offsetCarrusel = 0;
float[] btnX = new float[4];
float[] btnY = new float[4];
float[] btnW = new float[4];
float[] btnH = new float[4];
int opcionSeleccionada = 0;
int ultimaOpcionHover = -1;

float solCentroXRef = REF_W * 0.90;
float solCentroYRef = REF_H * 0.18;
float solRadioRef = REF_W * 0.045;
boolean fondoAlternativo = false;

// =====================================================
// PAUSA (agregamos GUARDAR para guardar el progreso en el txt xd)
// =====================================================
String[] botonesPausa = {"REANUDAR", "GUARDAR", "OPCIONES", "MENU"};
int totalBotonesPausa = 4;
float[] btnPausaX = new float[4];
float[] btnPausaY = new float[4];
float[] btnPausaW = new float[4];
float[] btnPausaH = new float[4];
boolean enPausa = false;
int opcionPausaHover = -1;
int opcionPausaSeleccionada = 0;
int pausaInicioMs = 0;
boolean nv2AudioEstabaSonandoAntesDePausa = false;
float nv2AudioPosPausaSeg = 0.0f;
boolean nv3VideoEstabaSonandoAntesDePausa = false;
boolean skipAutoSaveEnMenu = false;

// =====================================================
// INTRO (HISTORIA INICIAL: CUMPLEAÑOS DE SAM)
// =====================================================
String[] paginasLore = {
  "Es una mañana tranquila. El sol se cuela por las cortinas del cuarto de Sam. Hoy no es un día cualquiera: ¡es su cumpleaños!",
  "Mmmmmmmmmmm...",
  "¿Qué hora es...?",
  "Sam abre un ojo, luego el otro, y se queda mirando el techo.",
  "¡Ah, cierto! ¡Hoy cumplo diez!",
  "Espera... ¿será que...?",
  "¿Será que se acordaron?",
  "Nah, cómo se les va a olvidar. Soy hijo único.",
  "Pero... ¿y si no me compraron lo que pedí?",
  "Llevo meses pidiéndoles ese teléfono. ¡¡MESES!!",
  "Aunque, bueno... tampoco es que sea taaaaan importante.",
  "Bueno, sí lo necesito. O... ¿tal vez no? ¡Agh, no importa!",
  "Todos en el colegio tienen su grupo para jugar y hablar después de clases.",
  "Se ve divertido...",
  "Ojalá tuviera amigos así.",
  "Aunque... ¿de qué hablaría con ellos?",
  "¿Y si les digo 'juguemos'? Capaz piensan que soy intenso. ¿O 'pasemos el rato'? Emmm... ¡ni los conozco y ya los invito a salir!",
  "¡DAAAAAH! ¡Ni tengo el TELÉFONO y ya estoy pensando en cómo meter la pata!",
  "Sam se queda otro rato mirando el techo, imaginando todo lo que haría con un teléfono.",
  "Bueno, primero tendría que tenerlo...",
  "De repente se oye una voz desde la sala.",
  "¡Sam! ¡Baja un momento, que tenemos algo para ti!",
  "¡Y no te quedes ahí pegado al techo, que el cumpleañero tiene que bajar!",
  "¡Ya voy!",
  "¿Y si sí es el teléfono?",
  "Ufff, que no sea ropa, que no sea ropa...",
  "Aunque... ¿qué otra cosa podría ser?",
  "Sam salta de la cama. Intenta bajar tranquilo, pero termina bajando casi de dos en dos.",
  "¡Ya bajo!"
};

String[] hablantesLore = {
  "NARRADOR:",
  "SAM:",
  "SAM:",
  "NARRADOR:",
  "SAM:",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "NARRADOR:",
  "SAM (PENSAMIENTO):",
  "NARRADOR:",
  "MAMÁ:",
  "PAPÁ:",
  "SAM:",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "SAM (PENSAMIENTO):",
  "NARRADOR:",
  "SAM:"
};

int totalPaginasLore = 29;
int paginaActual = 0;

boolean mostrarSaltarIntro = true;
int opcionSaltarIntro = 1;
int hoverSaltarIntro = -1;
String[] textosSaltar = {"SÍ", "NO"};
float[] btnSaltarX = new float[2];
float[] btnSaltarY = new float[2];
float[] btnSaltarW = new float[2];
float[] btnSaltarH = new float[2];

// =====================================================
// NOVELA VISUAL: NOCHE, MAÑANA, COLEGIO Y PENALTIS
// =====================================================
PImage[] escenasNovela = new PImage[5];
String[] nombresArchivosEscenas = {
  "escena_1.png",
  "escena_despertar.png",
  "escena_desayuno.png",
  "escena_escuela.png",
  "escena_cancha.png"
};



int paginaEscuela = 0;

String[] paginasEscuela = {
  "Esa noche, Sam dejó su celular cargando al lado de la cama y se acomodó bajo las cobijas.",
  "Mañana llevo el celular al colegio.",
  "¡Tengo que mostrárselo a todos! Seguro van a querer verlo.",
  "Aunque... ¿y si no les interesa? Bueno, ya veré qué hago.",
  "Sam dejó el celular en la mesita y por fin se quedó dormido.",
  "A la mañana siguiente, la alarma de Sam empezó a sonar.",
  "Mmm... cinco minuticos más.",
  "De pronto, Sam recordó que ese día volvía al colegio y se levantó de golpe.",
  "¡Uy, es verdad! ¡Hoy vuelvo al colegio!",
  "Se vistió rápido y empezó a revisar sus cosas.",
  "Los cuadernos... la cartuchera... ¡el celular! No se me puede quedar.",
  "¿Será que hoy sí me siento con alguien? Bueno, ya veremos.",
  "Con la maleta al hombro, Sam salió de su cuarto.",
  "En la cocina, mamá terminaba de preparar el desayuno mientras papá tomaba café.",
  "¡Sam! ¡A desayunar, mi amor, que se te hace tarde!",
  "¡Ya voy! ¡No encuentro una media!",
  "¿Otra vez? Jajaja. ¿Cuántas llevas perdidas?",
  "¡No está perdida, pa! Tiene que estar por aquí.",
  "¿Miraste debajo de la cama? Ayer te vi quitártelas ahí.",
  "¡Ahhh, sí! ¡Aquí está! ¿Ves? No estaba perdida.",
  "Claro, claro. La media estaba de paseo.",
  "¡Jajajaja! ¡Pa, ya!",
  "Bueno, campeón, ¿listo para volver al colegio?",
  "Sí. Quiero ver si les muestro el celular.",
  "Primero desayuna, mi niño. Después lo muestras.",
  "Al llegar al salón, Sam dejó su maleta junto a uno de los puestos. Un compañero se acercó.",
  "¡Ey! ¿Tú eres nuevo o qué?",
  "No, el año pasado estaba acá. Me sentaba allá atrás.",
  "¡Ahhh, ya! Yo soy Mateo. ¿Y tú?",
  "Sam.",
  "Qué hubo, Sam. ¿Qué hiciste en vacaciones?",
  "Nada, ahí en la casa. Ah, y ayer cumplí diez.",
  "¡¿En serio?! ¡Feliz cumple, parce! ¿Y qué te dieron?",
  "Un celular.",
  "¡¿Un celular?! ¡A ver, a ver!",
  "Mira. Pero tiene un nombre rarísimo.",
  "SOMSOM 3297 ULTRA PRO MAX TURBO... ¡JAJAJAJA! ¿Eso es pirata o qué?",
  "¡Ey! ¡Yo no le puse el nombre!",
  "Jajaja, mala mía. Es que parece que le metieron todos los nombres que había.",
  "Y eso que no has visto la caja. El nombre ocupa todo el frente.",
  "¡JAJAJA! ¿Y ya sabes usarlo?",
  "Más o menos. Ayer me puse a cambiarle cosas y casi lo dejo sin batería.",
  "Jajaja. Bueno, después me lo muestras con calma.",
  "¡Pero no te burles otra vez!",
  "Mateo miró hacia la cancha y tuvo una idea.",
  "Oye, Sam, ¿te metes a jugar fútbol?",
  "¿Ya? Bueno... pero te aviso que no soy bueno.",
  "¡Mejor! Así no me haces quedar mal.",
  "Ah, entonces mejor no juego.",
  "Jajaja, mentira. ¡Ven!",
  "¿Van a jugar o qué?",
  "¡Sí! ¿Te metes?",
  "De una, pero no me pongan de arquero todo el rato.",
  "Jajaja, ¡ni hemos empezado y ya estás poniendo condiciones!",
  "¡Jajaja! Yo soy Sam, por cierto.",
  "Cristian.",
  "Yo ya me había presentado, ¿eh?",
  "Sí, sí, se me olvidó.",
  "Qué bien. Ya me olvidaron y ni empezamos.",
  "Mientras los tres se preparan para jugar, Clara, una compañera de su salón, los observa desde las gradas. No se acerca.",
  "Oye, Mateo, ¿esa niña también es de nuestro salón?",
  "Sí, es Clara. Si la viste esta mañana.",
  "Ahhh, ya. Creo que sí.",
  "Bueno, ¿vamos a jugar o nos vamos a quedar hablando?",
  "¡Ya, ya! Sam, tú empiezas. ¡A ver qué tal juegas!",
  "Listo. Pero después no se quejen si meto un golazo."
};

String[] hablantesEscuela = {
  // ESCENA 0
  "Narrador",
  "Sam",
  "Sam",
  "Sam",
  "Narrador",

  // ESCENA 1
  "Narrador",
  "Sam",
  "Narrador",
  "Sam",
  "Narrador",
  "Sam",
  "Sam",
  "Narrador",

  // ESCENA 2
  "Narrador",
  "Mamá",
  "Sam",
  "Papá",
  "Sam",
  "Mamá",
  "Sam",
  "Papá",
  "Sam",
  "Papá",
  "Sam",
  "Mamá",

  // ESCENA 3
  "Narrador",
  "Mateo",
  "Sam",
  "Mateo",
  "Sam",
  "Mateo",
  "Sam",
  "Mateo",
  "Sam",
  "Mateo",
  "Sam",
  "Mateo",
  "Sam",
  "Mateo",
  "Sam",
  "Mateo",
  "Sam",
  "Mateo",
  "Sam",

  // ESCENA 4
  "Narrador",
  "Mateo",
  "Sam",
  "Mateo",
  "Sam",
  "Mateo",
  "Cristian",
  "Mateo",
  "Cristian",
  "Mateo",
  "Sam",
  "Cristian",
  "Mateo",
  "Sam",
  "Mateo",
  "Narrador",
  "Sam",
  "Mateo",
  "Sam",
  "Cristian",
  "Mateo",
  "Sam"
};

int[] escenaPorPaginaEscuela = {
  // ESCENA 0: 5 páginas
  0, 0, 0, 0, 0,

  // ESCENA 1: 8 páginas
  1, 1, 1, 1, 1, 1, 1, 1,

  // ESCENA 2: 12 páginas
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,

  // ESCENA 3: 19 páginas
  3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
  3, 3, 3, 3, 3, 3, 3, 3, 3,

  // ESCENA 4: 22 páginas
  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
};

int totalPaginasEscuela = TAM_PAGINAS_ESCUELA;

// =====================================================
// CREDITOS
// =====================================================
String[] nombresCreditos = {
  "Sebastian Andrés Pimienta Sánchez",
  "Andrés Felipe Escorcia Sánchez",
  "Juan Pablo Pineda Jimenez",
  "Abraham David Orozco Celedón",
  "Andrés Felipe Escorcia Sánchez",
  "Sebastian Andrés Pimienta Sánchez"
};
int totalNombresCreditos = 6;
int nombreSeleccionado = 0;
int[] comboSecreto = {0, 3, 4}; // Hackerman
int[] secuenciaJugador = {-1, -1, -1};
int totalCombo = 3;

// =====================================================
// LOGROS: {id, nombre, descripcion, puntos, imagen}
// =====================================================
String[][] logros = {
  {"easter_egg_creditos", "Easter Egg", "Descubriste la combinación secreta en los créditos", "50", "logro_01"},
  {"logro_02", "Buen Despertar", "Bajaste a desayunar con tus padres a tiempo", "20", "logro_02"},
  {"logro_03", "Zombi Digital", "Te quedaste pegado a la pantalla y la comida se enfrió", "10", "logro_03"},
  {"logro_04", "Primer Like", "Apoyaste el arte o la foto de un amigo en Pixagram", "10", "logro_04"},
  {"logro_05", "DJ de Bolsillo", "Escuchaste música en el reproductor del celular", "10", "logro_05"},
  {"logro_06", "Defensor Digital", "Tomaste una postura ética ante la publicación sin consentimiento", "35", "logro_06"},
  {"logro_07", "Cazador de Bulos", "Cuestionaste o rechazaste desinformación y retos tóxicos", "25", "logro_07"},
  {"logro_08", "Goleador Implacable", "Ganaste la tanda de penaltis contra Mateo y Cristian", "30", "logro_08"},
  {"logro_09", "Acuerdo en Casa", "Pactaste límites saludables de uso del celular con tus padres", "25", "logro_09"},
  {"logro_10", "Chef Michelin", "Lograste Estrella Michelin en el Estofado Real del Chef", "50", "logro_10"},
  {"logro_11", "Leyenda Injugable", "Superaste el Nivel 2 en la dificultad Injugable (9 carriles)", "80", "logro_11"},
  {"logro_12", "Maestro del Combo", "Alcanzaste una racha de 25 o más notas seguidas en Cocina", "30", "logro_12"},
  {"logro_13", "Coleccionista veloz", "Recoge tres fichas en los primeros 45 segundos de una fase", "5", "logro_13"},
  {"logro_14", "Botín intacto", "Completa una fase con todas las fichas y sin perder vidas", "10", "logro_14"},
  {"logro_15", "Primer piso exprés", "Supera la fase 1 en menos de 45 segundos", "10", "logro_15"},
  {"logro_16", "Aún más alto", "Supera la fase 2 con al menos tres vidas", "10", "logro_16"},
  {"logro_17", "Récord compartido", "Supera la fase 3 habiendo recogido todas sus fichas", "20", "logro_17"},
  {"logro_18", "Sin un rasguño", "Supera la fase 3 sin perder vidas durante el intento", "10", "logro_18"},
  {"logro_19", "Remontada perfecta", "Tras agotar las vidas, supera esa fase sin perder ninguna vida en el reintento", "10", "logro_19"},
  {"logro_20", "Una buena tarde", "Supera el arcade y alcanza el final bueno", "10", "logro_20"},
  {"logro_21", "Tiempo para escuchar", "Llega a la fase 3, agota los dos intentos y descubre el final malo", "10", "logro_21"}
};
int totalLogros = 21;
boolean[] logrosDesbloqueados = new boolean[21];
PImage[] logroImagenes = new PImage[21];
int puntosJugador = 0;
int logroNotifFinTiempo = 0;
String logroNotifTexto = "";

// =====================================================
// SAM: posicion, hitbox, sprites y teclas de movimiento
// =====================================================
float pjX = 500;
float pjY = 500;
float pjW = 90;
float pjH = 125;
float pjVel = 8.5;

float hitOffX = 22;
float hitOffY = 90;
float hitW = 44;
float hitH = 34;

String direccionSam = "sur";
boolean samCaminando = false;

boolean movArriba = false;
boolean movAbajo = false;
boolean movIzquierda = false;
boolean movDerecha = false;
int[] teclasDireccion = new int[4];
int cantTeclasDir = 0;

PImage[] spriteCaminarNorte = new PImage[4];
PImage[] spriteCaminarSur = new PImage[4];
PImage[] spriteCaminarEste = new PImage[4];
PImage[] spriteCaminarOeste = new PImage[4];
PImage[] spriteIdle = new PImage[4];
int totalFramesAnim = 4;
int totalFramesIdle = 4;
int frameAnimActual = 0;
int contadorFrameAnim = 0;
int velocidadAnim = 4;

// =====================================================
// EXPLORACION
// =====================================================
boolean leyendoMensaje = false;
boolean modoDebug = false;

int pisoActual = 2; // 2 = habitacion, 1 = primer piso
boolean animandoEscalera = false;
int faseEscalera = 0;  // 1 = entrando a la escalera, 2 = saliendo en el nuevo piso

float limIzq, limDer, limArr, limAba;
float escX, escY, escW, escH;
float[] obsX = new float[12];
float[] obsY = new float[12];
float[] obsW = new float[12];
float[] obsH = new float[12];
int totalObstaculos = 0;

// Hitbox solida ajustable de la escalera en el segundo piso (fracciones de width y height)
float escPiso2HitXFrac = 0.710f;
float escPiso2HitYFrac = 0.222f;
float escPiso2HitWFrac = 0.164f;
float escPiso2HitHFrac = 0.295f;

// =====================================================
// PADRES Y SISTEMA NARRATIVO DINAMICO
// =====================================================
float padresX = 0;
float padresY = 0;
float padresSep = 0;
boolean tieneCelular = false;
boolean samCercaDePadres = false;

int totalPaginasPadresInicial = 8;
int totalPaginasPadresFeedback = 4;
int paginaPadres = 0;
boolean feedbackPadresActivo = false;
boolean habloConPadresPostCelular = false;

String[] paginasPadres = {
  "¡Ay, mi niño, por fin bajaste! ¡Feliz cumpleaños, mi amor!",
  "Feliz cumple, campeón. Diez añitos... cualquier día me pasas de estatura.",
  "Jeje, gracias. Oigan, ¿y esas caras? ¿Qué esconden?",
  "Es que llevas meses pidiéndola. Y bueno... te la ganaste.",
  "Eso sí: pilas con quién hablas ahí, ¿oíste?",
  "(Mamá le entrega a Sam una caja con un celular. En el frente, en letras gigantes: SOMSOM 3297 ULTRA PRO MAX TURBO.)",
  "¡¿UN SOMSOM 3297?! ¡JAJAJA! ¡Gracias, má! ¡Gracias, pa! ¿Y ese nombre? Parece un transformador.",
  "Jajaja. Ve y pruébalo, mi cielo. Pero no te olvides del desayuno, ¿eh? Ya casi está."
};

String[] hablantesPadres = {
  "MAMÁ:", "PAPÁ:", "SAM:", "MAMÁ:",
  "PAPÁ:", "NARRADOR:", "SAM:", "MAMÁ:"
};

// Diálogos de respuesta según el bienestar y el tiempo
String[] paginasPadresBueno = {
  "¡Mi amor! Justo a tiempo. Los panqueques todavía están calientitos. ¡Ven, siéntate!",
  "Jajaja, ¿y qué tal ese aparato? ¿Ya lo prendiste o todavía estás leyendo la caja?",
  "¡Está brutal, pa! Ya vi algunas cosas, pero no me iba a perder los panqueques.",
  "Así me gusta. Come antes de que se enfríen. Después juegas con tu Somsom."
};

String[] hablantesPadresBueno = {
  "MAMÁ:", "PAPÁ:", "SAM:", "MAMÁ:"
};

String[] paginasPadresMalo = {
  "Sam, mi amor... llevo rato llamándote. Ya me estaba preocupando.",
  "¡Perdón, má! Estaba mirando unas cosas en el cel y se me pasó el tiempo.",
  "¡Jajaja! Primer día y ya lo perdimos. Imagínate en una semana.",
  "Ay, déjalo, hombre. Pero sí, mi cielo, guarda el cel un momentico y ven a desayunar. ¿Sí?"
};

String[] hablantesPadresMalo = {
  "MAMÁ:", "SAM:", "PAPÁ:", "MAMÁ:"
};

// =====================================================
// METRICAS DIGITALES DE SAM (BIENESTAR, REPUTACION, TIEMPO, PUNTOS ANIMADOS)
// =====================================================
float bienestarDigital = 100.0;    // 0 a 100 (salud mental y tranquilidad)
int reputacionDigital = 15;        // -50 a 100 (aceptación/clout social)
int horaReloj = 9;                 // Comienza 09:41 AM en Navidad
int minutoReloj = 41;
float acumuladorMinutos = 0;
int bateriaPct = 98;

boolean desayunoLlamado = false;
boolean desayunoTarde = false;

// Interpolaciones suaves para HUD, barras y contador de puntos
float bienestarVisualLerp = 100.0f;
float reputacionVisualLerp = 15.0f;
float puntosMostradosLerp = 0.0f;
int flashBienestarTimer = 0;
int colorFlashBienestar = color(80, 225, 120);
int flashReputacionTimer = 0;
int colorFlashReputacion = color(255, 215, 50);
int flashPuntosTimer = 0;
boolean mostrarResumenPuntos = false;

// Desglose de puntos por categoría para el resumen
int ptsCatExploracion = 0;
int ptsCatPenaltis = 0;
int ptsCatDecisiones = 0;
int ptsCatCocina = 0;
int ptsCatLogros = 0;
int rachaGolesPenaltis = 0;
int rachaDecisionesSanas = 0;

// Efecto de sacudida de pantalla (Screen Shake)
int shakeTimer = 0;
float shakeIntensidad = 0.0f;

// Pop-ups flotantes de puntos y métricas (Arreglos paralelos fijos - AyP 2)
final int MAX_POPUPS_FX = 24;
boolean[] popupFxActivo = new boolean[MAX_POPUPS_FX];
float[] popupFxX = new float[MAX_POPUPS_FX];
float[] popupFxY = new float[MAX_POPUPS_FX];
float[] popupFxVY = new float[MAX_POPUPS_FX];
float[] popupFxAlfa = new float[MAX_POPUPS_FX];
float[] popupFxEscala = new float[MAX_POPUPS_FX];
String[] popupFxTexto = new String[MAX_POPUPS_FX];
int[] popupFxColor = new int[MAX_POPUPS_FX];

// Partículas de celebración al ganar puntos (Arreglos paralelos fijos - AyP 2)
final int MAX_PARTICULAS_FX = 60;
boolean[] partFxActiva = new boolean[MAX_PARTICULAS_FX];
float[] partFxX = new float[MAX_PARTICULAS_FX];
float[] partFxY = new float[MAX_PARTICULAS_FX];
float[] partFxVX = new float[MAX_PARTICULAS_FX];
float[] partFxVY = new float[MAX_PARTICULAS_FX];
float[] partFxTam = new float[MAX_PARTICULAS_FX];
float[] partFxAlfa = new float[MAX_PARTICULAS_FX];
int[] partFxColor = new int[MAX_PARTICULAS_FX];

// Estado de reflexión/verificación en las 6 publicaciones comunitarias de Pixagram
boolean[] pixaReflexionDada = { false, false, false, false, false, false };

// Variables de decisiones narrativas y bloqueo por puntos
boolean decisionPixagramTomada = false;
int decisionPixagramPenaltis = 0; // 0 = pendiente, 1 = Disculpa pública / Humildad (40 pts), 2 = DM / Celebrar sano (15 pts), 3 = No hacer nada (0 pts)
boolean mostrandoDecisionPadres = false;
int decisionPadresDesayuno = 0;   // 0 = pendiente, 1 = Acuerdo familiar (30 pts), 2 = Alarma de límite (15 pts), 3 = Pasar rápido (0 pts)

// Variables de Transición Temporal y Novela Visual de Cocina con Amigo
int timerTransicionTemporal = 0;
final int DURACION_TRANSICION_TEMPORAL = 210;
int paginaCocina = 0;
int totalPaginasCocina = 12;
boolean mostrandoDecisionCocina = false;
int decisionCocinaTomada = 0; // 0 = pendiente, 1 = Canal de cocina sana (60 pts), 2 = Concentrarse en el estofado (0 pts)

// Notificaciones flotantes estilo Push
String notifPushTitulo = "";
String notifPushSub = "";
int notifPushFin = 0;
float notifPushY = -90;

// Partículas de corazones flotantes al dar like (arreglos simples - AyP 2)
final int MAX_CORAZONES = 25;
float[] corazonesX = new float[MAX_CORAZONES];
float[] corazonesY = new float[MAX_CORAZONES];
float[] corazonesAlfa = new float[MAX_CORAZONES];
boolean[] corazonesActivo = new boolean[MAX_CORAZONES];

// =====================================================
// CELULAR Y PANTALLA
// =====================================================
float telefonoX, telefonoY;
float telefonoAncho = 340;
float telefonoAlto = 640;
float pantallaX, pantallaY, pantallaW, pantallaH;

boolean enHome = true;
String appAbierta = "";
String[] nombresApps = {"Notas", "Ajustes", "Música", "Cámara", "Mensajes", "Galería", "Pixagram", "Parejas", "Pixel Art", "Frutas"};
int totalApps = 10;
int columnasApps = 3;
float tamApp = 54;
float espacioAppsX = 0;
float espacioAppsY = 9;
float inicioAppsY = 60;
int[] coloresApps = new int[10];

boolean modoOscuroConfig = true;
boolean notificacionesConfig = true;
int[] fondosHome = new int[3];
int totalFondosHome = 3;
int fondoActualIndex = 0;
String textoNota = "Escribe tus notas aquí...\n";

// =====================================================
// REPRODUCTOR DE MUSICA DEL CELULAR
// =====================================================
String[] listaCanciones = {
  "BoogieParty.mp3",
  "TeddyBearWaltz.mp3",
  "UnholyKnight.mp3",
  "MiamiNights.mp3",
  "Wholesome.mp3",
  "StreetParty.mp3",
  "doki.mp3",
  "Aoi.mp3",
  "Hello-juliet.mp3",
  "tengo-mucho-drip.mp3",
  "Perfecto-Miserable.mp3"
};
String[] nombresCanciones = {
  "Boogie Party",
  "Teddy Bear Waltz",
  "Unholy Knight",
  "Miami Nights",
  "Wholesome",
  "Street Party",
  "Doki",
  "Aoi Koi",
  "Hello Juliet",
  "Tengo drip",
  "Perfecto Miserable"
};
int totalCanciones = 11;
int cancionActualIndex = 0;
boolean reproduciendoMusica = false;
SoundFile reproductorMp3;

float musTarjetaY = 36;
float musTarjetaH = 86;
float musVisY, musVisH;
float musProgX = 22;
float musProgY, musProgW;
float musBotonW = 64;
float musBotonH = 38;
float musEspacioBtn = 15;
float musInicioBtnX, musBotonY;

// =====================================================
// MENSAJES (CHATS INTERACTIVOS)
// =====================================================
int MAX_CHATS = 5;
int totalChats = 3;
int chatAbierto = -1; // -1 = lista de chats, 0..4 = conversacion abierta si
String[] chatNombres = new String[MAX_CHATS];
String[] chatSubtitulos = new String[MAX_CHATS];
String[] chatHoras = new String[MAX_CHATS];
int[] chatColores = new int[MAX_CHATS];
boolean[] chatTieneNoLeido = new boolean[MAX_CHATS];
boolean[] chatRespondido = new boolean[MAX_CHATS];
String[][] chatMensajes = new String[MAX_CHATS][4];
String[] chatRespuestasSam = new String[MAX_CHATS];
boolean smsClaraDesbloqueado = false;
boolean smsMateoDesbloqueado = false;
boolean claraIntroducidaAlGrupo = false;

// Variables de Desayuno, Fin DÃ­a 1 y Cama
boolean desayunoComido = false;
int paginaDesayuno = 0;
final int TOTAL_PAGS_DESAYUNO = 6;
boolean samCercaDeMesa = false;
boolean samCercaDeCama = false;
boolean dialogoCamaActivo = false;
boolean juegosDesbloqueados = false;
int timerFinDia1 = 0;
final int DURACION_FIN_DIA_1 = 180;
boolean dia1Terminado = false;

void inicializarChatsDia1() {
  t3Reiniciar();
  reiniciarHistoriaDespuesCocina();
  totalChats = 2; // Antes del Nivel 1 solo aparecen Mamá y Michi (sin Clara ni grupo pq sam no conoce a nadie aun xd ok pana cffff)
  smsClaraDesbloqueado = false;
  smsMateoDesbloqueado = false;
  claraIntroducidaAlGrupo = false;

  // Chat 0: Mamá
  chatNombres[0] = "Mamá";
  chatSubtitulos[0] = "Familia";
  chatHoras[0] = "09:42";
  chatColores[0] = color(255, 100, 140);
  chatTieneNoLeido[0] = true;
  chatRespondido[0] = false;
  chatMensajes[0][0] = "O: ¡Hijo! Qué alegría que te haya gustado el celular.";
  chatMensajes[0][1] = "O: Tu papá y yo sabemos cuánto te esforzaste en el colegio este año.";
  chatMensajes[0][2] = "O: Acuérdate de no quedarte pegado a la pantalla. ¡El desayuno ya casi está listo!";
  chatMensajes[0][3] = "S: ¡Gracias mamá! Me encantó el regalo. Ya voy a la mesa en un ratico <3";
  chatRespuestasSam[0] = "¡Gracias mamá! Ya voy a la mesa <3";

  // Chat 1: Michi
  chatNombres[1] = "Michi";
  chatSubtitulos[1] = "Mascota consentida";
  chatHoras[1] = "Ayer";
  chatColores[1] = color(245, 160, 60);
  chatTieneNoLeido[1] = false;
  chatRespondido[1] = false;
  chatMensajes[1][0] = "O: Miau.";
  chatMensajes[1][1] = "O: Humano.";
  chatMensajes[1][2] = "O: Deja ese aparato brillante y ven a servirme mi comida favorita.";
  chatMensajes[1][3] = "S: Michi, ¿cómo estás escribiendo desde un teléfono? jajaja :3";
  chatRespuestasSam[1] = "¡Ya te sirvo las galletitas Michi! :3";

  // Contactos que se desbloquean tras los penaltis y post de Pixagram:
  // Chat 2: Clara
  chatNombres[2] = "Clara";
  chatSubtitulos[2] = "Amiga del salón";
  chatHoras[2] = "Ahora";
  chatColores[2] = color(170, 90, 220);
  chatTieneNoLeido[2] = false;
  chatRespondido[2] = false;
  chatMensajes[2][0] = "O: Ey Sam, te vi jugando con los pelaos en la cancha jaja";
  chatMensajes[2][1] = "O: Qué partidazo, todos estábamos pegados a los penaltis";
  chatMensajes[2][2] = "O: Oye, ¿me metes al grupo de los panas?";
  chatMensajes[2][3] = "S: De una, ya te agrego al grupo del salón :D";
  chatRespuestasSam[2] = "De una, ya te agrego al grupo del salón :D";

  // Chat 3: Séptimo B (Los panas)
  chatNombres[3] = "Sexto B (Los panas)";
  chatSubtitulos[3] = "Grupo del salón";
  chatHoras[3] = "08:30";
  chatColores[3] = color(80, 140, 240);
  chatTieneNoLeido[3] = false;
  chatRespondido[3] = false;
  chatMensajes[3][0] = "O: Leo: ¿Alguien copió lo que dejó el profe? Borró antes de que terminara.";
  chatMensajes[3][1] = "O: Lucas: Yo sí, pero no entiendo mi propia letra jajaja";
  chatMensajes[3][2] = "O: Leo: Manda foto, entre todos desciframos eso";
  chatMensajes[3][3] = "S: Yo alcancé a copiar. Ya les paso foto.";
  chatRespuestasSam[3] = "Yo alcancé a copiar. Ya les paso foto.";

  // Chat 4: Mateo y Cristian
  chatNombres[4] = "Mateo y Cristian";
  chatSubtitulos[4] = "Compañeros de cancha";
  chatHoras[4] = "Hace 5 min";
  chatColores[4] = color(80, 180, 140);
  chatTieneNoLeido[4] = false;
  chatRespondido[4] = false;
  chatMensajes[4][0] = "O: Mateo: Qué tanda de penaltis tan candela la de hoy";
  chatMensajes[4][1] = "O: Cristian: Ya vimos lo de Pixagram jaja";
  chatMensajes[4][2] = "O: Mateo: Buen juego, Sam. Hay que repetirlo pronto";
  chatMensajes[4][3] = "S: Gracias, estuvo bueno. Mañana revancha";
  chatRespuestasSam[4] = "Gracias, estuvo bueno. Mañana revancha";
}

void desbloquearSmsPostPenaltis() {
  if (!smsClaraDesbloqueado) {
    smsClaraDesbloqueado = true;
    smsMateoDesbloqueado = true;
    totalChats = 5;
    chatTieneNoLeido[2] = true; // Clara
    chatTieneNoLeido[4] = true; // Mateo y Cristian
    chatHoras[2] = "Ahora";
    chatHoras[4] = "Hace 2 min";
    crearPopupFlotante("Â¡Nuevo mensaje SMS de Clara!", width / 2, 120 * escalaY, color(200, 130, 255));
    if (sonidoClic != null) { sonidoClic.amp(0.4f * volMaster); sonidoClic.play(); }
  }
}

// =====================================================
// PIXAGRAM (RED SOCIAL COMPLETA CON VECTORES DE DIÁLOGOS)
// =====================================================
float pixHeaderH = 34;
float pixStoriesH = 66;
float pixPostHeaderY = 124;
float pixImgX = 8;
float pixImgY = 144;
float pixImgH = 138;
float pixAccionesY = 292;

int totalPixaPosts = 6;
int pixaPostActual = 0;
int pixaPestanaActual = 0; // 0 = Feed, 1 = Explorar, 2 = Perfil de Sam
PImage logoPixagram;
PImage[] pixaAvatares = new PImage[6];
PImage[] pixaFotosPosts = new PImage[6];

String[] pixaUsuarios = {
  "@clara_art",
  "@leo_speedrun",
  "@michi_pixel",
  "@sofia_books",
  "@mateo_vlogs",
  "@profe_ciencias"
};
String[] pixaNombres = {
  "Clara Sánchez",
  "Leo Gamer",
  "Michi el Gato",
  "Sofía Lectora",
  "Mateo Vlogs",
  "Prof. Martínez"
};
String[] pixaBios = {
  "Estudiante y dibujante | Dibujo digital y tradicional",
  "Gamer de 7°B | Subiendo de rango #Hype",
  "El rey de la casa | Experto en siestas",
  "Libros, té y tranquilidad | Menos pantalla, más vida",
  "Bromas pesadas y retos virales | #Reto100K",
  "Ciencias y Robótica | Ciudadanía digital responsable"
};
String[] pixaTiempos = {
  "Hace 12 min",
  "Hace 35 min",
  "Hace 1 h",
  "Hace 2 h",
  "Hace 3 h",
  "Hace 5 h"
};
String[] pixaDescripciones = {
  "¡Feliz Navidad a todos! Pasé toda la noche terminando esta pintura digital junto a la ventana. ¿Qué les parece la luz? #arte #navidad",
  "¡Llegó el #Reto100K! Si pasas más de 6 horas continuas en la app ganas 500 seguidores. ¿Te atreves o tienes miedo? #viral #gamer",
  "Mi humano me compró una cama cara pero prefiero dormir encima de su teclado. Zzz... #catlife #navidad",
  "La mejor parte de la Navidad no son las pantallas ni los likes, sino desconectar y disfrutar con la familia. #paz #lectura",
  "¡SE FILTRARON LAS RESPUESTAS DEL EXAMEN! Dale like y comenta 'PASAR' para mandarte el link por mensaje privado antes de que lo borren. #viral #colegio",
  "La luz azul nocturna de las pantallas suprime la melatonina y altera tu descanso. Cuiden sus horas de sueño en estas fiestas. #salud #ciencia"
};
String[] pixaCategorias = {
  "Arte Creativo",
  "Reto Viral",
  "Mascotas",
  "Bienestar Digital",
  "Desinformación",
  "Ciencia & Salud"
};
int[] pixaLikesCount = {48, 124, 89, 36, 210, 52};
boolean[] pixaLikeDado = {false, false, false, false, false, false};

// Comentarios de la comunidad estructurados para el nivel de redes sociales
String[][] pixaComentariosAutores = {
  {"@sam_adventures", "@michi_pixel", "@leo_speedrun"},
  {"@mateo_vlogs", "@sofia_books", "@clara_art"},
  {"@sam_adventures", "@clara_art", "@sofia_books"},
  {"@sam_adventures", "@profe_ciencias", "@leo_speedrun"},
  {"@sofia_books", "@profe_ciencias", "@leo_speedrun"},
  {"@sofia_books", "@sam_adventures", "@clara_art"}
};
String[][] pixaComentariosTextos = {
  {"¡Te quedó increíble Clara! Me encanta la paleta de colores.", "Miau aprueba esta obra de arte.", "¡Demasiada paciencia! Yo prefiero jugar xd"},
  {"¡Ya llevo 4 horas pegado al cel! Nadie me gana.", "Leo, eso suena súper dañino para los ojos y la salud...", "Leo, mejor ve a pasar tiempo con tu familia en Navidad."},
  {"Siempre durmiendo encima de las cosas jajaja.", "¡Qué ternura de michi! Dale un abrazo de mi parte.", "Ese gato vive mejor que todos nosotros juntos."},
  {"Tienes toda la razón Sofía, a veces hace falta desconectar.", "Excelente reflexión Sofía, equilibrio ante todo.", "Jajaja aburrido, pero feliz navidad pues."},
  {"Mateo, eso es completamente falso y peligroso.", "Mateo, hablaremos en rectoría el lunes sobre difundir mentiras.", "Jajaja no me creo nada pero igual comento por si acaso."},
  {"Muy importante profe, voy a activar el filtro de luz cálida.", "Uf, tengo que cuidar mis horas de sueño...", "¡Gracias profe por la información!"}
};

int[] pixaImpactoBienestar = {+4, -6, +5, +8, -8, +6};
int[] pixaImpactoReputacion = {+3, +8, +2, +3, -5, +4};

// =====================================================
// =====================================================
// DATOS DE PIXAGRAM Y MENSAJERÍA (VECTORES Y MATRICES - AYP 2)
// =====================================================
int COLOR_OUTSIDE_BG   = #1A191E;
int COLOR_APP_BG       = #ECEAE4;
int COLOR_CARD         = #F7F5EF;
int COLOR_PRIMARY      = #584D82;
int COLOR_PRIMARY_DARK = #352E52;
int COLOR_ACCENT       = #D96B52;
int COLOR_TEXT_DARK    = #262429;
int COLOR_TEXT_MUTED   = #85808E;
int COLOR_BORDER       = #DBD6CB;

int currentTab = 0; // 0: HOME, 1: FEED, 2: PUBLICAR, 3: MENSAJES

// Publicaciones del Feed (Arreglos paralelos)
final int MAX_FEED_POSTS = 5;
final int MAX_COMMENTS_POR_POST = 6;
int totalFeedPosts = 0;
int[] postIds = new int[MAX_FEED_POSTS];
String[] postAuthorName = new String[MAX_FEED_POSTS];
String[] postAuthorHandle = new String[MAX_FEED_POSTS];
String[] postAvatarPath = new String[MAX_FEED_POSTS];
PImage[] postAvatarImg = new PImage[MAX_FEED_POSTS];
String[] postTimeAgo = new String[MAX_FEED_POSTS];
String[] postCaption = new String[MAX_FEED_POSTS];
String[] postImagePath = new String[MAX_FEED_POSTS];
PImage[] postImg = new PImage[MAX_FEED_POSTS];
int[] postLikes = new int[MAX_FEED_POSTS];
boolean[] postIsLiked = new boolean[MAX_FEED_POSTS];
boolean[] postIsSaved = new boolean[MAX_FEED_POSTS];
String[] postCategoryTag = new String[MAX_FEED_POSTS];
int[] postCommentCount = new int[MAX_FEED_POSTS];
String[][] postCommentAuthor = new String[MAX_FEED_POSTS][MAX_COMMENTS_POR_POST];
String[][] postCommentText = new String[MAX_FEED_POSTS][MAX_COMMENTS_POR_POST];

// Conversaciones de Mensajes Privados (Arreglos paralelos y matrices - AyP 2)
final int TOTAL_CONVERSACIONES = 3;
final int MAX_MENSAJES_CONV = 10;
String[] convContactName = new String[TOTAL_CONVERSACIONES];
String[] convContactHandle = new String[TOTAL_CONVERSACIONES];
String[] convAvatarPath = new String[TOTAL_CONVERSACIONES];
PImage[] convAvatarImg = new PImage[TOTAL_CONVERSACIONES];
int[] convMessageCount = new int[TOTAL_CONVERSACIONES];
String[][] convMsgSender = new String[TOTAL_CONVERSACIONES][MAX_MENSAJES_CONV];
String[][] convMsgText = new String[TOTAL_CONVERSACIONES][MAX_MENSAJES_CONV];
String[][] convMsgTime = new String[TOTAL_CONVERSACIONES][MAX_MENSAJES_CONV];
int activeChatIndex = -1;

float scrollYFeed = 0;
float maxScrollYFeed = 0;

String newPostText = "";
int selectedCategoryIndex = 0;
String[] categoryOptions = {"Diario", "Deportes", "Colegio", "Notas"};
final int TOTAL_CATEGORY_OPTIONS = 4;
String[] imgOptionsPixa = {"post1.png", "post2.png", "post3.png", "post4.png"};
final int TOTAL_IMG_OPTIONS = 4;
String selectedImagePath = "post1.png";

String newChatMessage = "";

String playerName = "Sam";
String playerHandle = "@sam_adventures";
PImage playerAvatar;
final int TOTAL_MENSAJES_POR_CHAT = 4;

// =====================================================
// SETUP
// =====================================================
void setup() {
  fullScreen();
  pixelDensity(1);
  inicializarSistemaGuardadoYCielo();
  recCargarPreferencias();
  frameRate(60);
  cargarFuenteMenu();
  surface.setTitle("Sam Thinks a Lot");
  textAlign(CENTER, CENTER);
  smooth(2); // suavizado ligero (evita BICUBIC de software en JAVA2D para mantener 60 FPS)
}

void cargarFuenteMenu() {
  try {
    File fFredoka = dataFile("Fredoka-Bold.ttf");
    if (fFredoka.exists()) {
      fuenteComic = createFont("Fredoka-Bold.ttf", 44, true);
    } else {
      fuenteComic = createFont("Trebuchet MS Bold", 44, true);
    }
  } catch (Exception exF) {
    fuenteComic = createFont("Segoe UI Bold", 44, true);
  }
}

void cargarRecursosIniciales() {
  fondosHome[0] = color(40, 55, 80);
  fondosHome[1] = color(75, 45, 85);
  fondosHome[2] = color(35, 75, 55);

  coloresApps[0] = color(230, 210, 100);
  coloresApps[1] = color(100, 170, 230);
  coloresApps[2] = color(220, 100, 100);
  coloresApps[3] = color(130, 200, 100);
  coloresApps[4] = color(160, 100, 220);
  coloresApps[5] = color(240, 130, 180);
  coloresApps[6] = color(225, 48, 108);
  coloresApps[7] = color(59, 130, 246);
  coloresApps[8] = color(234, 88, 12);
  coloresApps[9] = color(244, 63, 94);
  inicializarChatsDia1();

  // Carga segura del marco de celular dibujado por el usuario (pre-escalado para evitar reescalado por frame en JAVA2D)
  int telAltoInit = max(1, round(min(840.0f, height * 0.90f)));
  int telAnchoInit = max(1, round(telAltoInit * (888.0f / 1600.0f)));
  try {
    marcoCelular = loadImage("marco_celular.png");
    if (marcoCelular != null && marcoCelular.width > 0) {
      marcoCelular.resize(telAnchoInit, telAltoInit);
    }
  } catch (Exception e) {
    marcoCelular = null;
  }

  // =====================================================
  // CARGA SEGURA DE IMÁGENES: MINIJUEGO MEMORIA (PAREJAS)
  // =====================================================
  // Reverso de la carta
  if (dataFile("atras_cartas.jpeg").exists()) {
    try { imgCartaReverso = loadImage("atras_cartas.jpeg"); } catch (Exception e) { imgCartaReverso = null; }
  } else { if (dataFile("reverso_cartas.jpeg").exists()) {
    try { imgCartaReverso = loadImage("reverso_cartas.jpeg"); } catch (Exception e) { imgCartaReverso = null; }
  } else {
    imgCartaReverso = null;
  } }

  // Frente vacío de la carta
  if (dataFile("frontal_cartas.jpeg").exists()) {
    try { imgCartaFrente = loadImage("frontal_cartas.jpeg"); } catch (Exception e) { imgCartaFrente = null; }
  } else { if (dataFile("frente_cartas.jpeg").exists()) {
    try { imgCartaFrente = loadImage("frente_cartas.jpeg"); } catch (Exception e) { imgCartaFrente = null; }
  } else {
    imgCartaFrente = null;
  } }

  // Fondo de cartas (si existe en data/)
  if (dataFile("fondo_cartas.jpeg").exists()) {
    try { imgFondoCartas = loadImage("fondo_cartas.jpeg"); } catch (Exception e) { imgFondoCartas = null; }
  } else { if (dataFile("fondo_cartas.png").exists()) {
    try { imgFondoCartas = loadImage("fondo_cartas.png"); } catch (Exception e) { imgFondoCartas = null; }
  } else { if (dataFile("fondo_parejas.png").exists()) {
    try { imgFondoCartas = loadImage("fondo_parejas.png"); } catch (Exception e) { imgFondoCartas = null; }
  } else {
    imgFondoCartas = null;
  } } }

  // Carga segura de las 15 figuras
  for (int i = 0; i < 15; i++) {
    imgFiguras[i] = null;
  }

  // 0: perrito / perros
  if (dataFile("perros_cartas.jpeg").exists()) {
    try { imgFiguras[0] = loadImage("perros_cartas.jpeg"); } catch (Exception e) { imgFiguras[0] = null; }
  } else { if (dataFile("perro_cartas.jpeg").exists()) {
    try { imgFiguras[0] = loadImage("perro_cartas.jpeg"); } catch (Exception e) { imgFiguras[0] = null; }
  } else { if (dataFile("perrito_cartas.jpeg").exists()) {
    try { imgFiguras[0] = loadImage("perrito_cartas.jpeg"); } catch (Exception e) { imgFiguras[0] = null; }
  } } }

  // 1: gato
  if (dataFile("gato_cartas.jpeg").exists()) {
    try { imgFiguras[1] = loadImage("gato_cartas.jpeg"); } catch (Exception e) { imgFiguras[1] = null; }
  } else { if (dataFile("gatos_cartas.jpeg").exists()) {
    try { imgFiguras[1] = loadImage("gatos_cartas.jpeg"); } catch (Exception e) { imgFiguras[1] = null; }
  } }

  // 2: pizza
  if (dataFile("pizza_cartas.jpeg").exists()) {
    try { imgFiguras[2] = loadImage("pizza_cartas.jpeg"); } catch (Exception e) { imgFiguras[2] = null; }
  }

  // 3: manzana
  if (dataFile("manzana_cartas.jpeg").exists()) {
    try { imgFiguras[3] = loadImage("manzana_cartas.jpeg"); } catch (Exception e) { imgFiguras[3] = null; }
  }

  // 4: estrella
  if (dataFile("estrella_cartas.jpeg").exists()) {
    try { imgFiguras[4] = loadImage("estrella_cartas.jpeg"); } catch (Exception e) { imgFiguras[4] = null; }
  }

  // 5 a 14: Figuras que se cargan si existen; si no existen quedan en null sin error (png, jpg, jpeg)
  for (int i = 5; i < 15; i++) {
    String nom = nombresFiguras[i];
    if (dataFile(nom + "_cartas.png").exists()) {
      try { imgFiguras[i] = loadImage(nom + "_cartas.png"); } catch (Exception e) { imgFiguras[i] = null; }
    } else { if (dataFile(nom + "_cartas.jpg").exists()) {
      try { imgFiguras[i] = loadImage(nom + "_cartas.jpg"); } catch (Exception e) { imgFiguras[i] = null; }
    } else { if (dataFile(nom + "_cartas.jpeg").exists()) {
      try { imgFiguras[i] = loadImage(nom + "_cartas.jpeg"); } catch (Exception e) { imgFiguras[i] = null; }
    } else { if (dataFile(nom + ".png").exists()) {
      try { imgFiguras[i] = loadImage(nom + ".png"); } catch (Exception e) { imgFiguras[i] = null; }
    } else { if (dataFile(nom + ".jpg").exists()) {
      try { imgFiguras[i] = loadImage(nom + ".jpg"); } catch (Exception e) { imgFiguras[i] = null; }
    } else { if (dataFile(nom + ".jpeg").exists()) {
      try { imgFiguras[i] = loadImage(nom + ".jpeg"); } catch (Exception e) { imgFiguras[i] = null; }
    } else {
      imgFiguras[i] = null;
    } } } } } }
  }

  // =====================================================
  // LIMPIEZA DE PÍXELES Y FONDOS NEGROS (MINIJUEGO CARTAS)
  // =====================================================
  // 1. Limpiar márgenes negros y esquinas en cartas
  if (imgCartaReverso != null) {
    imgCartaReverso = limpiarCarta(imgCartaReverso);
    if (imgCartaReverso != null && imgCartaReverso.height > 540) {
      int nuevoAlto = 540;
      int nuevoAncho = max(1, round(nuevoAlto * ((float)imgCartaReverso.width / (float)imgCartaReverso.height)));
      imgCartaReverso.resize(nuevoAncho, nuevoAlto);
    }
  }

  if (imgCartaFrente != null) {
    imgCartaFrente = limpiarCarta(imgCartaFrente);
    if (imgCartaFrente != null && imgCartaFrente.height > 540) {
      int nuevoAlto = 540;
      int nuevoAncho = max(1, round(nuevoAlto * ((float)imgCartaFrente.width / (float)imgCartaFrente.height)));
      imgCartaFrente.resize(nuevoAncho, nuevoAlto);
    }
  }

  // 2. Limpiar fondo negro exterior con Flood Fill y suavizar iconos
  for (int i = 0; i < 15; i++) {
    if (imgFiguras[i] != null) {
      imgFiguras[i] = quitarFondoNegro(imgFiguras[i]);
      if (imgFiguras[i] != null && imgFiguras[i].width > 320) {
        imgFiguras[i].resize(320, 320);
      }
    }
  }

  // Imagenes de Pixagram (pre-escaladas en carga para rendimiento fluido)
  try {
    logoPixagram = loadImage("logo_pixagram.png");
    if (logoPixagram != null && logoPixagram.width > 0) {
      int tamLogoPx = max(1, round(tamApp));
      logoPixagram.resize(tamLogoPx, tamLogoPx);
    }
  } catch (Exception e) {
    logoPixagram = null;
  }

  String[] archivosAvatar = {"avatar_clara.png", "avatar_leo.png", "avatar_michi.png", "avatar_sofia.png", "avatar_mateo.png", "avatar_profe.png"};
  for (int i = 0; i < 6; i++) {
    try {
      pixaAvatares[i] = loadImage(archivosAvatar[i]);
      if (pixaAvatares[i] == null) { pixaAvatares[i] = loadImage("pixa_avatar_" + i + ".png"); }
      if (pixaAvatares[i] != null && pixaAvatares[i].width > 64) {
        pixaAvatares[i].resize(64, 64);
      }
    } catch (Exception e) {
      pixaAvatares[i] = null;
    }
  }

  // Seis publicaciones: cargar los PNG de la carpeta data por su nombre.
  cargarFotosComunidadPixagram();

  // Inicializar datos de Pixagram: sin publicaciones genéricas previas;
  // únicamente Mateo y Cristian subirán la publicación según se gane o pierda el Nivel 1 (Penaltis)
  try {
    playerAvatar = loadImage("sam_cancha.jpg");
    if (playerAvatar != null && playerAvatar.width > 80) {
      playerAvatar.resize(80, 80);
    }
  } catch (Exception e) {
    playerAvatar = null;
  }
  totalFeedPosts = 0;

  // Conversación 0: Leo
  convContactName[0] = "Leo";
  convContactHandle[0] = "@leo_goals";
  convAvatarPath[0] = "avatar_leo.png";
  try {
    convAvatarImg[0] = loadImage("avatar_leo.png");
    if (convAvatarImg[0] != null && convAvatarImg[0].width > 64) convAvatarImg[0].resize(64, 64);
  } catch (Exception e) { convAvatarImg[0] = null; }
  convMsgSender[0][0] = "Leo";
  convMsgText[0][0] = "¡Hola Sam! ¿Listo para los penaltis en el colegio?";
  convMsgTime[0][0] = "14:20";
  convMsgSender[0][1] = "Sam";
  convMsgText[0][1] = "¡Claro que sí! Allá nos vemos.";
  convMsgTime[0][1] = "14:22";
  convMessageCount[0] = 2;

  // Conversación 1: Clara
  convContactName[1] = "Clara";
  convContactHandle[1] = "@clara_art";
  convAvatarPath[1] = "avatar_clara.png";
  try {
    convAvatarImg[1] = loadImage("avatar_clara.png");
    if (convAvatarImg[1] != null && convAvatarImg[1].width > 64) convAvatarImg[1].resize(64, 64);
  } catch (Exception e) { convAvatarImg[1] = null; }
  convMsgSender[1][0] = "Clara";
  convMsgText[1][0] = "¡Hola Sam! Qué emoción verte mañana en clase.";
  convMsgTime[1][0] = "11:05";
  convMsgSender[1][1] = "Sam";
  convMsgText[1][1] = "¡Igualmente Clara! Nos vemos temprano.";
  convMsgTime[1][1] = "11:10";
  convMessageCount[1] = 2;

  // Conversación 2: Mateo y Cristian
  convContactName[2] = "Mateo y Cristian";
  convContactHandle[2] = "@mateo_y_cristian";
  convAvatarPath[2] = "mateo_cancha.jpg";
  try {
    convAvatarImg[2] = loadImage("mateo_cancha.jpg");
    if (convAvatarImg[2] != null && convAvatarImg[2].width > 64) convAvatarImg[2].resize(64, 64);
  } catch (Exception e) { convAvatarImg[2] = null; }
  convMsgSender[2][0] = "Mateo";
  convMsgText[2][0] = "Mañana veremos si nos haces gol en la cancha.";
  convMsgTime[2][0] = "19:30";
  convMessageCount[2] = 1;

  escalaX = width / REF_W;
  escalaY = height / REF_H;

  // Dimensiones del arco en 1536x864 adaptadas a la pantalla
  arcoAncho = 700 * escalaX;
  arcoAlto = 270 * escalaY;
  arcoX = width / 2 - arcoAncho / 2;
  arcoY = 210 * escalaY;

  puntoPenaltiX = width / 2;
  puntoPenaltiY = height - 135 * escalaY;

  pateadorBaseX = puntoPenaltiX - 95 * escalaX;
  pateadorBaseY = puntoPenaltiY - 30 * escalaY;
  pateadorX = pateadorBaseX;
  pateadorY = pateadorBaseY;

  arqueroAncho = 76 * escalaX;
  arqueroAlto = 175 * escalaY;
  arqueroX = width / 2;
  arqueroY = arcoY + arcoAlto - (arqueroAlto / 2);
  balonTamanoInicial = 54 * escalaY;
  balonTamanoFinal = 26 * escalaY;
  balonTamanoActual = balonTamanoInicial;
  balonX = puntoPenaltiX;
  balonY = puntoPenaltiY;
}

// =====================================================
// DRAW
// =====================================================
void draw() {
  escalaX = width / REF_W;
  escalaY = height / REF_H;
  if (fotogramaSalida == null && !enTransicion) {
    feriaActualizarPantalla();
    if (!hcActiva && hcPuedeContinuar()) hcIniciar();
  }
  int escena = escenaVisualActual();
  prepararTransicionVisual(escena);
  if (fotogramaSalida == null) {
    dibujarEscenaJuego();
    escenaDibujada = escena;
    if (escena == escenaVisualActual()) {
      if (mostrarReaccionClip()) dibujarReaccionClip();
      else dibujarGuiaDeJuego();
    }
  }
  dibujarTransicionGlobal();
}

void dibujarEscenaJuego() {
  if (!feriaDibujar()) {

    boolean flujoRetornoActivo = true;

    if (dibujarHistoria3()) {
      flujoRetornoActivo = false;
    }
    if (flujoRetornoActivo) {

      if (dibujarHistoriaDespuesCocina()) {
        flujoRetornoActivo = false;
      }
      if (flujoRetornoActivo) {

        // nos aseguramos de que la fuente principal este activa para que no se dañen los simbolos xd
        if (fuenteComic != null) {
          textFont(fuenteComic);
        }

        // Interpolaciones suaves de barras y contador de puntos (Juice & UX)
        bienestarVisualLerp = lerp(bienestarVisualLerp, bienestarDigital, 0.12f);
        reputacionVisualLerp = lerp(reputacionVisualLerp, reputacionDigital, 0.12f);
        if (abs(puntosMostradosLerp - puntosJugador) < 0.35f) {
          puntosMostradosLerp = puntosJugador;
        } else {
          puntosMostradosLerp = lerp(puntosMostradosLerp, puntosJugador, 0.16f);
        }

        boolean shakeAplicado = false;
        if (shakeTimer > 0) {
          shakeTimer--;
          pushMatrix();
          translate(round(random(-shakeIntensidad, shakeIntensidad) * escalaX), round(random(-shakeIntensidad, shakeIntensidad) * escalaY));
          shakeAplicado = true;
        }

        // control centralizado para que musica_fondo solo suene en menu, novelas visuales y exploracion xd
        actualizarMusicaFondoPorEstado();

        // -----------------------------------------------------
        // CARGA: un lote de recursos por fotograma.
        // -----------------------------------------------------
        if (estadoActual == CARGA) {
          dibujarPantallaCarga();
          if (pasoCarga == -2) {
            // El primer fotograma se presenta antes de leer assets del disco.
            pasoCarga++;
            return;
          }
          if (pasoCarga == -1) {
            cargarRecursosIniciales();
            pasoCarga++;
            return;
          }
          if (pasoCarga >= totalPasosCarga) {
            if (cargaCompletaDesde < 0) cargaCompletaDesde = millis();
            if (millis() - cargaCompletaDesde >= CARGA_ESPERA_COMPLETA_MS && !enTransicion) {
              estadoDestino = MENU;
              enTransicion = true;
            }
            return;
          }

          try {
            if (pasoCarga == 0) {
              try {
                fuenteCelular = createFont("Segoe UI Semibold", 32, true);
                fontTitle = createFont("Segoe UI Bold", 32, true);
                fontBold = createFont("Segoe UI Bold", 28, true);
                fontBody = createFont("Segoe UI", 28, true);
              } catch (Exception e) {
                fuenteCelular = fuenteComic;
                fontTitle = fuenteComic;
                fontBold = fuenteComic;
                fontBody = fuenteComic;
              }
              textFont(fuenteComic);
              inicializarSistemaGuardadoYCielo();
            }
            if (pasoCarga == 1) {
              videoFondo = new Movie(this, "menu_juego.mp4");
              videoFondo.volume(0);
            } else {
              if (pasoCarga == 2) {
                fondoHabitacion = loadImage("habitacion.png");
                if (fondoHabitacion != null && fondoHabitacion.width > 0) {
                  fondoHabitacion.resize(width, height);
                }
                fondoPrimerPiso = loadImage("pp_sam.jpeg");
                if (fondoPrimerPiso != null && fondoPrimerPiso.width > 0) {
                  fondoPrimerPiso.resize(width, height);
                }
                indicativoDireccion = loadImage("dirección.png");
                indicativoGuardar = loadImage("guardar.png");
                indicativoPendiente = loadImage("pendiente.png");
                int tamIndicativo = max(1, round(130 * escalaX));
                if (indicativoDireccion != null && indicativoDireccion.width > 0)
                  indicativoDireccion.resize(tamIndicativo, tamIndicativo);
                if (indicativoGuardar != null && indicativoGuardar.width > 0)
                  indicativoGuardar.resize(tamIndicativo, tamIndicativo);
                if (indicativoPendiente != null && indicativoPendiente.width > 0)
                  indicativoPendiente.resize(tamIndicativo, tamIndicativo);
              } else {
                if (pasoCarga == 3) {
                  videoCreditos = new Movie(this, "video_creditos.mp4");
                } else {
                  if (pasoCarga == 4) {
                    try {
                      musicaFondo = new SoundFile(this, "musica_fondo.mp3");
                    } catch (Exception exMf) {
                      musicaFondo = null;
                    }
                    try {
                      if (reproductorMp3 == null) {
                        reproductorMp3 = new SoundFile(this, listaCanciones[cancionActualIndex]);
                      }
                    } catch (Exception exMp3) {
                      reproductorMp3 = null;
                    }
                  } else {
                    if (pasoCarga == 5) {
                      try {
                        sonidoHover = new SoundFile(this, "hover.wav");
                      } catch (Exception exHov) {
                        sonidoHover = null;
                      }
                    } else {
                      if (pasoCarga == 6) {
                        cargarEfectosSonido();
                        try {
                          sonidoClic = new SoundFile(this, "clic.wav");
                        } catch (Exception exClic) {
                          sonidoClic = null;
                        }
                        for (int i = 0; i < 9; i++) {
                          try {
                            paMusicaNiveles[i] = new SoundFile(this, paArchivosMusica[i]);
                          } catch (Exception e) {
                          }
                        }
                        try {
                          sfxFrutaFusion = new SoundFile(this, "Fruta_Fusion.mp3");
                          sfxFrutaCaida = new SoundFile(this, "Caida_Fruta.mp3");
                        } catch (Exception e) {
                        }
                        try {
                          if (nv2Audio == null) {
                            nv2Audio = new SoundFile(this, nv2ArchivoAudio);
                          }
                        } catch (Exception exNv2) {
                          nv2Audio = null;
                        }
                      } else {
                        if (pasoCarga == 7) {
                          logoMenu = loadImage("logo_menus.png");
                          if (logoMenu != null && logoMenu.width > 0) {
                            int lw = max(1, PApplet.parseInt(REF_W * 0.40f * escalaX));
                            int lh = max(1, PApplet.parseInt(lw * ((float) logoMenu.height / (float) logoMenu.width)));
                            logoMenu.resize(lw, lh);
                          }
                        } else {
                          if (pasoCarga == 8) {
                            fondoEscena = loadImage("escena_1.png");
                            if (fondoEscena != null && fondoEscena.width > 0) {
                              fondoEscena.resize(width, height);
                            }
                            for (int e = 0; e < 5; e++) {
                              try {
                                escenasNovela[e] = loadImage(nombresArchivosEscenas[e]);
                                if (escenasNovela[e] != null && escenasNovela[e].width > 0) {
                                  escenasNovela[e].resize(width, height);
                                }
                              } catch (Exception ex) {
                                escenasNovela[e] = null;
                              }
                            }
                            if (escenasNovela[0] == null || escenasNovela[0].width <= 0) {
                              escenasNovela[0] = fondoEscena;
                            }
                            if (escenasNovela[1] == null || escenasNovela[1].width <= 0) {
                              escenasNovela[1] = escenasNovela[0];
                            }
                          } else {
                            if (pasoCarga == 9) {
                              if (marcoCelular == null) {
                                try {
                                  marcoCelular = loadImage("marco_celular.png");
                                  if (marcoCelular != null && marcoCelular.width > 0) {
                                    int telAltoInit = max(1, round(min(840.0f, height * 0.90f)));
                                    int telAnchoInit = max(1, round(telAltoInit * (888.0f / 1600.0f)));
                                    marcoCelular.resize(telAnchoInit, telAltoInit);
                                  }
                                } catch (Exception e) {
                                }
                              }
                            } else {
                              if (pasoCarga == 10) {
                                PImage imgLogoComun = loadImage("logo.png");
                                if (imgLogoComun != null && imgLogoComun.width > 120) {
                                  imgLogoComun.resize(120, 120);
                                }
                                for (int i = 0; i < totalLogros; i++) {
                                  String nombreImg = logros[i][4];
                                  if (nombreImg != null && !nombreImg.equals("") && !nombreImg.equals("logo")
                                      && dataFile(nombreImg + ".png").exists()) {
                                    try {
                                      logroImagenes[i] = loadImage(nombreImg + ".png");
                                      if (logroImagenes[i] != null && logroImagenes[i].width > 120)
                                        logroImagenes[i].resize(120, 120);
                                    } catch (Exception exLogro) {
                                      logroImagenes[i] = imgLogoComun;
                                    }
                                  } else {
                                    logroImagenes[i] = imgLogoComun;
                                  }
                                }
                              } else {
                                if (pasoCarga == 11) {
                                  int spW = max(1, round(pjW));
                                  int spH = max(1, round(pjH));
                                  for (int i = 0; i < totalFramesAnim; i++) {
                                    String numFrame = str(i + 1);
                                    spriteCaminarNorte[i] = loadImage("Sam_Sprites/caminar_norte_" + numFrame + ".png");
                                    if (spriteCaminarNorte[i] != null && spriteCaminarNorte[i].width > 0)
                                      spriteCaminarNorte[i].resize(spW, spH);
                                    spriteCaminarSur[i] = loadImage("Sam_Sprites/caminar_sur_" + numFrame + ".png");
                                    if (spriteCaminarSur[i] != null && spriteCaminarSur[i].width > 0)
                                      spriteCaminarSur[i].resize(spW, spH);
                                    spriteCaminarEste[i] = loadImage("Sam_Sprites/caminar_este_" + numFrame + ".png");
                                    if (spriteCaminarEste[i] != null && spriteCaminarEste[i].width > 0)
                                      spriteCaminarEste[i].resize(spW, spH);
                                    spriteCaminarOeste[i] = loadImage("Sam_Sprites/caminar_oeste_" + numFrame + ".png");
                                    if (spriteCaminarOeste[i] != null && spriteCaminarOeste[i].width > 0)
                                      spriteCaminarOeste[i].resize(spW, spH);
                                  }
                                  for (int i = 0; i < totalFramesIdle; i++) {
                                    spriteIdle[i] = loadImage("Sam_Sprites/idle_" + str(i + 1) + ".png");
                                    if (spriteIdle[i] != null && spriteIdle[i].width > 0)
                                      spriteIdle[i].resize(spW, spH);
                                  }
                                } else {
                                  if (pasoCarga == 12) {
                                    // Cargar las imágenes desde la carpeta /data y pre-escalarlas manteniendo su proporción exacta
                                    File fFondo = dataFile("bg_penaltis.png");
                                    if (fFondo.exists()) {
                                      imgFondoCancha = loadImage("bg_penaltis.png");
                                      if (imgFondoCancha != null && imgFondoCancha.width > 0)
                                        imgFondoCancha.resize(width, height);
                                    }
                                    File fSamQ = dataFile("sam_quieto.png");
                                    if (fSamQ.exists()) {
                                      imgSamQuieto = loadImage("sam_quieto.png");
                                      if (imgSamQuieto != null && imgSamQuieto.height > 0) {
                                        int targetH = max(1, round(232.0f * escalaY));
                                        imgSamQuieto.resize(max(1, round(imgSamQuieto.width * ((float) targetH / imgSamQuieto.height))), targetH);
                                      }
                                    }
                                    File fSamP = dataFile("sam_patada.png");
                                    if (fSamP.exists()) {
                                      imgSamPatada = loadImage("sam_patada.png");
                                      if (imgSamPatada != null && imgSamPatada.height > 0) {
                                        int targetH = max(1, round(232.0f * escalaY));
                                        imgSamPatada.resize(max(1, round(imgSamPatada.width * ((float) targetH / imgSamPatada.height))), targetH);
                                      }
                                    }
                                    File fMatQ = dataFile("mateo_quieto.png");
                                    if (fMatQ.exists()) {
                                      imgMateoQuieto = loadImage("mateo_quieto.png");
                                      if (imgMateoQuieto != null && imgMateoQuieto.height > 0) {
                                        int targetH = max(1, round(178.0f * escalaY));
                                        imgMateoQuieto.resize(max(1, round(imgMateoQuieto.width * ((float) targetH / imgMateoQuieto.height))),
                                            targetH);
                                      }
                                    }
                                    File fMatI = dataFile("mateo_izq.png");
                                    if (fMatI.exists()) {
                                      imgMateoIzq = loadImage("mateo_izq.png");
                                      if (imgMateoIzq != null && imgMateoIzq.height > 0) {
                                        int targetH = max(1, round(158.0f * escalaY));
                                        imgMateoIzq.resize(max(1, round(imgMateoIzq.width * ((float) targetH / imgMateoIzq.height))), targetH);
                                      }
                                    }
                                    File fMatD = dataFile("mateo_der.png");
                                    if (fMatD.exists()) {
                                      imgMateoDer = loadImage("mateo_der.png");
                                      if (imgMateoDer != null && imgMateoDer.height > 0) {
                                        int targetH = max(1, round(158.0f * escalaY));
                                        imgMateoDer.resize(max(1, round(imgMateoDer.width * ((float) targetH / imgMateoDer.height))), targetH);
                                      }
                                    }
                                    File fCriQ = dataFile("cristian_quieto.png");
                                    if (fCriQ.exists()) {
                                      imgCristianQuieto = loadImage("cristian_quieto.png");
                                      if (imgCristianQuieto != null && imgCristianQuieto.height > 0) {
                                        int targetH = max(1, round(178.0f * escalaY));
                                        imgCristianQuieto
                                            .resize(max(1, round(imgCristianQuieto.width * ((float) targetH / imgCristianQuieto.height))), targetH);
                                      }
                                    }
                                    File fCriI = dataFile("cristian_izq.png");
                                    if (fCriI.exists()) {
                                      imgCristianIzq = loadImage("cristian_izq.png");
                                      if (imgCristianIzq != null && imgCristianIzq.height > 0) {
                                        int targetH = max(1, round(158.0f * escalaY));
                                        imgCristianIzq.resize(max(1, round(imgCristianIzq.width * ((float) targetH / imgCristianIzq.height))),
                                            targetH);
                                      }
                                    }
                                    File fCriD = dataFile("cristian_der.png");
                                    if (fCriD.exists()) {
                                      imgCristianDer = loadImage("cristian_der.png");
                                      if (imgCristianDer != null && imgCristianDer.height > 0) {
                                        int targetH = max(1, round(158.0f * escalaY));
                                        imgCristianDer.resize(max(1, round(imgCristianDer.width * ((float) targetH / imgCristianDer.height))),
                                            targetH);
                                      }
                                    }
                                    File fBal = dataFile("balon.png");
                                    if (fBal.exists()) {
                                      imgBalon = loadImage("balon.png");
                                      if (imgBalon != null && imgBalon.height > 0) {
                                        int targetH = max(1, round(54.0f * escalaY));
                                        imgBalon.resize(targetH, targetH);
                                      }
                                    }
                                  }
                                  if (pasoCarga == 13) {
                                    File fSamC = dataFile("sam_cancha.jpg");
                                    if (fSamC.exists()) {
                                      imgSamCancha = loadImage("sam_cancha.jpg");
                                      if (imgSamCancha != null && imgSamCancha.height > 0) {
                                        int targetH = max(1, round(74.0f * escalaY));
                                        imgSamCancha.resize(max(1, round(imgSamCancha.width * ((float) targetH / imgSamCancha.height))), targetH);
                                      }
                                    }
                                    File fMatC = dataFile("mateo_cancha.jpg");
                                    if (fMatC.exists()) {
                                      imgMateoCancha = loadImage("mateo_cancha.jpg");
                                      if (imgMateoCancha != null && imgMateoCancha.height > 0) {
                                        int targetH = max(1, round(74.0f * escalaY));
                                        imgMateoCancha.resize(max(1, round(imgMateoCancha.width * ((float) targetH / imgMateoCancha.height))),
                                            targetH);
                                      }
                                    }
                                    File fCriC = dataFile("cristian_cancha.jpg");
                                    if (fCriC.exists()) {
                                      imgCristianCancha = loadImage("cristian_cancha.jpg");
                                      if (imgCristianCancha != null && imgCristianCancha.height > 0) {
                                        int targetH = max(1, round(74.0f * escalaY));
                                        imgCristianCancha
                                            .resize(max(1, round(imgCristianCancha.width * ((float) targetH / imgCristianCancha.height))), targetH);
                                      }
                                    }

                                    File fPostG = dataFile("post_penaltis_gana.png");
                                    if (fPostG.exists()) {
                                      imgPostGana = loadImage("post_penaltis_gana.png");
                                      if (imgPostGana != null && imgPostGana.width > 360)
                                        imgPostGana.resize(360, 360);
                                    }
                                    File fPostP = dataFile("post_penaltis_pierde.png");
                                    if (fPostP.exists()) {
                                      imgPostPierde = loadImage("post_penaltis_pierde.png");
                                      if (imgPostPierde != null && imgPostPierde.width > 360)
                                        imgPostPierde.resize(360, 360);
                                    }

                                    File fMama = dataFile("mama (1).png");
                                    if (fMama.exists()) {
                                      imgMama = loadImage("mama (1).png");
                                      if (imgMama != null && imgMama.width > 0) {
                                        imgMama.resize(max(1, round(220 * escalaX)), max(1, round(320 * escalaY)));
                                      }
                                    }
                                    File fPapa = dataFile("papa.png.png");
                                    if (fPapa.exists()) {
                                      imgPapa = loadImage("papa.png.png");
                                      if (imgPapa != null && imgPapa.width > 0) {
                                        imgPapa.resize(max(1, round(220 * escalaX)), max(1, round(320 * escalaY)));
                                      }
                                    }
                                    File fDes = dataFile("escena_desayuno.png");
                                    if (fDes.exists()) {
                                      imgEscenaDesayuno = loadImage("escena_desayuno.png");
                                      if (imgEscenaDesayuno != null && imgEscenaDesayuno.width > 0) {
                                        imgEscenaDesayuno.resize(width, height);
                                      }
                                    }
                                  }
                                  if (pasoCarga == 14) {
                                    if (dataFile("bg_cocina.png").exists()) {
                                      imgFondoCocina = loadImage("bg_cocina.png");
                                    } else {
                                      if (dataFile("fondo_cocina_ritmo.png").exists()) {
                                        imgFondoCocina = loadImage("fondo_cocina_ritmo.png");
                                      } else {
                                        if (dataFile("fondo_nivel2.png").exists()) {
                                          imgFondoCocina = loadImage("fondo_nivel2.png");
                                        }
                                      }
                                    }
                                    if (imgFondoCocina != null && imgFondoCocina.width > 0) {
                                      imgFondoCocina.resize(width, height);
                                    }
                                    if (imgFondoCocina == null || imgFondoCocina.width <= 0) {
                                      if (imgEscenaDesayuno != null && imgEscenaDesayuno.width > 0) {
                                        imgFondoCocina = imgEscenaDesayuno;
                                      } else {
                                        if (escenasNovela[2] != null && escenasNovela[2].width > 0) {
                                          imgFondoCocina = escenasNovela[2];
                                        } else {
                                          imgFondoCocina = fondoEscena;
                                        }
                                      }
                                    }
                                    // Nuevas ilustraciones preparadas para la escena de cocina, notas y resultados (con fallback seguro si aún no están en /data)
                                    try {
                                      File fSamCF = dataFile("sam_chef_feliz.png");
                                      if (fSamCF.exists())
                                        imgSamChefFeliz = loadImage("sam_chef_feliz.png");
                                      File fSamCP = dataFile("sam_chef_pensativo.png");
                                      if (fSamCP.exists())
                                        imgSamChefPensativo = loadImage("sam_chef_pensativo.png");
                                      File fMatCA = dataFile("mateo_casual_apena.png");
                                      if (fMatCA.exists())
                                        imgMateoCasualApena = loadImage("mateo_casual_apena.png");
                                      File fMatCE = dataFile("mateo_chef_entusiasmado.png");
                                      if (fMatCE.exists())
                                        imgMateoChefEntusiasmado = loadImage("mateo_chef_entusiasmado.png");
                                      File fPlatoM = dataFile("plato_estofado_michelin.png");
                                      if (fPlatoM.exists())
                                        imgPlatoMichelin = loadImage("plato_estofado_michelin.png");
                                      File fPlatoQ = dataFile("plato_estofado_quemado.png");
                                      if (fPlatoQ.exists())
                                        imgPlatoQuemado = loadImage("plato_estofado_quemado.png");
                                      File fNotaNv2 = dataFile("nota_nv2.png");
                                      if (fNotaNv2.exists())
                                        imgNotaNv2 = loadImage("nota_nv2.png");
                                      File fRecNv2 = dataFile("receptor_nv2.png");
                                      if (fRecNv2.exists())
                                        imgReceptorNv2 = loadImage("receptor_nv2.png");
                                      else {
                                        if (dataFile("circulo_ritmo.png").exists())
                                          imgReceptorNv2 = loadImage("circulo_ritmo.png");
                                        else {
                                          if (dataFile("receptor.png").exists())
                                            imgReceptorNv2 = loadImage("receptor.png");
                                        }
                                      }

                                    } catch (Exception exArte) {
                                    }
                                  }
                                  if (pasoCarga == 15) {
                                    try {
                                      // Cargar ilustraciones de dificultad Nivel 2 (IbisPaint)
                                      String[] nomDifArch = {"intermedio", "dificil", "extremo", "injugable"};
                                      for (int d = 0; d < 4; d++) {
                                        String nd = nomDifArch[d];
                                        if (dataFile("dificultad_" + nd + ".png").exists())
                                          imgDificultadNv2[d] = loadImage("dificultad_" + nd + ".png");
                                        else {
                                          if (dataFile("dif_" + nd + ".png").exists())
                                            imgDificultadNv2[d] = loadImage("dif_" + nd + ".png");
                                          else {
                                            if (dataFile(nd + ".png").exists())
                                              imgDificultadNv2[d] = loadImage(nd + ".png");
                                            else {
                                              if (dataFile("dificultad_" + nd + ".jpg").exists())
                                                imgDificultadNv2[d] = loadImage("dificultad_" + nd + ".jpg");
                                              else {
                                                if (dataFile("dif_" + nd + ".jpg").exists())
                                                  imgDificultadNv2[d] = loadImage("dif_" + nd + ".jpg");
                                              }
                                            }
                                          }
                                        }
                                      }
                                    } catch (Exception exArte) {
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          } catch (Exception e) {
            println("Error en la carga: " + e.getMessage());
          }
          pasoCarga++;
        }

        // -----------------------------------------------------
        // MENU PRINCIPAL Y TRANSICION ESTILO STARDEW VALLEY AL CIELO
        // -----------------------------------------------------
        if (estadoActual == MENU) {
          // dibujamos el video con la interpolacion suave hacia las nubes de arriba a la derecha xd
          dibujarVideoFondoConCamaraCielo();

          if (volMaster <= 0.05f) {
            volMaster = 1.0f;
            nivelVolumen = 10;
          }

          // calculamos cuanto se deslizan hacia abajo el logo y los botones cuando sube la camara (sin tint para no dar lag)
          float curvaCielo = obtenerCurvaSuaveCielo();
          float offsetLogoAbajo = curvaCielo * (height * 0.92f);
          float offsetBotonesAbajo = curvaCielo * (height * 0.32f);

          if (logoMenu != null && curvaCielo < 0.92f) {
            noTint();
            imageMode(CENTER);
            image(logoMenu, REF_W * 0.55f * escalaX, (REF_H * 0.48f * escalaY) + offsetLogoAbajo);
            imageMode(CORNER);
          }

          // Botones del carrusel deslizandose suavemente hacia abajo
          float botonAlto = (REF_H * 0.08f) * escalaY;
          float botonAncho = (REF_W * 0.18f) * escalaX;
          float botonEspacio = (REF_W * 0.03f) * escalaX;
          float anchoTotalBotones = (botonAncho * botonesVisibles) + (botonEspacio * (botonesVisibles - 1));
          float botonesInicioX = (width - anchoTotalBotones) / 2;
          float botonesY = (height - botonAlto - ((REF_H * 0.05f) * escalaY)) + offsetBotonesAbajo;

          for (int k = 0; k < botonesVisibles; k++) {
            btnW[k] = botonAncho;
            btnH[k] = botonAlto;
            btnX[k] = botonesInicioX + (k * (botonAncho + botonEspacio));
            btnY[k] = botonesY;
          }

          if (faseCamaraMenu == 0 && !mostrarOpciones && (abs(mouseX - pmouseX) > 2 || abs(mouseY - pmouseY) > 2)) {
            int seleccionPrevia = opcionSeleccionada;

            for (int k = 0; k < botonesVisibles; k++) {
              if (mouseX > btnX[k] && mouseX < btnX[k] + btnW[k] && mouseY > btnY[k] && mouseY < btnY[k] + btnH[k]) {
                opcionSeleccionada = (offsetCarrusel + k) % totalBotones;
              }
            }

            if (opcionSeleccionada != seleccionPrevia && opcionSeleccionada != ultimaOpcionHover) {
              if (sonidoHover != null) {
                sonidoHover.amp(0.15f * volMaster);
                sonidoHover.play();
              }
              ultimaOpcionHover = opcionSeleccionada;
            }
          }

          if (curvaCielo < 0.85f) {
            textAlign(CENTER, CENTER);
            textSize(max(12, PApplet.parseInt(24 * escalaX)));
            for (int k = 0; k < botonesVisibles; k++) {
              int indiceReal = (offsetCarrusel + k) % totalBotones;
              boolean seleccionado = (opcionSeleccionada == indiceReal);

              if (seleccionado) {
                fill(255, 220, 100);
              } else {
                fill(180, 120, 60);
              }
              stroke(100, 50, 20);
              strokeWeight(4);
              rect(btnX[k], btnY[k], btnW[k], btnH[k], 8);

              noStroke();
              if (seleccionado) {
                fill(255, 232, 130);
              } else {
                fill(192, 138, 78);
              }
              rect(btnX[k] + 4, btnY[k] + 4, btnW[k] - 8, btnH[k] / 2 - 4, 4);

              if (!seleccionado) {
                fill(100, 50, 20);
                text(nombresBotones[indiceReal], btnX[k] + (btnW[k] / 2) + 2, btnY[k] + (btnH[k] / 2) + 2);
                fill(255);
              } else {
                fill(50, 20, 0);
              }
              text(nombresBotones[indiceReal], btnX[k] + (btnW[k] / 2), btnY[k] + (btnH[k] / 2));
            }

            // Flechas a los lados
            float anchoFlecha = (REF_W * 0.02f) * escalaX;
            float margenFlecha = (REF_W * 0.015f) * escalaX;
            fill(200, 150, 90);
            noStroke();
            float flechaIzqX = btnX[0] - margenFlecha;
            float flotarFlechas = sin(millis() * 0.003f) * 5 * escalaY;
            float flechaIzqY = btnY[0] + (btnH[0] / 2) + flotarFlechas;
            triangle(flechaIzqX, flechaIzqY, flechaIzqX - anchoFlecha, flechaIzqY - anchoFlecha, flechaIzqX - anchoFlecha, flechaIzqY + anchoFlecha);
            float flechaDerX = btnX[botonesVisibles - 1] + btnW[botonesVisibles - 1] + margenFlecha;
            float flechaDerY = btnY[botonesVisibles - 1] + (btnH[botonesVisibles - 1] / 2) + flotarFlechas;
            triangle(flechaDerX, flechaDerY, flechaDerX + anchoFlecha, flechaDerY - anchoFlecha, flechaDerX + anchoFlecha, flechaDerY + anchoFlecha);
          }

          // dibujamos los recuadros flotantes de partida guardada y '+' en el cielo
          dibujarMenuPartidasEnElCielo();
        }

        // -----------------------------------------------------
        // INTRO (LORE INICIAL)
        // -----------------------------------------------------
        if (estadoActual == JUEGO) {
          PImage bgIntro = fondoEscena;
          if (paginaActual >= 21 && imgEscenaDesayuno != null && imgEscenaDesayuno.width > 0) {
            bgIntro = imgEscenaDesayuno;
          } else {
            if (paginaActual >= 21 && escenasNovela != null && TAM_ESCENAS_NOVELA > 2 && escenasNovela[2] != null && escenasNovela[2].width > 0) {
              bgIntro = escenasNovela[2];
            }
          }
          if (bgIntro != null && bgIntro.width > 0) {
            image(bgIntro, 0, 0);
          } else {
            background(15, 25, 40);
          }

          float cajaAncho = width * 0.85f;
          float cajaAlto = height * 0.25f;
          float cajaX = (width - cajaAncho) / 2;
          float cajaY = height - cajaAlto - 40;

          fill(0, 210);
          noStroke();
          rectMode(CORNER);
          rect(cajaX, cajaY, cajaAncho, cajaAlto, 15);

          if (!mostrarSaltarIntro) {
            fill(100, 220, 120);
            textAlign(LEFT, TOP);
            textSize(26 * escalaX);
            text(hablantesLore[paginaActual], cajaX + 30, cajaY + 20);

            String textoFullLore = paginasLore[paginaActual];
            if (!textoFullLore.equals(ultimoTextoDialogo)) {
              ultimoTextoDialogo = textoFullLore;
              charsVisibles = 0;
              dialogoCompletado = false;
            }
            if (!dialogoCompletado && !enPausa) {
              charsVisibles += velTypewriter;
              if (charsVisibles >= textoFullLore.length()) {
                charsVisibles = textoFullLore.length();
                dialogoCompletado = true;
              }
            }
            int nCharsLore = constrain(PApplet.parseInt(charsVisibles), 0, textoFullLore.length());
            String textoParcialLore = textoFullLore.substring(0, nCharsLore);

            fill(240);
            textSize(21 * escalaX);
            text(textoParcialLore, cajaX + 30, cajaY + 60, cajaAncho - 60, cajaAlto - 80);

            fill(150);
            textAlign(RIGHT, BOTTOM);
            textSize(15 * escalaX);
            text(dialogoCompletado ? "Clic o ENTER: Avanzar | 'M' Menú" : "Clic o ENTER: Completar | 'M' Menú", cajaX + cajaAncho - 20,
                cajaY + cajaAlto - 15);
          } else {
            ultimoTextoDialogo = "";
            charsVisibles = 0;
            dialogoCompletado = false;

            fill(180);
            textAlign(CENTER, CENTER);
            textSize(20 * escalaX);
            text("Elige si deseas ver o saltar la introducción para comenzar...", cajaX + cajaAncho / 2, cajaY + cajaAlto / 2);

            float saltarX = (REF_W * 0.02f) * escalaX;
            float saltarY = (REF_H * 0.02f) * escalaY;
            float saltarW = (REF_W * 0.18f) * escalaX;
            float saltarH = (REF_H * 0.15f) * escalaY;

            fill(0, 180);
            noStroke();
            rect(saltarX, saltarY, saltarW, saltarH, 10);

            fill(255);
            textAlign(CENTER, TOP);
            textSize(18 * escalaX);
            text("¿Saltar introducción?", saltarX + (saltarW / 2), saltarY + 10 * escalaY);

            for (int k = 0; k < 2; k++) {
              btnSaltarW[k] = saltarW * 0.4f;
              btnSaltarH[k] = saltarH * 0.4f;
              btnSaltarY[k] = saltarY + saltarH - btnSaltarH[k] - 10 * escalaY;
              if (k == 0) {
                btnSaltarX[k] = saltarX + (saltarW * 0.05f);
              } else {
                btnSaltarX[k] = saltarX + saltarW - btnSaltarW[k] - (saltarW * 0.05f);
              }
            }

            if (abs(mouseX - pmouseX) > 2 || abs(mouseY - pmouseY) > 2) {
              hoverSaltarIntro = -1;
              for (int k = 0; k < 2; k++) {
                if (mouseX > btnSaltarX[k] && mouseX < btnSaltarX[k] + btnSaltarW[k] && mouseY > btnSaltarY[k]
                    && mouseY < btnSaltarY[k] + btnSaltarH[k]) {
                  hoverSaltarIntro = k;
                  opcionSaltarIntro = k;
                }
              }
            }

            for (int k = 0; k < 2; k++) {
              boolean seleccionado = (opcionSaltarIntro == k);

              if (seleccionado) {
                fill(255, 220, 100);
              } else {
                fill(180, 120, 60);
              }
              stroke(100, 50, 20);
              strokeWeight(2);
              rect(btnSaltarX[k], btnSaltarY[k], btnSaltarW[k], btnSaltarH[k], 6);

              noStroke();
              if (seleccionado) {
                fill(255, 240, 150, 100);
              } else {
                fill(200, 150, 90, 100);
              }
              rect(btnSaltarX[k] + 2, btnSaltarY[k] + 2, btnSaltarW[k] - 4, btnSaltarH[k] / 2 - 2, 3);

              if (seleccionado) {
                fill(50, 20, 0);
              } else {
                fill(255);
              }
              textAlign(CENTER, CENTER);
              textSize(16 * escalaX);
              text(textosSaltar[k], btnSaltarX[k] + (btnSaltarW[k] / 2), btnSaltarY[k] + (btnSaltarH[k] / 2));
            }
          }
        }

        // -----------------------------------------------------
        // CREDITOS
        // -----------------------------------------------------
        if (estadoActual == CREDITOS) {
          if (videoCreditos != null) {
            if (videoCreditos.available()) {
              videoCreditos.read();
            }
            if (videoCreditos.time() >= videoCreditos.duration() - 0.1f || !videoCreditos.isPlaying()) {
              videoCreditos.jump(0);
              videoCreditos.play();
            }
            if (videoCreditos.width > 0 && videoCreditos.height > 0) {
              image(videoCreditos, 0, 0, width, height);
            } else {
              background(10, 12, 20);
            }
          } else {
            background(10, 12, 20);
          }

          noStroke();
          fill(0, 170);
          rectMode(CORNER);
          rect(width * 0.15f, height * 0.08f, width * 0.70f, height * 0.87f, 15);

          fill(255);
          textAlign(CENTER, CENTER);
          textSize(45 * escalaX);
          text("EQUIPO DE DESARROLLO", width / 2, height * 0.15f);

          textSize(30 * escalaX);
          fill(100, 210, 120);
          text("Programación y Lógica", width / 2, height * 0.28f);

          float interlineado = height * 0.045f;
          float yProgramacion = (height * 0.42f) - (interlineado * 1.5f);
          for (int i = 0; i < 4; i++) {
            String etiqueta = nombresCreditos[i];
            if (nombreSeleccionado == i) {
              fill(255, 220, 100);
              etiqueta = "» " + etiqueta + " «";
            } else {
              fill(255);
            }
            textSize(24 * escalaX);
            text(etiqueta, width / 2, yProgramacion + (i * interlineado));
          }

          textSize(30 * escalaX);
          fill(100, 210, 120);
          text("Arte y Diseño", width / 2, height * 0.64f);

          float yArte = (height * 0.73f) - (interlineado * 0.5f);
          for (int i = 0; i < 2; i++) {
            int indice = i + 4;
            String etiqueta = nombresCreditos[indice];
            if (nombreSeleccionado == indice) {
              fill(255, 220, 100);
              etiqueta = "» " + etiqueta + " «";
            } else {
              fill(255);
            }
            textSize(24 * escalaX);
            text(etiqueta, width / 2, yArte + (i * interlineado));
          }

          textSize(16 * escalaX);
          fill(180);
          text("'M' para regresar al menú", width / 2, height * 0.90f);
        }

        // -----------------------------------------------------
        // EXPLORACION (RPG)
        // -----------------------------------------------------
        if (estadoActual == EXPLORACION) {
          background(0);
          if (pisoActual == 2 && fondoHabitacion != null) {
            image(fondoHabitacion, 0, 0);
          } else {
            if (pisoActual == 1 && fondoPrimerPiso != null) {
              image(fondoPrimerPiso, 0, 0);
            } else {
              background(50, 40, 40);
            }
          }

          if (pisoActual == 2) {
            limIzq = width * 0.042f;
            limDer = width * 0.872f;
            limArr = height * 0.130f;
            limAba = height * 0.955f;


            totalObstaculos = 7;
            obsX[0] = limIzq;
            obsY[0] = 0;
            obsW[0] = limDer - limIzq;
            obsH[0] = limArr;
            obsX[1] = width * 0.540f;
            obsY[1] = height * 0.580f;
            obsW[1] = width * 0.150f;
            obsH[1] = height * 0.300f;
            obsX[2] = width * 0.050f;
            obsY[2] = height * 0.700f;
            obsW[2] = width * 0.090f;
            obsH[2] = height * 0.180f;
            obsX[3] = width * 0.050f;
            obsY[3] = height * 0.145f;
            obsW[3] = width * 0.115f;
            obsH[3] = height * 0.170f;
            obsX[4] = width * 0.170f;
            obsY[4] = height * 0.140f;
            obsW[4] = width * 0.110f;
            obsH[4] = height * 0.180f;
            obsX[5] = width * 0.300f;
            obsY[5] = height * 0.145f;
            obsW[5] = width * 0.080f;
            obsH[5] = height * 0.170f;
            // obs[6]: Hitbox solida de la escalera del segundo piso (ajustable arriba con escPiso2Hit*Frac)
            obsX[6] = width * escPiso2HitXFrac;
            obsY[6] = height * escPiso2HitYFrac;
            obsW[6] = width * escPiso2HitWFrac;
            obsH[6] = height * escPiso2HitHFrac;
          } else {
            limIzq = 0;
            limDer = width;
            limArr = height * 0.060f;
            limAba = height;


            totalObstaculos = 9;
            obsX[0] = 0;
            obsY[0] = 0;
            obsW[0] = width;
            obsH[0] = limArr;
            obsX[1] = width * 0.445f;
            obsY[1] = height * 0.470f;
            obsW[1] = width * 0.150f;
            obsH[1] = height * 0.230f;
            obsX[2] = width * 0.050f;
            obsY[2] = height * 0.430f;
            obsW[2] = width * 0.070f;
            obsH[2] = height * 0.180f;
            obsX[3] = width * 0.160f;
            obsY[3] = height * 0.700f;
            obsW[3] = width * 0.150f;
            obsH[3] = height * 0.140f;
            obsX[4] = width * 0.075f;
            obsY[4] = height * 0.235f;
            obsW[4] = width * 0.350f;
            obsH[4] = height * 0.165f;
            obsX[5] = width * 0.780f;
            obsY[5] = height * 0.330f;
            obsW[5] = width * 0.170f;
            obsH[5] = height * 0.105f;
            obsX[6] = width * 0.765f;
            obsY[6] = height * 0.550f;
            obsW[6] = width * 0.078f;
            obsH[6] = height * 0.308f;
            obsX[7] = width * 0.920f;
            obsY[7] = height * 0.360f;
            obsW[7] = width * 0.080f;
            obsH[7] = height * 0.690f;
            obsX[8] = width * 0.820f;
            obsY[8] = height * 0.080f;
            obsW[8] = width * 0.070f;
            obsH[8] = height * 0.265f;
          }

          // Padres de Sam (dimensiones y hitbox dedicadas)
          padresX = width * 0.50f;
          calcularZonaEscalera();
          if (animandoEscalera) actualizarRecorridoEscalera();

          padresY = height * 0.20f;
          padresSep = width * 0.065f;
          float pSpriteW = pjW * 1.05f;
          float pSpriteH = pjH * 1.05f;
          float padresHitX = padresX + pSpriteW * 0.14f;
          float padresHitY = padresY + pSpriteH * 0.08f;
          float padresHitW = padresSep + pSpriteW * 0.68f;
          float padresHitH = pSpriteH * 0.88f;

          if (pisoActual == 1) {
            float zonaPadresX = padresHitX - 50 * escalaX;
            float zonaPadresY = padresHitY - 45 * escalaY;
            float zonaPadresW = padresHitW + 100 * escalaX;
            float zonaPadresH = padresHitH + 95 * escalaY;
            samCercaDePadres = (pjX + hitOffX < zonaPadresX + zonaPadresW && pjX + hitOffX + hitW > zonaPadresX
                && pjY + hitOffY < zonaPadresY + zonaPadresH && pjY + hitOffY + hitH > zonaPadresY);
            float centroHitX = pjX + hitOffX + hitW * 0.5f;
            float centroHitY = pjY + hitOffY + hitH * 0.5f;
            float puntoMesaX = constrain(centroHitX, obsX[1], obsX[1] + obsW[1]);
            float puntoMesaY = constrain(centroHitY, obsY[1], obsY[1] + obsH[1]);
            samCercaDeMesa = dist(centroHitX, centroHitY, puntoMesaX, puntoMesaY) < 70 * escalaX;

            boolean samDetrasDePadres = (pjY + pjH) < (padresY + pSpriteH);
            if (samDetrasDePadres) {
              dibujarSamExploracion();
              dibujarPadresExploracion(pSpriteW, pSpriteH);
            } else {
              dibujarPadresExploracion(pSpriteW, pSpriteH);
              dibujarSamExploracion();
            }
          } else {
            samCercaDePadres = false;
            samCercaDeMesa = false;
            dibujarSamExploracion();
          }

          if (pisoActual == 2) {
            samCercaDeCama = dist(pjX + pjW / 2.0f, pjY + pjH / 2.0f, obsX[1] + obsW[1] / 2.0f, obsY[1] + obsH[1] / 2.0f) < 150 * escalaX;
          } else {
            samCercaDeCama = false;
          }

          if (!animandoEscalera && !enTransicion && !leyendoMensaje && !enPausa && !mostrandoModalDormir) {
            if (pisoActual == 2) {
              if (!desayunoComido) {
                dibujarIndicativoFlotante(indicativoDireccion, obsX[6] - 12 * escalaX, obsY[6] + obsH[6] * 0.50f, 95 * escalaX, 0);
              }
              if (tieneCelular && desayunoComido) {
                dibujarIndicativoFlotante(indicativoDireccion, obsX[1] - 20 * escalaX, obsY[1] + obsH[1] * 0.5f, 95 * escalaX, 0);
              }
            }
            if (pisoActual == 1) {
              if (!tieneCelular) {
                dibujarIndicativoFlotante(indicativoPendiente, padresX + padresSep * 0.5f + pSpriteW * 0.5f, padresY - 35 * escalaY, 90 * escalaX, 1.5f);
              }
              if (tieneCelular && !desayunoComido && !dia1Terminado) {
                dibujarIndicativoFlotante(indicativoPendiente, obsX[1] + obsW[1] * 0.5f, obsY[1] - 35 * escalaY, 90 * escalaX, 1.5f);
              }
              if (desayunoComido) {
                dibujarIndicativoFlotante(indicativoDireccion, escX - 12 * escalaX, escY + escH * 0.55f, 95 * escalaX, 0);
              }
            }
          }

          boolean samSobreEscalera = samCercaDeAccesoEscalera();

          if (!animandoEscalera && !enPausa && samSobreEscalera) {
            if (pisoActual == 2) {
              dibujarAvisoInteraccionExploracion("Presiona 'E' para bajar");
            } else {
              dibujarAvisoInteraccionExploracion("Presiona 'E' para subir");
            }
          }

          if (!animandoEscalera && !leyendoMensaje && !enTransicion && !enPausa && !mostrandoModalDormir) {
            if (pisoActual == 1) {
              if (!tieneCelular && samCercaDePadres) {
                dibujarAvisoInteraccionExploracion("Presiona 'E' para hablar con tus padres");
              } else {
                if (tieneCelular && !desayunoComido && samCercaDeMesa) {
                  dibujarAvisoInteraccionExploracion("Presiona 'E' para desayunar en la mesa");
                } else {
                  if (dia1Terminado && samCercaDePadres) {
                    dibujarAvisoInteraccionExploracion("Presiona 'E' para hablar con tus padres");
                  } else {
                    if (samCercaDePadres) {
                      dibujarAvisoInteraccionExploracion("Presiona 'E' para hablar");
                    }
                  }
                }
              }
            } else {
              if (pisoActual == 2) {
                if (samCercaDeCama) {
                  if (tieneCelular && desayunoComido) {
                    dibujarAvisoInteraccionExploracion("Presiona 'E' para acostarte en la cama");
                  } else {
                    dibujarAvisoInteraccionExploracion("Ya me desperté, debería bajar a la sala");
                  }
                }
              }
            }
          }
          if (leyendoMensaje) {
            fill(0, 200);
            noStroke();
            rect(100, height - 200, width - 200, 150, 15);
            fill(255);
            textAlign(CENTER, CENTER);
            textSize(24 * escalaX);
            if (pisoActual == 2) {
              text("SAM: Bajemos a ver qué me van a dar... \n Espero que no sea ROPA AAAAHHHHHH \n (Presiona E para cerrar)", width / 2,
                  height - 125);
            } else {
              if (dia1Terminado) {
                text("SAM: Mis padres están orgullosos del partido de hoy. Me dijeron que suba a descansar. \n (Presiona E para cerrar)", width / 2,
                    height - 125);
              } else {
                text("SAM: La sala y el comedor. Huele a desayuno recien preparado. \n (Presiona E para cerrar)", width / 2, height - 125);
              }
            }
          }

          if (!animandoEscalera) {
            samCaminando = false;

            if (!leyendoMensaje && !enTransicion && alphaTransicion <= 0 && !enPausa && !guiaPresentacionPendiente) {
              float desplazX = 0;
              float desplazY = 0;

              if (movArriba) {
                desplazY -= pjVel;
                direccionSam = "norte";
              }
              if (movAbajo) {
                desplazY += pjVel;
                direccionSam = "sur";
              }
              if (movIzquierda) {
                desplazX -= pjVel;
                direccionSam = "oeste";
              }
              if (movDerecha) {
                desplazX += pjVel;
                direccionSam = "este";
              }

              for (int eje = 0; eje < 2; eje++) {
                float futX = pjX;
                float futY = pjY;
                if (eje == 0) {
                  futX += desplazX;
                } else {
                  futY += desplazY;
                }

                if (futX != pjX || futY != pjY) {
                  float futHitX = futX + hitOffX;
                  float futHitY = futY + hitOffY;
                  if (futHitX < limIzq) {
                    futX = limIzq - hitOffX;
                  }
                  if (futHitX + hitW > limDer) {
                    futX = limDer - hitW - hitOffX;
                  }
                  if (futHitY < limArr) {
                    futY = limArr - hitOffY;
                  }
                  if (futHitY + hitH > limAba) {
                    futY = limAba - hitH - hitOffY;
                  }

                  futHitX = futX + hitOffX;
                  futHitY = futY + hitOffY;

                  boolean hayColision = false;
                  for (int i = 0; i < totalObstaculos; i++) {
                    if (futHitX < obsX[i] + obsW[i] && futHitX + hitW > obsX[i] && futHitY < obsY[i] + obsH[i] && futHitY + hitH > obsY[i]) {
                      hayColision = true;
                    }
                  }
                  if (pisoActual == 1) {
                    if (futHitX < padresHitX + padresHitW && futHitX + hitW > padresHitX && futHitY < padresHitY + padresHitH
                        && futHitY + hitH > padresHitY) {
                      hayColision = true;
                    }
                  }

                  if (!hayColision) {
                    pjX = futX;
                    pjY = futY;
                    samCaminando = true;
                  }
                }
              }
            }
          }

          if (!enPausa) {
            contadorFrameAnim++;
            if (samCaminando) {
              if (contadorFrameAnim >= velocidadAnim) {
                contadorFrameAnim = 0;
                frameAnimActual = (frameAnimActual + 1) % totalFramesAnim;
                if (frameAnimActual % 2 == 0) {
                  reproducirSfx(SFX_PASOS, 0.35f);
                }
              }
            } else {
              if (contadorFrameAnim >= velocidadAnim * 3) {
                contadorFrameAnim = 0;
                frameAnimActual = (frameAnimActual + 1) % totalFramesIdle;
              }
            }
          }

          if (modoDebug) {
            pushStyle();
            rectMode(CORNER);
            noFill();
            stroke(255, 255, 0);
            strokeWeight(3);
            rect(limIzq, limArr, limDer - limIzq, limAba - limArr);

            fill(255, 0, 0, 100);
            noStroke();
            for (int i = 0; i < totalObstaculos; i++) {
              rect(obsX[i], obsY[i], obsW[i], obsH[i]);
            }

            if (pisoActual == 2) {
              noFill();
              stroke(255, 255, 0);
              strokeWeight(2);
              rect(obsX[6], obsY[6], obsW[6], obsH[6]);
              noStroke();
              fill(255, 255, 0);
              textAlign(CENTER, CENTER);
              textSize(12);
              text("ESCALERA (obs[6])", obsX[6] + obsW[6] * 0.5f, obsY[6] + obsH[6] * 0.5f);
            }

            if (pisoActual == 1) {
              fill(255, 0, 180, 75);
              stroke(255, 0, 255);
              strokeWeight(2);
              rect(padresHitX, padresHitY, padresHitW, padresHitH);
              noStroke();
            }

            fill(0, 0, 255, 100);
            rect(escX, escY, escW, escH);

            noFill();
            stroke(0, 255, 0);
            strokeWeight(2);
            rect(pjX + hitOffX, pjY + hitOffY, hitW, hitH);
            stroke(0, 255, 0, 100);
            strokeWeight(1);
            rect(pjX, pjY, pjW, pjH);

            fill(0, 255, 0);
            textAlign(LEFT, TOP);
            textSize(12);
            text("HIT: offX=" + hitOffX + " offY=" + hitOffY + " W=" + hitW + " H=" + hitH, 10, 10);
            text("POS: x=" + PApplet.parseInt(pjX) + " y=" + PApplet.parseInt(pjY), 10, 26);
            if (pisoActual == 2) {
              text("ESC P2: X=" + nf(escPiso2HitXFrac, 1, 3) + " Y=" + nf(escPiso2HitYFrac, 1, 3) + " W=" + nf(escPiso2HitWFrac, 1, 3) + " H=" + nf(escPiso2HitHFrac, 1, 3), 10, 42);
            }
            popStyle();
          }

          // HUD Integrado de Bienestar Digital, Reputación Digital y Puntos (Requisito 2 y 3)
          dibujarHUDExploracion();

          fill(255, 180);
          textAlign(CENTER, CENTER);
          textSize(14 * escalaX);
          if (tieneCelular) {
            text("WASD/Flechas: Mover | E: Interactuar | C: Celular | TAB: Resumen Puntos | P: Pausa", width / 2, height - 15);
          } else {
            text("WASD/Flechas: Mover | E: Interactuar | TAB: Resumen Puntos | P: Pausa", width / 2, height - 15);
          }

          if (dialogoCamaActivo) {
            dibujarDialogoCama();
          }

          if (mostrandoModalDormir) {
            dibujarModalDormir();
          }
        }

        // -----------------------------------------------------
        // LOGROS
        // -----------------------------------------------------
        if (estadoActual == LOGROS) {
          background(15, 15, 20);

          fill(255);
          textAlign(CENTER, CENTER);
          textSize(38 * escalaX);
          text("LOGROS", width / 2, height * 0.08f);

          fill(255, 220, 80);
          textSize(20 * escalaX);
          text("Puntos Totales: " + round(puntosMostradosLerp) + " pts  (Presiona TAB para Desglose)", width / 2, height * 0.14f);

          int columnas = 7;
          float margen = width * 0.05f;
          float espacioCasilla = width * 0.012f;
          float casillaTam = (width - (margen * 2) - (espacioCasilla * (columnas - 1))) / columnas;
          float inicioY = height * 0.20f;

          for (int i = 0; i < totalLogros; i++) {
            int columna = i % columnas;
            int fila = i / columnas;
            float casillaX = margen + (columna * (casillaTam + espacioCasilla));
            float casillaY = inicioY + (fila * (casillaTam + espacioCasilla));

            if (logrosDesbloqueados[i]) {
              fill(40, 60, 40);
              stroke(255, 220, 100);
            } else {
              fill(35, 35, 35);
              stroke(90, 90, 90);
            }
            strokeWeight(3);
            rect(casillaX, casillaY, casillaTam, casillaTam, 8);

            if (logroImagenes[i] != null) {
              image(logroImagenes[i], casillaX + (casillaTam * 0.15f), casillaY + (casillaTam * 0.1f), casillaTam * 0.7f, casillaTam * 0.55f);
              if (!logrosDesbloqueados[i]) {
                noStroke();
                fill(25, 25, 28, 175);
                rect(casillaX + (casillaTam * 0.14f), casillaY + (casillaTam * 0.09f), casillaTam * 0.72f, casillaTam * 0.57f, 6);
              }
            }

            noStroke();
            if (logrosDesbloqueados[i]) {
              fill(255);
            } else {
              fill(120);
            }
            textAlign(CENTER, CENTER);
            textSize(12 * escalaX);
            text(logros[i][1], casillaX + (casillaTam / 2), casillaY + (casillaTam * 0.85f));
          }

          fill(180);
          textAlign(CENTER, CENTER);
          textSize(16 * escalaX);
          text("Presiona 'M' para regresar al menú", width / 2, height * 0.95f);
        }

        if (estadoActual == RECUERDOS)
          recDibujar();

        // -----------------------------------------------------
        // DIALOGO CON LOS PADRES
        // -----------------------------------------------------
        if (estadoActual == PADRES) {
          if (imgEscenaDesayuno != null && imgEscenaDesayuno.width > 0) {
            image(imgEscenaDesayuno, 0, 0);
          } else {
            if (escenasNovela[2] != null && escenasNovela[2].width > 0) {
              image(escenasNovela[2], 0, 0);
            } else {
              if (fondoEscena != null && fondoEscena.width > 0) {
                image(fondoEscena, 0, 0);
              } else {
                background(15, 25, 40);
              }
            }
          }

          String hablanteActual = "";
          String textoActual = "";

          if (!feedbackPadresActivo) {
            hablanteActual = hablantesPadres[paginaPadres];
            textoActual = paginasPadres[paginaPadres];
          } else {
            if (!desayunoTarde) {
              hablanteActual = hablantesPadresBueno[paginaPadres];
              textoActual = paginasPadresBueno[paginaPadres];
            } else {
              hablanteActual = hablantesPadresMalo[paginaPadres];
              textoActual = paginasPadresMalo[paginaPadres];
            }
          }

          // Retratos de Mamá y Papá en el comedor (sin tint() en CPU por frame)
          float altoRetrato = 320 * escalaY;
          float anchoRetrato = 220 * escalaX;
          float posYRetrato = height * 0.28f;

          // Mamá a la izquierda
          if (imgMama != null && imgMama.width > 0) {
            boolean hablaMama = (hablanteActual.indexOf("MAMÁ") >= 0 || hablanteActual.indexOf("Mamá") >= 0);
            image(imgMama, width * 0.22f - (anchoRetrato / 2), posYRetrato + (hablaMama ? 0 : 12 * escalaY));
          }

          // Papá a la derecha
          if (imgPapa != null && imgPapa.width > 0) {
            boolean hablaPapa = (hablanteActual.indexOf("PAPÁ") >= 0 || hablanteActual.indexOf("Papá") >= 0);
            image(imgPapa, width * 0.78f - (anchoRetrato / 2), posYRetrato + (hablaPapa ? 0 : 12 * escalaY));
          }

          dibujarHUDExploracion();

          float cajaAncho = width * 0.85f;
          float cajaAlto = height * 0.25f;
          float cajaX = (width - cajaAncho) / 2;
          float cajaY = height - cajaAlto - 40;

          fill(0, 210);
          noStroke();
          rectMode(CORNER);
          rect(cajaX, cajaY, cajaAncho, cajaAlto, 15);

          fill(100, 220, 120);
          textAlign(LEFT, TOP);
          textSize(26 * escalaX);

          text(hablanteActual, cajaX + 30, cajaY + 20);

          if (!textoActual.equals(ultimoTextoDialogo)) {
            ultimoTextoDialogo = textoActual;
            charsVisibles = 0;
            dialogoCompletado = false;
          }
          if (!dialogoCompletado && !enPausa) {
            charsVisibles += velTypewriter;
            if (charsVisibles >= textoActual.length()) {
              charsVisibles = textoActual.length();
              dialogoCompletado = true;
            }
          }
          int nCharsPadres = constrain(PApplet.parseInt(charsVisibles), 0, textoActual.length());
          String textoParcialPadres = textoActual.substring(0, nCharsPadres);

          fill(240);
          textSize(21 * escalaX);
          text(textoParcialPadres, cajaX + 30, cajaY + 60, cajaAncho - 60, cajaAlto - 80);

          fill(150);
          textAlign(RIGHT, BOTTOM);
          textSize(15 * escalaX);
          text(dialogoCompletado ? "Clic o ENTER: Avanzar | 'M' Menú" : "Clic o ENTER: Completar | 'M' Menú", cajaX + cajaAncho - 20,
              cajaY + cajaAlto - 15);

          if (mostrandoDecisionPadres) {
            dibujarModalDecisionPadres();
          }
        }

        // -----------------------------------------------------
        // NIVEL 1: CELULAR DE SAM
        // -----------------------------------------------------
        if (estadoActual == NIVEL1) {
          background(0);
          if (pisoActual == 2 && fondoHabitacion != null && fondoHabitacion.width > 0) {
            image(fondoHabitacion, 0, 0);
          } else {
            if (fondoPrimerPiso != null && fondoPrimerPiso.width > 0) {
              image(fondoPrimerPiso, 0, 0);
            } else {
              background(50, 40, 40);
            }
          }

          fill(0, 160);
          noStroke();
          rectMode(CORNER);
          rect(0, 0, width, height);

          // Relación de aspecto calibrada a tu dibujo de Ibis Paint (888 x 1600 = 0.555)
          telefonoAlto = min(840, height * 0.90f);
          telefonoAncho = telefonoAlto * (888.0f / 1600.0f);
          telefonoX = (width - telefonoAncho) / 2;
          telefonoY = (height - telefonoAlto) / 2;

          // Medidas de la pantalla interior calibradas exactamente al marco completo
          pantallaW = telefonoAncho * (660.0f / 888.0f);
          pantallaH = telefonoAlto * (1020.0f / 1600.0f);
          pantallaX = telefonoX + (telefonoAncho * (114.0f / 888.0f));
          pantallaY = telefonoY + (telefonoAlto * (294.0f / 1600.0f));

          // AVANCE DEL TIEMPO IN-GAME: Cada 4 segundos reales suma 1 minuto in-game
          if (!enPausa) acumuladorMinutos += (1.0f / 60.0f);
          if (acumuladorMinutos >= 4.0f) {
            acumuladorMinutos = 0;
            minutoReloj++;
            if (minutoReloj >= 60) {
              minutoReloj = 0;
              horaReloj++;
            }
            // Drenar batería lentamente
            if (minutoReloj % 15 == 0 && bateriaPct > 5) {
              bateriaPct--;
            }
          }

          // Eventos narrativos del Nivel 1 basados en el tiempo
          if (minutoReloj >= 52 && !desayunoLlamado && !desayunoComido && !penaltisJugados) {
            desayunoLlamado = true;
            notifPushTitulo = "MAMÁ (Hace un momento)";
            reproducirSfx(SFX_NOTIFICACION, 0.6f);
            notifPushSub = "¡Sam! ¡Los panqueques ya están listos, baja a desayunar!";
            notifPushFin = millis() + 6000;
            notifPushY = -80;
          }

          if (minutoReloj >= 58 && !desayunoTarde && !desayunoComido && !penaltisJugados) {
            desayunoTarde = true;
            bienestarDigital = max(20, bienestarDigital - 15);
            notifPushTitulo = "MAMÁ (Urgente)";
            reproducirSfx(SFX_NOTIFICACION, 0.7f);
            notifPushSub = "¡Sam! La comida se está enfriando. Deja el teléfono.";
            notifPushFin = millis() + 6000;
            notifPushY = -80;
            // Logro si se quedó pegado
            desbloquearLogro(2);
          }

          // =====================================================
          // MINIJUEGOS EN PANTALLA COMPLETA (PAREJAS, PIXEL ART, FRUTAS)
          // =====================================================
          if (!enHome && (appAbierta.equals("Parejas") || appAbierta.equals("Pixel Art") || appAbierta.equals("Frutas"))) {
            if (appAbierta.equals("Parejas")) {
              dibujarJuegoParejas(width, height);
            } else {
              if (appAbierta.equals("Pixel Art")) {
                dibujarJuegoPixelArt(width, height);
              } else {
                if (appAbierta.equals("Frutas")) {
                  dibujarJuegoFrutas(width, height);
                }
              }
            }
          } else {
            // 0. FONDO BASE DEL CUERPO DEL CELULAR (Evita cualquier hueco transparente con el suelo)
            pushStyle();
            fill(modoOscuroConfig ? color(16, 20, 28) : color(240, 242, 248));
            noStroke();
            rect(telefonoX + (telefonoAncho * (108.0f / 888.0f)), telefonoY + (telefonoAlto * (286.0f / 1600.0f)), telefonoAncho * (672.0f / 888.0f),
                telefonoAlto * (1034.0f / 1600.0f), 16);
            popStyle();

            // 1. ÁREA DE PANTALLA RECORTADA (detrás del marco)
            pushStyle();
            clip(pantallaX, pantallaY, pantallaW, pantallaH);
            pushMatrix();
            translate(pantallaX, pantallaY);
            if (fuenteCelular != null) {
              textFont(fuenteCelular);
            }

            // Fondo base de la pantalla
            if (enHome) {
              fill(fondosHome[fondoActualIndex]);
            } else {
              fill(modoOscuroConfig ? color(16, 20, 28) : color(242, 244, 250));
            }
            noStroke();
            rect(0, 0, pantallaW, pantallaH);

            // =====================================================
            // BARRA SUPERIOR DE ESTADO PERMANENTE (En Home y todas las Apps)
            // =====================================================
            float barraH = 28;
            float barraYCentro = 16;
            fill(10, 14, 22, 240);
            noStroke();
            rect(0, 0, pantallaW, barraH);

            // Reloj nítido y legible
            fill(255);
            textSize(12.5f);
            textAlign(LEFT, CENTER);
            String txtHora = (horaReloj < 10 ? "0" : "") + horaReloj + ":" + (minutoReloj < 10 ? "0" : "") + minutoReloj;
            text(txtHora, 10, barraYCentro);

            // Corazón ilustrado + Barra de Bienestar
            float corazonX = 54;
            float corazonY = barraYCentro;
            fill(255, 75, 95);
            noStroke();
            ellipse(corazonX - 2.5f, corazonY - 2, 5, 5);
            ellipse(corazonX + 2.5f, corazonY - 2, 5, 5);
            triangle(corazonX - 4.8f, corazonY - 1, corazonX + 4.8f, corazonY - 1, corazonX, corazonY + 4.8f);

            fill(38, 46, 58);
            rect(corazonX + 7, barraYCentro - 4, 34, 8, 3);
            if (bienestarDigital > 60) {
              fill(80, 225, 120);
            } else {
              if (bienestarDigital > 30) {
                fill(255, 195, 50);
              } else {
                fill(255, 70, 70);
              }
            }
            rect(corazonX + 7, barraYCentro - 4, constrain(34 * (bienestarDigital / 100.0f), 0, 34), 8, 3);

            // Reputación con estrella vectorial limpia (nunca se vuelve [])
            float estrellaX = pantallaW - 70;
            float estrellaY = barraYCentro;
            fill(255, 215, 50);
            noStroke();
            pushMatrix();
            translate(estrellaX, estrellaY);
            beginShape();
            for (int s = 0; s < 5; s++) {
              float aExt = -HALF_PI + s * TWO_PI / 5.0f;
              float aInt = aExt + PI / 5.0f;
              vertex(cos(aExt) * 5.5f, sin(aExt) * 5.5f);
              vertex(cos(aInt) * 2.5f, sin(aInt) * 2.5f);
            }
            endShape(CLOSE);
            popMatrix();

            fill(255, 220, 80);
            textSize(11);
            textAlign(LEFT, CENTER);
            text("" + reputacionDigital, estrellaX + 8, estrellaY);

            // Batería
            stroke(180);
            strokeWeight(1);
            noFill();
            rect(pantallaW - 28, barraYCentro - 5, 18, 10, 2);
            fill(bateriaPct > 20 ? color(80, 225, 120) : color(255, 70, 70));
            noStroke();
            rect(pantallaW - 27, barraYCentro - 4, constrain(16 * (bateriaPct / 100.0f), 0, 16), 8, 1);
            fill(180);
            rect(pantallaW - 10, barraYCentro - 2, 1.5f, 4);

            // =====================================================
            // CONTENIDO DE LA PANTALLA (HOME O APP)
            // =====================================================
            if (enHome) {
              // ---------- WIDGET DE RELOJ Y FECHA GRANDE EN HOME ----------
              fill(255);
              textSize(28);
              textAlign(CENTER, CENTER);
              text(txtHora, pantallaW / 2, 52);

              fill(220, 235, 255, 210);
              textSize(10.5f);
              text("Miércoles, 25 de Dic", pantallaW / 2, 72);

              stroke(255, 35);
              strokeWeight(1);
              line(30, 84, pantallaW - 30, 84);
              noStroke();

              // ---------- PANTALLA DE INICIO (APPS) ----------
              inicioAppsY = 82;
              tamApp = 48;
              espacioAppsX = (pantallaW - (columnasApps * tamApp)) / (columnasApps + 1);
              espacioAppsY = 9;

              int appsVisibles = juegosDesbloqueados ? totalApps : 7;
              for (int i = 0; i < appsVisibles; i++) {
                float appX = appCelularX(i);
                float appY = appCelularY(i);
                float centroX = appX + tamApp / 2;
                float centroY = appY + tamApp / 2;

                fill(coloresApps[i]);
                stroke(15);
                strokeWeight(2);
                rect(appX, appY, tamApp, tamApp, 10);

                fill(255);
                noStroke();
                if (i == 0) {
                  rect(centroX - 12, centroY - 14, 24, 28, 2);
                  fill(200, 100, 100);
                  rect(centroX - 8, centroY - 10, 16, 4);
                  fill(100);
                  rect(centroX - 8, centroY - 3, 16, 2.5f);
                  rect(centroX - 8, centroY + 3, 11, 2.5f);
                } else {
                  if (i == 1) {
                    ellipse(centroX, centroY, 20, 20);
                    fill(100, 170, 230);
                    ellipse(centroX, centroY, 10, 10);
                  } else {
                    if (i == 2) {
                      ellipse(centroX - 5, centroY + 5, 8, 6);
                      rect(centroX - 1, centroY - 8, 3, 14);
                      rect(centroX - 1, centroY - 8, 9, 4);
                    } else {
                      if (i == 3) {
                        rect(centroX - 14, centroY - 10, 28, 20, 3);
                        fill(100);
                        ellipse(centroX, centroY, 12, 12);
                        fill(255);
                        ellipse(centroX, centroY, 5, 5);
                      } else {
                        if (i == 4) {
                          rect(centroX - 14, centroY - 11, 28, 20, 4);
                          triangle(centroX - 9, centroY + 9, centroX - 4, centroY + 15, centroX - 2, centroY + 9);
                        } else {
                          if (i == 5) {
                            rect(centroX - 14, centroY - 12, 28, 24, 2);
                            fill(240, 220, 100);
                            ellipse(centroX + 7, centroY - 4, 5, 5);
                            fill(100, 150, 100);
                            triangle(centroX - 12, centroY + 8, centroX - 2, centroY - 2, centroX + 8, centroY + 8);
                          } else {
                            if (i == 6) {
                              if (logoPixagram != null && logoPixagram.width > 0) {
                                image(logoPixagram, appX, appY, tamApp, tamApp);
                              } else {
                                noFill();
                                stroke(255);
                                strokeWeight(2.5f);
                                rect(centroX - 13, centroY - 13, 26, 26, 7);
                                ellipse(centroX, centroY, 12, 12);
                                fill(255);
                                noStroke();
                                ellipse(centroX + 7, centroY - 7, 3.5f, 3.5f);
                              }
                            } else {
                              if (i == 7) {
                                fill(255);
                                rect(centroX - 11, centroY - 9, 13, 18, 3);
                                fill(59, 130, 246);
                                textAlign(CENTER, CENTER);
                                textSize(11);
                                text("?", centroX - 4.5f, centroY);
                                fill(254, 240, 138);
                                rect(centroX - 2, centroY - 9, 13, 18, 3);
                                fill(234, 88, 12);
                                ellipse(centroX + 4.5f, centroY, 6, 6);
                              } else {
                                if (i == 8) {
                                  fill(250, 204, 21);
                                  rect(centroX - 10, centroY - 10, 9, 9, 2);
                                  fill(59, 130, 246);
                                  rect(centroX + 1, centroY - 10, 9, 9, 2);
                                  fill(34, 197, 94);
                                  rect(centroX - 10, centroY + 1, 9, 9, 2);
                                  fill(239, 68, 68);
                                  rect(centroX + 1, centroY + 1, 9, 9, 2);
                                } else {
                                  if (i == 9) {
                                    fill(239, 68, 68);
                                    ellipse(centroX - 5, centroY + 4, 12, 12);
                                    ellipse(centroX + 5, centroY + 4, 12, 12);
                                    noFill();
                                    stroke(34, 197, 94);
                                    strokeWeight(1.8f);
                                    arc(centroX, centroY - 3, 10, 10, PI, TWO_PI);
                                    line(centroX, centroY - 8, centroX + 4, centroY - 12);
                                    noStroke();
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }

                fill(255);
                if (fuenteCelular != null) {
                  textFont(fuenteCelular);
                }
                textSize(11);
                textAlign(CENTER, BASELINE);
                text(nombresApps[i], appX + (tamApp / 2), appY + tamApp + 13);
              }

              // Base dock decorativo inferior
              fill(255, 30);
              rect(16, pantallaH - 32, pantallaW - 32, 20, 8);
              fill(255, 120);
              textSize(10);
              textAlign(CENTER, CENTER);
              text("Desliza para más", pantallaW / 2, pantallaH - 22);

            } else {
              // ---------- APPS ABIERTAS ----------

              // ===== BLOC DE NOTAS =====
              if (appAbierta.equals("Notas")) {
                fill(248, 242, 215);
                rect(0, 24, pantallaW, pantallaH - 24);
                fill(40);
                textSize(15);
                textAlign(LEFT, BASELINE);
                text("Bloc de Notas", 14, 48);
                stroke(210, 195, 160);
                line(12, 54, pantallaW - 12, 54);

                textSize(13);
                fill(50);
                text(textoNota + "_", 14, 76, pantallaW - 28, pantallaH - 120);

                // ===== AJUSTES =====
              } else {
                if (appAbierta.equals("Ajustes")) {
                  fill(modoOscuroConfig ? 255 : 30);
                  textSize(16);
                  textAlign(LEFT, BASELINE);
                  text("Configuración", 14, 48);

                  fill(modoOscuroConfig ? 48 : 215);
                  rect(12, 58, pantallaW - 24, 38, 6);
                  fill(modoOscuroConfig ? 255 : 30);
                  textSize(13);
                  text("Modo Oscuro: " + (modoOscuroConfig ? "ON" : "OFF"), 20, 82);

                  fill(modoOscuroConfig ? 48 : 215);
                  rect(12, 104, pantallaW - 24, 38, 6);
                  fill(modoOscuroConfig ? 255 : 30);
                  text("Notificaciones: " + (notificacionesConfig ? "ON" : "OFF"), 20, 128);

                  fill(modoOscuroConfig ? 48 : 215);
                  rect(12, 150, pantallaW - 24, 38, 6);
                  fill(modoOscuroConfig ? 255 : 30);
                  text("Fondo de Pantalla: [ Estilo " + (fondoActualIndex + 1) + " ]", 20, 174);

                  // ===== MUSICA =====
                } else {
                  if (appAbierta.equals("Música")) {
                    fill(modoOscuroConfig ? 255 : 30);
                    textSize(16);
                    textAlign(LEFT, BASELINE);
                    text("Reproductor MP3", 14, 46);

                    float tarjetaW = pantallaW - 28;
                    musTarjetaY = 56;
                    musTarjetaH = 80;
                    float visX = 14;
                    float visW = pantallaW - 28;
                    musVisY = musTarjetaY + musTarjetaH + 12;
                    musVisH = constrain(pantallaH - musVisY - 80, 75, 140);
                    musProgW = pantallaW - 40;
                    musProgX = 20;
                    musProgY = musVisY + musVisH + 16;
                    musInicioBtnX = (pantallaW - ((musBotonW * 3) + (musEspacioBtn * 2))) / 2;
                    musBotonY = musProgY + 26;

                    fill(modoOscuroConfig ? 38 : 225);
                    stroke(modoOscuroConfig ? 60 : 195);
                    strokeWeight(1.5f);
                    rect(14, musTarjetaY, tarjetaW, musTarjetaH, 8);

                    // Indicador de reproducción limpio
                    fill(reproduciendoMusica ? color(60, 220, 120) : color(255, 180, 50));
                    noStroke();
                    ellipse(14 + tarjetaW / 2 - 58, musTarjetaY + 16, 7, 7);
                    fill(modoOscuroConfig ? 255 : 30);
                    textSize(11);
                    textAlign(CENTER, CENTER);
                    text(reproduciendoMusica ? "REPRODUCIENDO" : "EN PAUSA", 14 + tarjetaW / 2 + 6, musTarjetaY + 16);

                    textSize(14);
                    fill(80, 200, 255);
                    text(nombresCanciones[cancionActualIndex], 14 + tarjetaW / 2, musTarjetaY + 44);

                    textSize(11);
                    fill(modoOscuroConfig ? 160 : 90);
                    text("Pista " + (cancionActualIndex + 1) + " de " + totalCanciones, 14 + tarjetaW / 2, musTarjetaY + 66);

                    // Ecualizador visual
                    fill(10, 12, 18);
                    stroke(modoOscuroConfig ? 45 : 170);
                    strokeWeight(1.5f);
                    rect(visX, musVisY, visW, musVisH, 6);

                    int totalBarras = 16;
                    float margenBarras = 8;
                    float pasoBarra = (visW - (margenBarras * 2)) / totalBarras;
                    float anchoBarra = pasoBarra * 0.72f;
                    float tiempoAnim = millis() * 0.007f;

                    for (int b = 0; b < totalBarras; b++) {
                      float barraX = visX + margenBarras + (b * pasoBarra);
                      float barraMaxH = musVisH - 24;

                      if (reproduciendoMusica) {
                        float factor = abs(sin(tiempoAnim * 2.2f + b * 0.75f) * 0.5f + cos(tiempoAnim * 3.4f + b * 1.3f) * 0.5f);
                        barraH = factor * barraMaxH;
                        if (barraH < 5) {
                          barraH = 5;
                        }
                      }

                      float barraY = musVisY + musVisH - 6 - barraH;
                      if (b < 4) {
                        fill(255, 60, 80);
                      } else {
                        if (b < 8) {
                          fill(255, 170, 30);
                        } else {
                          if (b < 12) {
                            fill(40, 220, 120);
                          } else {
                            fill(60, 180, 255);
                          }
                        }
                      }

                      noStroke();
                      rect(barraX, barraY, anchoBarra, barraH, 2);
                    }

                    // Progreso canción
                    float duracionSeg = 0;
                    float posicionSeg = 0;
                    float porcentajeCancion = 0;

                    if (reproductorMp3 != null) {
                      try {
                        duracionSeg = reproductorMp3.duration();
                        posicionSeg = reproductorMp3.position();
                        if (duracionSeg > 0.1f) {
                          porcentajeCancion = constrain(posicionSeg / duracionSeg, 0, 1);
                        }
                      } catch (Exception e) {
                      }
                    }

                    stroke(modoOscuroConfig ? 50 : 185);
                    strokeWeight(3.5f);
                    line(musProgX, musProgY, musProgX + musProgW, musProgY);

                    if (porcentajeCancion > 0) {
                      stroke(80, 200, 255);
                      line(musProgX, musProgY, musProgX + (musProgW * porcentajeCancion), musProgY);
                    }

                    float puntoX = musProgX + (musProgW * porcentajeCancion);
                    noStroke();
                    fill(80, 200, 255);
                    circle(puntoX, musProgY, 10);

                    int minActual = PApplet.parseInt(posicionSeg) / 60;
                    int segActual = PApplet.parseInt(posicionSeg) % 60;
                    int minTotal = PApplet.parseInt(duracionSeg) / 60;
                    int segTotal = PApplet.parseInt(duracionSeg) % 60;
                    String textoActual = (minActual < 10 ? "0" : "") + minActual + ":" + (segActual < 10 ? "0" : "") + segActual;
                    String textoTotal = (minTotal < 10 ? "0" : "") + minTotal + ":" + (segTotal < 10 ? "0" : "") + segTotal;

                    fill(modoOscuroConfig ? 160 : 90);
                    textSize(10);
                    textAlign(LEFT, BASELINE);
                    text(textoActual, musProgX, musProgY + 14);
                    textAlign(RIGHT, BASELINE);
                    text(textoTotal, musProgX + musProgW, musProgY + 14);

                    // Botones de música (anteriores, reproducir/pausar, siguiente)
                    float btnPrevX = musInicioBtnX;
                    float btnPlayX = musInicioBtnX + musBotonW + musEspacioBtn;
                    float btnSigX = musInicioBtnX + (musBotonW + musEspacioBtn) * 2;

                    fill(modoOscuroConfig ? 60 : 200);
                    noStroke();
                    rect(btnPrevX, musBotonY, musBotonW, musBotonH, 6);
                    rect(btnPlayX, musBotonY, musBotonW, musBotonH, 6);
                    rect(btnSigX, musBotonY, musBotonW, musBotonH, 6);

                    // Icono Anterior |< (vectorial)
                    fill(modoOscuroConfig ? 240 : 40);
                    float cPrevX = btnPrevX + musBotonW / 2;
                    float cPrevY = musBotonY + musBotonH / 2;
                    rect(cPrevX - 6, cPrevY - 6, 2.5f, 12, 1);
                    triangle(cPrevX + 5, cPrevY - 6, cPrevX + 5, cPrevY + 6, cPrevX - 3.5f, cPrevY);

                    // Icono Play / Pausa (vectorial, jamás se convierte en [])
                    float cPlayX = btnPlayX + musBotonW / 2;
                    float cPlayY = musBotonY + musBotonH / 2;
                    if (reproduciendoMusica) {
                      // Barras de Pausa ||
                      fill(modoOscuroConfig ? 240 : 40);
                      rect(cPlayX - 4.5f, cPlayY - 6, 3, 12, 1);
                      rect(cPlayX + 1.5f, cPlayY - 6, 3, 12, 1);
                    } else {
                      // Triángulo de Play >
                      fill(80, 220, 120);
                      triangle(cPlayX - 4, cPlayY - 7, cPlayX - 4, cPlayY + 7, cPlayX + 6, cPlayY);
                    }

                    // Icono Siguiente >| (vectorial)
                    fill(modoOscuroConfig ? 240 : 40);
                    float cSigX = btnSigX + musBotonW / 2;
                    float cSigY = musBotonY + musBotonH / 2;
                    triangle(cSigX - 5, cSigY - 6, cSigX - 5, cSigY + 6, cSigX + 3.5f, cSigY);
                    rect(cSigX + 3.5f, cSigY - 6, 2.5f, 12, 1);

                    // ===== CAMARA =====
                  } else {
                    if (appAbierta.equals("Cámara")) {
                      fill(15);
                      rect(12, 42, pantallaW - 24, 220, 8);
                      stroke(60);
                      strokeWeight(1);
                      line(pantallaW / 2 - 15, 152, pantallaW / 2 + 15, 152);
                      line(pantallaW / 2, 137, pantallaW / 2, 167);
                      fill(255);
                      textSize(14);
                      textAlign(CENTER, BASELINE);
                      text("Vista previa activa", pantallaW / 2, 235);

                      // Botón obturador
                      stroke(255);
                      strokeWeight(3);
                      fill(255, 60);
                      circle(pantallaW / 2, pantallaH - 65, 46);

                      // ===== MENSAJES (ESTILO CHAT COMPLETO E INTERACTIVO) =====
                    } else {
                      if (appAbierta.equals("Mensajes")) {
                        if (fuenteCelular != null)
                          textFont(fuenteCelular);
                        boolean esOscuro = modoOscuroConfig;

                        if (chatAbierto == -1) {
                          // --- VISTA LISTA DE CHATS ---
                          fill(esOscuro ? color(22, 26, 36) : color(255));
                          rect(0, 28, pantallaW, 38);
                          stroke(esOscuro ? color(38, 44, 58) : color(225, 228, 235));
                          strokeWeight(1);
                          line(0, 66, pantallaW, 66);
                          noStroke();

                          fill(80, 160, 255);
                          textSize(13);
                          textAlign(LEFT, CENTER);
                          text("< Celular", 10, 47);

                          fill(esOscuro ? 245 : 30);
                          textSize(15);
                          textAlign(CENTER, CENTER);
                          text("Mensajes", pantallaW / 2, 47);

                          // Lista de conversaciones
                          for (int ch = 0; ch < totalChats; ch++) {
                            float chY = 72 + ch * 60;

                            fill(esOscuro ? color(26, 31, 42) : color(248, 249, 252));
                            stroke(esOscuro ? color(36, 42, 56) : color(230, 232, 240));
                            strokeWeight(1);
                            rect(8, chY, pantallaW - 16, 54, 8);
                            noStroke();

                            // Avatar
                            fill(chatColores[ch]);
                            circle(32, chY + 27, 32);
                            fill(255);
                            textSize(12);
                            textAlign(CENTER, CENTER);
                            text(chatNombres[ch].substring(0, min(2, chatNombres[ch].length())), 32, chY + 26);

                            // Nombre y hora
                            fill(esOscuro ? 250 : 25);
                            textSize(12);
                            textAlign(LEFT, CENTER);
                            text(chatNombres[ch], 54, chY + 17);

                            fill(esOscuro ? 150 : 120);
                            textSize(9.5f);
                            textAlign(RIGHT, CENTER);
                            text(chatHoras[ch], pantallaW - 16, chY + 17);

                            // Mensaje previo
                            fill(esOscuro ? color(175, 185, 200) : color(100, 105, 115));
                            textSize(10);
                            textAlign(LEFT, CENTER);
                            String txtPrevio = chatMensajes[ch][TOTAL_MENSAJES_POR_CHAT - 1];
                            if (txtPrevio.startsWith("O: ") || txtPrevio.startsWith("S: ")) {
                              txtPrevio = txtPrevio.substring(3);
                            }
                            if (txtPrevio.length() > 28) {
                              txtPrevio = txtPrevio.substring(0, 26) + "...";
                            }
                            text(txtPrevio, 54, chY + 36);

                            // Píldora de mensaje no leído
                            if (chatTieneNoLeido[ch]) {
                              fill(80, 220, 120);
                              circle(pantallaW - 22, chY + 36, 15);
                              fill(10, 30, 15);
                              textSize(9.5f);
                              textAlign(CENTER, CENTER);
                              text("1", pantallaW - 22, chY + 35);
                            }
                          }

                        } else {
                          // --- VISTA DENTRO DEL CHAT SELECCIONADO ---
                          int ch = chatAbierto;

                          // Cabecera del chat
                          fill(esOscuro ? color(22, 26, 36) : color(255));
                          rect(0, 28, pantallaW, 40);
                          stroke(esOscuro ? color(38, 44, 58) : color(225, 228, 235));
                          strokeWeight(1);
                          line(0, 68, pantallaW, 68);
                          noStroke();

                          // Botón volver a lista
                          fill(80, 160, 255);
                          textSize(12.5f);
                          textAlign(LEFT, CENTER);
                          text("< Chats", 10, 48);

                          // Avatar del contacto
                          fill(chatColores[ch]);
                          circle(68, 48, 26);
                          fill(255);
                          textSize(11);
                          textAlign(CENTER, CENTER);
                          text(chatNombres[ch].substring(0, min(2, chatNombres[ch].length())), 68, 47);

                          // Nombre y estado
                          fill(esOscuro ? 250 : 25);
                          textSize(11.5f);
                          textAlign(LEFT, CENTER);
                          text(chatNombres[ch], 86, 42);

                          fill(80, 210, 120);
                          circle(88, 55, 5);
                          fill(esOscuro ? 160 : 120);
                          textSize(9);
                          text("en línea", 95, 55);

                          // Burbujas de mensajes de la conversación
                          float bubY = 76;
                          for (int m = 0; m < TOTAL_MENSAJES_POR_CHAT; m++) {
                            String mRaw = chatMensajes[ch][m];
                            boolean esSam = mRaw.startsWith("S: ");
                            String msg = mRaw.substring(3);

                            // Si es el mensaje final de Sam y aún no responde, no lo mostramos todavía
                            if (esSam && !chatRespondido[ch] && m == TOTAL_MENSAJES_POR_CHAT - 1) {
                              continue;
                            }

                            textSize(10);
                            float maxBubW = pantallaW * 0.74f;
                            float textW = min(maxBubW - 14, textWidth(msg) + 14);
                            float bubH = 26;
                            if (msg.length() > 30) {
                              bubH = 38;
                            }

                            if (!esSam) {
                              // Mensaje recibido (izquierda)
                              fill(esOscuro ? color(32, 38, 50) : color(235, 238, 245));
                              stroke(esOscuro ? color(44, 52, 68) : color(220, 225, 235));
                              strokeWeight(1);
                              rect(10, bubY, textW + 14, bubH, 8);
                              noStroke();

                              fill(esOscuro ? 245 : 30);
                              textAlign(LEFT, TOP);
                              text(msg, 16, bubY + 5, textW + 2, bubH);
                            } else {
                              // Mensaje de Sam enviado (derecha)
                              fill(30, 140, 240);
                              noStroke();
                              rect(pantallaW - 12 - (textW + 14), bubY, textW + 14, bubH, 8);

                              fill(255);
                              textAlign(LEFT, TOP);
                              text(msg, pantallaW - 6 - (textW + 14), bubY + 5, textW + 2, bubH);

                              // Checkmarks de visto
                              fill(190, 230, 255);
                              textSize(8);
                              textAlign(RIGHT, BOTTOM);
                              text("visto", pantallaW - 16, bubY + bubH - 2);
                            }

                            bubY += bubH + 8;
                          }

                          // Barra inferior interactiva de respuesta
                          float replyY = pantallaH - 42;
                          fill(esOscuro ? color(20, 24, 32) : color(255));
                          rect(0, replyY, pantallaW, 42);
                          stroke(esOscuro ? color(38, 44, 58) : color(225, 228, 235));
                          strokeWeight(1);
                          line(0, replyY, pantallaW, replyY);
                          noStroke();

                          if (!chatRespondido[ch]) {
                            // Botón interactivo de responder
                            fill(80, 160, 255);
                            rect(10, replyY + 6, pantallaW - 20, 30, 15);
                            fill(255);
                            textSize(9.5f);
                            textAlign(CENTER, CENTER);
                            text("Toca para responder: \"" + chatRespuestasSam[ch] + "\"", pantallaW / 2, replyY + 21);
                          } else {
                            // Ya respondido
                            fill(esOscuro ? color(28, 34, 46) : color(240, 242, 248));
                            rect(10, replyY + 6, pantallaW - 20, 30, 15);
                            fill(esOscuro ? 140 : 120);
                            textSize(10);
                            textAlign(CENTER, CENTER);
                            text("Mensaje enviado (visto)", pantallaW / 2, replyY + 21);
                          }
                        }

                        // ===== GALERIA =====
                      } else {
                        if (appAbierta.equals("Galería")) {
                          fill(modoOscuroConfig ? 255 : 30);
                          textSize(16);
                          textAlign(LEFT, BASELINE);
                          text("Galería de Fotos", 14, 46);

                          fill(modoOscuroConfig ? 40 : 210);
                          rect(12, 56, pantallaW - 24, 150, 6);
                          fill(modoOscuroConfig ? 255 : 0);
                          textSize(13);
                          textAlign(CENTER, BASELINE);
                          text("Foto #01 - Mañana de Navidad", pantallaW / 2, 195);

                          // ===== PIXAGRAM (NUEVO DISEÑO ORGANICO / WARM PAPER) =====
                        } else {
                          if (appAbierta.equals("Pixagram")) {
                            fill(COLOR_APP_BG);
                            noStroke();
                            rect(0, 28, pantallaW, pantallaH - 28);

                            // Cabecera superior de Pixagram (Y = 28 a 54)
                            fill(COLOR_CARD);
                            stroke(COLOR_BORDER);
                            strokeWeight(1);
                            rect(0, 28, pantallaW, 26);
                            noStroke();

                            fill(COLOR_PRIMARY);
                            textFont(fontBold);
                            textSize(13);
                            textAlign(LEFT, CENTER);
                            text("< Celular", 10, 41);

                            fill(COLOR_PRIMARY_DARK);
                            textFont(fontTitle);
                            textSize(17);
                            textAlign(CENTER, CENTER);
                            text("Pixagram", pantallaW / 2, 41);

                            float contentY = 54;
                            float contentH = pantallaH - 54 - 48;

                            pushMatrix();
                            switch (currentTab) {
                              case 0 : {
                                // INICIO PIXAGRAM
                                pushMatrix();
                                translate(0, contentY);
                                dibujarInicioPixagram();
                                popMatrix();
                                break;
                              }

                              case 1 : {
                                // FEED PIXAGRAM (Publicación Penaltis + Decisión + 6 Perfiles Comunitarios)
                                pushMatrix();
                                translate(0, contentY + scrollYFeed);
                                dibujarFeedPixagram(contentH);
                                popMatrix();
                                break;
                              }

                              case 2 : {
                                // PANTALLA PUBLICAR (Informativa)
                                pushMatrix();
                                translate(0, contentY);
                                fill(COLOR_CARD);
                                stroke(COLOR_BORDER);
                                rect(12, 24, pantallaW - 24, 110, 10);
                                textFont(fontBold);
                                textSize(10.5f);
                                fill(COLOR_PRIMARY_DARK);
                                textAlign(CENTER, TOP);
                                text("Solo Mateo y Cristian publican aquí", pantallaW / 2, 42);
                                textFont(fontBody);
                                textSize(9.5f);
                                fill(COLOR_TEXT_MUTED);
                                text("La publicación del Nivel 1 es subida automáticamente por Mateo y Cristian según el resultado de los penaltis.",
                                    22, 66, pantallaW - 44, 56);
                                popMatrix();
                                break;
                              }

                              case 3 : {
                                // MENSAJES PRIVADOS
                                pushMatrix();
                                translate(0, contentY);

                                if (activeChatIndex == -1) {
                                  textFont(fontTitle);
                                  fill(COLOR_TEXT_DARK);
                                  textAlign(LEFT, TOP);
                                  text("Mensajes Privados", 12, 10);

                                  float curYMsg = 30;

                                  for (int cIdx = 0; cIdx < TOTAL_CONVERSACIONES; cIdx++) {
                                    fill(COLOR_CARD);
                                    stroke(COLOR_BORDER);
                                    rect(12, curYMsg, pantallaW - 24, 50, 6);

                                    pushStyle();
                                    if (convAvatarImg[cIdx] != null && convAvatarImg[cIdx].width > 0) {
                                      image(convAvatarImg[cIdx], 20, curYMsg + 9, 32, 32);
                                      noFill();
                                      stroke(COLOR_BORDER);
                                      strokeWeight(1.5f);
                                      rect(20, curYMsg + 9, 32, 32, 6);
                                    } else {
                                      fill(0xFFDDD8CD);
                                      stroke(COLOR_BORDER);
                                      ellipse(20 + 16, curYMsg + 9 + 16, 32, 32);
                                    }
                                    popStyle();

                                    textFont(fontBold);
                                    textSize(10);
                                    fill(COLOR_TEXT_DARK);
                                    textAlign(LEFT, TOP);
                                    text(convContactName[cIdx], 60, curYMsg + 10);

                                    String lastMsg = (convMessageCount[cIdx] > 0) ? convMsgText[cIdx][convMessageCount[cIdx] - 1] : "Sin mensajes";
                                    textFont(fontBody);
                                    textSize(9);
                                    fill(COLOR_TEXT_MUTED);
                                    text(lastMsg, 60, curYMsg + 25, pantallaW - 80, 16);

                                    curYMsg += 58;
                                  }
                                } else {
                                  // Conversación activa
                                  fill(COLOR_CARD);
                                  stroke(COLOR_BORDER);
                                  rect(0, 0, pantallaW, 34);

                                  textFont(fontBold);
                                  textSize(12);
                                  fill(COLOR_PRIMARY);
                                  textAlign(LEFT, CENTER);
                                  text("<", 12, 17);

                                  pushStyle();
                                  if (convAvatarImg[activeChatIndex] != null && convAvatarImg[activeChatIndex].width > 0) {
                                    image(convAvatarImg[activeChatIndex], 30, 5, 24, 24);
                                    noFill();
                                    stroke(COLOR_BORDER);
                                    strokeWeight(1.5f);
                                    rect(30, 5, 24, 24, 4);
                                  } else {
                                    fill(0xFFDDD8CD);
                                    stroke(COLOR_BORDER);
                                    ellipse(30 + 12, 5 + 12, 24, 24);
                                  }
                                  popStyle();

                                  textFont(fontBold);
                                  textSize(10);
                                  fill(COLOR_TEXT_DARK);
                                  text(convContactName[activeChatIndex], 62, 17);

                                  float msgY = 42;

                                  for (int mIdx = 0; mIdx < convMessageCount[activeChatIndex]; mIdx++) {
                                    boolean isMe = convMsgSender[activeChatIndex][mIdx].equals(playerName);

                                    float bubbleW = min(textWidth(convMsgText[activeChatIndex][mIdx]) + 18, pantallaW - 80);
                                    bubbleW = max(bubbleW, 45);
                                    float bubbleH = 26;
                                    float bubbleX = isMe ? (pantallaW - bubbleW - 12) : 12;

                                    fill(isMe ? COLOR_PRIMARY : COLOR_CARD);
                                    stroke(isMe ? COLOR_PRIMARY : COLOR_BORDER);
                                    rect(bubbleX, msgY, bubbleW, bubbleH, 6);

                                    fill(isMe ? 255 : COLOR_TEXT_DARK);
                                    textFont(fontBody);
                                    textSize(9);
                                    textAlign(LEFT, CENTER);
                                    text(convMsgText[activeChatIndex][mIdx], bubbleX + 9, msgY + bubbleH / 2);

                                    msgY += bubbleH + 6;
                                  }

                                  float inputY = contentH - 36;
                                  fill(COLOR_CARD);
                                  stroke(COLOR_BORDER);
                                  rect(12, inputY, pantallaW - 68, 28, 5);

                                  fill(COLOR_TEXT_DARK);
                                  textFont(fontBody);
                                  textSize(9);
                                  textAlign(LEFT, CENTER);
                                  text(newChatMessage + (frameCount % 60 < 30 ? "|" : ""), 20, inputY + 14);

                                  if (newChatMessage.length() == 0) {
                                    fill(COLOR_TEXT_MUTED);
                                    text("Escribe un mensaje...", 20, inputY + 14);
                                  }

                                  fill(COLOR_PRIMARY);
                                  noStroke();
                                  rect(pantallaW - 50, inputY, 38, 28, 5);

                                  fill(255);
                                  textFont(fontBold);
                                  textSize(9);
                                  textAlign(CENTER, CENTER);
                                  text("Enviar", pantallaW - 31, inputY + 14);
                                }

                                popMatrix();
                                break;
                              }
                            }
                            popMatrix();

                            // Barra de desplazamiento lateral moderna en el Feed
                            if (currentTab == 1 && maxScrollYFeed > 0) {
                              float trackH = contentH - 8;
                              float thumbH = max(24, trackH * (contentH / (contentH + maxScrollYFeed)));
                              float thumbY = contentY + 4 + map(-scrollYFeed, 0, maxScrollYFeed, 0, trackH - thumbH);
                              noStroke();
                              fill(COLOR_PRIMARY_DARK, 90);
                              rect(pantallaW - 5, thumbY, 3, thumbH, 2);
                            }

                            // Cabecera superior fija
                            fill(COLOR_CARD);
                            stroke(COLOR_BORDER);
                            strokeWeight(1);
                            rect(0, 28, pantallaW, 26);
                            noStroke();

                            fill(COLOR_PRIMARY);
                            textFont(fontBold);
                            textSize(13);
                            textAlign(LEFT, CENTER);
                            text("< Celular", 10, 41);

                            fill(COLOR_PRIMARY_DARK);
                            textFont(fontTitle);
                            textSize(17);
                            textAlign(CENTER, CENTER);
                            text("Pixagram", pantallaW / 2, 41);

                            // Barra superior de estado fija sobre Y=0..28
                            dibujarBarraEstadoCelular();
                            // Barra inferior de navegación (iconos dibujados por código para evitar cuadros rotos)
                            fill(COLOR_CARD);
                            stroke(COLOR_BORDER);
                            strokeWeight(1);
                            rect(0, pantallaH - 48, pantallaW, 48);

                            String[] tabNames = {"Inicio", "Feed"};
                            int[] tabIndices = {0, 1};
                            final int TOTAL_TABS_PIXA = 2;
                            float btnW = pantallaW / 2.0f;

                            for (int tb = 0; tb < TOTAL_TABS_PIXA; tb++) {
                              float bX = tb * btnW;
                              boolean isSelected = (currentTab == tabIndices[tb]);
                              float icX = bX + btnW / 2;
                              float icY = pantallaH - 48 + 15;
                              int colIc = isSelected ? COLOR_PRIMARY : COLOR_TEXT_MUTED;

                              pushStyle();
                              stroke(colIc);
                              strokeWeight(1.8f);
                              noFill();
                              if (tb == 0) {
                                ellipse(icX, icY, 12, 12);
                                fill(colIc);
                                noStroke();
                                ellipse(icX, icY, 5, 5);
                              } else {
                                rect(icX - 7, icY - 6, 14, 12, 2);
                                line(icX - 4, icY - 2, icX + 4, icY - 2);
                                line(icX - 4, icY + 2, icX + 4, icY + 2);
                              }
                              popStyle();

                              textAlign(CENTER, CENTER);
                              textFont(isSelected ? fontBold : fontBody);
                              textSize(13);
                              fill(isSelected ? COLOR_PRIMARY_DARK : COLOR_TEXT_MUTED);
                              text(tabNames[tb], bX + btnW / 2, pantallaH - 48 + 33);

                              if (isSelected) {
                                fill(COLOR_ACCENT);
                                noStroke();
                                ellipse(bX + btnW / 2, pantallaH - 4, 4, 4);
                              }
                            }
                            if (fuenteCelular != null) {
                              textFont(fuenteCelular);
                            }
                          } else {
                            if (appAbierta.equals("Parejas")) {
                              dibujarJuegoParejas(pantallaW, pantallaH);
                            } else {
                              if (appAbierta.equals("Pixel Art")) {
                                dibujarJuegoPixelArt(pantallaW, pantallaH);
                              } else {
                                if (appAbierta.equals("Frutas")) {
                                  dibujarJuegoFrutas(pantallaW, pantallaH);
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              // BotÃ³n universal para apps tradicionales
              if (!appAbierta.equals("Pixagram") && !appAbierta.equals("Mensajes") && !appAbierta.equals("Parejas") && !appAbierta.equals("Pixel Art")
                  && !appAbierta.equals("Frutas")) {
                fill(55, 70, 95);
                noStroke();
                rect(12, pantallaH - 32, 70, 24, 4);
                fill(255);
                textSize(12);
                textAlign(LEFT, CENTER);
                text("< Atrás", 22, pantallaH - 20);
              }
            }

            // --- EFECTO DE CORAZONES FLOTANTES AL DAR LIKE ---
            for (int ci = 0; ci < MAX_CORAZONES; ci++) {
              if (corazonesActivo[ci]) {
                float cx = corazonesX[ci];
                float cy = corazonesY[ci];
                float calfa = corazonesAlfa[ci];

                fill(240, 50, 75, calfa);
                noStroke();
                ellipse(cx - 4, cy - 3, 7, 7);
                ellipse(cx + 4, cy - 3, 7, 7);
                triangle(cx - 7, cy - 2, cx + 7, cy - 2, cx, cy + 6);

                corazonesY[ci] -= 1.5f;
                corazonesAlfa[ci] -= 6;
                if (corazonesAlfa[ci] <= 10) {
                  corazonesActivo[ci] = false;
                }
              }
            }

            // --- NOTIFICACIÓN FLOTANTE PUSH BANNER (BAJA SUAVEMENTE) ---
            if (millis() < notifPushFin) {
              if (notifPushY < 8) {
                notifPushY += 7;
              }
              fill(25, 30, 42, 245);
              stroke(225, 48, 108);
              strokeWeight(2);
              rect(10, notifPushY, pantallaW - 20, 46, 10);

              fill(255, 60, 100);
              circle(22, notifPushY + 14, 8);
              fill(255);
              noStroke();
              textSize(11);
              textAlign(LEFT, TOP);
              text(notifPushTitulo, 32, notifPushY + 8);
              fill(220);
              textSize(10);
              text(notifPushSub, 18, notifPushY + 24, pantallaW - 36, 20);
            } else {
              if (notifPushY > -90) {
                notifPushY -= 7;
              }
            }

            // --- EFECTO DE SOBREESTÃMULO / ANSIEDAD SI EL BIENESTAR ES BAJO ---
            if (bienestarDigital < 35) {
              float pulso = sin(millis() * 0.006f);
              fill(255, 30, 30, map(pulso, -1, 1, 20, 55));
              noStroke();
              rect(0, 0, pantallaW, pantallaH);
            }

            popMatrix();
            noClip();
            popStyle();
            if (fuenteComic != null) {
              textFont(fuenteComic);
            }

            // 2. MARCO ILUSTRADO DEL CELULAR (DIBUJADO POR EL USUARIO - pre-escalado en setup)
            if (marcoCelular != null && marcoCelular.width > 0) {
              if (abs(marcoCelular.width - telefonoAncho) <= 2 && abs(marcoCelular.height - telefonoAlto) <= 2) {
                image(marcoCelular, round(telefonoX), round(telefonoY));
              } else {
                image(marcoCelular, telefonoX, telefonoY, telefonoAncho, telefonoAlto);
              }
            } else {
              // Fallback si la imagen no se encontrara
              pushStyle();
              rectMode(CORNER);
              stroke(15);
              strokeWeight(6);
              noFill();
              rect(telefonoX, telefonoY, telefonoAncho, telefonoAlto, 16);
              popStyle();
            }

            // HUD lateral de métricas digitales también visible junto al celular
            dibujarHUDExploracion();

            // Título y controles fuera del celular
            fill(255);
            textAlign(CENTER, CENTER);
            textSize(24 * escalaX);
            text("CELULAR DE SAM", width / 2, height * 0.035f);

            // Botón interactivo inferior del celular
            float btnGuardarW = BOTON_GUARDAR_CELULAR_W * escalaX;
            float btnGuardarH = BOTON_GUARDAR_CELULAR_H * escalaY;
            float btnGuardarX = (width - btnGuardarW) / 2;
            float btnGuardarY = height - btnGuardarH - BOTON_GUARDAR_CELULAR_MARGEN;

            boolean hoverBtnInf = (mouseX >= btnGuardarX && mouseX <= btnGuardarX + btnGuardarW && mouseY >= btnGuardarY
                && mouseY <= btnGuardarY + btnGuardarH);

            if (penaltisJugados && !decisionPixagramTomada) {
              fill(65, 30, 25, 240);
              stroke(255, 160, 60);
            } else {
              if (penaltisJugados && decisionPixagramTomada) {
                fill(hoverBtnInf ? color(40, 145, 75, 245) : color(25, 110, 55, 240));
                stroke(110, 255, 150);
              } else {
                fill(hoverBtnInf ? color(35, 55, 90, 240) : color(20, 25, 38, 230));
                stroke(80, 160, 255);
              }
            }
            strokeWeight(2);
            rect(btnGuardarX, btnGuardarY, btnGuardarW, btnGuardarH, 19);
            noStroke();

            fill(255);
            textSize(13.5f * escalaX);
            textAlign(CENTER, CENTER);
            if (penaltisJugados) {
              if (!decisionPixagramTomada) {
                dibujarIconoAlerta(btnGuardarX + 26 * escalaX, btnGuardarY + btnGuardarH / 2, 8 * escalaX, color(255, 215, 110));
                fill(255, 215, 110);
                text("Toma una decisión en el Feed de Pixagram sobre la foto", width / 2 + 10 * escalaX, btnGuardarY + btnGuardarH / 2);
              } else {
                if (!dia1Terminado) {
                  fill(210, 255, 220);
                  text("Finalizar Día 1 >> ('C' o ENTER)", width / 2, btnGuardarY + btnGuardarH / 2);
                } else {
                  if (juegosDesbloqueados) {
                    fill(180, 220, 255);
                    text("¿Quedarse jugando o irse a dormir? ('C' o Clic)", width / 2, btnGuardarY + btnGuardarH / 2);
                  } else {
                    fill(180, 220, 255);
                    text("Guardar Celular ('C' o Clic)", width / 2, btnGuardarY + btnGuardarH / 2);
                  }
                }
              }
            } else {
              fill(180, 220, 255);
              text("Guardar Celular / Bajar a desayunar ('C' o Clic)", width / 2, btnGuardarY + btnGuardarH / 2);
            }

            if (mostrandoModalDormir) {
              dibujarModalDormir();
            }
          }
        }

        // -----------------------------------------------------
        // NOVELA VISUAL: NOCHE, MAÑANA, COLEGIO Y PENALTIS
        // -----------------------------------------------------
        if (estadoActual == NOVELA_ESCUELA) {
          int idxEscena = escenaPorPaginaEscuela[paginaEscuela];
          PImage imgFondo = escenasNovela[idxEscena];

          // Fondo: blit directo 3-arg y capa ambiental ligera (sin tint() sobre imagen 1080p en JAVA2D)
          pushStyle();
          if (imgFondo != null && imgFondo.width > 0) {
            image(imgFondo, 0, 0);
            if (idxEscena == 1) {
              noStroke();
              fill(255, 220, 140, 28); // Amanecer dorado en la habitación
              rect(0, 0, width, height);
            }
          } else {
            if (fondoEscena != null && fondoEscena.width > 0) {
              image(fondoEscena, 0, 0);
              noStroke();
              if (idxEscena == 0) {
                fill(15, 25, 70, 115); // Noche azulada (yendo a dormir)
                rect(0, 0, width, height);
              } else {
                if (idxEscena == 1) {
                  fill(255, 220, 140, 28); // Amanecer dorado (despertándose)
                  rect(0, 0, width, height);
                } else {
                  if (idxEscena == 2) {
                    fill(255, 200, 130, 32); // Desayuno hogareño cálido con los padres
                    rect(0, 0, width, height);
                  } else {
                    if (idxEscena == 4) {
                      fill(140, 240, 150, 24); // Cancha de césped exterior y reto de penaltis
                      rect(0, 0, width, height);
                    }
                  }
                }
              }
            } else {
              background(15, 20, 32);
            }
          }
          popStyle();

          // Si estamos en la escena 2 (Desayuno familiar), mostrar a Mamá y Papá en el comedor
          if (idxEscena == 2) {
            float anchoRetratoEsc = 220 * escalaX;
            float posYRetratoEsc = height * 0.28f;
            String habEsc = hablantesEscuela[paginaEscuela];

            if (imgMama != null && imgMama.width > 0) {
              boolean hablaMamaEsc = (habEsc.indexOf("MAMÁ") >= 0 || habEsc.indexOf("Mamá") >= 0);
              image(imgMama, width * 0.22f - (anchoRetratoEsc / 2), posYRetratoEsc + (hablaMamaEsc ? 0 : 12 * escalaY));
            }
            if (imgPapa != null && imgPapa.width > 0) {
              boolean hablaPapaEsc = (habEsc.indexOf("PAPÁ") >= 0 || habEsc.indexOf("Papá") >= 0);
              image(imgPapa, width * 0.78f - (anchoRetratoEsc / 2), posYRetratoEsc + (hablaPapaEsc ? 0 : 12 * escalaY));
            }
          }

          // Etiqueta del momento / lugar en la esquina superior izquierda
          pushStyle();
          fill(0, 180);
          stroke(255, 220, 100);
          strokeWeight(1.5f);
          rect(24, 20, 260 * escalaX, 36 * escalaY, 8);
          noStroke();
          fill(255, 220, 100);
          textSize(14 * escalaX);
          textAlign(CENTER, CENTER);
          String lugarTxt = "";
          if (idxEscena == 0)
            lugarTxt = "Habitación de Sam - Noche";
          else {
            if (idxEscena == 1)
              lugarTxt = "Habitación de Sam - Mañana";
            else {
              if (idxEscena == 2)
                lugarTxt = "Comedor - Desayuno familiar";
              else {
                if (idxEscena == 3)
                  lugarTxt = "Colegio - Patio con amigos";
                else
                  lugarTxt = "Cancha de Fútbol - Penaltis";
              }
            }
          }
          text(lugarTxt, 24 + (130 * escalaX), 20 + (18 * escalaY));
          popStyle();

          // Cuadro de diálogo de novela visual
          float cajaAncho = width * 0.85f;
          float cajaAlto = height * 0.25f;
          float cajaX = (width - cajaAncho) / 2;
          float cajaY = height - cajaAlto - 40;

          fill(0, 215);
          stroke(45, 55, 75);
          strokeWeight(2);
          rectMode(CORNER);
          rect(cajaX, cajaY, cajaAncho, cajaAlto, 15);
          noStroke();

          // Nombre del hablante
          fill(100, 220, 120);
          textAlign(LEFT, TOP);
          textSize(25 * escalaX);
          text(hablantesEscuela[paginaEscuela], cajaX + 30, cajaY + 20);

          // Texto del diálogo con efecto máquina de escribir
          String textoFullEscuela = paginasEscuela[paginaEscuela];
          if (!textoFullEscuela.equals(ultimoTextoDialogo)) {
            ultimoTextoDialogo = textoFullEscuela;
            if (paginaEscuela == 5) {
              reproducirSfx(SFX_ALARMA_CELULAR, 0.7f);
            } // Página de la alarma del celular
            charsVisibles = 0;
            dialogoCompletado = false;
          }
          if (!dialogoCompletado && !enPausa) {
            charsVisibles += velTypewriter;
            if (charsVisibles >= textoFullEscuela.length()) {
              charsVisibles = textoFullEscuela.length();
              dialogoCompletado = true;
            }
          }
          int nCharsEsc = constrain(PApplet.parseInt(charsVisibles), 0, textoFullEscuela.length());
          String textoParcialEsc = textoFullEscuela.substring(0, nCharsEsc);

          fill(245);
          textSize(21 * escalaX);
          text(textoParcialEsc, cajaX + 30, cajaY + 60, cajaAncho - 60, cajaAlto - 80);

          // Indicador inferior
          fill(160);
          textAlign(RIGHT, BOTTOM);
          textSize(14 * escalaX);
          if (!dialogoCompletado) {
            text("Clic o ENTER: Completar | 'M' Menú (" + (paginaEscuela + 1) + "/" + totalPaginasEscuela + ")", cajaX + cajaAncho - 20,
                cajaY + cajaAlto - 15);
          } else {
            if (paginaEscuela < totalPaginasEscuela - 1) {
              text("Clic o ENTER: Avanzar | 'M' Menú (" + (paginaEscuela + 1) + "/" + totalPaginasEscuela + ")", cajaX + cajaAncho - 20,
                  cajaY + cajaAlto - 15);
            } else {
              text("Clic o ENTER: ¡Comenzar Duelo de Penaltis! (NIVEL 1)", cajaX + cajaAncho - 20, cajaY + cajaAlto - 15);
            }
          }
        }

        // -----------------------------------------------------
        // PANTALLA DE TRANSICION EN NEGRO: "NIVEL 1"
        // -----------------------------------------------------
        if (estadoActual == NIVEL1_INTRO) {
          background(0);
          timerNivel1Intro++;
          if (timerNivel1Intro == 1) {
            reproducirSfx(SFX_INTRO_NIVEL, 0.7f);
          }

          float progresoIntro = constrain(timerNivel1Intro / PApplet.parseFloat(DURACION_NIVEL1_INTRO), 0, 1);
          float alfaTexto = 255;
          if (timerNivel1Intro < 30) {
            alfaTexto = map(timerNivel1Intro, 0, 30, 0, 255);
          } else {
            if (timerNivel1Intro > DURACION_NIVEL1_INTRO - 30) {
              alfaTexto = map(timerNivel1Intro, DURACION_NIVEL1_INTRO - 30, DURACION_NIVEL1_INTRO, 255, 0);
            }
          }

          pushStyle();
          textAlign(CENTER, CENTER);

          // Resplandor sutil detrás del título
          fill(255, 190, 40, alfaTexto * 0.25f);
          textSize(86 * escalaX);
          text("NIVEL 1", width / 2 + 4, height / 2 - 20 * escalaY + 4);

          fill(255, 220, 70, alfaTexto);
          textSize(84 * escalaX);
          text("NIVEL 1", width / 2, height / 2 - 20 * escalaY);

          fill(220, 235, 255, alfaTexto * 0.9f);
          textSize(26 * escalaX);
          text("DUELO DE PENALTIS EN LA CANCHA", width / 2, height / 2 + 52 * escalaY);

          // Línea decorativa animada
          stroke(255, 200, 60, alfaTexto * 0.8f);
          strokeWeight(3);
          float anchoLinea = 340 * escalaX * sin(progresoIntro * PI);
          line(width / 2 - anchoLinea / 2, height / 2 + 18 * escalaY, width / 2 + anchoLinea / 2, height / 2 + 18 * escalaY);
          popStyle();

          if (timerNivel1Intro >= DURACION_NIVEL1_INTRO && !enTransicion) {
            penEstadoActual = 0;
            tiroActual = 1;
            goles = 0;
            atajadas = 0;
            fallos = 0;
            arcoAncho = 700 * escalaX;
            arcoAlto = 270 * escalaY;
            arcoX = width / 2 - arcoAncho / 2;
            arcoY = 210 * escalaY;
            puntoPenaltiX = width / 2;
            puntoPenaltiY = height - 135 * escalaY;
            pateadorBaseX = puntoPenaltiX - 95 * escalaX;
            pateadorBaseY = puntoPenaltiY - 30 * escalaY;
            pateadorX = pateadorBaseX;
            pateadorY = pateadorBaseY;
            arqueroAncho = 76 * escalaX;
            arqueroAlto = 175 * escalaY;
            arqueroX = width / 2;
            arqueroY = arcoY + arcoAlto - (arqueroAlto / 2);
            balonTamanoInicial = 54 * escalaY;
            balonTamanoFinal = 26 * escalaY;
            balonTamanoActual = balonTamanoInicial;
            balonX = puntoPenaltiX;
            balonY = puntoPenaltiY;
            estadoDestino = PENALTIS;
            enTransicion = true;
          }
        }

        // -----------------------------------------------------
        // MINIJUEGO DE PENALTIS (SIN SUBRUTINAS NI CLASES PERSONALIZADAS)
        // -----------------------------------------------------
        if (estadoActual == PENALTIS) {
          pushStyle();

          if (fuenteComic != null) {
            textFont(fuenteComic);
          }

          // Dimensiones del arco adaptadas exactamente a la pantalla
          arcoAncho = 700 * escalaX;
          arcoAlto = 270 * escalaY;
          arcoX = width / 2 - arcoAncho / 2;
          arcoY = 210 * escalaY;
          puntoPenaltiX = width / 2;
          puntoPenaltiY = height - 135 * escalaY;
          pateadorBaseX = puntoPenaltiX - 95 * escalaX;
          pateadorBaseY = puntoPenaltiY - 30 * escalaY;
          arqueroAncho = 76 * escalaX;
          arqueroAlto = 175 * escalaY;

          // Determinar portero en turno según tiroActual:
          // Impares (1, 3, 5) -> MATEO | Pares (2, 4) -> CRISTIAN
          boolean turnoMateo = (tiroActual % 2 != 0);
          radioAtajada = turnoMateo ? (70 * escalaY) : (90 * escalaY);

          // 1. DIBUJAR ESCENARIO Y CANCHA
          if (imgFondoCancha != null) {
            imageMode(CORNER);
            image(imgFondoCancha, 0, 0);
          } else {
            background(18, 24, 48);
            noStroke();
            fill(28, 38, 70);
            rect(0, 120 * escalaY, width, 160 * escalaY);
            fill(255, 250, 200, 35);
            triangle(200 * escalaX, 0, 0, 480 * escalaY, 650 * escalaX, 480 * escalaY);
            triangle(width - 200 * escalaX, 0, width - 650 * escalaX, 480 * escalaY, width, 480 * escalaY);
            fill(35, 30, 50);
            rect(0, 230 * escalaY, width, 160 * escalaY);
            for (float px = 30 * escalaX; px < width; px += 32 * escalaX) {
              for (float py = 250 * escalaY; py < 370 * escalaY; py += 26 * escalaY) {
                fill((px * 19 + py * 7) % 200 + 55, (px * 31) % 180 + 50, (py * 13) % 200 + 55);
                float saltoFan = sin(frameCount * 0.1f + px) * 2;
                ellipse(px, py + saltoFan, 14 * escalaY, 14 * escalaY);
              }
            }
            stroke(20);
            strokeWeight(3 * escalaY);
            fill(210, 50, 40);
            rect(0, 375 * escalaY, width, 35 * escalaY);
            noStroke();
            for (int i = 0; i < 9; i++) {
              fill(i % 2 == 0 ? color(38, 148, 48) : color(46, 166, 56));
              float yFranja1 = 410 * escalaY + i * (52 * escalaY);
              rect(0, yFranja1, width, 53 * escalaY);
            }
            stroke(255, 210);
            strokeWeight(5 * escalaY);
            line(0, arcoY + arcoAlto, width, arcoY + arcoAlto);
            noFill();
            quad(width / 2 - 520 * escalaX, arcoY + arcoAlto, width / 2 + 520 * escalaX, arcoY + arcoAlto, width / 2 + 720 * escalaX, height,
                width / 2 - 720 * escalaX, height);
          }

          // Dibujar Red y Arco (Siempre visibles encima del fondo para precisión física)
          stroke(230, 180);
          strokeWeight(2 * escalaY);
          fill(255, 255, 255, 35);
          rectMode(CORNER);
          rect(arcoX, arcoY, arcoAncho, arcoAlto);
          for (float x = arcoX; x <= arcoX + arcoAncho; x += 28 * escalaX) {
            line(x, arcoY, x, arcoY + arcoAlto);
          }
          for (float y = arcoY; y <= arcoY + arcoAlto; y += 28 * escalaY) {
            line(arcoX, y, arcoX + arcoAncho, y);
          }

          // Sombra de los postes en el suelo
          stroke(0, 60);
          strokeWeight(14 * escalaY);
          line(arcoX, arcoY + arcoAlto, arcoX - 40 * escalaX, arcoY + arcoAlto + 25 * escalaY);
          line(arcoX + arcoAncho, arcoY + arcoAlto, arcoX + arcoAncho + 40 * escalaX, arcoY + arcoAlto + 25 * escalaY);

          // Postes y Travesaño
          stroke(30);
          strokeWeight(grosorPostes + 6 * escalaY);
          line(arcoX, arcoY + arcoAlto, arcoX, arcoY);
          line(arcoX + arcoAncho, arcoY + arcoAlto, arcoX + arcoAncho, arcoY);
          line(arcoX - grosorPostes / 2, arcoY, arcoX + arcoAncho + grosorPostes / 2, arcoY);

          stroke(255);
          strokeWeight(grosorPostes);
          line(arcoX, arcoY + arcoAlto, arcoX, arcoY);
          line(arcoX + arcoAncho, arcoY + arcoAlto, arcoX + arcoAncho, arcoY);
          line(arcoX - grosorPostes / 2, arcoY, arcoX + arcoAncho + grosorPostes / 2, arcoY);

          // Punto blanco de penalti
          noStroke();
          fill(255, 230);
          ellipse(puntoPenaltiX, puntoPenaltiY, 22 * escalaX, 12 * escalaY);

          // 2. ACTUALIZAR LÓGICA SEGÚN EL ESTADO
          if (penEstadoActual == 0 || penEstadoActual == 1) {
            arqueroOrigenX = width / 2;
            arqueroOrigenY = arcoY + arcoAlto - (arqueroAlto / 2);
            float velMovArq = (penDificultadActual == 2) ? 0.14f : 0.08f;
            if (turnoMateo)
              velMovArq *= 1.15f;
            arqueroX = lerp(arqueroX, arqueroOrigenX + sin(frameCount * velMovArq) * (35 * escalaX), 0.1f);
            arqueroY = arqueroOrigenY;
            pateadorX = pateadorBaseX;
            pateadorY = pateadorBaseY;
          }

          if (penEstadoActual == 1) {
            if (penSubEstadoApuntado == 0) {
              anguloDireccion = sin(frameCount * 0.075f * penMultVelocidadMira);
              apTargetX = map(anguloDireccion, -1, 1, arcoX - 80 * escalaX, arcoX + arcoAncho + 80 * escalaX);
              apTargetY = arcoY + arcoAlto / 2;
            } else {
              if (penSubEstadoApuntado == 1) {
                anguloAltura = sin(frameCount * 0.095f * penMultVelocidadMira);
                apTargetY = map(anguloAltura, -1, 1, arcoY - 45 * escalaY, arcoY + arcoAlto);
              } else {
                if (penSubEstadoApuntado == 2) {
                  porcentajePotencia = (sin(frameCount * 0.115f * penMultVelocidadMira) + 1.0f) / 2.0f;
                }
              }
            }

            penTiempoRestanteAccion--;
            if (penTiempoRestanteAccion <= 0) {
              reproducirSfx(SFX_PEN_TIEMPO_AGOTADO, 0.6f);
              accionApuntadoDisparada = true;
            }

            if (accionApuntadoDisparada) {
              accionApuntadoDisparada = false;
              if (penSubEstadoApuntado == 0) {
                penSubEstadoApuntado = 1;
                reproducirSfx(SFX_PEN_FIJAR, 0.5f);
                penTiempoRestanteAccion = penTiempoLimiteFrames;
              } else {
                if (penSubEstadoApuntado == 1) {
                  penSubEstadoApuntado = 2;
                  reproducirSfx(SFX_PEN_FIJAR, 0.5f);
                  penTiempoRestanteAccion = penTiempoLimiteFrames;
                } else {
                  if (penSubEstadoApuntado == 2) {
                    balonOrigenX = puntoPenaltiX;
                    balonOrigenY = puntoPenaltiY;

                    float umbralFalloPotencia = (penDificultadActual == 2) ? 0.86f : 0.92f;
                    if (porcentajePotencia > umbralFalloPotencia) {
                      balonDestinoX = apTargetX + random(-110 * escalaX, 110 * escalaX);
                      balonDestinoY = apTargetY - 85 * escalaY;
                    } else {
                      balonDestinoX = apTargetX;
                      balonDestinoY = apTargetY;
                    }

                    velocidadBalon = map(porcentajePotencia, 0.1f, 1.0f, 0.024f, 0.058f);

                    float probabilidadAcierto = penBaseProbabilidadArquero + (tiroActual - 1) * 0.10f;
                    if (tiroActual % 2 != 0) {
                      radioAtajada = 70 * escalaY;
                    } else {
                      probabilidadAcierto = probabilidadAcierto + 0.08f;
                      radioAtajada = 90 * escalaY;
                    }

                    boolean adivinaCorrecto = random(1.0f) < probabilidadAcierto;
                    if (adivinaCorrecto) {
                      arqueroDestinoX = constrain(balonDestinoX, arcoX + 35 * escalaX, arcoX + arcoAncho - 35 * escalaX);
                      arqueroDestinoY = constrain(balonDestinoY, arcoY + 45 * escalaY, arcoY + arcoAlto - (arqueroAlto / 2));
                    } else {
                      float errorX = random(-320 * escalaX, 320 * escalaX);
                      if (abs(errorX) < 100 * escalaX)
                        errorX = (random(1) > 0.5f) ? (200 * escalaX) : (-200 * escalaX);
                      arqueroDestinoX = constrain(width / 2 + errorX, arcoX - 30 * escalaX, arcoX + arcoAncho + 30 * escalaX);
                      arqueroDestinoY = arcoY + arcoAlto - (arqueroAlto / 2);
                    }

                    tBalon = 0;
                    penEstadoActual = 2;
                    reproducirSfx(SFX_PEN_PATADA, 0.7f);
                  }
                }
              }
            }
          } else {
            if (penEstadoActual == 2) {
              tBalon += velocidadBalon;
              float elevacionCurva = sin(tBalon * PI) * (65 * escalaY) * porcentajePotencia;
              balonX = lerp(balonOrigenX, balonDestinoX, tBalon);
              balonY = lerp(balonOrigenY, balonDestinoY, tBalon) - elevacionCurva;
              balonTamanoActual = lerp(balonTamanoInicial, balonTamanoFinal, tBalon);

              float velVueloArquero = (tiroActual % 2 != 0) ? (velocidadArquero * 1.25f) : (velocidadArquero * 0.85f);
              arqueroX = lerp(arqueroX, arqueroDestinoX, velVueloArquero);
              arqueroY = lerp(arqueroY, arqueroDestinoY, velVueloArquero);

              pateadorX = lerp(pateadorBaseX, puntoPenaltiX - 45 * escalaX, constrain(tBalon * 3.0f, 0, 1));
              pateadorY = lerp(pateadorBaseY, puntoPenaltiY - 10 * escalaY, constrain(tBalon * 3.0f, 0, 1));

              if (tBalon >= 1.0f) {
                balonX = balonDestinoX;
                balonY = balonDestinoY;

                float luzIzquierda = arcoX + 18 * escalaX;
                float luzDerecha = arcoX + arcoAncho - 18 * escalaX;
                float luzArriba = arcoY + 18 * escalaY;
                float luzPiso = arcoY + arcoAlto + 10 * escalaY;

                boolean pegaPosteIzq = (balonDestinoX >= arcoX - 22 * escalaX && balonDestinoX <= luzIzquierda)
                    && (balonDestinoY >= arcoY - 15 * escalaY && balonDestinoY <= luzPiso);
                boolean pegaPosteDer = (balonDestinoX >= luzDerecha && balonDestinoX <= arcoX + arcoAncho + 22 * escalaX)
                    && (balonDestinoY >= arcoY - 15 * escalaY && balonDestinoY <= luzPiso);
                boolean pegaTravesano = (balonDestinoY >= arcoY - 22 * escalaY && balonDestinoY <= luzArriba)
                    && (balonDestinoX >= arcoX - 15 * escalaX && balonDestinoX <= arcoX + arcoAncho + 15 * escalaX);

                boolean dentroRed = (balonDestinoX > luzIzquierda && balonDestinoX < luzDerecha && balonDestinoY > luzArriba
                    && balonDestinoY <= luzPiso);

                radioAtajada = (tiroActual % 2 != 0) ? (70 * escalaY) : (90 * escalaY);
                float distanciaArquero = dist(balonDestinoX, balonDestinoY, arqueroX, arqueroY);

                if (distanciaArquero <= radioAtajada) {
                  atajadas++;
                  reproducirSfx(SFX_PEN_ATAJADA, 0.7f);
                  rachaGolesPenaltis = 0;
                  if (tiroActual % 2 != 0) {
                    mensajeResultado = "¡ATAJADÓN DE MATEO!";
                  } else {
                    mensajeResultado = "¡ATAJADÓN DE CRISTIAN!";
                  }
                  colorResultado = color(255, 85, 85);
                  activarScreenShake(6, 6.5f);
                  crearPopupFlotante("¡ATAJADO!", balonDestinoX, balonDestinoY - 20 * escalaY, color(255, 95, 95));
                } else {
                  if (dentroRed) {
                    goles++;
                    reproducirSfx(SFX_PEN_GOL, 0.8f);
                    rachaGolesPenaltis++;
                    mensajeResultado = "¡GOOOOOOLAZO DE SAM!";
                    colorResultado = color(85, 255, 95);

                    int ptsBase = (penDificultadActual == 0) ? 20 : ((penDificultadActual == 1) ? 35 : 55);
                    float distEsqIzq = dist(balonDestinoX, balonDestinoY, arcoX, arcoY);
                    float distEsqDer = dist(balonDestinoX, balonDestinoY, arcoX + arcoAncho, arcoY);
                    float minDistEsq = min(distEsqIzq, distEsqDer);
                    int bonoPrecision = (minDistEsq < 155 * escalaX) ? 20 : ((minDistEsq < 265 * escalaX) ? 10 : 5);
                    int bonoRacha = (rachaGolesPenaltis > 1) ? ((rachaGolesPenaltis - 1) * 10) : 0;
                    int ptsGol = ptsBase + bonoPrecision + bonoRacha;
                    puntajePenaltis += ptsGol;

                    String etiqGol = "+" + ptsGol + " PTS" + (minDistEsq < 155 * escalaX ? " ¡AL ÁNGULO!" : "")
                        + (rachaGolesPenaltis > 1 ? " (Racha x" + rachaGolesPenaltis + ")" : "");
                    ganarPuntosConPopup(ptsGol, 2, etiqGol, balonDestinoX, balonDestinoY - 25 * escalaY, color(90, 255, 115));
                    activarScreenShake(10, 9.5f);
                  } else {
                    fallos++;
                    rachaGolesPenaltis = 0;
                    if (pegaPosteIzq)
                      mensajeResultado = "¡PALO IZQUIERDO Y FUERA!";
                    else {
                      if (pegaPosteDer)
                        mensajeResultado = "¡PALO DERECHO Y FUERA!";
                      else {
                        if (pegaTravesano)
                          mensajeResultado = "¡TRAVESAÑO Y FUERA!";
                        else
                          mensajeResultado = "¡SE FUE A LA TRIBUNA!";
                      }
                    }
                    colorResultado = color(255, 220, 40);
                    if (pegaPosteIzq || pegaPosteDer || pegaTravesano) {
                      reproducirSfx(SFX_PEN_PALO, 0.7f);
                    } else {
                      reproducirSfx(SFX_PEN_FUERA, 0.6f);
                    }
                    activarScreenShake(7, 7.5f);
                    crearPopupFlotante("¡FALLO!", balonDestinoX, balonDestinoY - 20 * escalaY, color(255, 210, 60));
                  }
                }

                tiempoResultadoFrames = 0;
                penEstadoActual = 3;
              }
            }
          }

          // 3. DIBUJAR ARQUERO (MATEO EN IMPARES / CRISTIAN EN PARES)
          pushMatrix();
          translate(arqueroX, arqueroY);
          noStroke();
          fill(0, 80);
          ellipse(0, arqueroAlto / 2 - 5 * escalaY, arqueroAncho * 1.45f, 18 * escalaY);

          PImage spriteArqQuieto = turnoMateo ? imgMateoQuieto : imgCristianQuieto;
          PImage spriteArqIzq = turnoMateo ? imgMateoIzq : imgCristianIzq;
          PImage spriteArqDer = turnoMateo ? imgMateoDer : imgCristianDer;

          if (spriteArqQuieto != null) {
            imageMode(CENTER);
            PImage spriteUsar = spriteArqQuieto;
            boolean volandoLateral = false;
            if ((penEstadoActual == 2 || penEstadoActual == 3) && arqueroX < width / 2 - 45 * escalaX && spriteArqIzq != null) {
              spriteUsar = spriteArqIzq;
              volandoLateral = true;
            } else {
              if ((penEstadoActual == 2 || penEstadoActual == 3) && arqueroX > width / 2 + 45 * escalaX && spriteArqDer != null) {
                spriteUsar = spriteArqDer;
                volandoLateral = true;
              }
            }
            float altoDeseadoArq = (volandoLateral ? 158.0f : 178.0f) * escalaY;
            float anchoDeseadoArq = altoDeseadoArq * ((float) spriteUsar.width / (float) spriteUsar.height);
            image(spriteUsar, 0, 0, anchoDeseadoArq, altoDeseadoArq);
          } else {
            float inclinacionArq = 0;
            if (penEstadoActual == 2 || penEstadoActual == 3) {
              inclinacionArq = constrain((arqueroX - width / 2) * 0.0022f, -0.65f, 0.65f);
            }
            rotate(inclinacionArq);
            stroke(25);
            strokeWeight(3.5f * escalaY);
            rectMode(CENTER);
            fill(30, 35, 50);
            rect(-16 * escalaX, 35 * escalaY, 20 * escalaX, 36 * escalaY, 6);
            rect(16 * escalaX, 35 * escalaY, 20 * escalaX, 36 * escalaY, 6);
            fill(45, 95, 55);
            rect(0, 0, arqueroAncho, arqueroAlto - 45 * escalaY, 14);
            fill(255, 230, 50);
            float extGuanteY = (penEstadoActual == 2 || penEstadoActual == 3) ? -22 * escalaY : 0;
            ellipse(-arqueroAncho / 2 - 12 * escalaX, extGuanteY, 26 * escalaY, 26 * escalaY);
            ellipse(arqueroAncho / 2 + 12 * escalaX, extGuanteY, 26 * escalaY, 26 * escalaY);
            fill(255, 205, 155);
            ellipse(0, -arqueroAlto / 2 + 16 * escalaY, 44 * escalaY, 44 * escalaY);
            fill(turnoMateo ? color(230, 120, 40) : color(30, 30, 35));
            arc(0, -arqueroAlto / 2 + 12 * escalaY, 44 * escalaY, 36 * escalaY, PI, TWO_PI, CHORD);
            rectMode(CORNER);
          }
          popMatrix();

          // 4. DIBUJAR BALÓN
          float bxDibujo = (penEstadoActual == 0 || penEstadoActual == 1) ? puntoPenaltiX : balonX;
          float byDibujo = (penEstadoActual == 0 || penEstadoActual == 1) ? puntoPenaltiY : balonY;
          float bTamDibujo = (penEstadoActual == 0 || penEstadoActual == 1) ? balonTamanoInicial : balonTamanoActual;

          if (penEstadoActual != 4) {
            pushMatrix();
            translate(bxDibujo, byDibujo);
            noStroke();
            fill(0, 85);
            ellipse(0, bTamDibujo * 0.45f, bTamDibujo * 0.95f, bTamDibujo * 0.35f);
            if (penEstadoActual == 2)
              rotate(frameCount * 0.25f);
            if (imgBalon != null) {
              imageMode(CENTER);
              float anchoBal = bTamDibujo * ((float) imgBalon.width / (float) imgBalon.height);
              image(imgBalon, 0, 0, anchoBal, bTamDibujo);
            } else {
              fill(255);
              stroke(25);
              strokeWeight(3 * escalaY);
              ellipse(0, 0, bTamDibujo, bTamDibujo);
            }
            popMatrix();
          }

          // 5. DIBUJAR PATEADOR FIJO (SAM)
          if (penEstadoActual != 4) {
            pushMatrix();
            translate(pateadorX, pateadorY);
            noStroke();
            fill(0, 90);
            ellipse(0, 102 * escalaY, 115 * escalaX, 28 * escalaY);
            PImage spriteSam = ((penEstadoActual == 2 || penEstadoActual == 3) && imgSamPatada != null) ? imgSamPatada : imgSamQuieto;
            if (spriteSam != null) {
              imageMode(CENTER);
              float altoSam = 232.0f * escalaY;
              float anchoSam = altoSam * ((float) spriteSam.width / (float) spriteSam.height);
              image(spriteSam, 0, 0, anchoSam, altoSam);
            } else {
              stroke(25);
              strokeWeight(4 * escalaY);
              rectMode(CENTER);
              fill(45, 135, 235);
              rect(0, -22 * escalaY, 86 * escalaX, 82 * escalaY, 16);
              rectMode(CORNER);
            }
            popMatrix();
          }

          // 6. MECÁNICA DE APUNTADO Y HUD
          if (penEstadoActual == 1) {
            pushMatrix();
            translate(puntoPenaltiX, puntoPenaltiY);
            float anguloFlecha = atan2(apTargetY - puntoPenaltiY, apTargetX - puntoPenaltiX);
            rotate(anguloFlecha);
            stroke(255, 235, 40);
            strokeWeight(6 * escalaY);
            line(0, 0, 130 * escalaX, 0);
            fill(255, 235, 40);
            noStroke();
            triangle(130 * escalaX, -14 * escalaY, 160 * escalaX, 0, 130 * escalaX, 14 * escalaY);
            popMatrix();

            noFill();
            stroke(255, 50, 50);
            strokeWeight(4 * escalaY);
            ellipse(apTargetX, apTargetY, 48 * escalaY, 48 * escalaY);
            stroke(255);
            strokeWeight(2 * escalaY);
            line(apTargetX - 32 * escalaX, apTargetY, apTargetX + 32 * escalaX, apTargetY);
            line(apTargetX, apTargetY - 32 * escalaY, apTargetX, apTargetY + 32 * escalaY);

            dibujarIndicacionesPenaltis();
          }

          if (penEstadoActual != 0) dibujarMarcadorPenaltis(turnoMateo);

          // 7. PANTALLAS DE INICIO, RESULTADO Y FIN
          if (penEstadoActual == 0) {
            dibujarInicioPenaltis();
          } else {
            if (penEstadoActual == 3) {
              dibujarAvisoTiroPenaltis();

              tiempoResultadoFrames++;
              if (tiempoResultadoFrames >= DURACION_PAUSA_RESULTADO) {
                if (tiroActual < TOTAL_TIROS) {
                  tiroActual++;
                  tBalon = 0;
                  balonX = puntoPenaltiX;
                  balonY = puntoPenaltiY;
                  balonTamanoActual = balonTamanoInicial;
                  arqueroX = width / 2;
                  arqueroY = arcoY + arcoAlto - (arqueroAlto / 2);
                  radioAtajada = (tiroActual % 2 != 0) ? (70 * escalaY) : (90 * escalaY);
                  penSubEstadoApuntado = 0;
                  porcentajePotencia = 0;
                  penTiempoRestanteAccion = penTiempoLimiteFrames;
                  penEstadoActual = 1;
                } else {
                  penEstadoActual = 4;
                  reaccionClipAlResultado(goles >= 3);
                  if (!penaltisJugados) {
                    penaltisJugados = true;
                    if (goles >= 3) {
                      ganarPuntosConPopup(25, 2, "+25 PTS ¡VICTORIA!", width / 2, height / 2 - 120 * escalaY, color(255, 220, 60));
                      puntajePenaltis += 25;
                      reproducirSfx(SFX_PEN_VICTORIA, 0.8f);
                      modificarReputacion(10, width / 2 - 120 * escalaX, height / 2 - 70 * escalaY);
                      modificarBienestar(8, width / 2 + 120 * escalaX, height / 2 - 70 * escalaY);
                      desbloquearLogro(7); // Goleador Implacable (índice 7)
                    } else {
                      reproducirSfx(SFX_PEN_DERROTA, 0.8f);
                      modificarReputacion(-6, width / 2 - 120 * escalaX, height / 2 - 70 * escalaY);
                      modificarBienestar(-8, width / 2 + 120 * escalaX, height / 2 - 70 * escalaY);
                    }
                    prepararPostPixagramPenaltis();
                  }
                }
              }
            } else {
              if (penEstadoActual == 4) {
                dibujarResumenPenaltis();
              }
            }
          }
          imageMode(CORNER);
          rectMode(CORNER);
          popStyle();
        }

        // -----------------------------------------------------
        // CARTEL DE TRANSICION TEMPORAL («12 DÍAS DESPUÉS»)
        // -----------------------------------------------------
        if (estadoActual == TRANSICION_TEMPORAL) {
          dibujarTransicionTemporal();
        }

        // -----------------------------------------------------
        // NUEVA SECUENCIA DE NOVELA VISUAL: COCINA CON AMIGO
        // -----------------------------------------------------
        if (estadoActual == NOVELA_COCINA) {
          dibujarNovelaCocina();
        }

        // -----------------------------------------------------
        // CINEMATICA: FIN DEL DIA 1
        // -----------------------------------------------------
        if (estadoActual == FIN_DIA_1) {
          dibujarFinDia1();
        }

        // -----------------------------------------------------
        // ESCENA INTERACTIVA: DESAYUNO FAMILIAR
        // -----------------------------------------------------
        if (estadoActual == DESAYUNO) {
          dibujarEscenaDesayuno();
        }

        // -----------------------------------------------------
        // SELECCION DE DIFICULTAD DEL NIVEL 2 (4 DIFICULTADES)
        // -----------------------------------------------------
        if (estadoActual == SELECCION_DIF_NV2) {
          dibujarSeleccionDificultadNv2();
        }

        // -----------------------------------------------------
        // PANTALLA DE TRANSICION EN NEGRO: "NIVEL 2" + ADVERTENCIA DE EPILEPSIA
        // -----------------------------------------------------
        if (estadoActual == NIVEL2_INTRO) {
          background(6, 5, 12);
          if (!enPausa) {
            timerNivel2Intro++;
          }
          if (!enPausa && timerNivel2Intro == 1) {
            reproducirSfx(SFX_INTRO_NIVEL, 0.7f);
          }

          float progresoIntro = constrain(timerNivel2Intro / PApplet.parseFloat(DURACION_NIVEL2_INTRO), 0, 1);
          float alfaTexto = 255;
          if (timerNivel2Intro < 25) {
            alfaTexto = map(timerNivel2Intro, 0, 25, 0, 255);
          } else {
            if (timerNivel2Intro > DURACION_NIVEL2_INTRO - 25) {
              alfaTexto = map(timerNivel2Intro, DURACION_NIVEL2_INTRO - 25, DURACION_NIVEL2_INTRO, 255, 0);
            }
          }

          pushStyle();
          textAlign(CENTER, CENTER);

          fill(255, 190, 40, alfaTexto * 0.25f);
          textSize(82 * escalaX);
          text("NIVEL 2", width / 2 + 4, height / 2 - 145 * escalaY + 4);

          fill(255, 220, 70, alfaTexto);
          textSize(80 * escalaX);
          text("NIVEL 2", width / 2, height / 2 - 145 * escalaY);

          fill(220, 235, 255, alfaTexto * 0.95f);
          textSize(25 * escalaX);
          text("¡COCINA AL RITMO! - MODO " + nv2NombresDificultad[nv2Dificultad], width / 2, height / 2 - 75 * escalaY);

          fill(255, 200, 110, alfaTexto * 0.88f);
          textSize(18 * escalaX);
          text(nv2DescripcionesDif[nv2Dificultad], width / 2, height / 2 - 40 * escalaY);

          stroke(255, 200, 60, alfaTexto * 0.8f);
          strokeWeight(3);
          float anchoLinea = 380 * escalaX * sin(progresoIntro * PI);
          line(width / 2 - anchoLinea / 2, height / 2 - 102 * escalaY, width / 2 + anchoLinea / 2, height / 2 - 102 * escalaY);

          // Recuadro destacado de Advertencia de Fotosensibilidad / Epilepsia
          rectMode(CENTER);
          float pulsoWarn = 0.5f + 0.5f * sin(frameCount * 0.2f);
          fill(42, 12, 18, alfaTexto * 0.92f);
          stroke(lerpColor(color(255, 90, 70), color(255, 220, 60), pulsoWarn), alfaTexto);
          strokeWeight(3 * escalaX);
          rect(width / 2, height / 2 + 88 * escalaY, 920 * escalaX, 175 * escalaY, 18);
          rectMode(CORNER);

          dibujarIconoAlerta(width / 2 - 395 * escalaX, height / 2 + 40 * escalaY, 18 * escalaX, color(255, 220, 60, PApplet.parseInt(alfaTexto)));
          dibujarIconoAlerta(width / 2 + 395 * escalaX, height / 2 + 40 * escalaY, 18 * escalaX, color(255, 220, 60, PApplet.parseInt(alfaTexto)));

          fill(255, 225, 75, alfaTexto);
          textSize(22 * escalaX);
          text("ADVERTENCIA DE FOTOSENSIBILIDAD / EPILEPSIA", width / 2, height / 2 + 38 * escalaY);

          fill(245, 230, 230, alfaTexto * 0.95f);
          textSize(15.5f * escalaX);
          text(
              "Este nivel contiene destellos rápidos, cambios intensos de color psicodélico,\nvibración de pantalla y efectos visuales de alta energía al subir el combo.\nSi sientes mareo o fatiga visual, toma un descanso inmediatamente.",
              width / 2, height / 2 + 98 * escalaY);

          fill(170, 210, 255, alfaTexto * 0.8f);
          textSize(14 * escalaX);
          text("Presiona [ENTER], [ESPACIO] o haz clic para comenzar ya", width / 2, height / 2 + 205 * escalaY);
          popStyle();

          if (!enPausa && timerNivel2Intro >= DURACION_NIVEL2_INTRO && !enTransicion) {
            nv2ReiniciarPartida = true;
            estadoDestino = NIVEL2;
            enTransicion = true;
          }
        }

        // -----------------------------------------------------
        // MINIJUEGO DE COCINA AL RITMO (NIVEL 2 - 4 DIFICULTADES Y HASTA 9 CARRILES)
        // -----------------------------------------------------
        if (estadoActual == NIVEL2) {
          ejecutarMinijuegoNivel2();
        }

        if ((estadoActual == HISTORIA3_ARCADE && !t3Activa) || (estadoActual == HISTORIA_POST_COCINA && !hcActiva)) {
          background(10, 12, 20);
        }

        if (enPausa && estadoPermitePausaGlobal()) {
          dibujarMenuPausaGlobal();
        }

        // -----------------------------------------------------
        // PANEL DE VOLUMEN
        // -----------------------------------------------------
        if (mostrarOpciones && (estadoActual == MENU || (enPausa && estadoPermitePausaGlobal()))) {
          dibujarPanelOpcionesGlobal();
        }

        // -----------------------------------------------------
        // POP-UPS FLOTANTES DE PUNTOS, PARTICULAS Y PANEL DE RESUMEN
        // -----------------------------------------------------
        actualizarYDibujarPopupsYParticulas();
        if (mostrarResumenPuntos) {
          dibujarPanelResumenPuntos();
        }
        dibujarPanelDebugDesarrollador();

        // -----------------------------------------------------
        // AVISO DE LOGRO DESBLOQUEADO
        // -----------------------------------------------------
        dibujarAvisoLogro();

        if (shakeAplicado) {
          popMatrix();
        }

      }

    }

  }
}


// =====================================================
// RUEDA DEL MOUSE
// =====================================================
void mouseWheel(MouseEvent event) {
  if (transicionBloqueaEntrada()) return;
  boolean flujoRetornoActivo = true;

  if (enPausa && estadoPermitePausaGlobal()) {
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    if (ruedaHistoriaDespuesCocina(event.getCount())) {
      flujoRetornoActivo = false;
    }
    if (flujoRetornoActivo) {

      if (estadoActual == NIVEL1 && !enHome) {
        if (appAbierta.equals("Pixagram") && currentTab == 1) {
          float e = event.getCount();
          scrollYFeed -= e * 36;
          scrollYFeed = constrain(scrollYFeed, -maxScrollYFeed, 0);
        } else {
          if (appAbierta.equals("Pixel Art")) {
            procesarRuedaPixelArt(event.getCount());
          }
        }
      }

    }

  }
}

// =====================================================
// MOUSE PRESSED
// =====================================================
void mousePressed() {
  if (transicionBloqueaEntrada()) return;
  prepararPresentacionDeNivelClip();
  if (guiaPresentacionPendiente) {
    terminarPresentacionClip();
    return;
  }
  if (clicGuiaCelular()) return;
  if (!feriaClic()) {

    boolean flujoRetornoActivo = true;

    if (enPausa && estadoPermitePausaGlobal()) {
      procesarClicPausaGlobal();
      flujoRetornoActivo = false;
    }
    if (flujoRetornoActivo) {

    if (clicHistoria3()) {
      flujoRetornoActivo = false;
    }
    if (flujoRetornoActivo) {

      if (clicHistoriaDespuesCocina()) {
        flujoRetornoActivo = false;
      }
      if (flujoRetornoActivo) {

        boolean clicConsumido = false;
        boolean enMinijuegoPantallaCompleta = (estadoActual == NIVEL1 && !enHome
            && (appAbierta.equals("Parejas") || appAbierta.equals("Pixel Art") || appAbierta.equals("Frutas")));

        if (estadoActual == CARGA || estadoActual == RECUERDOS || (estadoActual == MENU && procesarClicFlechasMenu())) {
          if (estadoActual == RECUERDOS)
            recClic();
          clicConsumido = true;
        } else {
          if (procesarClicDebugDesarrollador()) {
            clicConsumido = true;
          } else {
            if (mostrarResumenPuntos) {
              mostrarResumenPuntos = false;
              if (sonidoClic != null) {
                sonidoClic.amp(0.3f * volMaster);
                sonidoClic.play();
              }
              clicConsumido = true;
            } else {
              if (!enMinijuegoPantallaCompleta && (estadoActual == EXPLORACION || estadoActual == PADRES || estadoActual == NIVEL1
                  || estadoActual == NOVELA_COCINA || estadoActual == SELECCION_DIF_NV2)) {
                // Clic en el contador de puntos del HUD para abrir resumen de puntuación
                float hudX = 18 * escalaX;
                float hudY = 14 * escalaY;
                float hudW = 470 * escalaX;
                float hudH = 82 * escalaY;
                if (mouseX >= hudX + hudW - 145 * escalaX && mouseX <= hudX + hudW && mouseY >= hudY && mouseY <= hudY + hudH) {
                  mostrarResumenPuntos = !mostrarResumenPuntos;
                  if (sonidoClic != null) {
                    sonidoClic.amp(0.35f * volMaster);
                    sonidoClic.play();
                  }
                  clicConsumido = true;
                }
              }
            }
          }
        }

        if (!clicConsumido) {
          // ---------- Minijuego de Penaltis ----------
          if (estadoActual == PENALTIS) {
            if (penEstadoActual == 0) {
              for (int i = 0; i < TOTAL_DIFICULTADES_PEN; i++) {
                float bx = width / 2 + (i - 1) * 290 * escalaX;
                float by = 455 * escalaY;
                if (mouseX >= bx - 130 * escalaX && mouseX <= bx + 130 * escalaX && mouseY >= by - 50 * escalaY && mouseY <= by + 50 * escalaY) {
                  penDificultadActual = i;
                  if (sonidoClic != null) {
                    sonidoClic.amp(0.3f * volMaster);
                    sonidoClic.play();
                  }
                }
              }
              if (mouseX >= width / 2 - 180 * escalaX && mouseX <= width / 2 + 180 * escalaX && mouseY >= 615 * escalaY - 42 * escalaY
                  && mouseY <= 615 * escalaY + 42 * escalaY) {
                if (penDificultadActual == 0) {
                  penTiempoLimiteFrames = 300;
                  penMultVelocidadMira = 1.0f;
                  penBaseProbabilidadArquero = 0.35f;
                  velocidadArquero = 0.065f;
                } else {
                  if (penDificultadActual == 1) {
                    penTiempoLimiteFrames = 210;
                    penMultVelocidadMira = 1.38f;
                    penBaseProbabilidadArquero = 0.50f;
                    velocidadArquero = 0.085f;
                  } else {
                    penTiempoLimiteFrames = 150;
                    penMultVelocidadMira = 1.75f;
                    penBaseProbabilidadArquero = 0.68f;
                    velocidadArquero = 0.11f;
                  }
                }
                tiroActual = 1;
                radioAtajada = 70 * escalaY;
                goles = 0;
                atajadas = 0;
                fallos = 0;
                rachaGolesPenaltis = 0;
                ptsCatPenaltis = 0;
                tBalon = 0;
                balonX = puntoPenaltiX;
                balonY = puntoPenaltiY;
                balonTamanoActual = balonTamanoInicial;
                penSubEstadoApuntado = 0;
                penTiempoRestanteAccion = penTiempoLimiteFrames;
                penEstadoActual = 1;
                if (sonidoClic != null) {
                  sonidoClic.amp(0.4f * volMaster);
                  sonidoClic.play();
                }
              }
            } else {
              if (penEstadoActual == 1) {
                accionApuntadoDisparada = true;
              } else {
                if (penEstadoActual == 4) {
                  if (mouseX >= width / 2 - 220 * escalaX && mouseX <= width / 2 + 220 * escalaX && mouseY >= 555 * escalaY - 40 * escalaY
                      && mouseY <= 555 * escalaY + 40 * escalaY) {
                    if (sonidoClic != null) {
                      sonidoClic.amp(0.4f * volMaster);
                      sonidoClic.play();
                    }
                    desbloquearSmsPostPenaltis();
                    prepararPostPixagramPenaltis();
                    enHome = false;
                    appAbierta = "Pixagram";
                    currentTab = 1;
                    scrollYFeed = 0;
                    estadoDestino = NIVEL1;
                    enTransicion = true;
                  }
                }
              }
            }
          }

          // ---------- Transición Temporal ("12 días después") ----------
          else {
            if (estadoActual == TRANSICION_TEMPORAL) {
              if (!enTransicion && timerTransicionTemporal > 35) {
                if (sonidoClic != null) {
                  sonidoClic.amp(0.35f * volMaster);
                  sonidoClic.play();
                }
                paginaCocina = 0;
                mostrandoDecisionCocina = false;
                ultimoTextoDialogo = "";
                charsVisibles = 0;
                dialogoCompletado = false;
                estadoDestino = NOVELA_COCINA;
                enTransicion = true;
              }
            }

            // ---------- Escena de Novela Visual de Cocina ----------
            else {
              if (estadoActual == NOVELA_COCINA) {
                if (!enTransicion && alphaTransicion <= 0) {
                  if (mostrandoDecisionCocina) {
                    procesarClicDecisionCocina();
                  } else {
                    if (!dialogoCompletado) {
                      charsVisibles = ultimoTextoDialogo.length();
                      dialogoCompletado = true;
                    } else {
                      if (paginaCocina == 6 && decisionCocinaTomada == 0) {
                        mostrandoDecisionCocina = true;
                        if (sonidoHover != null) {
                          sonidoHover.amp(0.2f * volMaster);
                          sonidoHover.play();
                        }
                      } else {
                        if (paginaCocina < totalPaginasCocina - 1) {
                          paginaCocina++;
                          if (sonidoHover != null) {
                            sonidoHover.amp(0.15f * volMaster);
                            sonidoHover.play();
                          }
                        } else {
                          if (sonidoClic != null) {
                            sonidoClic.amp(0.4f * volMaster);
                            sonidoClic.play();
                          }
                          estadoDestino = SELECCION_DIF_NV2;
                          enTransicion = true;
                        }
                      }
                    }
                  }
                }
              }

              // ---------- Selección de Dificultad del Nivel 2 ----------
              else {
                if (estadoActual == SELECCION_DIF_NV2) {
                  if (!enTransicion) {
                    boolean difCambiada = false;
                    for (int i = 0; i < TOTAL_DIFICULTADES_NV2 && !difCambiada; i++) {
                      float cx = width / 2 + (i - 1.5f) * 340 * escalaX;
                      float cy = 430 * escalaY;
                      float cardW = 315 * escalaX;
                      float cardH = 380 * escalaY;
                      if (mouseX >= cx - cardW / 2 && mouseX <= cx + cardW / 2 && mouseY >= cy - cardH / 2 && mouseY <= cy + cardH / 2) {
                        nv2Dificultad = i;
                        reproducirOpeningChestNv2(0.55f);
                        difCambiada = true;
                      }
                    }
                    if (!difCambiada) {
                      float btnX = width / 2;
                      float btnY = 735 * escalaY;
                      if (mouseX >= btnX - 220 * escalaX && mouseX <= btnX + 220 * escalaX && mouseY >= btnY - 38 * escalaY
                          && mouseY <= btnY + 38 * escalaY) {
                        reproducirOpeningChestNv2(0.65f);
                        timerNivel2Intro = 0;
                        estadoDestino = NIVEL2_INTRO;
                        enTransicion = true;
                      }
                    }
                  }
                }

                // ---------- Pantalla Intro Nivel 2 ----------
                else {
                  if (estadoActual == NIVEL2_INTRO) {
                    if (!enTransicion) {
                      nv2ReiniciarPartida = true;
                      estadoDestino = NIVEL2;
                      enTransicion = true;
                    }
                  }

                  // ---------- Minijuego de Cocina al Ritmo (NIVEL 2) ----------
                  else {
                    if (estadoActual == NIVEL2) {
                      if (nv2SubEstado == NV2_SUB_JUGANDO) {
                        float zonaImpactoY = nv2ZonaImpactoBaseY * escalaY;
                        int carrilClic = -1;
                        float radioReceptor = (nv2NumCarrilesActivos >= 9 ? 38 : (nv2NumCarrilesActivos >= 5 ? 46 : 58)) * escalaX;
                        for (int c = 0; c < nv2NumCarrilesActivos && carrilClic == -1; c++) {
                          float cx = nv2CarrilBaseX[c] * escalaX;
                          if (dist(mouseX, mouseY, cx, zonaImpactoY) <= radioReceptor && !nv2TeclaCarrilPresionada[c]) {
                            nv2TeclaCarrilPresionada[c] = true;
                            if (c == 0)
                              nv2TeclaIzqPresionada = true;
                            if (c == 1)
                              nv2TeclaDerPresionada = true;
                            carrilClic = c;
                          }
                        }
                        if (carrilClic != -1) {
                          procesarInputCarrilNv2(carrilClic);
                        }
                      } else {
                        if (nv2SubEstado == NV2_SUB_RESULTADOS || nv2SubEstado == NV2_SUB_DERROTA) {
                          float btnY = height / 2 + 215 * escalaY;
                          if (mouseX >= width / 2 - 310 * escalaX - 135 * escalaX && mouseX <= width / 2 - 310 * escalaX + 135 * escalaX
                              && mouseY >= btnY - 34 * escalaY && mouseY <= btnY + 34 * escalaY) {
                            if (sonidoClic != null) {
                              sonidoClic.amp(0.4f * volMaster);
                              sonidoClic.play();
                            }
                            nv2ReiniciarPartida = true;
                          } else {
                            if (mouseX >= width / 2 - 145 * escalaX && mouseX <= width / 2 + 145 * escalaX && mouseY >= btnY - 34 * escalaY
                                && mouseY <= btnY + 34 * escalaY) {
                              if (sonidoClic != null) {
                                sonidoClic.amp(0.4f * volMaster);
                                sonidoClic.play();
                              }
                              detenerYReiniciarTodosLosAudiosNv2();
                              estadoDestino = SELECCION_DIF_NV2;
                              enTransicion = true;
                            } else {
                              if (mouseX >= width / 2 + 310 * escalaX - 135 * escalaX && mouseX <= width / 2 + 310 * escalaX + 135 * escalaX
                                  && mouseY >= btnY - 34 * escalaY && mouseY <= btnY + 34 * escalaY) {
                                if (sonidoClic != null) {
                                  sonidoClic.amp(0.4f * volMaster);
                                  sonidoClic.play();
                                }
                                detenerYReiniciarTodosLosAudiosNv2();
                                estadoDestino = MENU;
                                enTransicion = true;
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          // ---------- Dialogo con los padres ----------
          if (estadoActual == PADRES) {
              if (!enTransicion && alphaTransicion <= 0) {
                if (mostrandoDecisionPadres) {
                  procesarClicDecisionPadres();
                } else {
                  if (!dialogoCompletado) {
                    charsVisibles = ultimoTextoDialogo.length();
                    dialogoCompletado = true;
                  } else {
                    int limitePaginas = feedbackPadresActivo ? (totalPaginasPadresFeedback - 1) : (totalPaginasPadresInicial - 1);

                    if (paginaPadres < limitePaginas) {
                      paginaPadres++;
                    } else {
                      if (!feedbackPadresActivo) {
                        tieneCelular = true;
                        estadoDestino = NIVEL1;
                        enTransicion = true;
                      } else {
                        if (decisionPadresDesayuno == 0) {
                          mostrandoDecisionPadres = true;
                          if (sonidoHover != null) {
                            sonidoHover.amp(0.2f * volMaster);
                            sonidoHover.play();
                          }
                        } else {
                          habloConPadresPostCelular = true;
                          if (!desayunoTarde) {
                            desbloquearLogro(1);
                          }
                          estadoDestino = EXPLORACION;
                          enTransicion = true;
                        }
                      }
                    }
                  }
                }
              }
            }

            // ---------- Celular ----------
            else {
              if (estadoActual == NIVEL1) {
                if (mostrandoModalDormir) {
                  procesarClicModalDormir();
                } else {
                  if (!enHome && appAbierta.equals("Parejas")) {
                    procesarClicParejas(mouseX, mouseY, width, height);
                  } else {
                    if (!enHome && appAbierta.equals("Pixel Art")) {
                      procesarClicPixelArt(mouseButton);
                    } else {
                      if (!enHome && appAbierta.equals("Frutas")) {
                        procesarClicFrutas();
                      } else {
                        float relX = mouseX - pantallaX;
                        float relY = mouseY - pantallaY;
                        boolean accionCelularHecha = false;

                        // Botón físico inferior en la barbilla del teléfono para volver a Home
                        if (mouseX >= telefonoX + (telefonoAncho * 0.32f) && mouseX <= telefonoX + (telefonoAncho * 0.68f)
                            && mouseY >= pantallaY + pantallaH && mouseY <= telefonoY + telefonoAlto) {
                          registrarRegresoGuiaPixagram();
                          enHome = true;
                          if (appAbierta.equals("Pixel Art")) {
                            detenerMusicaPixelArt();
                          }
                          appAbierta = "";
                          if (sonidoClic != null) {
                            sonidoClic.amp(0.3f * volMaster);
                            sonidoClic.play();
                          }
                          accionCelularHecha = true;
                        }

                        if (!accionCelularHecha) {
                          if (enHome) {
                            tamApp = 48;
                            inicioAppsY = 82;
                            espacioAppsY = 9;
                            espacioAppsX = (pantallaW - (columnasApps * tamApp)) / (columnasApps + 1);
                            int appsVisibles = juegosDesbloqueados ? totalApps : 7;
                            for (int i = 0; i < appsVisibles; i++) {
                              float appX = appCelularX(i);
                              float appY = appCelularY(i);

                              if (relX >= appX && relX <= appX + tamApp && relY >= appY && relY <= appY + tamApp) {
                                enHome = false;
                                appAbierta = nombresApps[i];
                                if (appAbierta.equals("Pixagram")) registrarEntradaGuiaPixagram();
                                reproducirSfx(SFX_APP_ABRIR, 0.5f);
                                if (appAbierta.equals("Parejas")) {
                                  iniciarJuegoParejas();
                                } else {
                                  if (appAbierta.equals("Pixel Art")) {
                                    initPixelArtGame();
                                  } else {
                                    if (appAbierta.equals("Frutas")) {
                                      initJuegoFrutas();
                                    }
                                  }
                                }
                                if (sonidoClic != null) {
                                  sonidoClic.amp(0.3f * volMaster);
                                  sonidoClic.play();
                                }
                              }
                            }
                          } else {
                            // Botón universal solo para apps sencillas
                            if (!accionCelularHecha && !appAbierta.equals("Pixagram") && !appAbierta.equals("Mensajes")
                                && !appAbierta.equals("Parejas") && !appAbierta.equals("Pixel Art") && !appAbierta.equals("Frutas")) {
                              if ((relX >= 0 && relX <= 80 && relY >= 20 && relY <= 64)
                                  || (relX >= 10 && relX <= 90 && relY >= pantallaH - 38 && relY <= pantallaH - 8)) {
                                enHome = true;
                                appAbierta = "";
                                if (sonidoClic != null) {
                                  sonidoClic.amp(0.3f * volMaster);
                                  sonidoClic.play();
                                }
                                accionCelularHecha = true;
                              }
                            }

                            if (!accionCelularHecha) {
                              // Ajustes
                              if (appAbierta.equals("Ajustes")) {
                                if (relX >= 12 && relX <= pantallaW - 12) {
                                  if (relY >= 38 && relY <= 72) {
                                    modoOscuroConfig = !modoOscuroConfig;
                                    if (sonidoClic != null) {
                                      sonidoClic.amp(0.3f * volMaster);
                                      sonidoClic.play();
                                    }
                                  }
                                  if (relY >= 80 && relY <= 114) {
                                    notificacionesConfig = !notificacionesConfig;
                                    if (sonidoClic != null) {
                                      sonidoClic.amp(0.3f * volMaster);
                                      sonidoClic.play();
                                    }
                                  }
                                  if (relY >= 122 && relY <= 156) {
                                    fondoActualIndex = (fondoActualIndex + 1) % totalFondosHome;
                                    if (sonidoClic != null) {
                                      sonidoClic.amp(0.3f * volMaster);
                                      sonidoClic.play();
                                    }
                                  }
                                }
                              }

                              // Música
                              else {
                                if (appAbierta.equals("Música")) {
                                  if (relY >= musProgY - 10 && relY <= musProgY + 14 && relX >= musProgX && relX <= musProgX + musProgW) {
                                    if (reproductorMp3 != null) {
                                      try {
                                        float duracionTotal = reproductorMp3.duration();
                                        if (duracionTotal > 0.1f) {
                                          float nuevoPorcentaje = constrain((relX - musProgX) / musProgW, 0, 0.99f);
                                          reproductorMp3.jump(nuevoPorcentaje * duracionTotal);
                                        }
                                      } catch (Exception e) {
                                      }
                                    }
                                  }

                                  if (relY >= musBotonY && relY <= musBotonY + musBotonH) {
                                    int cambioDePista = 0;
                                    float botonPlayX = musInicioBtnX + musBotonW + musEspacioBtn;
                                    float botonSiguienteX = musInicioBtnX + (musBotonW + musEspacioBtn) * 2;

                                    if (relX >= musInicioBtnX && relX <= musInicioBtnX + musBotonW) {
                                      cambioDePista = -1;
                                    } else {
                                      if (relX >= botonSiguienteX && relX <= botonSiguienteX + musBotonW) {
                                        cambioDePista = 1;
                                      } else {
                                        if (relX >= botonPlayX && relX <= botonPlayX + musBotonW) {
                                          if (reproduciendoMusica) {
                                            if (reproductorMp3 != null) {
                                              reproductorMp3.pause();
                                              reproduciendoMusica = false;
                                            }
                                          } else {
                                            if (reproductorMp3 != null) {
                                              if (musicaFondo != null && musicaFondo.isPlaying()) {
                                                musicaFondo.pause();
                                              }
                                              reproductorMp3.amp(volMaster);
                                              reproductorMp3.play();
                                              reproduciendoMusica = true;
                                            } else {
                                              try {
                                                if (musicaFondo != null && musicaFondo.isPlaying()) {
                                                  musicaFondo.pause();
                                                }
                                                reproductorMp3 = new SoundFile(this, listaCanciones[cancionActualIndex]);
                                                reproductorMp3.amp(volMaster);
                                                reproductorMp3.play();
                                                reproduciendoMusica = true;
                                              } catch (Exception e) {
                                              }
                                            }
                                          }
                                          desbloquearLogro(4);
                                        }
                                      }
                                    }

                                    if (cambioDePista != 0) {
                                      cancionActualIndex = (cancionActualIndex + cambioDePista + totalCanciones) % totalCanciones;
                                      try {
                                        if (reproductorMp3 != null) {
                                          reproductorMp3.stop();
                                        }
                                        if (musicaFondo != null && musicaFondo.isPlaying()) {
                                          musicaFondo.pause();
                                        }
                                        reproductorMp3 = new SoundFile(this, listaCanciones[cancionActualIndex]);
                                        reproductorMp3.amp(volMaster);
                                        reproductorMp3.play();
                                        reproduciendoMusica = true;
                                      } catch (Exception e) {
                                      }
                                    }
                                  }
                                }

                                // ===== MENSAJES (CHATS INTERACTIVOS) =====
                                else {
                                  if (appAbierta.equals("Mensajes")) {
                                    if (chatAbierto == -1) {
                                      if (relX >= 0 && relX <= 80 && relY >= 28 && relY <= 66) {
                                        enHome = true;
                                        appAbierta = "";
                                        if (sonidoClic != null) {
                                          sonidoClic.amp(0.3f * volMaster);
                                          sonidoClic.play();
                                        }
                                        accionCelularHecha = true;
                                      } else {
                                        for (int ch = 0; ch < totalChats && !accionCelularHecha; ch++) {
                                          float chY = 72 + ch * 60;
                                          if (relX >= 8 && relX <= pantallaW - 8 && relY >= chY && relY <= chY + 54) {
                                            chatAbierto = ch;
                                            chatTieneNoLeido[ch] = false;
                                            if (sonidoClic != null) {
                                              sonidoClic.amp(0.25f * volMaster);
                                              sonidoClic.play();
                                            }
                                            accionCelularHecha = true;
                                          }
                                        }
                                      }
                                    } else {
                                      if (relX >= 0 && relX <= 75 && relY >= 28 && relY <= 68) {
                                        chatAbierto = -1;
                                        if (sonidoClic != null) {
                                          sonidoClic.amp(0.25f * volMaster);
                                          sonidoClic.play();
                                        }
                                        accionCelularHecha = true;
                                      } else {
                                        float replyY = pantallaH - 42;
                                        if (relY >= replyY && relY <= pantallaH && relX >= 10 && relX <= pantallaW - 10) {
                                          if (!chatRespondido[chatAbierto]) {
                                            chatRespondido[chatAbierto] = true;
                                            reproducirSfx(SFX_MENSAJE_ENVIADO, 0.5f);
                                            modificarBienestar(4, "Respuesta en Mensajes");
                                            modificarReputacion(3, "Contacto con amigos");
                                            ganarPuntosConPopup(10, "Mensaje respondido", pantallaX + pantallaW / 2, pantallaY + replyY);
                                            if (sonidoClic != null) {
                                              sonidoClic.amp(0.4f * volMaster);
                                              sonidoClic.play();
                                            }

                                            if (chatAbierto == 2 && !claraIntroducidaAlGrupo) {
                                              claraIntroducidaAlGrupo = true;
                                              chatMensajes[3][0] = "S: Sam: Oigan muchachos, metí a Clara al grupo de los panas :)";
                                              chatMensajes[3][1] = "O: Clara: ¡Hola a todos! Gracias Sam por unirme al grupo.";
                                              chatMensajes[3][2] = "O: Mateo: ¡Bienvenida Clara! Qué partidazo el de hoy en la cancha.";
                                              chatMensajes[3][3] = "O: Cristian: ¡Qué más Clara! Qué nota tenerte por acá.";
                                              chatTieneNoLeido[3] = true;
                                              chatRespondido[3] = true;
                                              crearPopupFlotante("¡Clara se ha unido al grupo de los panas!", width / 2, 120 * escalaY,
                                                  color(120, 230, 255));
                                            }
                                          }
                                          accionCelularHecha = true;
                                        }
                                      }
                                    }
                                  }

                                  // ===== PIXAGRAM =====
                                  else {
                                    if (appAbierta.equals("Pixagram")) {
                                      if (relX >= 0 && relX <= 85 && relY >= 28 && relY <= 54) {
                                        registrarRegresoGuiaPixagram();
                                        enHome = true;
                                        appAbierta = "";
                                        if (sonidoClic != null) {
                                          sonidoClic.amp(0.3f * volMaster);
                                          sonidoClic.play();
                                        }
                                        accionCelularHecha = true;
                                      }

                                      float navY = pantallaH - 48;
                                      if (!accionCelularHecha && relY >= navY && relY <= pantallaH) {
                                        float btnW = pantallaW / 2.0f;
                                        int clickedIdx = PApplet.parseInt(relX / btnW);
                                        int[] tabIndices = {0, 1};
                                        if (clickedIdx >= 0 && clickedIdx < 2) {
                                          currentTab = tabIndices[clickedIdx];
                                          if (sonidoClic != null) {
                                            sonidoClic.amp(0.25f * volMaster);
                                            sonidoClic.play();
                                          }
                                          accionCelularHecha = true;
                                        }
                                      }

                                      if (!accionCelularHecha) {
                                        float contentY = 54;
                                        float contentH = pantallaH - 54 - 48;

                                        if (currentTab == 0) {
                                          if (relX >= 12 && relX <= pantallaW - 12 && relY >= contentY + 80 && relY <= contentY + contentH - 10) {
                                            currentTab = 1;
                                            if (sonidoClic != null) {
                                              sonidoClic.amp(0.25f * volMaster);
                                              sonidoClic.play();
                                            }
                                            accionCelularHecha = true;
                                          }
                                        } else {
                                          if (currentTab == 1) {
                                            if (relY >= contentY && relY <= pantallaH - 48) {
                                              procesarClicFeedPixagram(relX, relY, contentY, contentH);
                                              accionCelularHecha = true;
                                            }
                                          } else {
                                            if (currentTab == 3) {
                                              if (activeChatIndex == -1) {
                                                float curYMsgClick = contentY + 30;
                                                for (int cIdx = 0; cIdx < TOTAL_CONVERSACIONES && !accionCelularHecha; cIdx++) {
                                                  if (relX >= 12 && relX <= 12 + pantallaW - 24 && relY >= curYMsgClick
                                                      && relY <= curYMsgClick + 50) {
                                                    activeChatIndex = cIdx;
                                                    if (sonidoClic != null) {
                                                      sonidoClic.amp(0.25f * volMaster);
                                                      sonidoClic.play();
                                                    }
                                                    accionCelularHecha = true;
                                                  }
                                                  curYMsgClick += 58;
                                                }
                                              } else {
                                                if (relX >= 4 && relX <= 4 + 34 && relY >= contentY + 2 && relY <= contentY + 2 + 30) {
                                                  activeChatIndex = -1;
                                                  if (sonidoClic != null) {
                                                    sonidoClic.amp(0.25f * volMaster);
                                                    sonidoClic.play();
                                                  }
                                                  accionCelularHecha = true;
                                                } else {
                                                  float inputY = contentY + contentH - 36;
                                                  if (relX >= pantallaW - 50 && relX <= pantallaW - 50 + 38 && relY >= inputY
                                                      && relY <= inputY + 28) {
                                                    if (newChatMessage.trim().length() > 0 && convMessageCount[activeChatIndex] < MAX_MENSAJES_CONV) {
                                                      int mIdx = convMessageCount[activeChatIndex];
                                                      convMsgSender[activeChatIndex][mIdx] = playerName;
                                                      convMsgText[activeChatIndex][mIdx] = newChatMessage;
                                                      convMsgTime[activeChatIndex][mIdx] = "10:43";
                                                      convMessageCount[activeChatIndex]++;
                                                      reproducirSfx(SFX_MENSAJE_ENVIADO, 0.5f);
                                                      newChatMessage = "";
                                                      modificarBienestar(3, "Charla en Pixagram");
                                                      ganarPuntosConPopup(5, "DM enviado", pantallaX + pantallaW / 2, pantallaY + inputY);
                                                      if (sonidoClic != null) {
                                                        sonidoClic.amp(0.3f * volMaster);
                                                        sonidoClic.play();
                                                      }
                                                    }
                                                    accionCelularHecha = true;
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }

                        if (!accionCelularHecha) {
                          float btnGuardarW = BOTON_GUARDAR_CELULAR_W * escalaX;
                          float btnGuardarH = BOTON_GUARDAR_CELULAR_H * escalaY;
                          float btnGuardarX = (width - btnGuardarW) / 2;
                          float btnGuardarY = height - btnGuardarH - BOTON_GUARDAR_CELULAR_MARGEN;
                          if (mouseX >= btnGuardarX && mouseX <= btnGuardarX + btnGuardarW && mouseY >= btnGuardarY
                              && mouseY <= btnGuardarY + btnGuardarH) {
                            if (penaltisJugados && !dia1Terminado) {
                              intentarSalirDeCelular();
                            } else {
                              if (dia1Terminado && juegosDesbloqueados) {
                                mostrandoModalDormir = true;
                                if (sonidoClic != null) {
                                  sonidoClic.amp(0.35f * volMaster);
                                  sonidoClic.play();
                                }
                              } else {
                                intentarSalirDeCelular();
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              // ---------- Novela Escuela / Penaltis ----------
              else {
                if (estadoActual == NOVELA_ESCUELA) {
                  if (!enTransicion && alphaTransicion <= 0) {
                    if (!dialogoCompletado) {
                      charsVisibles = ultimoTextoDialogo.length();
                      dialogoCompletado = true;
                    } else {
                      if (paginaEscuela < totalPaginasEscuela - 1) {
                        paginaEscuela++;
                        if (sonidoHover != null) {
                          sonidoHover.amp(0.12f * volMaster);
                          sonidoHover.play();
                        }
                      } else {
                        timerNivel1Intro = 0;
                        estadoDestino = NIVEL1_INTRO;
                        enTransicion = true;
                        if (sonidoClic != null) {
                          sonidoClic.amp(0.4f * volMaster);
                          sonidoClic.play();
                        }
                      }
                    }
                  }
                }

                // ---------- Exploracion ----------
                else {
                  if (estadoActual == EXPLORACION) {
                    if (dialogoCamaActivo) {
                      dialogoCamaActivo = false;
                      estadoDestino = NIVEL1;
                      enHome = true;
                      appAbierta = "";
                      desbloquearJuegosConClip();
                      enTransicion = true;
                      if (sonidoClic != null) {
                        sonidoClic.amp(0.35f * volMaster);
                        sonidoClic.play();
                      }
                    } else {
                      if (mostrandoModalDormir) {
                        procesarClicModalDormir();
                      }
                    }
                  } else {
                    if (estadoActual == FIN_DIA_1) {
                      if (!enTransicion && timerFinDia1 > 20) {
                        avanzarDesdeFinDia1();
                      }
                    }

                    // ---------- Desayuno familiar ----------
                    else {
                      if (estadoActual == DESAYUNO) {
                        if (!enTransicion) {
                          procesarClicDesayuno();
                        }
                      }
                    }
                  }
                }
              }
            }

            // ---------- Menu principal y seleccion en el cielo ----------
            if (estadoActual == MENU) {
              if (!mostrarOpciones) {
                // si ya estamos subiendo o en las nubes, procesamos el clic en los recuadros del cielo xd
                if (!procesarClicMenuCielo()) {
                  for (int k = 0; k < botonesVisibles; k++) {
                    if (mouseX > btnX[k] && mouseX < btnX[k] + btnW[k] && mouseY > btnY[k] && mouseY < btnY[k] + btnH[k]) {
                      int indiceReal = (offsetCarrusel + k) % totalBotones;

                      if (sonidoClic != null) {
                        sonidoClic.amp(0.5f * volMaster);
                        sonidoClic.play();
                      }

                      // al darle a JUGAR (0), activamos la subida de camara estilo Stardew Valley hacia las nubes
                      if (indiceReal == 0) {
                        cargarPartidasDesdeArchivo();
                        faseCamaraMenu = 1;
                      }
                      if (indiceReal == 1) {
                        mostrarOpciones = true;
                      }
                      if (indiceReal == 2) {
                        estadoDestino = CREDITOS;
                        enTransicion = true;
                      }
                      if (indiceReal == 3) {
                        exit();
                      }
                      if (indiceReal == 4) {
                        estadoDestino = LOGROS;
                        enTransicion = true;
                      }
                      if (indiceReal == 5)
                        recAbrir();
                      if (indiceReal == 6)
                        feriaAbrir();
                    }
                  }

                  float solCentroX = solCentroXRef * escalaX;
                  float solCentroY = solCentroYRef * escalaY;
                  float solRadio = solRadioRef * escalaX;

                  if (dist(mouseX, mouseY, solCentroX, solCentroY) <= solRadio) {
                    if (videoFondo != null) {
                      videoFondo.dispose();
                    }

                    if (!fondoAlternativo) {
                      videoFondo = new Movie(this, "menu_juego_2.mp4");
                      logoMenu = loadImage("logo_menus_2.png");
                    } else {
                      videoFondo = new Movie(this, "menu_juego.mp4");
                      logoMenu = loadImage("logo_menus.png");
                    }
                    if (logoMenu != null && logoMenu.width > 0) {
                      int lw = max(1, PApplet.parseInt(REF_W * 0.40f * escalaX));
                      int lh = max(1, PApplet.parseInt(lw * ((float) logoMenu.height / (float) logoMenu.width)));
                      logoMenu.resize(lw, lh);
                    }
                    fondoAlternativo = !fondoAlternativo;
                    fondoCieloCacheListo = false;
                    videoFondo.volume(0);
                    videoFondo.play();
                    ultimoReinicioVideo = millis();
                  }
                }
              }
            } else {
              // ---------- Intro ----------
              if (estadoActual == JUEGO) {
                if (mostrarSaltarIntro) {
                  if (hoverSaltarIntro != -1) {
                    if (sonidoClic != null) {
                      sonidoClic.amp(0.5f * volMaster);
                      sonidoClic.play();
                    }
                    if (hoverSaltarIntro == 0) {
                      estadoDestino = EXPLORACION;
                      enTransicion = true;
                      paginaActual = 0;
                      mostrarSaltarIntro = false;
                    }
                    if (hoverSaltarIntro == 1) {
                      mostrarSaltarIntro = false;
                      ultimoTextoDialogo = "";
                      charsVisibles = 0;
                      dialogoCompletado = false;
                    }
                  }
                } else {
                  if (!dialogoCompletado) {
                    charsVisibles = ultimoTextoDialogo.length();
                    dialogoCompletado = true;
                  } else {
                    if (paginaActual < totalPaginasLore - 1) {
                      paginaActual++;
                    } else {
                      estadoDestino = EXPLORACION;
                      enTransicion = true;
                      paginaActual = 0;
                    }
                  }
                }
              }
            }
        }

      }

    }

    }

  }
}

// =====================================================
// TECLADO
// =====================================================
void keyPressed() {
  if (transicionBloqueaEntrada()) {
    if (key == ESC) key = 0;
    return;
  }
  prepararPresentacionDeNivelClip();
  if (guiaPresentacionPendiente) {
    if (key == ENTER || key == RETURN || key == ' '
        || (guiaNivelPresentado == 0 && (key == ESC || keyCode == GUIA_TECLA))) {
      terminarPresentacionClip();
    }
    if (key == ESC) key = 0;
    return;
  }
  if (teclaGuiaCelular()) return;
  if (keyCode == GUIA_TECLA && obtenerContextoGuia() >= 0) {
    if (!guiaF1Presionada) alternarGuia();
    guiaF1Presionada = true;
    return;
  }
  if (!feriaTecla()) {

    boolean flujoRetornoActivo = true;

    boolean fueEscGlobal = (key == ESC || keyCode == ESC);
    if (key == ESC) {
      key = 0;
    }
    if (enPausa && estadoPermitePausaGlobal()) {
      procesarTeclaPausaGlobal(key, keyCode, fueEscGlobal);
      flujoRetornoActivo = false;
    } else {
      if (teclaAbrePausaGlobal(key, keyCode, fueEscGlobal)) {
        activarPausaGlobal();
        flujoRetornoActivo = false;
      }
    }
    if (flujoRetornoActivo) {

    if (teclaHistoria3()) {
      flujoRetornoActivo = false;
    }
    if (flujoRetornoActivo) {

      if (teclaHistoriaDespuesCocina()) {
        flujoRetornoActivo = false;
      }
      if (flujoRetornoActivo) {

        boolean botonAtras = (key == 'm' || key == 'M' || fueEscGlobal);
        boolean fueEsc = fueEscGlobal;

        boolean teclaConsumida = false;
        boolean enMinijuegoPantallaCompleta = (estadoActual == NIVEL1 && !enHome
            && (appAbierta.equals("Parejas") || appAbierta.equals("Pixel Art") || appAbierta.equals("Frutas")));
        detenerMusicaPixelArt();
        if (estadoActual == CARGA || estadoActual == RECUERDOS) {
          if (estadoActual == RECUERDOS)
            recTecla(botonAtras);
          teclaConsumida = true;
        } else {
          if (procesarTeclaDebugDesarrollador(key, keyCode)) {
            teclaConsumida = true;
          } else {
            if (keyCode == TAB && !enMinijuegoPantallaCompleta
                && !(estadoActual == NIVEL1 && !enHome && (appAbierta.equals("Notas") || appAbierta.equals("Pixagram")))) {
              mostrarResumenPuntos = !mostrarResumenPuntos;
              if (sonidoClic != null) {
                sonidoClic.amp(0.35f * volMaster);
                sonidoClic.play();
              }
              teclaConsumida = true;
            } else {
              if (mostrarResumenPuntos && (botonAtras || keyCode == ENTER || key == RETURN || key == ' ')) {
                mostrarResumenPuntos = false;
                teclaConsumida = true;
              }
            }
          }
        }

        if (!teclaConsumida) {
          // ---------- Minijuego de Penaltis ----------
          if (estadoActual == PENALTIS) {
            if (penEstadoActual == 0) {
              if (key == '1')
                penDificultadActual = 0;
              if (key == '2')
                penDificultadActual = 1;
              if (key == '3')
                penDificultadActual = 2;
            } else {
              if (penEstadoActual == 1 && (key == ' ' || keyCode == ENTER || key == RETURN)) {
                accionApuntadoDisparada = true;
              } else {
                if (penEstadoActual == 4 && (key == ' ' || keyCode == ENTER || key == RETURN)) {
                  desbloquearSmsPostPenaltis();
                  prepararPostPixagramPenaltis();
                  enHome = false;
                  appAbierta = "Pixagram";
                  currentTab = 1;
                  scrollYFeed = 0;
                  estadoDestino = NIVEL1;
                  enTransicion = true;
                }
              }
            }
            teclaConsumida = true;
          }

          // ---------- Transición Temporal ----------
          else {
            if (estadoActual == TRANSICION_TEMPORAL) {
              if ((key == ' ' || keyCode == ENTER || key == RETURN) && !enTransicion && timerTransicionTemporal > 35) {
                paginaCocina = 0;
                mostrandoDecisionCocina = false;
                ultimoTextoDialogo = "";
                charsVisibles = 0;
                dialogoCompletado = false;
                estadoDestino = NOVELA_COCINA;
                enTransicion = true;
              }
              teclaConsumida = true;
            }

            // ---------- Novela Visual de Cocina ----------
            else {
              if (estadoActual == NOVELA_COCINA) {
                if (botonAtras) {
                  estadoDestino = MENU;
                  enTransicion = true;
                } else {
                  if (!enTransicion && alphaTransicion <= 0) {
                    if (mostrandoDecisionCocina) {
                      if (key == '1')
                        elegirOpcionCocina(1);
                      if (key == '2')
                        elegirOpcionCocina(2);
                    } else {
                      if (keyCode == ENTER || key == ENTER || key == RETURN || key == ' ') {
                        if (!dialogoCompletado) {
                          charsVisibles = ultimoTextoDialogo.length();
                          dialogoCompletado = true;
                        } else {
                          if (paginaCocina == 6 && decisionCocinaTomada == 0) {
                            mostrandoDecisionCocina = true;
                          } else {
                            if (paginaCocina < totalPaginasCocina - 1) {
                              paginaCocina++;
                              if (sonidoHover != null) {
                                sonidoHover.amp(0.15f * volMaster);
                                sonidoHover.play();
                              }
                            } else {
                              estadoDestino = SELECCION_DIF_NV2;
                              enTransicion = true;
                            }
                          }
                        }
                      }
                    }
                  }
                }
                teclaConsumida = true;
              }

              // ---------- Selección de Dificultad del Nivel 2 ----------
              else {
                if (estadoActual == SELECCION_DIF_NV2) {
                  if (botonAtras) {
                    estadoDestino = MENU;
                    enTransicion = true;
                  } else {
                    if (key == '1') {
                      nv2Dificultad = NV2_DIF_INTERMEDIO;
                      reproducirOpeningChestNv2(0.55f);
                    } else {
                      if (key == '2') {
                        nv2Dificultad = NV2_DIF_DIFICIL;
                        reproducirOpeningChestNv2(0.55f);
                      } else {
                        if (key == '3') {
                          nv2Dificultad = NV2_DIF_EXTREMO;
                          reproducirOpeningChestNv2(0.55f);
                        } else {
                          if (key == '4') {
                            nv2Dificultad = NV2_DIF_INJUGABLE;
                            reproducirOpeningChestNv2(0.55f);
                          } else {
                            if (key == 'a' || key == 'A' || keyCode == LEFT) {
                              nv2Dificultad = (nv2Dificultad - 1 + TOTAL_DIFICULTADES_NV2) % TOTAL_DIFICULTADES_NV2;
                              reproducirOpeningChestNv2(0.50f);
                            } else {
                              if (key == 'd' || key == 'D' || keyCode == RIGHT) {
                                nv2Dificultad = (nv2Dificultad + 1) % TOTAL_DIFICULTADES_NV2;
                                reproducirOpeningChestNv2(0.50f);
                              } else {
                                if ((key == ' ' || keyCode == ENTER || key == RETURN) && !enTransicion) {
                                  reproducirOpeningChestNv2(0.65f);
                                  timerNivel2Intro = 0;
                                  estadoDestino = NIVEL2_INTRO;
                                  enTransicion = true;
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                  teclaConsumida = true;
                }

                // ---------- Pantalla Intro Nivel 2 ----------
                else {
                  if (estadoActual == NIVEL2_INTRO) {
                    if ((key == ' ' || keyCode == ENTER || key == RETURN) && !enTransicion) {
                      nv2ReiniciarPartida = true;
                      estadoDestino = NIVEL2;
                      enTransicion = true;
                    }
                    teclaConsumida = true;
                  }

                  // ---------- Minijuego de Cocina al Ritmo (NIVEL 2) ----------
                  else {
                    if (estadoActual == NIVEL2) {
                      if (key == 'b' || key == 'B') {
                        nv2AutoPlayBot = !nv2AutoPlayBot;
                        nv2TimerAutoAvanceBot = 0;
                        if (!nv2AutoPlayBot) {
                          for (int c = 0; c < MAX_CARRILES_NV2; c++)
                            nv2TeclaCarrilPresionada[c] = false;
                        }
                        crearPopupFlotante(nv2AutoPlayBot ? "BOT AUTO-PLAY NIVEL 2: ACTIVADO [B]" : "BOT AUTO-PLAY NIVEL 2: DESACTIVADO", width / 2,
                            155 * escalaY, color(80, 255, 195));
                      } else {
                        if ((modoDebug || nv2AutoPlayBot) && (key >= '1' && key <= '4') && nv2SubEstado == NV2_SUB_JUGANDO) {
                          nv2Dificultad = key - '1';
                          iniciarPartidaNivel2();
                          crearPopupFlotante("CAMBIO A NIVEL " + (nv2Dificultad + 1) + ": " + nv2NombresDificultad[nv2Dificultad] + " ("
                              + nv2TitulosPorDif[nv2Dificultad] + ")", width / 2, 155 * escalaY, color(255, 225, 85));
                        } else {
                          if (nv2SubEstado == NV2_SUB_JUGANDO) {
                            int carrilDetectado = obtenerCarrilPorTeclaNv2(key, keyCode);
                            if (carrilDetectado >= 0 && carrilDetectado < nv2NumCarrilesActivos && !nv2TeclaCarrilPresionada[carrilDetectado]) {
                              nv2TeclaCarrilPresionada[carrilDetectado] = true;
                              if (carrilDetectado == 0)
                                nv2TeclaIzqPresionada = true;
                              if (carrilDetectado == 1)
                                nv2TeclaDerPresionada = true;
                              procesarInputCarrilNv2(carrilDetectado);
                            } else {
                              if (key == ']' || key == '+' || keyCode == UP || (nv2Dificultad != NV2_DIF_INTERMEDIO && keyCode == RIGHT)) {
                                int salto = (keyCode == UP) ? 50 : 25;
                                nv2OffsetMs += salto;
                                crearPopupFlotante("OFFSET: " + (nv2OffsetMs >= 0 ? "+" : "") + nv2OffsetMs + " ms (Notas bajan antes)", width / 2,
                                    175 * escalaY, color(255, 230, 80));
                              } else {
                                if (key == '[' || key == '-' || keyCode == DOWN || (nv2Dificultad != NV2_DIF_INTERMEDIO && keyCode == LEFT)) {
                                  int salto = (keyCode == DOWN) ? 50 : 25;
                                  nv2OffsetMs -= salto;
                                  crearPopupFlotante("OFFSET: " + (nv2OffsetMs >= 0 ? "+" : "") + nv2OffsetMs + " ms (Notas bajan después)",
                                      width / 2, 175 * escalaY, color(100, 220, 255));
                                }
                              }
                            }
                          } else {
                            if (nv2SubEstado == NV2_SUB_RESULTADOS || nv2SubEstado == NV2_SUB_DERROTA) {
                              if (key == '1') {
                                nv2Dificultad = NV2_DIF_INTERMEDIO;
                                nv2ReiniciarPartida = true;
                              } else {
                                if (key == '2') {
                                  nv2Dificultad = NV2_DIF_DIFICIL;
                                  nv2ReiniciarPartida = true;
                                } else {
                                  if (key == '3') {
                                    nv2Dificultad = NV2_DIF_EXTREMO;
                                    nv2ReiniciarPartida = true;
                                  } else {
                                    if (key == '4') {
                                      nv2Dificultad = NV2_DIF_INJUGABLE;
                                      nv2ReiniciarPartida = true;
                                    } else {
                                      if (key == 'r' || key == 'R') {
                                        nv2ReiniciarPartida = true;
                                      } else {
                                        if (key == 'c' || key == 'C') {
                                          detenerYReiniciarTodosLosAudiosNv2();
                                          estadoDestino = SELECCION_DIF_NV2;
                                          enTransicion = true;
                                        } else {
                                          if (keyCode == ENTER || key == RETURN) {
                                            detenerYReiniciarTodosLosAudiosNv2();
                                            estadoDestino = MENU;
                                            enTransicion = true;
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                      teclaConsumida = true;
                    }
                  }
                }
              }
            }
          }
        }

        if (!teclaConsumida) {
          if (estadoActual == EXPLORACION && !enPausa && !leyendoMensaje && !animandoEscalera && !enTransicion) {
            int codigoMov = -1;
            if (key == 'w' || key == 'W' || keyCode == UP) {
              codigoMov = UP;
            }
            if (key == 's' || key == 'S' || keyCode == DOWN) {
              codigoMov = DOWN;
            }
            if (key == 'a' || key == 'A' || keyCode == LEFT) {
              codigoMov = LEFT;
            }
            if (key == 'd' || key == 'D' || keyCode == RIGHT) {
              codigoMov = RIGHT;
            }

            if (codigoMov != -1) {
              boolean yaContenido = false;
              for (int td = 0; td < cantTeclasDir; td++) {
                if (teclasDireccion[td] == codigoMov) {
                  yaContenido = true;
                  break;
                }
              }
              if (!yaContenido && cantTeclasDir < 4) {
                teclasDireccion[cantTeclasDir] = codigoMov;
                cantTeclasDir++;
              }

              movArriba = false;
              movAbajo = false;
              movIzquierda = false;
              movDerecha = false;
              int ultimaTecla = teclasDireccion[cantTeclasDir - 1];
              if (ultimaTecla == UP) {
                movArriba = true;
              }
              if (ultimaTecla == DOWN) {
                movAbajo = true;
              }
              if (ultimaTecla == LEFT) {
                movIzquierda = true;
              }
              if (ultimaTecla == RIGHT) {
                movDerecha = true;
              }
            }
          }

          // Panel de volumen
          if (estadoActual == MENU && mostrarOpciones) {
            if ((key == 'd' || key == 'D' || keyCode == RIGHT) && nivelVolumen < 10) {
              nivelVolumen++;
              volMaster = nivelVolumen / 10.0f;
              if (musicaFondo != null) {
                musicaFondo.amp(volMaster);
              }
              if (reproductorMp3 != null) {
                reproductorMp3.amp(volMaster);
              }
              if (nv2Audio != null) {
                nv2Audio.amp(volMaster);
              }
              if (sonidoClic != null) {
                sonidoClic.amp(0.5f * volMaster);
                sonidoClic.play();
              }
            }
            if ((key == 'a' || key == 'A' || keyCode == LEFT) && nivelVolumen > 1) {
              nivelVolumen--;
              volMaster = nivelVolumen / 10.0f;
              if (musicaFondo != null) {
                musicaFondo.amp(volMaster);
              }
              if (reproductorMp3 != null) {
                reproductorMp3.amp(volMaster);
              }
              if (nv2Audio != null) {
                nv2Audio.amp(volMaster);
              }
              if (sonidoClic != null) {
                sonidoClic.amp(0.5f * volMaster);
                sonidoClic.play();
              }
            }
            if (botonAtras || keyCode == ENTER || key == ' ') {
              mostrarOpciones = false;
            }
          }

          // Menú principal y pantalla de seleccion en el cielo
          if (estadoActual == MENU && !mostrarOpciones) {
              if (!procesarTeclaMenuCielo(key, keyCode, botonAtras)) {
                if (key == '2') {
                  if (sonidoClic != null) {
                    sonidoClic.amp(0.5f * volMaster);
                    sonidoClic.play();
                  }
                  estadoDestino = SELECCION_DIF_NV2;
                  enTransicion = true;
                } else {
                  if (key == 'd' || key == 'D' || keyCode == RIGHT) {
                    int posicionEnVentana = (opcionSeleccionada - offsetCarrusel + totalBotones) % totalBotones;
                    if (posicionEnVentana >= botonesVisibles - 1) {
                      offsetCarrusel = (offsetCarrusel + 1) % totalBotones;
                    }
                    opcionSeleccionada = (opcionSeleccionada + 1) % totalBotones;
                    if (sonidoHover != null) {
                      sonidoHover.amp(0.15f * volMaster);
                      sonidoHover.play();
                    }
                  }
                  if (key == 'a' || key == 'A' || keyCode == LEFT) {
                    int posicionEnVentana = (opcionSeleccionada - offsetCarrusel + totalBotones) % totalBotones;
                    if (posicionEnVentana <= 0) {
                      offsetCarrusel = (offsetCarrusel - 1 + totalBotones) % totalBotones;
                    }
                    opcionSeleccionada = (opcionSeleccionada - 1 + totalBotones) % totalBotones;
                    if (sonidoHover != null) {
                      sonidoHover.amp(0.15f * volMaster);
                      sonidoHover.play();
                    }
                  }

                  if (keyCode == ENTER || key == ' ') {
                    if (sonidoClic != null) {
                      sonidoClic.amp(0.5f * volMaster);
                      sonidoClic.play();
                    }
                    if (opcionSeleccionada == 0) {
                      cargarPartidasDesdeArchivo();
                      faseCamaraMenu = 1;
                    }
                    if (opcionSeleccionada == 1) {
                      mostrarOpciones = true;
                    }
                    if (opcionSeleccionada == 2) {
                      estadoDestino = CREDITOS;
                      enTransicion = true;
                    }
                    if (opcionSeleccionada == 3) {
                      exit();
                    }
                    if (opcionSeleccionada == 4) {
                      estadoDestino = LOGROS;
                      enTransicion = true;
                    }
                    if (opcionSeleccionada == 5)
                      recAbrir();
                    if (opcionSeleccionada == 6)
                      feriaAbrir();
                  }
                }
              }
            }

            // Diálogo con los padres
            else {
              if (estadoActual == PADRES) {
                if (botonAtras) {
                  estadoDestino = MENU;
                  enTransicion = true;
                } else {
                  if (mostrandoDecisionPadres) {
                    if (key == '1')
                      elegirOpcionPadres(1);
                    if (key == '2')
                      elegirOpcionPadres(2);
                    if (key == '3')
                      elegirOpcionPadres(3);
                  } else {
                    if (keyCode == ENTER || key == ENTER || key == RETURN || key == ' ') {
                      if (!enTransicion && alphaTransicion <= 0) {
                        if (!dialogoCompletado) {
                          charsVisibles = ultimoTextoDialogo.length();
                          dialogoCompletado = true;
                        } else {
                          int limitePaginas = feedbackPadresActivo ? (totalPaginasPadresFeedback - 1) : (totalPaginasPadresInicial - 1);
                          if (paginaPadres < limitePaginas) {
                            paginaPadres++;
                          } else {
                            if (!feedbackPadresActivo) {
                              tieneCelular = true;
                              estadoDestino = NIVEL1;
                              enTransicion = true;
                            } else {
                              if (decisionPadresDesayuno == 0) {
                                mostrandoDecisionPadres = true;
                              } else {
                                habloConPadresPostCelular = true;
                                if (!desayunoTarde) {
                                  desbloquearLogro(1);
                                }
                                estadoDestino = EXPLORACION;
                                enTransicion = true;
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              // Celular
              else {
                if (estadoActual == NIVEL1) {
                  boolean teclaCelularHecha = false;

                  // Teclas para minijuegos en pantalla completa
                  if (!enHome && appAbierta.equals("Frutas")) {
                    if (fueEsc) {
                      enHome = true;
                      appAbierta = "";
                    } else {
                      procesarTeclasFrutas(key, keyCode);
                    }
                    teclaCelularHecha = true;
                  } else {
                    if (!enHome && appAbierta.equals("Pixel Art")) {
                      if (fueEsc) {
                        enHome = true;
                        appAbierta = "";
                        detenerMusicaPixelArt();
                      } else {
                        procesarTeclasPixelArt(key, keyCode);
                      }
                      teclaCelularHecha = true;
                    } else {
                      if (!enHome && appAbierta.equals("Parejas")) {
                        if (fueEsc) {
                          enHome = true;
                          appAbierta = "";
                          teclaCelularHecha = true;
                        }
                      }
                    }
                  }

                  if (!teclaCelularHecha && !enHome && appAbierta.equals("Notas")) {
                    if (key == BACKSPACE) {
                      if (!textoNota.equals("")) {
                        textoNota = textoNota.substring(0, textoNota.length() - 1);
                      }
                      teclaCelularHecha = true;
                    } else {
                      if (key == ENTER || key == RETURN) {
                        textoNota += "\n";
                        teclaCelularHecha = true;
                      } else {
                        if (key >= 32 && key <= 126) {
                          textoNota += key;
                          teclaCelularHecha = true;
                        }
                      }
                    }
                  }

                  if (!teclaCelularHecha && !enHome && appAbierta.equals("Pixagram")) {
                    if (currentTab == 1 && penaltisJugados && !decisionPixagramTomada) {
                      if (key == '1') {
                        ejecutarDecisionPixagramPenaltis(1);
                        teclaCelularHecha = true;
                      } else {
                        if (key == '2') {
                          ejecutarDecisionPixagramPenaltis(2);
                          teclaCelularHecha = true;
                        } else {
                          if (key == '3') {
                            ejecutarDecisionPixagramPenaltis(3);
                            teclaCelularHecha = true;
                          }
                        }
                      }
                    }
                    if (!teclaCelularHecha) {
                      if (currentTab == 2) {
                        if (key == BACKSPACE) {
                          if (newPostText.length() > 0)
                            newPostText = newPostText.substring(0, newPostText.length() - 1);
                        } else {
                          if (key != CODED && key != ENTER && key != RETURN && key != TAB && key != ESC) {
                            if (newPostText.length() < 100)
                              newPostText += key;
                          }
                        }
                        teclaCelularHecha = true;
                      } else {
                        if (currentTab == 3 && activeChatIndex != -1) {
                          if (key == BACKSPACE) {
                            if (newChatMessage.length() > 0)
                              newChatMessage = newChatMessage.substring(0, newChatMessage.length() - 1);
                          } else {
                            if (key == ENTER || key == RETURN) {
                              if (newChatMessage.trim().length() > 0 && convMessageCount[activeChatIndex] < MAX_MENSAJES_CONV) {
                                int mIdx = convMessageCount[activeChatIndex];
                                convMsgSender[activeChatIndex][mIdx] = playerName;
                                convMsgText[activeChatIndex][mIdx] = newChatMessage;
                                convMsgTime[activeChatIndex][mIdx] = "10:43";
                                convMessageCount[activeChatIndex]++;
                                reproducirSfx(SFX_MENSAJE_ENVIADO, 0.5f);
                                newChatMessage = "";
                              }
                            } else {
                              if (key != CODED && key != TAB && key != ESC) {
                                if (newChatMessage.length() < 50)
                                  newChatMessage += key;
                              }
                            }
                          }
                          teclaCelularHecha = true;
                        }
                      }
                    }
                  }

                  if (!teclaCelularHecha && mostrandoModalDormir) {
                    if (key == '1') {
                      mostrandoModalDormir = false;
                      modificarBienestar(-15, width / 2, height / 2 - 40 * escalaY);
                      modificarReputacion(-8, width / 2, height / 2 - 80 * escalaY);
                      activarScreenShake(10, 5.0f);
                      crearPopupFlotante("¡Decidiste jugar un rato más! (-15 Bienestar)", width / 2, height / 2 - 120 * escalaY, color(96, 165, 250));
                      if (sonidoClic != null) {
                        sonidoClic.amp(0.35f * volMaster);
                        sonidoClic.play();
                      }
                      teclaCelularHecha = true;
                    } else {
                      if (key == '2') {
                        mostrandoModalDormir = false;
                        bienestarDigital = min(100, bienestarDigital + 25);
                        puntosJugador += 25;
                        generarParticulasCelebracion(width / 2, height / 2, color(52, 211, 153), 20);
                        if (sonidoClic != null) {
                          sonidoClic.amp(0.4f * volMaster);
                          sonidoClic.play();
                        }
                        if (!penaltisJugados) {
                          paginaEscuela = 0;
                          ultimoTextoDialogo = "";
                          charsVisibles = 0;
                          dialogoCompletado = false;
                          crearPopupFlotante("¡A descansar! (+25 Bienestar Digital)", width / 2, 100 * escalaY, color(52, 211, 153));
                          estadoDestino = NOVELA_ESCUELA;
                          enTransicion = true;
                        } else {
                          if (!dia1Terminado) {
                            timerFinDia1 = 0;
                            estadoDestino = FIN_DIA_1;
                            enTransicion = true;
                          } else {
                            timerTransicionTemporal = 0;
                            crearPopupFlotante("¡A descansar! +25 Bienestar Digital", width / 2, height / 2, color(52, 211, 153));
                            estadoDestino = TRANSICION_TEMPORAL;
                            enTransicion = true;
                          }
                        }
                        teclaCelularHecha = true;
                      } else {
                        if (fueEsc || key == 'c' || key == 'C') {
                          mostrandoModalDormir = false;
                          teclaCelularHecha = true;
                        }
                      }
                    }
                  }

                  if (!teclaCelularHecha) {
                    if (botonAtras) {
                      if (reproductorMp3 != null) {
                        reproductorMp3.stop();
                        reproduciendoMusica = false;
                      }
                      estadoDestino = MENU;
                      enTransicion = true;
                    } else {
                      if (penaltisJugados && !dia1Terminado
                          && (key == 'c' || key == 'C' || key == 'd' || key == 'D' || keyCode == ENTER || key == ENTER || key == RETURN)) {
                        intentarSalirDeCelular();
                      } else {
                        if ((tieneCelular || penaltisJugados) && (key == 'c' || key == 'C' || key == 'd' || key == 'D')) {
                          if (dia1Terminado && juegosDesbloqueados) {
                            mostrandoModalDormir = !mostrandoModalDormir;
                            if (sonidoClic != null) {
                              sonidoClic.amp(0.35f * volMaster);
                              sonidoClic.play();
                            }
                          } else {
                            intentarSalirDeCelular();
                          }
                        }
                      }
                    }
                  }
                }

                // Novela visual de la escuela y penaltis
                else {
                  if (estadoActual == NOVELA_ESCUELA) {
                    if (botonAtras) {
                      estadoDestino = MENU;
                      enTransicion = true;
                      paginaEscuela = 0;
                    } else {
                      if (keyCode == ENTER || key == ENTER || key == RETURN || key == ' ') {
                        if (!enTransicion && alphaTransicion <= 0) {
                          if (!dialogoCompletado) {
                            charsVisibles = ultimoTextoDialogo.length();
                            dialogoCompletado = true;
                          } else {
                            if (paginaEscuela < totalPaginasEscuela - 1) {
                              paginaEscuela++;
                              if (sonidoHover != null) {
                                sonidoHover.amp(0.12f * volMaster);
                                sonidoHover.play();
                              }
                            } else {
                              timerNivel1Intro = 0;
                              estadoDestino = NIVEL1_INTRO;
                              enTransicion = true;
                              if (sonidoClic != null) {
                                sonidoClic.amp(0.4f * volMaster);
                                sonidoClic.play();
                              }
                            }
                          }
                        }
                      }
                    }
                  }

                  // ---------- Fin Dia 1 ----------
                  else {
                    if (estadoActual == FIN_DIA_1) {
                      if ((key == ' ' || keyCode == ENTER || key == RETURN) && !enTransicion && timerFinDia1 > 20) {
                        avanzarDesdeFinDia1();
                      }
                      teclaConsumida = true;
                    }

                    // ---------- Desayuno familiar ----------
                    else {
                      if (estadoActual == DESAYUNO) {
                        if ((key == ' ' || keyCode == ENTER || key == RETURN) && !enTransicion) {
                          procesarClicDesayuno();
                        }
                        teclaConsumida = true;
                      }

                      // Intro
                      else {
                        if (estadoActual == JUEGO) {
                          if (mostrarSaltarIntro) {
                            if (key == 'a' || key == 'A' || keyCode == LEFT) {
                              opcionSaltarIntro = 0;
                              if (sonidoHover != null) {
                                sonidoHover.amp(0.15f * volMaster);
                                sonidoHover.play();
                              }
                            }
                            if (key == 'd' || key == 'D' || keyCode == RIGHT) {
                              opcionSaltarIntro = 1;
                              if (sonidoHover != null) {
                                sonidoHover.amp(0.15f * volMaster);
                                sonidoHover.play();
                              }
                            }
                            if (keyCode == ENTER || key == ' ') {
                              if (sonidoClic != null) {
                                sonidoClic.amp(0.5f * volMaster);
                                sonidoClic.play();
                              }
                              if (opcionSaltarIntro == 0) {
                                estadoDestino = EXPLORACION;
                                enTransicion = true;
                                paginaActual = 0;
                                mostrarSaltarIntro = false;
                              }
                              if (opcionSaltarIntro == 1) {
                                mostrarSaltarIntro = false;
                                ultimoTextoDialogo = "";
                                charsVisibles = 0;
                                dialogoCompletado = false;
                              }
                            }
                          } else {
                            if (keyCode == ENTER || key == ' ') {
                              if (!dialogoCompletado) {
                                charsVisibles = ultimoTextoDialogo.length();
                                dialogoCompletado = true;
                              } else {
                                if (paginaActual < totalPaginasLore - 1) {
                                  paginaActual++;
                                } else {
                                  estadoDestino = EXPLORACION;
                                  enTransicion = true;
                                  paginaActual = 0;
                                }
                              }
                            }
                          }
                        }

                        // Créditos
                        else {
                          if (estadoActual == CREDITOS) {
                            if (!botonAtras) {
                              if (key == 'a' || key == 'A' || keyCode == UP) {
                                nombreSeleccionado = (nombreSeleccionado - 1 + totalNombresCreditos) % totalNombresCreditos;
                              }
                              if (key == 'd' || key == 'D' || keyCode == DOWN) {
                                nombreSeleccionado = (nombreSeleccionado + 1) % totalNombresCreditos;
                              }

                              if (keyCode == ENTER || key == ' ') {
                                for (int i = 0; i < totalCombo - 1; i++) {
                                  secuenciaJugador[i] = secuenciaJugador[i + 1];
                                }
                                secuenciaJugador[totalCombo - 1] = nombreSeleccionado;

                                boolean coincideCombo = true;
                                for (int i = 0; i < totalCombo; i++) {
                                  if (secuenciaJugador[i] != comboSecreto[i]) {
                                    coincideCombo = false;
                                  }
                                }

                                if (coincideCombo && (!logrosDesbloqueados[0] || !logrosPartidaActual[0])) {
                                  desbloquearLogro(0);
                                }
                              }
                            }
                            if (botonAtras) {
                              estadoDestino = MENU;
                              enTransicion = true;
                            }
                          }

                          // Exploración
                          else {
                            if (estadoActual == EXPLORACION) {
                                boolean puedeInteractuar = !animandoEscalera && !enTransicion && alphaTransicion <= 0;

                                if (mostrandoModalDormir) {
                                  if (key == '1') {
                                    mostrandoModalDormir = false;
                                    modificarBienestar(-15, width / 2, height / 2 - 40 * escalaY);
                                    modificarReputacion(-8, width / 2, height / 2 - 80 * escalaY);
                                    activarScreenShake(10, 5.0f);
                                    crearPopupFlotante("¡Decidiste jugar un rato más! (-15 Bienestar)", width / 2, height / 2 - 120 * escalaY,
                                        color(96, 165, 250));
                                    if (sonidoClic != null) {
                                      sonidoClic.amp(0.35f * volMaster);
                                      sonidoClic.play();
                                    }
                                    estadoDestino = NIVEL1;
                                    enHome = true;
                                    appAbierta = "";
                                    enTransicion = true;
                                  } else {
                                    if (key == '2') {
                                      mostrandoModalDormir = false;
                                      bienestarDigital = min(100, bienestarDigital + 25);
                                      puntosJugador += 25;
                                      generarParticulasCelebracion(width / 2, height / 2, color(52, 211, 153), 20);
                                      if (sonidoClic != null) {
                                        sonidoClic.amp(0.4f * volMaster);
                                        sonidoClic.play();
                                      }
                                      if (!penaltisJugados) {
                                        paginaEscuela = 0;
                                        ultimoTextoDialogo = "";
                                        charsVisibles = 0;
                                        dialogoCompletado = false;
                                        crearPopupFlotante("¡A descansar! (+25 Bienestar Digital)", width / 2, 100 * escalaY, color(52, 211, 153));
                                        estadoDestino = NOVELA_ESCUELA;
                                        enTransicion = true;
                                      } else {
                                        if (!dia1Terminado) {
                                          timerFinDia1 = 0;
                                          estadoDestino = FIN_DIA_1;
                                          enTransicion = true;
                                        } else {
                                          timerTransicionTemporal = 0;
                                          crearPopupFlotante("¡A descansar! +25 Bienestar Digital", width / 2, height / 2, color(52, 211, 153));
                                          estadoDestino = TRANSICION_TEMPORAL;
                                          enTransicion = true;
                                        }
                                      }
                                    } else {
                                      if (fueEsc) {
                                        mostrandoModalDormir = false;
                                      }
                                    }
                                  }
                                  teclaConsumida = true;
                                } else {
                                  if (puedeInteractuar
                                      && ((key == 'e' || key == 'E') || (dialogoCamaActivo && (keyCode == ENTER || key == RETURN || key == ' ')))) {
                                    boolean sobreEscalera = samCercaDeAccesoEscalera();

                                    if (sobreEscalera) {
                                      iniciarRecorridoEscalera();
                                    } else {
                                      if (pisoActual == 2 && samCercaDeCama && tieneCelular && desayunoComido) {
                                        if (dialogoCamaActivo) {
                                          dialogoCamaActivo = false;
                                          estadoDestino = NIVEL1;
                                          enHome = true;
                                          appAbierta = "";
                                          desbloquearJuegosConClip();
                                          enTransicion = true;
                                          if (sonidoClic != null) {
                                            sonidoClic.amp(0.35f * volMaster);
                                            sonidoClic.play();
                                          }
                                        } else {
                                          dialogoCamaActivo = true;
                                          leyendoMensaje = false;
                                          if (sonidoClic != null) {
                                            sonidoClic.amp(0.35f * volMaster);
                                            sonidoClic.play();
                                          }
                                        }
                                      } else {
                                        if (pisoActual == 1 && tieneCelular && !desayunoComido && samCercaDeMesa) {
                                          paginaDesayuno = 0;
                                          estadoDestino = DESAYUNO;
                                          leyendoMensaje = false;
                                          enTransicion = true;
                                          if (sonidoClic != null) {
                                            sonidoClic.amp(0.35f * volMaster);
                                            sonidoClic.play();
                                          }
                                        } else {
                                          if (pisoActual == 1 && samCercaDePadres) {
                                            if (!tieneCelular) {
                                              paginaPadres = 0;
                                              feedbackPadresActivo = false;
                                              leyendoMensaje = false;
                                              estadoDestino = PADRES;
                                              enTransicion = true;
                                            } else {
                                              leyendoMensaje = !leyendoMensaje;
                                            }
                                          } else {
                                            leyendoMensaje = !leyendoMensaje;
                                          }
                                        }
                                      }
                                    }
                                  }
                                }

                                if (tieneCelular && puedeInteractuar && (key == 'c' || key == 'C')) {
                                  estadoDestino = NIVEL1;
                                  enTransicion = true;
                                } else {
                                  if (modoDebug) {
                                    float paso = 2;
                                    char tecla = (key >= 'A' && key <= 'Z') ? PApplet.parseChar(key + 32) : key;

                                    if (tecla == 'i') {
                                      hitOffY -= paso;
                                      println("hitOffY = " + hitOffY);
                                    }
                                    if (tecla == 'k') {
                                      hitOffY += paso;
                                      println("hitOffY = " + hitOffY);
                                    }
                                    if (tecla == 'j') {
                                      hitOffX -= paso;
                                      println("hitOffX = " + hitOffX);
                                    }
                                    if (tecla == 'l') {
                                      hitOffX += paso;
                                      println("hitOffX = " + hitOffX);
                                    }
                                    if (tecla == 'o') {
                                      hitW += paso;
                                      println("hitW = " + hitW);
                                    }
                                    if (tecla == 'u') {
                                      hitW -= paso;
                                      println("hitW = " + hitW);
                                    }
                                    if (tecla == 'n') {
                                      hitH += paso;
                                      println("hitH = " + hitH);
                                    }
                                    if (tecla == 'h') {
                                      hitH -= paso;
                                      println("hitH = " + hitH);
                                    }
                                  }
                                }
                            }

                            // Logros
                            else {
                              if (estadoActual == LOGROS) {
                                if (botonAtras) {
                                  estadoDestino = MENU;
                                  enTransicion = true;
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
        }

      }

    }

    }

  }
}

// =====================================================
// KEY RELEASED
// =====================================================
void keyReleased() {
  if (key == ENTER || key == RETURN || key == ' ') guiaAvanceCelularPulsado = false;
  if (keyCode == GUIA_TECLA) guiaF1Presionada = false;
  boolean flujoRetornoActivo = true;

  if (soltarTeclaHistoria3()) {
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    if (estadoActual == NIVEL1 && !enHome && appAbierta.equals("Pixel Art")) {
      procesarSoltarTeclasPixelArt(key);
    } else {
      if (estadoActual == NIVEL2) {
        int carrilSoltado = obtenerCarrilPorTeclaNv2(key, keyCode);
        if (carrilSoltado >= 0 && carrilSoltado < MAX_CARRILES_NV2) {
          nv2TeclaCarrilPresionada[carrilSoltado] = false;
          if (carrilSoltado == 0)
            nv2TeclaIzqPresionada = false;
          if (carrilSoltado == 1)
            nv2TeclaDerPresionada = false;
        }
      } else {
        int codigoMov = -1;
        if (key == 'w' || key == 'W' || keyCode == UP) {
          codigoMov = UP;
        }
        if (key == 's' || key == 'S' || keyCode == DOWN) {
          codigoMov = DOWN;
        }
        if (key == 'a' || key == 'A' || keyCode == LEFT) {
          codigoMov = LEFT;
        }
        if (key == 'd' || key == 'D' || keyCode == RIGHT) {
          codigoMov = RIGHT;
        }

        if (codigoMov != -1) {
          for (int i = 0; i < cantTeclasDir; i++) {
            if (teclasDireccion[i] == codigoMov) {
              for (int j = i; j < cantTeclasDir - 1; j++) {
                teclasDireccion[j] = teclasDireccion[j + 1];
              }
              cantTeclasDir--;
              break;
            }
          }

          movArriba = false;
          movAbajo = false;
          movIzquierda = false;
          movDerecha = false;
          if (cantTeclasDir > 0) {
            int ultimaTecla = teclasDireccion[cantTeclasDir - 1];
            if (ultimaTecla == UP) {
              movArriba = true;
            }
            if (ultimaTecla == DOWN) {
              movAbajo = true;
            }
            if (ultimaTecla == LEFT) {
              movIzquierda = true;
            }
            if (ultimaTecla == RIGHT) {
              movDerecha = true;
            }
          }
        }
      }
    }

  }
}

// =====================================================
// MOUSE RELEASED Y MOUSE DRAGGED
// =====================================================
void mouseReleased() {
  if (estadoActual == NIVEL1 && !enHome && appAbierta.equals("Pixel Art")) {
    procesarSoltarPixelArt();
  } else {
    if (estadoActual == NIVEL2) {
      nv2TeclaIzqPresionada = false;
      nv2TeclaDerPresionada = false;
      for (int c = 0; c < MAX_CARRILES_NV2; c++) {
        nv2TeclaCarrilPresionada[c] = false;
      }
    }
  }
}

void mouseDragged() {
  if (transicionBloqueaEntrada()) return;
  if (estadoActual == NIVEL1 && !enHome) {
    if (appAbierta.equals("Pixel Art")) {
      procesarArrastrePixelArt(mouseButton);
    }
  }
}
void dibujarBarraEstadoCelular() {
  float barraH = 28;
  float barraYCentro = 16;
  fill(10, 14, 22, 245);
  noStroke();
  rect(0, 0, pantallaW, barraH);

  fill(255);
  textSize(12.5);
  textAlign(LEFT, CENTER);
  String txtHora = (horaReloj < 10 ? "0" : "") + horaReloj + ":" + (minutoReloj < 10 ? "0" : "") + minutoReloj;
  text(txtHora, 10, barraYCentro);

  float corazonX = 54;
  float corazonY = barraYCentro;
  fill(255, 75, 95);
  noStroke();
  ellipse(corazonX - 2.5, corazonY - 2, 5, 5);
  ellipse(corazonX + 2.5, corazonY - 2, 5, 5);
  triangle(corazonX - 4.8, corazonY - 1, corazonX + 4.8, corazonY - 1, corazonX, corazonY + 4.8);

  fill(38, 46, 58);
  rect(corazonX + 7, barraYCentro - 4, 34, 8, 3);
  if (bienestarDigital > 60) { fill(80, 225, 120); }
  else { if (bienestarDigital > 30) { fill(255, 195, 50); }
  else { fill(255, 70, 70); } }
  rect(corazonX + 7, barraYCentro - 4, constrain(34 * (bienestarDigital / 100.0), 0, 34), 8, 3);

  float estrellaX = pantallaW - 70;
  float estrellaY = barraYCentro;
  fill(255, 215, 50);
  noStroke();
  pushMatrix();
  translate(estrellaX, estrellaY);
  beginShape();
  for (int s = 0; s < 5; s++) {
    float aExt = -HALF_PI + s * TWO_PI / 5.0;
    float aInt = aExt + PI / 5.0;
    vertex(cos(aExt) * 5.5, sin(aExt) * 5.5);
    vertex(cos(aInt) * 2.5, sin(aInt) * 2.5);
  }
  endShape(CLOSE);
  popMatrix();

  fill(255, 220, 80);
  textSize(11);
  textAlign(LEFT, CENTER);
  text("" + reputacionDigital, estrellaX + 8, estrellaY);

  stroke(180);
  strokeWeight(1);
  noFill();
  rect(pantallaW - 28, barraYCentro - 5, 18, 10, 2);
  fill(bateriaPct > 20 ? color(80, 225, 120) : color(255, 70, 70));
  noStroke();
  rect(pantallaW - 27, barraYCentro - 4, constrain(16 * (bateriaPct / 100.0), 0, 16), 8, 1);
  fill(180);
  rect(pantallaW - 10, barraYCentro - 2, 1.5, 4);
}


// =========================================================================
// INDICATIVOS DE EXPLORACION
void dibujarIndicativoFlotante(PImage icono, float x, float y, float tam, float fase) {
  if (icono != null && icono.width > 0) {
    pushStyle();
    imageMode(CENTER);
    image(icono, x, y + sin(frameCount * 0.07f + fase) * 6 * escalaY, tam, tam);
    popStyle();
  }
}

// INTERACCIÓN: PLATO DE DESAYUNO EN LA MESA DEL COMEDOR
// =========================================================================
void dibujarPlatoDesayunoEnMesa(float x, float y) {
  pushStyle();
  rectMode(CENTER);
  ellipseMode(CENTER);

  // Sombra del plato
  fill(0, 45);
  noStroke();
  ellipse(x + 2, y + 8, 54 * escalaX, 28 * escalaY);

  // Plato de porcelana
  fill(245, 248, 250);
  stroke(200, 210, 220);
  strokeWeight(2);
  ellipse(x, y + 4, 52 * escalaX, 26 * escalaY);

  // Reborde interior
  noFill();
  stroke(220, 230, 238);
  strokeWeight(1);
  ellipse(x, y + 4, 42 * escalaX, 20 * escalaY);

  // Pila de 3 panqueques dorados
  fill(225, 168, 85);
  stroke(185, 125, 50);
  strokeWeight(1.2);
  ellipse(x, y + 4, 34 * escalaX, 16 * escalaY);

  fill(238, 185, 102);
  stroke(195, 138, 60);
  ellipse(x, y + 1, 31 * escalaX, 15 * escalaY);

  fill(248, 198, 115);
  stroke(205, 148, 68);
  ellipse(x, y - 2, 28 * escalaX, 14 * escalaY);

  // Miel / Sirope derramado
  fill(215, 135, 30, 210);
  noStroke();
  ellipse(x + 2, y - 1, 16 * escalaX, 8 * escalaY);
  ellipse(x - 5, y + 2, 7 * escalaX, 4 * escalaY);

  // Cuadrito de mantequilla derritiéndose
  fill(255, 240, 140);
  stroke(220, 190, 80);
  strokeWeight(1);
  rect(x + 1, y - 3, 7 * escalaX, 5 * escalaY, 1.5);

  // Vaso de jugo de naranja al lado
  fill(0, 30);
  noStroke();
  ellipse(x + 26 * escalaX, y - 6 * escalaY + 2, 12 * escalaX, 7 * escalaY);
  fill(255, 160, 40, 230);
  stroke(255, 220, 160, 180);
  strokeWeight(1);
  rect(x + 26 * escalaX, y - 10 * escalaY, 10 * escalaX, 14 * escalaY, 2);

  // Vapor caliente animado si aún no se ha desayunado
  if (!desayunoComido) {
    stroke(255, 255, 255, 110 + 60 * sin(frameCount * 0.08));
    strokeWeight(1.5);
    noFill();
    float vaporOff = sin(frameCount * 0.1) * 3 * escalaX;
    line(x - 4 + vaporOff, y - 6 * escalaY, x - 2 + vaporOff, y - 18 * escalaY);
    line(x + 4 - vaporOff, y - 8 * escalaY, x + 6 - vaporOff, y - 22 * escalaY);
  }

  popStyle();
}

// =========================================================================
// ESCENA INTERACTIVA: DESAYUNO FAMILIAR
// =========================================================================
void dibujarEscenaDesayuno() {
  pushStyle();
  background(20, 18, 25);

  // Fondo acogedor del comedor / cocina
  if (imgEscenaDesayuno != null && imgEscenaDesayuno.width > 0) {
    image(imgEscenaDesayuno, 0, 0, width, height);
  } else {
    // Fondo de respaldo ilustrado cálido
    for (int y = 0; y < height; y++) {
      float inter = map(y, 0, height, 0, 1);
      stroke(lerpColor(color(45, 30, 40), color(20, 15, 22), inter));
      line(0, y, width, y);
    }
  }

  // Capa cálida de iluminación matutina
  noStroke();
  fill(255, 230, 180, 28);
  rect(0, 0, width, height);

  // Título superior de la escena
  fill(25, 20, 30, 190);
  rect(width / 2 - 200 * escalaX, 22 * escalaY, 400 * escalaX, 42 * escalaY, 10);
  fill(255, 220, 130);
  textAlign(CENTER, CENTER);
  textSize(18 * escalaX);
  text("COMEDOR FAMILIAR - DESAYUNO", width / 2, 43 * escalaY);

  // Zona central interactiva (animación de comer en página 2)
  if (paginaDesayuno == 2) {
    // Tarjeta central especial del desayuno
    fill(20, 24, 36, 230);
    stroke(245, 158, 11);
    strokeWeight(2.5 * escalaX);
    rect(width / 2 - 280 * escalaX, height * 0.22, 560 * escalaX, 210 * escalaY, 18);

    // Dibujar plato grande de panqueques
    float cpx = width / 2;
    float cpy = height * 0.32;
    ellipseMode(CENTER);
    fill(0, 60);
    ellipse(cpx + 4, cpy + 24, 140 * escalaX, 55 * escalaY);
    fill(248, 250, 252);
    stroke(203, 213, 225);
    strokeWeight(3);
    ellipse(cpx, cpy + 18, 130 * escalaX, 50 * escalaY);

    // 3 panqueques grandes
    fill(217, 148, 62);
    stroke(180, 110, 40);
    ellipse(cpx, cpy + 14, 95 * escalaX, 36 * escalaY);
    fill(235, 172, 85);
    ellipse(cpx, cpy + 6, 88 * escalaX, 34 * escalaY);
    fill(245, 192, 106);
    ellipse(cpx, cpy - 2, 80 * escalaX, 32 * escalaY);

    // Miel y mantequilla
    fill(217, 119, 6, 220);
    noStroke();
    ellipse(cpx + 4, cpy, 44 * escalaX, 18 * escalaY);
    fill(254, 240, 138);
    stroke(234, 179, 8);
    strokeWeight(1.5);
    rect(cpx + 2, cpy - 6, 16 * escalaX, 12 * escalaY, 3);

    // Barra de vitalidad y bienestar digital
    float barraW = 380 * escalaX;
    float barraH = 22 * escalaY;
    float barraX = width / 2 - barraW / 2;
    float barraY = height * 0.40;
    fill(15, 23, 42);
    stroke(51, 65, 85);
    rect(barraX, barraY, barraW, barraH, 8);

    float progresoBarra = constrain((millis() % 2000) / 1600.0f, 0.4f, 1.0f);
    fill(52, 211, 153);
    noStroke();
    rect(barraX + 2, barraY + 2, (barraW - 4) * progresoBarra, barraH - 4, 6);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(13 * escalaX);
    text("ENERGÍA FAMILIAR Y BIENESTAR AL 100%", width / 2, barraY + barraH / 2);
  }

  // Cuadro de diálogo unificado (mismo tamaño, fondo y posición que todo el juego)
  float cajaAncho = width * 0.85;
  float cajaAlto = height * 0.25;
  float cajaX = (width - cajaAncho) / 2;
  float cajaY = height - cajaAlto - 40;

  fill(0, 210);
  noStroke();
  rectMode(CORNER);
  rect(cajaX, cajaY, cajaAncho, cajaAlto, 15);

  // Textos y hablante por página
  String nombreHablante = "";
  String linea1 = "";
  String linea2 = "";
  String textoBoton = "CONTINUAR >>";

  if (paginaDesayuno == 0) {
    nombreHablante = "MAMÁ";
    linea1 = "¡Sam, ven! Los panqueques todavía están calientitos.";
    linea2 = "Te serví jugo de naranja. Siéntate, que ya vamos a empezar.";
    textoBoton = "SENTARSE A LA MESA >>";
  } else { if (paginaDesayuno == 1) {
    nombreHablante = "PAPÁ";
    linea1 = "A ver, campeón, ¿me pasas la miel?";
    linea2 = "Tu mamá hizo un montón, pero si te demoras me los como todos.";
    textoBoton = "PASARLE LA MIEL >>";
  } else { if (paginaDesayuno == 2) {
    nombreHablante = "SAM";
    linea1 = "¡Ey, déjame los míos! Apenas me estoy sentando.";
    linea2 = "Mmm... ¡están buenísimos, má!";
    textoBoton = "SEGUIR DESAYUNANDO >>";
  } else { if (paginaDesayuno == 3) {
    nombreHablante = "MAMÁ";
    linea1 = "Come tranquilo, mi amor. Todavía tenemos tiempo.";
    linea2 = "¿Ya guardaste los cuadernos y la cartuchera en la maleta?";
    textoBoton = "RESPONDER >>";
  } else { if (paginaDesayuno == 4) {
    nombreHablante = "SAM";
    linea1 = "¡Sí, ya está todo! Voy por la maleta.";
    linea2 = "¡Gracias por el desayuno! Nos vemos más tarde.";
    textoBoton = "SALIR AL COLEGIO >>";
  } } } } }

  // Nombre del interlocutor en verde idéntico a todo el juego
  fill(100, 220, 120);
  textAlign(LEFT, TOP);
  textSize(26 * escalaX);
  text(nombreHablante + ":", cajaX + 30, cajaY + 20);

  // Texto del diálogo
  fill(240);
  textSize(20 * escalaX);
  float anchoTextoDesayuno = cajaAncho - 60 - 320 * escalaX;
  text(linea1 + "\n" + linea2, cajaX + 30, cajaY + 58, anchoTextoDesayuno, cajaAlto - 75);

  // Botón con la estética de madera / dorado de los botones de pausa (Imagen 2)
  float btnW = 300 * escalaX;
  float btnH = 48 * escalaY;
  float btnX = cajaX + cajaAncho - btnW - 25 * escalaX;
  float btnY = cajaY + cajaAlto - btnH - 18 * escalaY;
  boolean hoverBtn = (mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= btnY && mouseY <= btnY + btnH);

  // Base del botón con borde chocolate
  if (hoverBtn) { fill(255, 220, 100); } else { fill(180, 120, 60); }
  stroke(100, 50, 20);
  strokeWeight(3.5);
  rect(btnX, btnY, btnW, btnH, 8);

  // Brillo superior (gloss highlight)
  noStroke();
  if (hoverBtn) { fill(255, 240, 150, 100); } else { fill(200, 150, 90, 100); }
  rect(btnX + 4, btnY + 4, btnW - 8, btnH / 2 - 4, 4);

  // Texto con sombra pixel art
  if (fuenteComic != null) textFont(fuenteComic);
  textAlign(CENTER, CENTER);
  textSize(16 * escalaX);
  if (!hoverBtn) {
    fill(100, 50, 20);
    text(textoBoton, btnX + btnW / 2 + 1.5f, btnY + btnH / 2 + 1.5f);
    fill(255);
  } else {
    fill(50, 20, 0);
  }
  text(textoBoton, btnX + btnW / 2, btnY + btnH / 2);
  popStyle();

}
void procesarClicDesayuno() {
  if (sonidoClic != null) { sonidoClic.amp(0.35 * volMaster); sonidoClic.play(); }

  if (paginaDesayuno < 4) {
    paginaDesayuno++;
  } else {
    desayunoComido = true;
    habloConPadresPostCelular = true;
    modificarBienestar(20, width / 2, height / 2);
    modificarReputacion(10, width / 2, height / 2 - 40 * escalaY);
    puntosJugador += 30;
    desbloquearLogro(1); // Desayuno consciente
    generarParticulasCelebracion(width / 2, height / 2, color(245, 158, 11), 22);
    estadoDestino = EXPLORACION;
    enTransicion = true;
    crearPopupFlotante("¡Desayuno nutritivo completado! Sube a tu habitación.", width / 2, 100 * escalaY, color(52, 211, 153));
  }
}

// =========================================================================
// CINEMÁTICA: FIN DEL DÍA 1 (SIMILAR A NIVEL 1 Y NIVEL 2)
// =========================================================================
void dibujarFinDia1() {
  background(0);
  if (!enPausa) {
    timerFinDia1++;
  }

  float progresoIntro = constrain(timerFinDia1 / float(DURACION_FIN_DIA_1), 0, 1);
  float alfaTexto = 255;
  if (timerFinDia1 < 30) {
    alfaTexto = map(timerFinDia1, 0, 30, 0, 255);
  } else { if (timerFinDia1 > DURACION_FIN_DIA_1 - 30) {
    alfaTexto = map(timerFinDia1, DURACION_FIN_DIA_1 - 30, DURACION_FIN_DIA_1, 255, 0);
  } }

  pushStyle();
  textAlign(CENTER, CENTER);

  // Resplandor sutil detrás del título
  fill(56, 189, 248, alfaTexto * 0.28);
  textSize(84 * escalaX);
  text("FIN DEL DÍA 1", width / 2 + 4, height / 2 - 25 * escalaY + 4);

  fill(186, 230, 253, alfaTexto);
  textSize(82 * escalaX);
  text("FIN DEL DÍA 1", width / 2, height / 2 - 25 * escalaY);

  fill(224, 242, 254, alfaTexto * 0.92);
  textSize(24 * escalaX);
  text("EMOCIÓN EN LA CANCHA Y PRIMEROS MENSAJES", width / 2, height / 2 + 48 * escalaY);

  // Línea decorativa animada
  stroke(56, 189, 248, alfaTexto * 0.85);
  strokeWeight(3.5);
  float anchoLinea = 380 * escalaX * sin(progresoIntro * PI);
  line(width / 2 - anchoLinea / 2, height / 2 + 12 * escalaY, width / 2 + anchoLinea / 2, height / 2 + 12 * escalaY);

  // Indicador inferior
  fill(148, 163, 184, alfaTexto * 0.7);
  textSize(18 * escalaX);
  text("(Presiona ESPACIO o haz clic para continuar)", width / 2, height - 70 * escalaY);
  popStyle();

  if (!enPausa && timerFinDia1 >= DURACION_FIN_DIA_1 && !enTransicion) {
    avanzarDesdeFinDia1();
  }
}

void avanzarDesdeFinDia1() {
  dia1Terminado = true;
  pisoActual = 1;
  pjX = width * 0.50f;
  pjY = height * 0.78f;
  direccionSam = "norte";
  samCaminando = false;
  animandoEscalera = false;
  leyendoMensaje = false;
  enHome = true;
  appAbierta = "";
  timerFinDia1 = 0;
  if (sonidoClic != null) { sonidoClic.amp(0.4 * volMaster); sonidoClic.play(); }
  estadoDestino = EXPLORACION;
  enTransicion = true;
  crearPopupFlotante("¡Has vuelto a casa! Sube a tu cuarto en el segundo piso.", width / 2, 100 * escalaY, color(96, 165, 250));
}

void dibujarDialogoCama() {
  pushStyle();
  float cajaAncho = width * 0.85;
  float cajaAlto = height * 0.25;
  float cajaX = (width - cajaAncho) / 2;
  float cajaY = height - cajaAlto - 40;

  fill(0, 210);
  noStroke();
  rectMode(CORNER);
  rect(cajaX, cajaY, cajaAncho, cajaAlto, 15);

  fill(100, 220, 120);
  textAlign(LEFT, TOP);
  textSize(26 * escalaX);
  text("SAM:", cajaX + 30, cajaY + 20);

  // =========================================================================
  // AQUÍ PUEDES MODIFICAR EL TEXTO DE SAM AL ACOSTARSE EN LA CAMA:
  // =========================================================================
  String textoDialogoCama = "¡Uff, qué rico se siente acostarse un ratico en la cama!\n" +
                            "Espera un momento... ¿qué es esto? ¡No me había dado cuenta de que el celular tenía juegos instalados!";

  fill(240);
  textSize(21 * escalaX);
  text(textoDialogoCama, cajaX + 30, cajaY + 60, cajaAncho - 60, cajaAlto - 80);

  fill(150);
  textAlign(RIGHT, BOTTOM);
  textSize(15 * escalaX);
  text("Clic, ENTER o ESPACIO: Abrir celular | 'M' Menú", cajaX + cajaAncho - 20, cajaY + cajaAlto - 15);
  popStyle();
}

// =====================================================
// CONTROL CENTRALIZADO DE MUSICA DE FONDO POR ESTADO
// Solo suena en el menu, las novelas visuales y exploracion xd
// =====================================================
boolean estadoPermiteMusicaFondo(int est) {
  boolean permitido = (est == MENU || est == RECUERDOS || est == JUEGO || est == EXPLORACION || est == PADRES || est == DESAYUNO || est == NOVELA_ESCUELA || est == NOVELA_COCINA);
  return permitido;
}

boolean procesarClicFlechasMenu() {
  boolean consumido = false;
  if (!enTransicion && alphaTransicion <= 0 && !mostrarOpciones && faseCamaraMenu == 0 && mouseButton == LEFT) {
    float ancho = REF_W * 0.02f * escalaX;
    float margen = REF_W * 0.015f * escalaX;
    float centroY = btnY[0] + btnH[0] / 2;
    // La zona incluye todo el recorrido vertical de la animación.
    if (abs(mouseY - centroY) <= ancho + 12 * escalaY) {
      float izquierda = btnX[0] - margen;
      float derecha = btnX[botonesVisibles - 1] + btnW[botonesVisibles - 1] + margen;
      if (mouseX >= izquierda - ancho - 10 * escalaX && mouseX <= izquierda + 10 * escalaX) {
        offsetCarrusel = (offsetCarrusel - 1 + totalBotones) % totalBotones;
        opcionSeleccionada = offsetCarrusel;
        consumido = true;
      }
      if (mouseX >= derecha - 10 * escalaX && mouseX <= derecha + ancho + 10 * escalaX) {
        offsetCarrusel = (offsetCarrusel + 1) % totalBotones;
        opcionSeleccionada = (offsetCarrusel + botonesVisibles - 1) % totalBotones;
        consumido = true;
      }
    }
    if (consumido && sonidoClic != null) {
      sonidoClic.amp(0.35f * volMaster);
      sonidoClic.play();
    }
  }
  return consumido;
}

void actualizarMusicaFondoPorEstado() {
  // si salimos de nivel 1 (celular) apagamos musica del mp3 o pixel art si quedo sonando xd
  if (ultimoEstadoAudioControl == NIVEL1 && estadoActual != NIVEL1) {
    if (reproductorMp3 != null && reproduciendoMusica) {
      reproductorMp3.stop();
      reproduciendoMusica = false;
    }
    detenerMusicaPixelArt();
  }
  ultimoEstadoAudioControl = estadoActual;

  boolean destinoPermite = !enTransicion || estadoPermiteMusicaFondo(estadoDestino);
  boolean debeSonarAhora = estadoPermiteMusicaFondo(estadoActual) && destinoPermite;

  if (musicaFondo != null) {
    if (debeSonarAhora) {
      if (!musicaFondoDeberiaSonar || !musicaFondo.isPlaying()) {
        musicaFondo.loop();
        musicaFondo.amp(volMaster);
        musicaFondoDeberiaSonar = true;
      }
    } else {
      if (musicaFondoDeberiaSonar || musicaFondo.isPlaying()) {
        musicaFondo.stop();
        musicaFondoDeberiaSonar = false;
      }
    }
  }
}

void dibujarSamExploracion() {
  pushStyle();
  pushMatrix();
  imageMode(CORNER);
  rectMode(CORNER);
  noTint();
  PImage spriteActual = null;
  if (samCaminando) {
    if (direccionSam.equals("norte")) {
      spriteActual = spriteCaminarNorte[frameAnimActual];
    } else {
      if (direccionSam.equals("sur")) {
        spriteActual = spriteCaminarSur[frameAnimActual];
      } else {
        if (direccionSam.equals("este")) {
          spriteActual = spriteCaminarEste[frameAnimActual];
        } else {
          if (direccionSam.equals("oeste")) {
            spriteActual = spriteCaminarOeste[frameAnimActual];
          }
        }
      }
    }
  } else {
    if (direccionSam.equals("norte")) {
      spriteActual = spriteIdle[0];
    } else {
      if (direccionSam.equals("sur")) {
        spriteActual = spriteIdle[1];
      } else {
        if (direccionSam.equals("este")) {
          spriteActual = spriteIdle[2];
        } else {
          if (direccionSam.equals("oeste")) {
            spriteActual = spriteIdle[3];
          }
        }
      }
    }
  }

  if (animandoEscalera) {
    float xPies = piesSamX();
    float yPies = piesSamY();
    translate(xPies, yPies);
    scale(escalaSamEscalera);
    translate(-xPies, -yPies);
  }
  if (spriteActual != null) {
    image(spriteActual, pjX, pjY);
  } else {
    fill(100, 255, 100);
    noStroke();
    rect(pjX, pjY, pjW, pjH);
  }
  popMatrix();
  popStyle();
}

void dibujarPadresExploracion(float pSpriteW, float pSpriteH) {
  pushStyle();
  imageMode(CORNER);
  rectMode(CORNER);
  noTint();
  if (imgMama != null && imgMama.width > 0) {
    image(imgMama, padresX, padresY, pSpriteW, pSpriteH);
  } else {
    noStroke();
    fill(255, 190, 210);
    rect(padresX, padresY, pSpriteW, pSpriteH);
  }
  if (imgPapa != null && imgPapa.width > 0) {
    image(imgPapa, padresX + padresSep, padresY, pSpriteW, pSpriteH);
  } else {
    noStroke();
    fill(190, 210, 255);
    rect(padresX + padresSep, padresY, pSpriteW, pSpriteH);
  }

  fill(255);
  textAlign(CENTER, BOTTOM);
  textSize(14 * escalaX);
  text("MAMÁ", padresX + (pSpriteW * 0.5f), padresY);
  text("PAPÁ", padresX + padresSep + (pSpriteW * 0.5f), padresY);
  popStyle();
}

void dibujarAvisoInteraccionExploracion(String msg) {
  pushStyle();
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(20 * escalaX);
  float mitadW = textWidth(msg) * 0.5f;
  float minX = limIzq + mitadW + 8 * escalaX;
  float maxX = limDer - mitadW - 8 * escalaX;
  float posX = pjX + (pjW * 0.5f);
  if (minX <= maxX) {
    posX = constrain(posX, minX, maxX);
  } else {
    posX = (limIzq + limDer) * 0.5f;
  }
  float posY = max(24 * escalaY, pjY - 20 * escalaY);
  text(msg, posX, posY);
  popStyle();
}

boolean pixagramPermitePausaGlobal() {
  return estadoActual == NIVEL1 && !enHome && appAbierta.equals("Pixagram") && !mostrandoModalDormir;
}

boolean estadoPermitePausaGlobal() {
  boolean permitido = false;
  if (!feriaActiva && !enTransicion && !mostrarResumenPuntos) {
    if (t3Activa || hcActiva || pixagramPermitePausaGlobal()) {
      permitido = true;
    } else {
      if (estadoActual == JUEGO || estadoActual == PADRES || estadoActual == DESAYUNO
          || estadoActual == NOVELA_ESCUELA || estadoActual == FIN_DIA_1
          || estadoActual == TRANSICION_TEMPORAL || estadoActual == NOVELA_COCINA
          || estadoActual == SELECCION_DIF_NV2 || estadoActual == NIVEL2_INTRO
          || estadoActual == NIVEL2) {
        permitido = true;
      } else {
        if (estadoActual == EXPLORACION && !mostrandoModalDormir && !animandoEscalera) {
          permitido = true;
        }
      }
    }
  }
  return permitido;
}

boolean teclaAbrePausaGlobal(char k, int kCode, boolean fueEsc) {
  if (pixagramPermitePausaGlobal()) return fueEsc && estadoPermitePausaGlobal();
  boolean esP = (k == 'p') || (k == 'P' && !modoDebug);
  boolean esM = (k == 'm' || k == 'M');
  boolean esArcadeM = (t3Activa && t3Etapa == 4 && !t3IntroActiva && !finalNivel3Activo
      && (nv3_estadoMenu == 2 || nv3_pantalla >= 1));
  boolean mAbrePausa = (t3Activa && !esArcadeM) || hcActiva || estadoActual == JUEGO
      || estadoActual == EXPLORACION || estadoActual == FIN_DIA_1
      || estadoActual == TRANSICION_TEMPORAL || estadoActual == NOVELA_COCINA
      || estadoActual == SELECCION_DIF_NV2 || estadoActual == NIVEL2_INTRO
      || estadoActual == NIVEL2;
  boolean abre = estadoPermitePausaGlobal() && (esP || fueEsc || (esM && mAbrePausa));
  return abre;
}

int obtenerEstadoRealParaGuardado() {
  int est = estadoActual;
  if (t3Activa) {
    est = HISTORIA3_ARCADE;
  } else {
    if (hcActiva) {
      est = HISTORIA_POST_COCINA;
    }
  }
  return est;
}

void activarPausaGlobal() {
  enPausa = true;
  mostrarOpciones = false;
  opcionPausaSeleccionada = 0;
  opcionPausaHover = -1;
  pausaInicioMs = millis();

  movArriba = false;
  movAbajo = false;
  movIzquierda = false;
  movDerecha = false;
  cantTeclasDir = 0;

  nv2TeclaIzqPresionada = false;
  nv2TeclaDerPresionada = false;
  for (int c = 0; c < MAX_CARRILES_NV2; c++) {
    nv2TeclaCarrilPresionada[c] = false;
  }

  nv2AudioEstabaSonandoAntesDePausa = false;
  if (estadoActual == NIVEL2 && !hcActiva && !t3Activa && nv2SubEstado == NV2_SUB_JUGANDO && !nv2ExtremoFaseAlerta && nv2Audio != null) {
    try {
      if (nv2Audio.isPlaying()) {
        nv2AudioPosPausaSeg = nv2Audio.position();
        nv2AudioEstabaSonandoAntesDePausa = true;
        nv2Audio.pause();
      }
    } catch (Exception e) {
    }
  }

  nv3VideoEstabaSonandoAntesDePausa = false;
  if (t3Activa && t3Etapa == 4 && !t3IntroActiva && !finalNivel3Activo && nv3_videoListo && nv3_videoFondo != null && nv3_estadoMenu >= 0) {
    try {
      nv3VideoEstabaSonandoAntesDePausa = true;
      nv3_videoFondo.pause();
    } catch (Exception e) {
    }
  }

  if (t3Activa && t3Etapa == 4 && !t3IntroActiva && !finalNivel3Activo) {
    nv3_limpiarControles();
  }

  reproducirSfx(SFX_PAUSA, 0.5f);
}

void desactivarPausaGlobal() {
  int deltaPausa = max(0, millis() - pausaInicioMs);
  enPausa = false;
  mostrarOpciones = false;

  if (estadoActual == NIVEL2 && !hcActiva && !t3Activa && nv2SubEstado == NV2_SUB_JUGANDO) {
    nv2TiempoInicioMs += deltaPausa;
    if (nv2ExtremoFaseAlerta) {
      nv2ExtremoAlertaInicioMs += deltaPausa;
    }
    if (nv2AudioEstabaSonandoAntesDePausa && !nv2ExtremoFaseAlerta && nv2Audio != null) {
      try {
        float pos = max(0.0f, nv2AudioPosPausaSeg);
        float dur = nv2Audio.duration();
        if (dur > 0.1f) {
          pos = constrain(pos, 0.0f, max(0.0f, dur - 0.05f));
        }
        nv2Audio.cue(pos);
        nv2Audio.rate(1.0f);
        nv2Audio.amp(volMaster);
        nv2Audio.jump(pos);
        if (!nv2Audio.isPlaying()) {
          nv2Audio.play();
        }
      } catch (Exception e) {
        try {
          if (!nv2Audio.isPlaying()) nv2Audio.play();
        } catch (Exception ex) {
        }
      }
    }
  }
  nv2AudioEstabaSonandoAntesDePausa = false;

  if (t3Activa) {
    if (t3Etapa == 2) {
      t3InicioEscena += deltaPausa;
    }
    t3TickTexto = millis();
    if (t3IntroActiva) {
      t3IntroInicio += deltaPausa;
    }
    if (finalNivel3Activo) {
      finalNivel3InicioCreditos += deltaPausa;
    }
    if (t3Etapa == 4 && !t3IntroActiva && !finalNivel3Activo) {
      nv3_ultimoTiempo = millis();
      nv3_limpiarControles();
      if (nv3VideoEstabaSonandoAntesDePausa && nv3_videoListo && nv3_videoFondo != null && nv3_estadoMenu >= 0) {
        try {
          nv3_videoFondo.loop();
          nv3_videoFondo.volume(0);
        } catch (Exception e) {
        }
      }
    }
  }
  nv3VideoEstabaSonandoAntesDePausa = false;

  reproducirSfx(SFX_PAUSA, 0.5f);
}

void ejecutarOpcionPausaGlobal(int opcion) {
  if (opcion == 0) {
    desactivarPausaGlobal();
  } else {
    if (opcion == 1) {
      guardarPartidaEnArchivo(obtenerEstadoRealParaGuardado());
      crearPopupFlotante("¡Partida guardada en archivo!", width / 2, height * 0.22f, color(255, 220, 100));
    } else {
      if (opcion == 2) {
        mostrarOpciones = true;
      } else {
        if (opcion == 3) {
          boolean estabaEnHc = hcActiva;
          guardarPartidaEnArchivo(obtenerEstadoRealParaGuardado());
          enPausa = false;
          mostrarOpciones = false;
          nv2AudioEstabaSonandoAntesDePausa = false;
          nv3VideoEstabaSonandoAntesDePausa = false;
          skipAutoSaveEnMenu = true;
          detenerYReiniciarTodosLosAudiosNv2();
          if (hcActiva) {
            reiniciarHistoriaDespuesCocina();
          }
          if (t3Activa) {
            t3Reiniciar();
          }
          if (estabaEnHc && estadoActual == NIVEL2) {
            estadoActual = HISTORIA_POST_COCINA;
          }
          estadoDestino = MENU;
          enTransicion = true;
        }
      }
    }
  }
}

void dibujarMenuPausaGlobal() {
  pushStyle();
  rectMode(CORNER);
  imageMode(CORNER);
  noTint();
  if (fuenteComic != null) {
    textFont(fuenteComic);
  }

  fill(0, 150);
  noStroke();
  rect(0, 0, width, height);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40 * escalaX);
  text("PAUSA", width / 2, height * 0.3f);

  float pausaBtnAncho = (REF_W * 0.18f) * escalaX;
  float pausaBtnAlto = (REF_H * 0.08f) * escalaY;
  float pausaEspacio = (REF_W * 0.03f) * escalaX;
  float pausaAnchoTotal = (pausaBtnAncho * totalBotonesPausa) + (pausaEspacio * (totalBotonesPausa - 1));
  float pausaInicioX = (width - pausaAnchoTotal) / 2;
  float pausaY = height * 0.5f;

  for (int k = 0; k < totalBotonesPausa; k++) {
    btnPausaW[k] = pausaBtnAncho;
    btnPausaH[k] = pausaBtnAlto;
    btnPausaX[k] = pausaInicioX + (k * (pausaBtnAncho + pausaEspacio));
    btnPausaY[k] = pausaY;
  }

  if (!mostrarOpciones) {
    int hoverActual = -1;
    for (int k = 0; k < totalBotonesPausa; k++) {
      if (mouseX > btnPausaX[k] && mouseX < btnPausaX[k] + btnPausaW[k] && mouseY > btnPausaY[k] && mouseY < btnPausaY[k] + btnPausaH[k]) {
        hoverActual = k;
      }
    }
    if (hoverActual != opcionPausaHover && hoverActual != -1) {
      opcionPausaSeleccionada = hoverActual;
      if (sonidoHover != null) {
        sonidoHover.amp(0.15f * volMaster);
        sonidoHover.play();
      }
    }
    opcionPausaHover = hoverActual;
  }

  for (int k = 0; k < totalBotonesPausa; k++) {
    boolean seleccionado = (opcionPausaSeleccionada == k);

    if (seleccionado) {
      fill(255, 220, 100);
    } else {
      fill(180, 120, 60);
    }
    stroke(100, 50, 20);
    strokeWeight(4);
    rect(btnPausaX[k], btnPausaY[k], btnPausaW[k], btnPausaH[k], 8);

    noStroke();
    if (seleccionado) {
      fill(255, 240, 150, 100);
    } else {
      fill(200, 150, 90, 100);
    }
    rect(btnPausaX[k] + 4, btnPausaY[k] + 4, btnPausaW[k] - 8, btnPausaH[k] / 2 - 4, 4);

    textSize(24 * escalaX);
    if (!seleccionado) {
      fill(100, 50, 20);
      text(botonesPausa[k], btnPausaX[k] + (btnPausaW[k] / 2) + 2, btnPausaY[k] + (btnPausaH[k] / 2) + 2);
      fill(255);
    } else {
      fill(50, 20, 0);
    }
    text(botonesPausa[k], btnPausaX[k] + (btnPausaW[k] / 2), btnPausaY[k] + (btnPausaH[k] / 2));
  }

  if (!mostrarOpciones) {
    dibujarIndicativoFlotante(indicativoGuardar, btnPausaX[1] + btnPausaW[1] * 0.5f, btnPausaY[1] - 34 * escalaY, 90 * escalaX, 2.5f);
  }

  fill(180);
  textSize(16 * escalaX);
  text("LEFT/RIGHT para navegar | ENTER para confirmar | P o ESC para reanudar", width / 2, pausaY + pausaBtnAlto + (20 * escalaY));
  popStyle();
}

void dibujarPanelOpcionesGlobal() {
  pushStyle();
  rectMode(CORNER);
  if (fuenteComic != null) {
    textFont(fuenteComic);
  }
  fill(0, 180);
  noStroke();
  rect(0, 0, width, height);

  int totalCuadros = 10;
  float cuadroTam = (REF_W * 0.045f) * escalaX;
  float cuadroEspacio = (REF_W * 0.012f) * escalaX;
  float cuadrosAnchoTotal = (cuadroTam * totalCuadros) + (cuadroEspacio * (totalCuadros - 1));
  float cuadrosInicioX = (width - cuadrosAnchoTotal) / 2;
  float cuadrosY = (height - cuadroTam) / 2;

  for (int i = 0; i < totalCuadros; i++) {
    if (i < nivelVolumen) {
      fill(100, 220, 120);
    } else {
      fill(60, 60, 60);
    }
    stroke(255);
    strokeWeight(2);
    rect(cuadrosInicioX + i * (cuadroTam + cuadroEspacio), cuadrosY, cuadroTam, cuadroTam, 4);
  }

  noStroke();
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(28 * escalaX);
  text("VOLUMEN: " + (nivelVolumen * 10) + "%", width / 2, cuadrosY - (cuadroTam * 0.9f));
  textSize(16 * escalaX);
  fill(200);
  text("Flechas IZQUIERDA/DERECHA para ajustar | 'M' o ESC para cerrar", width / 2, cuadrosY + cuadroTam + (cuadroTam * 0.7f));
  popStyle();
}

void procesarClicPausaGlobal() {
  if (!mostrarOpciones) {
    boolean clicHecho = false;
    for (int k = 0; k < totalBotonesPausa && !clicHecho; k++) {
      if (mouseX > btnPausaX[k] && mouseX < btnPausaX[k] + btnPausaW[k] && mouseY > btnPausaY[k] && mouseY < btnPausaY[k] + btnPausaH[k]) {
        opcionPausaSeleccionada = k;
        if (sonidoClic != null) {
          sonidoClic.amp(0.5f * volMaster);
          sonidoClic.play();
        }
        ejecutarOpcionPausaGlobal(k);
        clicHecho = true;
      }
    }
  }
}

void procesarTeclaPausaGlobal(char k, int kCode, boolean fueEsc) {
  boolean esAtras = (k == 'm' || k == 'M' || fueEsc);
  if (mostrarOpciones) {
    if ((k == 'd' || k == 'D' || kCode == RIGHT) && nivelVolumen < 10) {
      nivelVolumen++;
      volMaster = nivelVolumen / 10.0f;
      if (musicaFondo != null) {
        musicaFondo.amp(volMaster);
      }
      if (reproductorMp3 != null) {
        reproductorMp3.amp(volMaster);
      }
      if (nv2Audio != null) {
        nv2Audio.amp(volMaster);
      }
      if (nv3_musicaSala != null) {
        nv3_musicaSala.amp(0.45f * volMaster);
      }
      if (nv3_musicaJuego != null) {
        nv3_musicaJuego.amp(0.50f * volMaster);
      }
      if (nv3_musicaVictoria != null) {
        nv3_musicaVictoria.amp(0.50f * volMaster);
      }
      if (sonidoClic != null) {
        sonidoClic.amp(0.5f * volMaster);
        sonidoClic.play();
      }
    }
    if ((k == 'a' || k == 'A' || kCode == LEFT) && nivelVolumen > 1) {
      nivelVolumen--;
      volMaster = nivelVolumen / 10.0f;
      if (musicaFondo != null) {
        musicaFondo.amp(volMaster);
      }
      if (reproductorMp3 != null) {
        reproductorMp3.amp(volMaster);
      }
      if (nv2Audio != null) {
        nv2Audio.amp(volMaster);
      }
      if (nv3_musicaSala != null) {
        nv3_musicaSala.amp(0.45f * volMaster);
      }
      if (nv3_musicaJuego != null) {
        nv3_musicaJuego.amp(0.50f * volMaster);
      }
      if (nv3_musicaVictoria != null) {
        nv3_musicaVictoria.amp(0.50f * volMaster);
      }
      if (sonidoClic != null) {
        sonidoClic.amp(0.5f * volMaster);
        sonidoClic.play();
      }
    }
    if (esAtras || kCode == ENTER || k == RETURN || k == ' ') {
      mostrarOpciones = false;
    }
  } else {
    if (k == 'p' || k == 'P' || esAtras) {
      desactivarPausaGlobal();
    } else {
      if (kCode == LEFT || k == 'a' || k == 'A') {
        if (opcionPausaSeleccionada > 0) {
          opcionPausaSeleccionada--;
        }
        if (sonidoHover != null) {
          sonidoHover.amp(0.15f * volMaster);
          sonidoHover.play();
        }
      }
      if (kCode == RIGHT || k == 'd' || k == 'D') {
        if (opcionPausaSeleccionada < totalBotonesPausa - 1) {
          opcionPausaSeleccionada++;
        }
        if (sonidoHover != null) {
          sonidoHover.amp(0.15f * volMaster);
          sonidoHover.play();
        }
      }
      if (kCode == ENTER || k == RETURN || k == ' ') {
        if (sonidoClic != null) {
          sonidoClic.amp(0.5f * volMaster);
          sonidoClic.play();
        }
        ejecutarOpcionPausaGlobal(opcionPausaSeleccionada);
      }
    }
  }
}
