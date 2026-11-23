from pathlib import Path
import re
root=Path(__file__).resolve().parents[2]
def wrap(file,name,condition,alternative=''):
 p=root/file;s=p.read_text(encoding='utf-8-sig');m=re.search(r'\b(?:void|boolean) '+name+r'\([^\n]*\)\s*\{',s);start=m.end(); depth=1;i=start
 # Skip comments and literals while finding the function end.
 token=re.compile(r'//[^\n]*|/\*.*?\*/|"(?:\\.|[^"\\])*"|\x27(?:\\.|[^\x27\\])*\x27|[{}]',re.S)
 for t in token.finditer(s,start):
  if t[0]=='{':depth+=1
  if t[0]=='}':depth-=1
  if depth==0: i=t.start();break
 s=s[:start]+'\n  if ('+condition+') {\n'+s[start:i]+'\n  }'+alternative+'\n'+s[i:];p.write_text(s,encoding='utf8')
main='DigitalBalance_entrega3_AFES_SAPS_ADOC_JPPJ.pde'
wrap(main,'draw','!feriaDibujar()')
wrap(main,'keyPressed','!feriaTecla()')
wrap(main,'mousePressed','!feriaClic()')
wrap('Finales_Nivel3.pde','iniciarFinalNivel3','!feriaActiva',' else { feriaTerminoArcade = true; }')
wrap('Pestana_Guardado_Y_MenuCielo.pde','guardarPartidaEnArchivo','!feriaActiva')
p=root/main;s=p.read_text(encoding='utf8').replace('"LOGROS", "RECUERDOS"','"LOGROS", "RECUERDOS", "FERIA GAMER"').replace('int totalBotones = 6;','int totalBotones = 7;')
s=s.replace('if (indiceReal == 5)\n                      recAbrir();','if (indiceReal == 5)\n                      recAbrir();\n                    if (indiceReal == 6) feriaAbrir();')
s=s.replace('if (opcionSeleccionada == 5)\n                    recAbrir();','if (opcionSeleccionada == 5)\n                    recAbrir();\n                  if (opcionSeleccionada == 6) feriaAbrir();')
p.write_text(s,encoding='utf8')
p=root/'Pestana_HUD_Y_Puntos.pde';s=p.read_text(encoding='utf8').replace('if (idx >= 0 && idx < totalLogros && !logrosDesbloqueados[idx])','if (!feriaActiva && idx >= 0 && idx < totalLogros && !logrosDesbloqueados[idx])');p.write_text(s,encoding='utf8')
p=root/'Historia_despues_de_cocina.pde';s=p.read_text(encoding='utf8').replace('return estadoActual == NIVEL2','return !feriaActiva && estadoActual == NIVEL2');p.write_text(s,encoding='utf8')
