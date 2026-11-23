from pathlib import Path
import re
root=Path(__file__).resolve().parents[2]
p=root/'Feria_Gamer.pde'
names=set('t3Activa t3ChatAbierto t3Etapa t3Pagina t3SaludLlegada t3IntroActiva hcActiva hcBuena hcGrabaron hcPublicada hcMeGusta hcEtapa hcPagina hcDecision finalNivel3Activo finalNivel3Bueno finalNivel3Pagina finalNivel3Creditos penEstadoActual penSubEstadoApuntado tiroActual atajadas fallos puntajePenaltis penDificultadActual paginaActual paginaEscuela paginaCocina decisionCocinaTomada dia1Terminado juegosDesbloqueados decisionPixagramTomada charsVisibles dialogoCompletado ultimoTextoDialogo nv2ReiniciarPartida nv2SubEstado nv2Completado nv2PrecisionFinal nv2AutoPlayBot'.split())
found={}
for f in root.glob('*.pde'):
 for m in re.finditer(r'^(int|float|boolean|String) (\w+)\s*=',f.read_text(encoding='utf-8-sig'),re.M):
  if m[2] in names:found[m[2]]=m[1]
groups={t:[n for n,k in found.items() if k==t] for t in ['int','float','boolean','String']}
s='\n// Copia temporal de las variables narrativas que toca una demostración.\n'
for t,ns in groups.items():s+=f'{t}[] feriaHistoria{t} = new {t}[{len(ns)}];\n'
for func,save in [('feriaGuardarHistoria',True),('feriaRestaurarHistoria',False)]:
 s+=f'void {func}() {{\n'
 for t,ns in groups.items():
  for i,n in enumerate(ns):s+=f'  feriaHistoria{t}[{i}] = {n};\n' if save else f'  {n} = feriaHistoria{t}[{i}];\n'
 s+='}\n'
p.write_text(p.read_text(encoding='utf8')+s,encoding='utf8')
print('Snapshot de',len(found),'variables')
# A separate generated Java copy is only used for before/after regression tests.
b=Path('C:/Users/escor/AppData/Local/Temp/sam_feria_build')
old=Path('C:/Users/escor/AppData/Local/Temp/sam_retornos_base/source/DigitalBalance_entrega3_AFES_SAPS_ADOC_JPPJ.java').read_text(encoding='utf8')
(b/'JuegoAntes.java').write_text(old.replace('DigitalBalance_entrega3_AFES_SAPS_ADOC_JPPJ','JuegoAntes'),encoding='utf8')
