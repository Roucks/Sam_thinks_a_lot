// =========================================================================
// PESTAÑA 3: MINIJUEGO DE COCINA AL RITMO (NIVEL 2 HIPER-DOPAMÍNICO Y CAÓTICO)
// (Arquitectura modular con arreglos paralelos de tamaño fijo - AyP 2)
// =========================================================================

int[] nv2NotaUltimoTickMs = new int[MAX_NOTAS_NV2];
int nv2IndicePrimeraNotaActiva = 0;
float nv2VelocidadPxPorMs = 0.45f;
boolean recompensaNivel2Otorgada = false;

// Vértices unitarios precalculados para octágonos (evita 16 llamadas a sin/cos por nota/receptor)
final float[] NV2_OCT_COS = { 0.9238795f, 0.3826834f, -0.3826834f, -0.9238795f, -0.9238795f, -0.3826834f, 0.3826834f, 0.9238795f };
final float[] NV2_OCT_SIN = { 0.3826834f, 0.9238795f, 0.9238795f, 0.3826834f, -0.3826834f, -0.9238795f, -0.9238795f, -0.3826834f };

// --- Sistema de Vida / Calidad del Plato (Poder Perder) ---
float nv2VidaPlato = 100.0f;
float nv2VidaPlatoLerp = 100.0f;
int nv2FlashDanoTimer = 0;

// --- Sistema de Combo Loco y Dinámico ---
float nv2ComboPosX = 768.0f;
float nv2ComboPosY = 230.0f;
float nv2ComboTargetX = 768.0f;
float nv2ComboTargetY = 230.0f;
float nv2ComboAngulo = 0.0f;
float nv2ComboTargetAngulo = 0.0f;
float nv2ComboEscala = 1.0f;

// --- Textos Flotantes de Locura / Hype (Arreglos paralelos fijos - AyP 2) ---
final int MAX_HYPE_NV2 = 4;
boolean[] nv2HypeActivo = new boolean[MAX_HYPE_NV2];
float[] nv2HypeX = new float[MAX_HYPE_NV2];
float[] nv2HypeY = new float[MAX_HYPE_NV2];
float[] nv2HypeVX = new float[MAX_HYPE_NV2];
float[] nv2HypeVY = new float[MAX_HYPE_NV2];
float[] nv2HypeAng = new float[MAX_HYPE_NV2];
float[] nv2HypeEscala = new float[MAX_HYPE_NV2];
float[] nv2HypeAlfa = new float[MAX_HYPE_NV2];
String[] nv2HypeTexto = new String[MAX_HYPE_NV2];
int[] nv2HypeColor = new int[MAX_HYPE_NV2];

// --- Evento Clímax Modo Extremo: Pausa de Alerta y Furia de Mamá (Contra Reloj 90s) ---
boolean nv2ExtremoFaseAlerta = false;
boolean nv2ExtremoFaseMama = false;
int nv2ExtremoAlertaInicioMs = 0;
int nv2ExtremoMamaInicioMs = 0;
int nv2UltimoSegAlerta = -1;
float nv2ProgresoMamaLerp = 0.0f;
final int DURACION_ALERTA_MAMA_MS = 6800; // ~6.8 segundos de pausa sin notas con texto de advertencia
final int DURACION_CLIMAX_MAMA_MS = 102250; // Duración completa del clímax hasta el final real de Aoi.mp3 (282.25s total - 180s = 102.25s)

String[] nv2FrasesLocura = {
  "¡LOCURA CULINARIA!",
  "¡FUEGO MÁXIMO!",
  "¡HIPER COMBO!",
  "¡SABOR EXPLOSIVO!",
  "¡CHEF SUPREMO!",
  "¡RITMO BRUTAL!",
  "¡DOPAMINA AL 1000%!",
  "¡NO PARES AHORA!",
  "¡¡VIENE MAMÁ!!",
  "¡¡LIMPIA LA MESA!!",
  "¡¡VELOCIDAD x2!!",
  "¡¡SALVA LA COCINA!!"
};
final int TOTAL_FRASES_LOCURA = 12;

// --- Ondas de Choque y Arcos de "Arranque" entre Notas Seguidas / Dobles ---
final int MAX_ONDAS_NV2 = 16;
boolean[] nv2OndaActiva = new boolean[MAX_ONDAS_NV2];
float[] nv2OndaX = new float[MAX_ONDAS_NV2];
float[] nv2OndaY = new float[MAX_ONDAS_NV2];
float[] nv2OndaRadio = new float[MAX_ONDAS_NV2];
float[] nv2OndaAlfa = new float[MAX_ONDAS_NV2];
int[] nv2OndaColor = new int[MAX_ONDAS_NV2];

final int MAX_RAYOS_ARRANQUE = 12;
boolean[] nv2RayoActivo = new boolean[MAX_RAYOS_ARRANQUE];
float[] nv2RayoX1 = new float[MAX_RAYOS_ARRANQUE];
float[] nv2RayoY1 = new float[MAX_RAYOS_ARRANQUE];
float[] nv2RayoX2 = new float[MAX_RAYOS_ARRANQUE];
float[] nv2RayoY2 = new float[MAX_RAYOS_ARRANQUE];
float[] nv2RayoAlfa = new float[MAX_RAYOS_ARRANQUE];
int[] nv2RayoColor = new int[MAX_RAYOS_ARRANQUE];

int nv2UltimoHitMs = -9999;
float nv2UltimoHitX = 0.0f;
float nv2UltimoHitY = 0.0f;
int nv2UltimoHitColor = color(255);

// --- Vibración por carril en Notas Sostenidas ---
float[] nv2VibracionCarril = new float[MAX_CARRILES_NV2];

// --- Sistema Global de "Juice" / "Game Feel" Dopamínico (Todos los Niveles) ---
// A. Keybeams, Latido de Línea de Carril y Highway Reactivo
float[] nv2KeybeamAlfa = new float[MAX_CARRILES_NV2];
boolean[] nv2KeybeamEsHit = new boolean[MAX_CARRILES_NV2];
float[] nv2LatidoLineaCarril = new float[MAX_CARRILES_NV2];
float nv2ScrollHighwayOffset = 0.0f;

// B. Squash & Stretch en Receptores y Slashes de Luz en Cruz (4-5 frames)
float[] nv2ReceptorEscala = new float[MAX_CARRILES_NV2];
final int MAX_SLASH_NV2 = 18;
boolean[] nv2SlashActivo = new boolean[MAX_SLASH_NV2];
float[] nv2SlashX = new float[MAX_SLASH_NV2];
float[] nv2SlashY = new float[MAX_SLASH_NV2];
float[] nv2SlashAngulo = new float[MAX_SLASH_NV2];
int[] nv2SlashTimer = new int[MAX_SLASH_NV2];
int[] nv2SlashColor = new int[MAX_SLASH_NV2];

// C. Bass Bump / Zoom Pulse de Cámara y Partículas de Fuego / Energía Ascendentes
float nv2ZoomCamara = 1.0f;
final int MAX_PART_FUEGO_NV2 = 36;
boolean[] nv2FuegoActivo = new boolean[MAX_PART_FUEGO_NV2];
float[] nv2FuegoX = new float[MAX_PART_FUEGO_NV2];
float[] nv2FuegoY = new float[MAX_PART_FUEGO_NV2];
float[] nv2FuegoVX = new float[MAX_PART_FUEGO_NV2];
float[] nv2FuegoVY = new float[MAX_PART_FUEGO_NV2];
float[] nv2FuegoTam = new float[MAX_PART_FUEGO_NV2];
float[] nv2FuegoAlfa = new float[MAX_PART_FUEGO_NV2];
int[] nv2FuegoColor = new int[MAX_PART_FUEGO_NV2];

// --- Cachés Gráficos Pre-renderizados (PGraphics) para 60 FPS sólidos en JAVA2D ---
PGraphics pgFondoEstaticoNv2 = null;
PGraphics[] pgNotaCacheNv2 = new PGraphics[MAX_CARRILES_NV2];
PGraphics[] pgReceptorActivoCacheNv2 = new PGraphics[MAX_CARRILES_NV2];
PGraphics[] pgReceptorPopCacheNv2 = new PGraphics[MAX_CARRILES_NV2];
int nv2CacheAncho = 0;
int nv2CacheAlto = 0;
int nv2CacheCarriles = -1;
int nv2CacheDificultad = -1;
boolean nv2CacheFaseMama = false;

// --- Catálogo de 4 Canciones (1 por Nivel de Dificultad) (Arreglos paralelos - AyP 2) ---
// 0: Intermedio -> Appeal (100 BPM)
// 1: Difícil    -> Hello Juliet (132 BPM)
// 2: Extremo    -> Aoi, Koi, Daidaiiro No Hi (149 BPM, sincronizada 8 secciones + Fase Mamá)
// 3: Injugable  -> Rush E - Sheet Music Boss (90 -> 180+ BPM Black MIDI, sincronizada 8 secciones)
String[] nv2ArchivosPorDif = {
  "appeal_100bpm.mp3",
  "Hello-juliet.mp3",
  "Aoi.mp3",
  "RushE.mp3"
};
String[] nv2TitulosPorDif = {
  "Phantastic Beats - Appeal (100 BPM)",
  "Hello Juliet (132 BPM)",
  "Aoi, Koi, Daidaiiro No Hi (149 BPM)",
  "RUSH E - Sheet Music Boss (90->180+ BPM)"
};
int[] nv2BpmPorDif = { 100, 132, 149, 165 };
int[] nv2DuracionMsPorDif = { 91090, 208091, 180000, 177353 };
SoundFile[] nv2AudiosPorDif = new SoundFile[TOTAL_DIFICULTADES_NV2];

int nv2SeccionCancionActual = -1;
String[] nv2NombresSeccionAoi = {
  "1/8 INTRO INSTRUMENTAL (Platillos -> Distorsión)",
  "2/8 VERSO 1 (Mapeo Vocal Natsuko)",
  "3/8 ESTRIBILLO / DROP 1 (Stream de Corcheas y Saltos)",
  "4/8 TRANSICIÓN INSTRUMENTAL (Bajo + Notas Sostenidas)",
  "5/8 VERSO 2 & PRE-CORO (Sincronización Mixta)",
  "6/8 CORO PRINCIPAL - ¡KIAI / CLÍMAX! (Dobles en Caja + Cruzados)",
  "7/8 PUENTE INSTRUMENTAL / BRIDGE (Atmosférico y Sliders Lentos)",
  "8/8 OUTRO (Subida Progresiva -> Cascada Final Abrupta)"
};
String[] nv2NombresSeccionRushE = {
  "INTRO DEL CANAL & EL 'E' INICIAL (Acordes [0,2,4,6,8] -> Silencio -> Mini-Jack 'J')",
  "1/8 TEMA A - POLCA LENTA (90 a 115 BPM: Bajo Oom-Pah -> Staccato 'J' 0:29.1)",
  "2/8 TEMA A - VARIACIÓN RÁPIDA (135 BPM: Ráfagas H-J + Escalas [8->4])",
  "3/8 PUENTE MELÓDICO - SECCIÓN B (Saltos Dobles Simétricos + Puente 'ESP')",
  "4/8 RETORNO ACELERADO & VOCAL 'E' (160 BPM: Corte 1:33.8 -> 'E' 1:34.2)",
  "5/8 REINICIO & ACELERACIÓN CRÍTICA (90 -> 175 BPM: Acordes Triples Pesados)",
  "6/8 CLÍMAX BLACK MIDI (180 BPM: Escaleras Cromáticas 0<->8 + Centro [4])",
  "7/8 OUTRO - CAOS ABSOLUTO (Kiai: Streams + Cascada 2:14 -> Acorde 9 Teclas 2:16)",
  "8/8 OUTRO DEL VIDEO (Cola -> Loop Final 2:26.2 -> Último 'E' en 'ESP' 2:34.8)"
};

String nv2ArchivoFaseMama = "Aoi.mp3";
String nv2TituloFaseMama = "Aoi, Koi, Daidaiiro No Hi - ¡Clímax Furia de Mamá!";
int nv2BpmFaseMama = 149;
SoundFile nv2AudioFaseMama = null;
int nv2DuracionTotalActivaMs = 91000;

// --- Arreglos fijos para el Analizador de Forma de Onda Musical (40 ms por ventana) ---
final int MAX_VENTANAS_ANALISIS_NV2 = 8000;
float[] nv2EnergiaVentana = new float[MAX_VENTANAS_ANALISIS_NV2];
float[] nv2GraveVentana = new float[MAX_VENTANAS_ANALISIS_NV2];
float[] nv2AgudoVentana = new float[MAX_VENTANAS_ANALISIS_NV2];

// --- Bot Auto-Play de Modo Debug (Juega solo los 4 niveles musicales) ---
boolean nv2AutoPlayBot = false;
int nv2TimerAutoAvanceBot = 0;

// --- Audio "opening_chest.ogg" para los 4 niveles de dificultad del Nivel 2 (con variación de pitch) ---
SoundFile nv2SonidoOpeningChest = null;
int nv2UltimoOpeningChestMs = -999;
float nv2UltimoPitchChest = 1.0f;
int nv2ContadorTapsPitch = 0;

void reproducirOpeningChestNv2(float ampFactor) {
  int ahoraMs = millis();
  // Cooldown de 110 ms para evitar solapamiento de decodificación OGG en ráfagas rápidas (149-180 BPM)
  if (ahoraMs - nv2UltimoOpeningChestMs >= 110) {
    nv2UltimoOpeningChestMs = ahoraMs;
    try {
      if (nv2SonidoOpeningChest == null) {
        File fChest = dataFile("opening_chest.ogg");
        if (fChest.exists()) {
          nv2SonidoOpeningChest = new SoundFile(this, "opening_chest.ogg");
        }
      }
      if (nv2SonidoOpeningChest != null) {
        float ampFinal = constrain(ampFactor * max(0.5f, volMaster), 0.0f, 1.0f);
        nv2SonidoOpeningChest.amp(ampFinal);
        nv2SonidoOpeningChest.play();
      } else { if (sonidoClic != null) {
        float ampFinal = constrain(ampFactor * max(0.5f, volMaster), 0.0f, 1.0f);
        sonidoClic.amp(ampFinal);
        sonidoClic.play();
      } }
    } catch (Exception e) {
    }
  }
}

void detenerYReiniciarTodosLosAudiosNv2() {
  try {
    if (nv2Audio != null) {
      nv2Audio.stop();
      nv2Audio.cue(0.0f);
    }
    for (int i = 0; i < TOTAL_DIFICULTADES_NV2; i++) {
      if (nv2AudiosPorDif[i] != null) {
        nv2AudiosPorDif[i].stop();
        nv2AudiosPorDif[i].cue(0.0f);
      }
    }
  } catch (Exception e) {
  }
}

void cargarAudioNivel2PorDificultad(int dif, boolean esFaseMama) {
  int d = constrain(dif, 0, TOTAL_DIFICULTADES_NV2 - 1);
  if (!esFaseMama) {
    detenerYReiniciarTodosLosAudiosNv2();
  }
  if (esFaseMama) {
    nv2ArchivoAudio = nv2ArchivosPorDif[NV2_DIF_EXTREMO];
    nv2CancionTitulo = nv2TituloFaseMama;
    nv2DuracionTotalActivaMs = DURACION_CLIMAX_MAMA_MS;
    try {
      if (nv2AudiosPorDif[NV2_DIF_EXTREMO] == null) {
        File fExt = dataFile(nv2ArchivosPorDif[NV2_DIF_EXTREMO]);
        if (fExt.exists()) {
          nv2AudiosPorDif[NV2_DIF_EXTREMO] = new SoundFile(this, nv2ArchivosPorDif[NV2_DIF_EXTREMO]);
        }
      }
      nv2Audio = nv2AudiosPorDif[NV2_DIF_EXTREMO];
    } catch (Exception e) {
      nv2Audio = null;
    }
  } else {
    nv2ArchivoAudio = nv2ArchivosPorDif[d];
    nv2CancionTitulo = nv2TitulosPorDif[d];
    nv2DuracionTotalActivaMs = nv2DuracionMsPorDif[d];
    try {
      if (nv2AudiosPorDif[d] == null) {
        File fAudio = dataFile(nv2ArchivosPorDif[d]);
        if (fAudio.exists()) {
          try {
            nv2AudiosPorDif[d] = new SoundFile(this, nv2ArchivosPorDif[d]);
          } catch (Exception exLoad) {
            nv2AudiosPorDif[d] = null;
          }
        }
        if (nv2AudiosPorDif[d] == null && d == NV2_DIF_INJUGABLE) {
          File fRush = dataFile("RUSH E [Qskm9MTz2V4].mp3");
          if (fRush.exists()) {
            try {
              nv2AudiosPorDif[d] = new SoundFile(this, "RUSH E [Qskm9MTz2V4].mp3");
            } catch (Exception exRush) {
              nv2AudiosPorDif[d] = null;
            }
          }
        }
      }
      nv2Audio = nv2AudiosPorDif[d];
      if (nv2Audio != null) {
        nv2Audio.stop();
        nv2Audio.cue(0.0f);
        try {
          float durSec = nv2Audio.duration();
          if (durSec > 1.0f) {
            int durRealMs = round(durSec * 1000.0f);
            if (d == NV2_DIF_EXTREMO) {
              nv2DuracionTotalActivaMs = 180000;
              nv2DuracionMsPorDif[d] = 180000;
            } else {
              nv2DuracionTotalActivaMs = durRealMs;
              nv2DuracionMsPorDif[d] = durRealMs;
            }
          }
        } catch (Exception exDur) {}
      }
    } catch (Exception e) {
      nv2Audio = null;
    }
  }
}

int obtenerTiempoAudioRealMsNv2() {
  int audioTimeMs = (millis() - nv2TiempoInicioMs) + nv2OffsetMs;
  if (!nv2ExtremoFaseAlerta && nv2Audio != null) {
    try {
      if (nv2Audio.isPlaying()) {
        float posSeg = nv2Audio.position();
        if (posSeg > 0.02f && posSeg < 340.0f) {
          int posAudioRealMs = round(posSeg * 1000.0f);
          if (nv2ExtremoFaseMama && nv2Dificultad == NV2_DIF_EXTREMO) {
            // En Fase Mamá, posSeg avanza desde 180.0s en adelante.
            // Sincronizamos para que audioTimeMs coincida con nv2ExtremoMamaInicioMs + (posSeg - 180.0s)
            int tiempoClimaxReal = max(0, posAudioRealMs - 180000);
            int objetivoAudioMs = nv2ExtremoMamaInicioMs + tiempoClimaxReal;
            int relojActual = (millis() - nv2TiempoInicioMs) + nv2OffsetMs;
            if (abs(objetivoAudioMs - relojActual) > 150) {
              nv2TiempoInicioMs = millis() - (objetivoAudioMs - nv2OffsetMs);
            }
          } else {
            int relojActualMs = millis() - nv2TiempoInicioMs;
            if (abs(posAudioRealMs - relojActualMs) > 180) {
              nv2TiempoInicioMs = millis() - posAudioRealMs;
            }
          }
        }
      }
    } catch (Exception e) {
    }
    audioTimeMs = (millis() - nv2TiempoInicioMs) + nv2OffsetMs;
  }
  return audioTimeMs;
}

void configurarGeometriaCarrilesNv2(int numCarriles) {
  nv2NumCarrilesActivos = constrain(numCarriles, 2, MAX_CARRILES_NV2);

  // Actualizar etiquetas de tecla de cada carril según la dificultad activa
  if (nv2Dificultad == NV2_DIF_INTERMEDIO) {
    nv2EtiquetasCarril[0] = "A / IZQ";
    nv2EtiquetasCarril[1] = "D / DER";
  } else { if (nv2Dificultad == NV2_DIF_DIFICIL) {
    nv2EtiquetasCarril[0] = "D";
    nv2EtiquetasCarril[1] = "F";
    nv2EtiquetasCarril[2] = "J";
    nv2EtiquetasCarril[3] = "K";
  } else { if (nv2Dificultad == NV2_DIF_EXTREMO) {
    if (nv2ExtremoFaseMama) {
      // 6 carriles repentinos: S, D, F, J, K, L
      nv2EtiquetasCarril[0] = "S";
      nv2EtiquetasCarril[1] = "D";
      nv2EtiquetasCarril[2] = "F";
      nv2EtiquetasCarril[3] = "J";
      nv2EtiquetasCarril[4] = "K";
      nv2EtiquetasCarril[5] = "L";
    } else {
      // 5 carriles estándar: D, F, J, K, L
      nv2EtiquetasCarril[0] = "D";
      nv2EtiquetasCarril[1] = "F";
      nv2EtiquetasCarril[2] = "J";
      nv2EtiquetasCarril[3] = "K";
      nv2EtiquetasCarril[4] = "L";
    }
  } else { if (nv2Dificultad == NV2_DIF_INJUGABLE) {
    // Orden lineal: A S D F ESPACIO H J K L
    nv2EtiquetasCarril[0] = "A";
    nv2EtiquetasCarril[1] = "S";
    nv2EtiquetasCarril[2] = "D";
    nv2EtiquetasCarril[3] = "F";
    nv2EtiquetasCarril[4] = "ESP";
    nv2EtiquetasCarril[5] = "H";
    nv2EtiquetasCarril[6] = "J";
    nv2EtiquetasCarril[7] = "K";
    nv2EtiquetasCarril[8] = "L";
  } } } }

  if (nv2NumCarrilesActivos == 2) {
    nv2CarrilBaseX[0] = 580.0f;
    nv2CarrilBaseX[1] = 956.0f;
  } else {
    float sep = 195.0f;
    if (nv2NumCarrilesActivos == 4) sep = 185.0f;
    else { if (nv2NumCarrilesActivos == 5) sep = 162.0f;
    else { if (nv2NumCarrilesActivos == 6) sep = 142.0f;
    else { if (nv2NumCarrilesActivos >= 7) sep = 118.0f; } } }

    float anchoTotal = (nv2NumCarrilesActivos - 1) * sep;
    float inicioX = (REF_W - anchoTotal) / 2.0f;
    for (int c = 0; c < nv2NumCarrilesActivos; c++) {
      nv2CarrilBaseX[c] = inicioX + c * sep;
    }
  }

  regenerarCachesGraficosNv2();
}

void regenerarCachesGraficosNv2() {
  if (width > 0 && height > 0) {
    escalaX = width / REF_W;
    escalaY = height / REF_H;

  float zonaImpactoY = nv2ZonaImpactoBaseY * escalaY;
  float radioNota = (nv2NumCarrilesActivos >= 9 ? 25.0f : (nv2NumCarrilesActivos >= 5 ? 30.0f : 36.0f)) * escalaX;
  float anchoCarril = (nv2NumCarrilesActivos >= 9 ? 102.0f : (nv2NumCarrilesActivos >= 5 ? 112.0f : 138.0f)) * escalaX;
  int tamEtiqueta = max(10, round((nv2NumCarrilesActivos >= 9 ? 13 : (nv2NumCarrilesActivos >= 5 ? 14 : 16)) * escalaX));

  // 1. Pre-renderizar sprites de Notas y Receptores Activos por cada carril (Límites ajustados a 2.45x para reducir el blending en un 75%)
  int tamSpriteNota = max(24, ceil(radioNota * 2.45f));
  if (tamSpriteNota % 2 != 0) tamSpriteNota++;
  float rRecBase = radioNota * 1.075f;
  float rRecAct = rRecBase * 1.14f;
  int tamSpriteRec = max(28, ceil(rRecAct * 2.50f));
  if (tamSpriteRec % 2 != 0) tamSpriteRec++;

  for (int c = 0; c < nv2NumCarrilesActivos; c++) {
    int col = nv2ColoresCarril[c];

    // A) Caché de Nota de este carril
    PGraphics pgN = createGraphics(tamSpriteNota, tamSpriteNota);
    pgN.beginDraw();
    pgN.clear();
    pgN.smooth();
    float mN = tamSpriteNota * 0.5f;
    if (imgNotaNv2 != null && imgNotaNv2.width > 0) {
      pgN.imageMode(CENTER);
      pgN.tint(col);
      pgN.image(imgNotaNv2, mN, mN, radioNota * 2.1f, radioNota * 2.1f);
      pgN.noTint();
    } else {
      pgN.noStroke();
      pgN.fill(red(col), green(col), blue(col), 85);
      pgN.ellipse(mN, mN, radioNota * 2.35f, radioNota * 2.35f);

      pgN.fill(col);
      pgN.stroke(255, 245);
      pgN.strokeWeight(2.8f * escalaX);
      pgN.beginShape();
      for (int i = 0; i < 8; i++) {
        pgN.vertex(mN + NV2_OCT_COS[i] * radioNota, mN + NV2_OCT_SIN[i] * radioNota);
      }
      pgN.endShape(CLOSE);

      pgN.fill(255, 245, 220, 195);
      pgN.noStroke();
      pgN.beginShape();
      pgN.vertex(mN, mN - radioNota * 0.52f);
      pgN.vertex(mN + radioNota * 0.52f, mN);
      pgN.vertex(mN, mN + radioNota * 0.52f);
      pgN.vertex(mN - radioNota * 0.52f, mN);
      pgN.endShape(CLOSE);

      pgN.fill(255, 210);
      pgN.ellipse(mN - radioNota * 0.28f, mN - radioNota * 0.28f, radioNota * 0.35f, radioNota * 0.22f);
    }
    pgN.endDraw();
    pgNotaCacheNv2[c] = pgN;

    // B) Caché de Receptor Presionado / Activo de este carril
    PGraphics pgR = createGraphics(tamSpriteRec, tamSpriteRec);
    pgR.beginDraw();
    pgR.clear();
    pgR.smooth();
    if (fuenteComic != null) pgR.textFont(fuenteComic);
    float mR = tamSpriteRec * 0.5f;
    if (imgReceptorNv2 != null && imgReceptorNv2.width > 0) {
      pgR.imageMode(CENTER);
      pgR.image(imgReceptorNv2, mR, mR, rRecAct * 2.1f, rRecAct * 2.1f);
    } else {
      pgR.noStroke();
      pgR.fill(red(col), green(col), blue(col), 135);
      pgR.ellipse(mR, mR, rRecAct * 2.35f, rRecAct * 2.35f);

      pgR.fill(col);
      pgR.stroke(255, 255, 200);
      pgR.strokeWeight(4.0f * escalaX);
      pgR.beginShape();
      for (int i = 0; i < 8; i++) {
        pgR.vertex(mR + NV2_OCT_COS[i] * rRecAct, mR + NV2_OCT_SIN[i] * rRecAct);
      }
      pgR.endShape(CLOSE);

      pgR.noFill();
      pgR.stroke(255, 225);
      pgR.strokeWeight(1.8f * escalaX);
      pgR.ellipse(mR, mR, rRecAct * 1.42f, rRecAct * 1.42f);
    }
    pgR.fill(255);
    pgR.noStroke();
    pgR.textAlign(CENTER, CENTER);
    pgR.textSize(tamEtiqueta);
    pgR.text(nv2EtiquetasCarril[c], mR, mR);
    pgR.endDraw();
    pgReceptorActivoCacheNv2[c] = pgR;

    // C) Caché de Receptor en Pop Elástico 1.35x (Squash & Stretch pre-renderizado a 2.55x -> 0 costo CPU en vivo)
    float rRecPop = rRecBase * 1.35f;
    int tamSpritePop = max(36, ceil(rRecPop * 2.55f));
    if (tamSpritePop % 2 != 0) tamSpritePop++;
    PGraphics pgPop = createGraphics(tamSpritePop, tamSpritePop);
    pgPop.beginDraw();
    pgPop.clear();
    pgPop.smooth();
    if (fuenteComic != null) pgPop.textFont(fuenteComic);
    float mPop = tamSpritePop * 0.5f;
    if (imgReceptorNv2 != null && imgReceptorNv2.width > 0) {
      pgPop.imageMode(CENTER);
      pgPop.image(imgReceptorNv2, mPop, mPop, rRecPop * 2.15f, rRecPop * 1.98f);
    } else {
      pgPop.noStroke();
      pgPop.fill(red(col), green(col), blue(col), 170);
      pgPop.ellipse(mPop, mPop, rRecPop * 2.45f, rRecPop * 2.25f);

      pgPop.fill(lerpColor(col, color(255), 0.35f));
      pgPop.stroke(255, 255, 235);
      pgPop.strokeWeight(4.8f * escalaX);
      pgPop.beginShape();
      for (int i = 0; i < 8; i++) {
        // Efecto Squash & Stretch ligeramente ensanchado horizontalmente (1.06x en X, 0.95x en Y)
        pgPop.vertex(mPop + NV2_OCT_COS[i] * rRecPop * 1.06f, mPop + NV2_OCT_SIN[i] * rRecPop * 0.95f);
      }
      pgPop.endShape(CLOSE);

      pgPop.noFill();
      pgPop.stroke(255, 245);
      pgPop.strokeWeight(2.2f * escalaX);
      pgPop.ellipse(mPop, mPop, rRecPop * 1.50f, rRecPop * 1.38f);
    }
    pgPop.fill(255);
    pgPop.noStroke();
    pgPop.textAlign(CENTER, CENTER);
    pgPop.textSize(max(12, round(tamEtiqueta * 1.22f)));
    pgPop.text(nv2EtiquetasCarril[c], mPop, mPop);
    pgPop.endDraw();
    pgReceptorPopCacheNv2[c] = pgPop;
  }

  // 2. Pre-renderizar Escena Estática Completa (Fondo + Oscurecimiento + Pistas + Receptores Reposo + Marco HUD)
  if (pgFondoEstaticoNv2 == null || pgFondoEstaticoNv2.width != width || pgFondoEstaticoNv2.height != height) {
    pgFondoEstaticoNv2 = createGraphics(width, height);
  }
  pgFondoEstaticoNv2.beginDraw();
  pgFondoEstaticoNv2.smooth();
  if (fuenteComic != null) pgFondoEstaticoNv2.textFont(fuenteComic);

  PImage imgBase = imgFondoCocina;
  if (imgBase == null || imgBase.width <= 0) {
    if (imgEscenaDesayuno != null && imgEscenaDesayuno.width > 0) imgBase = imgEscenaDesayuno;
    else { if (escenasNovela[2] != null && escenasNovela[2].width > 0) imgBase = escenasNovela[2];
    else { if (fondoEscena != null && fondoEscena.width > 0) imgBase = fondoEscena;
    else { if (escenasNovela[0] != null && escenasNovela[0].width > 0) imgBase = escenasNovela[0]; } } }
  }
  if (imgBase != null && imgBase.width > 0) {
    pgFondoEstaticoNv2.imageMode(CORNER);
    if (imgBase.width == width && imgBase.height == height) {
      pgFondoEstaticoNv2.image(imgBase, 0, 0);
    } else {
      pgFondoEstaticoNv2.image(imgBase, 0, 0, width, height);
    }
  } else {
    pgFondoEstaticoNv2.background(18, 22, 34);
  }

  // Capa de oscurecimiento horneada una sola vez en el buffer estático
  pgFondoEstaticoNv2.noStroke();
  pgFondoEstaticoNv2.fill(8, 10, 20, 185);
  pgFondoEstaticoNv2.rectMode(CORNER);
  pgFondoEstaticoNv2.rect(0, 0, width, height);

  // Pistas de carriles y receptores en estado normal horneados una sola vez
  for (int c = 0; c < nv2NumCarrilesActivos; c++) {
    float cx = nv2CarrilBaseX[c] * escalaX;
    int colC = nv2ColoresCarril[c];

    pgFondoEstaticoNv2.rectMode(CENTER);
    pgFondoEstaticoNv2.fill(16, 20, 32, 218);
    pgFondoEstaticoNv2.stroke(red(colC), green(colC), blue(colC), 98);
    pgFondoEstaticoNv2.strokeWeight(2.0f * escalaX);
    pgFondoEstaticoNv2.rect(cx, height * 0.52f, anchoCarril, height * 0.78f, 14 * escalaX);

    // Línea guía central sutil del carril
    pgFondoEstaticoNv2.stroke(red(colC), green(colC), blue(colC), 32);
    pgFondoEstaticoNv2.strokeWeight(1.2f * escalaX);
    pgFondoEstaticoNv2.line(cx, 112 * escalaY, cx, zonaImpactoY - rRecBase);

    // Receptor en reposo
    if (imgReceptorNv2 != null && imgReceptorNv2.width > 0) {
      pgFondoEstaticoNv2.imageMode(CENTER);
      pgFondoEstaticoNv2.tint(colC);
      pgFondoEstaticoNv2.image(imgReceptorNv2, cx, zonaImpactoY, rRecBase * 2.1f, rRecBase * 2.1f);
      pgFondoEstaticoNv2.noTint();
      pgFondoEstaticoNv2.imageMode(CORNER);
    } else {
      pgFondoEstaticoNv2.noStroke();
      pgFondoEstaticoNv2.fill(red(colC), green(colC), blue(colC), 45);
      pgFondoEstaticoNv2.ellipse(cx, zonaImpactoY, rRecBase * 2.35f, rRecBase * 2.35f);

      pgFondoEstaticoNv2.fill(22, 26, 40, 242);
      pgFondoEstaticoNv2.stroke(colC);
      pgFondoEstaticoNv2.strokeWeight(3.0f * escalaX);
      pgFondoEstaticoNv2.beginShape();
      for (int i = 0; i < 8; i++) {
        pgFondoEstaticoNv2.vertex(cx + NV2_OCT_COS[i] * rRecBase, zonaImpactoY + NV2_OCT_SIN[i] * rRecBase);
      }
      pgFondoEstaticoNv2.endShape(CLOSE);

      pgFondoEstaticoNv2.noFill();
      pgFondoEstaticoNv2.stroke(255, 110);
      pgFondoEstaticoNv2.strokeWeight(1.8f * escalaX);
      pgFondoEstaticoNv2.ellipse(cx, zonaImpactoY, rRecBase * 1.42f, rRecBase * 1.42f);
    }

    pgFondoEstaticoNv2.fill(255);
    pgFondoEstaticoNv2.noStroke();
    pgFondoEstaticoNv2.textAlign(CENTER, CENTER);
    pgFondoEstaticoNv2.textSize(tamEtiqueta);
    pgFondoEstaticoNv2.text(nv2EtiquetasCarril[c], cx, zonaImpactoY);
  }

  // Panel superior del HUD y textos estáticos horneados en el buffer
  pgFondoEstaticoNv2.rectMode(CORNER);
  pgFondoEstaticoNv2.fill(12, 16, 28, 238);
  pgFondoEstaticoNv2.stroke(255, 200, 75, 195);
  pgFondoEstaticoNv2.strokeWeight(2.0f * escalaX);
  pgFondoEstaticoNv2.rect(20 * escalaX, 14 * escalaY, width - 40 * escalaX, 88 * escalaY, 14 * escalaX);

  pgFondoEstaticoNv2.textAlign(LEFT, TOP);
  pgFondoEstaticoNv2.textSize(max(12, round(20 * escalaX)));
  if (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama) {
    pgFondoEstaticoNv2.fill(255, 75, 75);
    pgFondoEstaticoNv2.text("COCINA AL RITMO - ¡¡FURIA DE MAMÁ CONTRA RELOJ!! (6 CARRILES)", 42 * escalaX, 22 * escalaY);
  } else {
    pgFondoEstaticoNv2.fill(255, 220, 80);
    pgFondoEstaticoNv2.text("COCINA AL RITMO - " + nv2NombresDificultad[nv2Dificultad] + " (" + nv2NumCarrilesActivos + " CARRILES)", 42 * escalaX, 22 * escalaY);
  }

  pgFondoEstaticoNv2.textSize(max(10, round(14 * escalaX)));
  if (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama) {
    pgFondoEstaticoNv2.fill(255, 205, 110);
    pgFondoEstaticoNv2.text("¡VELOCIDAD x2 ACTIVA!   |   Teclas: S, D, F, J, K, L   |   ¡Arregla la cocina!", 42 * escalaX, 48 * escalaY);
  } else {
    pgFondoEstaticoNv2.fill(195, 215, 245);
    pgFondoEstaticoNv2.text("Canción: " + nv2CancionTitulo + "   |   Mult: x" + nf(nv2MultiplicadorDif[nv2Dificultad], 1, 1), 42 * escalaX, 48 * escalaY);
    pgFondoEstaticoNv2.noStroke();
    pgFondoEstaticoNv2.fill(35, 45, 68);
    pgFondoEstaticoNv2.rect(42 * escalaX, 74 * escalaY, 360 * escalaX, 12 * escalaY);
  }

  // Marco vacío de la barra de Calidad del Plato
  float vidaX = width * 0.5f - 175 * escalaX;
  float vidaY = 24 * escalaY;
  float vidaW = 350 * escalaX;
  float vidaH = 22 * escalaY;
  pgFondoEstaticoNv2.stroke(255, 140);
  pgFondoEstaticoNv2.strokeWeight(1.8f * escalaX);
  pgFondoEstaticoNv2.fill(30, 20, 28);
  pgFondoEstaticoNv2.rect(vidaX, vidaY + 22 * escalaY, vidaW, vidaH);

  pgFondoEstaticoNv2.endDraw();

    nv2CacheAncho = width;
    nv2CacheAlto = height;
    nv2CacheCarriles = nv2NumCarrilesActivos;
    nv2CacheDificultad = nv2Dificultad;
    nv2CacheFaseMama = nv2ExtremoFaseMama;
  }
}

int obtenerCarrilPorTeclaNv2(char k, int kCode) {
  int carril = -1;
  if (nv2Dificultad == NV2_DIF_INTERMEDIO) {
    if (k == 'a' || k == 'A' || kCode == LEFT) carril = 0;
    else { if (k == 'd' || k == 'D' || kCode == RIGHT) carril = 1; }
  } else { if (nv2Dificultad == NV2_DIF_DIFICIL) {
    // Modo Difícil: D F J K
    if (k == 'd' || k == 'D') carril = 0;
    else { if (k == 'f' || k == 'F') carril = 1;
    else { if (k == 'j' || k == 'J') carril = 2;
    else { if (k == 'k' || k == 'K') carril = 3; } } }
  } else { if (nv2Dificultad == NV2_DIF_EXTREMO) {
    if (nv2ExtremoFaseMama) {
      // 6 teclas en Modo Furia de Mamá: S, D, F, J, K, L
      if (k == 's' || k == 'S') carril = 0;
      else { if (k == 'd' || k == 'D') carril = 1;
      else { if (k == 'f' || k == 'F') carril = 2;
      else { if (k == 'j' || k == 'J') carril = 3;
      else { if (k == 'k' || k == 'K') carril = 4;
      else { if (k == 'l' || k == 'L') carril = 5; } } } } }
    } else {
      // Modo Extremo estándar: D F J K L
      if (k == 'd' || k == 'D') carril = 0;
      else { if (k == 'f' || k == 'F') carril = 1;
      else { if (k == 'j' || k == 'J') carril = 2;
      else { if (k == 'k' || k == 'K') carril = 3;
      else { if (k == 'l' || k == 'L') carril = 4; } } } }
    }
  } else { if (nv2Dificultad == NV2_DIF_INJUGABLE) {
    // Modo Injugable (9 teclas en orden lineal): A S D F ESPACIO H J K L
    if (k == 'a' || k == 'A') carril = 0;
    else { if (k == 's' || k == 'S') carril = 1;
    else { if (k == 'd' || k == 'D') carril = 2;
    else { if (k == 'f' || k == 'F') carril = 3;
    else { if (k == ' ') carril = 4;
    else { if (k == 'h' || k == 'H') carril = 5;
    else { if (k == 'j' || k == 'J') carril = 6;
    else { if (k == 'k' || k == 'K') carril = 7;
    else { if (k == 'l' || k == 'L') carril = 8; } } } } } } } }
  } } } }
  return carril;
}

void iniciarPartidaNivel2() {
  nv2ReiniciarPartida = false;
  nv2SubEstado = NV2_SUB_JUGANDO;
  nv2Completado = false;
  recompensaNivel2Otorgada = false;

  nv2PuntosObtenidos = 0;
  nv2ComboActual = 0;
  nv2MaxCombo = 0;
  nv2ConteoPerfecto = 0;
  nv2ConteoBueno = 0;
  nv2ConteoFallo = 0;
  nv2FeedbackVisual = "¡A COCINAR AL RITMO!";
  nv2FeedbackTimer = 55;
  nv2ColorFeedback = color(255, 225, 80);
  nv2ProgresoLerp = 0.0f;

  // Reiniciar Vida / Calidad del Plato
  nv2VidaPlato = 100.0f;
  nv2VidaPlatoLerp = 100.0f;
  nv2FlashDanoTimer = 0;

  // Reiniciar estado de Fase Mamá en Extremo
  nv2ExtremoFaseAlerta = false;
  nv2ExtremoFaseMama = false;
  nv2ExtremoAlertaInicioMs = 0;
  nv2ExtremoMamaInicioMs = 0;
  nv2UltimoSegAlerta = -1;
  nv2ProgresoMamaLerp = 0.0f;

  // Reiniciar estado de Combo Dinámico y efectos
  nv2ComboPosX = width * 0.5f;
  nv2ComboPosY = 235 * escalaY;
  nv2ComboTargetX = width * 0.5f;
  nv2ComboTargetY = 235 * escalaY;
  nv2ComboAngulo = 0.0f;
  nv2ComboTargetAngulo = 0.0f;
  nv2ComboEscala = 1.0f;
  nv2UltimoHitMs = -9999;

  for (int i = 0; i < MAX_HYPE_NV2; i++) nv2HypeActivo[i] = false;
  for (int i = 0; i < MAX_ONDAS_NV2; i++) nv2OndaActiva[i] = false;
  for (int i = 0; i < MAX_RAYOS_ARRANQUE; i++) nv2RayoActivo[i] = false;
  for (int i = 0; i < MAX_SLASH_NV2; i++) nv2SlashActivo[i] = false;
  for (int i = 0; i < MAX_PART_FUEGO_NV2; i++) nv2FuegoActivo[i] = false;
  nv2ZoomCamara = 1.0f;
  nv2ScrollHighwayOffset = 0.0f;

  for (int c = 0; c < MAX_CARRILES_NV2; c++) {
    nv2TeclaCarrilPresionada[c] = false;
    nv2FlashCarril[c] = 0;
    nv2VibracionCarril[c] = 0.0f;
    nv2KeybeamAlfa[c] = 0.0f;
    nv2KeybeamEsHit[c] = false;
    nv2LatidoLineaCarril[c] = 0.0f;
    nv2ReceptorEscala[c] = 1.0f;
  }
  nv2TeclaIzqPresionada = false;
  nv2TeclaDerPresionada = false;

  mostrarOpciones = false;
  if (volMaster <= 0.05f) {
    volMaster = 1.0f;
    nivelVolumen = 10;
  }

  if (musicaFondo != null) {
    musicaFondo.stop();
  }
  musicaFondoDeberiaSonar = false;

  // 1. Cargar primero la canción propia de esta dificultad (cada nivel tiene su propia canción)
  cargarAudioNivel2PorDificultad(nv2Dificultad, false);

  // 2. Configurar velocidad y carriles iniciales según dificultad (actualiza título de canción en el caché)
  if (nv2Dificultad == NV2_DIF_INTERMEDIO) {
    configurarGeometriaCarrilesNv2(2);
    nv2VelocidadPxPorMs = 0.52f;
    nv2VentanaPerfectoMs = 85;
    nv2VentanaBuenoMs = 155;
  } else { if (nv2Dificultad == NV2_DIF_DIFICIL) {
    // En Difícil empieza con 2 carriles y se expande progresivamente a 3 y 4 carriles durante la canción
    configurarGeometriaCarrilesNv2(2);
    nv2VelocidadPxPorMs = 0.65f;
    nv2VentanaPerfectoMs = 78;
    nv2VentanaBuenoMs = 145;
  } else { if (nv2Dificultad == NV2_DIF_EXTREMO) {
    configurarGeometriaCarrilesNv2(5);
    nv2VelocidadPxPorMs = 0.80f;
    nv2VentanaPerfectoMs = 72;
    nv2VentanaBuenoMs = 135;
  } else {
    // Injugable: 9 carriles (A S D F ESPACIO H J K L) y caída ultrarrápida
    configurarGeometriaCarrilesNv2(9);
    nv2VelocidadPxPorMs = 1.05f;
    nv2VentanaPerfectoMs = 68;
    nv2VentanaBuenoMs = 130;
  } } }

  // 3. Analizar la onda real del audio cargado + BPM para que las notas sigan exactamente a la canción
  generarMapaNotasNivel2(nv2Dificultad);
  reproducirOpeningChestNv2(0.55f);

  try {
    if (nv2Audio != null) {
      // Garantizar que la canción SIEMPRE empiece desde el segundo 0:00 al darle Play o Reintentar
      nv2Audio.stop();
      nv2Audio.cue(0.0f);
      nv2Audio.rate(1.0f);
      nv2Audio.amp(max(0.6f, volMaster));
      nv2Audio.play();
    }
  } catch (Exception e) {
    try {
      if (nv2Audio != null) {
        nv2Audio.cue(0.0f);
        nv2Audio.amp(max(0.6f, volMaster));
        nv2Audio.play();
      }
    } catch (Exception ex) {
      nv2Audio = null;
    }
  }
  nv2TiempoInicioMs = millis();
  nv2TimerAutoAvanceBot = 0;
  nv2SeccionCancionActual = -1;
}

boolean hayEspacioEnCarrilNv2(int tiempoMs, int c, boolean sostenida, int duracionMs) {
  boolean espacioLibre = true;
  int durNueva = sostenida ? duracionMs : 0;
  int margenTrasSostenidaMs = (nv2Dificultad == NV2_DIF_INJUGABLE) ? 35 : (nv2ExtremoFaseMama ? 520 : 800);
  int margenAntesSostenidaMs = (nv2Dificultad == NV2_DIF_INJUGABLE) ? 30 : (nv2ExtremoFaseMama ? 360 : 540);
  int margenNormalMs = (nv2Dificultad == NV2_DIF_INJUGABLE) ? 25 : (nv2ExtremoFaseMama ? 160 : 220);

  for (int j = 0; j < totalNotasNv2 && espacioLibre; j++) {
    if (nv2NotaCarril[j] == c) {
      int tIniJ = nv2NotaTiempoMs[j];
      int tFinJ = tIniJ + (nv2NotaEsSostenida[j] ? nv2NotaDuracionMs[j] : 0);

      if (tiempoMs >= tIniJ) {
        if (nv2NotaEsSostenida[j]) {
          // Dejar un espacio después del fin de una nota sostenida en la misma fila/carril
          if (tiempoMs < tFinJ + margenTrasSostenidaMs) espacioLibre = false;
        } else { if (sostenida) {
          // Si viene una nota sostenida después de otra en el mismo carril, dejar espacio antes
          if (tiempoMs < tFinJ + margenAntesSostenidaMs) espacioLibre = false;
        } else {
          if (tiempoMs < tFinJ + margenNormalMs) espacioLibre = false;
        } }
      } else {
        int tFinNueva = tiempoMs + durNueva;
        if (sostenida) {
          if (tFinNueva + margenTrasSostenidaMs > tIniJ) espacioLibre = false;
        } else { if (nv2NotaEsSostenida[j]) {
          if (tFinNueva + margenAntesSostenidaMs > tIniJ) espacioLibre = false;
        } else {
          if (tFinNueva + margenNormalMs > tIniJ) espacioLibre = false;
        } }
      }
    }
  }
  return espacioLibre;
}

int obtenerMaxCarrilesEnTiempoNv2(int tiempoMs) {
  int maxC = 9;
  if (nv2Dificultad == NV2_DIF_INTERMEDIO) {
    maxC = 2;
  } else { if (nv2Dificultad == NV2_DIF_DIFICIL) {
    if (tiempoMs < 24000) maxC = 2;
    else { if (tiempoMs < 52000) maxC = 3;
    else maxC = 4; }
  } else { if (nv2Dificultad == NV2_DIF_EXTREMO) {
    if (nv2ExtremoFaseMama) maxC = 6;
    else maxC = 5;
  } } }
  return maxC;
}

void agregarNotaNv2(int tiempoMs, int carril, boolean sostenida, int duracionMs) {
  if (totalNotasNv2 < MAX_NOTAS_NV2) {
    int maxC = obtenerMaxCarrilesEnTiempoNv2(tiempoMs);
    int c = constrain(carril, 0, maxC - 1);
    int dur = sostenida ? duracionMs : 0;
    boolean puedeAgregar = true;

    if (!hayEspacioEnCarrilNv2(tiempoMs, c, sostenida, dur)) {
      if (nv2Dificultad == NV2_DIF_INJUGABLE) {
        // En modo Injugable (9-Key VSRG Rush E), respetar estrictamente el carril asignado sin reubicar a otro carril
        puedeAgregar = false;
      } else { if (nv2Dificultad == NV2_DIF_INTERMEDIO) {
        // En modo Intermedio no deben crearse notas dobles al reubicar
        for (int j = 0; j < totalNotasNv2 && puedeAgregar; j++) {
          if (abs(nv2NotaTiempoMs[j] - tiempoMs) < 260) {
            puedeAgregar = false;
          }
        }
      } }
      if (puedeAgregar) {
        int cAlternativo = -1;
        for (int paso = 1; paso < maxC && cAlternativo == -1; paso++) {
          int cand = (c + paso) % maxC;
          if (hayEspacioEnCarrilNv2(tiempoMs, cand, sostenida, dur)) {
            boolean ocupadoCerca = false;
            for (int j = 0; j < totalNotasNv2 && !ocupadoCerca; j++) {
              if (nv2NotaCarril[j] == cand && abs(nv2NotaTiempoMs[j] - tiempoMs) < 320) {
                ocupadoCerca = true;
              }
            }
            if (!ocupadoCerca) {
              cAlternativo = cand;
            }
          }
        }
        if (cAlternativo == -1) {
          puedeAgregar = false;
        } else {
          c = cAlternativo;
        }
      }
    }

    if (puedeAgregar) {
      int idx = totalNotasNv2;
      nv2NotaTiempoMs[idx] = tiempoMs;
      nv2NotaCarril[idx] = c;
      nv2NotaEsSostenida[idx] = sostenida;
      nv2NotaDuracionMs[idx] = dur;
      nv2NotaImpactada[idx] = false;
      nv2NotaManteniendo[idx] = false;
      nv2NotaCompletada[idx] = false;
      nv2NotaFallada[idx] = false;
      nv2NotaUltimoTickMs[idx] = tiempoMs;

      // Garantizar orden cronológico ascendente estricto para los cortes tempranos del motor
      int k = idx;
      while (k > 0 && nv2NotaTiempoMs[k] < nv2NotaTiempoMs[k - 1]) {
        int tmpT = nv2NotaTiempoMs[k]; nv2NotaTiempoMs[k] = nv2NotaTiempoMs[k - 1]; nv2NotaTiempoMs[k - 1] = tmpT;
        int tmpC = nv2NotaCarril[k]; nv2NotaCarril[k] = nv2NotaCarril[k - 1]; nv2NotaCarril[k - 1] = tmpC;
        boolean tmpS = nv2NotaEsSostenida[k]; nv2NotaEsSostenida[k] = nv2NotaEsSostenida[k - 1]; nv2NotaEsSostenida[k - 1] = tmpS;
        int tmpD = nv2NotaDuracionMs[k]; nv2NotaDuracionMs[k] = nv2NotaDuracionMs[k - 1]; nv2NotaDuracionMs[k - 1] = tmpD;
        int tmpU = nv2NotaUltimoTickMs[k]; nv2NotaUltimoTickMs[k] = nv2NotaUltimoTickMs[k - 1]; nv2NotaUltimoTickMs[k - 1] = tmpU;
        k--;
      }
      totalNotasNv2++;
    }
  }
}

// =========================================================================
// ANALIZADOR DE ONDA MUSICAL REAL (PCM WAVEFORM + BPM) PARA SEGUIR CADA CANCIÓN
// =========================================================================
boolean generarMapaNotasDesdeAudioNv2(int dif, int offsetRelojMs, int duracionMapaMs, boolean modoMama) {
  boolean mapaGenerado = false;
  if (nv2Audio != null) {
    int totalFrames = 0;
    int sRate = 44100;
    boolean lecturaValida = true;
    try {
      totalFrames = nv2Audio.frames();
      sRate = max(8000, nv2Audio.sampleRate());
    } catch (Exception e) {
      lecturaValida = false;
    }

    int ventanaMs = 40; // 25 ventanas por segundo (resolución rítmica de 40 ms)
    int numVentanas = min(MAX_VENTANAS_ANALISIS_NV2 - 1, duracionMapaMs / ventanaMs);

    if (lecturaValida && totalFrames > 1000 && numVentanas > 40) {
      int framesPorVentana = max(1, (sRate * ventanaMs) / 1000);
      int pasoMuestra = max(1, framesPorVentana / 28); // ~28 muestras por ventana = análisis instantáneo (< 3 ms)
      float maxEnergiaGlobal = 0.0001f;

      int ventanaOffsetAudio = modoMama ? (nv2DuracionMsPorDif[NV2_DIF_EXTREMO] / ventanaMs) : 0;

      // 1. Extraer envolvente de energía (RMS), graves y agudos leyendo directamente los frames PCM de la canción
      for (int v = 0; v < numVentanas; v++) {
        int frameBase = ((v + ventanaOffsetAudio) * framesPorVentana) % totalFrames;
        float sumaAbs = 0.0f;
        float sumaDiff = 0.0f;
        float prevM = 0.0f;
        int cont = 0;
        for (int f = frameBase; f < frameBase + framesPorVentana && f < totalFrames; f += pasoMuestra) {
          float m = nv2Audio.read(f, 0);
          float a = abs(m);
          sumaAbs += a;
          if (cont > 0) {
            sumaDiff += abs(m - prevM);
          }
          prevM = m;
          cont++;
        }
        if (cont > 0) {
          float e = sumaAbs / float(cont);
          float ag = sumaDiff / float(cont);
          nv2EnergiaVentana[v] = e;
          nv2AgudoVentana[v] = ag;
          nv2GraveVentana[v] = max(0.0f, e - ag * 0.65f);
          if (e > maxEnergiaGlobal) maxEnergiaGlobal = e;
        } else {
          nv2EnergiaVentana[v] = 0.0f;
          nv2AgudoVentana[v] = 0.0f;
          nv2GraveVentana[v] = 0.0f;
        }
      }

      // Normalizar entre 0.0 y 1.0 respecto al pico máximo de la canción
      for (int v = 0; v < numVentanas; v++) {
        nv2EnergiaVentana[v] /= maxEnergiaGlobal;
        nv2AgudoVentana[v] /= maxEnergiaGlobal;
        nv2GraveVentana[v] /= maxEnergiaGlobal;
      }

      // 2. Configurar sensibilidad rítmica y rejilla BPM propia de la canción de este nivel
      int bpm = modoMama ? nv2BpmFaseMama : nv2BpmPorDif[constrain(dif, 0, TOTAL_DIFICULTADES_NV2 - 1)];
      float beatMs = 60000.0f / float(max(60, bpm));
      float subdivMs = (dif == NV2_DIF_INTERMEDIO) ? beatMs : ((dif == NV2_DIF_DIFICIL) ? (beatMs * 0.5f) : (beatMs * 0.25f));
      if (modoMama) subdivMs = beatMs * 0.5f;

      int minSepMs = 460;
      float ratioUmbralPico = 1.24f;
      float probSostenida = 0.20f;
      if (modoMama) {
        minSepMs = 155;
        ratioUmbralPico = 1.07f;
        probSostenida = 0.14f;
      } else { if (dif == NV2_DIF_INTERMEDIO) {
        minSepMs = 460;
        ratioUmbralPico = 1.22f;
        probSostenida = 0.22f;
      } else { if (dif == NV2_DIF_DIFICIL) {
        minSepMs = 270;
        ratioUmbralPico = 1.14f;
        probSostenida = 0.24f;
      } else { if (dif == NV2_DIF_EXTREMO) {
        minSepMs = 195;
        ratioUmbralPico = 1.10f;
        probSostenida = 0.20f;
      } else {
        minSepMs = 125;
        ratioUmbralPico = 1.05f;
        probSostenida = 0.16f;
      } } } }

      int vInicio = modoMama ? (850 / ventanaMs) : (2200 / ventanaMs);
      int vFin = numVentanas - (1500 / ventanaMs);
      int ultimoOnsetMs = -9999;
      int ultimoCarril = 0;
      int numNotasCreadas = 0;
      float umbralSilencio = 0.085f;

      for (int v = vInicio; v < vFin; v++) {
        int tRelMs = v * ventanaMs;
        int tAbsMs = offsetRelojMs + tRelMs;
        if (tRelMs - ultimoOnsetMs < minSepMs) continue;

        float eAct = nv2EnergiaVentana[v];
        if (eAct < umbralSilencio) continue;

        float sumaLocal = 0.0f;
        int contLocal = 0;
        for (int k = max(0, v - 12); k <= min(numVentanas - 1, v + 6); k++) {
          sumaLocal += nv2EnergiaVentana[k];
          contLocal++;
        }
        float promLocal = (contLocal > 0) ? (sumaLocal / float(contLocal)) : eAct;

        boolean esPicoMusical = (eAct >= nv2EnergiaVentana[v - 1] && eAct >= nv2EnergiaVentana[v + 1] && eAct > promLocal * ratioUmbralPico);

        float restoSub = tRelMs % subdivMs;
        float distSub = min(restoSub, subdivMs - restoSub);
        boolean enRejillaBpm = (distSub <= ventanaMs * 0.85f);

        int maxHuecoActivoMs = modoMama ? 400 : ((dif == NV2_DIF_INJUGABLE) ? 340 : ((dif == NV2_DIF_EXTREMO) ? 540 : ((dif == NV2_DIF_DIFICIL) ? 700 : 950)));
        boolean pulsoContinuo = enRejillaBpm && (eAct > promLocal * 0.90f) && (tRelMs - ultimoOnsetMs >= maxHuecoActivoMs);

        if (!esPicoMusical && !pulsoContinuo) continue;

        int maxC = obtenerMaxCarrilesEnTiempoNv2(tAbsMs);

        float ratioAgudo = nv2AgudoVentana[v] / max(0.0001f, eAct);
        int bandaEspectral = round(constrain(map(ratioAgudo, 0.12f, 0.72f, 0, maxC - 1), 0, maxC - 1));
        int carril = (bandaEspectral + numNotasCreadas) % maxC;
        if (carril == ultimoCarril && maxC > 1 && (numNotasCreadas % 3 != 0)) {
          carril = (carril + 1 + (v % (maxC - 1))) % maxC;
        }
        if (modoMama && numNotasCreadas % 4 == 0) {
          carril = 0;
        }

        int ventanasSost = 0;
        int maxVentSost = modoMama ? 7 : 14;
        for (int s = v + 1; s < min(vFin, v + maxVentSost); s++) {
          if (nv2EnergiaVentana[s] >= eAct * 0.68f && nv2EnergiaVentana[s] > umbralSilencio * 1.3f) {
            ventanasSost++;
          } else {
            break;
          }
        }
        boolean hacerSostenida = (ventanasSost >= 6) && (((numNotasCreadas * 7 + v) % 100) < round(probSostenida * 100));
        int durSostMs = hacerSostenida ? constrain(ventanasSost * ventanaMs, modoMama ? 240 : 380, modoMama ? 420 : 680) : 0;

        agregarNotaNv2(tAbsMs, carril, hacerSostenida, durSostMs);
        ultimoOnsetMs = tRelMs;
        ultimoCarril = carril;
        numNotasCreadas++;

        if (!hacerSostenida && eAct > promLocal * 1.34f) {
          if (modoMama || dif == NV2_DIF_EXTREMO || dif == NV2_DIF_INJUGABLE) {
            int freqAcorde = (dif == NV2_DIF_INJUGABLE) ? 2 : 3;
            if (numNotasCreadas % freqAcorde == 0) {
              int cSimult = (carril + max(2, maxC / 2)) % maxC;
              agregarNotaNv2(tAbsMs, cSimult, false, 0);
            }
          }
        }
      }

      if (totalNotasNv2 >= 25) {
        mapaGenerado = true;
      }
    }
  }
  return mapaGenerado;
}

int obtenerSeccionAoiKoiPorTiempoNv2(int tMs) {
  int sec = 7;                  // 3:45 - Fin  Outro (Cascada hasta corte abrupto)
  if (tMs < 25000) sec = 0;     // 0:00 - 0:25 Intro Instrumental
  else { if (tMs < 50000) sec = 1;  // 0:25 - 0:50 Verso 1 (Intro cantada)
  else { if (tMs < 76000) sec = 2;  // 0:50 - 1:16 Estribillo / Drop 1
  else { if (tMs < 102000) sec = 3; // 1:16 - 1:42 Transición Instrumental
  else { if (tMs < 140000) sec = 4; // 1:42 - 2:20 Verso 2 & Pre-Coro
  else { if (tMs < 180000) sec = 5; // 2:20 - 3:00 Coro Principal (Clímax / Kiai)
  else { if (tMs < 225000) sec = 6; } } } } } } // 3:00 - 3:45 Puente Instrumental (Bridge)
  return sec;
}

int obtenerSeccionRushEPorTiempoNv2(int tMs) {
  int sec = 8;                    // 2:18.0 - 2:38.0 (138000 - 158000 ms) 8/8 Outro del Video
  if (tMs < 21200) sec = 0;       // 0:00.0 - 0:21.2 (0 - 21200 ms)       Intro del Canal, Silencio & El "E" Inicial
  else { if (tMs < 51000) sec = 1;  // 0:21.2 - 0:51.0 (21200 - 51000 ms)   1/8 Tema A - Polca Lenta (90 a 115 BPM)
  else { if (tMs < 71000) sec = 2;  // 0:51.0 - 1:11.0 (51000 - 71000 ms)   2/8 Tema A - Variación Rápida (135 BPM)
  else { if (tMs < 83200) sec = 3;  // 1:11.0 - 1:23.2 (71000 - 83200 ms)   3/8 Puente Melódico - Sección B (Jumps)
  else { if (tMs < 95500) sec = 4;  // 1:23.2 - 1:35.5 (83200 - 95500 ms)   4/8 Retorno Acelerado & Vocal "E" (160 BPM)
  else { if (tMs < 107200) sec = 5; // 1:35.5 - 1:47.2 (95500 - 107200 ms)  5/8 Reinicio & Aceleración Crítica (90->175 BPM)
  else { if (tMs < 126200) sec = 6; // 1:47.2 - 2:06.2 (107200 - 126200 ms) 6/8 Clímax Black MIDI (180 BPM)
  else { if (tMs < 138000) sec = 7; } } } } } } } // 2:06.2 - 2:18.0 (126200 - 138000 ms) 7/8 Outro - Caos Absoluto (Kiai)
  return sec;
}

// =========================================================================
// MAPA RÍTMICO OFICIAL SINCRONIZADO: "AOI, KOI, DAIDAIIRO NO HI" (149 BPM, 4/4)
// (Nivel EXTREMO: Secciones 1-6 [0:00-3:00] en Fase 1 con 5 carriles,
//  y Secciones 7-8 [3:00-4:30] en Fase Mamá con 6 carriles incluyendo [S])
// =========================================================================
void generarMapaAoiKoiSincronizadoNv2(boolean modoMama, int offsetRelojMs) {
  int ventanaMs = 40;
  int duracionCancionTotalMs = 282250;
  int numVentanas = min(MAX_VENTANAS_ANALISIS_NV2 - 1, duracionCancionTotalMs / ventanaMs);
  boolean tieneOndaAudio = false;

  // 1. Extraer envolvente real de Aoi.mp3 para detectar silencios, platillos, voz, bajo, snare y el corte abrupto final
  if (nv2Audio != null) {
    try {
      int totalFrames = nv2Audio.frames();
      int sRate = max(8000, nv2Audio.sampleRate());
      if (totalFrames > 1000 && numVentanas > 40) {
        int framesPorVentana = max(1, (sRate * ventanaMs) / 1000);
        int pasoMuestra = max(1, framesPorVentana / 28);
        float maxE = 0.0001f;
        for (int v = 0; v < numVentanas; v++) {
          int frameBase = (v * framesPorVentana) % totalFrames;
          float sumaAbs = 0.0f;
          float sumaDiff = 0.0f;
          float prevM = 0.0f;
          int cont = 0;
          for (int f = frameBase; f < frameBase + framesPorVentana && f < totalFrames; f += pasoMuestra) {
            float m = nv2Audio.read(f, 0);
            sumaAbs += abs(m);
            if (cont > 0) sumaDiff += abs(m - prevM);
            prevM = m;
            cont++;
          }
          if (cont > 0) {
            float e = sumaAbs / float(cont);
            float ag = sumaDiff / float(cont);
            nv2EnergiaVentana[v] = e;
            nv2AgudoVentana[v] = ag;
            nv2GraveVentana[v] = max(0.0f, e - ag * 0.65f);
            if (e > maxE) maxE = e;
          } else {
            nv2EnergiaVentana[v] = 0.0f;
            nv2AgudoVentana[v] = 0.0f;
            nv2GraveVentana[v] = 0.0f;
          }
        }
        for (int v = 0; v < numVentanas; v++) {
          nv2EnergiaVentana[v] /= maxE;
          nv2AgudoVentana[v] /= maxE;
          nv2GraveVentana[v] /= maxE;
        }
        tieneOndaAudio = true;
      }
    } catch (Exception e) {
      tieneOndaAudio = false;
    }
  }

  // Detectar el instante exacto del final en el archivo Aoi.mp3 (282,253 ms)
  int finCorteAbruptoMs = 281200;
  if (tieneOndaAudio) {
    for (int v = numVentanas - 1; v > (250000 / ventanaMs); v--) {
      if (nv2EnergiaVentana[v] > 0.08f) {
        finCorteAbruptoMs = min(duracionCancionTotalMs - 800, v * ventanaMs);
        break;
      }
    }
  }

  // 2. Rejilla oficial 149 BPM en compás 4/4
  // 1 negra (beat) = 60000 / 149 = 402.68457 ms | 1 corchea = 201.34228 ms | 1 compás (4 negras) = 8 corcheas = 1610.738 ms
  float corcheaMs = 60000.0f / (149.0f * 2.0f);
  int maxC = modoMama ? 6 : 5; // Fase 1: 5 carriles (D,F,J,K,L) | Fase Mamá: 6 carriles (S,D,F,J,K,L)
  int inicioAudioMs = modoMama ? 180800 : 1800;
  int finAudioMs = modoMama ? finCorteAbruptoMs : (180000 - 600);

  int idxInicio = max(4, int(inicioAudioMs / corcheaMs));
  int idxFin = int(finAudioMs / corcheaMs);

  // Patrones vocales y de riffs en arreglos fijos (adaptados a los 5 carriles de Extremo)
  int[] carrilesVocales = { 1, 2, 3, 2, 1, 2, 3, 4 }; // Centro melódico para la voz de Natsuko
  int[] saltosDrop = { 0, 4, 1, 3, 0, 4, 2, 4, 1, 3, 0, 4, 2, 0, 3, 4 }; // Saltos rápidos en Estribillo
  int[] cruzadosKiai = { 0, 4, 2, 1, 3, 2, 0, 4, 2, 3, 1, 2, 4, 0, 2, 3 }; // Patrones cruzados en Coro Kiai

  for (int idxC = idxInicio; idxC <= idxFin; idxC++) {
    int tMs = round(idxC * corcheaMs);
    if (tMs < inicioAudioMs || tMs > finAudioMs) continue;

    // Tiempo real en el reloj de la partida
    int tReloj = modoMama ? (offsetRelojMs + (tMs - 180000)) : tMs;

    int vIdx = constrain(tMs / ventanaMs, 0, numVentanas - 1);
    float eAudio = tieneOndaAudio ? nv2EnergiaVentana[vIdx] : 0.55f;
    float agAudio = tieneOndaAudio ? nv2AgudoVentana[vIdx] : 0.30f;

    // Respetar silencios reales del audio
    if (tieneOndaAudio && eAudio < 0.045f) continue;

    int pasoCompas = idxC % 8; // 0..7 dentro del compás de 4/4 (0=Beat 1, 2=Beat 2/Snare, 4=Beat 3, 6=Beat 4/Snare)
    int numCompas = idxC / 8;
    boolean esTiempoNegra = (idxC % 2 == 0);
    boolean esGolpeCajaSnare = (pasoCompas == 2 || pasoCompas == 6); // Tiempos 2 y 4 del 4/4

    // Desplazamiento espectral según la frecuencia real de la ventana (0..2)
    int modEspectral = (tieneOndaAudio && eAudio > 0.08f) ? constrain(round((agAudio / max(0.01f, eAudio)) * 2.5f), 0, 2) : 0;

    if (!modoMama) {
      // =========================================================================
      // SECCIÓN 1: INTRO INSTRUMENTAL (0:00 - 0:25 | 0 - 25,000 ms)
      // =========================================================================
      if (tMs < 25000) {
        if (tMs < 12200) {
          // 0:00 - 0:12 -> Comienza con golpes lentos siguiendo los platillos (negras/blancas en carriles altos J, K, L)
          if (pasoCompas == 0 || pasoCompas == 4 || (tieneOndaAudio && eAudio > 0.36f && esTiempoNegra)) {
            int cPlatillo = 2 + ((numCompas + (pasoCompas / 2) + modEspectral) % 3); // J, K, L (2..4)
            boolean sostIntro = (pasoCompas == 0 && numCompas % 2 == 0);
            agregarNotaNv2(tReloj, cPlatillo, sostIntro, sostIntro ? 480 : 0);
          }
        } else {
          // 0:12 - 0:25 -> Entra la distorsión total de la guitarra: ráfagas rápidas de notas simples (corcheas continuas)
          int cRafaga = (idxC + numCompas * 2 + modEspectral) % maxC;
          agregarNotaNv2(tReloj, cRafaga, false, 0);
          if (tMs > 22800 && pasoCompas == 6) {
            agregarNotaNv2(tReloj + round(corcheaMs * 0.5f), (cRafaga + 2) % maxC, false, 0);
          }
        }
      }

      // =========================================================================
      // SECCIÓN 2: VERSO 1 - INTRO CANTADA (0:25 - 0:50 | 25,000 - 50,000 ms)
      // =========================================================================
      else { if (tMs < 50000) {
        // Mapeo vocal siguiendo las sílabas de la voz de Natsuko (densidad reducida para dar respiro)
        int posEnFraseVocal = idxC % 16;
        if (posEnFraseVocal <= 11) {
          boolean silabaActiva = esTiempoNegra || (posEnFraseVocal == 3 || posEnFraseVocal == 7 || posEnFraseVocal == 9) || (tieneOndaAudio && eAudio > 0.42f);
          if (silabaActiva) {
            int cVocal = carrilesVocales[(posEnFraseVocal + modEspectral) % 8] % maxC;
            boolean finSilabaLarga = (posEnFraseVocal == 10);
            agregarNotaNv2(tReloj, cVocal, finSilabaLarga, finSilabaLarga ? 460 : 0);
          }
        } else { if (posEnFraseVocal == 14 && tieneOndaAudio && eAudio > 0.35f) {
          agregarNotaNv2(tReloj, 0, false, 0);
        } }
      }

      // =========================================================================
      // SECCIÓN 3: ESTRIBILLO / DROP 1 (0:50 - 1:16 | 50,000 - 76,000 ms)
      // =========================================================================
      else { if (tMs < 76000) {
        // Pico de intensidad: el ritmo explota. Stream denso de corcheas siguiendo la batería agresiva y saltos rápidos
        int cSalto = (saltosDrop[idxC % 16] + modEspectral) % maxC;
        agregarNotaNv2(tReloj, cSalto, false, 0);

        // Golpe doble de impacto en el inicio de cada compás y en golpes de caja
        if (pasoCompas == 0 || (esGolpeCajaSnare && numCompas % 2 == 1)) {
          int cPar = (cSalto < 2) ? (2 + (idxC % 3)) : (idxC % 2);
          agregarNotaNv2(tReloj, cPar, false, 0);
        }
      }

      // =========================================================================
      // SECCIÓN 4: TRANSICIÓN INSTRUMENTAL (1:16 - 1:42 | 76,000 - 102,000 ms)
      // =========================================================================
      else { if (tMs < 102000) {
        // Sección técnica: centrada estrictamente en el riff de bajo y la batería con notas sostenidas (sliders/long notes)
        if (pasoCompas == 0 || pasoCompas == 4) {
          int cBajo = (numCompas + (pasoCompas / 4) + modEspectral) % 2; // Carriles graves D, F (0, 1)
          agregarNotaNv2(tReloj, cBajo, true, 520);
        } else { if (pasoCompas == 2 || pasoCompas == 6 || pasoCompas == 7) {
          int cBat = 2 + ((idxC + modEspectral) % 3); // Batería en mano derecha J, K, L (2, 3, 4)
          agregarNotaNv2(tReloj, cBat, false, 0);
        } }
      }

      // =========================================================================
      // SECCIÓN 5: VERSO 2 & PRE-CORO (1:42 - 2:20 | 102,000 - 140,000 ms)
      // =========================================================================
      else { if (tMs < 140000) {
        boolean enPreCoro = (tMs >= 124000);
        if (!enPreCoro) {
          if (esTiempoNegra || pasoCompas == 3 || pasoCompas == 7) {
            int cMix = carrilesVocales[(idxC + modEspectral) % 8] % maxC;
            boolean sostMix = (pasoCompas == 4 && numCompas % 2 == 1);
            agregarNotaNv2(tReloj, cMix, sostMix, sostMix ? 420 : 0);
            if (esGolpeCajaSnare && !sostMix) {
              int cGuit = (cMix <= 1) ? 4 : 0;
              agregarNotaNv2(tReloj, cGuit, false, 0);
            }
          }
        } else {
          int cPre = (idxC * 2 + modEspectral) % maxC;
          agregarNotaNv2(tReloj, cPre, false, 0);
          if (pasoCompas == 0 || pasoCompas == 4) {
            agregarNotaNv2(tReloj, (cPre + 2) % maxC, false, 0);
          }
        }
      }

      // =========================================================================
      // SECCIÓN 6: CORO PRINCIPAL - CLÍMAX / KIAI (2:20 - 3:00 | 140,000 - 180,000 ms)
      // =========================================================================
      else {
        // Kiai / Máxima dificultad: patrones cruzados + dobles notas en los golpes de caja (snare: tiempos 2 y 4)
        int cKiai = (cruzadosKiai[idxC % 16] + modEspectral) % maxC;
        agregarNotaNv2(tReloj, cKiai, false, 0);

        if (esGolpeCajaSnare || pasoCompas == 0) {
          int cSnare = (cKiai < 2) ? (2 + ((idxC * 3) % 3)) : ((idxC * 3) % 2);
          if (cSnare == cKiai) cSnare = (cKiai + 2) % maxC;
          agregarNotaNv2(tReloj, cSnare, false, 0);
        }

        if (numCompas % 2 == 1 && (pasoCompas == 3 || pasoCompas == 7)) {
          int tSemi = tReloj + round(corcheaMs * 0.5f);
          agregarNotaNv2(tSemi, 2, false, 0);
        }
      } } } } }
    } else {
      // =========================================================================
      // FASE MAMÁ (6 CARRILES S, D, F, J, K, L): SECCIONES 7 y 8 DE AOI KOI (3:00 - 4:30)
      // =========================================================================
      if (tMs < 225000) {
        // SECCIÓN 7: PUENTE INSTRUMENTAL / BRIDGE (3:00 - 3:45 | 180,000 - 225,000 ms)
        // Cambio de ritmo atmosférico con deslizadores lentos + protagonismo del nuevo 6to carril [S] (carril 0)
        if (pasoCompas == 0) {
          int cBridge = (numCompas % 2 == 0) ? 0 : ((numCompas * 2 + modEspectral) % maxC);
          agregarNotaNv2(tReloj, cBridge, true, 880);
        } else { if (pasoCompas == 4) {
          int cEco = (5 - (numCompas % maxC));
          boolean sostEco = (numCompas % 2 == 0);
          agregarNotaNv2(tReloj, cEco, sostEco, sostEco ? 620 : 0);
        } else { if ((pasoCompas == 2 || pasoCompas == 6) && eAudio > 0.28f) {
          int cPulso = (idxC + modEspectral) % maxC;
          agregarNotaNv2(tReloj, cPulso, false, 0);
        } } }
      } else {
        // SECCIÓN 8: OUTRO (3:45 - FIN | 225,000 ms - Corte abrupto final)
        if (tMs < 248000) {
          // 3:45 - 4:08 -> La instrumentación vuelve a subir progresivamente
          float progSubida = constrain(map(tMs, 225000, 248000, 0.0f, 1.0f), 0.0f, 1.0f);
          if (esTiempoNegra || progSubida > 0.35f) {
            int cSub = (idxC * 3 + modEspectral) % maxC;
            agregarNotaNv2(tReloj, cSub, false, 0);
            if (progSubida > 0.55f && esGolpeCajaSnare) {
              agregarNotaNv2(tReloj, (cSub + 3) % maxC, false, 0);
            }
          }
        } else {
          // 4:08 - Fin -> Cascada rápida en los 6 carriles (S, D, F, J, K, L) hasta el corte abrupto del final
          int cicloCascada = idxC % 10;
          int cCascada = (cicloCascada < 6) ? cicloCascada : (10 - cicloCascada); // Barrido S..L..S
          agregarNotaNv2(tReloj, cCascada, false, 0);

          if (esGolpeCajaSnare) {
            int cAcento = 5 - cCascada;
            if (cAcento != cCascada) {
              agregarNotaNv2(tReloj, cAcento, false, 0);
            }
          }

          if (tMs > finAudioMs - 16000 && pasoCompas % 2 == 1) {
            int tSemi = tReloj + round(corcheaMs * 0.5f);
            if (tMs + round(corcheaMs * 0.5f) < finAudioMs - 120) {
              int cSemi = (cCascada + 1) % maxC;
              agregarNotaNv2(tSemi, cSemi, false, 0);
            }
          }
        }
      }
    }
  }
}

// =========================================================================
// ARQUITECTURA BASADA EN PULSOS Y SUBDIVISIONES DE COMPÁS (4/4) PARA RUSH E
// =========================================================================
final int PATTERN_TEMA_A_5 = 5;
final int PATTERN_TEMA_A_6 = 6;
final int PATTERN_TEMA_A_7 = 7;
final int PATTERN_TEMA_A_8 = 8;
final int PATTERN_TEMA_A_9 = 9;
final int PATTERN_TEMA_A_10 = 10;
final int PATTERN_TEMA_A_11 = 11;
final int PATTERN_TEMA_A_12 = 12;
final int PATTERN_SECCION_B = 21;
final int PATTERN_OCTAVAS_ACENTUADAS = 29;
final int PATTERN_ACORDES_DESCENDENTES = 35;
final int PATTERN_REINICIO_DISONANTE = 40;
final int PATTERN_BLACK_MIDI_CLIMAX = 50;
final int PATTERN_MODULACION_CAOS = 60;

void addMeasure(int startTimeMs, int endTimeMs, int patternType) {
  float beatDuration = (endTimeMs - startTimeMs) / 4.0f;
  float sub16 = beatDuration / 4.0f;

  if (patternType == PATTERN_TEMA_A_5 || patternType == PATTERN_TEMA_A_9) {
    // MANO IZQUIERDA (Compás 5 / 9):
    // Pulso 1.0 y 3.0: Bajo en Carril 0 ('A')
    // Contratiempo 1.5 y 3.5: Acorde en Carriles [2+3] ('D'+'F')
    // Pulso 2.0 y 4.0: Bajo en Carril 1 ('S')
    // Contratiempo 2.5 y 4.5: Acorde en Carriles [2+3] ('D'+'F')
    for (int p = 0; p < 4; p++) {
      int tBajo = round(startTimeMs + p * beatDuration);
      int cBajo = (p % 2 == 0) ? 0 : 1;
      agregarNotaNv2(tBajo, cBajo, false, 0);

      int tAcorde = round(startTimeMs + p * beatDuration + 2.0f * sub16);
      agregarNotaNv2(tAcorde, 2, false, 0);
      agregarNotaNv2(tAcorde, 3, false, 0);

      // MANO DERECHA: 16 semicorcheas alternando 6-5-6-5
      for (int s = 0; s < 4; s++) {
        int tMel = round(startTimeMs + p * beatDuration + s * sub16);
        int cMel = (s % 2 == 0) ? 6 : 5;
        agregarNotaNv2(tMel, cMel, false, 0);
      }
    }
  } else { if (patternType == PATTERN_TEMA_A_6) {
    // MANO IZQUIERDA estándar
    for (int p = 0; p < 4; p++) {
      int tBajo = round(startTimeMs + p * beatDuration);
      int cBajo = (p % 2 == 0) ? 0 : 1;
      agregarNotaNv2(tBajo, cBajo, false, 0);

      int tAcorde = round(startTimeMs + p * beatDuration + 2.0f * sub16);
      agregarNotaNv2(tAcorde, 2, false, 0);
      agregarNotaNv2(tAcorde, 3, false, 0);
    }
    // MANO DERECHA:
    // Pulsos 1 y 2: 8 semicorcheas alternando 6 y 5
    for (int p = 0; p < 2; p++) {
      for (int s = 0; s < 4; s++) {
        int tMel = round(startTimeMs + p * beatDuration + s * sub16);
        int cMel = (s % 2 == 0) ? 6 : 5;
        agregarNotaNv2(tMel, cMel, false, 0);
      }
    }
    // Pulso 3: 4 semicorcheas Mi-Fa-Mi-Re# en Carriles 6 -> 7 -> 6 -> 5
    int[] melP3 = { 6, 7, 6, 5 };
    for (int s = 0; s < 4; s++) {
      int tMel = round(startTimeMs + 2 * beatDuration + s * sub16);
      agregarNotaNv2(tMel, melP3[s], false, 0);
    }
    // Pulso 4: 3 corcheas ascendentes Mi - La - Do en Carriles 6 (4.0) -> 7 (4.5) -> 8 (final)
    int t4_0 = round(startTimeMs + 3 * beatDuration);
    int t4_5 = round(startTimeMs + 3 * beatDuration + 2.0f * sub16);
    int t4_end = round(startTimeMs + 3 * beatDuration + 3.0f * sub16);
    agregarNotaNv2(t4_0, 6, false, 0);
    agregarNotaNv2(t4_5, 7, false, 0);
    agregarNotaNv2(t4_end, 8, false, 0);
  } else { if (patternType == PATTERN_TEMA_A_7) {
    // MANO IZQUIERDA estándar
    for (int p = 0; p < 4; p++) {
      int tBajo = round(startTimeMs + p * beatDuration);
      int cBajo = (p % 2 == 0) ? 0 : 1;
      agregarNotaNv2(tBajo, cBajo, false, 0);

      int tAcorde = round(startTimeMs + p * beatDuration + 2.0f * sub16);
      agregarNotaNv2(tAcorde, 2, false, 0);
      agregarNotaNv2(tAcorde, 3, false, 0);
    }
    // MANO DERECHA:
    // Pulso 1: 4 semicorcheas de Re5 en Carril 5 ('H')
    for (int s = 0; s < 4; s++) {
      int tMel = round(startTimeMs + 0 * beatDuration + s * sub16);
      agregarNotaNv2(tMel, 5, false, 0);
    }
    // Pulso 2: Re-Do-Si-Re en 5 -> 4 -> 3 -> 5
    int[] melP2 = { 5, 4, 3, 5 };
    for (int s = 0; s < 4; s++) {
      int tMel = round(startTimeMs + 1 * beatDuration + s * sub16);
      agregarNotaNv2(tMel, melP2[s], false, 0);
    }
    // Pulso 3: 4 semicorcheas de Do5 en Carril 5 ('H')
    for (int s = 0; s < 4; s++) {
      int tMel = round(startTimeMs + 2 * beatDuration + s * sub16);
      agregarNotaNv2(tMel, 5, false, 0);
    }
    // Pulso 4: Do-Si-La-Do en 5 -> 4 -> 3 -> 5
    int[] melP4 = { 5, 4, 3, 5 };
    for (int s = 0; s < 4; s++) {
      int tMel = round(startTimeMs + 3 * beatDuration + s * sub16);
      agregarNotaNv2(tMel, melP4[s], false, 0);
    }
  } else { if (patternType == PATTERN_TEMA_A_8) {
    // MANO IZQUIERDA:
    // Pulso 1: Bajo [0] y acorde [2+3]
    agregarNotaNv2(round(startTimeMs + 0 * beatDuration), 0, false, 0);
    agregarNotaNv2(round(startTimeMs + 0 * beatDuration + 2.0f * sub16), 2, false, 0);
    agregarNotaNv2(round(startTimeMs + 0 * beatDuration + 2.0f * sub16), 3, false, 0);

    // Pulso 2: Bajo [1] y acorde [2+3]
    agregarNotaNv2(round(startTimeMs + 1 * beatDuration), 1, false, 0);
    agregarNotaNv2(round(startTimeMs + 1 * beatDuration + 2.0f * sub16), 2, false, 0);
    agregarNotaNv2(round(startTimeMs + 1 * beatDuration + 2.0f * sub16), 3, false, 0);

    // Pulso 3: Golpe seco Sol#4 (Carril 4 'ESP' + Bajo en Carril 0)
    agregarNotaNv2(round(startTimeMs + 2 * beatDuration), 0, false, 0);
    agregarNotaNv2(round(startTimeMs + 2 * beatDuration), 4, false, 0);

    // Pulso 4: Silencio de melodía con golpe de bajo en [0] al final (en 4.75)
    agregarNotaNv2(round(startTimeMs + 3 * beatDuration + 3.0f * sub16), 0, false, 0);

    // MANO DERECHA:
    // Pulso 1: 4 semicorcheas de Si4 en Carril 5 ('H')
    for (int s = 0; s < 4; s++) {
      int tMel = round(startTimeMs + 0 * beatDuration + s * sub16);
      agregarNotaNv2(tMel, 5, false, 0);
    }
    // Pulso 2: 2 corcheas Fa#4 - Si4 en Carriles 4 (2.0) -> 5 (2.5)
    agregarNotaNv2(round(startTimeMs + 1 * beatDuration), 4, false, 0);
    agregarNotaNv2(round(startTimeMs + 1 * beatDuration + 2.0f * sub16), 5, false, 0);
  } else { if (patternType == PATTERN_TEMA_A_10) {
    // MANO IZQUIERDA estándar
    for (int p = 0; p < 4; p++) {
      int tBajo = round(startTimeMs + p * beatDuration);
      int cBajo = (p % 2 == 0) ? 0 : 1;
      agregarNotaNv2(tBajo, cBajo, false, 0);

      int tAcorde = round(startTimeMs + p * beatDuration + 2.0f * sub16);
      agregarNotaNv2(tAcorde, 2, false, 0);
      agregarNotaNv2(tAcorde, 3, false, 0);
    }
    // MANO DERECHA:
    // Pulsos 1 y 2: 8 semicorcheas alternando 6 y 5
    for (int p = 0; p < 2; p++) {
      for (int s = 0; s < 4; s++) {
        int tMel = round(startTimeMs + p * beatDuration + s * sub16);
        int cMel = (s % 2 == 0) ? 6 : 5;
        agregarNotaNv2(tMel, cMel, false, 0);
      }
    }
    // Pulso 3: 4 semicorcheas en 6 -> 7 -> 6 -> 5
    int[] melP3 = { 6, 7, 6, 5 };
    for (int s = 0; s < 4; s++) {
      int tMel = round(startTimeMs + 2 * beatDuration + s * sub16);
      agregarNotaNv2(tMel, melP3[s], false, 0);
    }
    // Pulso 4: 4 semicorcheas subiendo más agudo (Mi5 - La5 - Do6 - Mi6) en 5 -> 6 -> 7 -> 8
    int[] melP4 = { 5, 6, 7, 8 };
    for (int s = 0; s < 4; s++) {
      int tMel = round(startTimeMs + 3 * beatDuration + s * sub16);
      agregarNotaNv2(tMel, melP4[s], false, 0);
    }
  } else { if (patternType == PATTERN_TEMA_A_11) {
    // MANO IZQUIERDA estándar
    for (int p = 0; p < 4; p++) {
      int tBajo = round(startTimeMs + p * beatDuration);
      int cBajo = (p % 2 == 0) ? 0 : 1;
      agregarNotaNv2(tBajo, cBajo, false, 0);

      int tAcorde = round(startTimeMs + p * beatDuration + 2.0f * sub16);
      agregarNotaNv2(tAcorde, 2, false, 0);
      agregarNotaNv2(tAcorde, 3, false, 0);
    }
    // MANO DERECHA: Escala descendente de 16 semicorcheas continuas en los 4 pulsos
    int[][] esc11 = {
      { 8, 7, 6, 8 },
      { 7, 6, 5, 7 },
      { 6, 5, 4, 6 },
      { 5, 4, 3, 2 }
    };
    for (int p = 0; p < 4; p++) {
      for (int s = 0; s < 4; s++) {
        int tMel = round(startTimeMs + p * beatDuration + s * sub16);
        agregarNotaNv2(tMel, esc11[p][s], false, 0);
      }
    }
  } else { if (patternType == PATTERN_TEMA_A_12) {
    // MANO IZQUIERDA: Caminata cromática de corcheas en octavas:
    // Pulso 1.0 [0], 1.5 [1], 2.0 [2], 2.5 [0], 3.0 [1+4], 4.0 [0]
    agregarNotaNv2(round(startTimeMs + 0 * beatDuration), 0, false, 0);
    agregarNotaNv2(round(startTimeMs + 0 * beatDuration + 2.0f * sub16), 1, false, 0);
    agregarNotaNv2(round(startTimeMs + 1 * beatDuration), 2, false, 0);
    agregarNotaNv2(round(startTimeMs + 1 * beatDuration + 2.0f * sub16), 0, false, 0);
    agregarNotaNv2(round(startTimeMs + 2 * beatDuration), 1, false, 0);
    agregarNotaNv2(round(startTimeMs + 2 * beatDuration), 4, false, 0);
    agregarNotaNv2(round(startTimeMs + 3 * beatDuration), 0, false, 0);

    // MANO DERECHA:
    // Pulsos 1 y 2 (8 semicorcheas): 6-5-4-3-4-3-2-3
    int[] mel12 = { 6, 5, 4, 3, 4, 3, 2, 3 };
    for (int i = 0; i < 8; i++) {
      int p = i / 4;
      int s = i % 4;
      int tMel = round(startTimeMs + p * beatDuration + s * sub16);
      agregarNotaNv2(tMel, mel12[i], false, 0);
    }
    // Pulso 3.0: Golpe seco de resolución en La4 (Carril 4 'ESP')
    agregarNotaNv2(round(startTimeMs + 2 * beatDuration), 4, false, 0);
    // Pulso 4: Silencio de melodía
  } else { if (patternType == PATTERN_SECCION_B) {
    // BLOQUE 5: SECCIÓN B (Jumps)
    // Pulso 1.0: Salto doble [1+7]. Subdivisión 1.75: [6]
    // Pulso 2.0: Salto doble [2+5]. Contratiempo 2.5: [6]
    // Pulso 3.0: Salto doble [0+8]. Contratiempo 3.5: [7]
    // Pulso 4.0: Salto doble [3+6]. Contratiempo 4.5: [4]
    int tP1 = round(startTimeMs + 0 * beatDuration);
    agregarNotaNv2(tP1, 1, false, 0);
    agregarNotaNv2(tP1, 7, false, 0);
    agregarNotaNv2(round(startTimeMs + 0 * beatDuration + 3.0f * sub16), 6, false, 0);

    int tP2 = round(startTimeMs + 1 * beatDuration);
    agregarNotaNv2(tP2, 2, false, 0);
    agregarNotaNv2(tP2, 5, false, 0);
    agregarNotaNv2(round(startTimeMs + 1 * beatDuration + 2.0f * sub16), 6, false, 0);

    int tP3 = round(startTimeMs + 2 * beatDuration);
    agregarNotaNv2(tP3, 0, false, 0);
    agregarNotaNv2(tP3, 8, false, 0);
    agregarNotaNv2(round(startTimeMs + 2 * beatDuration + 2.0f * sub16), 7, false, 0);

    int tP4 = round(startTimeMs + 3 * beatDuration);
    agregarNotaNv2(tP4, 3, false, 0);
    agregarNotaNv2(tP4, 6, false, 0);
    agregarNotaNv2(round(startTimeMs + 3 * beatDuration + 2.0f * sub16), 4, false, 0);
  } else { if (patternType == PATTERN_OCTAVAS_ACENTUADAS) {
    // BLOQUE 6: COMPASES 29 AL 34
    // Pulsos 1 y 2: Semicorcheas rápidas en 6-5-6-5 con bajo en [0] y [1] y acordes [2+3]
    for (int p = 0; p < 2; p++) {
      int tBajo = round(startTimeMs + p * beatDuration);
      int cBajo = (p == 0) ? 0 : 1;
      agregarNotaNv2(tBajo, cBajo, false, 0);

      int tAcorde = round(startTimeMs + p * beatDuration + 2.0f * sub16);
      agregarNotaNv2(tAcorde, 2, false, 0);
      agregarNotaNv2(tAcorde, 3, false, 0);

      for (int s = 0; s < 4; s++) {
        int tMel = round(startTimeMs + p * beatDuration + s * sub16);
        int cMel = (s % 2 == 0) ? 6 : 5;
        agregarNotaNv2(tMel, cMel, false, 0);
      }
    }
    // Pulsos 3 y 4: 8 semicorcheas de octavas acentuadas alternando [6+8] y [5+7]
    for (int p = 2; p < 4; p++) {
      int tBajo = round(startTimeMs + p * beatDuration);
      int cBajo = (p == 2) ? 0 : 1;
      agregarNotaNv2(tBajo, cBajo, false, 0);

      for (int s = 0; s < 4; s++) {
        int tOct = round(startTimeMs + p * beatDuration + s * sub16);
        if (s % 2 == 0) {
          agregarNotaNv2(tOct, 6, false, 0);
          agregarNotaNv2(tOct, 8, false, 0);
        } else {
          agregarNotaNv2(tOct, 5, false, 0);
          agregarNotaNv2(tOct, 7, false, 0);
        }
      }
    }
  } else { if (patternType == PATTERN_ACORDES_DESCENDENTES) {
    // BLOQUE 6: COMPASES 35 Y 36
    // Escala descendente de acordes densos triples/cuádruples cada semicorchea:
    // [6+7+8] -> [5+6+7] -> [4+5+6] -> [3+4+5] con bajo en [0+1] en cada pulso
    for (int p = 0; p < 4; p++) {
      int tBajo = round(startTimeMs + p * beatDuration);
      agregarNotaNv2(tBajo, 0, false, 0);
      agregarNotaNv2(tBajo, 1, false, 0);

      // Semicorchea 0: [6+7+8]
      int t0 = round(startTimeMs + p * beatDuration + 0.0f * sub16);
      agregarNotaNv2(t0, 6, false, 0);
      agregarNotaNv2(t0, 7, false, 0);
      agregarNotaNv2(t0, 8, false, 0);

      // Semicorchea 1: [5+6+7]
      int t1 = round(startTimeMs + p * beatDuration + 1.0f * sub16);
      agregarNotaNv2(t1, 5, false, 0);
      agregarNotaNv2(t1, 6, false, 0);
      agregarNotaNv2(t1, 7, false, 0);

      // Semicorchea 2: [4+5+6]
      int t2 = round(startTimeMs + p * beatDuration + 2.0f * sub16);
      agregarNotaNv2(t2, 4, false, 0);
      agregarNotaNv2(t2, 5, false, 0);
      agregarNotaNv2(t2, 6, false, 0);

      // Semicorchea 3: [3+4+5]
      int t3 = round(startTimeMs + p * beatDuration + 3.0f * sub16);
      agregarNotaNv2(t3, 3, false, 0);
      agregarNotaNv2(t3, 4, false, 0);
      agregarNotaNv2(t3, 5, false, 0);
    }
  } else { if (patternType == PATTERN_REINICIO_DISONANTE) {
    // BLOQUE 7: [95,500 a 107,200 ms] Reinicio acelerado con disonancias [1+2+3] y [5+6+7]
    for (int p = 0; p < 4; p++) {
      int tBajo = round(startTimeMs + p * beatDuration);
      int cBajo = (p % 2 == 0) ? 0 : 1;
      agregarNotaNv2(tBajo, cBajo, false, 0);
      agregarNotaNv2(tBajo, 1, false, 0);
      agregarNotaNv2(tBajo, 2, false, 0);
      agregarNotaNv2(tBajo, 3, false, 0);

      int tAcorde = round(startTimeMs + p * beatDuration + 2.0f * sub16);
      agregarNotaNv2(tAcorde, 5, false, 0);
      agregarNotaNv2(tAcorde, 6, false, 0);
      agregarNotaNv2(tAcorde, 7, false, 0);
    }
  } else { if (patternType == PATTERN_BLACK_MIDI_CLIMAX) {
    // BLOQUE 7: [107,200 a 126,200 ms] Clímax 180 BPM
    // Barrido cromático 0->8 y 8->0 en cada pulso con acordes fuertes
    for (int p = 0; p < 4; p++) {
      int tPulso = round(startTimeMs + p * beatDuration);
      if (p == 0) {
        agregarNotaNv2(tPulso, 0, false, 0);
        agregarNotaNv2(tPulso, 6, false, 0);
      } else { if (p == 1) {
        agregarNotaNv2(tPulso, 1, false, 0);
        agregarNotaNv2(tPulso, 5, false, 0);
      } else { if (p == 2) {
        agregarNotaNv2(tPulso, 0, false, 0);
        agregarNotaNv2(tPulso, 7, false, 0);
      } else {
        agregarNotaNv2(tPulso, 1, false, 0);
        agregarNotaNv2(tPulso, 6, false, 0);
      } } }

      float stepP = beatDuration / 9.0f;
      if (p % 2 == 0) {
        for (int c = 0; c < 9; c++) {
          int tC = round(startTimeMs + p * beatDuration + c * stepP);
          agregarNotaNv2(tC, c, false, 0);
        }
      } else {
        for (int c = 8; c >= 0; c--) {
          int tC = round(startTimeMs + p * beatDuration + (8 - c) * stepP);
          agregarNotaNv2(tC, c, false, 0);
        }
      }
    }
  } else { if (patternType == PATTERN_MODULACION_CAOS) {
    // BLOQUE 7: [126,200 a 134,000 ms] Modulación (+1 semitono) y Caos Final
    for (int p = 0; p < 4; p++) {
      int t0 = round(startTimeMs + p * beatDuration + 0.0f * sub16);
      agregarNotaNv2(t0, 0, false, 0);
      agregarNotaNv2(t0, 2, false, 0);
      agregarNotaNv2(t0, 6, false, 0);
      agregarNotaNv2(t0, 8, false, 0);

      int t1 = round(startTimeMs + p * beatDuration + 1.0f * sub16);
      agregarNotaNv2(t1, 5, false, 0);
      agregarNotaNv2(t1, 7, false, 0);

      int t2 = round(startTimeMs + p * beatDuration + 2.0f * sub16);
      agregarNotaNv2(t2, 1, false, 0);
      agregarNotaNv2(t2, 3, false, 0);
      agregarNotaNv2(t2, 5, false, 0);
      agregarNotaNv2(t2, 7, false, 0);

      int t3 = round(startTimeMs + p * beatDuration + 3.0f * sub16);
      agregarNotaNv2(t3, 6, false, 0);
      agregarNotaNv2(t3, 8, false, 0);
    }
  } } } } } } } } } } } } }
}

// =========================================================================
// MAPEO OFICIAL SINCRONIZADO: "RUSH E [Qskm9MTz2V4].mp3" (Duración: 158,000 ms / 2:38)
// 9-Key VSRG (Índices 0 al 8):
// [0:'A' Bajo Octava] [1:'S' Bajo Quinta] [2:'D' Acorde Izq] [3:'F' Acorde Der]
// [4:'ESP' Centro/Especial/"E"] [5:'H' Melodía Grave] [6:'J' Melodía Principal Mi5]
// [7:'K' Melodía Aguda] [8:'L' Picos/Octavas]
// =========================================================================
void generarMapaRushESincronizadoNv2() {
  // BLOQUE 0: INTRO DEL CANAL Y SILENCIO [0 ms a 12,300 ms]
  // 5 Notas Sostenidas (Long Notes) dramáticas de Sheet Music Boss (0 a 8,500 ms)
  agregarNotaNv2(0, 0, true, 1800);
  agregarNotaNv2(0, 4, true, 1800);

  agregarNotaNv2(1800, 1, true, 1800);
  agregarNotaNv2(1800, 5, true, 1800);

  agregarNotaNv2(3600, 2, true, 1800);
  agregarNotaNv2(3600, 6, true, 1800);

  agregarNotaNv2(5400, 3, true, 1800);
  agregarNotaNv2(5400, 7, true, 1800);

  agregarNotaNv2(7200, 0, false, 0);
  agregarNotaNv2(7200, 2, false, 0);
  agregarNotaNv2(7200, 4, false, 0);
  agregarNotaNv2(7200, 6, false, 0);
  agregarNotaNv2(7200, 8, false, 0);

  // [8,500 a 12,300 ms]: SILENCIO TOTAL EN EL MP3. Cero notas.

  // BLOQUE 1: COMPASES 1 AL 3 - EL "E" INICIAL [12,300 ms a 21,200 ms]
  // Compases 1 y 2 [12,300 a 18,500 ms]:
  int[] tMi5Inicial = { 12300, 14100, 15400, 16300, 16950, 17450, 17850, 18150, 18400 };
  for (int i = 0; i < 9; i++) {
    agregarNotaNv2(tMi5Inicial[i], 6, false, 0);
  }

  // Compás 3 [18,500 a 21,200 ms]:
  for (int t = 18500; t < 20500; t += 65) {
    int pasoFusa = (t - 18500) / 65;
    int cMel = (pasoFusa % 2 == 0) ? 6 : 5;
    agregarNotaNv2(t, cMel, false, 0);
    if (pasoFusa % 2 == 0) {
      int cBajo = ((pasoFusa / 2) % 2 == 0) ? 0 : 1;
      agregarNotaNv2(t, cBajo, false, 0);
    }
  }

  // Barrido descendente (glissando) de 9 notas consecutivas de 8 a 0
  for (int c = 8; c >= 0; c--) {
    int tGliss = 20500 + round((8 - c) * 75.0f);
    agregarNotaNv2(tGliss, c, false, 0);
  }

  // BLOQUE 2: COMPÁS 4 - INTRO DE BAJO PESADO (♩ = 36, ff) [21,200 ms a 29,100 ms]
  // Pulso 1
  agregarNotaNv2(21200, 0, false, 0);
  agregarNotaNv2(22187, 2, false, 0);
  agregarNotaNv2(22187, 3, false, 0);

  // Pulso 2
  agregarNotaNv2(23175, 1, false, 0);
  agregarNotaNv2(24162, 2, false, 0);
  agregarNotaNv2(24162, 3, false, 0);

  // Pulso 3: Apoyatura rápida Mi-Fa#-Sol# en 1 -> 2 -> 3
  agregarNotaNv2(25150, 1, false, 0);
  agregarNotaNv2(25230, 2, false, 0);
  agregarNotaNv2(25310, 3, false, 0);
  agregarNotaNv2(25400, 0, false, 0);
  agregarNotaNv2(26137, 2, false, 0);
  agregarNotaNv2(26137, 3, false, 0);

  // Pulso 4
  agregarNotaNv2(27125, 1, false, 0);
  agregarNotaNv2(28112, 2, false, 0);
  agregarNotaNv2(28112, 3, false, 0);

  // BLOQUE 3: COMPASES 5 AL 12 - TEMA A EN ACCELERANDO [29,100 ms a 51,000 ms]
  addMeasure(29100, 32500, PATTERN_TEMA_A_5);  // Compás 5 (dur 3400 ms)
  addMeasure(32500, 35600, PATTERN_TEMA_A_6);  // Compás 6 (dur 3100 ms)
  addMeasure(35600, 38400, PATTERN_TEMA_A_7);  // Compás 7 (dur 2800 ms)
  addMeasure(38400, 41000, PATTERN_TEMA_A_8);  // Compás 8 (dur 2600 ms)
  addMeasure(41000, 43500, PATTERN_TEMA_A_5);  // Compás 9 (dur 2500 ms)
  addMeasure(43500, 46000, PATTERN_TEMA_A_10); // Compás 10 (dur 2500 ms)
  addMeasure(46000, 48500, PATTERN_TEMA_A_11); // Compás 11 (dur 2500 ms)
  addMeasure(48500, 51000, PATTERN_TEMA_A_12); // Compás 12 (dur 2500 ms)

  // BLOQUE 4: COMPASES 13 AL 20 - TEMA A RÁPIDO (♩ = 155) [51,000 ms a 71,000 ms]
  addMeasure(51000, 53500, PATTERN_TEMA_A_5);  // Compás 13
  addMeasure(53500, 56000, PATTERN_TEMA_A_6);  // Compás 14
  addMeasure(56000, 58500, PATTERN_TEMA_A_7);  // Compás 15
  addMeasure(58500, 61000, PATTERN_TEMA_A_8);  // Compás 16
  addMeasure(61000, 63500, PATTERN_TEMA_A_5);  // Compás 17
  addMeasure(63500, 66000, PATTERN_TEMA_A_10); // Compás 18
  addMeasure(66000, 68500, PATTERN_TEMA_A_11); // Compás 19
  addMeasure(68500, 71000, PATTERN_TEMA_A_12); // Compás 20

  // BLOQUE 5: COMPASES 21 AL 28 - PUENTE MELÓDICO (SECCIÓN B) [71,000 ms a 83,200 ms]
  for (int m = 0; m < 7; m++) {
    int startM = 71000 + m * 1525;
    int endM = startM + 1525;
    addMeasure(startM, endM, PATTERN_SECCION_B);
  }

  // Compás 28 (81,675 a 83,200 ms - Corte dramático):
  agregarNotaNv2(81675, 0, false, 0);
  agregarNotaNv2(81675, 4, false, 0);
  agregarNotaNv2(81675, 6, false, 0);

  agregarNotaNv2(82250, 1, false, 0);
  agregarNotaNv2(82250, 3, false, 0);
  agregarNotaNv2(82250, 5, false, 0);
  agregarNotaNv2(82250, 7, false, 0);

  agregarNotaNv2(82500, 0, false, 0);
  agregarNotaNv2(82500, 2, false, 0);
  agregarNotaNv2(82500, 6, false, 0);
  agregarNotaNv2(82500, 8, false, 0);

  // BLOQUE 6: COMPASES 29 AL 37 - OCTAVAS ACENTUADAS Y PRIMER GRITO "E!" [83,200 ms a 95,500 ms]
  for (int m = 0; m < 6; m++) {
    int startM = 83200 + m * 1325;
    int endM = startM + 1325;
    addMeasure(startM, endM, PATTERN_OCTAVAS_ACENTUADAS);
  }

  addMeasure(91150, 92475, PATTERN_ACORDES_DESCENDENTES);
  addMeasure(92475, 93800, PATTERN_ACORDES_DESCENDENTES);

  // De 93,800 a 94,200 ms: SILENCIO ABSOLUTO (corte en seco del piano).
  // En 94,200 ms (01:34.200): Grito "E!" - Nota Sostenida masiva en [0, 2, 4, 6, 8] hasta 95,500 ms
  agregarNotaNv2(94200, 0, true, 1300);
  agregarNotaNv2(94200, 2, true, 1300);
  agregarNotaNv2(94200, 4, true, 1300);
  agregarNotaNv2(94200, 6, true, 1300);
  agregarNotaNv2(94200, 8, true, 1300);

  // BLOQUE 7: SEGUNDA MITAD BLACK MIDI Y OUTRO HASTA EL FINAL [95,500 ms a 158,000 ms]
  // [95,500 a 107,200 ms] Reinicio y Aceleración Crítica:
  addMeasure(95500, 98000, PATTERN_REINICIO_DISONANTE);
  addMeasure(98000, 100200, PATTERN_REINICIO_DISONANTE);
  addMeasure(100200, 102000, PATTERN_REINICIO_DISONANTE);
  addMeasure(102000, 103500, PATTERN_REINICIO_DISONANTE);
  addMeasure(103500, 104700, PATTERN_REINICIO_DISONANTE);
  addMeasure(104700, 105700, PATTERN_REINICIO_DISONANTE);
  addMeasure(105700, 106600, PATTERN_REINICIO_DISONANTE);
  addMeasure(106600, 107200, PATTERN_REINICIO_DISONANTE);

  // [107,200 a 126,200 ms] Clímax Black MIDI (180 BPM = compás de 1,333 ms, pulso de 333 ms):
  int tClimax = 107200;
  while (tClimax + 1333 <= 126200) {
    addMeasure(tClimax, tClimax + 1333, PATTERN_BLACK_MIDI_CLIMAX);
    tClimax += 1333;
  }
  if (tClimax < 126200) {
    addMeasure(tClimax, 126200, PATTERN_BLACK_MIDI_CLIMAX);
  }

  // [126,200 a 136,500 ms] Modulación (+1 semitono) y Caos Final:
  int tMod = 126200;
  while (tMod + 1300 <= 134000) {
    addMeasure(tMod, tMod + 1300, PATTERN_MODULACION_CAOS);
    tMod += 1300;
  }

  // 134,000 a 135,200 ms: Cascada descendente final
  for (int iter = 0; iter < 4; iter++) {
    int tBase = 134000 + iter * 300;
    for (int c = 8; c >= 0; c--) {
      int tCasc = tBase + round((8 - c) * 32.0f);
      agregarNotaNv2(tCasc, c, false, 0);
    }
  }

  // 135,200 a 136,000 ms: Silencio breve antes del impacto

  // 136,000 ms (02:16.000): Segundo grito "E!" final. Acorde total de los 9 carriles [0..8]
  for (int c = 0; c < 9; c++) {
    agregarNotaNv2(136000, c, false, 0);
  }

  // [136,500 a 158,000 ms] Cola de Reverberación y Outro del Video (¡MANTENER NIVEL ACTIVO!):
  // 136,500 a 146,200 ms: Reverberación y silencio
  // 146,200 a 154,800 ms: Música del cartel final del video
  int[] melodiaOutro = { 5, 6, 4, 5, 6, 3, 5, 6, 4, 6, 5, 4, 6, 5, 3, 4 };
  float pasoOutroMs = 180.0f;
  int pasoOutro = 0;
  for (float tOut = 146200.0f; tOut <= 154200.0f; tOut += pasoOutroMs) {
    int cMel = melodiaOutro[pasoOutro % 16];
    agregarNotaNv2(round(tOut), cMel, false, 0);
    if (pasoOutro % 4 == 0) {
      int cBajo = ((pasoOutro / 4) % 2 == 0) ? 1 : 2;
      agregarNotaNv2(round(tOut), cBajo, false, 0);
    }
    pasoOutro++;
  }

  // En 154,800 ms (02:34.800): Último golpe en Carril 4 ('ESP') en el último "E" cortado
  agregarNotaNv2(154800, 4, false, 0);

  // De 154,800 a 158,000 ms: Silencio final mientras el MP3 concluye en 158,000 ms (02:38.000)
}


void generarMapaNotasNivel2(int dif) {
  totalNotasNv2 = 0;
  nv2IndicePrimeraNotaActiva = 0;

  // Nivel EXTREMO (dif == 2): Mapeo oficial sincronizado de "Aoi, Koi, Daidaiiro No Hi" (149 BPM, 4/4, Secciones 1-6)
  if (dif == NV2_DIF_EXTREMO) {
    generarMapaAoiKoiSincronizadoNv2(false, 0);
  } else { if (dif == NV2_DIF_INJUGABLE) {
    // Nivel INJUGABLE (dif == 3): Mapeo oficial sincronizado de "RUSH E" (Accelerando 90 -> 186 BPM, 8 secciones)
    generarMapaRushESincronizadoNv2();
  } }

  // Para INTERMEDIO ("appeal_100bpm.mp3") y DIFÍCIL ("Hello-juliet.mp3"), o como respaldo, generar mapa siguiendo la onda real + BPM
  if (totalNotasNv2 < 25) {
    generarMapaNotasDesdeAudioNv2(dif, 0, nv2DuracionTotalActivaMs, false);
  }

  // Respaldo algorítmico al BPM de la canción si el archivo de audio no pudo leerse
  if (totalNotasNv2 < 25) {
    int bpm = nv2BpmPorDif[constrain(dif, 0, TOTAL_DIFICULTADES_NV2 - 1)];
    int beatMs = max(250, round(60000.0f / float(bpm)));
    int inicioMs = 2400;
    int finMs = nv2DuracionTotalActivaMs - 2500;

    int numBeat = 0;
    for (int t = inicioMs; t <= finMs; t += beatMs) {
      if (dif == NV2_DIF_INTERMEDIO) {
        int carril = (numBeat % 2 == 0) ? 0 : 1;
        if (numBeat % 3 == 0) carril = (numBeat / 3) % 2;
        boolean sost = (numBeat % 8 == 4);
        agregarNotaNv2(t, carril, sost, sost ? 520 : 0);
        if (t > 35000 && numBeat % 4 == 2 && !sost) {
          agregarNotaNv2(t + beatMs / 2, 1 - carril, false, 0);
        }
      } else { if (dif == NV2_DIF_DIFICIL) {
        int maxC = (t < 24000) ? 2 : ((t < 52000) ? 3 : 4);
        int carril = (numBeat * 3 + (numBeat / 3)) % maxC;
        boolean sost = (numBeat % 6 == 3);
        agregarNotaNv2(t, carril, sost, sost ? 500 : 0);
        if (!sost && (numBeat % 2 == 1 || t > 45000)) {
          int c2 = (carril + 1 + (numBeat % (maxC - 1))) % maxC;
          agregarNotaNv2(t + beatMs / 2, c2, false, 0);
        }
      } else { if (dif == NV2_DIF_EXTREMO) {
        int maxC = 5;
        int c1 = (numBeat * 2 + (numBeat / 3)) % maxC;
        boolean sost = (numBeat % 7 == 4);
        agregarNotaNv2(t, c1, sost, sost ? 460 : 0);
        if (numBeat % 4 == 0 && !sost) {
          int cSimult = (c1 + 2) % maxC;
          agregarNotaNv2(t, cSimult, false, 0);
        }
        if (!sost) {
          int cCorchea = (c1 + 1 + (numBeat % 3)) % maxC;
          agregarNotaNv2(t + beatMs / 2, cCorchea, false, 0);
        }
      } else {
        int maxC = 9;
        int c1 = (numBeat * 5 + (numBeat / 2)) % maxC;
        boolean sost = (numBeat % 8 == 5);
        agregarNotaNv2(t, c1, sost, sost ? 420 : 0);
        if (numBeat % 2 == 0 && !sost) {
          int cSimult = (c1 + 4) % maxC;
          agregarNotaNv2(t, cSimult, false, 0);
        }
        if (!sost) {
          int pasoSemi = max(90, beatMs / 4);
          for (int s = 1; s <= 3; s++) {
            int cEsc = (c1 + s * 2) % maxC;
            agregarNotaNv2(t + pasoSemi * s, cEsc, false, 0);
          }
        }
      } } }
      numBeat++;
    }
  }
}

// Generación de mapa frenético de notas para la Furia de Mamá (6 carriles con S, D, F, J, K, L)
void generarMapaNotasFaseMamaNv2(int inicioMs, int duracionMs) {
  totalNotasNv2 = 0;
  nv2IndicePrimeraNotaActiva = 0;

  // Continuar el mapeo oficial sincronizado de "Aoi, Koi, Daidaiiro No Hi" (Secciones 7 y 8: Bridge + Outro Cascada Final, 3:00 a 4:30)
  generarMapaAoiKoiSincronizadoNv2(true, inicioMs);

  // Respaldo por análisis de onda PCM si fuese necesario
  if (totalNotasNv2 < 25) {
    generarMapaNotasDesdeAudioNv2(NV2_DIF_EXTREMO, inicioMs, duracionMs, true);
  }

  if (totalNotasNv2 < 25) {
    int beatMs = 280;
    int finMs = inicioMs + duracionMs;
    int maxC = 6;
    int numBeat = 0;

    for (int t = inicioMs + 850; t <= finMs - 1200; t += beatMs) {
      int c1 = (numBeat * 5 + 1) % maxC;
      if (numBeat % 4 == 0) c1 = 0;
      boolean sost = (numBeat % 9 == 4);
      agregarNotaNv2(t, c1, sost, sost ? 240 : 0);
      if (numBeat % 3 == 0 && !sost) {
        int c2 = (c1 == 0) ? (3 + (numBeat % 3)) : ((c1 + 3) % maxC);
        agregarNotaNv2(t, c2, false, 0);
      }
      if (!sost && numBeat % 2 == 1) {
        int cRapida = (c1 + 2) % maxC;
        agregarNotaNv2(t + 140, cRapida, false, 0);
      }
      numBeat++;
    }
  }
}

// =========================================================================
// DISPARADORES DE COMBO LOCO, CHISPAS Y ARRANQUE DE PARTÍCULAS
// =========================================================================
void registrarImpactoComboNv2(float hitX, float hitY, int colCarril, boolean esPerfecto) {
  int ahoraMs = millis();

  // 1. Si se presionan dos notas al mismo tiempo o muy seguidas (<= 240 ms),
  // explotan partículas "arrancándose" entre sí y un rayo de energía conecta ambos carriles
  if (ahoraMs - nv2UltimoHitMs <= 240 && dist(hitX, hitY, nv2UltimoHitX, nv2UltimoHitY) > 20 * escalaX) {
    generarParticulasArranqueNv2(nv2UltimoHitX, nv2UltimoHitY, hitX, hitY, nv2UltimoHitColor, colCarril);
  }
  nv2UltimoHitMs = ahoraMs;
  nv2UltimoHitX = hitX;
  nv2UltimoHitY = hitY;
  nv2UltimoHitColor = colCarril;

  // 2. Onda expansiva y Slash de luz en cruz (4-5 frames) en el receptor
  crearOndaImpactoNv2(hitX, hitY, colCarril);
  crearSlashImpactoNv2(hitX, hitY, colCarril);

  // 3. Mover el texto del COMBO a distintas posiciones dinámicas de la pantalla
  int slotPos = (nv2ComboActual + int(random(1, 5))) % 5;
  if (slotPos == 0) {
    nv2ComboTargetX = width * random(0.16f, 0.28f);
    nv2ComboTargetY = height * random(0.24f, 0.42f);
  } else { if (slotPos == 1) {
    nv2ComboTargetX = width * random(0.72f, 0.84f);
    nv2ComboTargetY = height * random(0.24f, 0.42f);
  } else { if (slotPos == 2) {
    nv2ComboTargetX = width * random(0.20f, 0.34f);
    nv2ComboTargetY = height * random(0.46f, 0.62f);
  } else { if (slotPos == 3) {
    nv2ComboTargetX = width * random(0.66f, 0.80f);
    nv2ComboTargetY = height * random(0.46f, 0.62f);
  } else {
    nv2ComboTargetX = width * random(0.42f, 0.58f);
    nv2ComboTargetY = height * random(0.22f, 0.32f);
  } } } }

  // Física elástica en el contador de COMBO: pop de escala, micro-rotación aleatoria y chispas desde las letras
  nv2ComboAngulo = random(-0.055f, 0.055f);
  nv2ComboTargetAngulo = random(-0.05f, 0.05f);
  nv2ComboEscala = 1.38f + constrain(nv2ComboActual * 0.012f, 0.0f, 0.42f);
  generarChispasComboNv2(nv2ComboPosX, nv2ComboPosY, colCarril);

  // Bass Bump / Zoom Pulse: micro-zoom de cámara en aciertos seguidos / combo
  if (nv2ComboActual >= 2 && (esPerfecto || nv2ComboActual % 2 == 0)) {
    float zoomTarget = (nv2ComboActual >= 20) ? 1.024f : 1.018f;
    nv2ZoomCamara = max(nv2ZoomCamara, zoomTarget);
  }

  // Temblor en hitos de combo para máxima fluidez sin saturar la matriz de cámara cada nota
  if (nv2ComboActual >= 10 && nv2ComboActual % 8 == 0) {
    float shakeCombo = constrain(2.0f + nv2ComboActual * 0.12f, 2.0f, 10.0f);
    activarScreenShake(4, shakeCombo);
  }

  // Llenar la pantalla de textos flotantes de locura en hitos destacados de combo (para no saturar glifos de texto)
  if (nv2ComboActual >= 15 && nv2ComboActual % 15 == 0) {
    crearTextoLocuraNv2();
  }
}

void crearSlashImpactoNv2(float x, float y, int col) {
  for (int i = 0; i < MAX_SLASH_NV2; i++) {
    if (!nv2SlashActivo[i]) {
      nv2SlashActivo[i] = true;
      nv2SlashX[i] = x;
      nv2SlashY[i] = y;
      nv2SlashAngulo[i] = random(0.0f, PI);
      nv2SlashTimer[i] = 5; // Dura 5 frames
      nv2SlashColor[i] = col;
      break;
    }
  }
}

void generarChispasComboNv2(float cx, float cy, int colBase) {
  int creadas = 0;
  for (int i = 0; i < MAX_PARTICULAS_FX; i++) {
    if (!partFxActiva[i]) {
      partFxActiva[i] = true;
      partFxX[i] = cx + random(-60, 60) * escalaX;
      partFxY[i] = cy + random(-16, 16) * escalaY;
      partFxVX[i] = random(-7.0f, 7.0f) * escalaX;
      partFxVY[i] = random(-8.0f, 3.0f) * escalaY;
      partFxTam[i] = random(4.5f, 8.5f) * escalaX;
      partFxAlfa[i] = 235.0f;
      partFxColor[i] = (creadas % 2 == 0) ? color(255, 240, 110) : lerpColor(colBase, color(255), 0.35f);
      creadas++;
      if (creadas >= 2) break;
    }
  }
}

void crearOndaImpactoNv2(float x, float y, int col) {
  boolean creada = false;
  for (int i = 0; i < MAX_ONDAS_NV2 && !creada; i++) {
    if (!nv2OndaActiva[i]) {
      nv2OndaActiva[i] = true;
      nv2OndaX[i] = x;
      nv2OndaY[i] = y;
      nv2OndaRadio[i] = 28 * escalaX;
      nv2OndaAlfa[i] = 240.0f;
      nv2OndaColor[i] = col;
      creada = true;
    }
  }
}

void generarParticulasArranqueNv2(float x1, float y1, float x2, float y2, int col1, int col2) {
  // Registrar rayo de conexión entre las dos notas simultáneas / seguidas
  for (int r = 0; r < MAX_RAYOS_ARRANQUE; r++) {
    if (!nv2RayoActivo[r]) {
      nv2RayoActivo[r] = true;
      nv2RayoX1[r] = x1;
      nv2RayoY1[r] = y1;
      nv2RayoX2[r] = x2;
      nv2RayoY2[r] = y2;
      nv2RayoAlfa[r] = 255.0f;
      nv2RayoColor[r] = lerpColor(col1, col2, 0.5f);
      break;
    }
  }

  // Explotar partículas arrancándose de un carril hacia el otro y chocando en el medio
  int creadas = 0;
  for (int i = 0; i < MAX_PARTICULAS_FX; i++) {
    if (!partFxActiva[i]) {
      partFxActiva[i] = true;
      float t = random(0.1f, 0.9f);
      partFxX[i] = lerp(x1, x2, t) + random(-12, 12) * escalaX;
      partFxY[i] = lerp(y1, y2, t) + random(-14, 14) * escalaY;
      float dir = (creadas % 2 == 0) ? 1.0f : -1.0f;
      partFxVX[i] = ((x2 - x1) * 0.045f * dir + random(-4.5f, 4.5f)) * escalaX;
      partFxVY[i] = random(-9.5f, -2.0f) * escalaY;
      partFxTam[i] = random(7.0f, 13.5f) * escalaX;
      partFxAlfa[i] = 255.0f;
      partFxColor[i] = (creadas % 2 == 0) ? col1 : col2;
      creadas++;
      if (creadas >= 6) break;
    }
  }
}

void generarChispasSostenidaNv2(float cx, float cy, int col) {
  for (int i = 0; i < MAX_PARTICULAS_FX; i++) {
    if (!partFxActiva[i]) {
      partFxActiva[i] = true;
      partFxX[i] = cx + random(-18, 18) * escalaX;
      partFxY[i] = cy + random(-10, 10) * escalaY;
      partFxVX[i] = random(-6.5f, 6.5f) * escalaX;
      partFxVY[i] = random(-10.5f, -3.5f) * escalaY;
      partFxTam[i] = random(5.0f, 10.0f) * escalaX;
      partFxAlfa[i] = 235.0f;
      partFxColor[i] = lerpColor(col, color(255, 255, 180), 0.45f);
      break;
    }
  }
}

void crearTextoLocuraNv2() {
  boolean creado = false;
  for (int i = 0; i < MAX_HYPE_NV2 && !creado; i++) {
    if (!nv2HypeActivo[i]) {
      nv2HypeActivo[i] = true;
      nv2HypeX[i] = random(160 * escalaX, width - 160 * escalaX);
      nv2HypeY[i] = random(150 * escalaY, height - 220 * escalaY);
      nv2HypeVX[i] = random(-2.2f, 2.2f) * escalaX;
      nv2HypeVY[i] = random(-3.0f, -1.2f) * escalaY;
      nv2HypeAng[i] = 0.0f;
      nv2HypeEscala[i] = 1.0f;
      nv2HypeAlfa[i] = 255.0f;
      int idxF = int(random(TOTAL_FRASES_LOCURA));
      nv2HypeTexto[i] = nv2FrasesLocura[idxF];
      int idxC = int(random(MAX_CARRILES_NV2));
      nv2HypeColor[i] = lerpColor(nv2ColoresCarril[idxC], color(255, 245, 120), 0.35f);
      creado = true;
    }
  }
}

void aplicarDanoPlatoNv2(float cantidadDano) {
  nv2VidaPlato = max(0.0f, nv2VidaPlato - cantidadDano);
  nv2FlashDanoTimer = 16;
  activarScreenShake(6, 5.5f);

  if (nv2VidaPlato <= 0.0f && nv2SubEstado == NV2_SUB_JUGANDO) {
    nv2VidaPlato = 0.0f;
    nv2SubEstado = NV2_SUB_DERROTA;
    reaccionClipAlResultado(false);
    reproducirSfx(SFX_NV2_DERROTA, 0.8f);
    detenerYReiniciarTodosLosAudiosNv2();
    activarScreenShake(24, 12.0f);
    generarParticulasCelebracion(width / 2, height / 2, color(255, 65, 50), 20);
    modificarBienestar(-10, width / 2 - 140 * escalaX, height / 2);
    modificarReputacion(-6, width / 2 + 140 * escalaX, height / 2);
  }
}

void procesarInputCarrilNv2(int carril) {
  if (carril >= 0 && carril < nv2NumCarrilesActivos && nv2SubEstado == NV2_SUB_JUGANDO) {
    nv2FlashCarril[carril] = 10;
    nv2KeybeamAlfa[carril] = max(nv2KeybeamAlfa[carril], 115.0f);
    nv2KeybeamEsHit[carril] = false;
    nv2ReceptorEscala[carril] = max(nv2ReceptorEscala[carril], 1.10f);
    if (carril == 0) nv2FlashIzq = 10;
    if (carril == 1) nv2FlashDer = 10;

    int audioTimeMs = obtenerTiempoAudioRealMsNv2();
    int mejorIdx = -1;
    int menorDiff = 999999;

    for (int i = nv2IndicePrimeraNotaActiva; i < totalNotasNv2; i++) {
      if (nv2NotaTiempoMs[i] > audioTimeMs + nv2VentanaBuenoMs + 600) break;
      if (nv2NotaCarril[i] == carril && !nv2NotaImpactada[i] && !nv2NotaFallada[i]) {
        int diff = abs(audioTimeMs - nv2NotaTiempoMs[i]);
        if (diff <= nv2VentanaBuenoMs && diff < menorDiff) {
          menorDiff = diff;
          mejorIdx = i;
        }
      }
    }

    float cx = nv2CarrilBaseX[carril] * escalaX;
    float zonaImpactoY = nv2ZonaImpactoBaseY * escalaY;
    float multDif = nv2MultiplicadorDif[nv2Dificultad];

    if (mejorIdx != -1) {
      nv2NotaImpactada[mejorIdx] = true;
      nv2ComboActual++;
      if (nv2ComboActual > nv2MaxCombo) nv2MaxCombo = nv2ComboActual;

      if (nv2ComboActual == 25) {
        desbloquearLogro(11); // Maestro del Combo
      }

      boolean esPerf = (menorDiff <= nv2VentanaPerfectoMs);
      // Activar Keybeam completo, Latido blanco de la línea de carril y Squash & Stretch 1.35x del receptor
      nv2KeybeamAlfa[carril] = 255.0f;
      nv2KeybeamEsHit[carril] = true;
      nv2LatidoLineaCarril[carril] = 1.0f;
      nv2ReceptorEscala[carril] = esPerf ? 1.35f : 1.24f;
      if (esPerf) {
        nv2ConteoPerfecto++;
        int ptsHit = round((120 + min(nv2ComboActual, 40) * 6) * multDif);
        nv2PuntosObtenidos += ptsHit;
        nv2VidaPlato = min(100.0f, nv2VidaPlato + 2.4f);
        nv2FeedbackVisual = "¡PERFECTO! +" + ptsHit;
        nv2ColorFeedback = color(90, 255, 130);
        generarParticulasCelebracion(cx, zonaImpactoY, nv2ColoresCarril[carril], 4);
        if (nv2ComboActual > 0 && nv2ComboActual % 10 == 0) {
          int bonusRacha = round(15 * multDif);
          ganarPuntosConPopup(bonusRacha, 4, "COMBO x" + nv2ComboActual + "! +" + bonusRacha + " PTS", cx, zonaImpactoY - 60 * escalaY, color(255, 230, 75));
        }
      } else {
        nv2ConteoBueno++;
        int ptsHit = round((65 + min(nv2ComboActual, 30) * 3) * multDif);
        nv2PuntosObtenidos += ptsHit;
        nv2VidaPlato = min(100.0f, nv2VidaPlato + 1.1f);
        nv2FeedbackVisual = "¡BUENO! +" + ptsHit;
        nv2ColorFeedback = color(100, 215, 255);
        generarParticulasCelebracion(cx, zonaImpactoY, color(100, 215, 255), 2);
      }
      nv2FeedbackTimer = 24;

      // Activar animación loca de combo y posible arranque de partículas entre notas
      registrarImpactoComboNv2(cx, zonaImpactoY, nv2ColoresCarril[carril], esPerf);

      if (nv2NotaEsSostenida[mejorIdx]) {
        nv2NotaManteniendo[mejorIdx] = true;
        nv2NotaUltimoTickMs[mejorIdx] = audioTimeMs;
      } else {
        nv2NotaCompletada[mejorIdx] = true;
      }
      // Reproducir opening_chest.ogg al presionar la nota (atenuado al ~50% del volumen previo para no saturar)
      reproducirOpeningChestNv2(0.24f);
    } else {
      // Pulsación en vacío: penalización leve de combo y calidad del plato
      if (audioTimeMs > 2000) {
        nv2ComboActual = 0;
        nv2ComboEscala = 1.0f;
        nv2FeedbackVisual = "¡A DESTIEMPO!";
        nv2ColorFeedback = color(255, 140, 80);
        nv2FeedbackTimer = 16;
        aplicarDanoPlatoNv2(4.5f);
      }
    }
  }
}

// =========================================================================
// BOT AUTO-PLAY (JUEGA AUTOMÁTICAMENTE LOS 4 NIVELES DE MÚSICA AL 100%)
// =========================================================================
void ejecutarBotAutoPlayNv2(int tiempoActualMs) {
  if (nv2AutoPlayBot && nv2SubEstado == NV2_SUB_JUGANDO) {
    if (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseAlerta) {
      for (int c = 0; c < nv2NumCarrilesActivos; c++) {
        nv2TeclaCarrilPresionada[c] = false;
      }
    } else {
      // 1. Mantener presionados únicamente los carriles que tienen una nota sostenida activa
      boolean[] mantenerCarril = new boolean[MAX_CARRILES_NV2];
      for (int i = nv2IndicePrimeraNotaActiva; i < totalNotasNv2; i++) {
        int tIni = nv2NotaTiempoMs[i];
        if (tIni > tiempoActualMs + 120) break;
        if (nv2NotaCompletada[i] || nv2NotaFallada[i]) continue;
        int c = nv2NotaCarril[i];
        if (c < 0 || c >= nv2NumCarrilesActivos) continue;

        if (nv2NotaEsSostenida[i] && nv2NotaManteniendo[i]) {
          int tFin = tIni + nv2NotaDuracionMs[i];
          if (tiempoActualMs < tFin - 65) {
            mantenerCarril[c] = true;
          }
        }
      }

      for (int c = 0; c < nv2NumCarrilesActivos; c++) {
        nv2TeclaCarrilPresionada[c] = mantenerCarril[c];
      }

      // 2. Impactar con precisión PERFECTA cada nota cuando llega a la línea de impacto
      for (int i = nv2IndicePrimeraNotaActiva; i < totalNotasNv2; i++) {
        int tIni = nv2NotaTiempoMs[i];
        if (tIni > tiempoActualMs + 18) break;
        if (nv2NotaImpactada[i] || nv2NotaCompletada[i] || nv2NotaFallada[i]) continue;

        int c = nv2NotaCarril[i];
        if (c >= 0 && c < nv2NumCarrilesActivos && tiempoActualMs >= tIni - 12) {
          nv2TeclaCarrilPresionada[c] = true;
          if (c == 0) nv2TeclaIzqPresionada = true;
          if (c == 1) nv2TeclaDerPresionada = true;
          procesarInputCarrilNv2(c);
        }
      }
    }
  }
}

// =========================================================================
// MOTOR PRINCIPAL DE DIBUJO Y FÍSICA DEL NIVEL 2 (OPTIMIZADO CON PGRAPHICS)
// =========================================================================
void ejecutarMinijuegoNivel2() {
  if (!enPausa && nv2ReiniciarPartida) {
    iniciarPartidaNivel2();
  }

  // Asegurar que el caché estático de escena y los sprites estén listos
  if (pgFondoEstaticoNv2 == null || nv2CacheAncho != width || nv2CacheAlto != height ||
      nv2CacheCarriles != nv2NumCarrilesActivos || nv2CacheDificultad != nv2Dificultad ||
      nv2CacheFaseMama != nv2ExtremoFaseMama) {
    regenerarCachesGraficosNv2();
  }

  // --- C.1 BASS BUMP / ZOOM PULSE DE CÁMARA (Sin escalar pgFondoEstaticoNv2 para mantener Blit nativo a 60 FPS) ---
  if (!enPausa) {
    nv2ZoomCamara = lerp(nv2ZoomCamara, 1.0f, 0.20f);
  }

  // Blit opaco instantáneo de toda la escena base en (0, 0) exacto -> System.arraycopy / Blit nativo de < 0.2 ms
  imageMode(CORNER);
  if (pgFondoEstaticoNv2 != null) {
    image(pgFondoEstaticoNv2, 0, 0);
  }

  if (nv2SubEstado == NV2_SUB_JUGANDO) {
    int audioTimeMs = enPausa ? ((pausaInicioMs - nv2TiempoInicioMs) + nv2OffsetMs) : obtenerTiempoAudioRealMsNv2();
    int duracionTotalMs = nv2DuracionTotalActivaMs;

    // En modo DIFÍCIL (índice 1), expansión progresiva de carriles: 2 -> 3 (a los 22s) -> 4 (a los 50s)
    if (!enPausa && nv2Dificultad == NV2_DIF_DIFICIL) {
      int carrilesDeseados = (audioTimeMs < 22000) ? 2 : ((audioTimeMs < 50000) ? 3 : 4);
      if (carrilesDeseados != nv2NumCarrilesActivos) {
        configurarGeometriaCarrilesNv2(carrilesDeseados);
        crearPopupFlotante("¡NUEVO CARRIL ACTIVO! (" + carrilesDeseados + " CARRILES)", width / 2, 220 * escalaY, color(255, 220, 75));
        activarScreenShake(10, 5.0f);
      }
    }

    // Transición especial de Nivel Extremo: 100% completado -> Alerta de Mamá -> Clímax Furia
    if (!enPausa && nv2Dificultad == NV2_DIF_EXTREMO) {
      if (!nv2ExtremoFaseAlerta && !nv2ExtremoFaseMama && audioTimeMs >= duracionTotalMs) {
        nv2ExtremoFaseAlerta = true;
        nv2ExtremoAlertaInicioMs = millis();
        nv2UltimoSegAlerta = -1;
        // Reproducir sonido de alerta (con respaldo si no existe el archivo individual)
        if (!reproducirSfx(SFX_NV2_ALERTA_MAMA, 0.90f)) {
          if (!reproducirSfx(SFX_ALARMA_CELULAR, 0.85f)) {
            reproducirSfx(SFX_PEN_TIEMPO_AGOTADO, 0.90f);
          }
        }
        totalNotasNv2 = 0; // Se dejan de generar y mostrar notas por unos 6 o 7 segundos
        if (nv2Audio != null && nv2Audio.isPlaying()) {
          nv2Audio.pause();
        }
      }

      if (nv2ExtremoFaseAlerta) {
        int tiempoAlerta = millis() - nv2ExtremoAlertaInicioMs;
        if (tiempoAlerta >= DURACION_ALERTA_MAMA_MS) {
          nv2ExtremoFaseAlerta = false;
          nv2ExtremoFaseMama = true;
          // Impacto sonoro de Mamá llegando (puerta/olla metálica)
          if (!reproducirSfx(SFX_NV2_MAMA_LLEGA, 0.95f)) {
            reproducirSfx(SFX_PEN_PALO, 0.95f);
          }
          nv2ExtremoMamaInicioMs = audioTimeMs;
          nv2ProgresoMamaLerp = 0.0f;
          nv2VelocidadPxPorMs = 0.80f * 1.65f;
          configurarGeometriaCarrilesNv2(6); // ¡Aparece la 6ta tecla S de la nada y regenera caché!
          activarScreenShake(28, 12.0f);
          crearPopupFlotante("¡¡NUEVA TECLA: [S]!!", nv2CarrilBaseX[0] * escalaX, nv2ZonaImpactoBaseY * escalaY - 60 * escalaY, color(255, 60, 60));
          crearOndaImpactoNv2(nv2CarrilBaseX[0] * escalaX, nv2ZonaImpactoBaseY * escalaY, color(255, 60, 60));
          generarParticulasCelebracion(nv2CarrilBaseX[0] * escalaX, nv2ZonaImpactoBaseY * escalaY, color(255, 60, 60), 16);
          generarMapaNotasFaseMamaNv2(nv2ExtremoMamaInicioMs, DURACION_CLIMAX_MAMA_MS);
          // Continuar Aoi.mp3 desde el minuto 3:00 (Secciones 7 y 8: Bridge + Outro Cascada Final)
          try {
            if (nv2Audio != null) {
              float segInicioMama = 180.0f; // Exactamente segundo 3:00 de Aoi.mp3
              nv2Audio.stop();
              nv2Audio.cue(segInicioMama);
              nv2Audio.rate(1.0f);
              nv2Audio.amp(volMaster);
              nv2Audio.jump(segInicioMama);
              if (!nv2Audio.isPlaying()) {
                nv2Audio.play();
              }
            }
          } catch (Exception e) {
            try {
              if (nv2Audio != null) nv2Audio.play();
            } catch (Exception ex) {}
          }
        }
      }

      if (nv2ExtremoFaseMama) {
        int tiempoEnMama = audioTimeMs - nv2ExtremoMamaInicioMs;
        float progresoMama = constrain(tiempoEnMama / float(DURACION_CLIMAX_MAMA_MS), 0.0f, 1.0f);
        nv2ProgresoMamaLerp = lerp(nv2ProgresoMamaLerp, progresoMama, 0.12f);
        if (frameCount % 45 == 0) {
          activarScreenShake(4, 3.5f);
        }
      }

      // En modo EXTREMO ("Aoi, Koi, Daidaiiro No Hi" - 149 BPM), anunciar cada cambio de sección estructural
      if (!nv2ExtremoFaseAlerta) {
        int tCancionAoi = nv2ExtremoFaseMama ? (180000 + (audioTimeMs - nv2ExtremoMamaInicioMs)) : audioTimeMs;
        int secAoi = obtenerSeccionAoiKoiPorTiempoNv2(tCancionAoi);
        if (secAoi != nv2SeccionCancionActual) {
          nv2SeccionCancionActual = secAoi;
          int colSec = (secAoi == 5 || secAoi == 2 || secAoi == 7) ? color(255, 95, 220) : color(115, 235, 255);
          crearPopupFlotante(nv2NombresSeccionAoi[secAoi], width / 2, 195 * escalaY, colSec);
          if (secAoi == 2 || secAoi == 5 || secAoi == 7) {
            activarScreenShake(14, 7.5f);
            crearTextoLocuraNv2();
          }
        }
      }
    }

    // En modo INJUGABLE ("RUSH E - Sheet Music Boss"), anunciar cada cambio de sección estructural y el "E" del 1:34.2
    if (!enPausa && nv2Dificultad == NV2_DIF_INJUGABLE) {
      int secRush = obtenerSeccionRushEPorTiempoNv2(audioTimeMs);
      if (secRush != nv2SeccionCancionActual) {
        nv2SeccionCancionActual = secRush;
        int colSec = (secRush == 6 || secRush == 7 || secRush == 4) ? color(255, 85, 215) : color(115, 240, 255);
        crearPopupFlotante(nv2NombresSeccionRushE[secRush], width / 2, 195 * escalaY, colSec);
        if (secRush == 2 || secRush == 5 || secRush == 6 || secRush == 7) {
          activarScreenShake(14, 7.5f);
          crearTextoLocuraNv2();
        }
      }
    }

    // Si el Bot Auto-Play está activo, juega automáticamente todas las notas del nivel actual
    if (!enPausa && nv2AutoPlayBot) {
      ejecutarBotAutoPlayNv2(audioTimeMs);
    }

    // Barra de progreso superior del HUD calculada dividiendo audioTimeMs entre la duración total real del archivo
    float progreso = (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama)
      ? nv2ProgresoMamaLerp
      : constrain(audioTimeMs / float(duracionTotalMs), 0.0f, 1.0f);
    if (!(nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama)) {
      nv2ProgresoLerp = lerp(nv2ProgresoLerp, progreso, 0.1f);
    }
    nv2VidaPlatoLerp = lerp(nv2VidaPlatoLerp, nv2VidaPlato, 0.15f);

    float receptorY = nv2ZonaImpactoBaseY * escalaY;
    float zonaImpactoY = receptorY;
    float radioNota = (nv2NumCarrilesActivos >= 9 ? 25.0f : (nv2NumCarrilesActivos >= 5 ? 30.0f : 36.0f)) * escalaX;
    float anchoCarril = (nv2NumCarrilesActivos >= 9 ? 102.0f : (nv2NumCarrilesActivos >= 5 ? 112.0f : 138.0f)) * escalaX;

    // --- A.1 & C.3 ESCENARIO VIVO Y HIGHWAY REACTIVO (100% FillRect nativo -> 0 lag) ---
    dibujarEscenarioVivoYHighwayNv2(audioTimeMs, anchoCarril, receptorY);

    // 1. FILTRO PSICODÉLICO REACTIVO AL COMBO Y AL RITMO + VIÑETA DE FUEGO Y PARTÍCULAS ASCENDENTES
    dibujarFiltroPsicodelicoReactivoNv2(audioTimeMs);

    // Avanzar puntero de primera nota activa para no recorrer notas ya completadas o falladas
    while (nv2IndicePrimeraNotaActiva < totalNotasNv2 &&
           (nv2NotaCompletada[nv2IndicePrimeraNotaActiva] || nv2NotaFallada[nv2IndicePrimeraNotaActiva])) {
      nv2IndicePrimeraNotaActiva++;
    }

    if (!enPausa) {
      // Resetear vibraciones de carriles antes de evaluar notas sostenidas activas
      for (int c = 0; c < nv2NumCarrilesActivos; c++) {
        nv2VibracionCarril[c] = lerp(nv2VibracionCarril[c], 0.0f, 0.25f);
      }

      // Pre-chequeo de notas sostenidas que se están manteniendo para hacer vibrar el carril
      for (int i = nv2IndicePrimeraNotaActiva; i < totalNotasNv2; i++) {
        if (nv2NotaTiempoMs[i] > audioTimeMs + 300) break;
        if (nv2NotaEsSostenida[i] && nv2NotaManteniendo[i] && !nv2NotaCompletada[i] && !nv2NotaFallada[i]) {
          int c = nv2NotaCarril[i];
          if (c >= 0 && c < nv2NumCarrilesActivos && nv2TeclaCarrilPresionada[c]) {
            nv2VibracionCarril[c] = random(-7.0f, 7.0f) * escalaX;
            nv2KeybeamAlfa[c] = max(nv2KeybeamAlfa[c], 150.0f);
            nv2LatidoLineaCarril[c] = max(nv2LatidoLineaCarril[c], 0.55f);
          }
        }
      }
    }

    // --- 2. KEYBEAMS (RAYOS DE LUZ EN GRADIENTE), LATIDO DE LÍNEAS DE CARRIL Y SQUASH & STRETCH EN RECEPTORES ---
    // (100% rect() entero FillRect y Blit 3-args sin AffineTransform para 60 FPS clavados)
    rectMode(CORNER);
    noStroke();
    int yHazSup = round(108 * escalaY);
    int altoHazTotal = max(40, round(receptorY - yHazSup));
    int wHaz = max(8, round(anchoCarril - 10 * escalaX));

    for (int c = 0; c < nv2NumCarrilesActivos; c++) {
      float cx = nv2CarrilBaseX[c] * escalaX + nv2VibracionCarril[c];
      int icx = round(cx);
      int colC = nv2ColoresCarril[c];
      int rC = (colC >> 16) & 0xFF;
      int gC = (colC >> 8) & 0xFF;
      int bC = colC & 0xFF;

      if (!enPausa) {
        if (nv2FlashCarril[c] > 0) nv2FlashCarril[c]--;
        if (nv2TeclaCarrilPresionada[c]) {
          nv2KeybeamAlfa[c] = max(nv2KeybeamAlfa[c], 110.0f);
        }
      }

      // A.2 Keybeam vertical semitransparente en 3 bandas de gradiente (FillRect nativo ultrarrápido)
      if (nv2KeybeamAlfa[c] > 3.0f) {
        float kbAlfa = nv2KeybeamAlfa[c];
        int hTercio = altoHazTotal / 3;
        float multHit = nv2KeybeamEsHit[c] ? 0.42f : 0.22f;

        // Tramo superior (tenue y angosto)
        int wSup = max(4, round(wHaz * 0.56f));
        fill(rC, gC, bC, round(kbAlfa * multHit * 0.25f));
        rect(icx - (wSup >> 1), yHazSup, wSup, hTercio);

        // Tramo medio
        int wMed = max(6, round(wHaz * 0.78f));
        fill(rC, gC, bC, round(kbAlfa * multHit * 0.58f));
        rect(icx - (wMed >> 1), yHazSup + hTercio, wMed, hTercio);

        // Tramo inferior junto al receptor (intenso y ancho completo)
        int yInfHaz = yHazSup + hTercio * 2;
        int hInfHaz = altoHazTotal - hTercio * 2;
        fill(rC, gC, bC, round(kbAlfa * multHit));
        rect(icx - (wHaz >> 1), yInfHaz, wHaz, hInfHaz);

        if (nv2KeybeamEsHit[c]) {
          int wCore = max(2, round(wHaz * 0.28f));
          fill(255, 255, 255, round(kbAlfa * 0.34f));
          rect(icx - (wCore >> 1), yHazSup + hTercio, wCore, altoHazTotal - hTercio);
        }

        if (!enPausa) {
          nv2KeybeamAlfa[c] = lerp(nv2KeybeamAlfa[c], 0.0f, nv2KeybeamEsHit[c] ? 0.20f : 0.28f);
          if (nv2KeybeamAlfa[c] < 4.0f) {
            nv2KeybeamAlfa[c] = 0.0f;
            nv2KeybeamEsHit[c] = false;
          }
        }
      }

      // A.3 Latido en la línea vertical del carril usando FillRect entero (30x más rápido que strokeWeight + line)
      if (nv2LatidoLineaCarril[c] > 0.03f) {
        float lat = nv2LatidoLineaCarril[c];
        int wHaloL = max(4, round((4.0f + 10.0f * lat) * escalaX));
        int wCoreL = max(2, round((2.0f + 4.5f * lat) * escalaX));
        fill(rC, gC, bC, round(195 * lat));
        rect(icx - (wHaloL >> 1), yHazSup, wHaloL, altoHazTotal);
        fill(255, 255, 255, round(245 * lat));
        rect(icx - (wCoreL >> 1), yHazSup, wCoreL, altoHazTotal);

        if (!enPausa) {
          nv2LatidoLineaCarril[c] = lerp(nv2LatidoLineaCarril[c], 0.0f, 0.24f);
          if (nv2LatidoLineaCarril[c] < 0.035f) nv2LatidoLineaCarril[c] = 0.0f;
        }
      }

      // B.1 Squash & Stretch en receptores usando PGraphics pre-escalado a 1.35x (0 costo de reescalado en CPU)
      if (!enPausa) {
        nv2ReceptorEscala[c] = lerp(nv2ReceptorEscala[c], 1.0f, 0.24f);
        if (abs(nv2ReceptorEscala[c] - 1.0f) < 0.01f) nv2ReceptorEscala[c] = 1.0f;
      }

      if (nv2FlashCarril[c] > 0 || nv2TeclaCarrilPresionada[c] || nv2ReceptorEscala[c] > 1.015f) {
        PGraphics pgRec = (nv2ReceptorEscala[c] >= 1.15f && pgReceptorPopCacheNv2[c] != null)
          ? pgReceptorPopCacheNv2[c]
          : pgReceptorActivoCacheNv2[c];
        if (pgRec != null) {
          image(pgRec, icx - (pgRec.width >> 1), round(receptorY) - (pgRec.height >> 1));
        }
      }
    }

    // --- 3. Actualizar y Dibujar Notas (con Estelas/Trails fantasma ultrarrápidas y chispas en caída) ---
    float scrollSpeed = nv2VelocidadPxPorMs * escalaY;
    float danoPorMiss = (nv2Dificultad == NV2_DIF_INJUGABLE) ? 11.5f : ((nv2Dificultad == NV2_DIF_EXTREMO) ? 13.5f : 15.0f);
    boolean velocidadX2Activa = (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama) ||
                                (nv2VelocidadPxPorMs >= 1.0f) || (nv2ComboActual >= 18);
    boolean chispaEstelaEsteFrame = false;

    for (int i = nv2IndicePrimeraNotaActiva; i < totalNotasNv2; i++) {
      if (nv2NotaCompletada[i] || nv2NotaFallada[i]) continue;

      int notaHitTimeMs = nv2NotaTiempoMs[i];
      // Cortar búsqueda apenas las notas futuras aún no están en pantalla
      if (notaHitTimeMs > audioTimeMs + 2200) break;

      int c = nv2NotaCarril[i];
      if (c >= nv2NumCarrilesActivos) continue;

      int tFin = notaHitTimeMs + nv2NotaDuracionMs[i];

      // Verificar si la nota ya pasó sin ser impactada (MISS -> Baja barra de vida del plato)
      if (!enPausa && !nv2NotaImpactada[i] && audioTimeMs > notaHitTimeMs + nv2VentanaBuenoMs) {
        nv2NotaFallada[i] = true;
        nv2ConteoFallo++;
        nv2ComboActual = 0;
        nv2ComboEscala = 1.0f;
        nv2FeedbackVisual = "¡SE QUEMA! (MISS)";
        nv2ColorFeedback = color(255, 75, 75);
        nv2FeedbackTimer = 22;
        crearPopupFlotante("MISS - Se quema", nv2CarrilBaseX[c] * escalaX, receptorY - 30 * escalaY, color(255, 80, 80));
        aplicarDanoPlatoNv2(danoPorMiss);
        continue;
      }

      // Manejo de notas sostenidas que están siendo mantenidas: vibración + chispas continuas
      if (!enPausa && nv2NotaEsSostenida[i] && nv2NotaManteniendo[i]) {
        float cx = nv2CarrilBaseX[c] * escalaX + nv2VibracionCarril[c];
        if (nv2TeclaCarrilPresionada[c]) {
          if (frameCount % 6 == 0) {
            generarChispasSostenidaNv2(cx, receptorY, nv2ColoresCarril[c]);
          }
          if (audioTimeMs - nv2NotaUltimoTickMs[i] >= 120) {
            nv2NotaUltimoTickMs[i] = audioTimeMs;
            int ptsTick = round(25 * nv2MultiplicadorDif[nv2Dificultad]);
            nv2PuntosObtenidos += ptsTick;
            nv2VidaPlato = min(100.0f, nv2VidaPlato + 0.65f);
          }
          if (audioTimeMs >= tFin - 80) {
            nv2NotaManteniendo[i] = false;
            nv2NotaCompletada[i] = true;
            int ptsFin = round(80 * nv2MultiplicadorDif[nv2Dificultad]);
            nv2PuntosObtenidos += ptsFin;
            nv2VidaPlato = min(100.0f, nv2VidaPlato + 1.8f);
            crearPopupFlotante("¡SOSTENIDA! +" + ptsFin, cx, receptorY - 45 * escalaY, nv2ColoresCarril[c]);
            crearOndaImpactoNv2(cx, receptorY, nv2ColoresCarril[c]);
            crearSlashImpactoNv2(cx, receptorY, nv2ColoresCarril[c]);
            continue;
          }
        } else {
          // Al soltar la nota sostenida no se reinicia el combo para permitir presionar la siguiente nota
          nv2NotaManteniendo[i] = false;
          nv2NotaCompletada[i] = true;
          if (audioTimeMs >= notaHitTimeMs + nv2NotaDuracionMs[i] * 0.45f) {
            int ptsFin = round(55 * nv2MultiplicadorDif[nv2Dificultad]);
            nv2PuntosObtenidos += ptsFin;
            nv2VidaPlato = min(100.0f, nv2VidaPlato + 1.2f);
            crearPopupFlotante("¡SOSTENIDA! +" + ptsFin, cx, receptorY - 45 * escalaY, nv2ColoresCarril[c]);
          }
          continue;
        }
      }

      // Fórmula obligatoria de posición Y en pantalla: y = receptorY - (notaHitTimeMs - audioTimeMs) * scrollSpeed
      float y = receptorY - (notaHitTimeMs - audioTimeMs) * scrollSpeed;
      float yCabeza = y;
      float yCola = nv2NotaEsSostenida[i] ? (receptorY - (tFin - audioTimeMs) * scrollSpeed) : yCabeza;

      if (yCabeza < -60 * escalaY && yCola < -60 * escalaY) continue;
      if (yCola > height + 60 * escalaY) continue;

      float cx = nv2CarrilBaseX[c] * escalaX + nv2VibracionCarril[c];
      int col = nv2ColoresCarril[c];
      int rCol = (col >> 16) & 0xFF;
      int gCol = (col >> 8) & 0xFF;
      int bCol = col & 0xFF;

      // Cola de nota sostenida con rect directo sin bordes redondeados (FillRect rápido)
      if (nv2NotaEsSostenida[i]) {
        float yInf = nv2NotaManteniendo[i] ? receptorY : yCabeza;
        float ySup = max(108 * escalaY, yCola);
        if (yInf > ySup) {
          noStroke();
          float wCola = radioNota * (nv2NotaManteniendo[i] ? 0.86f : 0.66f);
          int xCola = round(cx - wCola);
          int yColaInt = round(ySup);
          int wColaInt = max(4, round(wCola * 2.0f));
          int hColaInt = max(2, round(yInf - ySup));
          fill(rCol, gCol, bCol, nv2NotaManteniendo[i] ? 230 : 155);
          rect(xCola, yColaInt, wColaInt, hColaInt);

          float wNuc = wCola * 0.42f;
          fill(255, 250, 210, nv2NotaManteniendo[i] ? 215 : 130);
          rect(round(cx - wNuc), yColaInt + 2, max(2, round(wNuc * 2.0f)), max(1, hColaInt - 4));
        }
      }

      // B.2 Estelas (Trails) fantasma detrás de las notas en caída usando FillRect entero (50x más rápido que ellipse)
      if (!nv2NotaImpactada[i] || nv2NotaManteniendo[i]) {
        float yDib = nv2NotaManteniendo[i] ? receptorY : yCabeza;
        if (yDib >= 104 * escalaY && yDib <= height + 36 * escalaY) {
          if (!nv2NotaImpactada[i] && yDib > 138 * escalaY) {
            noStroke();
            int icxN = round(cx);
            int iyN = round(yDib);
            int wTrail1 = max(6, round(radioNota * 1.15f));
            int hTrail1 = max(8, round((velocidadX2Activa ? 24.0f : 16.0f) * escalaY));
            fill(rCol, gCol, bCol, velocidadX2Activa ? 92 : 62);
            rect(icxN - (wTrail1 >> 1), iyN - round(radioNota * 0.6f) - hTrail1, wTrail1, hTrail1);

            int wTrail2 = max(4, round(radioNota * 0.68f));
            int hTrail2 = max(8, round((velocidadX2Activa ? 22.0f : 14.0f) * escalaY));
            fill(rCol, gCol, bCol, velocidadX2Activa ? 52 : 34);
            rect(icxN - (wTrail2 >> 1), iyN - round(radioNota * 0.6f) - hTrail1 - hTrail2, wTrail2, hTrail2);

            // Máximo 1 chispa desprendida cada 5 frames en total para no saturar el pool de partículas
            if (!enPausa && !chispaEstelaEsteFrame && (frameCount % (velocidadX2Activa ? 4 : 8) == 0) && yDib < receptorY - 30 * escalaY) {
              generarChispaEstelaNotaNv2(cx, yDib - radioNota * 0.5f, col, velocidadX2Activa);
              chispaEstelaEsteFrame = true;
            }
          }

          // Cabeza estilizada de la nota (Blit directo desde pgNotaCacheNv2[c])
          PGraphics pgN = pgNotaCacheNv2[c];
          if (pgN != null) {
            image(pgN, round(cx) - (pgN.width >> 1), round(yDib) - (pgN.height >> 1));
          }
        }
      }
    }

    // --- 4. Dibujar Slashes en Cruz, Rayos de Arranque, Ondas de Choque y Combo Elástico ---
    dibujarEfectosCombosYOndasNv2();

    // Si estamos en la pausa de 6-7 segundos de alerta de Mamá, dibujar el cartel dramático de peligro
    if (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseAlerta) {
      dibujarAlertaMamaNv2((enPausa ? pausaInicioMs : millis()) - nv2ExtremoAlertaInicioMs);
    }

    // --- 5. Elementos Dinámicos del HUD Superior (con Barra de Progreso Sobrecargada) ---
    dibujarHUDNivel2(audioTimeMs, duracionTotalMs);
    if (!enPausa && !nv2ExtremoFaseAlerta && nv2SubEstado == NV2_SUB_JUGANDO) {
      dibujarClipBailando(audioTimeMs, periodoVisualBeatNv2());
    }

    // =========================================================================
    // VERIFICAR FIN DE LA CANCIÓN:
    // REGLA ABSOLUTA: ¡EL NIVEL NUNCA TERMINA MIENTRAS LA CANCIÓN SIGA REPRODUCIÉNDOSE!
    // =========================================================================
    boolean audioTermino = false;
    boolean audioEstaSonando = (nv2Audio != null && nv2Audio.isPlaying());

    if (nv2Dificultad == NV2_DIF_EXTREMO) {
      if (nv2ExtremoFaseMama) {
        int tiempoEnMama = audioTimeMs - nv2ExtremoMamaInicioMs;
        if (audioEstaSonando) {
          audioTermino = false;
        } else {
          if (tiempoEnMama >= (DURACION_CLIMAX_MAMA_MS - 2500)) {
            audioTermino = true;
          } else { if (nv2Audio == null && tiempoEnMama >= DURACION_CLIMAX_MAMA_MS) {
            audioTermino = true;
          } }
        }
      }
    } else {
      if (audioEstaSonando) {
        audioTermino = false;
      } else {
        if (audioTimeMs > 4000 && audioTimeMs >= (duracionTotalMs - 1500)) {
          audioTermino = true;
        } else { if (nv2Audio == null && audioTimeMs >= duracionTotalMs) {
          audioTermino = true;
        } }
      }
    }

    if (!enPausa && !enTransicion && audioTermino) {
      finalizarPartidaNivel2();
    }
  } else { if (nv2SubEstado == NV2_SUB_DERROTA) {
    dibujarPantallaDerrotaNv2();
  } else {
    dibujarResultadosNivel2();
  } }
}

void generarChispaEstelaNotaNv2(float cx, float cy, int col, boolean modoRapido) {
  for (int i = 0; i < MAX_PARTICULAS_FX; i++) {
    if (!partFxActiva[i]) {
      partFxActiva[i] = true;
      partFxX[i] = cx + random(-14, 14) * escalaX;
      partFxY[i] = cy + random(-6, 6) * escalaY;
      partFxVX[i] = random(-1.8f, 1.8f) * escalaX;
      partFxVY[i] = random(-3.2f, -0.8f) * escalaY;
      partFxTam[i] = random(modoRapido ? 4.2f : 3.2f, modoRapido ? 7.8f : 5.8f) * escalaX;
      partFxAlfa[i] = modoRapido ? 195.0f : 145.0f;
      partFxColor[i] = lerpColor(col, color(255, 250, 200), 0.38f);
      break;
    }
  }
}

// =========================================================================
// A.1 & C.3 HIGHWAY REACTIVO Y ESCENARIO VIVO ULTRARRÁPIDO (100% FillRect -> 60 FPS)
// =========================================================================
int periodoVisualBeatNv2() {
  int bpmAct = (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama)
    ? nv2BpmFaseMama
    : nv2BpmPorDif[constrain(nv2Dificultad, 0, TOTAL_DIFICULTADES_NV2 - 1)];
  int periodoBeat = max(200, round(60000.0f / float(max(60, bpmAct))));
  if (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama) periodoBeat = max(170, periodoBeat / 2);
  return periodoBeat;
}

void dibujarEscenarioVivoYHighwayNv2(int tiempoActualMs, float anchoCarril, float receptorY) {
  int periodoBeat = periodoVisualBeatNv2();
  float faseBeat = (tiempoActualMs % periodoBeat) / float(periodoBeat);
  float pulsoBeat = (1.0f - faseBeat) * (1.0f - faseBeat);

  boolean modoFuegoMaximo = (nv2ComboActual >= 20) || (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama);
  boolean modoDios = (nv2ComboActual >= 40) || (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama);
  float factorRacha = constrain(nv2ComboActual / 35.0f, 0.0f, 1.0f);
  if (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama) factorRacha = 1.0f;

  // C.1 Pulso de cámara / Bass Bump aplicado matemáticamente a las coordenadas del Highway y Escenario (0 costo de reescalado)
  float zoomDelta = (nv2ZoomCamara - 1.0f) * 380.0f * escalaX;

  int yTop = round(104 * escalaY);
  float hwLeft = (nv2CarrilBaseX[0] * escalaX) - anchoCarril * 0.54f - zoomDelta;
  float hwRight = (nv2CarrilBaseX[max(0, nv2NumCarrilesActivos - 1)] * escalaX) + anchoCarril * 0.54f + zoomDelta;
  int iHwLeft = round(hwLeft);
  int iHwRight = round(hwRight);
  int iHwWidth = max(120, iHwRight - iHwLeft);
  int iHwHeight = max(120, round(receptorY + 24 * escalaY) - yTop);

  rectMode(CORNER);
  noStroke();

  // --- C.3 FONDO VIVO: Columnas de iluminación de concierto en el escenario (FillRect nativo) ---
  if (nv2ComboActual >= 4 || modoFuegoMaximo) {
    int numFocos = modoFuegoMaximo ? 3 : 2;
    int wHazConcierto = max(8, round((18.0f + 14.0f * pulsoBeat) * escalaX));
    for (int f = 0; f < numFocos; f++) {
      float ondaF = sin(frameCount * (modoFuegoMaximo ? 0.06f : 0.035f) + f * 1.5f);
      int xFocoIzq = max(16, round(iHwLeft * 0.45f + ondaF * 48 * escalaX - f * 28 * escalaX));
      int xFocoDer = min(width - 24, round(iHwRight + (width - iHwRight) * 0.55f - ondaF * 48 * escalaX + f * 28 * escalaX));

      int colFoco = modoDios
        ? color(255, 200, 55)
        : (modoFuegoMaximo ? color(255, 110, 40) : nv2ColoresCarril[(f * 2) % max(1, nv2NumCarrilesActivos)]);
      int alfaF = round((26.0f + 36.0f * factorRacha) * (0.5f + 0.5f * pulsoBeat));
      fill((colFoco >> 16) & 0xFF, (colFoco >> 8) & 0xFF, colFoco & 0xFF, alfaF);
      rect(xFocoIzq, yTop, wHazConcierto, height - yTop);
      rect(xFocoDer, yTop, wHazConcierto, height - yTop);
    }
  }

  // --- A.1 CONTENEDOR REACTIVO / SHADER PROCEDURAL DETRÁS DE LOS CARRILES (100% FillRect) ---
  // Rieles laterales luminosos del contenedor Highway (laten con el Bass Bump y el modo Fuego/Dios)
  int colRiel = modoDios
    ? color(255, 215, 60)
    : (modoFuegoMaximo ? color(255, 95, 40) : color(85, 200, 255));
  int rRiel = (colRiel >> 16) & 0xFF;
  int gRiel = (colRiel >> 8) & 0xFF;
  int bRiel = colRiel & 0xFF;
  int wRiel = max(4, round((5.0f + 7.0f * factorRacha + (nv2ZoomCamara - 1.0f) * 180.0f) * escalaX));
  int alfaRiel = round(90 + 115 * factorRacha + 40 * pulsoBeat);
  fill(rRiel, gRiel, bRiel, alfaRiel);
  rect(iHwLeft - wRiel, yTop, wRiel, iHwHeight);
  rect(iHwRight, yTop, wRiel, iHwHeight);

  // 1. Cuadrícula horizontal en movimiento sincronizada con la velocidad y la racha (FillRect de 2-3 px)
  float velScrollGrid = (2.8f + factorRacha * 4.5f + (modoFuegoMaximo ? 3.4f : 0.0f)) * escalaY;
  float pasoGridY = 56.0f * escalaY;
  nv2ScrollHighwayOffset = (nv2ScrollHighwayOffset + velScrollGrid) % pasoGridY;
  int hLineaGrid = max(2, round((modoFuegoMaximo ? 3.0f : 2.0f) * escalaY));

  for (float gy = yTop + nv2ScrollHighwayOffset; gy < receptorY + 18 * escalaY; gy += pasoGridY) {
    float progY = constrain((gy - yTop) / float(iHwHeight), 0.0f, 1.0f);
    int alfaLinea = round((26.0f + 68.0f * factorRacha + 32.0f * pulsoBeat) * progY);
    fill(rRiel, gRiel, bRiel, alfaLinea);
    rect(iHwLeft + 4, round(gy), iHwWidth - 8, hLineaGrid);
  }

  // 2. Barras ecualizadoras reactivas al ritmo/combo en la base de cada carril dentro del Highway
  int pasosEq = 5;
  int wBarra = max(8, round(anchoCarril * 0.66f));
  int hBarra = max(4, round(13.0f * escalaY));
  int sepBarra = max(8, round(20.0f * escalaY));

  for (int c = 0; c < nv2NumCarrilesActivos; c++) {
    int icx = round(nv2CarrilBaseX[c] * escalaX);
    int colC = modoDios
      ? lerpColor(nv2ColoresCarril[c], color(255, 215, 60), 0.45f)
      : nv2ColoresCarril[c];
    int rC = (colC >> 16) & 0xFF;
    int gC = (colC >> 8) & 0xFF;
    int bC = colC & 0xFF;

    float ondaCarril = 0.5f + 0.5f * sin(frameCount * (modoFuegoMaximo ? 0.24f : 0.14f) + c * 1.15f);
    float boostHit = nv2LatidoLineaCarril[c] * 0.65f + (nv2TeclaCarrilPresionada[c] ? 0.25f : 0.0f);
    float nivelColumna = constrain((0.18f + 0.48f * factorRacha) * ondaCarril + 0.34f * pulsoBeat + boostHit, 0.10f, 1.0f);

    int barrasActivas = max(1, round(nivelColumna * pasosEq));
    for (int b = 0; b < barrasActivas; b++) {
      int by = round(receptorY - 18 * escalaY) - b * sepBarra;
      int alfaB = round((34.0f + 60.0f * factorRacha) * (1.0f - b / float(pasosEq + 1)));
      fill(rC, gC, bC, alfaB);
      rect(icx - (wBarra >> 1), by, wBarra, hBarra);
    }
  }

  // 3. Nodos de onda sinusoidal de energía recorriendo el Highway (FillRect sin BasicStroke)
  float pasoOndaY = 44.0f * escalaY;
  float velOnda = frameCount * (modoFuegoMaximo ? 0.20f : 0.11f);
  float centroHwX = (hwLeft + hwRight) * 0.5f;
  float ampOndaX = iHwWidth * (0.30f + 0.14f * factorRacha);
  int wNodoOnda = max(6, round((10.0f + 8.0f * factorRacha) * escalaX));
  int hNodoOnda = max(4, round(8.0f * escalaY));

  fill(rRiel, gRiel, bRiel, round(95 + 75 * factorRacha));
  for (float wy = yTop + 16 * escalaY; wy < receptorY - 10 * escalaY; wy += pasoOndaY) {
    int iwy = round(wy);
    float sVal = sin(wy * 0.018f - velOnda);
    int wx1 = round(centroHwX + sVal * ampOndaX);
    rect(wx1 - (wNodoOnda >> 1), iwy, wNodoOnda, hNodoOnda);
    if (modoFuegoMaximo) {
      int wx2 = round(centroHwX - sVal * ampOndaX);
      rect(wx2 - (wNodoOnda >> 1), iwy, wNodoOnda, hNodoOnda);
    }
  }
}

// =========================================================================
// FILTRO PSICODÉLICO REACTIVO + C.2 VIÑETA / BORDES DE FUEGO Y PARTÍCULAS (100% FillRect)
// =========================================================================
void dibujarFiltroPsicodelicoReactivoNv2(int tiempoActualMs) {
  int bpmAct = (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama)
    ? nv2BpmFaseMama
    : nv2BpmPorDif[constrain(nv2Dificultad, 0, TOTAL_DIFICULTADES_NV2 - 1)];
  int periodoBeat = max(220, round(60000.0f / float(max(60, bpmAct))));
  if (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama) periodoBeat = max(180, periodoBeat / 2);
  float faseBeat = (tiempoActualMs % periodoBeat) / float(periodoBeat);
  float pulsoBeat = (1.0f - faseBeat) * (1.0f - faseBeat);

  rectMode(CORNER);
  noStroke();
  int yTop = round(104 * escalaY);
  int hUtil = height - yTop;

  boolean modoFuegoMaximo = (nv2ComboActual >= 20) || (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama);
  boolean modoDios = (nv2ComboActual >= 40);

  if (nv2ComboActual >= 4) {
    float nivelLocura = constrain(map(nv2ComboActual, 4, 45, 0.15f, 1.0f), 0.15f, 1.0f);
    float tColor = frameCount * (0.05f + nivelLocura * 0.08f);

    int rPsi = modoFuegoMaximo ? 255 : round(128 + 127 * sin(tColor));
    int gPsi = modoFuegoMaximo ? round(135 + 95 * sin(tColor * 1.4f)) : round(128 + 127 * sin(tColor + 2.094f));
    int bPsi = modoDios ? round(80 + 140 * sin(tColor * 2.0f)) : (modoFuegoMaximo ? 35 : round(128 + 127 * sin(tColor + 4.188f)));

    // Franjas perimetrales de neón que laten con el beat y el Bass Bump
    int boostZoom = round((nv2ZoomCamara - 1.0f) * 260.0f * escalaX);
    int grosorBorde = max(4, round((10.0f + pulsoBeat * 20.0f * nivelLocura) * escalaX) + boostZoom);
    int alfaBorde = round((75 + 135 * nivelLocura) * (0.45f + 0.55f * pulsoBeat));
    fill(rPsi, gPsi, bPsi, alfaBorde);
    rect(0, yTop, width, grosorBorde);
    rect(0, height - grosorBorde, width, grosorBorde);
    rect(0, yTop + grosorBorde, grosorBorde, hUtil - grosorBorde * 2);
    rect(width - grosorBorde, yTop + grosorBorde, grosorBorde, hUtil - grosorBorde * 2);

    // --- C.2 VIÑETA INTERNA LUMINOSA DE FUEGO REACTIVO (2 capas FillRect ultrarrápidas) ---
    if (nv2ComboActual >= 15 || modoFuegoMaximo) {
      for (int cv = 1; cv <= 2; cv++) {
        int pad = grosorBorde + (cv - 1) * round(12 * escalaX);
        int gCapa = round(12 * escalaX);
        int alfaV = round((52.0f / cv) * (0.55f + 0.45f * pulsoBeat) * nivelLocura);
        fill(255, modoDios ? 205 : 110, 30, alfaV);
        rect(pad, yTop + pad, width - pad * 2, gCapa);
        rect(pad, height - pad - gCapa, width - pad * 2, gCapa);
        rect(pad, yTop + pad + gCapa, gCapa, hUtil - (pad + gCapa) * 2);
        rect(width - pad - gCapa, yTop + pad + gCapa, gCapa, hUtil - (pad + gCapa) * 2);
      }
    }

    // Barras ecualizadoras psicodélicas en los márgenes izquierdo y derecho en combos >= 8
    if (nv2ComboActual >= 8) {
      int numBarrasEq = 7;
      int altoBarraEq = max(8, round(44 * escalaY));
      int sepEq = round(88 * escalaY);
      for (int k = 0; k < numBarrasEq; k++) {
        float ondaEq = 0.5f + 0.5f * sin(frameCount * 0.22f + k * 0.9f);
        int wEq = max(6, round((24.0f + 95.0f * nivelLocura * ondaEq * (0.5f + 0.5f * pulsoBeat)) * escalaX));
        int yEq = yTop + round(45 * escalaY) + k * sepEq;
        fill((rPsi + k * 28) & 255, (gPsi + k * 45) & 255, (bPsi + k * 60) & 255, round(95 * nivelLocura));
        rect(grosorBorde, yEq, wEq, altoBarraEq);
        rect(width - grosorBorde - wEq, yEq, wEq, altoBarraEq);
      }
    }
  }

  // --- C.2 PARTÍCULAS ASCENDENTES DE FUEGO QUE PARPADEAN AL RITMO (Usando FillRect entero) ---
  if ((nv2ComboActual >= 12 || modoFuegoMaximo) && frameCount % (modoFuegoMaximo ? 3 : 6) == 0) {
    for (int f = 0; f < MAX_PART_FUEGO_NV2; f++) {
      if (!nv2FuegoActivo[f]) {
        nv2FuegoActivo[f] = true;
        if (random(1.0f) < 0.65f) {
          nv2FuegoX[f] = random(18 * escalaX, width - 18 * escalaX);
          nv2FuegoY[f] = height - random(4, 24) * escalaY;
        } else {
          boolean izq = random(1.0f) < 0.5f;
          nv2FuegoX[f] = izq ? random(8, 120) * escalaX : (width - random(8, 120) * escalaX);
          nv2FuegoY[f] = random(height * 0.45f, height - 10 * escalaY);
        }
        nv2FuegoVX[f] = random(-1.4f, 1.4f) * escalaX;
        nv2FuegoVY[f] = random(-6.5f, -2.8f) * escalaY;
        nv2FuegoTam[f] = random(6.0f, 12.0f) * escalaX;
        nv2FuegoAlfa[f] = 240.0f;
        nv2FuegoColor[f] = modoDios
          ? lerpColor(color(255, 230, 75), color(255, 85, 25), random(1.0f))
          : lerpColor(color(255, 165, 35), color(255, 50, 20), random(1.0f));
        break;
      }
    }
  }

  for (int f = 0; f < MAX_PART_FUEGO_NV2; f++) {
    if (nv2FuegoActivo[f]) {
      nv2FuegoX[f] += nv2FuegoVX[f] + sin(frameCount * 0.15f + f) * 0.65f * escalaX;
      nv2FuegoY[f] += nv2FuegoVY[f];
      nv2FuegoAlfa[f] -= 6.5f;
      if (nv2FuegoAlfa[f] <= 0 || nv2FuegoY[f] < yTop) {
        nv2FuegoActivo[f] = false;
      } else {
        float parpadeo = 0.55f + 0.45f * pulsoBeat;
        int wF = max(3, round(nv2FuegoTam[f] * (0.75f + 0.30f * pulsoBeat)));
        int hF = max(4, round(wF * 1.35f));
        int fx = round(nv2FuegoX[f]) - (wF >> 1);
        int fy = round(nv2FuegoY[f]) - (hF >> 1);
        int colF = nv2FuegoColor[f];
        fill((colF >> 16) & 0xFF, (colF >> 8) & 0xFF, colF & 0xFF, round(nv2FuegoAlfa[f] * parpadeo));
        rect(fx, fy, wF, hF);
        int wCoreF = max(2, wF >> 1);
        fill(255, 250, 205, round(nv2FuegoAlfa[f] * parpadeo * 0.7f));
        rect(fx + (wCoreF >> 1), fy + 1, wCoreF, max(2, hF - 2));
      }
    }
  }

  // Alerta perimetral roja cuando se falla una nota, la vida es baja o Mamá está en modo furia
  if (nv2FlashDanoTimer > 0) {
    nv2FlashDanoTimer--;
    int gDano = max(6, round(18 * escalaX));
    fill(255, 35, 35, round(map(nv2FlashDanoTimer, 0, 16, 0, 190)));
    rect(0, yTop, width, gDano);
    rect(0, height - gDano, width, gDano);
    rect(0, yTop + gDano, gDano, hUtil - gDano * 2);
    rect(width - gDano, yTop + gDano, gDano, hUtil - gDano * 2);
  } else { if (nv2VidaPlato < 30.0f || (nv2Dificultad == NV2_DIF_EXTREMO && (nv2ExtremoFaseAlerta || nv2ExtremoFaseMama))) {
    float pulsoPeligro = 0.5f + 0.5f * sin(frameCount * 0.32f);
    int gAlarma = max(6, round((12.0f + 12.0f * pulsoPeligro) * escalaX));
    fill(255, 30, 30, round(90 + 130 * pulsoPeligro));
    rect(0, yTop, width, gAlarma);
    rect(0, height - gAlarma, width, gAlarma);
    rect(0, yTop + gAlarma, gAlarma, hUtil - gAlarma * 2);
    rect(width - gAlarma, yTop + gAlarma, gAlarma, hUtil - gAlarma * 2);
  } }
}

void dibujarEfectosCombosYOndasNv2() {
  // 1. Ondas expansivas octogonales en los receptores (sin Ellipse2D costoso)
  noFill();
  strokeWeight(2.5f * escalaX);
  for (int i = 0; i < MAX_ONDAS_NV2; i++) {
    if (nv2OndaActiva[i]) {
      nv2OndaRadio[i] += 8.5f * escalaX;
      nv2OndaAlfa[i] -= 18.0f;
      if (nv2OndaAlfa[i] <= 0) {
        nv2OndaActiva[i] = false;
      } else {
        int colO = nv2OndaColor[i];
        stroke((colO >> 16) & 0xFF, (colO >> 8) & 0xFF, colO & 0xFF, nv2OndaAlfa[i]);
        float ox = nv2OndaX[i];
        float oy = nv2OndaY[i];
        float rO = nv2OndaRadio[i];
        beginShape();
        for (int v = 0; v < 8; v++) {
          vertex(ox + NV2_OCT_COS[v] * rO, oy + NV2_OCT_SIN[v] * rO);
        }
        endShape(CLOSE);
      }
    }
  }

  // 1.B SLASH DE LUZ EN CRUZ AL ACERTAR (Romboides cruzados por vértices matemáticos: 0 pushMatrix/rotate/ellipse)
  noStroke();
  for (int s = 0; s < MAX_SLASH_NV2; s++) {
    if (nv2SlashActivo[s]) {
      int tRest = nv2SlashTimer[s];
      float progSlash = tRest / 5.0f;
      float rLargo = (48.0f + (5 - tRest) * 14.0f) * escalaX;
      float rCorto = max(2.0f, 7.5f * progSlash * escalaX);
      float sx = nv2SlashX[s];
      float sy = nv2SlashY[s];
      float ang = nv2SlashAngulo[s];
      float ca = cos(ang);
      float sa = sin(ang);
      int colS = nv2SlashColor[s];

      // Halo externo en cruz (2 quads cruzados a 90 grados)
      fill((colS >> 16) & 0xFF, (colS >> 8) & 0xFF, colS & 0xFF, round(235 * progSlash));
      quad(sx + ca * rLargo, sy + sa * rLargo,
           sx - sa * rCorto, sy + ca * rCorto,
           sx - ca * rLargo, sy - sa * rLargo,
           sx + sa * rCorto, sy - ca * rCorto);
      quad(sx - sa * rLargo, sy + ca * rLargo,
           sx - ca * rCorto, sy - sa * rCorto,
           sx + sa * rLargo, sy - ca * rLargo,
           sx + ca * rCorto, sy + sa * rCorto);

      // Núcleo blanco incandescente en cruz
      float rLCore = rLargo * 0.68f;
      float rCCore = rCorto * 0.48f;
      fill(255, 255, 255, round(255 * progSlash));
      quad(sx + ca * rLCore, sy + sa * rLCore,
           sx - sa * rCCore, sy + ca * rCCore,
           sx - ca * rLCore, sy - sa * rLCore,
           sx + sa * rCCore, sy - ca * rCCore);
      quad(sx - sa * rLCore, sy + ca * rLCore,
           sx - ca * rCCore, sy - sa * rCCore,
           sx + sa * rLCore, sy - ca * rLCore,
           sx + ca * rCCore, sy + sa * rCCore);

      nv2SlashTimer[s]--;
      if (nv2SlashTimer[s] <= 0) {
        nv2SlashActivo[s] = false;
      }
    }
  }

  // 2. Rayos eléctricos de "arranque" entre notas simultáneas o seguidas
  for (int r = 0; r < MAX_RAYOS_ARRANQUE; r++) {
    if (nv2RayoActivo[r]) {
      nv2RayoAlfa[r] -= 22.0f;
      if (nv2RayoAlfa[r] <= 0) {
        nv2RayoActivo[r] = false;
      } else {
        int colR = nv2RayoColor[r];
        stroke((colR >> 16) & 0xFF, (colR >> 8) & 0xFF, colR & 0xFF, nv2RayoAlfa[r]);
        strokeWeight(2.8f * escalaX);
        float mx = (nv2RayoX1[r] + nv2RayoX2[r]) * 0.5f + random(-16, 16) * escalaX;
        float my = (nv2RayoY1[r] + nv2RayoY2[r]) * 0.5f + random(-20, 20) * escalaY;
        line(nv2RayoX1[r], nv2RayoY1[r], mx, my);
        line(mx, my, nv2RayoX2[r], nv2RayoY2[r]);
      }
    }
  }
  noStroke();

  // 3. Textos flotantes de locura (con tamaño único entero para 100% caché de glifos en Java2D)
  boolean hypeConfigurado = false;
  int tamHypeFijo = max(14, round(24 * escalaX));
  for (int i = 0; i < MAX_HYPE_NV2; i++) {
    if (nv2HypeActivo[i]) {
      nv2HypeX[i] += nv2HypeVX[i];
      nv2HypeY[i] += nv2HypeVY[i];
      nv2HypeAlfa[i] -= 8.5f;
      if (nv2HypeAlfa[i] <= 0) {
        nv2HypeActivo[i] = false;
      } else {
        if (!hypeConfigurado) {
          textAlign(CENTER, CENTER);
          textSize(tamHypeFijo);
          hypeConfigurado = true;
        }
        int hx = round(nv2HypeX[i]);
        int hy = round(nv2HypeY[i]);
        fill(0, nv2HypeAlfa[i] * 0.85f);
        text(nv2HypeTexto[i], hx + 2, hy + 2);
        int colH = nv2HypeColor[i];
        fill((colH >> 16) & 0xFF, (colH >> 8) & 0xFF, colH & 0xFF, nv2HypeAlfa[i]);
        text(nv2HypeTexto[i], hx, hy);
      }
    }
  }

  // 4. D.1 FÍSICA ELÁSTICA EN EL CONTADOR DE COMBO (100% caché de glifos sin rotate/scale en Graphics2D)
  if (nv2ComboActual >= 1) {
    nv2ComboPosX = lerp(nv2ComboPosX, nv2ComboTargetX, 0.18f);
    nv2ComboPosY = lerp(nv2ComboPosY, nv2ComboTargetY, 0.18f);
    nv2ComboAngulo = lerp(nv2ComboAngulo, nv2ComboTargetAngulo, 0.22f);
    nv2ComboEscala = lerp(nv2ComboEscala, 1.0f, 0.24f);

    float jitter = min(16.0f, nv2ComboActual * 0.28f);
    int cxCombo = round(nv2ComboPosX + random(-jitter, jitter) * escalaX);
    // Rebote vertical elástico proporcional al pop de escala
    int popOffsetY = round((nv2ComboEscala - 1.0f) * -28.0f * escalaY);
    int cyCombo = round(nv2ComboPosY + random(-jitter, jitter) * escalaY) + popOffsetY;

    int tamBaseInt = (nv2ComboActual >= 30)
      ? max(28, round(58 * escalaX))
      : ((nv2ComboActual >= 12) ? max(22, round(46 * escalaX)) : max(18, round(36 * escalaX)));
    // 3 escalones discretos de pop elástico para mantener 100% hit-rate en el caché de glifos de Java2D
    int bonusPopPx = (nv2ComboEscala > 1.24f) ? 8 : ((nv2ComboEscala > 1.10f) ? 4 : 0);
    int tamComboInt = tamBaseInt + bonusPopPx;

    float tCol = frameCount * 0.12f;
    int colCombo = (nv2ComboActual >= 12)
      ? color(180 + 75 * sin(tCol), 180 + 75 * sin(tCol + 2.1f), 180 + 75 * sin(tCol + 4.2f))
      : color(255, 225, 65);

    // Estrella giratoria de energía y barra inclinada detrás del combo (aplican nv2ComboAngulo y nv2ComboEscala por vértices)
    if (nv2ComboActual >= 4) {
      float angEstrella = frameCount * 0.08f + nv2ComboAngulo * 4.0f;
      dibujarIconoEstrellaRotada(cxCombo, cyCombo, tamBaseInt * 0.92f * nv2ComboEscala, angEstrella, color(red(colCombo), green(colCombo), blue(colCombo), 78));
    }

    textAlign(CENTER, CENTER);
    textSize(tamComboInt);
    fill(0, 220);
    text("COMBO x" + nv2ComboActual + "!", cxCombo + 3, cyCombo + 3);
    fill(colCombo);
    text("COMBO x" + nv2ComboActual + "!", cxCombo, cyCombo);

    if (nv2ComboActual >= 10) {
      int tamSubInt = max(12, round(18 * escalaX));
      textSize(tamSubInt);
      fill(255, 245, 190);
      String subCombo = (nv2ComboActual >= 40) ? "¡¡MODO DIOS DEL ESTOFADO!!" : ((nv2ComboActual >= 20) ? "¡FUEGO MÁXIMO EN LA COCINA!" : "¡SIGUE ASÍ!");
      text(subCombo, cxCombo, cyCombo + round(tamBaseInt * 0.68f));
    }
  }
}

// =========================================================================
// PANTALLA DRAMÁTICA DE ADVERTENCIA: «¡¡MAMÁ VIENE HACIA LA COCINA!!»
// =========================================================================
void dibujarAlertaMamaNv2(int tiempoAlertaMs) {
  pushStyle();
  
  float progresoAlerta = constrain(tiempoAlertaMs / float(DURACION_ALERTA_MAMA_MS), 0.0f, 1.0f);
  int segsRestAlerta = max(1, ceil((DURACION_ALERTA_MAMA_MS - tiempoAlertaMs) / 1000.0f));
  
  // Ticking sonoro y micro-vibración en cada segundo de la cuenta regresiva
  if (segsRestAlerta != nv2UltimoSegAlerta) {
    nv2UltimoSegAlerta = segsRestAlerta;
    if (tiempoAlertaMs > 350) {
      if (sonidoClic != null) {
        sonidoClic.amp(0.40f * volMaster);
        sonidoClic.play();
      } else {
        reproducirSfx(SFX_NOTIFICACION, 0.45f);
      }
      activarScreenShake(4, 2.0f);
    }
  }

  float pulsoAlarma = 0.5f + 0.5f * sin(frameCount * 0.18f);
  float pulsoRapido = 0.5f + 0.5f * sin(frameCount * 0.35f);

  // -------------------------------------------------------------
  // 1. FONDO AMBIENTAL: Oscurecimiento cinematográfico y viñeta
  // -------------------------------------------------------------
  noStroke();
  fill(12, 10, 18, 205); // Tinte oscuro cinematográfico profundo
  rectMode(CORNER);
  rect(0, 0, width, height);

  // Viñeta perimetral de tensión (pulso rojo tenue en los bordes)
  fill(180, 25, 45, int(18 + 14 * pulsoAlarma));
  rect(0, 0, width, 18 * escalaY);
  rect(0, height - 18 * escalaY, width, 18 * escalaY);
  rect(0, 0, 18 * escalaX, height);
  rect(width - 18 * escalaX, 0, 18 * escalaX, height);

  // -------------------------------------------------------------
  // 2. ELEMENTO DIBUJADO EN EL FONDO (IZQUIERDA): Pasillo y Pasos
  // -------------------------------------------------------------
  // Haz de luz cálida proyectado desde la puerta del pasillo (a la izquierda)
  float puertaX = width * 0.12f;
  float luzSueloY = height * 0.88f;
  
  // Haz de luz trapezoidal en perspectiva hacia la cocina
  fill(255, 235, 175, int(22 + 10 * pulsoAlarma));
  beginShape();
  vertex(puertaX - 40 * escalaX, height * 0.25f);
  vertex(puertaX + 45 * escalaX, height * 0.25f);
  vertex(puertaX + 160 * escalaX, luzSueloY);
  vertex(puertaX - 80 * escalaX, luzSueloY);
  endShape(CLOSE);

  // Silueta sutil de Mamá proyectada en el vano de la puerta
  if (imgMama != null && imgMama.width > 0) {
    pushStyle();
    imageMode(CENTER);
    tint(22, 14, 28, int(115 + 40 * pulsoAlarma));
    image(imgMama, puertaX + 10 * escalaX, height * 0.44f, 85 * escalaX, 125 * escalaY);
    popStyle();
  }

  // Pasos dibujados avanzando rítmicamente en el pasillo
  float cicloPaso = (frameCount * 0.045f) % 1.0f;
  for (int p = 0; p < 3; p++) {
    float posPaso = ((cicloPaso + p * 0.33f) % 1.0f);
    float pasoX = lerp(puertaX - 10 * escalaX, puertaX + 85 * escalaX, posPaso);
    float pasoY = lerp(height * 0.40f, luzSueloY - 30 * escalaY, posPaso);
    float alfaPaso = sin(posPaso * PI) * 110;
    
    // Silueta de huella de zapato aproximándose
    fill(45, 25, 30, alfaPaso);
    pushMatrix();
    translate(pasoX, pasoY);
    rotate(0.35f + (p % 2 == 0 ? 0.08f : -0.08f));
    ellipse(0, 0, 14 * escalaX * (0.8f + 0.4f * posPaso), 24 * escalaY * (0.8f + 0.4f * posPaso));
    ellipse(0, 12 * escalaY * (0.8f + 0.4f * posPaso), 10 * escalaX * (0.8f + 0.4f * posPaso), 12 * escalaY * (0.8f + 0.4f * posPaso));
    popMatrix();
  }

  // -------------------------------------------------------------
  // 3. ELEMENTO DIBUJADO EN EL FONDO (DERECHA): Humo de la Olla
  // -------------------------------------------------------------
  // Volutas de vapor / humo que suben orgánicamente desde la estufa a la derecha
  float ollaX = width * 0.86f;
  float ollaY = height * 0.72f;
  noFill();
  strokeWeight(3.5f * escalaX);
  for (int v = 0; v < 4; v++) {
    float faseVapor = ((frameCount * 0.028f + v * 0.25f) % 1.0f);
    float vy = lerp(ollaY, ollaY - 320 * escalaY, faseVapor);
    float vx = ollaX + sin(faseVapor * TWO_PI * 1.5f + v) * (26 * escalaX);
    float alfaVapor = sin(faseVapor * PI) * 125;
    
    stroke(240, 235, 250, alfaVapor);
    bezier(vx, vy, 
           vx - 18 * escalaX, vy - 25 * escalaY, 
           vx + 18 * escalaX, vy - 50 * escalaY, 
           vx + sin(faseVapor * 5) * 15 * escalaX, vy - 75 * escalaY);
  }

  // -------------------------------------------------------------
  // 4. TARJETA NARRATIVA FLOTANTE (ESTILO ORGÁNICO / CINEMÁTICO)
  // -------------------------------------------------------------
  float cw = min(980 * escalaX, width * 0.88f);
  float ch = min(390 * escalaY, height * 0.82f);
  float cx = width / 2;
  float cy = height / 2;

  // Sombra suave multicapa (Glassmorphism / Ambient Occlusion)
  rectMode(CENTER);
  noStroke();
  fill(0, 0, 0, 55);
  rect(cx, cy + 12 * escalaY, cw + 16 * escalaX, ch + 16 * escalaY, 22 * escalaX);
  fill(0, 0, 0, 85);
  rect(cx, cy + 6 * escalaY, cw + 6 * escalaX, ch + 6 * escalaY, 20 * escalaX);

  // Cuerpo principal de la tarjeta: Pizarra carbón cálida con tintes grafito
  fill(20, 21, 30, 246);
  stroke(244, 63, 94, 180 + 70 * pulsoAlarma); // Borde coral carmesí con pulsación orgánica
  strokeWeight(2.2f * escalaX);
  rect(cx, cy, cw, ch, 18 * escalaX);

  // Borde superior interior de brillo sutil
  stroke(255, 255, 255, 30);
  strokeWeight(1.0f * escalaX);
  line(cx - cw * 0.46f, cy - ch * 0.5f + 2 * escalaY, cx + cw * 0.46f, cy - ch * 0.5f + 2 * escalaY);

  // -------------------------------------------------------------
  // 5. INSIGNIA SUPERIOR (PILL ORGÁNICO DE ESTADO)
  // -------------------------------------------------------------
  float pillW = 280 * escalaX;
  float pillH = 32 * escalaY;
  float pillY = cy - ch * 0.5f + 32 * escalaY;

  noStroke();
  fill(225, 29, 72, 235); // Rojo rubí / carmesí elegante
  rect(cx, pillY, pillW, pillH, 16 * escalaX);

  // Punto de pulso estilo radar en la insignia
  fill(255, 255, 255, 120 * pulsoRapido);
  ellipse(cx - pillW * 0.38f, pillY, 14 * escalaX, 14 * escalaX);
  fill(255, 255, 255);
  ellipse(cx - pillW * 0.38f, pillY, 7 * escalaX, 7 * escalaX);

  textAlign(CENTER, CENTER);
  if (fontBold != null) textFont(fontBold);
  textSize(max(11, round(13 * escalaX)));
  fill(255, 255, 255);
  text("PASOS EN EL PASILLO • ALERTA", cx + 8 * escalaX, pillY - 1 * escalaY);

  // -------------------------------------------------------------
  // 6. TÍTULO DRAMÁTICO PRINCIPAL
  // -------------------------------------------------------------
  if (fontTitle != null) textFont(fontTitle);
  textSize(max(18, round(34 * escalaX)));
  fill(255, 245, 245);
  text("¡Mamá viene hacia la cocina!", cx, cy - ch * 0.5f + 84 * escalaY);

  // Línea divisoria muy sutil
  stroke(255, 255, 255, 25);
  strokeWeight(1.2f * escalaX);
  line(cx - 140 * escalaX, cy - ch * 0.5f + 112 * escalaY, cx + 140 * escalaX, cy - ch * 0.5f + 112 * escalaY);

  // -------------------------------------------------------------
  // 7. DIÁLOGO ORGÁNICO ENTRE SAM Y MATEO (BLOQUE DE NARRATIVA)
  // -------------------------------------------------------------
  float bloqueTextoY = cy - 20 * escalaY;
  float margenLateral = cw * 0.08f;

  // Intervención de Mateo
  textAlign(LEFT, CENTER);
  if (fontBold != null) textFont(fontBold);
  textSize(max(12, round(16 * escalaX)));
  fill(56, 189, 248); // Azul celeste de Mateo
  text("Mateo:", cx - cw * 0.5f + margenLateral, bloqueTextoY - 22 * escalaY);

  if (fontBody != null) textFont(fontBody);
  textSize(max(12, round(16 * escalaX)));
  fill(226, 232, 240); // Blanco tiza suave
  text("«Sam... ¿esa es tu mamá? ¡Y mira cómo dejamos esto!»", 
       cx - cw * 0.5f + margenLateral + 68 * escalaX, bloqueTextoY - 22 * escalaY);

  // Intervención de Sam
  if (fontBold != null) textFont(fontBold);
  fill(251, 146, 60); // Naranja cálido de Sam
  text("Sam:", cx - cw * 0.5f + margenLateral, bloqueTextoY + 12 * escalaY);

  if (fontBody != null) textFont(fontBody);
  fill(226, 232, 240);
  text("«¡Ay, no! Tú recoge eso, que yo me encargo de la olla.»", 
       cx - cw * 0.5f + margenLateral + 48 * escalaX, bloqueTextoY + 12 * escalaY);

  // Caja de objetivo / misión urgente
  float cajaMisionY = cy + 62 * escalaY;
  float cajaMisionW = cw - margenLateral * 1.6f;
  float cajaMisionH = 34 * escalaY;
  rectMode(CENTER);
  fill(30, 24, 38, 210);
  stroke(245, 158, 11, 130); // Ámbar miel suave
  strokeWeight(1.2f * escalaX);
  rect(cx, cajaMisionY, cajaMisionW, cajaMisionH, 8 * escalaX);

  textAlign(CENTER, CENTER);
  if (fontBold != null) textFont(fontBold);
  textSize(max(11, round(14.5f * escalaX)));
  fill(252, 211, 77); // Amarillo ámbar cálido
  text("Todavía falta terminar el estofado... y recoger todo esto.", cx, cajaMisionY);

  // -------------------------------------------------------------
  // 8. INDICADOR DE CUENTA REGRESIVA CIRCULAR (TENSION GAUGE)
  // -------------------------------------------------------------
  float gaugeY = cy + ch * 0.5f - 42 * escalaY;
  float gaugeR = 24 * escalaX;
  float gaugeX = cx - 130 * escalaX;

  // Anillo de fondo
  noFill();
  stroke(255, 255, 255, 30);
  strokeWeight(3.8f * escalaX);
  ellipse(gaugeX, gaugeY, gaugeR * 2, gaugeR * 2);

  // Arco dinámico de progreso (va disminuyendo suavemente conforme pasa el tiempo)
  float anguloInicio = -HALF_PI;
  float anguloRestante = TWO_PI * (1.0f - progresoAlerta);
  stroke(lerpColor(color(245, 158, 11), color(239, 68, 68), pulsoAlarma));
  strokeWeight(4.2f * escalaX);
  arc(gaugeX, gaugeY, gaugeR * 2, gaugeR * 2, anguloInicio, anguloInicio + anguloRestante);

  // Número central del segundero
  fill(255, 255, 255);
  textAlign(CENTER, CENTER);
  if (fontBold != null) textFont(fontBold);
  textSize(max(13, round(18 * escalaX)));
  text(str(segsRestAlerta), gaugeX, gaugeY - 1 * escalaY);

  // Texto elegante al lado del indicador
  textAlign(LEFT, CENTER);
  if (fontBold != null) textFont(fontBold);
  textSize(max(12, round(15 * escalaX)));
  fill(248, 113, 113); // Coral brillante
  text("¡AHORA SÍ, A LAS CARRERAS!", gaugeX + gaugeR + 14 * escalaX, gaugeY - 7 * escalaY);

  if (fontBody != null) textFont(fontBody);
  textSize(max(10, round(12.5f * escalaX)));
  fill(160, 174, 192);
  text("La música se acelera. Queda poco tiempo.", gaugeX + gaugeR + 14 * escalaX, gaugeY + 10 * escalaY);

  rectMode(CORNER);
  popStyle();
}

// =========================================================================
// BARRA DE PROGRESO LÍQUIDA ROJA (ONDAS Y BURBUJAS EN VIVO) - FASE MAMÁ
// =========================================================================
void dibujarBarraLiquidaMamaNv2(float barX, float barY, float barW, float barH, float progreso, int segRestantes) {
  rectMode(CORNER);

  // Contenedor oscuro con brillo rojo
  fill(24, 8, 12, 240);
  stroke(255, 65, 65, 220);
  strokeWeight(1.8f * escalaX);
  rect(barX, barY, barW, barH);

  float fillW = constrain(barW * progreso, 0.0f, barW);
  float pasoOla = max(16.0f, 22.0f * escalaX);

  if (fillW > 4 * escalaX) {
    noStroke();
    fill(245, 40, 48, 235);
    beginShape();
    vertex(barX + 2 * escalaX, barY + barH - 2 * escalaY);
    for (float px = barX + 2 * escalaX; px <= barX + fillW - 2 * escalaX; px += pasoOla) {
      float wave = sin((px - barX) * 0.10f + frameCount * 0.24f) * (2.5f * escalaY);
      vertex(px, barY + 4.0f * escalaY + wave);
    }
    vertex(barX + fillW - 2 * escalaX, barY + barH - 2 * escalaY);
    endShape(CLOSE);

    // Burbujas y partículas eléctricas recorriendo el líquido rojo sobrecargado (FillRect entero)
    fill(255, 225, 195, 200);
    int tamBub = max(3, round(4.0f * escalaX));
    for (int b = 0; b < 4; b++) {
      int bubX = round(barX + ((frameCount * (2.6f + b * 0.55f) + b * 58) % max(10.0f, fillW - 8 * escalaX)) + 4 * escalaX);
      int bubY = round(barY + barH * 0.5f + sin(frameCount * 0.35f + b * 1.7f) * (barH * 0.28f));
      rect(bubX, bubY, tamBub, tamBub);
    }

    // Brillo intenso sobrecargado en la punta de la barra (FillRect multicapa)
    int tipX = round(barX + fillW);
    int tipY = round(barY);
    int tipH = round(barH);
    int wHaloTip = max(8, round(18 * escalaX));
    int wCoreTip = max(4, round(8 * escalaX));
    fill(255, 95, 40, 115);
    rect(tipX - (wHaloTip >> 1), tipY - round(3 * escalaY), wHaloTip, tipH + round(6 * escalaY));
    fill(255, 210, 90, 215);
    rect(tipX - (wCoreTip >> 1), tipY - round(1 * escalaY), wCoreTip, tipH + round(2 * escalaY));
    fill(255, 255, 255, 250);
    rect(tipX - 2, tipY + 1, 4, max(2, tipH - 2));
  }

  // Texto sobre la barra líquida
  int minR = segRestantes / 60;
  int segR = segRestantes % 60;
  fill(255, 240, 220);
  textAlign(CENTER, CENTER);
  textSize(max(9, round(12 * escalaX)));
  text("¡MAMÁ LLEGA EN " + nf(minR, 2) + ":" + nf(segR, 2) + " (" + round(progreso * 100) + "%)!", barX + barW * 0.5f, barY + barH * 0.5f);
}

void dibujarHUDNivel2(int tiempoActualMs, int duracionTotalMs) {
  // El panel superior oscuro y los títulos estáticos ya están horneados en pgFondoEstaticoNv2
  rectMode(CORNER);
  float barX = 42 * escalaX;
  float barY = 72 * escalaY;
  float barW = 360 * escalaX;

  if (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama) {
    float barH = 18 * escalaY;
    int tiempoEnMama = tiempoActualMs - nv2ExtremoMamaInicioMs;
    int tiempoRestMs = max(0, DURACION_CLIMAX_MAMA_MS - tiempoEnMama);
    int segRest = ceil(tiempoRestMs / 1000.0f);
    dibujarBarraLiquidaMamaNv2(barX, barY - 2 * escalaY, barW, barH, nv2ProgresoMamaLerp, segRest);
    if (nv2SeccionCancionActual >= 0 && nv2SeccionCancionActual < 8) {
      fill(255, 200, 235);
      textAlign(LEFT, TOP);
      textSize(max(10, round(13 * escalaX)));
      text(nv2NombresSeccionAoi[nv2SeccionCancionActual], 24 * escalaX, 108 * escalaY);
    }
  } else {
    // --- D.2 BARRA DE PROGRESO SOBRECARGADA (100% FillRect entero -> 0 costo CPU) ---
    noStroke();
    float fillW = constrain(barW * nv2ProgresoLerp, 0.0f, barW);
    int iBarX = round(barX);
    int iBarY = round(barY + 2 * escalaY);
    int iFillW = round(fillW);
    int iBarH = max(6, round(12 * escalaY));

    boolean sobrecargaCombo = (nv2ComboActual >= 15);
    int colBarraBase = sobrecargaCombo
      ? lerpColor(color(65, 240, 175), color(110, 225, 255), 0.5f + 0.5f * sin(frameCount * 0.16f))
      : color(90, 225, 130);

    fill(colBarraBase);
    rect(iBarX, iBarY, iFillW, iBarH);

    if (iFillW > 6) {
      // Franja central luminosa de energía
      fill(220, 255, 245, 145);
      rect(iBarX, iBarY + (iBarH >> 2), iFillW, max(2, iBarH / 3));

      // Partículas eléctricas recorriendo la barra a medida que se llena (FillRect entero)
      int wPE = max(3, round(5 * escalaX));
      int hPE = max(2, round(3 * escalaY));
      for (int pe = 0; pe < 4; pe++) {
        int avanceP = round((frameCount * (3.2f + pe * 0.65f) + pe * 67.0f)) % max(6, iFillW);
        int pxElec = iBarX + avanceP;
        int pyElec = iBarY + (iBarH >> 1) + round(sin(frameCount * 0.45f + pe * 1.9f) * (iBarH * 0.32f));
        fill(175, 250, 255, 230);
        rect(pxElec, pyElec - (hPE >> 1), wPE, hPE);
      }

      // Brillo intenso sobrecargado en la punta de la barra (FillRect multicapa)
      int tipX = iBarX + iFillW;
      int wHaloT = max(8, round(16 * escalaX));
      int wCoreT = max(4, round(8 * escalaX));
      fill(95, 245, 255, 110);
      rect(tipX - (wHaloT >> 1), iBarY - round(3 * escalaY), wHaloT, iBarH + round(6 * escalaY));
      fill(185, 255, 235, 215);
      rect(tipX - (wCoreT >> 1), iBarY - round(1 * escalaY), wCoreT, iBarH + round(2 * escalaY));
      fill(255, 255, 255, 255);
      rect(tipX - 2, iBarY, 4, iBarH);
    }

    if (nv2Dificultad == NV2_DIF_EXTREMO && nv2SeccionCancionActual >= 0 && nv2SeccionCancionActual < 8) {
      fill(255, 205, 245);
      textAlign(LEFT, TOP);
      textSize(max(10, round(13 * escalaX)));
      text(nv2NombresSeccionAoi[nv2SeccionCancionActual], 24 * escalaX, 108 * escalaY);
    } else { if (nv2Dificultad == NV2_DIF_INJUGABLE && nv2SeccionCancionActual >= 0 && nv2SeccionCancionActual < 9) {
      fill(255, 200, 250);
      textAlign(LEFT, TOP);
      textSize(max(10, round(13 * escalaX)));
      text(nv2NombresSeccionRushE[nv2SeccionCancionActual] + "   |   Offset: " + (nv2OffsetMs >= 0 ? "+" : "") + nv2OffsetMs + "ms [<- / ->]", 24 * escalaX, 108 * escalaY);
    } }
  }

  // --- BARRA DE VIDA / CALIDAD DEL PLATO (Centro - ¡Si llega a 0 pierdes!) ---
  float vidaX = width * 0.5f - 175 * escalaX;
  float vidaY = 24 * escalaY;
  float vidaW = 350 * escalaX;
  float vidaH = 22 * escalaY;

  int colVida = color(75, 235, 115);
  if (nv2VidaPlatoLerp < 35) colVida = color(255, 65, 65);
  else { if (nv2VidaPlatoLerp < 65) colVida = color(255, 195, 50); }

  dibujarIconoCorazon(vidaX + 10 * escalaX, vidaY + 8 * escalaY, 8 * escalaX, colVida);
  fill(colVida);
  textAlign(LEFT, CENTER);
  textSize(max(10, round(15 * escalaX)));
  text("CALIDAD DEL PLATO (VIDA): " + round(nv2VidaPlatoLerp) + "%", vidaX + 24 * escalaX, vidaY + 7 * escalaY);

  // Relleno dinámico de la barra de vida (el marco vacío ya está en pgFondoEstaticoNv2)
  noStroke();
  fill(colVida);
  rect(vidaX + 2 * escalaX, vidaY + 24 * escalaY, max(0, (vidaW - 4 * escalaX) * (nv2VidaPlatoLerp / 100.0f)), vidaH - 4 * escalaY);

  if (nv2VidaPlatoLerp < 35) {
    fill(255, 230, 230);
    textAlign(CENTER, CENTER);
    textSize(max(9, round(12 * escalaX)));
    text("¡PELIGRO! ¡SE QUEMA EL ESTOFADO!", vidaX + vidaW / 2, vidaY + 33 * escalaY);
  }

  // Marcador de Puntos de Cocina y Combo (Derecha)
  textAlign(RIGHT, TOP);
  fill(255, 235, 95);
  textSize(max(14, round(24 * escalaX)));
  text("Puntaje: " + nv2PuntosObtenidos, width - 44 * escalaX, 22 * escalaY);

  fill(nv2ComboActual >= 10 ? color(255, 195, 55) : color(180, 220, 255));
  textSize(max(12, round(18 * escalaX)));
  text("Combo: x" + nv2ComboActual + "  (Máx: x" + nv2MaxCombo + ")", width - 44 * escalaX, 54 * escalaY);

  // Indicador visible cuando el Bot Auto-Play está jugando solo
  if (nv2AutoPlayBot) {
    fill(18, 46, 38, 235);
    stroke(80, 255, 185);
    strokeWeight(1.5f * escalaX);
    float bw = 540 * escalaX;
    float bh = 26 * escalaY;
    rect(width * 0.5f - bw * 0.5f, 105 * escalaY, bw, bh);
    noStroke();
    fill(95, 255, 195);
    textAlign(CENTER, CENTER);
    textSize(max(10, round(13 * escalaX)));
    text("BOT AUTO-PLAY ACTIVO [B]  |  Teclas [1-4]: Cambiar Nivel/Canción en vivo", width * 0.5f, 118 * escalaY);
  }

  // Feedback central de precisión (tamaño entero fijo para 100% acierto de caché de glifos)
  if (nv2FeedbackTimer > 0) {
    nv2FeedbackTimer--;
    textAlign(CENTER, CENTER);
    textSize(max(16, round(28 * escalaX)));
    int fx = width / 2;
    int fy = round((nv2AutoPlayBot ? 156 : 138) * escalaY);
    fill(0, 200);
    text(nv2FeedbackVisual, fx + 2, fy + 2);
    fill(nv2ColorFeedback);
    text(nv2FeedbackVisual, fx, fy);
  }
}

void finalizarPartidaNivel2() {
  nv2SubEstado = NV2_SUB_RESULTADOS;
  nv2Completado = true;
  detenerYReiniciarTodosLosAudiosNv2();

  int totalIntentos = max(1, nv2ConteoPerfecto + nv2ConteoBueno + nv2ConteoFallo);
  float puntosPrec = nv2ConteoPerfecto * 1.0f + nv2ConteoBueno * 0.65f;
  nv2PrecisionFinal = constrain((puntosPrec / float(totalIntentos)) * 100.0f, 0.0f, 100.0f);
  reaccionClipAlResultado(nv2PrecisionFinal >= 60.0f);

  if (nv2PrecisionFinal >= 85.0f) {
    nv2CategoriaResultado = "ESTRELLA MICHELIN";
    reproducirSfx(SFX_NV2_RESULTADO_MICHELIN, 0.8f);
  } else { if (nv2PrecisionFinal >= 60.0f) {
    nv2CategoriaResultado = "CHEF APROBADO";
    reproducirSfx(SFX_NV2_RESULTADO_APROBADO, 0.8f);
  } else {
    nv2CategoriaResultado = "COCINA QUEMADA";
    reproducirSfx(SFX_NV2_RESULTADO_QUEMADA, 0.8f);
  } }

  if (!recompensaNivel2Otorgada) {
    recompensaNivel2Otorgada = true;
    int ptsGanadosGlobal = max(15, round(nv2PuntosObtenidos / 180.0f));
    ganarPuntosConPopup(ptsGanadosGlobal, 4, "+" + ptsGanadosGlobal + " PTS ¡RECETA COMPLETADA!", width / 2, 140 * escalaY, color(255, 225, 70));

    if (nv2PrecisionFinal >= 85.0f) {
      modificarBienestar(12, width / 2 - 140 * escalaX, 190 * escalaY);
      modificarReputacion(15, width / 2 + 140 * escalaX, 190 * escalaY);
      desbloquearLogro(9); // Chef Michelin
    } else { if (nv2PrecisionFinal >= 60.0f) {
      modificarBienestar(6, width / 2 - 140 * escalaX, 190 * escalaY);
      modificarReputacion(8, width / 2 + 140 * escalaX, 190 * escalaY);
    } }

    if (nv2Dificultad == NV2_DIF_INJUGABLE && nv2PrecisionFinal >= 50.0f) {
      desbloquearLogro(10); // Leyenda Injugable
    }

    if (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama) {
      nv2CategoriaResultado = "¡JUSTO A TIEMPO!";
      ganarPuntosConPopup(60, 4, "+60 PTS ¡ESTOFADO A SALVO!", width / 2, 175 * escalaY, color(255, 235, 80));
    }
  }
}

// =========================================================================
// PANTALLA DE DERROTA ("¡EL ESTOFADO SE QUEMÓ!")
// =========================================================================
void dibujarPantallaDerrotaNv2() {
  pushStyle();
  fill(20, 4, 8, 225);
  noStroke();
  rect(0, 0, width, height);

  float cw = 900 * escalaX;
  float ch = 540 * escalaY;
  float cx = width / 2;
  float cy = height / 2;

  rectMode(CENTER);
  fill(28, 12, 18, 248);
  stroke(255, 70, 65);
  strokeWeight(4 * escalaX);
  rect(cx, cy, cw, ch, 24 * escalaX);
  rectMode(CORNER);

  dibujarIconoAlerta(cx - 330 * escalaX, cy - 210 * escalaY, 22 * escalaX, color(255, 90, 70));
  dibujarIconoAlerta(cx + 330 * escalaX, cy - 210 * escalaY, 22 * escalaX, color(255, 90, 70));

  textAlign(CENTER, CENTER);
  fill(255, 80, 75);
  textSize(42 * escalaX);
  text("¡DERROTA CULINARIA!", cx, cy - 212 * escalaY);

  fill(255, 210, 180);
  textSize(22 * escalaX);
  if (nv2Dificultad == NV2_DIF_EXTREMO && nv2ExtremoFaseMama) {
    text("Mamá abre la puerta. Los dos se quedan quietos, con la cocina hecha un desastre.", cx, cy - 162 * escalaY);
  } else {
    text("Ese olor no era buena señal. El estofado se quedó pegado al fondo de la olla.", cx, cy - 162 * escalaY);
  }

  fill(235, 220, 220);
  textSize(18 * escalaX);
  text("Puntaje alcanzado: " + nv2PuntosObtenidos + "   |   Combo Máximo: x" + nv2MaxCombo + "   |   Fallos (Miss): " + nv2ConteoFallo, cx, cy + 58 * escalaY);

  fill(255, 195, 110);
  textSize(16 * escalaX);
  text("Manual: pulsa cada nota a tiempo y mantén las notas largas hasta que terminen.", cx, cy + 98 * escalaY);

  // Botones inferiores (mismas coordenadas que Resultados para soporte de clic y teclado)
  float btnY = height / 2 + 215 * escalaY;
  String[] txtBtns = { "REINTENTAR [R]", "CAMBIAR DIFICULTAD [C]", "VOLVER AL MENÚ [ENTER]" };
  float[] posXBtns = { cx - 310 * escalaX, cx, cx + 310 * escalaX };
  int[] colBtns = { color(65, 195, 95), color(230, 150, 45), color(75, 135, 225) };

  rectMode(CENTER);
  for (int b = 0; b < 3; b++) {
    boolean hover = (mouseX >= posXBtns[b] - 140 * escalaX && mouseX <= posXBtns[b] + 140 * escalaX && mouseY >= btnY - 34 * escalaY && mouseY <= btnY + 34 * escalaY);
    fill(hover ? lerpColor(colBtns[b], color(255), 0.22f) : colBtns[b]);
    stroke(255, 220);
    strokeWeight(2.5f * escalaX);
    rect(posXBtns[b], btnY, 275 * escalaX, 64 * escalaY, 14 * escalaX);

    fill(255);
    textSize(17.5f * escalaX);
    text(txtBtns[b], posXBtns[b], btnY);
  }
  rectMode(CORNER);
  popStyle();
}

void dibujarResultadosNivel2() {
  pushStyle();
  fill(0, 200);
  noStroke();
  rect(0, 0, width, height);

  float cw = 920 * escalaX;
  float ch = 560 * escalaY;
  float cx = width / 2;
  float cy = height / 2;

  rectMode(CENTER);
  fill(20, 26, 44, 248);
  stroke(255, 210, 75);
  strokeWeight(4 * escalaX);
  rect(cx, cy, cw, ch, 24 * escalaX);

  textAlign(CENTER, CENTER);
  fill(255, 225, 85);
  textSize(38 * escalaX);
  text("¡RESULTADO DE LA RECETA!", cx, cy - 220 * escalaY);

  int colCat = (nv2PrecisionFinal >= 85.0f) ? color(95, 250, 135) : ((nv2PrecisionFinal >= 60.0f) ? color(105, 215, 255) : color(255, 95, 85));
  fill(colCat);
  textSize(32 * escalaX);
  text(nv2CategoriaResultado + " (" + nf(nv2PrecisionFinal, 1, 1) + "%)", cx, cy - 168 * escalaY);

  // Estadísticas detalladas
  fill(225, 235, 255);
  textSize(20 * escalaX);
  text("Modo: " + nv2NombresDificultad[nv2Dificultad] + " (" + nv2CarrilesPorDif[nv2Dificultad] + " carriles)   |   Puntaje Cocina: " + nv2PuntosObtenidos + "   |   Combo Máx: x" + nv2MaxCombo, cx, cy + 28 * escalaY);

  fill(180, 240, 200);
  textSize(18 * escalaX);
  text("Perfectos: " + nv2ConteoPerfecto + "     |     Buenos: " + nv2ConteoBueno + "     |     Fallos: " + nv2ConteoFallo, cx, cy + 66 * escalaY);

  dibujarIconoEstrella(cx - 215 * escalaX, cy + 108 * escalaY, 9 * escalaX, color(255, 225, 90));
  dibujarIconoCorazon(cx + 15 * escalaX, cy + 108 * escalaY, 8.5f * escalaX, color(100, 240, 140));
  fill(255, 225, 90);
  textSize(18 * escalaX);
  text("Puntos Totales de Sam: " + puntosJugador + " pts       Bienestar: " + round(bienestarDigital) + "%", cx + 8 * escalaX, cy + 108 * escalaY);

  fill(175, 195, 230);
  textSize(14.5f * escalaX);
  text("Atajos rápidos de dificultad: [1] Intermedio   [2] Difícil   [3] Extremo   [4] Injugable", cx, cy + 148 * escalaY);

  // Si el Bot Auto-Play está activo, avanza automáticamente al siguiente nivel musical para jugar los 4 solos
  if (nv2AutoPlayBot) {
    nv2TimerAutoAvanceBot++;
    int segRestBot = max(1, ceil((210 - nv2TimerAutoAvanceBot) / 60.0f));
    int sigDif = (nv2Dificultad + 1) % TOTAL_DIFICULTADES_NV2;
    fill(95, 255, 195);
    textSize(16 * escalaX);
    text("BOT AUTO-PLAY [B]: Pasando automáticamente a [" + (sigDif + 1) + "] " + nv2NombresDificultad[sigDif] + " en " + segRestBot + "s...", cx, cy + 174 * escalaY);
    if (nv2TimerAutoAvanceBot >= 210) {
      nv2TimerAutoAvanceBot = 0;
      nv2Dificultad = sigDif;
      nv2ReiniciarPartida = true;
    }
  }

  // Botones inferiores
  float btnY = height / 2 + 215 * escalaY;
  String[] txtBtns = { "REINTENTAR [R]", "CAMBIAR DIFICULTAD [C]", "VOLVER AL MENÚ [ENTER]" };
  float[] posXBtns = { cx - 310 * escalaX, cx, cx + 310 * escalaX };
  int[] colBtns = { color(55, 185, 90), color(220, 145, 45), color(65, 130, 220) };

  for (int b = 0; b < 3; b++) {
    boolean hover = (mouseX >= posXBtns[b] - 140 * escalaX && mouseX <= posXBtns[b] + 140 * escalaX && mouseY >= btnY - 34 * escalaY && mouseY <= btnY + 34 * escalaY);
    fill(hover ? lerpColor(colBtns[b], color(255), 0.22f) : colBtns[b]);
    stroke(255, 220);
    strokeWeight(2.5f * escalaX);
    rect(posXBtns[b], btnY, 275 * escalaX, 64 * escalaY, 14 * escalaX);

    fill(255);
    textSize(17.5f * escalaX);
    text(txtBtns[b], posXBtns[b], btnY);
  }

  rectMode(CORNER);
  popStyle();
}
