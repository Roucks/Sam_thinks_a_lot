from pathlib import Path
p=Path(__file__).with_name('Informe_codigo_Sam_Thinks_a_Lot.md')
s=p.read_text(encoding='utf8')
s=s.replace('Código revisado el 14 de noviembre de 2026','Código revisado el 14 de noviembre de 2026 · Versión con Feria Gamer')
start=s.index('Precisión sobre las restricciones:')
end=s.index('\n\nContenido:',start)
s=s[:start]+('Revisión de retornos: se sustituyeron los retornos tempranos de 26 funciones por banderas de control y resultados locales. La revisión estructural actual no detecta return dentro de condicionales ni ciclos. Las funciones con resultado conservan un único retorno al final. También se comprobó la ausencia de charAt, else if, clases personalizadas y consultas .length de arreglos en las pestañas PDE. Se usaron 354 comparaciones de comportamiento sobre diálogos, avance, teclado y clics, además de comprobaciones de regresión y de feria. Esto no sustituye ensayar el juego completo en el equipo de la exposición.')+s[end:]
s=s.replace('Se elaboró leyendo las pestañas actuales y no modifica el juego.','Describe la versión actual después de incorporar Feria Gamer y corregir los retornos.')
s=s.replace('draw consulta primero dibujarHistoria3 y dibujarHistoriaDespuesCocina. Si una atiende la escena, el código actual termina la pasada con un retorno temprano y evita dibujar además el flujo general. Esto explica su prioridad real, pero también identifica una construcción que deben contrastar con la regla académica de retornos.', 'draw consulta primero el modo Feria y después las historias prioritarias. Las banderas controlan si debe continuar el resto de la pasada. flujoRetornoActivo pasa a false cuando la función ya atendió su tarea; los bloques posteriores solo se ejecutan si sigue true. Así se conserva la prioridad de las escenas sin return dentro de una condición.')
s=s.replace('El código actual todavía tiene retornos tempranos tras revertir la reestructuración. Este informe no los cambia.', 'La versión actual usa flujoRetornoActivo para permitir o bloquear las instrucciones posteriores. En funciones que entregan un dato, flujoRetornoValor conserva el resultado y se devuelve al final. Asignar false a la bandera no detiene por sí solo Java: los bloques if que la consultan son los que impiden continuar.')
s=s.replace('El código del juego permaneció sin cambios durante su preparación.', 'Las referencias se actualizaron después de incorporar Feria Gamer y corregir los retornos.')
section='''# 15 Modo Feria Gamer
Se activa desde el menú principal con F3 para habilitar debug y después F9. El selector presenta tres retos mediante teclas 1, 2 y 3, flechas y Enter o clic. M o Escape vuelve al selector durante un reto; desde el selector regresa al menú y restaura el estado de debug anterior.

Feria_Gamer.pde añade FERIA_GAMER con valor 20. feriaActiva indica que se está demostrando el juego; feriaNivel señala el reto y feriaSeleccion la opción resaltada. feriaAbrir guarda métricas y variables narrativas en arreglos temporales, activa la demostración y abre el selector. feriaJugar prepara el contexto correspondiente sin recorrer toda la historia.

Penaltis empieza con cinco tiros y elección de dificultad. Cocina abre su selección de dificultad. Arcade pasa directamente a la selección de personaje, conservando las tres fases y sus reglas. Los resultados muestran un resumen y vuelven al selector tras nueve segundos; Enter o clic permiten volver antes. En el arcade se omiten las conversaciones finales de la campaña durante la demostración.

feriaDibujar, feriaTecla y feriaClic entregan un boolean que indica si atendieron el cuadro o la entrada. Sus llamadas rodean el flujo habitual mediante condiciones. Este patrón evita que el mismo clic controle simultáneamente el selector y una pantalla de la campaña.

Durante la feria no se conceden logros, no se escribe la partida y no se inicia la consecuencia narrativa de cocina. Los puntos del reto son temporales. feriaRestaurarMetricas recupera las métricas previas y feriaRestaurarHistoria recupera las variables narrativas copiadas al entrar. No se trata de un segundo archivo de partida: la copia vive en memoria.

El fondo usa cuadrados suaves en movimiento y anillos que pulsan. Se calculan con tiempo, ciclos y sin, sin cargar una imagen nueva por cuadro ni definir clases propias. Los botones mantienen la paleta cálida del menú.

Para demostrarlo: activen F3 y F9, prueben un reto, vuelvan con M, prueben otro y salgan al menú. Comprueben que los puntos y desbloqueos de la campaña no aumentaron. La feria sirve para visitantes que quieren jugar de inmediato; el recorrido narrativo completo sigue disponible desde Jugar.

---
'''
s=s.replace('# Anexo de navegación',section+'# Anexo de navegación')
p.write_text(s,encoding='utf8')
q=Path(__file__).with_name('generar_informe.py');t=q.read_text(encoding='utf8').replace("'contarCadenas']", "'contarCadenas','feriaAbrir','feriaJugar','feriaSelector','feriaSalir','feriaDibujar','feriaTecla']");q.write_text(t,encoding='utf8')
