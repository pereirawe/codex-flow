"""Cria DOCX com texto/tabelas editáveis e diagramas de alta resolução."""
from pathlib import Path
import json,re,sys
from docx import Document
from docx.shared import Inches,Pt,RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT,WD_CELL_VERTICAL_ALIGNMENT
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from PIL import Image

SOURCE=Path(sys.argv[1]).resolve(); HERE=SOURCE.parent
manifest=json.loads(SOURCE.read_text())
data=[(s['title'],s['body']) for s in manifest['sections']]
TARGET=Path(sys.argv[2]).resolve(); TARGET.parent.mkdir(parents=True,exist_ok=True)
doc=Document();sec=doc.sections[0]
sec.page_width=Inches(8.5);sec.page_height=Inches(11)
sec.top_margin=Inches(.72);sec.bottom_margin=Inches(.65)
sec.left_margin=sec.right_margin=Inches(.72)
sec.header_distance=Inches(.25);sec.footer_distance=Inches(.28)
for name in ['Normal','Body Text']:
 st=doc.styles[name];st.font.name='Calibri';st.font.size=Pt(11)
 st.font.color.rgb=RGBColor.from_string('263D43')
 st.paragraph_format.space_after=Pt(7);st.paragraph_format.line_spacing=1.08
for name,size,color in [('Title',27,'000000'),('Heading 1',21,'000000'),('Heading 2',13,'000000')]:
 st=doc.styles[name];st.font.name='Calibri';st.font.size=Pt(size);st.font.color.rgb=RGBColor.from_string(color)
 st.paragraph_format.space_before=Pt(7);st.paragraph_format.space_after=Pt(10)
 st.paragraph_format.keep_with_next=True
for border in list(doc.styles['Title']._element.xpath('.//w:pBdr')):
 border.getparent().remove(border)
sec.header.paragraphs[0].add_run().add_picture(str(HERE/manifest['issuer']['logo']),width=Inches(1.1))
foot=sec.footer.paragraphs[0];foot.alignment=WD_ALIGN_PARAGRAPH.RIGHT
r=foot.add_run(f"{manifest['issuer']['name']} | {manifest['client']['name']} | {manifest['project']['status']} {manifest['project']['version']}     ");r.font.size=Pt(8);r.font.color.rgb=RGBColor.from_string('587273')
for field in ['PAGE','NUMPAGES']:
 if field=='NUMPAGES':foot.add_run(' / ')
 f=OxmlElement('w:fldSimple');f.set(qn('w:instr'),field);foot._p.append(f)

def inline(p,text):
 for piece in re.split(r'(\*\*.*?\*\*|\*[^*]+\*)',text):
  if not piece:continue
  if piece.startswith('**') and piece.endswith('**'):p.add_run(piece[2:-2]).bold=True
  elif piece.startswith('*') and piece.endswith('*'):p.add_run(piece[1:-1]).italic=True
  else:p.add_run(piece.replace('  \n','\n'))

def table(lines):
 rows=[[c.strip() for c in x.strip().strip('|').split('|')] for x in lines]
 rows=[rows[0]]+[x for x in rows[1:] if not all(re.fullmatch(r'[: -]+',c or ' ') for c in x)]
 n=len(rows[0])
 if any(len(row)!=n for row in rows): raise ValueError('Tabela com número inconsistente de colunas')
 t=doc.add_table(rows=0,cols=n);t.alignment=WD_TABLE_ALIGNMENT.CENTER
 t.autofit=False
 weights=([.09,.69,.22] if n==3 and rows[0][0]=='Parcela' else ([.24,.40,.20,.16] if n==4 and rows[0][0]=='Parte do projeto' else ([.38,.62] if n==2 else ([.37,.315,.315] if n==3 else [.55]+[.45/(n-1)]*(n-1)))))
 if n==3 and rows[0][0]=='ID': weights=[.08,.55,.37]
 if n==3 and rows[0][0]=='Etapa': weights=[.22,.23,.55]
 borders=OxmlElement('w:tblBorders')
 for edge in ['top','left','bottom','right','insideH','insideV']:
  border=OxmlElement('w:'+edge);border.set(qn('w:val'),'single');border.set(qn('w:sz'),'4');border.set(qn('w:color'),'D9D9D9');borders.append(border)
 t._tbl.tblPr.append(borders)
 for col,w in zip(t.columns,weights):col.width=Inches(7.06*w)
 for ri,values in enumerate(rows):
  cells=t.add_row().cells
  trpr=t.rows[-1]._tr.get_or_add_trPr();no=OxmlElement('w:cantSplit');trpr.append(no)
  if ri==0:
   repeat=OxmlElement('w:tblHeader');trpr.append(repeat)
  for ci,(cell,value,w) in enumerate(zip(cells,values,weights)):
   cell.width=Inches(7.06*w);cell.vertical_alignment=WD_CELL_VERTICAL_ALIGNMENT.CENTER
   pr=cell._tc.get_or_add_tcPr();marg=OxmlElement('w:tcMar')
   for edge,num in [('top',75),('bottom',75),('left',95),('right',95)]:
    el=OxmlElement('w:'+edge);el.set(qn('w:w'),str(num));el.set(qn('w:type'),'dxa');marg.append(el)
   pr.append(marg)
   shade=OxmlElement('w:shd');shade.set(qn('w:fill'),'176267' if ri==0 else ('EFF6F5' if ri%2==0 else 'FFFFFF'));pr.append(shade)
   p=cell.paragraphs[0];p.paragraph_format.space_after=Pt(0);p.paragraph_format.space_before=Pt(0);p.paragraph_format.line_spacing=1.03
   inline(p,value)
   for run in p.runs:
    run.font.size=Pt(9.5 if n>2 else 10)
    if ri==0:run.bold=True;run.font.color.rgb=RGBColor(255,255,255)
 doc.add_paragraph().paragraph_format.space_after=Pt(0)

for index,(title,body) in enumerate(data):
 if index and title not in manifest.get('layout',{}).get('continue_sections',[]):doc.add_page_break()
 doc.add_heading(title,level=1)
 lines=body.strip().splitlines();i=0
 while i<len(lines):
  line=lines[i]
  if not line.strip():i+=1;continue
  if line.startswith('|'):
   block=[]
   while i<len(lines) and lines[i].startswith('|'):block.append(lines[i]);i+=1
   table(block);continue
  if line.startswith('# '):doc.add_paragraph(line[2:],style='Title');i+=1;continue
  if line.startswith('## '):
   heading=doc.add_heading(line[3:],level=1)
   heading.paragraph_format.page_break_before=line[3:] in manifest.get('layout',{}).get('page_break_before',[])
   i+=1;continue
  if line.startswith('### '):doc.add_heading(line[4:],level=2);i+=1;continue
  m=re.fullmatch(r'!\[(.*?)\]\((.*?)\)',line)
  if m:
   image=HERE/m.group(2)
   if image.suffix.lower()=='.svg': image=image.with_suffix('.png')
   if not image.is_file(): raise ValueError(f'Imagem raster ausente: {image}')
   im=Image.open(image);w,h=im.size
   maxh=float(manifest.get('layout',{}).get('images',{}).get(m.group(2),{}).get('max_height_inches',3.55))
   width=min(7.02,maxh*w/h)
   p=doc.add_paragraph();p.alignment=WD_ALIGN_PARAGRAPH.CENTER
   p.paragraph_format.space_after=Pt(3)
   run=p.add_run();run.add_picture(str(image),width=Inches(width))
   drawing=run._r.xpath('.//wp:docPr')
   if drawing:drawing[0].set('descr',m.group(1))
   i+=1;continue
  chunks=[line];i+=1
  while i<len(lines) and lines[i].strip() and not lines[i].startswith(('|','#','![')):
   chunks.append(lines[i]);i+=1
  p=doc.add_paragraph();inline(p,'\n'.join(chunks))
  if all(x.startswith('*') and not x.startswith('**') for x in chunks):
   p.paragraph_format.space_after=Pt(6)
   for r in p.runs:r.font.size=Pt(9);r.font.color.rgb=RGBColor.from_string('587273')

doc.core_properties.title=manifest['project']['title']
doc.core_properties.author=manifest['issuer']['name']
doc.core_properties.version=manifest['project']['version']
doc.save(TARGET)
print(TARGET)
