final int GUIA_OBJ_ESTADO = 10;
final int GUIA_OBJ_INICIO = 11;
final int GUIA_PASOS_CELULAR_BASE = 9;
final int GUIA_PASOS_CELULAR = 12;
final int GUIA_PIXAGRAM_SIN_VISITA = 0;
final int GUIA_PIXAGRAM_EN_APP = 1;
final int GUIA_PIXAGRAM_AL_VOLVER = 2;
final int GUIA_PIXAGRAM_COMPLETA = 3;
// Medidas compartidas por el botón Guardar, su clic y el indicador de Clip.
final float BOTON_GUARDAR_CELULAR_W = 440;
final float BOTON_GUARDAR_CELULAR_H = 38;
final float BOTON_GUARDAR_CELULAR_MARGEN = 10;
int[] guiaOrdenCelular = {6, 4, 0, 1, 2, 3, 5, GUIA_OBJ_ESTADO, GUIA_OBJ_INICIO, 7, 8, 9};
String[] guiaConsejosCelular = {
  "Escribe tus ideas aquí. Yo prometo no corregirte las comas.",
  "Aquí ajustas el volumen y la apariencia del celular.",
  "Elige una canción y controla la reproducción desde aquí.",
  "Esta es la vista de la cámara. ¡Esconde mis mejores ángulos!",
  "Abre los chats y responde. A veces la historia sigue por aquí.",
  "Aquí puedes revisar las fotos que aparecen en el celular.",
  "¡Un mundo entero en tu bolsillo! Ve publicaciones y comenta. Yo vine por las fotos.",
  "¡Sam, hay juegos! ¡Y yo creyendo que esto era solo para chatear! En Parejas, voltea dos cartas iguales.",
  "Elige un color y pinta las casillas con su número. Permiso para salirse de la raya… denegado.",
  "Junta frutas iguales para fusionarlas. Si la jarra se desborda, yo no limpio.",
  "Arriba tienes la hora, el bienestar, la reputación y la batería. Cuatro cosas que mirar antes del desayuno.",
  "Este botón del marco te devuelve a las apps cuando estés dentro de una."
};

int guiaPasoCelular = 0;
int guiaInicioPasoCelular = -1;
float guiaCelularYAnterior = -1;
float guiaCelularDesdeY = -1;
float guiaBurbujaCelularX, guiaBurbujaCelularY;
final float GUIA_BURBUJA_CELULAR_W = 336;
final float GUIA_BURBUJA_CELULAR_H = 136;
boolean guiaCelularPausada = false;
boolean guiaDescubrimientoJuegos = false;
boolean guiaAvanceCelularPulsado = false;
int guiaPixagramVisita = GUIA_PIXAGRAM_SIN_VISITA;

float appCelularX(int app) {
  return espacioAppsX + (app % columnasApps) * (tamApp + espacioAppsX);
}

float appCelularY(int app) {
  return inicioAppsY + (app / columnasApps) * (tamApp + espacioAppsY + 12);
}

int limiteGuiaCelular() {
  return juegosDesbloqueados ? GUIA_PASOS_CELULAR : GUIA_PASOS_CELULAR_BASE;
}

boolean guiaCelularEnInicio() {
  return estadoActual == NIVEL1 && enHome && !mostrandoModalDormir && !enPausa;
}

boolean guiaCelularActiva() {
  return guiaCelularEnInicio() && !guiaCelularPausada && guiaPasoCelular < limiteGuiaCelular();
}

void reiniciarGuiaCelular() {
  guiaPasoCelular = 0;
  guiaInicioPasoCelular = -1;
  guiaCelularYAnterior = -1;
  guiaCelularDesdeY = -1;
  guiaCelularPausada = false;
  guiaDescubrimientoJuegos = false;
}

void registrarEntradaGuiaPixagram() {
  if (guiaPixagramVisita == GUIA_PIXAGRAM_SIN_VISITA && !desayunoComido && !penaltisJugados) {
    if (guiaPasoCelular == 0) avanzarGuiaCelular();
    guiaPixagramVisita = GUIA_PIXAGRAM_EN_APP;
    guiaInicioPasoCelular = -1;
  }
}

void registrarRegresoGuiaPixagram() {
  if (!enHome && appAbierta.equals("Pixagram") && guiaPixagramVisita == GUIA_PIXAGRAM_EN_APP) {
    guiaPixagramVisita = GUIA_PIXAGRAM_AL_VOLVER;
    guiaInicioPasoCelular = -1;
    guiaCelularDesdeY = guiaCelularYAnterior;
  }
}

boolean guiaPixagramAlVolver() {
  return guiaPixagramVisita == GUIA_PIXAGRAM_AL_VOLVER && guiaCelularEnInicio()
    && !desayunoComido && !penaltisJugados;
}

boolean guiaPixagramDentro() {
  return guiaPixagramVisita == GUIA_PIXAGRAM_EN_APP && estadoActual == NIVEL1
    && !enHome && appAbierta.equals("Pixagram") && !enPausa && !mostrarResumenPuntos
    && !desayunoComido && !penaltisJugados;
}

void desbloquearJuegosConClip() {
  if (juegosDesbloqueados) {
    mostrandoModalDormir = true;
    return;
  }
  juegosDesbloqueados = true;
  mostrandoModalDormir = false;
  guiaPasoCelular = GUIA_PASOS_CELULAR_BASE;
  guiaInicioPasoCelular = -1;
  guiaCelularYAnterior = -1;
  guiaCelularDesdeY = -1;
  guiaCelularPausada = false;
  guiaDescubrimientoJuegos = true;
}

void cerrarGuiaDeJuegos() {
  guiaDescubrimientoJuegos = false;
  guiaPasoCelular = GUIA_PASOS_CELULAR;
  mostrandoModalDormir = true;
}

void avanzarGuiaCelular() {
  guiaPasoCelular++;
  guiaInicioPasoCelular = -1;
  guiaCelularDesdeY = guiaCelularYAnterior;
  if (guiaDescubrimientoJuegos && guiaPasoCelular >= GUIA_PASOS_CELULAR) cerrarGuiaDeJuegos();
}

boolean clicGuiaCelular() {
  if (!guiaPixagramAlVolver() && !guiaCelularActiva()) return false;
  float x = mouseX / escalaX;
  float y = mouseY / escalaY;
  if (x >= guiaBurbujaCelularX && x <= guiaBurbujaCelularX + GUIA_BURBUJA_CELULAR_W
      && y >= guiaBurbujaCelularY && y <= guiaBurbujaCelularY + GUIA_BURBUJA_CELULAR_H
      && guiaInicioPasoCelular >= 0) {
    if (guiaPixagramAlVolver()) guiaPixagramVisita = GUIA_PIXAGRAM_COMPLETA;
    else avanzarGuiaCelular();
    return true;
  }
  return guiaDescubrimientoJuegos;
}

boolean teclaGuiaCelular() {
  boolean avanzar = key == ENTER || key == RETURN || key == ' ';
  if (avanzar && guiaAvanceCelularPulsado) return true;
  if (!guiaCelularEnInicio()) return false;
  if (guiaPixagramAlVolver() && avanzar) {
    guiaPixagramVisita = GUIA_PIXAGRAM_COMPLETA;
    guiaAvanceCelularPulsado = true;
    return true;
  }
  if (keyCode == GUIA_TECLA) {
    if (!guiaF1Presionada) {
      if (guiaDescubrimientoJuegos) {
        cerrarGuiaDeJuegos();
      } else {
        if (guiaPasoCelular >= limiteGuiaCelular()) reiniciarGuiaCelular();
        else guiaCelularPausada = !guiaCelularPausada;
      }
    }
    guiaF1Presionada = true;
    return true;
  }
  if (guiaCelularActiva() && avanzar) {
    guiaAvanceCelularPulsado = true;
    avanzarGuiaCelular();
    return true;
  }
  if (guiaDescubrimientoJuegos && key == ESC) {
    key = 0;
    cerrarGuiaDeJuegos();
    return true;
  }
  return guiaDescubrimientoJuegos;
}

void dibujarGuiaCelular(int ahora) {
  if (guiaPixagramAlVolver()) {
    dibujarClipObjetivoCelular(ahora, (width - BOTON_GUARDAR_CELULAR_W * escalaX) / 2,
      height - BOTON_GUARDAR_CELULAR_H * escalaY - BOTON_GUARDAR_CELULAR_MARGEN,
      BOTON_GUARDAR_CELULAR_W * escalaX, BOTON_GUARDAR_CELULAR_H * escalaY,
      "El desayuno te espera",
      "Guarda el celular y baja a desayunar. Después de comer, vuelve a tu cuarto y revísalo con calma.",
      "C o clic en Guardar Celular", false);
    return;
  }
  if (!guiaCelularActiva()) {
    if (!mostrandoModalDormir) dibujarClipEnEsquina(ahora, true);
    return;
  }
  int objeto = guiaOrdenCelular[guiaPasoCelular];
  float xObjetivo, yObjetivo, anchoObjetivo, altoObjetivo;
  String titulo;
  if (objeto == GUIA_OBJ_ESTADO) {
    xObjetivo = pantallaX;
    yObjetivo = pantallaY;
    anchoObjetivo = pantallaW;
    altoObjetivo = 28;
    titulo = "Barra de estado";
  } else {
    if (objeto == GUIA_OBJ_INICIO) {
      xObjetivo = telefonoX + telefonoAncho * 0.42f;
      anchoObjetivo = telefonoAncho * 0.16f;
      altoObjetivo = anchoObjetivo;
      yObjetivo = telefonoY + telefonoAlto * 0.91f - altoObjetivo / 2;
      titulo = "Botón de inicio";
    } else {
      xObjetivo = pantallaX + appCelularX(objeto);
      yObjetivo = pantallaY + appCelularY(objeto);
      anchoObjetivo = tamApp;
      altoObjetivo = tamApp;
      titulo = nombresApps[objeto];
    }
  }
  if (objeto == 6 && guiaPasoCelular == 0) titulo = "Clip · Un mundo nuevo";
  boolean emocion = guiaDescubrimientoJuegos && objeto == 7;
  if (emocion) titulo = "¡El celular tiene juegos!";
  String accion = guiaPasoCelular + 1 < limiteGuiaCelular() ? "Siguiente" : "Terminar";
  String controles = " · Clic aquí / Enter / Espacio";
  if (guiaDescubrimientoJuegos) controles += " · F1 omite";
  dibujarClipObjetivoCelular(ahora, xObjetivo, yObjetivo, anchoObjetivo, altoObjetivo,
    titulo, guiaConsejosCelular[objeto], accion + controles, emocion);
}

void dibujarGuiaDentroDePixagram(int ahora) {
  float lado = telefonoAncho * 0.16f;
  dibujarClipObjetivoCelular(ahora, telefonoX + telefonoAncho * 0.42f,
    telefonoY + telefonoAlto * 0.91f - lado / 2, lado, lado,
    "De vuelta a tus apps", "Cuando termines de mirar Pixagram, pulsa el botón circular de abajo.",
    "", false);
}

void dibujarClipObjetivoCelular(int ahora, float xObjetivo, float yObjetivo,
    float anchoObjetivo, float altoObjetivo, String titulo, String consejo, String controles, boolean emocion) {
  if (guiaInicioPasoCelular < 0) guiaInicioPasoCelular = ahora;
  int edad = ahora - guiaInicioPasoCelular;
  float xIcono = xObjetivo / escalaX;
  float yIcono = (yObjetivo + altoObjetivo / 2) / escalaY;
  float viaje = constrain(edad / 460.0f, 0, 1);
  viaje = viaje * viaje * (3 - 2 * viaje);
  float xClip = telefonoX / escalaX - 42 - 23 * (1 - viaje);
  float origenY = guiaCelularDesdeY < 0 ? yIcono - 40 : guiaCelularDesdeY;
  float salto = emocion ? 14 * abs(sin(edad * 0.012f)) * (1 - constrain(edad / 2300.0f, 0, 1)) : 0;
  float yClip = lerp(origenY, min(yIcono, REF_H - 52), viaje) - salto;
  guiaCelularYAnterior = yClip;
  guiaBurbujaCelularX = max(16, telefonoX / escalaX - GUIA_BURBUJA_CELULAR_W - 24);
  guiaBurbujaCelularY = constrain(yClip - 168, 92, REF_H - GUIA_BURBUJA_CELULAR_H - 24);

  pushStyle();
  pushMatrix();
  scale(escalaX, escalaY);
  rectMode(CORNER);
  dibujarBurbujaClip(guiaBurbujaCelularX, guiaBurbujaCelularY,
    GUIA_BURBUJA_CELULAR_W, GUIA_BURBUJA_CELULAR_H, xClip, yClip - 34,
    titulo, consejo, 16, 1);
  fill(26, 74, 80);
  textAlign(LEFT, CENTER);
  textSize(12);
  text(controles, guiaBurbujaCelularX + 18,
    guiaBurbujaCelularY + GUIA_BURBUJA_CELULAR_H - 16);
  float pixel = emocion ? 4.5f + salto * 0.05f : 4.1f;
  dibujarClipPixel(xClip - 8 * pixel, yClip - 10 * pixel, pixel, ahora, edad < 4500, 1);
  noStroke();
  if (viaje > 0.65f) dibujarFlechaClip(xIcono - 5, yIcono, 1, 255);
  noFill();
  stroke(255, 211, 122);
  strokeWeight(2);
  rect(xIcono - 2, yObjetivo / escalaY - 2, anchoObjetivo / escalaX + 4, altoObjetivo / escalaY + 4);
  popMatrix();
  popStyle();
}
