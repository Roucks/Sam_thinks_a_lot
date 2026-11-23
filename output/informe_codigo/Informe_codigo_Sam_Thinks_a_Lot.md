# Informe explicativo del código de Sam Thinks a Lot
Guía de estudio para la sustentación de Algoritmia y Programación II

DigitalBalance · Entrega 3 · Código revisado el 14 de noviembre de 2026 · Versión con Feria Gamer

Este informe está dirigido a los cuatro integrantes. Explica la organización del sketch, sus algoritmos y las conexiones entre pantallas, minijuegos, decisiones y archivos. Describe la versión actual después de incorporar Feria Gamer y corregir los retornos. El objetivo es que puedan seguir una acción desde la entrada del usuario hasta su consecuencia, en vez de memorizar procedimientos gráficos.

Cómo estudiarlo: primero lean juntos las secciones 1 a 4. Después profundicen en sus bloques y enseñen su parte al resto. Todos deben dominar estados, arreglos paralelos, métricas y persistencia. El reparto y los ejercicios de esta guía son propuestas de preparación, no atribuciones de autoría.

Revisión de retornos: se sustituyeron los retornos tempranos de 26 funciones por banderas de control y resultados locales. La revisión estructural actual no detecta return dentro de condicionales ni ciclos. Las funciones con resultado conservan un único retorno al final. También se comprobó la ausencia de charAt, else if, clases personalizadas y consultas .length de arreglos en las pestañas PDE. Se usaron 354 comparaciones de comportamiento sobre diálogos, avance, teclado y clics, además de comprobaciones de regresión y de feria. Esto no sustituye ensayar el juego completo en el equipo de la exposición.

Contenido: arquitectura, ciclo de ejecución, estados, datos, exploración, niveles, narrativa, minijuegos, métricas, Recuerdos, guardado, efectos, conceptos de AyP 2, plan de siete días y preguntas de práctica.

---
# 1 Arquitectura y pestañas
Las pestañas PDE forman un mismo sketch. Separarlas organiza el código, pero no crea programas independientes. Una función declarada en una pestaña puede usar variables globales de otra. Processing prepara ese conjunto para ejecutarlo.

La principal es DigitalBalance_entrega3_AFES_SAPS_ADOC_JPPJ.pde. Contiene constantes, estados generales, recursos, progreso de historia, setup, draw y eventos. Es el punto de partida para seguir una acción.

Pestañas de historia: Pestana_Pixagram_Y_Cocina conecta publicaciones y decisiones con cocina. Historia_despues_de_cocina administra las consecuencias del nivel 2. Historia_cuarto_y_arcade lleva la narración previa a la máquina. Dormir_o_Jugar contiene ese modal. Finales_Nivel3 decide el cierre y muestra créditos.

Pestañas de juegos: Pestana_Nivel2_Ritmo implementa cocina musical; Nivel3_Arcade, las fases de plataformas. Minijuego_frutas, Minijuego_parejas y Minijuego_pixelart corresponden a aplicaciones del celular. El nivel 1 de penaltis está principalmente en la principal.

Pestañas de apoyo: Pestana_HUD_Y_Puntos reúne métricas, logros, avisos y depuración. Pestana_Guardado_Y_MenuCielo administra partidas y selección. Recuerdos contiene colección y personalización. Transicion_Nivel3 genera el cierre pixelado; Fondo_Arcade_Animado crea el espacio retro; Resplandor_Arcade refuerza el gabinete. Pestana_Efectos_Sonido gestiona SFX. Utilidades_Texto aporta conteos y lectura de caracteres.

En data se encuentran imágenes, sonidos, fuentes y archivos de datos. code contiene bibliotecas. Deben explicar qué servicio utiliza cada biblioteca sin atribuirse su implementación interna.

Ruta sugerida: principal → HUD → guardado → nivel 2 y consecuencias → historia del arcade → nivel 3 → finales → Recuerdos. Consulten efectos y minijuegos cuando lleguen a su llamada. Para cada módulo identifiquen entradas, variables que modifica y salida visible.

---
# 2 Ejecución y eventos
setup se ejecuta una sola vez al iniciar. Prepara la ventana y elementos iniciales. draw se repite: cada pasada actualiza y representa el juego. Processing administra esa repetición; no hace falta llamar draw en un ciclo propio.

La carga usa pasoCarga y totalPasosCarga. Mientras estadoActual es CARGA muestra una barra calculada con pasoCarga / totalPasosCarga y prepara recursos por pasos. Permite mostrar avance, aunque una lectura individual pesada puede seguir tardando.

Actualizar cambia datos: posición, tiempo, nota acertada o página. Dibujar representa datos con imágenes, texto y figuras. Hay funciones del proyecto que combinan ambas tareas; al exponer señalen cuál instrucción modifica una variable y cuál solo la muestra.

Escalado: la referencia es 1536 × 864. escalaX = width / REF_W y escalaY = height / REF_H. Se multiplican posiciones y tamaños por la escala de su eje. Por ejemplo, si el ancho aumenta un 25 %, una posición horizontal de referencia también se multiplica por 1.25. Escalar por separado puede estirar elementos cuando cambia la relación de aspecto; no equivale automáticamente a conservar todas las proporciones.

mousePressed y keyPressed reciben entradas; keyReleased limpia teclas sostenidas. mouseDragged sirve para arrastre y mouseWheel para desplazamiento. La misma tecla tiene distintos significados según pantalla y subestado: primero se identifica el contexto y luego la acción.

draw consulta primero el modo Feria y después las historias prioritarias. Las banderas controlan si debe continuar el resto de la pasada. flujoRetornoActivo pasa a false cuando la función ya atendió su tarea; los bloques posteriores solo se ejecutan si sigue true. Así se conserva la prioridad de las escenas sin return dentro de una condición.

Ejercicio: pulsen Enter en una conversación y sigan su manejador. Si avanza dos líneas, revisen si dos funciones reciben el mismo evento y si el primer cambio deja otra condición verdadera. No basta con mirar el dibujo del diálogo.

---
# 3 Estados y progresión
Un estado es una variable que indica qué parte está activa. El programa usa enteros con nombres: MENU vale 1, EXPLORACION vale 4 y NIVEL2 vale 12. El nombre permite entender la condición sin memorizar el número.

estadoActual es la pantalla vigente. estadoDestino indica a dónde terminará una transición. enTransicion y alphaTransicion controlan si hay cambio visual y cuánta opacidad tiene. Cambiar solo el destino no siempre muestra inmediatamente una pantalla.

Flujo general: carga → menú → historia y exploración → desayuno y decisiones → contexto escolar y penaltis → Pixagram y cocina → nivel 2 → consecuencias → historia previa al arcade → transición del nivel 3 → arcade → final → créditos. Es un mapa de alto nivel: existen opciones, modales y escenas intermedias. Los juegos del celular y Recuerdos son recorridos complementarios.

Un subestado organiza una actividad sin crear una pantalla general por cada paso. penEstadoActual distingue dificultad, apuntado, disparo, resultado y cierre. nv2SubEstado distingue momentos de cocina. nv3_pantalla organiza las pantallas internas del arcade, mientras nv3_fase señala su fase.

Ejemplo didáctico simplificado:
```java
if (estadoActual == MENU) {
  // Dibujar opciones.
}
if (estadoActual == EXPLORACION) {
  // Actualizar y dibujar la casa.
}
```
Con if independientes, cambiar estadoActual dentro del primero puede permitir que otro bloque se ejecute en la misma pasada. Por eso el orden y las banderas de control importan. No peguen este ejemplo como sustituto del draw real.

Preguntas para estudiar: ¿qué inicia la escena?, ¿qué dato la mantiene activa?, ¿qué evento la termina?, ¿qué variables se reinician al volver? Deben poder responder esas cuatro preguntas de cada bloque que expongan.

---
# 4 Variables arreglos y matrices
int sirve para índices y contadores; float, para posiciones y valores fraccionarios; boolean, para banderas; String, para texto; char, para un carácter. final identifica una constante. Una global conserva información entre funciones y cuadros; una local sirve para cálculos dentro de su función o bloque.

Los arreglos paralelos describen un elemento mediante un índice común. t3PartX[i], t3PartY[i], t3PartVX[i], t3PartTam[i] y t3PartActiva[i] pertenecen a una partícula. La relación está en i, sin una clase Particula definida por el equipo.

Capacidad es espacio reservado; cantidad activa es el tramo utilizado. T3_MAX_FRAGMENTOS vale 16384, mientras t3CantidadFragmentos registra cuántos se generaron. Antes de insertar se comprueba contador < capacidad, se llenan las propiedades y se incrementa el contador.

Ejemplo didáctico:
```java
if (t3CantidadFragmentos < T3_MAX_FRAGMENTOS) {
  int i = t3CantidadFragmentos;
  t3PartX[i] = 100;
  t3PartY[i] = 80;
  t3PartActiva[i] = true;
  t3CantidadFragmentos++;
}
```
Al eliminar o desplazar un elemento hay que actualizar todos sus vectores. Si se mueve solo el vector de posiciones, una fruta puede conservar el tipo de otra. Con capacidad N, los índices válidos van de 0 a N - 1: N ya está fuera del arreglo.

Las matrices agregan otra dimensión. recDialogos agrupa recuerdo y línea de diálogo. Pixel Art representa filas y columnas de celdas. Dos ciclos permiten recorrer una matriz: el externo selecciona fila y el interno columna.

Ejercicio en papel: inventen tres partículas y escriban sus propiedades en columnas X, Y, velocidad y activa. Elijan el índice 1 y expliquen cómo lo actualizan. Después elimínenlo manteniendo la correspondencia. Esto demuestra comprensión del algoritmo sin depender de la animación.

---
# 5 Exploración celular y nivel 1
La exploración conserva posición de Sam, piso, dirección y teclas de movimiento. El sprite es la apariencia; la hitbox aproxima el área para comprobar obstáculos. Son conceptos distintos.

El programa propone una posición y comprueba zonas bloqueadas antes de aceptar el movimiento. Busquen hayColision en la principal. Dibujen dos rectángulos y expliquen cuándo coinciden sus intervalos horizontal y vertical. Una imagen grande no exige que toda su superficie sea una hitbox sólida.

Interactuar requiere tecla, proximidad y progreso. desayunoComido permite cambiar objetivos después de la mesa. dibujarIndicativoFlotante dibuja una ayuda visual; la condición lógica de interacción debe existir aunque el icono no se representara.

En el celular se convierten coordenadas de ventana a coordenadas internas restando su origen; en juegos escalados también se divide por escala. Esto permite averiguar qué botón o celda recibió el clic. prepararPostPixagramPenaltis prepara contenido, dibujarFeedPixagram lo muestra y ejecutarDecisionPixagramPenaltis aplica la elección.

Penaltis está principalmente en la principal. TOTAL_TIROS vale 5. tiroActual cuenta turnos; goles, atajadas y fallos acumulan resultados diferentes. puntajePenaltis conserva puntuación y penaltisJugados marca progreso narrativo.

penEstadoActual organiza las etapas. penSubEstadoApuntado distingue dirección, altura y potencia. El jugador fija parámetros, se ejecuta el lanzamiento, se registra el resultado y se pasa al siguiente tiro o al cierre. La dificultad modifica parámetros como velocidad de mira y comportamiento del arquero.

No reduzcan la explicación a una probabilidad del arquero: sigan también los datos del disparo y la trayectoria. Un resultado del minijuego alimenta publicaciones e historia; no equivale por sí solo al final general.

Práctica: completen un tiro y anoten etapa, turno, goles y puntos antes y después. Luego ejecuten los cinco y localicen dónde se cambia al cierre. En exploración, hagan una interacción una vez y comprueben qué bandera evita repetirla cuando ya no corresponde.

---
# 6 Nivel 2 y su consecuencia
Pestana_Nivel2_Ritmo maneja notas, carriles, audio, dificultad y resultados. iniciarPartidaNivel2 reinicia la sesión; generarMapaNotasNivel2 prepara el mapa; agregarNotaNv2 incorpora tiempo, carril y duración. Una nota sostenida exige mantener la entrada durante un intervalo.

obtenerTiempoAudioRealMsNv2 aporta referencia musical. obtenerCarrilPorTeclaNv2 convierte una tecla en índice de carril. La evaluación compara el momento de la pulsación con el esperado. Aciertos y fallos afectan combo, puntos y calidad; no son todos el mismo dato.

La precisión final de finalizarPartidaNivel2 usa esta regla real:
```java
int totalIntentos = max(1, nv2ConteoPerfecto
  + nv2ConteoBueno + nv2ConteoFallo);
float puntosPrec = nv2ConteoPerfecto * 1.0f
  + nv2ConteoBueno * 0.65f;
nv2PrecisionFinal = constrain(
  puntosPrec / float(totalIntentos) * 100, 0, 100);
```
max(1, ...) evita dividir entre cero. Perfecto pesa 1; bueno, 0.65; fallo no suma al numerador. Con 60 perfectos, 20 buenos y 20 fallos se obtiene 73 %. No es el puntaje acumulado.

Desde 85 % se clasifica ESTRELLA MICHELIN; desde 60 %, CHEF APROBADO; por debajo, COCINA QUEMADA. El bot es una herramienta de prueba, no evidencia del rendimiento de un jugador humano.

Historia_despues_de_cocina conecta resultado e historia. hcPuedeContinuar exige NIVEL2, ausencia de pausa y transición, ningún reinicio pendiente y subestado de resultados o derrota. hcIniciar detiene audio, desactiva bot y reinicia la secuencia.

La rama se calcula como hcBuena = nv2SubEstado == NV2_SUB_RESULTADOS && nv2PrecisionFinal >= 60.0f. Se necesitan las dos condiciones: una derrota conduce a la mala aunque hubiera quedado una precisión anterior alta. nv2ReiniciarPartida evita consumir un resultado mientras hay un reinicio pendiente.

Práctica: prueben una victoria y una derrota, avancen sus consecuencias y comprueben que el resultado viejo no vuelve a iniciar la misma secuencia. El error típico de un bucle narrativo es conservar verdadera una condición que ya debía haberse consumido.

---
# 7 Novela visual y nivel 3
Las novelas conservan páginas, etapas, textos y hablantes. hcPagina y hcEtapa organizan las consecuencias de cocina; hcHablante y hcDialogo seleccionan contenido; hcAvanzar y hcElegirDecision cambian el progreso. Los textos se manejan como datos, sin una función por frase.

Historia_cuarto_y_arcade administra la historia previa a la máquina. t3Reiniciar limpia su estado, t3Avanzar procesa el avance y t3EntrarArcade y t3AbrirJuegoArcade conectan relato y máquina. teclaHistoria3 y clicHistoria3 canalizan las entradas. El efecto de escritura aumenta caracteres visibles; distingan completar el texto de avanzar a otra página.

En Nivel3_Arcade, nv3_pantalla es la pantalla interna; nv3_fase, la fase; nv3_vidas, las vidas disponibles; nv3_intentosFase, intentos completos agotados en esa fase. nv3_reiniciarPartida comienza en fase 1, con cuatro vidas y cero intentos agotados.

nv3_avanzarTiempo acumula tiempo en nv3_acumulado. Mientras haya al menos nv3_PASO, continúe el juego y no haya pausa, resta un paso y llama nv3_actualizarJuego. Así la simulación usa pasos temporales y no únicamente una actualización por imagen dibujada.

Checkpoint: al continuar desde nv3_pantalla == 3 se incrementa fase, se reinician intentos, se copia nv3_puntos en nv3_puntosCheckpoint, se devuelven cuatro vidas y se inicia la fase. Desde nv3_pantalla == 4 se restauran vidas y puntos del checkpoint para repetir la fase actual.

El checkpoint es memoria de la sesión. No equivale a guardar en disco cada posición, barril y objeto. Cuando las vidas llegan a cero aumenta nv3_intentosFase: antes de dos se ofrece reintento; al llegar a dos se llama iniciarFinalNivel3(false). Las fichas pueden dar una vida adicional: dos intentos no siempre son exactamente ocho muertes.

Sam tiene doble salto, Mateo velocidad, Cristian agarre y Clara escudo. Estudien duración y recarga además de activación. El mapa usa vectores y cantidades por fase para plataformas, escaleras y peligros. Utilidades_Texto contiene, por ejemplo, cantidades de plataformas 6, 8 y 27.

---
# 8 Los minijuegos del celular
Parejas usa datos por carta para identidad, posición, estado y animación. iniciarJuegoParejas prepara la actividad; parIniciarNivel dispone cartas; procesarClicParejas acepta selecciones y parVerificarVictoriaNivel comprueba el objetivo. Se comparan identidades, se conservan parejas encontradas y se ocultan las distintas después del intervalo correspondiente.

Para estudiar parejas localicen qué impide escoger otra carta mientras dos incorrectas esperan ocultarse. Expliquen la bandera o etapa que bloquea la entrada antes de aceptar otro clic.

Frutas utiliza posiciones, velocidades, radios y tipos en arreglos paralelos. frutaActualizarFisica aplica gravedad y movimiento. Compara pares con i y j empezando j en i + 1, para no comparar una fruta consigo misma ni repetir cada pareja en orden contrario.

Calcula dx, dy y d2 = dx*dx + dy*dy. Si d2 es menor que el cuadrado de la suma de radios, hay contacto. Si los tipos coinciden, se marcan como muertas y se prepara una fruta superior. Una cola temporal de capacidad fija agrega las nuevas después: se evita alterar de inmediato el conjunto que se está recorriendo. Con tipos distintos se resuelve separación y respuesta física.

Comparar parejas tiene costo cercano a n² en el peor caso. Importa limitar elementos y comprobar capacidad. No hace falta dominar toda la fórmula del impulso de memoria, pero sí explicar distancia, contacto, fusión y por qué los cambios se aplazan.

Pixel Art almacena plantillas y dibujo por filas y columnas. paPaint transforma el ratón en una celda y cambia su valor; paGrade compara con la plantilla. paSetZoom modifica la vista sin cambiar los datos pintados. La recompensa debe distinguir completar una figura de volver a evaluarla repetidamente.

Relación con AyP 2: parejas muestra comparación y selección por índices; frutas combina recorridos anidados y vectores paralelos; Pixel Art usa matrices y transformaciones de coordenadas. Los tres necesitan reiniciar sus variables y dirigir correctamente la entrada del usuario.

Práctica: expliquen una selección de carta, una fusión y una celda pintada siguiendo datos antes y después. Señalen qué cambia realmente y qué es solo animación.

---
# 9 Métricas logros y finales
puntosJugador es puntuación; bienestarDigital se limita entre 0 y 100; reputacionDigital entre -50 y 100. Un puntaje grande no sustituye esas métricas al decidir el final.

ganarPuntosConPopup agrega puntuación y la distribuye por categorías: exploración, penaltis, decisiones, cocina y logros; también genera avisos. No todas las sumas pasan necesariamente por ella: frutas contiene incrementos directos de puntosJugador. No afirmen que cada punto de cada módulo se clasifica igual sin seguir su ruta.

modificarBienestar y modificarReputacion reciben un cambio y usan constrain para respetar límites. Existen versiones con distintos parámetros que delegan en otra función: esto es sobrecarga, no una clase personalizada.

Hay 21 logros. desbloquearLogro comprueba índice válido y !logrosDesbloqueados[idx], luego marca el arreglo, guarda progreso, consulta puntos y muestra aviso. La condición evita premiar repetidamente un logro ya obtenido.

Final general: iniciarFinalNivel3 concede +8 bienestar y +10 reputación si se ganó el arcade. Después evalúa bienestarDigital >= 70 && reputacionDigital >= 15. Deben cumplirse ambas. Un atajo de debug puede forzar una rama para pruebas.

Casos: 80 bienestar y 20 reputación producen final bueno; 90 y 10 producen malo. Si antes de ganar el arcade hay 65 y 8, las bonificaciones dejan 73 y 18: bueno. Perder el arcade no fuerza por sí solo el final malo; se evalúan las métricas generales.

Finales_Nivel3 muestra tres líneas narrativas y luego créditos. Los borradores se cargan entre archivos disponibles y el desplazamiento depende del tiempo transcurrido. El fondo distingue el tono del final.

Práctica: resuelvan casos numéricos sin ejecutar el juego y localicen luego la condición real. Expliquen por qué tener muchos puntos no garantiza un desenlace y por qué una barra animada del HUD no es la variable lógica que decide el final.

---
# 10 Recuerdos y persistencia
Recuerdos define RECUERDOS = 19 y REC_TOTAL = 9. recNombres, recArchivos, recLogro y recDialogos relacionan título, imagen, logro requerido y conversación. En el recuerdo 0 está El desayuno: requiere el logro 1 y usa escena_desayuno.png. Índice del recuerdo e índice del logro son listas diferentes conectadas por recLogro.

recSeleccion indica selección; recLinea, frase extra; recSeccion distingue galería y personalización. recAbrir reinicia navegación y carga imágenes solo si recCargado es falso. Reutilizarlas evita leer los mismos archivos en cada cuadro.

Tres temas y tres marcos tienen requisitos en recTemaLogro y recMarcoLogro. Un valor negativo representa disponibilidad sin logro. recAplicarTema asigna colores del celular y recDibujarMarco dibuja bordes de fotos. recCargarPreferencias valida datos, índices y requisitos antes de aplicar la selección.

La partida usa guardarPartidaEnArchivo y escribirArreglosEnTxt. Se guardan nombre, estado, subprogreso, puntos, bienestar y reputación. Las banderas extra incluyen celular, desayuno, penaltis, decisiones, goles, dificultad, categorías y bits de logros. El subprogreso varía por contexto: página de novela o piso de exploración, por ejemplo.

Serializar significa convertir datos en texto con campos y separadores. Un boolean puede representarse como 1 o 0. Cargar reconstruye los tipos y aplica progreso. Leer el archivo y restaurar la partida seleccionada son pasos relacionados, pero diferentes.

Archivos: data/partidas_guardadas.txt conserva partida; data/logros_globales.txt conserva desbloqueos entre partidas; data/recuerdos_config.txt conserva tema y marco. El checkpoint del arcade utiliza memoria y no es otro archivo de guardado exacto de la simulación.

try y catch atienden problemas de lectura o escritura. Una partida nueva debe limpiar escenas, contadores, controles y audios temporales, conservando lo que se diseñó como global.

Práctica: desde la interfaz guarden, vuelvan al menú y carguen. Comparen progreso y métricas. Si examinan texto o quieren borrar datos, usen una copia de prueba; no destruyan el progreso de sus compañeros.

---
# 11 Efectos audio y rendimiento
Transicion_Nivel3 está separada de las reglas de plataformas. t3IniciarTituloNivel3 prepara tiempo inicial, colores y vectores. t3DibujarTransicion decide qué mostrar por segundos: cierre desde 5 s, explosión desde 10 s y término en 11.8 s.

Los píxeles conservan posición, color, fase y llegada. La llegada depende de la distancia a la esquina más cercana, formando cuatro zonas de cierre. Los fragmentos de explosión tienen velocidades, tamaño, vida, opacidad y actividad en arreglos paralelos. Disminuir tamaño y opacidad despeja gradualmente la pantalla.

t3SonidoCierreDisparado y t3SonidoExplosionDisparado se reinician al comenzar. Al alcanzar cada evento se reproduce su sonido y se marca su bandera. Sin esa memoria, una condición verdadera durante muchos cuadros dispararía repetidamente el audio.

Fondo_Arcade_Animado combina capas de estrellas, cometas y elementos cósmicos. Distintas velocidades crean parallax. sin modifica brillo o tamaño para titileo. Resplandor_Arcade refuerza el gabinete. Estos dibujos son independientes de los obstáculos físicos de una fase.

Una oscilación baseY + sin(tiempo) * amplitud sube y baja alrededor del origen: amplitud controla distancia; multiplicar tiempo controla rapidez. Sirve para indicadores y movimiento tenue de galería.

lerp aproxima un valor visual al destino: actual + (destino - actual) * factor. Las barras pueden animarse mientras la métrica real ya cambió. Las decisiones se toman con el valor lógico, no con el interpolado de presentación.

Rendimiento: cargar imágenes, redimensionar recursos, crear fuentes o regenerar cachés en cada cuadro puede costar tiempo. El proyecto controla cargas y utiliza cachés en varias zonas. Leer el código no garantiza FPS: hay que medir en el equipo y resolución de la demostración.

Práctica: observen transición, zoom y fases por separado. Si hay un bajón identifiquen qué se actualiza en ese momento. No culpen automáticamente a todas las partículas: puede haber una carga, una caché o audio reiniciándose sin necesidad.

---
# 12 Conceptos y restricciones de AyP 2
Una función divide una tarea; sus parámetros son entradas. Una función con tipo de resultado entrega un valor; void ejecuta una tarea sin devolver un resultado. La estructura del proyecto se apoya en condiciones, ciclos, vectores y matrices.

PImage, PFont, SoundFile, Movie y File son tipos de Processing, Java o bibliotecas. Utilizarlos no equivale a definir una clase propia. new float[100] reserva un vector; no es una clase Particula escrita por el equipo. La aceptación académica de cada biblioteca depende de lo permitido por el docente.

Retornos: uno al final entrega el resultado calculado; uno dentro de un if termina antes. La versión actual usa flujoRetornoActivo para permitir o bloquear las instrucciones posteriores. En funciones que entregan un dato, flujoRetornoValor conserva el resultado y se devuelve al final. Asignar false a la bandera no detiene por sí solo Java: los bloques if que la consultan son los que impiden continuar. Ejemplo didáctico que evita el retorno dentro de la condición:
```java
boolean puedeInteractuar(boolean cerca, boolean pendiente) {
  boolean permitido = false;
  if (cerca && pendiente) {
    permitido = true;
  }
  return permitido;
}
```

Las capacidades TAM_... y contadores evitan consultar .length de arreglos. String.length() consulta una cadena y es otro caso. contarCadenas recorre cadenas y cuenta elementos. leerCaracter usa getChars y un arreglo auxiliar de un char, sin charAt. Su precondición es que la posición pedida esté dentro de la cadena; no deben afirmar que una posición inválida se corrige automáticamente.

El código utiliza if independientes y else con if anidado. Expliquen las llaves y el orden de evaluación, no solo el aspecto de la línea. && exige ambas condiciones; || acepta al menos una; ! niega una bandera. Un operador ternario selecciona entre dos valores según una condición y también aparece en el proyecto.

Un recorrido de n elementos cuesta trabajo proporcional a n; comparar pares puede aproximarse a n². Validar índices protege arreglos; limitar capacidad evita inserciones fuera de rango; una bandera de recompensa evita duplicados. Estos son argumentos de AyP 2 que deben poder mostrar sobre funciones reales.

---
# 13 Reparto y plan de siete días
El reparto siguiente organiza estudio, no autoría. Todos deben poder explicar estados, arreglos, métricas y archivos.

Integrante A: principal, setup, draw, eventos, exploración, celular y penaltis. Demuestra cómo un estado dirige el flujo y cómo se registra una interacción. Prepara dibujo de hitboxes y ejemplo de escalado.

Integrante B: Pixagram, cocina musical, decisiones y consecuencias del nivel 2. Calcula precisión, sigue hcBuena y distingue puntaje, combo, calidad y precisión. Demuestra victoria y derrota sin bucle.

Integrante C: historia previa, arcade, fases, habilidades y checkpoint. Explica el acumulador temporal y demuestra un reintento. Distingue intentos agotados de vidas perdidas y de guardar en archivo.

Integrante D: HUD, logros, Recuerdos, guardado, efectos y finales. Resuelve casos de métricas, muestra arreglos paralelos y distingue los tres archivos persistentes. Explica por qué los sonidos de transición no se repiten.

Día 1: lectura conjunta y diagrama del flujo sin mirar. Día 2: profundización individual y localización de funciones. Día 3: dos casos por bloque, anotando variables antes y después. Día 4: cada integrante enseña su bloque durante diez minutos. Día 5: intercambio: alguien diferente debe explicar el mismo recorrido. Día 6: ensayo con el tiempo oficial, preguntas e imprevistos. Día 7: repaso breve, copia de seguridad y comprobación de sketch, recursos y audio.

Si disponen de doce minutos, una distribución posible es: dos para arquitectura, dos para exploración y nivel 1, dos para cocina, dos para arcade, dos para métricas y archivos y dos para preguntas. Ajusten esto al tiempo que indique el docente.

Lista de preparación: abrir el sketch correcto; conocer dónde están los recursos; practicar rutas normales sin depender exclusivamente del debug; tener casos buenos y malos; probar persistencia en copia segura; acordar relevos entre compañeros; preparar una explicación sin sonido por si el audio del salón falla.

En cada exposición usen esta secuencia: qué problema resuelve → qué datos utiliza → qué condición o ciclo ejecuta → qué cambia → cómo comprobarlo. No lean todo el código en pantalla.

---
# 14 Preguntas para practicar
¿Qué hace draw? Se ejecuta repetidamente y en este juego coordina carga, actualizaciones y representación según contexto. No contiene únicamente dibujos.

¿Por qué arreglos paralelos? Permiten manejar varias propiedades por un índice común sin clases propias; exigen mantener índices sincronizados y respetar capacidades.

¿Bandera y contador son iguales? No: una bandera representa dos posibilidades; un contador una cantidad. Ejemplo: sonido disparado frente a fragmentos activos.

¿Ganar el arcade garantiza final bueno? No. Después de las bonificaciones se exigen bienestar de al menos 70 y reputación de al menos 15.

¿Perder cocina acaba el juego? No necesariamente: activa su consecuencia narrativa. El final general se evalúa después con sus métricas.

¿El checkpoint sobrevive al cierre? No debemos afirmarlo. Conserva datos para reintentar durante la sesión; el archivo de partida es otro mecanismo con campos concretos.

¿Qué evita repetir un logro? Validar que todavía no esté desbloqueado antes de marcarlo y sumar su recompensa.

¿Por qué max(1, totalIntentos)? Evita dividir entre cero; no convierte una sesión vacía en un resultado perfecto.

¿Índice igual a capacidad? Está fuera del arreglo: el último válido es capacidad - 1.

¿Por qué tiempo musical y no solo cuadros? La canción transcurre en tiempo real; evaluar notas necesita una referencia relacionada con ese tiempo.

¿Las pestañas son independientes? No: comparten el sketch y variables globales. Organizar archivos no elimina dependencias.

¿Por qué preparar nuevas frutas después del recorrido? Para no alterar inmediatamente el conjunto que se compara y mantener controladas inserciones y fusiones.

¿Qué es sobrecarga? Varias funciones con el mismo nombre y parámetros distintos; el conjunto de argumentos determina cuál se llama.

¿Qué responder si olvidamos una cifra? Identificamos la constante o función, la buscamos y explicamos el cálculo real. Es preferible a inventar una regla.

Ejercicio final conjunto: cada persona toma una acción que no sea de su bloque y la sigue desde teclado o ratón hasta datos, dibujo, consecuencia y guardado si corresponde. Si pueden hacerlo, comprenden las conexiones principales.

---
# 15 Modo Feria Gamer
Se activa desde el menú principal con F3 para habilitar debug y después F9. El selector presenta tres retos mediante teclas 1, 2 y 3, flechas y Enter o clic. M o Escape vuelve al selector durante un reto; desde el selector regresa al menú y restaura el estado de debug anterior.

Feria_Gamer.pde añade FERIA_GAMER con valor 20. feriaActiva indica que se está demostrando el juego; feriaNivel señala el reto y feriaSeleccion la opción resaltada. feriaAbrir guarda métricas y variables narrativas en arreglos temporales, activa la demostración y abre el selector. feriaJugar prepara el contexto correspondiente sin recorrer toda la historia.

Penaltis empieza con cinco tiros y elección de dificultad. Cocina abre su selección de dificultad. Arcade pasa directamente a la selección de personaje, conservando las tres fases y sus reglas. Los resultados muestran un resumen y vuelven al selector tras nueve segundos; Enter o clic permiten volver antes. En el arcade se omiten las conversaciones finales de la campaña durante la demostración.

feriaDibujar, feriaTecla y feriaClic entregan un boolean que indica si atendieron el cuadro o la entrada. Sus llamadas rodean el flujo habitual mediante condiciones. Este patrón evita que el mismo clic controle simultáneamente el selector y una pantalla de la campaña.

Durante la feria no se conceden logros, no se escribe la partida y no se inicia la consecuencia narrativa de cocina. Los puntos del reto son temporales. feriaRestaurarMetricas recupera las métricas previas y feriaRestaurarHistoria recupera las variables narrativas copiadas al entrar. No se trata de un segundo archivo de partida: la copia vive en memoria.

El fondo usa cuadrados suaves en movimiento y anillos que pulsan. Se calculan con tiempo, ciclos y sin, sin cargar una imagen nueva por cuadro ni definir clases propias. Los botones mantienen la paleta cálida del menú.

Para demostrarlo: activen F3 y F9, prueben un reto, vuelvan con M, prueben otro y salgan al menú. Comprueben que los puntos y desbloqueos de la campaña no aumentaron. La feria sirve para visitantes que quieren jugar de inmediato; el recorrido narrativo completo sigue disponible desde Jugar.

---
# Anexo de navegación
Las referencias del PDF se generan desde los archivos revisados. Señalan el inicio de funciones importantes. Los números cambian cuando se edita: busquen también el nombre.

Este informe es material de estudio y descripción de la versión revisada. No sustituye ejecutar los casos ni garantiza ausencia de errores. Las referencias se actualizaron después de incorporar Feria Gamer y corregir los retornos.
