// =========================================================================
// PESTAÑA: MinijuegoFrutas.pde
// FRUTAS EN LA JARRA (FÍSICA SUIKA GAME - ESTILOS KAWAII Y COOL)
// =========================================================================

int frutaEstadoJuego = 0; // 0 = Inicio idéntico a Parejas, 1 = Modo juego/selección estilo

final float FRUTA_LOGICO_W = 600.0f;
final float FRUTA_LOGICO_H = 830.0f;

final float FRUTA_GRAVEDAD    = 0.45f;
final int   FRUTA_SUBPASOS    = 4;
final float FRUTA_RESTITUCION = 0.15f;

// Dimensiones de la jarra
final float FRUTA_JARRA_IZQ    = 100.0f;
final float FRUTA_JARRA_DER    = 500.0f;
final float FRUTA_JARRA_FONDO  = 740.0f;
final float FRUTA_JARRA_BORDE  = 140.0f;
final float FRUTA_LINEA_LIMITE = 160.0f;

final float[] FRUTA_RADIOS = {15.0f, 22.0f, 30.0f, 38.0f, 47.0f, 57.0f, 67.0f, 78.0f, 90.0f, 104.0f};
final String[] FRUTA_NOMBRES = {"Cereza", "Fresa", "Uva", "Naranja", "Manzana", "Pera", "Durazno", "Piña", "Melón", "Sandía"};

int[] FRUTA_COLORES_K;
int[] FRUTA_COLORES_C;

int frutaTema = 0; // 0 = Kawaii, 1 = Cool
boolean frutaEnMenu = true;

// arreglos paralelos para las frutas en la jarra (cero POO xd)
final int MAX_FRUTAS_JARRA = 160;
int totalFrutasActivas = 0;
float[] frutaItemX = new float[MAX_FRUTAS_JARRA];
float[] frutaItemY = new float[MAX_FRUTAS_JARRA];
float[] frutaItemVX = new float[MAX_FRUTAS_JARRA];
float[] frutaItemVY = new float[MAX_FRUTAS_JARRA];
float[] frutaItemR = new float[MAX_FRUTAS_JARRA];
int[] frutaItemTipo = new int[MAX_FRUTAS_JARRA];
int[] frutaItemEdad = new int[MAX_FRUTAS_JARRA];
int[] frutaItemSemilla = new int[MAX_FRUTAS_JARRA];
float[] frutaItemEscala = new float[MAX_FRUTAS_JARRA];
boolean[] frutaItemMuerta = new boolean[MAX_FRUTAS_JARRA];
// Como máximo se fusionan MAX_FRUTAS_JARRA / 2 parejas en un subpaso.
float[] frutaNuevaX = new float[MAX_FRUTAS_JARRA / 2];
float[] frutaNuevaY = new float[MAX_FRUTAS_JARRA / 2];
float[] frutaNuevaVX = new float[MAX_FRUTAS_JARRA / 2];
float[] frutaNuevaVY = new float[MAX_FRUTAS_JARRA / 2];
int[] frutaNuevaTipo = new int[MAX_FRUTAS_JARRA / 2];

// arreglos paralelos para las particulas de fusion (cero POO xd)
final int MAX_PARTICULAS_FRUTA = 320;
int totalParticulasFruta = 0;
float[] frutaPartX = new float[MAX_PARTICULAS_FRUTA];
float[] frutaPartY = new float[MAX_PARTICULAS_FRUTA];
float[] frutaPartVX = new float[MAX_PARTICULAS_FRUTA];
float[] frutaPartVY = new float[MAX_PARTICULAS_FRUTA];
float[] frutaPartVida = new float[MAX_PARTICULAS_FRUTA];
float[] frutaPartTam = new float[MAX_PARTICULAS_FRUTA];
float[] frutaPartRot = new float[MAX_PARTICULAS_FRUTA];
int[] frutaPartCol = new int[MAX_PARTICULAS_FRUTA];
boolean[] frutaPartForma2 = new boolean[MAX_PARTICULAS_FRUTA];

int frutaSiguiente;
int frutaEnMano;
int frutaPuntaje = 0;
int frutaPuntajeMax = 0;
boolean frutaNuevoRecord = false;
int frutaCooldown = 0;
int frutaTiempoPeligro = 0;
boolean frutaPerdio = false;

// Dificultad dinámica
int frutaSoltadas = 0;
int frutaNivel = 1;
float frutaFondoActual = FRUTA_JARRA_FONDO;
int frutaTemblor = 0;
int frutaProxTemblor = 700;
int frutaAvisoNivel = 0;
float frutaShakeX = 0.0f, frutaShakeY = 0.0f;

// Escala en pantalla completa
float frutaEscalaV = 1.0f, frutaOffX = 0.0f, frutaOffY = 0.0f;

// Decoraciones de fondo
final int FRUTA_N_DECO = 18;
float[] frutaDecoX = new float[FRUTA_N_DECO];
float[] frutaDecoY = new float[FRUTA_N_DECO];
float[] frutaDecoT = new float[FRUTA_N_DECO];
float[] frutaDecoV = new float[FRUTA_N_DECO];
boolean frutaIniciado = false;

// -------------------------------------------------------------------------
// SUBRUTINAS DE GESTION DE ARREGLOS PARALELOS (FRUTAS Y PARTICULAS)
// -------------------------------------------------------------------------
int frutaAgregarItem(float x, float y, int tipo, float vx, float vy, float escala) {
  int idx = -1;
  if (totalFrutasActivas < MAX_FRUTAS_JARRA) {
    idx = totalFrutasActivas;
    frutaItemX[idx] = x;
    frutaItemY[idx] = y;
    frutaItemVX[idx] = vx;
    frutaItemVY[idx] = vy;
    frutaItemTipo[idx] = tipo;
    frutaItemR[idx] = FRUTA_RADIOS[tipo];
    frutaItemEdad[idx] = 0;
    frutaItemSemilla[idx] = int(random(1000));
    frutaItemEscala[idx] = escala;
    frutaItemMuerta[idx] = false;
    totalFrutasActivas++;
  }
  return idx;
}

void frutaEliminarItemEn(int idx) {
  for (int k = idx; k < totalFrutasActivas - 1; k++) {
    frutaItemX[k] = frutaItemX[k + 1];
    frutaItemY[k] = frutaItemY[k + 1];
    frutaItemVX[k] = frutaItemVX[k + 1];
    frutaItemVY[k] = frutaItemVY[k + 1];
    frutaItemR[k] = frutaItemR[k + 1];
    frutaItemTipo[k] = frutaItemTipo[k + 1];
    frutaItemEdad[k] = frutaItemEdad[k + 1];
    frutaItemSemilla[k] = frutaItemSemilla[k + 1];
    frutaItemEscala[k] = frutaItemEscala[k + 1];
    frutaItemMuerta[k] = frutaItemMuerta[k + 1];
  }
  totalFrutasActivas--;
}

void frutaAgregarParticula(float x, float y, int c) {
  if (totalParticulasFruta < MAX_PARTICULAS_FRUTA) {
    int idx = totalParticulasFruta;
    frutaPartX[idx] = x;
    frutaPartY[idx] = y;
    float a = random(TWO_PI);
    float v = random(1.5f, 5.0f);
    frutaPartVX[idx] = cos(a) * v;
    frutaPartVY[idx] = sin(a) * v - 1.5f;
    frutaPartVida[idx] = random(35, 60);
    frutaPartTam[idx] = random(5, 11);
    frutaPartRot[idx] = random(TWO_PI);
    frutaPartForma2[idx] = random(1.0f) < 0.4f;
    frutaPartCol[idx] = lerpColor(c, color(255), (frutaTema == 0) ? 0.35f : 0.2f);
    totalParticulasFruta++;
  }
}

void frutaEliminarParticulaEn(int idx) {
  for (int k = idx; k < totalParticulasFruta - 1; k++) {
    frutaPartX[k] = frutaPartX[k + 1];
    frutaPartY[k] = frutaPartY[k + 1];
    frutaPartVX[k] = frutaPartVX[k + 1];
    frutaPartVY[k] = frutaPartVY[k + 1];
    frutaPartVida[k] = frutaPartVida[k + 1];
    frutaPartTam[k] = frutaPartTam[k + 1];
    frutaPartRot[k] = frutaPartRot[k + 1];
    frutaPartCol[k] = frutaPartCol[k + 1];
    frutaPartForma2[k] = frutaPartForma2[k + 1];
  }
  totalParticulasFruta--;
}

void frutaActualizarParticula(int idx) {
  frutaPartX[idx] += frutaPartVX[idx];
  frutaPartY[idx] += frutaPartVY[idx];
  frutaPartVY[idx] += 0.12f;
  frutaPartVX[idx] *= 0.98f;
  frutaPartRot[idx] += 0.08f;
  frutaPartVida[idx]--;
}

void frutaDibujarParticula(int idx) {
  noStroke();
  int c = frutaPartCol[idx];
  fill(red(c), green(c), blue(c), constrain(frutaPartVida[idx] * 6.0f, 0.0f, 255.0f));
  if (frutaTema == 0) {
    if (frutaPartForma2[idx]) {
      frutaDibujarCorazon(frutaPartX[idx], frutaPartY[idx], frutaPartTam[idx]);
    } else {
      frutaDibujarEstrella(frutaPartX[idx], frutaPartY[idx], frutaPartTam[idx], frutaPartRot[idx], 0.38f);
    }
  } else {
    if (frutaPartForma2[idx]) {
      frutaDibujarDiamante(frutaPartX[idx], frutaPartY[idx], frutaPartTam[idx] * 0.9f, frutaPartRot[idx]);
    } else {
      frutaDibujarEstrella(frutaPartX[idx], frutaPartY[idx], frutaPartTam[idx] * 1.1f, frutaPartRot[idx], 0.2f);
    }
  }
}

// -------------------------------------------------------------------------
// INICIALIZACIÓN Y FLUJO
// -------------------------------------------------------------------------
void initJuegoFrutas() {
  if (!frutaIniciado) {
    FRUTA_COLORES_K = new int[] {
      color(245, 70, 95), color(255, 125, 140), color(185, 130, 235),
      color(255, 175, 70), color(150, 215, 90), color(220, 228, 100),
      color(255, 195, 165), color(255, 225, 90), color(190, 240, 170),
      color(110, 200, 125)
    };

    FRUTA_COLORES_C = new int[] {
      color(205, 25, 55), color(235, 65, 80), color(125, 75, 195),
      color(240, 130, 20), color(95, 175, 50), color(185, 195, 50),
      color(240, 150, 110), color(240, 190, 30), color(125, 205, 120),
      color(40, 135, 65)
    };

    for (int i = 0; i < FRUTA_N_DECO; i++) {
      frutaDecoX[i] = random(1.0f);
      frutaDecoY[i] = random(1.0f);
      frutaDecoT[i] = random(14.0f, 34.0f);
      frutaDecoV[i] = random(0.15f, 0.5f);
    }

    frutaCargarRecord();
    reiniciarJuegoFrutas();
    frutaIniciado = true;
  }
}

void frutaCargarRecord() {
  try {
    java.io.File f = new java.io.File(sketchPath("mejor_frutas.txt"));
    if (f.exists()) {
      String[] l = loadStrings(f.getAbsolutePath());
      if (l != null && contarCadenas(l) > 0) frutaPuntajeMax = parseInt(trim(l[0]));
    }
  } catch (Exception e) {
    frutaPuntajeMax = 0;
  }
}

void frutaGuardarRecord() {
  try {
    if (!feriaActiva) saveStrings(sketchPath("mejor_frutas.txt"), new String[] { str(frutaPuntajeMax) });
  } catch (Exception e) {}
}

int frutaCol(int tipo) {
  return (frutaTema == 0) ? FRUTA_COLORES_K[tipo] : FRUTA_COLORES_C[tipo];
}

int frutaHoja() {
  return (frutaTema == 0) ? color(110, 205, 100) : color(70, 170, 75);
}

void reiniciarJuegoFrutas() {
  totalFrutasActivas = 0;
  totalParticulasFruta = 0;
  frutaPuntaje = 0;
  frutaPerdio = false;
  frutaNuevoRecord = false;
  frutaTiempoPeligro = 0;
  frutaCooldown = 0;
  frutaSoltadas = 0;
  frutaNivel = 1;
  frutaFondoActual = FRUTA_JARRA_FONDO;
  frutaTemblor = 0;
  frutaProxTemblor = 700;
  frutaAvisoNivel = 0;
  frutaShakeX = 0.0f;
  frutaShakeY = 0.0f;
  frutaEnMano = int(random(4));
  frutaSiguiente = int(random(4));
}

void frutaElegirEstilo(int t) {
  frutaTema = t;
  frutaEnMenu = false;
  reiniciarJuegoFrutas();
  frutaCooldown = 15;
}

float frutaMX() { return (mouseX - frutaOffX) / frutaEscalaV; }
float frutaMY() { return (mouseY - frutaOffY) / frutaEscalaV; }

// -------------------------------------------------------------------------
// FÍSICA Y COLISIONES (USANDO ARREGLOS PARALELOS)
// -------------------------------------------------------------------------
void frutaActualizarFisica() {
  for (int i = 0; i < totalFrutasActivas; i++) {
    frutaItemVY[i] += FRUTA_GRAVEDAD / (float)FRUTA_SUBPASOS;
    frutaItemX[i] += frutaItemVX[i] / (float)FRUTA_SUBPASOS;
    frutaItemY[i] += frutaItemVY[i] / (float)FRUTA_SUBPASOS;
  }

  // arreglos temporales paralelos para las frutas que nacen por fusion en este subpaso
  int cantNuevas = 0;

  for (int i = 0; i < totalFrutasActivas; i++) {
    if (frutaItemMuerta[i]) continue;
    for (int j = i + 1; j < totalFrutasActivas; j++) {
      if (frutaItemMuerta[j]) continue;

      float dx = frutaItemX[j] - frutaItemX[i];
      float dy = frutaItemY[j] - frutaItemY[i];
      float minDist = frutaItemR[i] + frutaItemR[j];
      float d2 = dx * dx + dy * dy;
      if (d2 >= minDist * minDist) continue;

      float d = sqrt(d2);
      if (d < 0.0001f) { dx = 0.01f; dy = 0.0f; d = 0.01f; }

      if (abs(dx) < 1.0f) {
        dx = ((frutaItemSemilla[i] + frutaItemSemilla[j]) % 2 == 0) ? 1.0f : -1.0f;
        d = sqrt(dx * dx + dy * dy);
      }

      // Fusión de frutas iguales
      if (frutaItemTipo[i] == frutaItemTipo[j]) {
        frutaItemMuerta[i] = true;
        frutaItemMuerta[j] = true;
        if (sfxFrutaFusion != null) {
          sfxFrutaFusion.amp(0.6f * volMaster);
          sfxFrutaFusion.play();
        }
        frutaPuntaje += (frutaItemTipo[i] + 1) * (frutaItemTipo[i] + 2);
        puntosJugador += 2;
        float ma = frutaItemR[i] * frutaItemR[i];
        float mb = frutaItemR[j] * frutaItemR[j];
        float px = (frutaItemX[i] * ma + frutaItemX[j] * mb) / (ma + mb);
        float py = (frutaItemY[i] * ma + frutaItemY[j] * mb) / (ma + mb);
        if (frutaItemTipo[i] < TAM_FRUTA_RADIOS - 1) {
          if (cantNuevas < TAM_FRUTA_NUEVA_TIPO) {
            frutaNuevaX[cantNuevas] = px;
            frutaNuevaY[cantNuevas] = py;
            frutaNuevaVX[cantNuevas] = (frutaItemVX[i] + frutaItemVX[j]) * 0.5f;
            frutaNuevaVY[cantNuevas] = (frutaItemVY[i] + frutaItemVY[j]) * 0.5f;
            frutaNuevaTipo[cantNuevas] = frutaItemTipo[i] + 1;
            cantNuevas++;
          }
          frutaExplotar(px, py, frutaItemTipo[i] + 1, 8 + frutaItemTipo[i]);
        } else {
          frutaPuntaje += 500;
          reaccionClipAlResultado(true);
          puntosJugador += 25;
          frutaExplotar(px, py, 9, 30);
        }
        break;
      }

      // Separación elástica basada en masa
      float nx = dx / d;
      float ny = dy / d;
      float overlap = minDist - d;
      float ma = frutaItemR[i] * frutaItemR[i];
      float mb = frutaItemR[j] * frutaItemR[j];
      float total = ma + mb;
      frutaItemX[i] -= nx * overlap * (mb / total);
      frutaItemY[i] -= ny * overlap * (mb / total);
      frutaItemX[j] += nx * overlap * (ma / total);
      frutaItemY[j] += ny * overlap * (ma / total);

      float rvx = frutaItemVX[j] - frutaItemVX[i];
      float rvy = frutaItemVY[j] - frutaItemVY[i];
      float velNormal = rvx * nx + rvy * ny;
      if (velNormal < 0) {
        float impulso = -(1.0f + FRUTA_RESTITUCION) * velNormal / (1.0f / ma + 1.0f / mb);
        frutaItemVX[i] -= impulso * nx / ma;
        frutaItemVY[i] -= impulso * ny / ma;
        frutaItemVX[j] += impulso * nx / mb;
        frutaItemVY[j] += impulso * ny / mb;
      }
      frutaItemVX[i] *= 0.9995f;
      frutaItemVX[j] *= 0.9995f;
    }
  }

  for (int i = 0; i < totalFrutasActivas; i++) {
    if (frutaItemMuerta[i]) continue;
    if (frutaItemX[i] - frutaItemR[i] < FRUTA_JARRA_IZQ) {
      frutaItemX[i] = FRUTA_JARRA_IZQ + frutaItemR[i];
      frutaItemVX[i] *= -0.3f;
    }
    if (frutaItemX[i] + frutaItemR[i] > FRUTA_JARRA_DER) {
      frutaItemX[i] = FRUTA_JARRA_DER - frutaItemR[i];
      frutaItemVX[i] *= -0.3f;
    }
    if (frutaItemY[i] + frutaItemR[i] > frutaFondoActual) {
      frutaItemY[i] = frutaFondoActual - frutaItemR[i];
      frutaItemVY[i] *= -0.2f;
      frutaItemVX[i] *= 0.97f;
    }
    frutaItemVX[i] *= 0.9995f;
    frutaItemVY[i] *= 0.9995f;
  }

  for (int i = totalFrutasActivas - 1; i >= 0; i--) {
    if (frutaItemMuerta[i]) {
      frutaEliminarItemEn(i);
    }
  }

  for (int n = 0; n < cantNuevas; n++) {
    frutaAgregarItem(frutaNuevaX[n], frutaNuevaY[n], frutaNuevaTipo[n], frutaNuevaVX[n], frutaNuevaVY[n], 0.6f);
  }

  for (int i = 0; i < totalFrutasActivas; i++) {
    frutaItemEdad[i]++;
    if (frutaItemEscala[i] < 1.0f) {
      frutaItemEscala[i] = min(1.0f, frutaItemEscala[i] + 0.01f);
    }
  }
}

void frutaRevisarPerdida() {
  boolean peligro = false;
  boolean fuera = false;
  for (int i = 0; i < totalFrutasActivas; i++) {
    float v = sqrt(frutaItemVX[i] * frutaItemVX[i] + frutaItemVY[i] * frutaItemVY[i]);
    if (frutaItemEdad[i] > 45 && v < 5.0f && frutaItemY[i] - frutaItemR[i] < FRUTA_LINEA_LIMITE) {
      peligro = true;
      if (frutaItemY[i] < FRUTA_JARRA_BORDE) fuera = true;
    }
  }
  if (peligro) frutaTiempoPeligro += fuera ? 4 : 1;
  else frutaTiempoPeligro = max(0, frutaTiempoPeligro - 1);

  if (frutaTiempoPeligro > 150) {
    frutaPerdio = true;
    frutaShakeX = 0.0f;
    frutaShakeY = 0.0f;
    if (frutaPuntaje > frutaPuntajeMax) {
      frutaPuntajeMax = frutaPuntaje;
      frutaNuevoRecord = true;
      frutaGuardarRecord();
    }
    reaccionClipAlResultado(frutaNuevoRecord);
  }
}

void frutaActualizarDificultad() {
  int nuevo = 1 + frutaSoltadas / 10;
  if (nuevo > frutaNivel) {
    frutaNivel = nuevo;
    frutaAvisoNivel = 120;
  }

  float obj = FRUTA_JARRA_FONDO - min(170.0f, (frutaNivel - 1) * 14.0f);
  if (frutaFondoActual > obj) frutaFondoActual = max(obj, frutaFondoActual - 0.25f);

  if (frutaNivel >= 3) {
    if (frutaTemblor > 0) {
      frutaTemblor--;
      frutaShakeX = random(-4.0f, 4.0f);
      frutaShakeY = random(-3.0f, 3.0f);
      if (frutaTemblor % 4 == 0) {
        for (int i = 0; i < totalFrutasActivas; i++) {
          frutaItemVX[i] += random(-1.2f, 1.2f);
          frutaItemVY[i] -= random(0.0f, 1.5f);
        }
      }
    } else {
      frutaShakeX = 0.0f;
      frutaShakeY = 0.0f;
      frutaProxTemblor--;
      if (frutaProxTemblor <= 0) {
        frutaTemblor = 50;
        frutaProxTemblor = max(360, 900 - frutaNivel * 50);
      }
    }
  }
  if (frutaAvisoNivel > 0) frutaAvisoNivel--;
}

void frutaSoltar() {
  if (!frutaPerdio && frutaCooldown <= 0) {
    float r = FRUTA_RADIOS[frutaEnMano];
    float x = constrain(frutaMX(), FRUTA_JARRA_IZQ + r, FRUTA_JARRA_DER - r);
    frutaAgregarItem(x + random(-2.0f, 2.0f), 60.0f, frutaEnMano, random(-0.5f, 0.5f), 0.0f, 1.0f);
    if (sfxFrutaCaida != null) {
      sfxFrutaCaida.amp(0.4f * volMaster);
      sfxFrutaCaida.play();
    }
    frutaEnMano = frutaSiguiente;
    frutaSiguiente = int(random(4));
    frutaSoltadas++;
    frutaCooldown = 35;
  }
}

void frutaExplotar(float x, float y, int tipo, int n) {
  for (int i = 0; i < n; i++) {
    frutaAgregarParticula(x, y, frutaCol(tipo));
  }
}

// -------------------------------------------------------------------------
// RENDERIZADO EN PANTALLA COMPLETA
// -------------------------------------------------------------------------
void dibujarJuegoFrutas(float w, float h) {
  initJuegoFrutas();

  frutaEscalaV = min(w / FRUTA_LOGICO_W, h / FRUTA_LOGICO_H);
  frutaOffX = (w - FRUTA_LOGICO_W * frutaEscalaV) / 2.0f;
  frutaOffY = (h - FRUTA_LOGICO_H * frutaEscalaV) / 2.0f;

  // =========================================================================
  // PANTALLA 0: MENÚ DE INICIO
  // =========================================================================
  if (frutaEstadoJuego == 0) {
    pushStyle();
    if (fondoHabitacion != null && fondoHabitacion.width > 0) {
      image(fondoHabitacion, 0, 0, w, h);
    }
    noStroke();
    fill(15, 23, 42, 215);
    rect(0, 0, w, h);

    if (fuenteComic != null) textFont(fuenteComic);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize((w > 600) ? 34 * escalaX : 18);
    text("¡FRUTAS EN LA JARRA!", w / 2.0f, h * 0.30f);

    fill(148, 163, 184);
    textSize((w > 600) ? 18 * escalaX : 11.5f);
    text("Fusiona las frutas para que evolucionen sin desbordar la jarra", w / 2.0f, h * 0.38f);
    text("- Con modo super Kawaii y Cool", w / 2.0f, h * 0.44f);
    text("- Cuidado con la línea de peligro superior", w / 2.0f, h * 0.49f);

    float btnJW = (w > 600) ? 220 * escalaX : 140;
    float btnJH = (w > 600) ? 52 * escalaY : 36;
    float btnJX = w / 2.0f - btnJW / 2.0f;
    float btnJY = h * 0.58f;
    boolean hoverJ = (mouseX >= btnJX && mouseX <= btnJX + btnJW && mouseY >= btnJY && mouseY <= btnJY + btnJH);

    fill(hoverJ ? color(65, 145, 250) : color(59, 130, 246));
    noStroke();
    rect(btnJX, btnJY, btnJW, btnJH, (w > 600 ? 12 * escalaX : 10));
    fill(255);
    textSize((w > 600) ? 19 * escalaX : 13.5f);
    text("JUGAR AHORA", w / 2.0f, btnJY + btnJH / 2.0f);

    frutaDibujarBotonVolver(w, h);
    popStyle();
  } else {
    // =========================================================================
    // PANTALLA 1: JUEGO ACTIVO
    // =========================================================================
    pushStyle();
    if (fuenteComic != null) textFont(fuenteComic);
    smooth(8);

    if (frutaEnMenu) {
      frutaDibujarMenu(w, h);
      frutaDibujarBotonVolver(w, h);
      popStyle();
    } else {
      frutaDibujarFondoPantalla(w, h);

      boolean mostrarDerrota = frutaPerdio;
      if (!frutaPerdio) {
        for (int s = 0; s < FRUTA_SUBPASOS; s++) frutaActualizarFisica();
        frutaRevisarPerdida();
        frutaActualizarDificultad();
        if (frutaCooldown > 0) frutaCooldown--;
      }

      for (int i = totalParticulasFruta - 1; i >= 0; i--) {
        frutaActualizarParticula(i);
        if (frutaPartVida[i] <= 0) {
          frutaEliminarParticulaEn(i);
        }
      }

      pushMatrix();
      translate(frutaOffX, frutaOffY);
      scale(frutaEscalaV);

      pushMatrix();
      translate(frutaShakeX, frutaShakeY);
      frutaDibujarJarraFondo();
      for (int i = 0; i < totalFrutasActivas; i++) {
        int mood = 0;
        if (frutaPerdio || (frutaItemEdad[i] > 60 && frutaItemY[i] - frutaItemR[i] < FRUTA_LINEA_LIMITE && frutaTiempoPeligro > 10)) {
          mood = 2;
        } else {
          if (frutaItemEscala[i] < 1.0f) {
            mood = 1;
          }
        }
        frutaDibujarItem(frutaItemX[i], frutaItemY[i], frutaItemTipo[i], frutaItemEscala[i], frutaItemSemilla[i], mood);
      }
      frutaDibujarJarraFrente();
      frutaDibujarLineaPeligro();
      popMatrix();

      for (int i = 0; i < totalParticulasFruta; i++) {
        frutaDibujarParticula(i);
      }
      frutaDibujarEnMano();
      frutaDibujarHUD();
      popMatrix();

      if (mostrarDerrota) frutaDibujarGameOver();

      frutaDibujarBotonVolver(w, h);
      popStyle();
    }
  }
}

void frutaDibujarBotonVolver(float w, float h) {
  float btnX = 24.0f;
  float btnY = 16.0f;
  float btnW = 180.0f;
  float btnH = 34.0f;
  boolean hover = mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= btnY && mouseY <= btnY + btnH;

  pushStyle();
  fill(0, 40);
  noStroke();
  rect(btnX + 2, btnY + 2, btnW, btnH, 8);

  fill(hover ? color(232, 89, 12) : color(255));
  stroke(hover ? color(232, 89, 12) : color(200));
  strokeWeight(1.5f);
  rect(btnX, btnY, btnW, btnH, 8);

  fill(hover ? color(255) : color(50));
  textAlign(CENTER, CENTER);
  textSize(14);
  text("< Volver al celular", btnX + btnW / 2.0f, btnY + btnH / 2.0f - 1);
  popStyle();
}

void frutaDibujarMenu(float w, float h) {
  // Capa translúcida clara para que el menú de estilos contraste y deje ver el cuarto
  noStroke();
  fill(250, 248, 243, 215);
  rect(0, 0, w, h);

  pushMatrix();
  translate(frutaOffX, frutaOffY);
  scale(frutaEscalaV);

  textAlign(CENTER, CENTER);
  textSize(44);
  fill(0, 70);
  text("Frutas en la jarra", FRUTA_LOGICO_W / 2.0f + 3, 98);
  fill(30);
  text("Frutas en la jarra", FRUTA_LOGICO_W / 2.0f, 95);
  textSize(20);
  fill(0, 60);
  text("Elige tu estilo", FRUTA_LOGICO_W / 2.0f + 2, 152);
  fill(90);
  text("Elige tu estilo", FRUTA_LOGICO_W / 2.0f, 150);

  frutaDibujarTarjetaMenu(0, 165.0f, "Kawaii", "Pastel y tiernito", "1");
  frutaDibujarTarjetaMenu(1, 435.0f, "Cool", "Oscuro y con actitud", "2");

  textSize(14);
  fill(30);
  text("Click en una tarjeta o presiona 1 / 2", FRUTA_LOGICO_W / 2.0f, 730);
  fill(90);
  textSize(12);
  text("Puedes cambiar de estilo en pleno juego con la tecla T", FRUTA_LOGICO_W / 2.0f, 755);

  popMatrix();
}

void frutaDibujarTarjetaMenu(int t, float cx, String nombre, String desc, String tecla) {
  boolean hover = abs(frutaMX() - cx) < 125.0f && frutaMY() > 230.0f && frutaMY() < 670.0f;
  pushMatrix();
  if (hover) translate(0, -8);

  noStroke();
  fill(0, 0, 0, 45);
  rect(cx - 125.0f + 6, 238, 250, 440, (t == 0) ? 30 : 10);

  if (t == 0) { fill(255, 246, 250); stroke(255, 150, 185); }
  else        { fill(26, 38, 66);    stroke(90, 200, 255);  }
  strokeWeight(hover ? 7.0f : 4.0f);
  rect(cx - 125.0f, 230, 250, 440, (t == 0) ? 30 : 10);

  int guardado = frutaTema;
  frutaTema = t;
  int m = hover ? 1 : 0;
  frutaDibujarItem(cx, 335.0f, 9, 0.8f, 5, m);
  frutaDibujarItem(cx - 65.0f, 468.0f, 0, 1.6f, 9, m);
  frutaDibujarItem(cx + 65.0f, 465.0f, 3, 1.1f, 14, m);
  frutaTema = guardado;

  textAlign(CENTER, CENTER);
  noStroke();
  if (t == 0) fill(235, 110, 160); else fill(90, 220, 255);
  textSize(34);
  text(nombre, cx, 548);
  if (t == 0) fill(170, 110, 140); else fill(150, 180, 220);
  textSize(15);
  text(desc, cx, 582);

  if (t == 0) { fill(255, 215, 232); stroke(255, 150, 185); }
  else        { fill(20, 30, 55);    stroke(90, 200, 255);  }
  strokeWeight(2);
  rect(cx - 22.0f, 612, 44, 34, (t == 0) ? 12 : 5);
  noStroke();
  if (t == 0) fill(150, 80, 110); else fill(235, 248, 255);
  textSize(20);
  text(tecla, cx, 629);

  popMatrix();
}

void frutaDibujarFondoPantalla(float w, float h) {
  // 1. Imagen del cuarto al fondo
  if (fondoHabitacion != null && fondoHabitacion.width > 0) {
    image(fondoHabitacion, 0, 0, w, h);
  }

  // 2. Capa semitransparente según el estilo (Kawaii / Cool)
  noStroke();
  if (frutaTema == 0) {
    fill(255, 226, 238, 190);
  } else {
    fill(16, 22, 48, 210);
  }
  rect(0, 0, w, h);

  // Cuadrícula en estilo Cool
  if (frutaTema == 1) {
    stroke(120, 190, 255, 18);
    strokeWeight(1);
    float paso = 60.0f * frutaEscalaV;
    for (float x = 0; x < w; x += paso) line(x, 0, x, h);
    for (float y = 0; y < h; y += paso) line(0, y, w, y);
    noStroke();
  }

  // Decoraciones flotantes (estrellas/corazones)
  for (int i = 0; i < FRUTA_N_DECO; i++) {
    float t = frutaDecoT[i] * frutaEscalaV;
    float x = frutaDecoX[i] * w;
    float y = ((frutaDecoY[i] * (h + 80.0f) - frameCount * frutaDecoV[i] * frutaEscalaV) % (h + 80.0f) + (h + 80.0f)) % (h + 80.0f) - 40.0f;
    noStroke();
    if (frutaTema == 0) {
      fill(255, 255, 255, 140);
      if (i % 3 == 0) {
        frutaDibujarCorazon(x, y, t * 0.6f);
      } else {
        if (i % 3 == 1) {
          frutaDibujarEstrella(x, y, t * 0.5f, frameCount * 0.01f + i, 0.38f);
        } else {
          frutaDibujarNube(x, y, t);
        }
      }
    } else {
      fill(110, 190, 255, 45);
      if (i % 3 == 0) {
        frutaDibujarDiamante(x, y, t * 0.45f, frameCount * 0.01f + i);
      } else {
        if (i % 3 == 1) {
          frutaDibujarMas(x, y, t * 0.4f);
        } else {
          frutaDibujarTriangulo(x, y, t * 0.5f, frameCount * 0.008f + i);
        }
      }
    }
  }
}

void frutaDibujarCorazon(float x, float y, float s) {
  beginShape();
  vertex(x, y + s * 0.35f);
  bezierVertex(x - s, y - s * 0.3f, x - s * 0.5f, y - s * 0.95f, x, y - s * 0.45f);
  bezierVertex(x + s * 0.5f, y - s * 0.95f, x + s, y - s * 0.3f, x, y + s * 0.35f);
  endShape(CLOSE);
}

void frutaDibujarEstrella(float x, float y, float r, float rot, float interior) {
  pushMatrix();
  translate(x, y);
  rotate(rot);
  beginShape();
  for (int i = 0; i < 8; i++) {
    float a = i * QUARTER_PI;
    float rr = (i % 2 == 0) ? r : r * interior;
    vertex(cos(a) * rr, sin(a) * rr);
  }
  endShape(CLOSE);
  popMatrix();
}

void frutaDibujarNube(float x, float y, float t) {
  ellipse(x, y, t * 1.6f, t);
  ellipse(x - t * 0.5f, y + t * 0.1f, t, t * 0.8f);
  ellipse(x + t * 0.5f, y + t * 0.1f, t * 1.1f, t * 0.8f);
}

void frutaDibujarDiamante(float x, float y, float s, float rot) {
  pushMatrix();
  translate(x, y);
  rotate(rot);
  beginShape();
  vertex(0, -s);
  vertex(s * 0.7f, 0);
  vertex(0, s);
  vertex(-s * 0.7f, 0);
  endShape(CLOSE);
  popMatrix();
}

void frutaDibujarMas(float x, float y, float s) {
  rect(x - s, y - s * 0.22f, s * 2.0f, s * 0.44f);
  rect(x - s * 0.22f, y - s, s * 0.44f, s * 2.0f);
}

void frutaDibujarTriangulo(float x, float y, float s, float rot) {
  pushMatrix();
  translate(x, y);
  rotate(rot);
  triangle(0, -s, s * 0.9f, s * 0.7f, -s * 0.9f, s * 0.7f);
  popMatrix();
}

void frutaDibujarJarraFondo() {
  if (frutaTema == 0) {
    noStroke();
    float oy = FRUTA_JARRA_BORDE - 16.0f;
    fill(255, 170, 200);
    ellipse(FRUTA_JARRA_IZQ + 8, oy, 62, 62);
    ellipse(FRUTA_JARRA_DER - 8, oy, 62, 62);
    fill(255, 215, 230);
    ellipse(FRUTA_JARRA_IZQ + 8, oy, 32, 32);
    ellipse(FRUTA_JARRA_DER - 8, oy, 32, 32);

    fill(255, 246, 250);
    rect(FRUTA_JARRA_IZQ, FRUTA_JARRA_BORDE, FRUTA_JARRA_DER - FRUTA_JARRA_IZQ, FRUTA_JARRA_FONDO - FRUTA_JARRA_BORDE, 0, 0, 45, 45);

    fill(255, 215, 232, 150);
    for (int row = 0; row < 12; row++) {
      for (int col = 0; col < 7; col++) {
        float px = FRUTA_JARRA_IZQ + 28.0f + col * 56.0f + (row % 2) * 28.0f;
        float py = FRUTA_JARRA_BORDE + 40.0f + row * 50.0f;
        if (px < FRUTA_JARRA_DER - 16.0f && py < FRUTA_JARRA_FONDO - 20.0f) ellipse(px, py, 14, 14);
      }
    }

    float cx = (FRUTA_JARRA_IZQ + FRUTA_JARRA_DER) / 2.0f;
    float cy = frutaFondoActual - 70.0f;
    int tinta = color(120, 80, 100);
    noStroke();
    fill(255, 130, 160, 150);
    ellipse(cx - 78, cy + 12, 38, 22);
    ellipse(cx + 78, cy + 12, 38, 22);

    if (frutaPerdio) {
      stroke(tinta); strokeWeight(5); strokeCap(ROUND);
      line(cx - 62, cy - 14, cx - 42, cy + 6);
      line(cx - 42, cy - 14, cx - 62, cy + 6);
      line(cx + 42, cy - 14, cx + 62, cy + 6);
      line(cx + 62, cy - 14, cx + 42, cy + 6);
      noFill();
      arc(cx, cy + 22, 26, 16, PI, TWO_PI);
    } else {
      if (frutaTiempoPeligro > 10) {
        fill(tinta); noStroke();
        ellipse(cx - 52, cy - 4, 20, 26);
        ellipse(cx + 52, cy - 4, 20, 26);
        fill(255);
        ellipse(cx - 49, cy - 9, 8, 8);
        ellipse(cx + 55, cy - 9, 8, 8);
        stroke(tinta); strokeWeight(4); noFill();
        arc(cx, cy + 22, 24, 14, PI, TWO_PI);
        stroke(130, 200, 250); strokeWeight(1);
        fill(150, 210, 255);
        ellipse(cx + 82, cy - 30, 10, 15);
      } else {
        fill(tinta); noStroke();
        ellipse(cx - 52, cy - 4, 20, 26);
        ellipse(cx + 52, cy - 4, 20, 26);
        fill(255);
        ellipse(cx - 49, cy - 9, 8, 8);
        ellipse(cx + 55, cy - 9, 8, 8);
        ellipse(cx - 55, cy + 1, 4, 4);
        ellipse(cx + 49, cy + 1, 4, 4);
        stroke(tinta); strokeWeight(4); strokeCap(ROUND); noFill();
        arc(cx - 7, cy + 10, 14, 12, 0, PI);
        arc(cx + 7, cy + 10, 14, 12, 0, PI);
      }
    }
  } else {
    boolean alerta = frutaTiempoPeligro > 10;
    int luz = frutaPerdio ? color(255, 70, 70) : (alerta ? (((frameCount / 8) % 2 == 0) ? color(255, 160, 50) : color(150, 70, 30)) : color(80, 230, 255));

    float ay = FRUTA_JARRA_BORDE - 10.0f;
    stroke(140, 170, 205);
    strokeWeight(5);
    strokeCap(ROUND);
    line(FRUTA_JARRA_IZQ + 22, ay, FRUTA_JARRA_IZQ + 22, ay - 42);
    line(FRUTA_JARRA_DER - 22, ay, FRUTA_JARRA_DER - 22, ay - 42);
    noStroke();
    fill(luz, 70);
    ellipse(FRUTA_JARRA_IZQ + 22, ay - 46, 30, 30);
    ellipse(FRUTA_JARRA_DER - 22, ay - 46, 30, 30);
    fill(luz);
    ellipse(FRUTA_JARRA_IZQ + 22, ay - 46, 14, 14);
    ellipse(FRUTA_JARRA_DER - 22, ay - 46, 14, 14);

    noStroke();
    fill(26, 38, 66);
    rect(FRUTA_JARRA_IZQ, FRUTA_JARRA_BORDE, FRUTA_JARRA_DER - FRUTA_JARRA_IZQ, FRUTA_JARRA_FONDO - FRUTA_JARRA_BORDE, 0, 0, 30, 30);

    stroke(255, 255, 255, 14);
    strokeWeight(2);
    for (float x = FRUTA_JARRA_IZQ + 50; x < FRUTA_JARRA_DER - 10; x += 50) line(x, FRUTA_JARRA_BORDE, x, FRUTA_JARRA_FONDO - 36);
    for (float y = FRUTA_JARRA_BORDE + 50; y < FRUTA_JARRA_FONDO - 35; y += 50) line(FRUTA_JARRA_IZQ, y, FRUTA_JARRA_DER, y);

    float cx = (FRUTA_JARRA_IZQ + FRUTA_JARRA_DER) / 2.0f;
    float cy = frutaFondoActual - 70.0f;
    noStroke();
    if (frutaPerdio) {
      stroke(luz); strokeWeight(6); strokeCap(ROUND);
      line(cx - 76, cy - 14, cx - 40, cy + 6);
      line(cx - 40, cy - 14, cx - 76, cy + 6);
      line(cx + 40, cy - 14, cx + 76, cy + 6);
      line(cx + 76, cy - 14, cx + 40, cy + 6);
      line(cx - 24, cy + 28, cx + 24, cy + 28);
    } else {
      fill(luz, 50);
      rect(cx - 82, cy - 18, 52, 28, 10);
      rect(cx + 30, cy - 18, 52, 28, 10);
      fill(luz);
      rect(cx - 76, cy - 12, 40, 16, 5);
      rect(cx + 36, cy - 12, 40, 16, 5);
      if (alerta) {
        stroke(luz); strokeWeight(5); strokeCap(ROUND); strokeJoin(ROUND);
        noFill();
        beginShape();
        vertex(cx - 26, cy + 30); vertex(cx - 13, cy + 22); vertex(cx, cy + 30);
        vertex(cx + 13, cy + 22); vertex(cx + 26, cy + 30);
        endShape();
      } else {
        fill(luz);
        rect(cx - 24, cy + 25, 48, 6, 3);
      }
    }
  }

  // Piso dinámico
  float ph = FRUTA_JARRA_FONDO - frutaFondoActual;
  if (ph >= 1.0f) {
    float pw = FRUTA_JARRA_DER - FRUTA_JARRA_IZQ;
    noStroke();
    if (frutaTema == 0) {
      fill(255, 185, 215);
      rect(FRUTA_JARRA_IZQ, frutaFondoActual, pw, ph, 0, 0, 45, 45);
      for (float x = FRUTA_JARRA_IZQ + 10; x < FRUTA_JARRA_DER; x += 22) ellipse(x, frutaFondoActual + 1, 26, 14);
      fill(255, 255, 255, 110);
      for (int i = 0; i < 6; i++) {
        float bx = FRUTA_JARRA_IZQ + 40.0f + i * 64.0f;
        ellipse(bx, frutaFondoActual + 16.0f + (i % 3) * 8.0f, 8, 8);
      }
    } else {
      fill(58, 78, 110);
      rect(FRUTA_JARRA_IZQ, frutaFondoActual, pw, ph, 0, 0, 30, 30);
      for (float x = FRUTA_JARRA_IZQ; x < FRUTA_JARRA_DER; x += 24) {
        boolean amarillo = ((int)((x - FRUTA_JARRA_IZQ) / 24)) % 2 == 0;
        if (amarillo) fill(240, 190, 30); else fill(30, 34, 50);
        rect(x, frutaFondoActual, min(24.0f, FRUTA_JARRA_DER - x), 10);
      }
      fill(215, 235, 255);
      for (float x = FRUTA_JARRA_IZQ + 24; x < FRUTA_JARRA_DER; x += 48) ellipse(x, frutaFondoActual + 22, 6, 6);
    }
  }
}

void frutaDibujarJarraFrente() {
  if (frutaTema == 0) {
    noStroke();
    fill(255, 255, 255, 120);
    rect(FRUTA_JARRA_IZQ + 16, FRUTA_JARRA_BORDE + 50, 12, 330, 8);
    ellipse(FRUTA_JARRA_IZQ + 22, FRUTA_JARRA_BORDE + 410, 12, 12);
    fill(255, 255, 255, 60);
    rect(FRUTA_JARRA_DER - 28, FRUTA_JARRA_BORDE + 90, 8, 120, 6);

    stroke(255, 150, 185);
    strokeWeight(7);
    strokeJoin(ROUND);
    noFill();
    beginShape();
    vertex(FRUTA_JARRA_IZQ, FRUTA_JARRA_BORDE);
    vertex(FRUTA_JARRA_IZQ, FRUTA_JARRA_FONDO - 45);
    quadraticVertex(FRUTA_JARRA_IZQ, FRUTA_JARRA_FONDO, FRUTA_JARRA_IZQ + 45, FRUTA_JARRA_FONDO);
    vertex(FRUTA_JARRA_DER - 45, FRUTA_JARRA_FONDO);
    quadraticVertex(FRUTA_JARRA_DER, FRUTA_JARRA_FONDO, FRUTA_JARRA_DER, FRUTA_JARRA_FONDO - 45);
    vertex(FRUTA_JARRA_DER, FRUTA_JARRA_BORDE);
    endShape();

    stroke(255, 130, 170);
    strokeWeight(4);
    fill(255, 175, 205);
    rect(FRUTA_JARRA_IZQ - 12, FRUTA_JARRA_BORDE - 9, FRUTA_JARRA_DER - FRUTA_JARRA_IZQ + 24, 18, 9);
    noStroke();
    fill(255, 255, 255, 130);
    rect(FRUTA_JARRA_IZQ + 4, FRUTA_JARRA_BORDE - 5, FRUTA_JARRA_DER - FRUTA_JARRA_IZQ - 8, 4, 2);

    pushMatrix();
    translate(FRUTA_JARRA_DER - 10.0f, FRUTA_JARRA_BORDE - 36.0f);
    rotate(0.25f);
    stroke(235, 110, 160);
    strokeWeight(3);
    fill(255, 140, 185);
    beginShape();
    vertex(0, 0); bezierVertex(-14, -22, -38, -18, -36, 0); bezierVertex(-38, 18, -14, 22, 0, 0);
    endShape(CLOSE);
    beginShape();
    vertex(0, 0); bezierVertex(14, -22, 38, -18, 36, 0); bezierVertex(38, 18, 14, 22, 0, 0);
    endShape(CLOSE);
    fill(255, 110, 165);
    ellipse(0, 0, 16, 16);
    noStroke();
    fill(255, 255, 255, 170);
    ellipse(-22, -5, 10, 6); ellipse(22, -5, 10, 6);
    popMatrix();
  } else {
    noStroke();
    fill(200, 230, 255, 32);
    rect(FRUTA_JARRA_IZQ + 14, FRUTA_JARRA_BORDE + 40, 14, 340, 4);
    rect(FRUTA_JARRA_DER - 26, FRUTA_JARRA_BORDE + 90, 8, 120, 4);

    stroke(150, 185, 220);
    strokeWeight(8);
    strokeJoin(ROUND);
    noFill();
    beginShape();
    vertex(FRUTA_JARRA_IZQ, FRUTA_JARRA_BORDE);
    vertex(FRUTA_JARRA_IZQ, FRUTA_JARRA_FONDO - 30);
    quadraticVertex(FRUTA_JARRA_IZQ, FRUTA_JARRA_FONDO, FRUTA_JARRA_IZQ + 30, FRUTA_JARRA_FONDO);
    vertex(FRUTA_JARRA_DER - 30, FRUTA_JARRA_FONDO);
    quadraticVertex(FRUTA_JARRA_DER, FRUTA_JARRA_FONDO, FRUTA_JARRA_DER, FRUTA_JARRA_FONDO - 30);
    vertex(FRUTA_JARRA_DER, FRUTA_JARRA_BORDE);
    endShape();

    noStroke();
    fill(215, 235, 255);
    for (float y = FRUTA_JARRA_BORDE + 70; y < FRUTA_JARRA_FONDO - 40; y += 110) {
      ellipse(FRUTA_JARRA_IZQ, y, 9, 9);
      ellipse(FRUTA_JARRA_DER, y, 9, 9);
    }

    stroke(200, 222, 245);
    strokeWeight(3);
    fill(88, 108, 140);
    rect(FRUTA_JARRA_IZQ - 16, FRUTA_JARRA_BORDE - 12, FRUTA_JARRA_DER - FRUTA_JARRA_IZQ + 32, 24, 6);
    noStroke();
    fill(255, 255, 255, 70);
    rect(FRUTA_JARRA_IZQ - 10, FRUTA_JARRA_BORDE - 9, FRUTA_JARRA_DER - FRUTA_JARRA_IZQ + 20, 5, 2);
    fill(215, 235, 255);
    float paso = (FRUTA_JARRA_DER - FRUTA_JARRA_IZQ) / 8.0f;
    for (int i = 0; i <= 8; i++) ellipse(FRUTA_JARRA_IZQ + i * paso, FRUTA_JARRA_BORDE + 4, 6, 6);
  }
}

void frutaDibujarLineaPeligro() {
  float alerta = constrain(frutaTiempoPeligro / 150.0f, 0.0f, 1.0f);
  noStroke();
  if (frutaTema == 0) {
    fill(lerpColor(color(255, 160, 190, 170), color(255, 40, 90), alerta));
    float t = 5.0f + alerta * 3.0f;
    for (float x = FRUTA_JARRA_IZQ + 10; x < FRUTA_JARRA_DER - 6; x += 20) {
      float wob = sin(frameCount * 0.2f + x * 0.1f) * alerta * 3.0f;
      ellipse(x, FRUTA_LINEA_LIMITE + wob, t, t);
    }
  } else {
    int c = lerpColor(color(255, 170, 60, 190), color(255, 50, 50), alerta);
    fill(c);
    float lh = 3.0f + alerta * 3.0f;
    float desp = (frameCount * (0.5f + alerta * 2.0f)) % 22;
    for (float x = FRUTA_JARRA_IZQ + 4 - desp; x < FRUTA_JARRA_DER - 10; x += 22) {
      float x0 = max(x, FRUTA_JARRA_IZQ + 4);
      float x1 = min(x + 14.0f, FRUTA_JARRA_DER - 4);
      if (x1 > x0) rect(x0, FRUTA_LINEA_LIMITE - lh / 2.0f, x1 - x0, lh);
    }
  }
}

void frutaDibujarEnMano() {
  if (!frutaPerdio) {
    float r = FRUTA_RADIOS[frutaEnMano];
    float x = constrain(frutaMX(), FRUTA_JARRA_IZQ + r, FRUTA_JARRA_DER - r);

    noStroke();
    if (frutaTema == 0) {
      fill(255, 120, 160, 110);
      for (float y = 60 + r + 10; y < FRUTA_JARRA_FONDO; y += 18) ellipse(x, y, 4, 4);
    } else {
      fill(90, 210, 255, 120);
      for (float y = 60 + r + 10; y < FRUTA_JARRA_FONDO; y += 18) rect(x - 1.5f, y, 3, 8);
    }

    float esc = (frutaCooldown == 0) ? 1.0f : 0.4f + 0.6f * (1.0f - frutaCooldown / 35.0f);
    frutaDibujarItem(x, 60, frutaEnMano, esc, 7, 1);
  }
}

void frutaPanelHUD(float x, float y, float w, float h) {
  if (frutaTema == 0) {
    stroke(255, 150, 185);
    strokeWeight(3);
    fill(255, 255, 255, 220);
    rect(x, y, w, h, 20);
  } else {
    stroke(90, 200, 255);
    strokeWeight(2);
    fill(20, 30, 55, 230);
    rect(x, y, w, h, 6);
  }
}

void frutaDibujarHUD() {
  boolean K = (frutaTema == 0);

  // Panel Puntaje
  frutaPanelHUD(12, 10, 190, 62);
  noStroke();
  if (K) { fill(255, 200, 70); frutaDibujarEstrella(36, 32, 12, 0, 0.38f); }
  else   { fill(90, 220, 255); frutaDibujarDiamante(36, 32, 12, 0); }
  if (K) fill(150, 80, 110); else fill(235, 248, 255);
  textAlign(LEFT, CENTER);
  textSize(24);
  text(frutaPuntaje, 56, 30);
  if (K) fill(190, 130, 160); else fill(120, 170, 210);
  textSize(14);
  if (frutaPuntaje > frutaPuntajeMax && frutaPuntajeMax > 0) {
    if (K) fill(255, 120, 160); else fill(255, 190, 60);
    text("¡Nuevo récord!", 30, 56);
  } else {
    text("Mejor: " + frutaPuntajeMax, 30, 56);
  }

  // Panel Siguiente
  float bx = FRUTA_LOGICO_W - 112;
  frutaPanelHUD(bx, 10, 100, 100);
  noStroke();
  if (K) fill(150, 80, 110); else fill(235, 248, 255);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("Siguiente", bx + 50, 26);
  frutaDibujarItem(bx + 50, 72, frutaSiguiente, 0.9f, 3, 0);

  // Panel Nivel y Progreso
  frutaPanelHUD(222, 10, 156, 40);
  noStroke();
  if (K) fill(150, 80, 110); else fill(235, 248, 255);
  textAlign(CENTER, CENTER);
  textSize(18);
  text("Nivel " + frutaNivel, 300, 24);
  float prog = (frutaSoltadas % 10) / 10.0f;
  if (K) fill(255, 215, 232); else fill(40, 60, 95);
  rect(236, 37, 128, 6, 3);
  if (K) fill(255, 140, 185); else fill(90, 220, 255);
  rect(236, 37, 128 * prog, 6, 3);

  if (frutaAvisoNivel > 0) {
    float al = constrain(frutaAvisoNivel * 4.0f, 0.0f, 255.0f);
    textSize(40);
    fill(0, al * 0.35f);
    text("¡Nivel " + frutaNivel + "!", 303, 303);
    if (K) fill(255, 110, 160, al); else fill(90, 220, 255, al);
    text("¡Nivel " + frutaNivel + "!", 300, 300);
  }
  if (frutaTemblor > 0) {
    textSize(30);
    fill(255, 150, 50, 230);
    text("¡TEMBLOR!", 300, 215);
  }

  // Evolución de frutas inferior
  float total = 0;
  for (int i = 0; i < TAM_FRUTA_RADIOS; i++) total += map(FRUTA_RADIOS[i], 15, 104, 6, 15) * 2 + 12;
  total -= 12;
  float ex = (FRUTA_LOGICO_W - total) / 2.0f;
  for (int i = 0; i < TAM_FRUTA_RADIOS; i++) {
    float rr = map(FRUTA_RADIOS[i], 15, 104, 6, 15);
    frutaDibujarItem(ex + rr, 790, i, rr / FRUTA_RADIOS[i], 0, 0);
    ex += rr * 2 + 12;
  }
  if (K) fill(170, 110, 140); else fill(150, 180, 220);
  noStroke();
  textAlign(CENTER, TOP);
  textSize(12);
  text("Junta frutas iguales  ·  T: estilo  ·  M: menú  ·  R: reiniciar", FRUTA_LOGICO_W / 2.0f, 808);
}

void frutaDibujarGameOver() {
  noStroke();
  if (frutaTema == 0) fill(120, 60, 110, 150);
  else                fill(8, 10, 25, 205);
  rect(0, 0, width, height);

  pushMatrix();
  translate(frutaOffX, frutaOffY);
  scale(frutaEscalaV);
  frutaDibujarItem(FRUTA_LOGICO_W / 2.0f, 270, 1, 2.2f, 1, 2);

  textAlign(CENTER, CENTER);
  if (frutaTema == 0) {
    fill(255);
    textSize(40);
    text("¡Oh no! Se salieron", FRUTA_LOGICO_W / 2.0f, 400);
    text("de la jarra", FRUTA_LOGICO_W / 2.0f, 445);
    textSize(28);
    fill(255, 225, 120);
    text("Puntos: " + frutaPuntaje + "  ·  Nivel " + frutaNivel, FRUTA_LOGICO_W / 2.0f, 510);
    fill(255, 220, 235);
    textSize(18);
    text("Click, ESPACIO o R para jugar otra vez", FRUTA_LOGICO_W / 2.0f, 565);
  } else {
    fill(255, 90, 60);
    textSize(58);
    text("GAME OVER", FRUTA_LOGICO_W / 2.0f, 405);
    fill(235, 245, 255);
    textSize(20);
    text("Las frutas se salieron de la jarra", FRUTA_LOGICO_W / 2.0f, 455);
    fill(90, 220, 255);
    textSize(30);
    text("Puntos: " + frutaPuntaje + "  ·  Nivel " + frutaNivel, FRUTA_LOGICO_W / 2.0f, 515);
    fill(150, 180, 220);
    textSize(16);
    text("Click, ESPACIO o R para intentarlo otra vez", FRUTA_LOGICO_W / 2.0f, 570);
  }
  if (frutaNuevoRecord) {
    fill(255, 225, 120);
    textSize(24);
    text("¡Nuevo récord!", FRUTA_LOGICO_W / 2.0f, 625);
  } else {
    fill(255, 255, 255, 170);
    textSize(16);
    text("Récord: " + frutaPuntajeMax, FRUTA_LOGICO_W / 2.0f, 625);
  }
  popMatrix();
}

// -------------------------------------------------------------------------
// DIBUJO DE DETALLES Y CARITAS DE FRUTAS
// -------------------------------------------------------------------------
void frutaDibujarItem(float x, float y, int tipo, float esc, int semilla, int mood) {
  float r = FRUTA_RADIOS[tipo] * esc;
  int base = frutaCol(tipo);
  boolean K = (frutaTema == 0);
  int borde = K ? lerpColor(base, color(110, 60, 80), 0.45f) : color(18, 22, 42);

  pushMatrix();
  translate(x, y);

  noStroke();
  if (K) fill(120, 70, 100, 35);
  else   fill(0, 0, 0, 70);
  ellipse(r * 0.07f, r * 0.11f, r * 2.02f, r * 2.02f);

  frutaDetallesAtras(tipo, r);

  stroke(borde);
  strokeWeight(max(1.5f, r * (K ? 0.07f : 0.095f)));
  fill(base);
  ellipse(0, 0, r * 2.0f, r * 2.0f);

  frutaDetallesFrente(tipo, r);

  if (K) frutaDibujarCaraKawaii(r, mood, semilla);
  else   frutaDibujarCaraCool(tipo, r, mood, semilla);

  noStroke();
  if (K) {
    fill(255, 255, 255, 140);
    ellipse(-r * 0.48f, -r * 0.55f, r * 0.34f, r * 0.2f);
    ellipse(-r * 0.2f, -r * 0.72f, r * 0.09f, r * 0.09f);
  } else {
    noFill();
    stroke(255, 255, 255, 120);
    strokeWeight(max(1.5f, r * 0.08f));
    strokeCap(ROUND);
    arc(0, 0, r * 1.5f, r * 1.5f, PI * 1.08f, PI * 1.38f);
    noStroke();
    fill(255, 255, 255, 120);
    ellipse(-r * 0.3f, -r * 0.82f, r * 0.08f, r * 0.08f);
  }
  popMatrix();
}

void frutaDetallesAtras(int tipo, float r) {
  switch (tipo) {
    case 0:
      noFill();
      stroke(frutaHoja());
      strokeWeight(max(2.0f, r * 0.12f));
      bezier(0, -r * 0.9f, r * 0.1f, -r * 1.5f, r * 0.5f, -r * 1.6f, r * 0.8f, -r * 1.7f);
      noStroke();
      fill(frutaHoja());
      ellipse(r * 0.75f, -r * 1.55f, r * 0.7f, r * 0.35f);
      break;
    case 1:
      noStroke();
      fill(frutaHoja());
      for (int i = -2; i <= 2; i++) {
        pushMatrix();
        translate(i * r * 0.22f, -r * 0.92f);
        rotate(i * 0.35f);
        ellipse(0, -r * 0.08f, r * 0.28f, r * 0.42f);
        popMatrix();
      }
      break;
    case 4:
      stroke(130, 85, 60);
      strokeWeight(max(2.0f, r * 0.07f));
      line(0, -r * 0.9f, r * 0.05f, -r * 1.2f);
      noStroke();
      fill(frutaHoja());
      ellipse(r * 0.35f, -r * 1.1f, r * 0.55f, r * 0.28f);
      break;
    case 5:
      stroke(130, 85, 60);
      strokeWeight(max(2.0f, r * 0.07f));
      line(0, -r * 0.9f, r * 0.08f, -r * 1.25f);
      noStroke();
      fill(frutaHoja());
      ellipse(-r * 0.3f, -r * 1.1f, r * 0.5f, r * 0.25f);
      break;
    case 7:
      noStroke();
      fill(frutaHoja());
      for (int i = -2; i <= 2; i++) {
        pushMatrix();
        translate(i * r * 0.2f, -r * 0.88f);
        rotate(i * 0.3f);
        ellipse(0, -r * 0.2f, r * 0.22f, r * 0.6f);
        popMatrix();
      }
      break;
    case 3:
      noStroke();
      fill(frutaHoja());
      ellipse(r * 0.2f, -r * 0.98f, r * 0.5f, r * 0.24f);
      break;
  }
}

void frutaDetallesFrente(int tipo, float r) {
  noStroke();
  switch (tipo) {
    case 1:
      fill(255, 240, 160);
      for (int i = 0; i < 9; i++) {
        float a = i * TWO_PI / 9.0f + 0.3f;
        float rr = (i % 2 == 0) ? 0.72f : 0.5f;
        ellipse(cos(a) * r * rr, sin(a) * r * rr + r * 0.05f, r * 0.08f, r * 0.13f);
      }
      break;
    case 2:
      fill(215, 175, 250, 170);
      ellipse(r * 0.25f, r * 0.55f, r * 0.55f, r * 0.3f);
      break;
    case 3:
      stroke(255, 215, 140, 170);
      strokeWeight(max(1.5f, r * 0.04f));
      for (int i = 0; i < 6; i++) {
        float a = i * TWO_PI / 6.0f;
        line(cos(a) * r * 0.62f, sin(a) * r * 0.62f, cos(a) * r * 0.88f, sin(a) * r * 0.88f);
      }
      noStroke();
      break;
    case 6:
      fill(255, 130, 140, 110);
      ellipse(r * 0.4f, -r * 0.05f, r * 0.85f, r * 1.4f);
      stroke(235, 150, 130, 150);
      strokeWeight(max(1.5f, r * 0.04f));
      noFill();
      arc(0, 0, r * 0.2f, r * 1.6f, -HALF_PI, HALF_PI);
      noStroke();
      break;
    case 7:
      stroke(215, 165, 40, 190);
      strokeWeight(max(1.2f, r * 0.03f));
      for (float gy = -r * 0.7f; gy <= r * 0.8f; gy += r * 0.34f) {
        for (float gx = -r * 0.7f; gx <= r * 0.8f; gx += r * 0.34f) {
          float ox = (round(gy / (r * 0.34f)) % 2 == 0) ? 0.0f : r * 0.17f;
          float px = gx + ox;
          if (dist(px, gy, 0, 0) < r * 0.86f) {
            line(px - r * 0.05f, gy - r * 0.05f, px + r * 0.05f, gy + r * 0.05f);
            line(px - r * 0.05f, gy + r * 0.05f, px + r * 0.05f, gy - r * 0.05f);
          }
        }
      }
      noStroke();
      break;
    case 8:
      stroke(125, 195, 115, 170);
      strokeWeight(max(1.2f, r * 0.03f));
      for (int i = -3; i <= 3; i++) {
        float lx = i * r * 0.27f;
        float h = sqrt(max(0.0f, r * r * 0.8f - lx * lx));
        line(lx, -h, lx, h);
      }
      noStroke();
      break;
    case 9:
      noStroke();
      if (frutaTema == 0) fill(215, 245, 215); else fill(205, 235, 190);
      ellipse(0, 0, r * 1.72f, r * 1.72f);
      if (frutaTema == 0) fill(255, 120, 135); else fill(235, 60, 80);
      ellipse(0, 0, r * 1.56f, r * 1.56f);
      fill(frutaTema == 0 ? color(90, 50, 70) : color(30, 20, 35));
      for (int i = 0; i < 8; i++) {
        float a = i * TWO_PI / 8.0f + 0.4f;
        ellipse(cos(a) * r * 0.66f, sin(a) * r * 0.66f, r * 0.07f, r * 0.12f);
      }
      break;
  }
}

void frutaDibujarCaraKawaii(float r, int mood, int semilla) {
  float ey = r * 0.1f;
  float ex = r * 0.3f;
  float ew = r * 0.19f;
  float eh = r * 0.26f;
  boolean parpadeo = ((frameCount + semilla * 37) % 210) < 7;
  int tinta = color(85, 50, 70);

  noStroke();
  fill(255, 105, 145, 150);
  ellipse(-r * 0.55f, ey + r * 0.24f, r * 0.28f, r * 0.16f);
  ellipse( r * 0.55f, ey + r * 0.24f, r * 0.28f, r * 0.16f);

  if (mood == 1) {
    noFill();
    stroke(tinta);
    strokeWeight(max(1.5f, r * 0.06f));
    strokeCap(ROUND);
    arc(-ex, ey + eh * 0.25f, ew * 1.7f, ew * 1.7f, PI, TWO_PI);
    arc( ex, ey + eh * 0.25f, ew * 1.7f, ew * 1.7f, PI, TWO_PI);
  } else {
    if (parpadeo) {
      stroke(tinta);
      strokeWeight(max(1.5f, r * 0.055f));
      strokeCap(ROUND);
      line(-ex - ew * 0.6f, ey, -ex + ew * 0.6f, ey);
      line( ex - ew * 0.6f, ey,  ex + ew * 0.6f, ey);
    } else {
      noStroke();
      fill(tinta);
      ellipse(-ex, ey, ew, eh);
      ellipse( ex, ey, ew, eh);
      fill(255);
      ellipse(-ex + ew * 0.14f, ey - eh * 0.2f, ew * 0.48f, ew * 0.48f);
      ellipse( ex + ew * 0.14f, ey - eh * 0.2f, ew * 0.48f, ew * 0.48f);
      ellipse(-ex - ew * 0.12f, ey + eh * 0.2f, ew * 0.22f, ew * 0.22f);
      ellipse( ex - ew * 0.12f, ey + eh * 0.2f, ew * 0.22f, ew * 0.22f);
    }
  }

  if (mood == 2) {
    noFill();
    stroke(tinta);
    strokeWeight(max(1.5f, r * 0.05f));
    strokeCap(ROUND);
    arc(0, ey + r * 0.42f, r * 0.24f, r * 0.16f, PI, TWO_PI);
    noStroke();
    fill(150, 210, 255);
    ellipse(r * 0.7f, -r * 0.1f, r * 0.13f, r * 0.2f);
  } else {
    if (mood == 1) {
      noStroke();
      fill(200, 70, 95);
      arc(0, ey + r * 0.2f, r * 0.28f, r * 0.3f, 0, PI, CHORD);
    } else {
      noFill();
      stroke(tinta);
      strokeWeight(max(1.5f, r * 0.05f));
      strokeCap(ROUND);
      arc(-r * 0.065f, ey + r * 0.23f, r * 0.13f, r * 0.11f, 0, PI);
      arc( r * 0.065f, ey + r * 0.23f, r * 0.13f, r * 0.11f, 0, PI);
    }
  }
}

void frutaDibujarCaraCool(int tipo, float r, int mood, int semilla) {
  float ey = r * 0.06f;
  float ex = r * 0.31f;
  float ew = r * 0.2f;
  float eh = r * 0.24f;
  int tinta = color(18, 22, 42);
  boolean parpadeo = ((frameCount + semilla * 37) % 230) < 7;
  boolean lentes = (tipo >= 6) && mood != 2;
  float grosor = max(1.6f, r * 0.065f);

  strokeCap(ROUND);

  if (lentes) {
    noStroke();
    fill(15, 18, 35);
    rect(-ex - r * 0.27f, ey - r * 0.15f, r * 0.54f, r * 0.3f, r * 0.1f);
    rect( ex - r * 0.27f, ey - r * 0.15f, r * 0.54f, r * 0.3f, r * 0.1f);
    stroke(15, 18, 35);
    strokeWeight(grosor);
    line(-ex + r * 0.27f, ey - r * 0.05f, ex - r * 0.27f, ey - r * 0.05f);
    noStroke();
    fill(255, 255, 255, 90);
    rect(-ex - r * 0.2f, ey - r * 0.1f, r * 0.16f, r * 0.07f, r * 0.03f);
    rect( ex - r * 0.2f, ey - r * 0.1f, r * 0.16f, r * 0.07f, r * 0.03f);
  } else {
    if (mood == 1) {
      noFill();
      stroke(tinta);
      strokeWeight(grosor);
      arc(-ex, ey + eh * 0.2f, ew * 1.7f, ew * 1.5f, PI, TWO_PI);
      arc( ex, ey + eh * 0.2f, ew * 1.7f, ew * 1.5f, PI, TWO_PI);
    } else {
      if (parpadeo) {
        stroke(tinta);
        strokeWeight(grosor);
        line(-ex - ew * 0.7f, ey, -ex + ew * 0.7f, ey);
        line( ex - ew * 0.7f, ey,  ex + ew * 0.7f, ey);
      } else {
        noStroke();
        fill(255);
        ellipse(-ex, ey, ew * 1.5f, eh * 1.15f);
        ellipse( ex, ey, ew * 1.5f, eh * 1.15f);
        fill(tinta);
        float px = (mood == 2) ? 0.0f : ew * 0.22f;
        ellipse(-ex + px, ey + eh * 0.05f, ew * 0.7f, ew * 0.7f);
        ellipse( ex + px, ey + eh * 0.05f, ew * 0.7f, ew * 0.7f);
      }
    }
  }

  stroke(tinta);
  strokeWeight(grosor * 1.25f);
  if (mood == 2) {
    line(-ex - ew * 0.9f, ey - eh * 0.75f, -ex + ew * 0.7f, ey - eh * 1.05f);
    line( ex + ew * 0.9f, ey - eh * 0.75f,  ex - ew * 0.7f, ey - eh * 1.05f);
  } else {
    if (!lentes) {
      line(-ex - ew * 0.9f, ey - eh * 1.05f, -ex + ew * 0.7f, ey - eh * 0.7f);
      line( ex + ew * 0.9f, ey - eh * 1.05f,  ex - ew * 0.7f, ey - eh * 0.7f);
    }
  }

  if (mood == 2) {
    noFill();
    stroke(tinta);
    strokeWeight(grosor);
    arc(0, ey + r * 0.46f, r * 0.26f, r * 0.16f, PI, TWO_PI);
    noStroke();
    fill(130, 205, 255);
    ellipse(r * 0.7f, -r * 0.12f, r * 0.13f, r * 0.2f);
  } else {
    if (mood == 1) {
      stroke(tinta);
      strokeWeight(grosor * 0.8f);
      fill(255);
      arc(0, ey + r * 0.24f, r * 0.52f, r * 0.36f, 0, PI, CHORD);
    } else {
      noFill();
      stroke(tinta);
      strokeWeight(grosor);
      line(-r * 0.16f, ey + r * 0.32f, r * 0.12f, ey + r * 0.32f);
      line(r * 0.12f, ey + r * 0.32f, r * 0.22f, ey + r * 0.23f);
    }
  }
}

// -------------------------------------------------------------------------
// ENTRADA Y EVENTOS DE FRUTAS
// -------------------------------------------------------------------------
void procesarClicFrutas() {
  // Manejo del menú inicial
  if (frutaEstadoJuego == 0) {
    float btnJW = (width > 600) ? 220 * escalaX : 140;
    float btnJH = (width > 600) ? 52 * escalaY : 36;
    float btnJX = width / 2.0f - btnJW / 2.0f;
    float btnJY = height * 0.58f;
    
    // Clic en Jugar
    if (mouseX >= btnJX && mouseX <= btnJX + btnJW && mouseY >= btnJY && mouseY <= btnJY + btnJH) {
      frutaEstadoJuego = 1;
      frutaEnMenu = true; // Abre la selección de estilo Kawaii / Cool
      if (sonidoClic != null) { sonidoClic.amp(0.35f * volMaster); sonidoClic.play(); }
    } else {
      // Clic en Volver al Celular (En menú de inicio)
      if (mouseX >= 24 && mouseX <= 204 && mouseY >= 20 && mouseY <= 58) {
        enHome = true;
        appAbierta = "";
        if (sonidoClic != null) { sonidoClic.amp(0.3f * volMaster); sonidoClic.play(); }
      }
    }
  } else {
    // Botón superior: salir al celular (En el juego o eligiendo estilo)
    if (mouseX >= 24 && mouseX <= 204 && mouseY >= 20 && mouseY <= 58) {
      frutaEstadoJuego = 0; // Regresa al menú inicial
      enHome = true;
      appAbierta = "";
      if (sonidoClic != null) { sonidoClic.amp(0.35f * volMaster); sonidoClic.play(); }
    } else {
      if (frutaEnMenu) {
        if (frutaMY() > 230.0f && frutaMY() < 670.0f) {
          if (abs(frutaMX() - 165.0f) < 125.0f) {
            frutaElegirEstilo(0);
          } else {
            if (abs(frutaMX() - 435.0f) < 125.0f) frutaElegirEstilo(1);
          }
        }
      } else {
        if (frutaPerdio) {
          reiniciarJuegoFrutas();
        } else {
          frutaSoltar();
        }
      }
    }
  }
}

void procesarTeclasFrutas(char k, int kCode) {
  if (frutaEnMenu) {
    if (k == '1') frutaElegirEstilo(0);
    if (k == '2') frutaElegirEstilo(1);
  } else {
    if (k == ' ') {
      if (frutaPerdio) reiniciarJuegoFrutas();
      else frutaSoltar();
    }
    if (k == 'r' || k == 'R') reiniciarJuegoFrutas();
    if (k == 't' || k == 'T') frutaTema = 1 - frutaTema;
    if (k == 'm' || k == 'M') frutaEnMenu = true;
  }
}

// Sobrecargas de compatibilidad (por si queda alguna llamada vieja)
void procesarClicFrutas(float relX, float relY, float w, float h) {
  procesarClicFrutas();
}

void procesarMovimientoFrutas(float relX, float relY, float w, float h) {
  // En pantalla completa, la escala y offset ya procesan el mouse global (frutaMX y frutaMY)
}
