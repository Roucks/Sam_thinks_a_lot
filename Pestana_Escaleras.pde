final int ESCALERA_PELDANOS_MS = 500;
int inicioTramoEscalera = 0;
int duracionAcercamientoEscalera = 0;
float escaleraDesdeX, escaleraDesdeY;
float escalaSamEscalera = 1;

// Coordenadas de los pies de Sam, calibradas sobre el descanso y los peldaños.
float escaleraAccesoX() {
  float bordeSolido = width * (pisoActual == 2 ? escPiso2HitXFrac : 0.780f);
  return min(width * (pisoActual == 2 ? 0.690f : 0.755f), bordeSolido - hitW / 2 - 3 * escalaX);
}
float escaleraAccesoY() { return height * (pisoActual == 2 ? 0.352f : 0.366f); }
float escaleraInteriorX() { return width * (pisoActual == 2 ? 0.805f : 0.965f); }
float escaleraInteriorY() { return height * (pisoActual == 2 ? 0.421f : 0.202f); }
float piesSamX() { return pjX + hitOffX + hitW / 2; }
float piesSamY() { return pjY + hitOffY + hitH; }

void calcularZonaEscalera() {
  escX = width * (pisoActual == 2 ? 0.685f : 0.780f);
  escY = height * (pisoActual == 2 ? 0.235f : 0.050f);
  escW = width * (pisoActual == 2 ? 0.188f : 0.170f);
  escH = height * (pisoActual == 2 ? 0.265f : 0.250f);
}

boolean samCercaDeAccesoEscalera() {
  // La zona azul acepta acercamientos por el borde y por el descanso.
  float margenX = 28 * escalaX;
  float margenY = 44 * escalaY;
  return pjX + hitOffX < escX + escW + margenX
    && pjX + hitOffX + hitW > escX - margenX
    && pjY + hitOffY < escY + escH + margenY
    && pjY + hitOffY + hitH > escY - margenY;
}

void situarPiesSam(float x, float y) {
  pjX = x - hitOffX - hitW / 2;
  pjY = y - hitOffY - hitH;
}

void iniciarRecorridoEscalera() {
  animandoEscalera = true;
  faseEscalera = 1;
  leyendoMensaje = false;
  escaleraDesdeX = piesSamX();
  escaleraDesdeY = piesSamY();
  float recorrido = abs(escaleraAccesoX() - escaleraDesdeX) / escalaX
    + abs(escaleraAccesoY() - escaleraDesdeY) / escalaY;
  duracionAcercamientoEscalera = ceil(recorrido * 2.4f);
  inicioTramoEscalera = millis();
  reproducirSfx(SFX_ESCALERA, 0.6f);
}

void iniciarSalidaEscalera() {
  faseEscalera = 2;
  pisoActual = pisoActual == 2 ? 1 : 2;
  situarPiesSam(escaleraInteriorX(), escaleraInteriorY());
  escalaSamEscalera = 0.76f;
  direccionSam = "oeste";
  inicioTramoEscalera = millis();
}

void actualizarRecorridoEscalera() {
  int edad = millis() - inicioTramoEscalera;
  samCaminando = true;
  if (faseEscalera == 1) {
    if (enTransicion) {
      samCaminando = false;
      return;
    }
    if (edad < duracionAcercamientoEscalera) {
      acercarSamAlDescanso(edad / float(duracionAcercamientoEscalera));
      return;
    }
    float t = constrain((edad - duracionAcercamientoEscalera) / float(ESCALERA_PELDANOS_MS), 0, 1);
    direccionSam = "este";
    situarPiesSam(lerp(escaleraAccesoX(), escaleraInteriorX(), t), lerp(escaleraAccesoY(), escaleraInteriorY(), t));
    escalaSamEscalera = lerp(1, 0.76f, t);
    if (t >= 1) {
      estadoDestino = EXPLORACION;
      enTransicion = true;
    }
    return;
  }
  float t = constrain(edad / float(ESCALERA_PELDANOS_MS), 0, 1);
  direccionSam = "oeste";
  situarPiesSam(lerp(escaleraInteriorX(), escaleraAccesoX(), t), lerp(escaleraInteriorY(), escaleraAccesoY(), t));
  escalaSamEscalera = lerp(0.76f, 1, t);
  if (t >= 1) {
    animandoEscalera = false;
    faseEscalera = 0;
    samCaminando = false;
  }
}

void acercarSamAlDescanso(float avance) {
  float destinoX = escaleraAccesoX();
  float destinoY = escaleraAccesoY();
  float dx = abs(destinoX - escaleraDesdeX) / escalaX;
  float dy = abs(destinoY - escaleraDesdeY) / escalaY;
  float tramo = (dx + dy) * avance;
  // Primero llega al lado abierto. Luego se alinea con el peldaño de entrada.
  if (tramo < dx) {
    direccionSam = destinoX < escaleraDesdeX ? "oeste" : "este";
    situarPiesSam(lerp(escaleraDesdeX, destinoX, tramo / dx), escaleraDesdeY);
  } else {
    direccionSam = destinoY < escaleraDesdeY ? "norte" : "sur";
    situarPiesSam(destinoX, lerp(escaleraDesdeY, destinoY, constrain((tramo - dx) / max(1, dy), 0, 1)));
  }
}
