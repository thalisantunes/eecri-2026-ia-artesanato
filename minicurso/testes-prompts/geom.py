"""Funcoes de apoio do check.py: rodar o OpenSCAD, ler o SVG (aneis e caixas) e testar pontos."""
import re, subprocess, os, math, sys, tempfile

def run_openscad(scad, layer, defs=None, outdir=None, tag=""):
    outdir = outdir or tempfile.mkdtemp(prefix="osc_")
    out = os.path.join(outdir, f"{os.path.basename(scad)[:-5]}{tag}-{layer}.svg")
    if os.path.exists(out):
        os.remove(out)
    cmd = ["openscad", "-D", f'layer="{layer}"']
    for k, v in (defs or {}).items():
        cmd += ["-D", f"{k}={v}"]
    cmd += ["-o", out, scad]
    r = subprocess.run(cmd, capture_output=True, text=True)
    lines = r.stderr.splitlines()
    return r.returncode, lines, (out if os.path.exists(out) else None)

def parse_svg(path):
    s = open(path, encoding="utf-8").read()
    vb = re.search(r'viewBox="([^"]*)"', s).group(1)
    d = re.search(r'<path d="(.*?)"', s, re.S).group(1)
    rings, cur = [], []
    for tok in re.finditer(r'([MLz])\s*(-?[\d.e+-]+)?,?(-?[\d.e+-]+)?', d):
        c, a, b = tok.groups()
        if c == "M":
            if cur: rings.append(cur)
            cur = [(float(a), -float(b))]
        elif c == "L":
            cur.append((float(a), -float(b)))
        elif c == "z":
            if cur: rings.append(cur); cur = []
    if cur: rings.append(cur)
    return vb, rings

def bbox(ring):
    xs = [p[0] for p in ring]; ys = [p[1] for p in ring]
    return min(xs), min(ys), max(xs), max(ys)

def bbox_all(rings):
    xs = [p[0] for r in rings for p in r]; ys = [p[1] for r in rings for p in r]
    return min(xs), min(ys), max(xs), max(ys)

def area(ring):
    a = 0.0
    for (x1, y1), (x2, y2) in zip(ring, ring[1:] + ring[:1]):
        a += x1 * y2 - x2 * y1
    return a / 2

def inside(rings, x, y):
    """regra par-impar sobre varios aneis"""
    c = False
    for ring in rings:
        for (x1, y1), (x2, y2) in zip(ring, ring[1:] + ring[:1]):
            if (y1 > y) != (y2 > y):
                xi = x1 + (y - y1) * (x2 - x1) / (y2 - y1)
                if xi > x:
                    c = not c
    return c

def split_marks(rings, small=1.2):
    marks, body = [], []
    for r in rings:
        x0, y0, x1, y1 = bbox(r)
        (marks if max(x1 - x0, y1 - y0) < small else body).append(r)
    return marks, body

def forbidden(code):
    issues = []
    pats = {
        "3D": r"\b(cube|cylinder|sphere|linear_extrude|rotate_extrude|polyhedron)\s*\(",
        "recurso_inexistente": r"\b(roof|fill|textmetrics)\s*\(",
        "biblioteca": r"\b(include|use)\s*<",
        "minkowski": r"\bminkowski\s*\(",
    }
    for k, p in pats.items():
        if re.search(p, code):
            issues.append(k)
    return issues

def has_params(code, names):
    missing = []
    for n in names:
        if not re.search(r"(?m)^\s*" + re.escape(n) + r"\s*=", code):
            missing.append(n)
    return missing

def report(title, items):
    print(f"--- {title}")
    ok = True
    for name, passed, detail in items:
        mark = "OK " if passed else "FALHA"
        if not passed: ok = False
        print(f"  [{mark}] {name}: {detail}")
    return ok
