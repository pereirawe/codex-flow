#!/usr/bin/env python3
"""Restore locked upstream clones without copying their skills."""
import argparse
import json
from pathlib import Path
import subprocess
from flowctl import ROOT, vendor_register
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--home',default=str(Path.home()))
args=parser.parse_args()
for entry in json.loads((ROOT/'catalog/vendors.lock.json').read_text()):
    dest=ROOT/'vendor'/entry['name']
    if dest.exists():continue
    if not entry['url'] or not entry['commit']:raise SystemExit('Invalid lock entry: '+entry['name'])
    subprocess.run(['git','clone','--no-checkout',entry['url'],str(dest)],check=True)
    if entry['sparse_patterns']:
        subprocess.run(['git','-C',str(dest),'sparse-checkout','init','--no-cone'],check=True)
        (dest/'.git/info/sparse-checkout').write_text('\n'.join(entry['sparse_patterns'])+'\n')
    subprocess.run(['git','-C',str(dest),'checkout',entry['commit']],check=True)
print('Registered vendor skills:',vendor_register(args.home))
