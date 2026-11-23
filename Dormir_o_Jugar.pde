// =========================================================================
// PESTAÑA: ModalDormir.pde
// VENTANA FLOTANTE: DECISIÓN "¿QUEDARSE JUGANDO O IRSE A DORMIR?"
// =========================================================================

// Variables globales de estado del modal
boolean mostrandoModalDormir = false;
int hoverOpcionModalDormir = 0; // 0 = ninguno, 1 = jugar, 2 = dormir

// -------------------------------------------------------------------------
// RENDERIZADO Y DIBUJO DEL MODAL
// -------------------------------------------------------------------------
void dibujarModalDormir() {
  if (mostrandoModalDormir) {
    pushStyle();

    // 1. Oscurecer fondo con overlay suave
    fill(8, 12, 22, 220);
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, height);

    // 2. Tarjeta flotante centrada
    float modalW = 490.0f * escalaX;
    float modalH = 320.0f * escalaY;
    float modalX = (width - modalW) / 2.0f;
    float modalY = (height - modalH) / 2.0f;

    // Sombra exterior
    fill(0, 80);
    rect(modalX + 5, modalY + 7, modalW, modalH, 18);

    // Fondo de la tarjeta (azul oscuro acorde a la interfaz)
    fill(22, 30, 46);
    stroke(56, 189, 248);
    strokeWeight(2.2f * escalaX);
    rect(modalX, modalY, modalW, modalH, 16);

    // 3. Botón cerrar [X] (esquina superior derecha)
    float btnCerrarX = modalX + modalW - 28.0f * escalaX;
    float btnCerrarY = modalY + 24.0f * escalaY;
    boolean hoverCerrar = dist(mouseX, mouseY, btnCerrarX, btnCerrarY) < 16.0f * escalaX;
    
    fill(hoverCerrar ? color(239, 68, 68) : color(71, 85, 105));
    noStroke();
    ellipse(btnCerrarX, btnCerrarY, 24.0f * escalaX, 24.0f * escalaX);
    
    fill(255);
    textAlign(CENTER, CENTER);
    if (fontBold != null) textFont(fontBold);
    textSize(12.0f * escalaX);
    text("X", btnCerrarX, btnCerrarY - 1);

    // 4. Encabezado y textos explicativos
    float tituloY = modalY + 38.0f * escalaY;
    fill(255);
    textAlign(CENTER, CENTER);
    if (fontTitle != null) textFont(fontTitle);
    else { if (fuenteComic != null) textFont(fuenteComic); }
    textSize(22.0f * escalaX);
    text("¿UNA PARTIDA MÁS?", width / 2.0f, tituloY);

    if (fuenteCelular != null) textFont(fuenteCelular);
    else { if (fontBody != null) textFont(fontBody); }
    fill(203, 213, 225);
    textSize(13.0f * escalaX);
    String sub1 = dia1Terminado ? "Sam se acomoda en la cama con el celular." : "Sam se mete bajo las cobijas con su celular nuevo.";
    text(sub1, width / 2.0f, modalY + 68.0f * escalaY);
    
    fill(148, 163, 184);
    textSize(11.5f * escalaX);
    text("Todavía queda un juego por probar... aunque ya le da sueño.", width / 2.0f, modalY + 88.0f * escalaY);

    // 5. Dimensiones base de las opciones
    float opcW = modalW - 44.0f * escalaX;
    float opcH = 74.0f * escalaY;
    float opcX = modalX + 22.0f * escalaX;

    // ===== OPCIÓN 1: QUEDARSE JUGANDO =====
    float opc1Y = modalY + 114.0f * escalaY;
    boolean hoverOp1 = (mouseX >= opcX && mouseX <= opcX + opcW && mouseY >= opc1Y && mouseY <= opc1Y + opcH);

    fill(hoverOp1 ? color(30, 42, 62) : color(18, 25, 38));
    stroke(hoverOp1 ? color(96, 165, 250) : color(51, 65, 85));
    strokeWeight(hoverOp1 ? 2.2f * escalaX : 1.4f * escalaX);
    rect(opcX, opc1Y, opcW, opcH, 12);

    // Ícono mando de videojuegos
    float icon1X = opcX + 34.0f * escalaX;
    float icon1Y = opc1Y + opcH / 2.0f;
    noStroke();
    fill(37, 99, 235, 45);
    ellipse(icon1X, icon1Y, 34.0f * escalaX, 34.0f * escalaX);

    fill(hoverOp1 ? color(96, 165, 250) : color(147, 197, 253));
    rect(icon1X - 11.0f * escalaX, icon1Y - 7.0f * escalaY, 22.0f * escalaX, 14.0f * escalaY, 4.0f * escalaX);
    fill(24, 32, 47);
    rect(icon1X - 7.5f * escalaX, icon1Y - 4.0f * escalaY, 5.0f * escalaX, 8.0f * escalaY, 1);
    rect(icon1X - 9.0f * escalaX, icon1Y - 2.5f * escalaY, 8.0f * escalaX, 5.0f * escalaY, 1);
    fill(248, 113, 113);
    ellipse(icon1X + 4.0f * escalaX, icon1Y + 2.0f * escalaY, 3.5f * escalaX, 3.5f * escalaX);
    fill(250, 204, 21);
    ellipse(icon1X + 7.5f * escalaX, icon1Y - 2.0f * escalaY, 3.5f * escalaX, 3.5f * escalaX);

    // Textos Opción 1
    textAlign(LEFT, CENTER);
    fill(hoverOp1 ? color(255) : color(226, 232, 240));
    if (fontBold != null) textFont(fontBold);
    else { if (fuenteComic != null) textFont(fuenteComic); }
    textSize(15.0f * escalaX);
    text("Jugar un rato más", opcX + 62.0f * escalaX, opc1Y + 24.0f * escalaY);

    fill(148, 163, 184);
    if (fuenteCelular != null) textFont(fuenteCelular);
    else { if (fontBody != null) textFont(fontBody); }
    textSize(11.5f * escalaX);
    text("«Una más y ya. Esta sí es la última.»", opcX + 62.0f * escalaX, opc1Y + 48.0f * escalaY);

    // ===== OPCIÓN 2: IRSE A DORMIR =====
    float opc2Y = modalY + 202.0f * escalaY;
    boolean hoverOp2 = (mouseX >= opcX && mouseX <= opcX + opcW && mouseY >= opc2Y && mouseY <= opc2Y + opcH);

    fill(hoverOp2 ? color(18, 48, 38) : color(16, 32, 27));
    stroke(hoverOp2 ? color(52, 211, 153) : color(34, 197, 94));
    strokeWeight(hoverOp2 ? 2.2f * escalaX : 1.4f * escalaX);
    rect(opcX, opc2Y, opcW, opcH, 12);

    // Ícono luna de noche
    float icon2X = opcX + 34.0f * escalaX;
    float icon2Y = opc2Y + opcH / 2.0f;
    noStroke();
    fill(16, 185, 129, 45);
    ellipse(icon2X, icon2Y, 34.0f * escalaX, 34.0f * escalaX);

    fill(250, 204, 21);
    ellipse(icon2X - 2.0f * escalaX, icon2Y, 16.0f * escalaX, 16.0f * escalaX);
    fill(hoverOp2 ? color(18, 48, 38) : color(16, 32, 27));
    ellipse(icon2X + 2.5f * escalaX, icon2Y - 2.5f * escalaY, 14.0f * escalaX, 14.0f * escalaY);
    fill(255, 235, 130);
    ellipse(icon2X + 7.0f * escalaX, icon2Y + 4.0f * escalaY, 2.5f * escalaX, 2.5f * escalaX);

    // Textos Opción 2
    textAlign(LEFT, CENTER);
    fill(hoverOp2 ? color(255) : color(209, 250, 229));
    if (fontBold != null) textFont(fontBold);
    else { if (fuenteComic != null) textFont(fuenteComic); }
    textSize(15.0f * escalaX);
    if (dia1Terminado) {
      text("Irse a dormir", opcX + 62.0f * escalaX, opc2Y + 24.0f * escalaY);
    } else {
      text("Irse a dormir", opcX + 62.0f * escalaX, opc2Y + 24.0f * escalaY);
    }

    fill(110, 231, 183);
    if (fuenteCelular != null) textFont(fuenteCelular);
    else { if (fontBody != null) textFont(fontBody); }
    textSize(11.5f * escalaX);
    if (dia1Terminado) {
      text("«Ya me dio sueño. Mañana sigo.»", opcX + 62.0f * escalaX, opc2Y + 48.0f * escalaY);
    } else {
      text("«Mañana hay colegio. Mejor me duermo.»", opcX + 62.0f * escalaX, opc2Y + 48.0f * escalaY);
    }

    // Actualizar estado de hover
    if (hoverOp1) hoverOpcionModalDormir = 1;
    else { if (hoverOp2) hoverOpcionModalDormir = 2;
    else hoverOpcionModalDormir = 0; }

    popStyle();
  }
}

// -------------------------------------------------------------------------
// PROCESAMIENTO DE CLICS DEL MODAL
// -------------------------------------------------------------------------
boolean procesarClicModalDormir() {
  boolean consumido = false;
  if (mostrandoModalDormir) {
    consumido = true; // Bloquea los clics al fondo del juego mientras el modal esté abierto xd

    float modalW = 490.0f * escalaX;
    float modalH = 320.0f * escalaY;
    float modalX = (width - modalW) / 2.0f;
    float modalY = (height - modalH) / 2.0f;

    // Clic en botón cerrar [X]
    float btnCerrarX = modalX + modalW - 28.0f * escalaX;
    float btnCerrarY = modalY + 24.0f * escalaY;
    if (dist(mouseX, mouseY, btnCerrarX, btnCerrarY) < 18.0f * escalaX) {
      mostrandoModalDormir = false;
      if (sonidoClic != null) { sonidoClic.amp(0.3f * volMaster); sonidoClic.play(); }
    } else {
      float opcW = modalW - 44.0f * escalaX;
      float opcH = 74.0f * escalaY;
      float opcX = modalX + 22.0f * escalaX;
      float opc1Y = modalY + 114.0f * escalaY;
      float opc2Y = modalY + 202.0f * escalaY;

      // Clic en Opción 1: "Jugar un rato más"
      if (mouseX >= opcX && mouseX <= opcX + opcW && mouseY >= opc1Y && mouseY <= opc1Y + opcH) {
        mostrandoModalDormir = false;
        modificarBienestar(-15, width / 2.0f, height / 2.0f - 40.0f * escalaY);
        modificarReputacion(-8, width / 2.0f, height / 2.0f - 80.0f * escalaY);
        activarScreenShake(10, 5.0f);
        crearPopupFlotante("Sam vuelve a abrir el juego.", width / 2.0f, height / 2.0f - 120.0f * escalaY, color(96, 165, 250));
        
        if (sonidoClic != null) { sonidoClic.amp(0.35f * volMaster); sonidoClic.play(); }
        
        if (estadoActual == EXPLORACION) {
          estadoDestino = NIVEL1;
          enHome = true;
          appAbierta = "";
          enTransicion = true;
        }
      } else {
        // Clic en Opción 2: "Irse a dormir"
        if (mouseX >= opcX && mouseX <= opcX + opcW && mouseY >= opc2Y && mouseY <= opc2Y + opcH) {
          mostrandoModalDormir = false;
          bienestarDigital = min(100, bienestarDigital + 25);
          puntosJugador += 25;
          generarParticulasCelebracion(width / 2.0f, height / 2.0f, color(52, 211, 153), 20);
          
          if (sonidoClic != null) { sonidoClic.amp(0.4f * volMaster); sonidoClic.play(); }

          if (!penaltisJugados) {
            paginaEscuela = 0;
            ultimoTextoDialogo = "";
            charsVisibles = 0;
            dialogoCompletado = false;
            crearPopupFlotante("Sam deja el celular en la mesita y cierra los ojos.", width / 2.0f, 100.0f * escalaY, color(52, 211, 153));
            estadoDestino = NOVELA_ESCUELA;
            enTransicion = true;
          } else { if (!dia1Terminado) {
            timerFinDia1 = 0;
            estadoDestino = FIN_DIA_1;
            enTransicion = true;
          } else {
            // Acostado en la cama al final del día 1: pasa a transición temporal y Nivel 2
            timerTransicionTemporal = 0;
            crearPopupFlotante("Sam deja el celular en la mesita y cierra los ojos.", width / 2.0f, height / 2.0f, color(52, 211, 153));
            estadoDestino = TRANSICION_TEMPORAL;
            enTransicion = true;
          } }
        } else {
          // Clic fuera de la tarjeta: cerrar sin realizar acción
          if (mouseX < modalX || mouseX > modalX + modalW || mouseY < modalY || mouseY > modalY + modalH) {
            mostrandoModalDormir = false;
          }
        }
      }
    }
  }

  return consumido;
}
