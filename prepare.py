#!/usr/bin/env python3
"""Prepare dotfiles in a new directory; never install into the live home."""
import argparse
from pathlib import Path
import shutil

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output',type=Path,default=Path('prepared'))
parser.add_argument('--home',type=Path,default=Path.home())
args=parser.parse_args()
root=Path(__file__).resolve().parent
output=args.output.resolve()
home=args.home.expanduser().resolve()
if any(c in str(home) for c in ('"','\\','\n','\r')):
    parser.error('Home path contains unsupported configuration characters')
if output.exists():
    parser.error('Output already exists; choose a new directory')
output.mkdir(parents=True)
for relative,destination in [('config','.config'),('bin','.local/bin')]:
    for source in sorted((root/relative).rglob('*')):
        if not source.is_file():
            continue
        target=output/destination/source.relative_to(root/relative)
        target.parent.mkdir(parents=True,exist_ok=True)
        target.write_text(source.read_text().replace('__HOME__',str(home)))
        shutil.copymode(source,target)
print(f'Prepared: {output}')
print('Your live configuration was not changed. Review and copy selected files manually.')
