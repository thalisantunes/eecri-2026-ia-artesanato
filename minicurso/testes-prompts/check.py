"""Conferencia por script das respostas do teste cego dos prompts.

Uso, dentro desta pasta (precisa do OpenSCAD 2021.01 no PATH e do Python 3):
    python3 check.py p1 prompt-1-chaveiro-haiku-rodada-2.scad
    python3 check.py p2 | p3 | p4 | p5  seguido do arquivo .scad
    python3 check.py p4_anterior prompt-4-dobradica-haiku-rodada-1.scad
(p4_anterior confere a receita antiga do Prompt 4, usada nas rodadas 1 e 2.)
Cada conferencia exporta as camadas com o OpenSCAD e mede o SVG; veja geom.py.
"""
import sys, os, re, math
sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(__file__))
from geom import *

def near(a, b, tol): return abs(a - b) <= tol

def base_checks(scad, extra_params, defs=None):
    code = open(scad, encoding="utf-8").read()
    items = []
    res = {}
    for layer in ("cut", "engrave"):
        rc, lines, svg = run_openscad(scad, layer, defs)
        warn = [l for l in lines if "WARNING" in l or "ERROR" in l]
        echo = [l for l in lines if l.startswith("ECHO")]
        items.append((f"{layer}: exporta", rc == 0 and svg is not None, f"rc={rc} svg={'sim' if svg else 'nao'}"))
        items.append((f"{layer}: console sem WARNING/ERROR", not warn, "; ".join(warn[:2]) or "limpo"))
        items.append((f"{layer}: echo() presente", bool(echo), (echo[0][:90] if echo else "nenhum")))
        if svg:
            vb, rings = parse_svg(svg)
            res[layer] = (vb, rings)
    if len(res) == 2:
        items.append(("viewBox igual nas duas camadas", res["cut"][0] == res["engrave"][0], f"{res['cut'][0]} | {res['engrave'][0]}"))
    iss = forbidden(code)
    items.append(("sem 3D/recurso inexistente/biblioteca", not iss, ",".join(iss) or "limpo"))
    miss = has_params(code, ["layer", "registration"] + extra_params)
    items.append(("parametros esperados no topo", not miss, "faltam: " + ",".join(miss) if miss else "todos"))
    m = re.search(r"(?m)^\s*layer\s*=\s*\"cut\"\s*;\s*//\s*\[cut,\s*engrave\]", code)
    items.append(("layer com comentario do Customizer", bool(m), "ok" if m else "ausente"))
    return code, res, items

def p1(scad):
    names = ["width", "height", "corner_radius", "hole_diameter", "hole_margin", "label", "font_size", "bold", "text_margin"]
    code, res, items = base_checks(scad, names)
    if "cut" in res:
        marks, body = split_marks(res["cut"][1])
        outer = max(body, key=lambda r: abs(area(r))) if body else None
        holes = [r for r in body if r is not outer]
        if outer:
            x0, y0, x1, y1 = bbox(outer)
            items.append(("contorno 70 x 25", near(x1 - x0, 70, .1) and near(y1 - y0, 25, .1), f"{x1-x0:.2f} x {y1-y0:.2f}"))
        ok_hole = False; det = "sem furo"
        if holes:
            hx0, hy0, hx1, hy1 = bbox(holes[0])
            cx, cy = (hx0 + hx1) / 2, (hy0 + hy1) / 2
            ok_hole = near(hx1 - hx0, 4.5, .1) and near(cx, 5.75, .15) and near(cy, 12.5, .15)
            det = f"d={hx1-hx0:.2f} centro=({cx:.2f},{cy:.2f})"
        items.append(("furo 4,5 mm a 3,5 mm da borda", ok_hole, det))
        items.append(("2 marcas de registro", len(marks) == 2, f"{len(marks)} marcas"))
    if "engrave" in res:
        marks, body = split_marks(res["engrave"][1])
        if body:
            x0, y0, x1, y1 = bbox_all(body)
            items.append(("texto na area livre x[11,67]", x0 >= 10.9 and x1 <= 67.1, f"x {x0:.1f}..{x1:.1f}"))
            items.append(("texto centrado na altura", near((y0 + y1) / 2, 12.5, 1.6), f"centro y={(y0+y1)/2:.2f}"))
            items.append(("tamanho do texto ~8 (MARIA)", near(y1 - y0, 7.6, 0.8), f"altura={y1-y0:.2f}"))
    # nome longo
    rc, lines, svg = run_openscad(scad, "engrave", {"label": '"ALEXANDRE"'}, tag="-long")
    if svg:
        _, rings = parse_svg(svg); marks, body = split_marks(rings)
        x0, y0, x1, y1 = bbox_all(body)
        items.append(("nome de 9 letras cabe e encolhe", x0 >= 10.9 and x1 <= 67.1 and (y1 - y0) < 7.6, f"x {x0:.1f}..{x1:.1f}, altura {y1-y0:.2f}"))
    else:
        items.append(("nome de 9 letras exporta", False, "falhou"))
    # width parametrico
    rc, lines, svg = run_openscad(scad, "cut", {"width": 80}, tag="-w80")
    if svg:
        _, rings = parse_svg(svg); marks, body = split_marks(rings)
        outer = max(body, key=lambda r: abs(area(r))); x0, y0, x1, y1 = bbox(outer)
        items.append(("width=80 muda a peca", near(x1 - x0, 80, .1), f"{x1-x0:.2f}"))
    else:
        items.append(("width=80 exporta", False, "falhou"))
    return report("P1 chaveiro: " + os.path.basename(scad), items)

def plate_pattern(ring, t, n, fh, side):
    x0, y0, x1, y1 = bbox(ring)
    xs = x0 + t / 2 if side == "L" else x1 - t / 2
    pat = ""
    for i in range(n):
        z = y0 + (i + .5) * fh
        pat += "X" if inside([ring], xs, z) else "O"
    return pat

def line_intervals(ring, x, y0, y1):
    """intervalos de material ao longo da linha vertical x (de y0 a y1)"""
    ys = []
    for (xa, ya), (xb, yb) in zip(ring, ring[1:] + ring[:1]):
        if (xa > x) != (xb > x):
            ys.append(ya + (x - xa) * (yb - ya) / (xb - xa))
    ys.sort()
    return [(ys[i], ys[i + 1]) for i in range(0, len(ys) - 1, 2)]

def p2(scad):
    names = ["length", "width", "height", "thickness", "finger_width", "clearance", "with_lid", "spacing", "label", "font_size", "bold"]
    code, res, items = base_checks(scad, names)
    if "cut" in res:
        marks, body = split_marks(res["cut"][1])
        items.append(("2 marcas de registro", len(marks) == 2, f"{len(marks)}"))
        dims = sorted([(round(bbox(r)[2] - bbox(r)[0], 1), round(bbox(r)[3] - bbox(r)[1], 1)) for r in body])
        want = sorted([(80, 60), (80, 60), (80, 40), (80, 40), (60, 40), (60, 40)])
        items.append(("6 pecas com as dimensoes certas", dims == want, str(dims)))
        fb = [r for r in body if near(bbox(r)[2]-bbox(r)[0], 80, .15) and near(bbox(r)[3]-bbox(r)[1], 40, .15)]
        lr = [r for r in body if near(bbox(r)[2]-bbox(r)[0], 60, .15) and near(bbox(r)[3]-bbox(r)[1], 40, .15)]
        t, n, fh = 3, 5, 8.0
        if len(fb) == 2 and len(lr) == 2:
            pf = [plate_pattern(r, t, n, fh, s) for r in fb for s in "LR"]
            pl = [plate_pattern(r, t, n, fh, s) for r in lr for s in "LR"]
            items.append(("frente/tras: mesmo padrao nas 4 pontas", len(set(pf)) == 1, str(pf)))
            items.append(("laterais: mesmo padrao nas 4 pontas", len(set(pl)) == 1, str(pl)))
            comp = len(set(pf)) == 1 and len(set(pl)) == 1 and all((a == "X") != (b == "X") for a, b in zip(pf[0], pl[0]))
            items.append(("padroes complementares (canto fecha)", comp, f"{pf[0]} x {pl[0]}"))
            # folga: largura do vazio menos largura do dedo, em intervalo interno
            def widths(r):
                x0, y0, x1, y1 = bbox(r)
                iv = line_intervals(r, x0 + t / 2, y0, y1)
                return [round(b - a, 3) for a, b in iv]
            wf, wl = widths(fb[0]), widths(lr[0])
            # dedo da frente (material) vs vazio da lateral (indice 2 = material central em frente)
            def interior(wd):
                return wd[1:-1] if len(wd) > 2 else wd
            items.append(("larguras dos dedos medidas", True, f"frente(material)={wf} lateral(material)={wl}"))
            # slack: vazio da lateral no indice 2 menos dedo da frente no indice 2 (se existirem)
            try:
                # frente: material em 0,2,4 -> intervalos [0],[1],[2]; lateral: material em 1,3 -> intervalos [0],[1]
                tab_f = wf[1]            # dedo central (i=2)
                tab_l = wl[0]            # dedo i=1
                x0l, y0l, x1l, y1l = bbox(lr[0])
                # vazio central da lateral (i=2): entre os intervalos de material
                ivl = line_intervals(lr[0], x0l + t / 2, y0l, y1l)
                void_l = ivl[1][0] - ivl[0][1]
                slack = void_l - tab_f
                items.append(("folga dedo x fenda ~0,1 mm", near(slack, 0.1, .04), f"fenda={void_l:.3f} dedo={tab_f:.3f} folga={slack:.3f}"))
            except Exception as e:
                items.append(("folga dedo x fenda", False, f"nao medida: {e}"))
        else:
            items.append(("paredes identificadas", False, f"fb={len(fb)} lr={len(lr)}"))
    if "engrave" in res:
        marks, body = split_marks(res["engrave"][1])
        items.append(("gravacao so na tampa (existe texto)", len(body) > 0, f"{len(body)} aneis de texto"))
        if body:
            x0, y0, x1, y1 = bbox_all(body)
            items.append(("texto sobre uma peca de 80 x 60", (x1 - x0) < 70 and (y1 - y0) < 20, f"{x1-x0:.1f} x {y1-y0:.1f}"))
    # clearance=0: padroes continuam complementares; height=50
    for defs, tag in (({"clearance": 0}, "-c0"), ({"height": 50}, "-h50"), ({"with_lid": "false"}, "-nolid")):
        rc, lines, svg = run_openscad(scad, "cut", defs, tag=tag)
        warn = [l for l in lines if "WARNING" in l or "ERROR" in l]
        ok = rc == 0 and svg is not None and not warn
        det = f"rc={rc}"
        if ok:
            _, rings = parse_svg(svg); marks, body = split_marks(rings)
            det += f", {len(body)} pecas"
            if tag == "-nolid": ok = len(body) == 5
            if tag == "-h50":
                n2 = 2 * math.floor((50 / 8.0 - 1) / 2 + 0.5) + 1
                fh2 = 50.0 / n2
                fb = [r for r in body if near(bbox(r)[2]-bbox(r)[0], 80, .15) and near(bbox(r)[3]-bbox(r)[1], 50, .15)]
                lr = [r for r in body if near(bbox(r)[2]-bbox(r)[0], 60, .15) and near(bbox(r)[3]-bbox(r)[1], 50, .15)]
                if len(fb) == 2 and len(lr) == 2:
                    pf = plate_pattern(fb[0], 3, n2, fh2, "L"); pl = plate_pattern(lr[0], 3, n2, fh2, "L")
                    ok = all((a == "X") != (b == "X") for a, b in zip(pf, pl))
                    det += f", padroes {pf}/{pl}"
                else:
                    ok = False; det += ", paredes de 50 nao achadas"
            if tag == "-c0":
                fb = [r for r in body if near(bbox(r)[2]-bbox(r)[0], 80, .15) and near(bbox(r)[3]-bbox(r)[1], 40, .15)]
                lr = [r for r in body if near(bbox(r)[2]-bbox(r)[0], 60, .15) and near(bbox(r)[3]-bbox(r)[1], 40, .15)]
                if len(fb) == 2 and len(lr) == 2:
                    x0, y0, x1, y1 = bbox(fb[0]); ivf = line_intervals(fb[0], x0 + 1.5, y0, y1)
                    x0l, y0l, x1l, y1l = bbox(lr[0]); ivl = line_intervals(lr[0], x0l + 1.5, y0l, y1l)
                    # soma dos materiais frente + laterais deve ser a altura (sem sobra nem falta)
                    tot = sum(b - a for a, b in ivf) + sum(b - a for a, b in ivl)
                    ok = near(tot, 40, .02); det += f", material somado na zona={tot:.3f} (esperado 40)"
        items.append((f"variacao {defs}", ok, det))
    return report("P2 caixa: " + os.path.basename(scad), items)

def p3(scad):
    names = ["width", "height", "corner_radius", "margin", "holes", "hole_diameter", "hole_margin", "title", "title_size", "subtitle", "subtitle_size", "line_gap", "bold", "border", "border_width", "border_inset"]
    code, res, items = base_checks(scad, names)
    if "cut" in res:
        marks, body = split_marks(res["cut"][1])
        outer = max(body, key=lambda r: abs(area(r))); holes = [r for r in body if r is not outer]
        x0, y0, x1, y1 = bbox(outer)
        items.append(("contorno 120 x 50", near(x1-x0, 120, .1) and near(y1-y0, 50, .1), f"{x1-x0:.2f} x {y1-y0:.2f}"))
        cs = sorted([((bbox(h)[0]+bbox(h)[2])/2, (bbox(h)[1]+bbox(h)[3])/2, bbox(h)[2]-bbox(h)[0]) for h in holes])
        ok = len(cs) == 2 and near(cs[0][0], 6, .2) and near(cs[1][0], 114, .2) and all(near(c[1], 44, .2) and near(c[2], 4, .1) for c in cs)
        items.append(("2 furos de 4 mm nos cantos de cima", ok, str([(round(a,2), round(b,2), round(c,2)) for a,b,c in cs])))
    if "engrave" in res:
        marks, body = split_marks(res["engrave"][1])
        if body:
            x0, y0, x1, y1 = bbox_all(body)
            items.append(("texto dentro da largura livre [6,114]", x0 >= 5.9 and x1 <= 114.1, f"x {x0:.1f}..{x1:.1f}"))
            items.append(("texto centralizado em x", near((x0+x1)/2, 60, 1.5), f"centro x={(x0+x1)/2:.2f}"))
            # duas linhas: separar por y em torno de 25
            up = [r for r in body if (bbox(r)[1]+bbox(r)[3])/2 > 25]; dn = [r for r in body if (bbox(r)[1]+bbox(r)[3])/2 <= 25]
            items.append(("titulo acima e subtitulo abaixo do centro", len(up) > 0 and len(dn) > 0, f"{len(up)} aneis acima, {len(dn)} abaixo"))
    for defs, tag in (({"border": "true"}, "-b"), ({"holes": 0}, "-h0"), ({"title": '"UM TITULO MUITO MAIS LONGO DO QUE CABE NA PLACA"'}, "-long")):
        rc, lines, svg = run_openscad(scad, "engrave" if tag != "-h0" else "cut", defs, tag=tag)
        ok = rc == 0 and svg is not None; det = f"rc={rc}"
        if ok:
            _, rings = parse_svg(svg); marks, body = split_marks(rings)
            x0, y0, x1, y1 = bbox_all(body)
            if tag == "-b": ok = 2.4 <= x0 <= 2.6 and 117.4 <= x1 <= 117.6; det += f", bbox {x0:.1f}..{x1:.1f} (moldura a 2,5 mm da borda)"
            if tag == "-long": ok = x0 >= 5.9 and x1 <= 114.1; det += f", bbox {x0:.1f}..{x1:.1f}"
            if tag == "-h0": ok = len(body) == 1; det += f", {len(body)} contorno(s)"
        items.append((f"variacao {defs}", ok, det))
    return report("P3 placa: " + os.path.basename(scad), items)

def p4_anterior(scad):
    names = ["length", "width", "slot_length", "slot_gap", "row_spacing", "rigid_end", "edge_margin", "slot_width", "corner_radius"]
    code, res, items = base_checks(scad, names)
    if "cut" in res:
        marks, body = split_marks(res["cut"][1])
        outer = max(body, key=lambda r: abs(area(r))); slots = [r for r in body if r is not outer]
        x0, y0, x1, y1 = bbox(outer)
        W, H = x1 - x0, y1 - y0
        horiz = near(W, 80, .15) and near(H, 50, .15)
        vert = near(W, 50, .15) and near(H, 80, .15)
        items.append(("contorno 80 x 50 (qualquer orientacao)", horiz or vert, f"{W:.2f} x {H:.2f}"))
        items.append(("2 marcas de registro", len(marks) == 2, f"{len(marks)}"))
        items.append(("numero de fendas plausivel (>= 60)", len(slots) >= 60, f"{len(slots)} fendas"))
        if slots:
            dims = [(bbox(s)[2]-bbox(s)[0], bbox(s)[3]-bbox(s)[1]) for s in slots]
            thin = [min(d) for d in dims]; lens = [max(d) for d in dims]
            items.append(("fendas finas (~0,1 mm)", all(near(t, .1, .03) for t in thin), f"largura min={min(thin):.3f} max={max(thin):.3f}"))
            items.append(("comprimento das fendas <= 15", max(lens) <= 15.05, f"max={max(lens):.2f}"))
            # direcao: fendas paralelas ao lado de 50
            along_x = sum(1 for d in dims if d[0] > d[1])
            slit_dir_ok = (vert and along_x > len(slots)*0.9) or (horiz and along_x < len(slots)*0.1)
            items.append(("fendas paralelas ao lado `width` (50)", slit_dir_ok, f"{along_x} de {len(slots)} horizontais; peca {'horizontal' if horiz else 'vertical'}"))
            # zonas rigidas e margens
            if horiz:
                cx = sorted((bbox(s)[0]+bbox(s)[2])/2 for s in slots); lat = [(bbox(s)[1], bbox(s)[3]) for s in slots]
                items.append(("sem fenda nas pontas rigidas (10 mm)", cx[0] >= x0 + 10 - .05 and cx[-1] <= x1 - 10 + .05, f"primeira em {cx[0]-x0:.2f}, ultima a {x1-cx[-1]:.2f}"))
                items.append(("sem fenda a menos de 4 mm das bordas laterais", min(a for a, b in lat) >= y0 + 4 - .05 and max(b for a, b in lat) <= y1 - 4 + .05, f"{min(a for a,b in lat)-y0:.2f} / {y1-max(b for a,b in lat):.2f}"))
                rows = sorted(set(round(c, 2) for c in cx))
            else:
                cy = sorted((bbox(s)[1]+bbox(s)[3])/2 for s in slots); lat = [(bbox(s)[0], bbox(s)[2]) for s in slots]
                items.append(("sem fenda nas pontas rigidas (10 mm)", cy[0] >= y0 + 10 - .05 and cy[-1] <= y1 - 10 + .05, f"primeira em {cy[0]-y0:.2f}, ultima a {y1-cy[-1]:.2f}"))
                items.append(("sem fenda a menos de 4 mm das bordas laterais", min(a for a, b in lat) >= x0 + 4 - .05 and max(b for a, b in lat) <= x1 - 4 + .05, f"{min(a for a,b in lat)-x0:.2f} / {x1-max(b for a,b in lat):.2f}"))
                rows = sorted(set(round(c, 2) for c in cy))
            gaps = [round(b - a, 2) for a, b in zip(rows, rows[1:])]
            items.append(("espacamento entre fileiras ~2,5", gaps and all(near(g, 2.5, .06) for g in gaps), f"{len(rows)} fileiras, gaps min/max {min(gaps) if gaps else None}/{max(gaps) if gaps else None}"))
    return report("P4 dobradica (receita anterior): " + os.path.basename(scad), items)

def p4(scad):
    """Prompt 4 (receita atual): reproduz o padrao de laser/modelos/dobradica-viva.scad.
    So camada cut, sem marcas de registro e sem corner_radius."""
    code = open(scad, encoding="utf-8").read()
    items = []
    rc, lines, svg = run_openscad(scad, "cut")
    warn = [l for l in lines if "WARNING" in l or "ERROR" in l]
    echo = [l for l in lines if l.startswith("ECHO")]
    items.append(("cut: exporta", rc == 0 and svg is not None, f"rc={rc}"))
    items.append(("cut: console sem WARNING/ERROR", not warn, "; ".join(warn[:2]) or "limpo"))
    items.append(("echo() presente", bool(echo), (echo[0][:100] if echo else "nenhum")))
    iss = forbidden(code)
    items.append(("sem 3D/recurso inexistente/biblioteca", not iss, ",".join(iss) or "limpo"))
    names = ["layer", "length", "width", "slot_length", "slot_gap", "row_spacing", "rigid_end", "edge_margin", "slot_width", "overshoot"]
    miss = has_params(code, names)
    items.append(("parametros esperados no topo", not miss, "faltam: " + ",".join(miss) if miss else "todos"))
    if svg:
        vb, rings = parse_svg(svg)
        marks, body = split_marks(rings, small=0.3)
        allr = body
        x0, y0, x1, y1 = bbox_all(allr)
        items.append(("contorno 80 x 50", near(x1 - x0, 80, .1) and near(y1 - y0, 50, .1), f"{x1-x0:.2f} x {y1-y0:.2f}, viewBox {vb}"))
        # modelo de referencia (formulas da receita)
        L, W, sl, sg, rs, re_, em, sw, ov = 80.0, 50.0, 15.0, 3.0, 2.5, 10.0, 4.0, 0.1, 1.0
        n_rows = math.floor((L - 2 * re_) / rs) + 1
        xs0 = (L - (n_rows - 1) * rs) / 2
        period = sl + sg; inner = W - 2 * em
        n_even = math.floor((inner + sg) / period)
        ys0 = em + (inner - (n_even * period - sg)) / 2
        slots = []   # (x, ya, yb, parity)
        for r in range(n_rows):
            xr = xs0 + r * rs
            if r % 2 == 0:
                for k in range(n_even):
                    slots.append((xr, ys0 + k * period, ys0 + k * period + sl, 0))
            else:
                for k in range(n_even + 1):
                    a0 = ys0 - period / 2 + k * period
                    ya = -ov if k == 0 else a0
                    yb = W + ov if k == n_even else a0 + sl
                    slots.append((xr, ya, yb, 1))
        items.append(("referencia: 25 fileiras, 62 fendas", n_rows == 25 and len(slots) == 62, f"{n_rows} fileiras, {len(slots)} fendas"))
        # origem do SVG: o OpenSCAD escreve y invertido; parse_svg ja devolve y para cima
        def mat(x, y):
            return inside(body, x + 0.0, y + 0.0)
        bad_void, bad_mat, n_void, n_mat = [], [], 0, 0
        ox, oy = x0, y0   # se o contorno nao comeca em (0,0), mede relativo
        for (xr, ya, yb, par) in slots:
            lo, hi = max(ya, 0.0), min(yb, W)
            mid = (lo + hi) / 2
            for dx in (0.0, 0.03, -0.03):
                for yy in (mid, lo + 0.1, hi - 0.1):
                    n_void += 1
                    if mat(ox + xr + dx, oy + yy):
                        bad_void.append((round(xr + dx, 3), round(yy, 2)))
            for dx in (0.08, -0.08):
                n_mat += 1
                if not mat(ox + xr + dx, oy + mid):
                    bad_mat.append((round(xr + dx, 3), round(mid, 2)))
            if ya > 0:
                n_mat += 1
                if not mat(ox + xr, oy + ya - 0.1):
                    bad_mat.append((round(xr, 3), round(ya - 0.1, 2)))
            if yb < W:
                n_mat += 1
                if not mat(ox + xr, oy + yb + 0.1):
                    bad_mat.append((round(xr, 3), round(yb + 0.1, 2)))
        items.append((f"{n_void} pontos no eixo das fendas esperadas estao vazados", not bad_void, f"{len(bad_void)} falhas {bad_void[:3]}"))
        items.append((f"{n_mat} pontos ao lado e nas pontes estao com material", not bad_mat, f"{len(bad_mat)} falhas {bad_mat[:3]}"))
        # material em todo o resto (grade fora das fendas)
        bad_grid, n_grid = [], 0
        gx = 0.17
        while gx < L:
            gy = 0.13
            while gy < W:
                n_grid += 1
                if not mat(ox + gx, oy + gy):
                    bad_grid.append((round(gx, 2), round(gy, 2)))
                gy += 0.97
            gx += 0.5
        items.append((f"grade de {n_grid} pontos longe das fendas: sempre material", not bad_grid, f"{len(bad_grid)} falhas {bad_grid[:3]}"))
    # variacao: width = 70 (n_even muda de 2 para 3) -> tem de exportar limpo
    rc2, lines2, svg2 = run_openscad(scad, "cut", {"width": 70}, tag="-w70")
    w2 = [l for l in lines2 if "WARNING" in l or "ERROR" in l]
    ok2 = rc2 == 0 and svg2 is not None and not w2
    det2 = f"rc={rc2}"
    if ok2:
        vb2, rings2 = parse_svg(svg2); m2, b2 = split_marks(rings2, small=0.3); a, b, c, d = bbox_all(b2)
        ok2 = near(c - a, 80, .1) and near(d - b, 70, .1); det2 += f", {c-a:.2f} x {d-b:.2f}"
    items.append(("variacao width=70 exporta limpo e com 80 x 70", ok2, det2))
    return report("P4 dobradica: " + os.path.basename(scad), items)

def p5(scad):
    names = ["labels", "columns", "tag_gap", "tag_width", "tag_height", "corner_radius", "hole_diameter", "hole_margin", "font_size", "bold", "text_margin"]
    code, res, items = base_checks(scad, names)
    if "cut" in res:
        marks, body = split_marks(res["cut"][1])
        outers = [r for r in body if near(bbox(r)[2]-bbox(r)[0], 70, .15) and near(bbox(r)[3]-bbox(r)[1], 25, .15)]
        holes = [r for r in body if r not in outers]
        items.append(("8 contornos de 70 x 25", len(outers) == 8, f"{len(outers)}"))
        items.append(("8 furos", len(holes) == 8, f"{len(holes)}"))
        if body:
            x0, y0, x1, y1 = bbox_all(body)
            items.append(("lote 143 x 109", near(x1-x0, 143, .2) and near(y1-y0, 109, .2), f"{x1-x0:.2f} x {y1-y0:.2f}"))
        cols = sorted(set(round(bbox(r)[0], 1) for r in outers)); rows = sorted(set(round(bbox(r)[1], 1) for r in outers))
        items.append(("grade de 2 colunas x 4 linhas", len(cols) == 2 and len(rows) == 4, f"colunas={cols} linhas={rows}"))
    if "engrave" in res and "cut" in res:
        marks, body = split_marks(res["engrave"][1])
        _, cbody = split_marks(res["cut"][1])
        outers = [r for r in cbody if near(bbox(r)[2]-bbox(r)[0], 70, .15) and near(bbox(r)[3]-bbox(r)[1], 25, .15)]
        cells = {}
        for o in outers:
            ox0, oy0, ox1, oy1 = bbox(o); key = (round(ox0, 1), round(oy0, 1)); cells[key] = [r for r in body if ox0 <= bbox(r)[0] and bbox(r)[2] <= ox1 and oy0 <= bbox(r)[1] and bbox(r)[3] <= oy1]
        n_with = sum(1 for k, v in cells.items() if v)
        items.append(("texto dentro de cada um dos 8 chaveiros", n_with == 8 and sum(len(v) for v in cells.values()) == len(body), f"{n_with} celulas com texto, {len(body)} aneis no total"))
        # ordem: celula superior esquerda = ANA (3 letras) - largura menor que a de GABRIELA (linha 4, col 1)
        def width_of(key):
            v = cells.get(key, []);
            return (bbox_all(v)[2]-bbox_all(v)[0]) if v else 0
        keys = sorted(cells.keys(), key=lambda k: (-k[1], k[0]))   # de cima para baixo, esquerda para direita
        if len(keys) == 8:
            w = [width_of(k) for k in keys]
            # ANA(3) < BRUNO(5) < CARLA(5)... ; GABRIELA e a 7a (indice 6) e deve ser a mais larga ou reduzida
            items.append(("ordem dos nomes: ANA primeiro, HUGO por ultimo", w[0] < w[1] and w[7] < w[6], f"larguras na ordem de leitura: {[round(x,1) for x in w]}"))
            tall = [bbox_all(cells[k])[3]-bbox_all(cells[k])[1] for k in keys]
            items.append(("GABRIELA com letra menor que ANA", tall[6] < tall[0] - 0.3, f"alturas ANA={tall[0]:.2f} GABRIELA={tall[6]:.2f}"))
    for defs, tag, want in (({"labels": '["A","B","C"]'}, "-3", 3), ({"labels": '["A","B","C","D","E","F","G","H","I","J","K","L"]'}, "-12", 12)):
        rc, lines, svg = run_openscad(scad, "cut", defs, tag=tag)
        ok = rc == 0 and svg is not None; det = f"rc={rc}"
        if ok:
            _, rings = parse_svg(svg); marks, body = split_marks(rings)
            outers = [r for r in body if near(bbox(r)[2]-bbox(r)[0], 70, .15)]
            ok = len(outers) == want; det += f", {len(outers)} chaveiros (esperado {want})"
        items.append((f"variacao labels com {want}", ok, det))
    return report("P5 lote: " + os.path.basename(scad), items)

if __name__ == "__main__":
    which, path = sys.argv[1], sys.argv[2]
    {"p1": p1, "p2": p2, "p3": p3, "p4": p4, "p4_anterior": p4_anterior, "p5": p5}[which](path)
