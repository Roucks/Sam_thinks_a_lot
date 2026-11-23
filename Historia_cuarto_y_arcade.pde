// HISTORIA DEL CUARTO Y ARCADE — CINEMÁTICA
// Fondo y sprites existentes. Clic, ENTER o ESPACIO para leer y avanzar.
// Reemplaza solo esta pestaña. Conserva Transicion_Nivel3 de la versión aprobada.
// Los chats de noche y mañana se leen dentro del sprite de celular del juego.
final int HISTORIA3_ARCADE = 18;
boolean t3Activa = false;
boolean t3ChatAbierto = false;
boolean t3ArcadePreparado = false;
boolean t3ContinuarPulsado = false;
// 0: grupo de noche; 1: guardar celular; 2: amanecer;
// 3: grupo de mañana; 5: llegada; 4: título original / juego.
int t3Etapa = 0;
int t3Pagina = 0;
int t3SaludLlegada = 100;
int t3InicioDescanso = 0;
int t3InicioEscena = 0;
int t3InicioLinea = 0;
int t3TickTexto = 0;
float t3Camara = 1.025f;
float t3PosSam = 0.40f;
float t3ScrollChat = 0;
float t3Escala = 1;
float t3OffsetX = 0;
float t3OffsetY = 0;

String[] t3HablantesNoche = { "GRUPO", "SAM", "CRISTIAN", "CRISTIAN", "CLARA", "MATEO", "SAM", "SAM" };
String[] t3TextoNoche = {
  "Los panas · Hoy",
  "¿Ustedes todavía están despiertos?",
  "¿Mañana vamos al arcade? Mi hermana pasó hoy y dice que pusieron otra máquina.",
  "Es de subir esquivando barriles. BARRELBOUND algo. Yo quiero probarla.",
  "Yo puedo después de desayunar. Pero espérenme en la entrada, ¿sí?",
  "De una. Mi papá me lleva. Sam, ¿tú puedes?",
  "Sí, yo les aviso apenas me levante.",
  "Bueno, me fui. No llenen esto de mensajes que mañana no encuentro nada jajaja."
};
String[] t3HablantesManana = { "CRISTIAN", "SAM", "CLARA", "CRISTIAN", "CLARA", "SAM", "MATEO", "SAM", "CLARA", "CRISTIAN", "SAM" };
String[] t3TextoManana = {
  "Ya estoy en la entrada. ¿Ustedes por dónde vienen?",
  "Ya voy, ya voy. ¿Hace mucho llegaste?",
  "¿Ya estás allá? Yo apenas voy bajando del carro.",
  "Sí. Creo que veo la máquina desde acá. Tiene como una pantalla verde.",
  "No te metas todavía. Espérame que no te veo.",
  "Todavía estoy en la casa. Ya me pongo los zapatos y salgo.",
  "Yo ya voy llegando. Cristian, levanta la mano a ver dónde estás.",
  "Oigan, ¿me dejan probar primero? Ustedes ya saben jugar más que yo.",
  "Sí. Nos turnamos y ya. Igual yo tampoco sé jugar ese.",
  "Bueno, pero después voy yo. Ya pedí turno.",
  "Listo. Ya me llevan. Guárdenme el puesto."
};

String t3Dialogo() {
  boolean flujoRetornoActivo = true;
  String flujoRetornoValor = null;

  if (t3Etapa == 1) {
    flujoRetornoValor = "Sam deja el celular cargando y se acerca a la cama. Mañana habrá tiempo para responder.";
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    if (t3Etapa == 2) {
      flujoRetornoValor = "";
      flujoRetornoActivo = false;
    }
    if (flujoRetornoActivo) {

      if (t3Etapa == 5) {
        flujoRetornoValor = "Cristian ya está mirando la máquina. Clara y Mateo esperan a Sam en la entrada.";
        flujoRetornoActivo = false;
      }
      if (flujoRetornoActivo) {

        if (t3Etapa == 4 && nv3_estadoMenu < 0 && nv3_pantalla == 0) {
          {
            flujoRetornoValor = nv3_conversaciones[0][nv3_dialogo][1] + " " + nv3_conversaciones[0][nv3_dialogo][2];
            flujoRetornoActivo = false;
          }
        }
        if (flujoRetornoActivo) {

          String linea = "";
          if (t3Etapa == 3)
            linea = t3TextoManana[t3Pagina];
          else
            linea = t3TextoNoche[t3Pagina];
          if (t3Etapa == 0) {
            if (t3Pagina == 0 && hcDecision == 3)
              linea = "Los panas · Hay mensajes nuevos en el grupo.";
            if (t3Pagina == 1) {
              if (t3SaludLlegada >= 70)
                linea = "Todavía estoy acá. Ya estaba por dejar el cel cargando. ¿Qué pasó?";
              else {
                if (t3SaludLlegada >= 40)
                  linea = "Estoy, pero ya casi no veo del sueño. ¿Qué andan haciendo?";
                else
                  linea = "Estoy. Me arden los ojos de mirar esta pantalla, pero no me da por soltarla.";
              }
            }
            if (t3Pagina == 6) {
              if (t3SaludLlegada >= 70)
                linea = "Sí, puedo. Mañana les escribo después de desayunar.";
              else {
                if (t3SaludLlegada >= 40)
                  linea = "Sí, mañana. Hoy ya me está dando sueño hasta para contestar.";
                else
                  linea = "Sí quiero ir. Pero mañana no me escriban tan temprano, que ando muerto del sueño.";
              }
            }
          }
          if (t3Etapa == 3) {
            if (t3Pagina == 1) {
              if (t3SaludLlegada >= 70)
                linea = "¿Ya llegaste? Yo ya desayuné. Me pongo los zapatos y salgo.";
              else {
                if (t3SaludLlegada >= 40)
                  linea = "¿Ya estás allá? Se me pegaron las cobijas. Voy a lavarme la cara y salgo.";
                else
                  linea = "¿Ya llegaron? No oí la alarma. Tengo la cabeza pesadísima.";
              }
            }
            if (t3Pagina == 5 && t3SaludLlegada < 40)
              linea = "Esperen, ¿ya entraron o no? Estoy leyendo todo cruzado del sueño.";
            if (t3Pagina == 8 && t3SaludLlegada < 40)
              linea = "No hemos entrado. Ven tranquilo. Y si llegas con sueño, te sientas un rato con nosotros.";
            if (t3Pagina == 10 && t3SaludLlegada < 40)
              linea = "Ya me llevan. Jueguen ustedes primero, que todavía estoy como ido.";
            // La disculpa no restaura mágicamente la reputación ni borra la decisión anterior.
            if (hcDecision == 3) {
              if (t3Pagina == 5)
                linea = "Mateo... lo que puse ayer fue una bobada. No debí decir eso de ti.";
              if (t3Pagina == 6)
                linea = "Sí me dio rabia. Encima todos lo vieron. No lo vuelvas a hacer.";
              if (t3Pagina == 7)
                linea = "Sí. Perdón. Te iba a decir allá, pero no quería llegar como si nada.";
              if (t3Pagina == 8)
                linea = "Bueno, los esperamos. Cristian, ¿dónde te metiste? No te veo.";
            }
          }
          {
            flujoRetornoValor = linea;
            flujoRetornoActivo = false;
          }

        }

      }

    }

  }

  return flujoRetornoValor;
}

String t3Hablante() {
  boolean flujoRetornoActivo = true;
  String flujoRetornoValor = null;

  if (t3Etapa == 1 || t3Etapa == 2 || t3Etapa == 5) {
    flujoRetornoValor = "NARRADOR";
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    if (t3Etapa == 4 && nv3_estadoMenu < 0 && nv3_pantalla == 0) {
      flujoRetornoValor = nv3_conversaciones[0][nv3_dialogo][0];
      flujoRetornoActivo = false;
    }
    if (flujoRetornoActivo) {

      if (t3Etapa == 3) {
        flujoRetornoValor = t3HablantesManana[t3Pagina];
        flujoRetornoActivo = false;
      }
      if (flujoRetornoActivo) {

        {
          flujoRetornoValor = t3HablantesNoche[t3Pagina];
          flujoRetornoActivo = false;
        }

      }

    }

  }

  return flujoRetornoValor;
}

void t3Reiniciar() {
  t3Activa = false;
  t3ChatAbierto = false;
  t3IntroActiva = false;
  finalNivel3Activo = false;
  t3ContinuarPulsado = false;
  t3ScrollChat = 0;
  if (t3ArcadePreparado) nv3_detenerTodaLaMusica();
  if (t3ArcadePreparado && nv3_videoListo && nv3_videoFondo != null) nv3_videoFondo.pause();
}

void t3EmpezarCuarto() {
  detenerMediosParaSaltoDebug();
  t3Reiniciar();
  hcActiva = false;
  t3Activa = true;
  t3ChatAbierto = true;
  t3Etapa = 0;
  t3Pagina = 0;
  t3SaludLlegada = round(bienestarDigital);
  t3InicioEscena = millis();
  t3Camara = 1.025f;
  t3PosSam = 0.40f;
  estadoActual = HISTORIA3_ARCADE;
  estadoDestino = HISTORIA3_ARCADE;
  enTransicion = false;
  alphaTransicion = 0;
  pisoActual = 2;
  direccionSam = "sur";
  samCaminando = false;
  if (fondoHabitacion == null && dataFile("habitacion.png").exists()) {
    fondoHabitacion = loadImage("habitacion.png");
  }
  if (marcoCelular == null && dataFile("marco_celular.png").exists()) {
    marcoCelular = loadImage("marco_celular.png");
  }
  t3ContinuarPulsado = keyPressed && (key == ENTER || key == RETURN || key == ' ');
  t3PrepararLinea();
  reproducirSfx(SFX_NOTIFICACION, 0.32f);
}

void t3PrepararLinea() {
  hcReiniciarTexto();
  ultimoTextoDialogo = t3Dialogo();
  t3TickTexto = millis();
  t3InicioLinea = millis();
}

void t3CambiarEscena(int escena) {
  t3Etapa = escena;
  t3Pagina = 0;
  t3InicioEscena = millis();
  t3ChatAbierto = escena == 0 || escena == 3;
  if (t3ChatAbierto) t3ScrollChat = 0;
  t3PrepararLinea();
}

void t3Avanzar() {
  boolean flujoRetornoActivo = true;

  if (!t3Activa) {
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    if (t3Etapa == 4) {
      if (!t3IntroActiva && !finalNivel3Activo && nv3_estadoMenu < 0 && nv3_pantalla == 0) {
        if (!dialogoCompletado) {
          charsVisibles = t3Dialogo().length();
          dialogoCompletado = true;
          {
            flujoRetornoActivo = false;
          }
        }
        if (flujoRetornoActivo) {

          nv3_continuar();
          t3PrepararLinea();

        }
      }
      if (flujoRetornoActivo) {

        {
          flujoRetornoActivo = false;
        }

      }
    }
    if (flujoRetornoActivo) {

      if (t3Etapa == 2) {
        if (millis() - t3InicioEscena >= 350)
          t3EmpezarManana();
        {
          flujoRetornoActivo = false;
        }
      }
      if (flujoRetornoActivo) {

        String texto = t3Dialogo();
        if (!texto.equals(ultimoTextoDialogo))
          t3PrepararLinea();
        if (!dialogoCompletado) {
          charsVisibles = texto.length();
          dialogoCompletado = true;
          {
            flujoRetornoActivo = false;
          }
        }
        if (flujoRetornoActivo) {

          if (t3Etapa == 0) {
            t3Pagina++;
            if (t3Pagina >= TAM_T3_TEXTO_NOCHE) {
              t3CambiarEscena(1);
              {
                flujoRetornoActivo = false;
              }
            }
            if (flujoRetornoActivo) {

              t3PrepararLinea();
              if (!t3Hablante().equals("SAM"))
                reproducirSfx(SFX_NOTIFICACION, 0.14f);
              {
                flujoRetornoActivo = false;
              }

            }
          }
          if (flujoRetornoActivo) {

            if (t3Etapa == 1) {
              t3CambiarEscena(2);
              t3InicioDescanso = millis();
              modificarBienestar(8, width / 2, 100 * escalaY);
              {
                flujoRetornoActivo = false;
              }
            }
            if (flujoRetornoActivo) {

              if (t3Etapa == 3) {
                t3Pagina++;
                if (t3Pagina >= TAM_T3_TEXTO_MANANA) {
                  t3CambiarEscena(5);
                  {
                    flujoRetornoActivo = false;
                  }
                }
                if (flujoRetornoActivo) {

                  t3PrepararLinea();
                  if (!t3Hablante().equals("SAM"))
                    reproducirSfx(SFX_NOTIFICACION, 0.14f);
                  {
                    flujoRetornoActivo = false;
                  }

                }
              }
              if (flujoRetornoActivo) {

                if (t3Etapa == 5) {
                  // Esta llamada reproduce el título y los cuadrados completos.
                  t3IniciarTituloNivel3();
                }

              }

            }

          }

        }

      }

    }

  }
}

void t3EmpezarManana() {
  t3PosSam = 0.40f;
  t3Camara = 1.025f;
  t3CambiarEscena(3);
  reproducirSfx(SFX_NOTIFICACION, 0.32f);
}

void t3ActualizarTexto() {
  String texto = t3Dialogo();
  if (!texto.equals(ultimoTextoDialogo)) t3PrepararLinea();
  int ahora = millis();
  float paso = constrain((ahora - t3TickTexto) / 16.67f, 0, 3);
  t3TickTexto = ahora;
  if (!dialogoCompletado) {
    charsVisibles = min(texto.length(), charsVisibles + velTypewriter * paso);
    if (int(charsVisibles) >= texto.length()) dialogoCompletado = true;
  }
}

boolean dibujarHistoria3() {
  boolean flujoRetornoActivo = true;
  boolean flujoRetornoValor = false;

  if (!t3Activa) {
    flujoRetornoValor = false;
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    escalaX = width / REF_W;
    escalaY = height / REF_H;
    if (t3Etapa == 4) {
      t3DibujarArcade();
    } else {
      t3DibujarCinematica();
    }
    dibujarAvisoLogro();
    {
      flujoRetornoValor = true;
      flujoRetornoActivo = false;
    }

  }

  return flujoRetornoValor;
}

void t3DibujarCinematica() {
  pushStyle();
  rectMode(CORNER);
  imageMode(CORNER);
  noTint();
  if (t3Etapa == 5 || t3Etapa == 4) {
    t3DibujarSalaPanoramica();
  } else {
    t3DibujarCuarto();
  }
  if (t3Etapa == 2) {
    t3DibujarAmanecer();
  } else {
    t3ActualizarTexto();
    if (t3Etapa == 0 || t3Etapa == 3) {
      t3DibujarChatEnCelular();
    } else {
      t3DibujarSubtitulos();
    }
  }
  t3DibujarEncuadre();
  float entrada = 1 - constrain((millis() - t3InicioEscena) / 520.0f, 0, 1);
  if (entrada > 0) {
    noStroke();
    fill(8, 10, 20, 255 * entrada);
    rect(0, 0, width, height);
  }
  popStyle();
}

void t3DibujarCuarto() {
  t3Camara = lerp(t3Camara, 1.055f, 0.0025f);
  if (fondoHabitacion != null && fondoHabitacion.width > 0 && fondoHabitacion.height > 0) {
    float ajuste = max(width / float(fondoHabitacion.width), height / float(fondoHabitacion.height));
    float ancho = fondoHabitacion.width * ajuste * t3Camara;
    float alto = fondoHabitacion.height * ajuste * t3Camara;
    float desplazamiento = sin((millis() - t3InicioEscena) * 0.00015f) * width * 0.006f;
    image(fondoHabitacion, (width - ancho) / 2 + desplazamiento, (height - alto) / 2, ancho, alto);
  } else {
    background(34, 34, 55);
  }
  noStroke();
  fill(12, 21, 52, 70);
  if (t3Etapa == 3) fill(255, 187, 105, 20);
  rect(0, 0, width, height);
  if (t3Etapa != 2) t3DibujarSamCinematica();
}

void t3DibujarSamCinematica() {
  float objetivo = 0.40f;
  if (t3Etapa == 1) objetivo = 0.61f;
  boolean caminando = abs(t3PosSam - objetivo) > 0.004f;
  t3PosSam = lerp(t3PosSam, objetivo, 0.035f);
  PImage sam = spriteIdle[1];
  if (caminando) sam = spriteCaminarEste[(frameCount / 6) % 4];
  if (sam != null && sam.width > 0 && sam.height > 0) {
    float alto = height * 0.23f;
    float ancho = sam.width * alto / sam.height;
    float x = width * t3PosSam - ancho / 2;
    float y = height * 0.46f;
    noStroke();
    fill(0, 40);
    ellipse(x + ancho / 2, y + alto - 3, ancho * 0.7f, 12 * escalaY);
    image(sam, x, y, ancho, alto);
  }
}

void t3DibujarSalaPanoramica() {
  if (nv3_fuenteJuego == null) {
    nv3_fuenteJuego = fontBody;
    if (nv3_fuenteJuego == null) nv3_fuenteJuego = createFont("Monospaced", 16);
  }
  float escala = min(width / 960.0f, height / 600.0f);
  float x = (width - 960 * escala) / 2;
  float y = height * 0.75f - 559 * escala;
  pushMatrix();
  translate(x, y);
  scale(escala);
  nv3_dibujarSala();
  popMatrix();
}

void t3DibujarAmanecer() {
  float tiempo = (millis() - t3InicioEscena) / 1000.0f;
  noStroke();
  fill(8, 12, 25, 255 * constrain(tiempo / 0.8f, 0, 1));
  rect(0, 0, width, height);
  float alfa = 255 * min(constrain((tiempo - 0.55f) / 0.6f, 0, 1), constrain((3 - tiempo) / 0.55f, 0, 1));
  if (fontBody != null) textFont(fontBody);
  textAlign(CENTER, CENTER);
  textSize(28 * min(escalaX, escalaY));
  fill(242, 232, 212, alfa);
  text("A la mañana siguiente...", width / 2, height * 0.49f);
  if (tiempo >= 3) t3EmpezarManana();
}

void t3DibujarSubtitulos() {
  noStroke();
  // Sombra degradada: la imagen sigue visible, sin paneles que tapen el cuarto.
  int arriba = round(height * 0.54f);
  int abajo = round(height * 0.945f);
  for (int y = arriba; y < abajo; y++) {
    float fuerza = constrain((y - arriba) / (height * 0.27f), 0, 1);
    fill(9, 12, 24, 226 * fuerza);
    rect(0, y, width, 1);
  }
  float escala = min(escalaX, escalaY);
  float aparicion = constrain((millis() - t3InicioLinea) / 220.0f, 0, 1);
  float x = width * 0.085f;
  float y = height * 0.735f + 8 * escala * (1 - aparicion);
  String autor = t3Hablante();
  int acento = color(255, 212, 132);
  if (autor.equals("CLARA")) acento = color(241, 174, 213);
  if (autor.equals("CRISTIAN")) acento = color(151, 220, 245);
  if (autor.equals("MATEO")) acento = color(234, 192, 140);
  if (fontBold != null) textFont(fontBold);
  textAlign(LEFT, TOP);
  textSize(16 * escala);
  fill(acento, 255 * aparicion);
  rect(x, y + 1 * escala, 3 * escala, 17 * escala, 1 * escala);
  String etiqueta = autor;
  if (t3Etapa == 0 || t3Etapa == 3) etiqueta = autor + " · LOS PANAS";
  text(etiqueta, x + 15 * escala, y);
  if (fontBody != null) textFont(fontBody);
  textSize(27 * escala);
  fill(249, 246, 251, 255 * aparicion);
  t3TextoEstable(t3Dialogo(), x, y + 35 * escala, width * 0.82f, 36 * escala);
}

// Se calcula cada línea con el texto completo para evitar que salte mientras escribe.
void t3TextoEstable(String contenido, float x, float y, float ancho, float salto) {
  String[] palabras = split(contenido, ' ');
  String linea = "";
  int consumidos = 0;
  for (int i = 0; i < contarCadenas(palabras); i++) {
    String candidata = palabras[i];
    if (linea.length() > 0) candidata = linea + " " + palabras[i];
    if (textWidth(candidata) > ancho && linea.length() > 0) {
      int visibles = constrain(int(charsVisibles) - consumidos, 0, linea.length());
      text(linea.substring(0, visibles), x, y);
      consumidos += linea.length() + 1;
      y += salto;
      linea = palabras[i];
    } else {
      linea = candidata;
    }
  }
  int visibles = constrain(int(charsVisibles) - consumidos, 0, linea.length());
  text(linea.substring(0, visibles), x, y);
}

void t3DibujarEncuadre() {
  noStroke();
  fill(8, 10, 18);
  rect(0, 0, width, height * 0.055f);
  rect(0, height * 0.945f, width, height * 0.055f);
  if (fontBody != null) textFont(fontBody);
  textSize(13 * min(escalaX, escalaY));
  textAlign(LEFT, CENTER);
  fill(213, 210, 220);
  String lugar = "CUARTO DE SAM · NOCHE";
  if (t3Etapa == 3) lugar = "CUARTO DE SAM · MAÑANA";
  if (t3Etapa == 1 || t3Etapa == 2) lugar = "FIN DEL DÍA";
  if (t3Etapa == 5 || t3Etapa == 4) lugar = "ARCADE · LOS PANAS";
  text(lugar, width * 0.06f, height * 0.027f);
  if (t3Etapa != 2) {
    textAlign(RIGHT, CENTER);
    String ayuda = "CLIC / ENTER / ESPACIO · continuar";
    if (!dialogoCompletado) ayuda = "CLIC / ENTER / ESPACIO · completar texto";
    text(ayuda, width * 0.94f, height * 0.972f);
    textAlign(LEFT, CENTER);
    int cantidad = TAM_T3_TEXTO_NOCHE;
    if (t3Etapa == 3) cantidad = TAM_T3_TEXTO_MANANA;
    if (t3Etapa == 4) cantidad = 5;
    if (t3Etapa == 0 || t3Etapa == 3) text("Mensaje " + (t3Pagina + 1) + " / " + cantidad, width * 0.06f, height * 0.972f);
  }
}

// Punto de entrada que usan el HUD y Shift+K en el proyecto original.
// Al terminar el título original, este mismo punto abre el juego.
void t3EntrarArcade() {
  boolean flujoRetornoActivo = true;

  if (t3IntroActiva) {
    t3AbrirJuegoArcade();
    {
      flujoRetornoActivo = false;
    }
  }
  if (flujoRetornoActivo) {

    t3EmpezarCuarto();

  }
}

void t3AbrirJuegoArcade() {
  detenerMediosParaSaltoDebug();
  t3IntroActiva = false;
  finalNivel3Activo = false;
  hcActiva = false;
  t3Activa = true;
  t3ChatAbierto = false;
  t3Etapa = 4;
  estadoActual = HISTORIA3_ARCADE;
  estadoDestino = HISTORIA3_ARCADE;
  enTransicion = false;
  alphaTransicion = 0;
  if (!t3ArcadePreparado) {
    nv3_setup();
    t3ArcadePreparado = true;
  } else {
    nv3_reiniciarPartida();
  }
  nv3_modoDebug = modoDebug;
  nv3_pantalla = 0;
  nv3_estadoMenu = -1;
  nv3_dialogo = 0;
  nv3_ultimoTiempo = millis();
  for (int i = 0; i < TAM_NV3_RETENIDAS; i++) nv3_retenidas[i] = false;
  t3InicioEscena = millis();
  t3PrepararLinea();
  t3ContinuarPulsado = keyPressed && (key == ENTER || key == RETURN || key == ' ');
  t3MedidasArcade();
}

void t3EntrarArcadeDebug() {
  t3SaludLlegada = round(bienestarDigital);
  t3AbrirJuegoArcade();
  nv3_prepararMenu();
}

void t3MedidasArcade() {
  t3Escala = min(width / 960.0f, height / 800.0f);
  t3OffsetX = (width - 960 * t3Escala) / 2;
  t3OffsetY = (height - 800 * t3Escala) / 2;
  nv3MouseX = round((mouseX - t3OffsetX) / t3Escala);
  nv3MouseY = round((mouseY - t3OffsetY) / t3Escala);
}

void t3DibujarArcade() {
  boolean flujoRetornoActivo = true;

  if (t3IntroActiva) {
    t3DibujarTransicion();
    {
      flujoRetornoActivo = false;
    }
  }
  if (flujoRetornoActivo) {

    if (finalNivel3Activo) {
      dibujarFinalNivel3();
      {
        flujoRetornoActivo = false;
      }
    }
    if (flujoRetornoActivo) {

      nv3_modoDebug = modoDebug;
      if (nv3_estadoMenu < 0 && nv3_pantalla == 0) {
        nv3_actualizarMusicaSegunEstado();
        nv3_ultimoTiempo = millis();
        t3DibujarCinematica();
        {
          flujoRetornoActivo = false;
        }
      }
      if (flujoRetornoActivo) {

        t3MedidasArcade();
        if (nv3_videoListo && nv3_videoFondo != null && nv3_videoFondo.available())
          nv3_videoFondo.read();
        if (nv3_estadoMenu == 0)
          dibujarFondoArcadeAnimado();
        if (nv3_estadoMenu != 0)
          background(12, 15, 25);
        pushStyle();
        imageMode(CORNER);
        rectMode(CORNER);
        noTint();
        clip(t3OffsetX, t3OffsetY, 960 * t3Escala, 800 * t3Escala);
        pushMatrix();
        translate(t3OffsetX, t3OffsetY);
        scale(t3Escala);
        nv3_draw();
        popMatrix();
        noClip();
        popStyle();

      }

    }

  }
}

boolean teclaHistoria3() {
  boolean flujoRetornoActivo = true;
  boolean flujoRetornoValor = false;

  if (!t3Activa) {
    flujoRetornoValor = false;
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    if (key == ESC) {
      key = 0;
      t3Reiniciar();
      estadoActual = MENU;
      estadoDestino = MENU;
      {
        flujoRetornoValor = true;
        flujoRetornoActivo = false;
      }
    }
    if (flujoRetornoActivo) {

      if (t3IntroActiva) {
        flujoRetornoValor = true;
        flujoRetornoActivo = false;
      }
      if (flujoRetornoActivo) {

        if (keyCode == 114) {
          modoDebug = !modoDebug;
          {
            flujoRetornoValor = true;
            flujoRetornoActivo = false;
          }
        }
        if (flujoRetornoActivo) {

          if (modoDebug && key == 'K') {
            t3EmpezarCuarto();
            {
              flujoRetornoValor = true;
              flujoRetornoActivo = false;
            }
          }
          if (flujoRetornoActivo) {

            if (modoDebug && key == 'L') {
              t3EntrarArcadeDebug();
              {
                flujoRetornoValor = true;
                flujoRetornoActivo = false;
              }
            }
            if (flujoRetornoActivo) {

              boolean continuar = key == ENTER || key == RETURN || key == ' ';
              boolean lectura = t3Etapa != 4 || (nv3_estadoMenu < 0 && nv3_pantalla == 0);
              if (finalNivel3Activo) {
                if (continuar && !t3ContinuarPulsado) {
                  avanzarFinalNivel3();
                  t3ContinuarPulsado = true;
                }
                {
                  flujoRetornoValor = true;
                  flujoRetornoActivo = false;
                }
              }
              if (flujoRetornoActivo) {

                if (lectura) {
                  if (continuar && !t3ContinuarPulsado) {
                    t3Avanzar();
                    t3ContinuarPulsado = true;
                  }
                  {
                    flujoRetornoValor = true;
                    flujoRetornoActivo = false;
                  }
                }
                if (flujoRetornoActivo) {

                  if (continuar && nv3_estadoMenu == 0) {
                    if (!t3ContinuarPulsado)
                      nv3_iniciarZoom();
                    t3ContinuarPulsado = true;
                    {
                      flujoRetornoValor = true;
                      flujoRetornoActivo = false;
                    }
                  }
                  if (flujoRetornoActivo) {

                    if (continuar && nv3_estadoMenu == 2) {
                      if (!t3ContinuarPulsado) {
                        if (!nv3_dialogosArcadeTerminados)
                          nv3_avanzarDialogoArcade();
                        else
                          nv3_irASeleccionDePersonaje();
                        t3ContinuarPulsado = true;
                      }
                      {
                        flujoRetornoValor = true;
                        flujoRetornoActivo = false;
                      }
                    }
                    if (flujoRetornoActivo) {

                      nv3_keyPressed();
                      {
                        flujoRetornoValor = true;
                        flujoRetornoActivo = false;
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

  return flujoRetornoValor;
}

boolean soltarTeclaHistoria3() {
  boolean flujoRetornoActivo = true;
  boolean flujoRetornoValor = false;

  if (!t3Activa) {
    flujoRetornoValor = false;
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    if (key == ENTER || key == RETURN || key == ' ')
      t3ContinuarPulsado = false;
    if (t3Etapa == 4 && !t3IntroActiva && !finalNivel3Activo)
      nv3_keyReleased();
    {
      flujoRetornoValor = true;
      flujoRetornoActivo = false;
    }

  }

  return flujoRetornoValor;
}

boolean clicHistoria3() {
  boolean flujoRetornoActivo = true;
  boolean flujoRetornoValor = false;

  if (!t3Activa) {
    flujoRetornoValor = false;
    flujoRetornoActivo = false;
  }
  if (flujoRetornoActivo) {

    if (mouseButton != LEFT) {
      flujoRetornoValor = true;
      flujoRetornoActivo = false;
    }
    if (flujoRetornoActivo) {

      if (t3IntroActiva) {
        flujoRetornoValor = true;
        flujoRetornoActivo = false;
      }
      if (flujoRetornoActivo) {

        if (finalNivel3Activo) {
          avanzarFinalNivel3();
          {
            flujoRetornoValor = true;
            flujoRetornoActivo = false;
          }
        }
        if (flujoRetornoActivo) {

          if (t3Etapa != 4 || (nv3_estadoMenu < 0 && nv3_pantalla == 0)) {
            t3Avanzar();
            {
              flujoRetornoValor = true;
              flujoRetornoActivo = false;
            }
          }
          if (flujoRetornoActivo) {

            if (nv3_estadoMenu == 0) {
              nv3_iniciarZoom();
              {
                flujoRetornoValor = true;
                flujoRetornoActivo = false;
              }
            }
            if (flujoRetornoActivo) {

              if (nv3_estadoMenu == 2) {
                if (!nv3_dialogosArcadeTerminados)
                  nv3_avanzarDialogoArcade();
                else
                  nv3_irASeleccionDePersonaje();
                {
                  flujoRetornoValor = true;
                  flujoRetornoActivo = false;
                }
              }
              if (flujoRetornoActivo) {

                t3MedidasArcade();
                nv3_mousePressed();
                {
                  flujoRetornoValor = true;
                  flujoRetornoActivo = false;
                }

              }

            }

          }

        }

      }

    }

  }

  return flujoRetornoValor;
}

// Mismas proporciones de hcMedidasCelular(): se alinea el chat con el hueco
// real de marco_celular.png. El teléfono queda a un lado de la cinemática.
void t3MedidasCelularCinematica() {
  telefonoAlto = min(height * 0.86f, width * 0.80f * (1600.0f / 888.0f));
  telefonoAncho = telefonoAlto * (888.0f / 1600.0f);
  float centroX = width * 0.76f;
  if (width < height * 1.25f) centroX = width / 2;
  telefonoX = centroX - telefonoAncho / 2;
  float entrada = constrain((millis() - t3InicioEscena) / 480.0f, 0, 1);
  entrada = entrada * entrada * (3 - 2 * entrada);
  telefonoY = (height - telefonoAlto) / 2 + height * 0.025f * (1 - entrada);
  pantallaW = telefonoAncho * (660.0f / 888.0f);
  pantallaH = telefonoAlto * (1020.0f / 1600.0f);
  pantallaX = telefonoX + telefonoAncho * (114.0f / 888.0f);
  pantallaY = telefonoY + telefonoAlto * (294.0f / 1600.0f);
}

void t3DibujarChatEnCelular() {
  t3MedidasCelularCinematica();
  pushStyle();
  rectMode(CORNER);
  imageMode(CORNER);
  noStroke();

  // El marco original se dibuja una sola vez, al final, encima del chat.
  fill(COLOR_APP_BG);
  rect(pantallaX, pantallaY, pantallaW, pantallaH);

  // El recorte afecta solamente a las burbujas, dentro de la pantalla.
  // La cabecera y el pie se dibujan después y permanecen fijos.
  clip(pantallaX, pantallaY + pantallaH * (64.0f / 500.0f),
    pantallaW, pantallaH * (394.0f / 500.0f));
  pushMatrix();
  translate(pantallaX, pantallaY);
  scale(pantallaW / 320.0f, pantallaH / 500.0f);
  hcUsarFuente();
  textAlign(LEFT, TOP);
  textSize(17);
  int paginaActual = t3Pagina;
  float total = 0;
  for (int i = 0; i <= paginaActual; i++) {
    t3Pagina = i;
    total += hcContarLineas(t3Dialogo(), 252) * 23 + 54;
  }
  float destino = max(0, total - 380);
  t3ScrollChat = lerp(t3ScrollChat, destino, 0.22f);
  float y = 72 - t3ScrollChat;
  for (int i = 0; i <= paginaActual; i++) {
    t3Pagina = i;
    String mensaje = t3Dialogo();
    String autor = t3Hablante();
    textSize(17);
    float alto = hcContarLineas(mensaje, 252) * 23 + 44;
    float x = 10;
    if (autor.equals("SAM")) x = 30;
    float aparicion = 1;
    if (i == paginaActual) aparicion = constrain((millis() - t3InicioLinea) / 180.0f, 0, 1);
    float burbujaY = y + 6 * (1 - aparicion);
    fill(COLOR_CARD, 255 * aparicion);
    if (autor.equals("SAM")) fill(222, 226, 243, 255 * aparicion);
    rect(x, burbujaY, 280, alto, 10);
    if (fontBold != null) textFont(fontBold);
    textSize(12);
    fill(COLOR_PRIMARY_DARK, 255 * aparicion);
    text(autor, x + 14, burbujaY + 10);
    hcUsarFuente();
    textSize(17);
    fill(COLOR_TEXT_DARK, 255 * aparicion);
    if (i == paginaActual) {
      t3TextoEstable(mensaje, x + 14, burbujaY + 31, 252, 23);
    } else {
      hcTextoEnLineas(mensaje, x + 14, burbujaY + 31, 252, 23);
    }
    y += alto + 10;
  }
  t3Pagina = paginaActual;
  popMatrix();
  noClip();

  // Misma identidad visual del celular y Pixagram del proyecto.
  pushMatrix();
  translate(pantallaX, pantallaY);
  scale(pantallaW / 320.0f, pantallaH / 500.0f);
  fill(COLOR_PRIMARY);
  rect(0, 0, 320, 62);
  if (fontBold != null) textFont(fontBold);
  textAlign(LEFT, TOP);
  textSize(18);
  fill(255);
  text("Los panas", 16, 10);
  hcUsarFuente();
  textSize(11);
  fill(232, 227, 242);
  text("Sam, Clara, Mateo y Cristian", 16, 36);
  fill(COLOR_APP_BG);
  rect(0, 460, 320, 40);
  stroke(COLOR_BORDER);
  strokeWeight(1);
  line(12, 460, 308, 460);
  noStroke();
  fill(COLOR_TEXT_MUTED);
  textAlign(CENTER, CENTER);
  textSize(11);
  int cantidad = TAM_T3_TEXTO_NOCHE;
  if (t3Etapa == 3) cantidad = TAM_T3_TEXTO_MANANA;
  text("Mensaje " + (paginaActual + 1) + " de " + cantidad, 160, 480);
  popMatrix();
  noTint();
  if (marcoCelular != null && marcoCelular.width > 0) {
    image(marcoCelular, telefonoX, telefonoY, telefonoAncho, telefonoAlto);
  }
  popStyle();
}
