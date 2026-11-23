from pathlib import Path
import re, html
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak, Preformatted, KeepTogether
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.colors import HexColor
from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import letter
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

root=Path(__file__).resolve().parents[2]
out=Path(__file__).resolve().parent
source=out/'Informe_codigo_Sam_Thinks_a_Lot.md'
pdfmetrics.registerFont(TTFont('Arial',r'C:\Windows\Fonts\arial.ttf'))
pdfmetrics.registerFont(TTFont('ArialB',r'C:\Windows\Fonts\arialbd.ttf'))
pdfmetrics.registerFont(TTFont('Consolas',r'C:\Windows\Fonts\consola.ttf'))
styles=getSampleStyleSheet()
styles.add(ParagraphStyle(name='BodySam',fontName='Arial',fontSize=11,leading=15,spaceAfter=10,textColor=HexColor('#252525')))
styles.add(ParagraphStyle(name='HeadSam',fontName='ArialB',fontSize=20,leading=24,spaceAfter=18,textColor=HexColor('#000000')))
styles.add(ParagraphStyle(name='CodeSam',fontName='Consolas',fontSize=9,leading=12,spaceAfter=12))
styles.add(ParagraphStyle(name='RefSam',fontName='Arial',fontSize=9.5,leading=13,spaceAfter=6))
story=[]
for section in source.read_text(encoding='utf8').split('\n---\n'):
    if story:story.append(PageBreak())
    blocks=re.split(r'(```java\n.*?```)',section.strip(),flags=re.S)
    for block in blocks:
        if block.startswith('```'):
            story.append(Preformatted(block.split('\n',1)[1].rsplit('```',1)[0].strip(),styles['CodeSam']))
        else:
            for para in block.strip().split('\n\n'):
                if not para.strip():continue
                if para.startswith('# '):
                    lines=para.splitlines()
                    story.append(Paragraph(html.escape(lines[0][2:]),styles['HeadSam']))
                    if len(lines)>1:story.append(Paragraph(html.escape(' '.join(lines[1:])),styles['BodySam']))
                else:story.append(Paragraph(html.escape(para).replace('\n',' '),styles['BodySam']))

keys=['setup','draw','mousePressed','keyPressed','dibujarIndicativoFlotante','hcPuedeContinuar','hcIniciar','hcAvanzar','t3Avanzar','t3EntrarArcade','iniciarPartidaNivel2','finalizarPartidaNivel2','obtenerTiempoAudioRealMsNv2','nv3_reiniciarPartida','nv3_avanzarTiempo','nv3_actualizarJuego','iniciarFinalNivel3','desbloquearLogro','modificarBienestar','modificarReputacion','guardarPartidaEnArchivo','cargarPartidasDesdeArchivo','recAbrir','recDisponible','recGuardarPreferencias','t3IniciarTituloNivel3','t3DibujarTransicion','frutaActualizarFisica','parVerificarVictoriaNivel','paGrade','leerCaracter','contarCadenas','feriaAbrir','feriaJugar','feriaSelector','feriaSalir','feriaDibujar','feriaTecla']
refs=[]
for file in sorted(root.glob('*.pde')):
    found=[]
    for n,line in enumerate(file.read_text(encoding='utf-8-sig').splitlines(),1):
        m=re.match(r'\s*(?:public\s+)?(?:void|boolean|int|float|String|char)\s+(\w+)\s*\(',line)
        if m and m[1] in keys:found.append(f'{m[1]} — línea {n}')
    if found:
        story.append(Paragraph(html.escape(file.name),styles['RefSam']))
        for ref in found:story.append(Paragraph(html.escape(ref),styles['RefSam']))
        story.append(Spacer(1,7))
        refs.extend([f'{file.name}: {x}' for x in found])
(out/'Referencias_funciones.txt').write_text('\n'.join(refs),encoding='utf8')
def footer(c,d):
    c.setFont('Arial',8);c.setFillColor(HexColor('#666666'))
    c.drawString(45,27,'Sam Thinks a Lot · Guía de código · AyP 2')
    c.drawRightString(567,27,str(d.page))
doc=SimpleDocTemplate(str(out/'Informe_codigo_Sam_Thinks_a_Lot.pdf'),pagesize=letter,rightMargin=45,leftMargin=45,topMargin=42,bottomMargin=45,title='Informe explicativo del código de Sam Thinks a Lot',author='DigitalBalance')
doc.build(story,onFirstPage=footer,onLaterPages=footer)
print(out/'Informe_codigo_Sam_Thinks_a_Lot.pdf')
