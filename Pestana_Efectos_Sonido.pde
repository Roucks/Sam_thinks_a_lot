// =========================================================================
// PESTAÑA 4: EFECTOS DE SONIDO (catálogo, carga segura y reproducción)
// (Arreglos paralelos de tamaño fijo y constantes de índice - AyP 2)
//
// CÓMO AGREGAR UN EFECTO:
//   1. Reemplaza el archivo .mp3 vacío de la carpeta /data (mismo nombre) por el audio real.
//   2. Listo. Si el archivo está vacío (0 bytes) o no existe, el efecto simplemente no suena.
//
// NOTA: Las notas del juego de ritmo (Nivel 2) NO tienen efectos de sonido
// para no ensuciar la canción; el feedback de las notas es 100% visual.
// =========================================================================

final int TOTAL_SFX = 33;

// Índices de cada efecto 
final int SFX_PASOS                  = 0;
final int SFX_ESCALERA               = 1;
final int SFX_PAUSA                  = 2;
final int SFX_APP_ABRIR              = 3;
final int SFX_NOTIFICACION           = 4;
final int SFX_LOGRO                  = 5;
final int SFX_PUNTOS                 = 6;
final int SFX_BIENESTAR_SUBE         = 7;
final int SFX_BIENESTAR_BAJA         = 8;
final int SFX_DECISION_BLOQUEADA     = 9;
final int SFX_DECISION_CONFIRMADA    = 10;
final int SFX_LIKE                   = 11;
final int SFX_MENSAJE_ENVIADO        = 12;
final int SFX_ALARMA_CELULAR         = 13;
final int SFX_INTRO_NIVEL            = 14;
final int SFX_TRANSICION_TEMPORAL    = 15;
final int SFX_PEN_FIJAR              = 16;
final int SFX_PEN_PATADA             = 17;
final int SFX_PEN_GOL                = 18;
final int SFX_PEN_ATAJADA            = 19;
final int SFX_PEN_PALO               = 20;
final int SFX_PEN_FUERA              = 21;
final int SFX_PEN_TIEMPO_AGOTADO     = 22;
final int SFX_PEN_VICTORIA           = 23;
final int SFX_PEN_DERROTA            = 24;
final int SFX_NV2_DERROTA            = 25;
final int SFX_NV2_ALERTA_MAMA        = 26;
final int SFX_NV2_MAMA_LLEGA         = 27;
final int SFX_NV2_RESULTADO_MICHELIN = 28;
final int SFX_NV2_RESULTADO_APROBADO = 29;
final int SFX_NV2_RESULTADO_QUEMADA  = 30;
final int SFX_NV3_PIXELES_CIERRE    = 31;
final int SFX_NV3_PIXELES_EXPLOSION = 32;

String[] sfxNombres = {
  "sfx_pasos_sam.mp3",
  "sfx_subir_bajar_escalera.mp3",
  "sfx_pausa_abrir_cerrar.mp3",
  "sfx_celular_abrir_app.mp3",
  "sfx_celular_notificacion_push.mp3",
  "sfx_logro_desbloqueado.mp3",
  "sfx_puntos_ganados.mp3",
  "sfx_bienestar_sube.mp3",
  "sfx_bienestar_baja.mp3",
  "sfx_decision_bloqueada_faltan_puntos.mp3",
  "sfx_decision_confirmada.mp3",
  "sfx_pixagram_like.mp3",
  "sfx_mensaje_enviado.mp3",
  "sfx_alarma_celular_despertar.mp3",
  "sfx_intro_nivel_titulo.mp3",
  "sfx_transicion_doce_dias_despues.mp3",
  "sfx_penalti_fijar_apuntado.mp3",
  "sfx_penalti_patada_balon.mp3",
  "sfx_penalti_gol.mp3",
  "sfx_penalti_atajada_arquero.mp3",
  "sfx_penalti_balon_en_palo.mp3",
  "sfx_penalti_balon_fuera_tribuna.mp3",
  "sfx_penalti_tiempo_agotado.mp3",
  "sfx_penalti_tanda_victoria.mp3",
  "sfx_penalti_tanda_derrota.mp3",
  "sfx_cocina_derrota_estofado_quemado.mp3",
  "sfx_cocina_alerta_mama.mp3",
  "sfx_cocina_mama_llega_climax.mp3",
  "sfx_cocina_resultado_estrella_michelin.mp3",
  "sfx_cocina_resultado_chef_aprobado.mp3",
  "sfx_cocina_resultado_cocina_quemada.mp3",
  "sfx_nv3_pixeles_cierre.mp3",
  "sfx_nv3_pixeles_explosion.mp3"
};

SoundFile[] sfxSonidos = new SoundFile[TOTAL_SFX];

// Carga todos los efectos. Si el archivo no existe o está vacío (0 bytes) se deja en null (silencio).
void cargarEfectosSonido() {
  for (int i = 0; i < TOTAL_SFX; i++) {
    sfxSonidos[i] = null;
    try {
      File archivo = dataFile(sfxNombres[i]);
      if (archivo.exists() && archivo.length() > 0) {
        sfxSonidos[i] = new SoundFile(this, sfxNombres[i]);
      }
    } catch (Exception e) {
      sfxSonidos[i] = null;
    }
  }
}

// Reproduce un efecto. Devuelve true si realmente sonó (permite usar otro sonido de respaldo si no existe).
boolean reproducirSfx(int id, float amplitud) {
  boolean sono = false;
  if (id >= 0 && id < TOTAL_SFX && sfxSonidos[id] != null) {
    try {
      sfxSonidos[id].amp(constrain(amplitud * volMaster, 0.0f, 1.0f));
      sfxSonidos[id].play();
      sono = true;
    } catch (Exception e) {
      sono = false;
    }
  }
  return sono;
}
