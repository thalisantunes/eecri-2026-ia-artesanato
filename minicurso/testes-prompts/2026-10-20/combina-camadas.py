import re, sys
cut, eng, out = sys.argv[1:4]
def parse(p):
    s = open(p).read()
    vb = re.search(r'viewBox="([^"]+)"', s).group(1)
    paths = re.findall(r'<path d="(.*?)"', s, re.S)
    return [float(x) for x in vb.split()], paths
vb1, pc = parse(cut); vb2, pe = parse(eng)
x0=min(vb1[0],vb2[0]); y0=min(vb1[1],vb2[1])
x1=max(vb1[0]+vb1[2],vb2[0]+vb2[2]); y1=max(vb1[1]+vb1[3],vb2[1]+vb2[3])
pad=4; x0-=pad; y0-=pad; w=x1-x0+pad; h=y1-y0+pad
o=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{w*10:.0f}" height="{h*10:.0f}" viewBox="{x0} {y0} {w} {h}">',
   f'<rect x="{x0}" y="{y0}" width="{w}" height="{h}" fill="#ffffff"/>']
for d in pc:
    o.append(f'<path d="{d}" fill="#e9d3a8" fill-rule="evenodd" stroke="#d1261b" stroke-width="0.45"/>')
for d in pe:
    o.append(f'<path d="{d}" fill="#1f4fbf" fill-rule="evenodd" stroke="none" fill-opacity="0.9"/>')
o.append('</svg>')
open(out,'w').write('\n'.join(o))
