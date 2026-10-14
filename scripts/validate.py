#!/usr/bin/env python3
"""Validate native manifests, catalogs and runtime syntax without external calls."""
import json
from pathlib import Path
import re
import subprocess
import sys
import tomllib
from flowctl import ROOT, metadata, jsonc

errors=[]
names=set()
for kind in ['skills','commands','agents']:
    entries=json.loads((ROOT/'catalog'/(kind+'.json')).read_text())
    for entry in entries:
        if kind=='agents':
            path=ROOT/entry['config_file']
            try:
                data=tomllib.loads(path.read_text())
                for key in ['name','description','developer_instructions']:
                    if not isinstance(data.get(key),str) or not data[key]:errors.append(str(path)+': missing '+key)
                if data['name']!=entry['name']:errors.append(str(path)+': catalog name mismatch')
                if 'model' in data or 'model_reasoning_effort' in data:errors.append(str(path)+': unexpected model override')
            except Exception as exc:errors.append(str(path)+': '+str(exc))
        else:
            path=ROOT/entry['path']
            try:
                meta,body=metadata(path.read_text())
                if meta.get('name')!=entry['name']:errors.append(str(path)+': catalog name mismatch')
                if not meta.get('description'):errors.append(str(path)+': missing description')
                if not re.fullmatch('[a-z0-9-]{1,64}',entry['name']):errors.append(str(path)+': invalid skill name')
                if entry['name'] in names:errors.append('Duplicate skill name '+entry['name'])
                names.add(entry['name'])
                # Some legacy manifests contain supported metadata; parse the
                # entire YAML when PyYAML is available to catch malformed YAML.
                try:
                    import yaml
                    yaml.safe_load(path.read_text().split('---',2)[1])
                except ImportError:pass
                except Exception as exc:errors.append(str(path)+': '+str(exc))
            except Exception as exc:errors.append(str(path)+': '+str(exc))
for path in (ROOT/'scripts').rglob('*.sh'):
    result=subprocess.run(['bash','-n',str(path)],capture_output=True,text=True)
    if result.returncode:errors.append(str(path)+': '+result.stderr.strip())
for path in (ROOT/'scripts').rglob('*.py'):
    try:compile(path.read_text(),str(path),'exec')
    except SyntaxError as exc:errors.append(str(path)+': '+str(exc))
for path in (ROOT/'catalog').glob('*.json'):
    try:json.loads(path.read_text())
    except Exception as exc:errors.append(str(path)+': '+str(exc))
if errors:
    print('\n'.join(errors));sys.exit(1)
print('PASS: '+str(len(names))+' skill/command manifests, native agents, catalogs and script syntax')
