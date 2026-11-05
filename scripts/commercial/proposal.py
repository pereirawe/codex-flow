#!/usr/bin/env python3
"""Fonte única por cliente; validação, Markdown e pacote público sem scripts."""
import argparse,json,re,zipfile
from datetime import date
from pathlib import Path
from decimal import Decimal

def load(path):
    data=json.loads(path.read_text())
    if data.get('schema_version')!=1: raise ValueError('schema_version deve ser 1')
    for obj,keys in [('project',['title','slug','status','version']),('issuer',['name','logo']),('client',['name'])]:
        for key in keys:
            if not data.get(obj,{}).get(key): raise ValueError(f'{obj}.{key} obrigatório')
    ids=[s['id'] for s in data['sections']]
    if len(ids)!=len(set(ids)): raise ValueError('IDs de seção duplicados')
    for section in data['sections']:
        if not section.get('title') or not section.get('body'): raise ValueError('Seção vazia')
    assets={data['issuer']['logo']}|{d['source'] for d in data.get('diagrams',[])}
    for section in data['sections']:
        assets.update(re.findall(r'!\[[^\]]*\]\(([^)]+)\)',section['body']))
    diagram_sources={d['source'] for d in data.get('diagrams',[])}
    for item in assets:
        allowed={'.mmd'} if item in diagram_sources else {'.png','.jpg','.jpeg','.svg'}
        if Path(item).suffix.lower() not in allowed: raise ValueError(f'Tipo de asset proibido: {item}')
        target=(path.parent/item).resolve()
        if not target.is_relative_to(path.parent.resolve()): raise ValueError(f'Asset fora da pasta: {item}')
        if not target.is_file(): raise ValueError(f'Asset ausente: {item}')
        suffix=target.suffix.lower(); head=target.read_bytes()[:256]
        if suffix=='.png' and not head.startswith(b'\x89PNG\r\n\x1a\n'): raise ValueError('PNG inválido')
        if suffix in {'.jpg','.jpeg'} and not head.startswith(b'\xff\xd8'): raise ValueError('JPEG inválido')
        if suffix=='.svg' and b'<svg' not in target.read_bytes()[:4096]: raise ValueError('SVG inválido')
    # Optional machine-checkable commercial ledger; narrative still requires human review.
    ledger=data.get('commercial')
    if ledger:
        total=Decimal(str(ledger['total']));rate=Decimal(str(ledger['hourly_rate']))
        hours=sum(Decimal(str(x['hours'])) for x in ledger['fronts'])
        if hours*rate!=total: raise ValueError('Horas × taxa não conferem com total')
        if sum(Decimal(str(x['amount'])) for x in ledger['payments'])!=total: raise ValueError('Parcelas não conferem com total')
    return data,assets

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('command',choices=['init','validate','build','pack','publish-plan'])
    ap.add_argument('source',type=Path);ap.add_argument('--output',type=Path)
    args=ap.parse_args();p=args.source.resolve()
    if args.command=='init':
        if p.exists(): raise ValueError('Fonte já existe; use build ou edite a existente')
        p.parent.mkdir(parents=True,exist_ok=True)
        template={'schema_version':1,'project':{'slug':p.parent.parent.name,'title':'A CONFIRMAR','status':'minuta','version':'0.1.0','date':None,'valid_until':None},'client':{'name':'A CONFIRMAR'},'issuer':{'name':'A CONFIRMAR','logo':'assets/logo.png'},'sections':[{'id':'resumo','title':'1 Resumo executivo','body':'Escopo e condições a confirmar.'}],'diagrams':[],'drive':{}}
        p.write_text(json.dumps(template,ensure_ascii=False,indent=2)+'\n');print(p);return
    d,assets=load(p)
    if args.command=='validate': print(f"OK: {len(d['sections'])} seções; {len(d.get('diagrams',[]))} diagramas")
    elif args.command=='build':
        target=args.output or p.with_name('proposta.md')
        target.write_text('\n\n'.join('## '+s['title']+'\n\n'+s['body'] for s in d['sections'])+'\n')
        print(target)
    elif args.command=='pack':
        target=args.output or p.with_name('fontes-e-graficos.zip')
        # Allowlist only client-facing content, never internal strategy, scripts or Word.
        with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED) as z:
            md='\n\n'.join('## '+s['title']+'\n\n'+s['body'] for s in d['sections'])+'\n'
            z.writestr('proposta.md',md)
            for item in sorted(assets): z.write(p.parent/item,item)
            for item in d.get('diagrams',[]):
                svg=Path(item['source']).with_suffix('.svg')
                if (p.parent/svg).exists():
                    svg_target=(p.parent/svg).resolve()
                    if not svg_target.is_relative_to(p.parent): raise ValueError('SVG fora da pasta')
                    if b'<svg' not in svg_target.read_bytes()[:4096]: raise ValueError('SVG inválido')
                    z.write(svg_target,str(svg))
        print(target)
    else:
        for obj,key in [('client','name'),('issuer','name'),('project','title')]:
            if 'CONFIRMAR' in d[obj][key].upper(): raise ValueError('Identidade provisória: confirme antes de publicar')
        start=date.fromisoformat(d['project']['date']); end=date.fromisoformat(d['project']['valid_until'])
        if end<start: raise ValueError('Validade anterior à emissão')
        print(json.dumps({'client':d['client']['name'],'title':d['project']['title'],'drive':d.get('drive',{}),'action':'update_existing' if d.get('drive',{}).get('document_id') else 'resolve_folder_then_import','native_mime_type':'application/vnd.google-apps.document','requires_readback':True,'upload_word':False},ensure_ascii=False,indent=2))
if __name__=='__main__':
    try:main()
    except (ValueError,KeyError,OSError,TypeError) as e:raise SystemExit(str(e))
