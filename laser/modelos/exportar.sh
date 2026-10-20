#!/usr/bin/env bash
# =====================================================================
# exportar.sh
# Exporta os modelos .scad desta pasta:
#   svg/     um SVG por camada (cut, engrave) e, nos modelos de duas camadas,
#            NOME-combinado.svg: corte em vermelho (#FF0000, traço fino, sem
#            preenchimento) e gravação em azul (#0000FF). O combinado é o
#            arquivo principal para o LightBurn, que separa as camadas por
#            cor na importação (conferir na versão instalada).
#   dxf/     um DXF por camada (coordenadas absolutas, sem unidade declarada)
#   previa/  um PNG por SVG por camada, mais NOME-previa.png (o combinado).
#            Só se houver rsvg-convert, inkscape (1.x) ou ImageMagick.
#
# Uso:
#   bash exportar.sh                    todos os modelos, parâmetros padrão
#   bash exportar.sh chaveiro-tag       só os modelos citados
#   bash exportar.sh -n NOME [-l camadas] -D var=valor [-D ...] MODELO
#                                       uma variação, gravada como NOME-cut.svg,
#                                       NOME-engrave.svg... (-D exige -n, para
#                                       não sobrescrever os arquivos padrão)
#   -l cut             só a camada de corte (por exemplo, chaveiros em branco)
#   -l cut,engrave     as duas (padrão)
#   Exemplo:
#     bash exportar.sh -n pv-mdf -D 'powers=[80]' -D 'note="MDF 3 mm"' teste-potencia-velocidade
#   Textos entre aspas duplas dentro do -D precisam de aspas simples por fora.
#   Cada nome passado em -D precisa existir como variável do modelo.
#
# Variáveis opcionais:
#   OPENSCAD=/caminho/openscad   (padrão: "openscad" no PATH)
#   PNG_WIDTH=1400               largura dos PNGs, em pixels
#
# O que o script faz além de chamar o OpenSCAD:
#   O OpenSCAD 2021.01 grava em cada SVG uma caixa (viewBox) que acompanha
#   a geometria daquele arquivo. Duas camadas do mesmo modelo teriam caixas
#   diferentes e chegariam deslocadas no Inkscape. O script iguala a caixa
#   de todas as camadas de um modelo (união das caixas), confere de novo que
#   ficaram iguais e falha se não ficaram. A geometria não muda.
#   Se a caixa da caixa-finger-joint sair sem nomes (part_labels=false), a
#   camada engrave é ignorada.
#
# Sai com código diferente de zero, com mensagem, se algum export falhar.
# =====================================================================
set -u
export LC_NUMERIC=C

cd "$(dirname "${BASH_SOURCE[0]}")" || { echo "ERRO: não consegui entrar na pasta do script" >&2; exit 1; }

OPENSCAD="${OPENSCAD:-openscad}"
PNG_WIDTH="${PNG_WIDTH:-1400}"
PREVIEW_PAD=3        # margem em mm, só nos PNGs de prévia

# modelo:camadas
MODELS=(
  "teste-potencia-velocidade:cut engrave"
  "teste-kerf:cut engrave"
  "chaveiro-tag:cut engrave"
  "caixa-finger-joint:cut engrave"
  "dobradica-viva:cut"
  "placa-gravacao:cut engrave"
  "chaveiros-lote:cut engrave"
)

die() { echo "ERRO: $*" >&2; exit 1; }

usage() { sed -n '3,/^# ====/p' "${BASH_SOURCE[0]}" | sed -e '$d' -e 's/^# \{0,1\}//'; }

# --- argumentos ---------------------------------------------------------
NAME=""
LAYER_REQ=""
EXTRA=()     # pares "-D" "var=valor" para o openscad
DEFS=()      # só os "var=valor"
ARGS=()
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    -n|--nome)
      [ $# -ge 2 ] || die "-n precisa de um nome"
      NAME="$2"; shift 2 ;;
    -l|--camadas)
      [ $# -ge 2 ] || die "-l precisa de cut, engrave ou cut,engrave"
      LAYER_REQ="$(echo "$2" | tr ',' ' ')"
      for l in $LAYER_REQ; do
        case "$l" in cut|engrave) ;; *) die "camada desconhecida em -l: $l (use cut ou engrave)" ;; esac
      done
      shift 2 ;;
    -D)
      [ $# -ge 2 ] || die "-D precisa de var=valor"
      case "$2" in
        layer=*) die "não use -D layer: o script exporta cada camada sozinho" ;;
        *=*) ;;
        *) die "-D precisa de var=valor (recebi: $2)" ;;
      esac
      EXTRA+=("-D" "$2"); DEFS+=("$2"); shift 2 ;;
    -*) die "opção desconhecida: $1 (veja: bash exportar.sh -h)" ;;
    *)  ARGS+=("$1"); shift ;;
  esac
done
if [ -n "$NAME" ]; then
  case "$NAME" in *[!A-Za-z0-9._-]*) die "use só letras, números, ponto, hífen e sublinhado em -n" ;; esac
  [ ${#ARGS[@]} -eq 1 ] || die "-n exige exatamente um modelo"
fi
if [ ${#DEFS[@]} -gt 0 ] && [ -z "$NAME" ]; then
  die "-D exige -n NOME (para não sobrescrever os arquivos padrão)"
fi

command -v "$OPENSCAD" >/dev/null 2>&1 \
  || die "openscad não encontrado. Instale o OpenSCAD 2021.01 ou defina OPENSCAD=/caminho/para/openscad"

TMP="$(mktemp -d "${TMPDIR:-/tmp}/exportar.XXXXXX")" || die "não consegui criar pasta temporária"
trap 'rm -rf "$TMP"' EXIT

# --- escolha do conversor de PNG ---------------------------------------
CONV=""
if   command -v rsvg-convert >/dev/null 2>&1; then CONV="rsvg"
elif command -v inkscape     >/dev/null 2>&1; then CONV="inkscape"
elif command -v magick       >/dev/null 2>&1; then CONV="magick"
elif command -v convert      >/dev/null 2>&1 && convert -version 2>/dev/null | grep -qi imagemagick; then CONV="convert"
fi

render_png() {   # entrada.svg saida.png
  case "$CONV" in
    rsvg)     rsvg-convert -w "$PNG_WIDTH" -b white -o "$2" "$1" ;;
    inkscape) inkscape "$1" --export-type=png --export-filename="$2" \
                --export-width="$PNG_WIDTH" --export-background=white \
                --export-background-opacity=1 ;;
    magick)   magick -background white -density 300 "$1" -resize "${PNG_WIDTH}x" -flatten "$2" ;;
    convert)  convert -background white -density 300 "$1" -resize "${PNG_WIDTH}x" -flatten "$2" ;;
  esac
}

# --- utilitários de SVG ------------------------------------------------
svg_viewbox() { sed -n 's/.*viewBox="\([^"]*\)".*/\1/p' "$1" | head -n 1; }

# largura, altura e viewBox do elemento <svg>, numa linha só
svg_box_attrs() { sed -n 's/^<svg \(width="[^"]*" height="[^"]*" viewBox="[^"]*"\).*/\1/p' "$1" | head -n 1; }

set_svg_box() {  # arquivo largura altura viewBox
  sed -E "s|<svg width=\"[^\"]*\" height=\"[^\"]*\" viewBox=\"[^\"]*\"|<svg width=\"${2}mm\" height=\"${3}mm\" viewBox=\"${4}\"|" "$1" > "$1.tmp" \
    && mv "$1.tmp" "$1"
}

unify_boxes() {  # arquivo...
  local f union w h
  union="$(for f in "$@"; do svg_viewbox "$f"; done | awk '
    NF == 4 {
      x0 = $1; y0 = $2; x1 = $1 + $3; y1 = $2 + $4
      if (n == 0 || x0 < ax0) ax0 = x0
      if (n == 0 || y0 < ay0) ay0 = y0
      if (n == 0 || x1 > ax1) ax1 = x1
      if (n == 0 || y1 > ay1) ay1 = y1
      n++
    }
    END { printf "%g %g %g %g", ax0, ay0, ax1 - ax0, ay1 - ay0 }')"
  w="$(echo "$union" | awk '{ printf "%g", $3 }')"
  h="$(echo "$union" | awk '{ printf "%g", $4 }')"
  for f in "$@"; do set_svg_box "$f" "$w" "$h" "$union"; done
}

# relê os arquivos e falha se a caixa (largura, altura, viewBox) não for igual
check_same_box() {  # arquivo...
  local f first="" cur
  for f in "$@"; do
    cur="$(svg_box_attrs "$f")"
    [ -n "$cur" ] || die "não achei a caixa (width, height, viewBox) em $f"
    if [ -z "$first" ]; then first="$cur"
    elif [ "$cur" != "$first" ]; then
      die "as camadas ficaram com caixas diferentes: $f tem [$cur], esperado [$first]"
    fi
  done
}

pad_svg() {      # entrada.svg saida.svg margem_mm
  local vb nvb nw nh
  vb="$(svg_viewbox "$1")"
  nvb="$(echo "$vb" | awk -v p="$3" '{ printf "%g %g %g %g", $1 - p, $2 - p, $3 + 2 * p, $4 + 2 * p }')"
  nw="$(echo "$vb"  | awk -v p="$3" '{ printf "%g", $3 + 2 * p }')"
  nh="$(echo "$vb"  | awk -v p="$3" '{ printf "%g", $4 + 2 * p }')"
  cp "$1" "$2" && set_svg_box "$2" "$nw" "$nh" "$nvb"
}

# Estilos. O OpenSCAD grava todo caminho com STYLE_ORIG.
#   No SVG combinado (entregue): traço fino de 0,1 mm. Corte em vermelho puro,
#   sem preenchimento. Gravação em azul puro, com preenchimento.
#   Nas prévias em PNG: traço de 0,25 mm para aparecer, e gravação sem traço.
STYLE_ORIG='stroke="black" fill="lightgray" stroke-width="0.5"'
STYLE_CUT='stroke="#FF0000" fill="none" stroke-width="0.1"'
STYLE_ENGRAVE='stroke="#0000FF" fill="#0000FF" stroke-width="0.1"'
PREVIEW_CUT='stroke="#FF0000" fill="none" stroke-width="0.25"'
PREVIEW_ENGRAVE='stroke="none" fill="#0000FF"'

# cópia com o estilo da prévia (camada: cut, engrave)
style_preview() {  # entrada.svg saida.svg camada
  case "$3" in
    cut)     sed -e "s|$STYLE_ORIG|$PREVIEW_CUT|" "$1" > "$2" ;;
    engrave) sed -e "s|$STYLE_ORIG|$PREVIEW_ENGRAVE|" "$1" > "$2" ;;
    *)       cp "$1" "$2" ;;
  esac
}

# junta as camadas num SVG só, nas cores do combinado
combine_svg() {  # saida.svg cut.svg engrave.svg
  {
    sed -e "s|$STYLE_ORIG|$STYLE_CUT|" "$2" | sed '$d'
    sed -n '/<path/,$p' "$3" | sed -e "s|$STYLE_ORIG|$STYLE_ENGRAVE|" | sed '$d'
    echo '</svg>'
  } > "$1"
}

# --- exportação --------------------------------------------------------
export_layer() { # modelo base camada formato
  local model="$1" base="$2" layer="$3" ext="$4" out log
  out="$ext/$base-$layer.$ext"
  log="$TMP/$base-$layer-$ext.log"
  if ! "$OPENSCAD" ${EXTRA[@]+"${EXTRA[@]}"} -D "layer=\"$layer\"" -o "$out" "$model.scad" >"$log" 2>&1; then
    rm -f "$out"
    echo "FALHA: o OpenSCAD não conseguiu exportar $out" >&2
    { if grep -qE "ERROR|WARNING|TRACE" "$log"; then grep -E "ERROR|WARNING|TRACE|ECHO" "$log"; else cat "$log"; fi; } \
      | sed 's/^/  | /' >&2
    exit 1
  fi
  grep -E "WARNING|AVISO" "$log" | sed 's/^/  aviso: /' >&2
  [ -s "$out" ] || die "arquivo vazio: $out"
  case "$ext" in
    svg) grep -q "<path" "$out" || die "SVG sem nenhum caminho (geometria vazia): $out" ;;
    dxf) grep -qE "^(LINE|LWPOLYLINE|POLYLINE|ARC|CIRCLE)[[:space:]]*$" "$out" || die "DXF sem entidades (geometria vazia): $out" ;;
  esac
}

# variáveis de topo do modelo, na parte que o usuário muda (até o grupo [Hidden])
model_vars() {  # modelo
  awk '/\[Hidden\]/ { exit } /^[A-Za-z_][A-Za-z_0-9]*[[:space:]]*=/ { sub(/[[:space:]]*=.*/, ""); printf "%s ", $0 }' "$1.scad"
}

# cada nome passado em -D precisa ser variável do modelo
check_defs() {  # modelo
  local model="$1" kv name
  for kv in ${DEFS[@]+"${DEFS[@]}"}; do
    name="${kv%%=*}"
    case "$name" in ""|*[!A-Za-z0-9_]*) die "nome de variável inválido em -D: '$name'" ;; esac
    grep -Eq "^[[:space:]]*${name}[[:space:]]*=" "$model.scad" \
      || die "a variável '$name' não existe em $model.scad. Variáveis do modelo: $(model_vars "$model")"
  done
}

# --- seleção dos modelos -----------------------------------------------
SELECTED=()
if [ ${#ARGS[@]} -gt 0 ]; then
  for arg in "${ARGS[@]}"; do
    name="${arg%.scad}"
    found=""
    for entry in "${MODELS[@]}"; do
      [ "${entry%%:*}" = "$name" ] && found="$entry"
    done
    [ -n "$found" ] || die "modelo desconhecido: $arg"
    SELECTED+=("$found")
  done
else
  SELECTED=("${MODELS[@]}")
fi

mkdir -p svg dxf previa || die "não consegui criar svg/, dxf/ e previa/"

echo "OpenSCAD: $("$OPENSCAD" --version 2>&1 | head -n 1)"
if [ -n "$CONV" ]; then echo "Conversor de PNG: $CONV"; else echo "Conversor de PNG: nenhum (instale rsvg-convert, inkscape ou ImageMagick para gerar as prévias)"; fi

N_SVG=0; N_DXF=0; N_PNG=0
SVG_LIST=()
for entry in "${SELECTED[@]}"; do
  model="${entry%%:*}"
  avail="${entry#*:}"
  base="${NAME:-$model}"
  [ -f "$model.scad" ] || die "arquivo não encontrado: $model.scad"
  check_defs "$model"

  # camadas deste modelo: as pedidas em -l (que o modelo tenha), senão todas
  layers=""
  if [ -n "$LAYER_REQ" ]; then
    for l in $LAYER_REQ; do
      case " $avail " in *" $l "*) layers="$layers $l" ;; esac
    done
    [ -n "$layers" ] || die "o modelo $model não tem a camada pedida em -l ($LAYER_REQ). Camadas: $avail"
  else
    layers="$avail"
  fi
  # caixa sem nomes nos painéis: não há o que gravar
  if [ "$model" = "caixa-finger-joint" ]; then
    for kv in ${DEFS[@]+"${DEFS[@]}"}; do
      if [ "$(echo "$kv" | tr -d ' ')" = "part_labels=false" ]; then
        case " $layers " in *" engrave "*) echo "  (camada engrave ignorada: part_labels=false)" ;; esac
        layers="$(echo " $layers " | sed 's/ engrave / /')"
      fi
    done
    [ -n "$(echo $layers)" ] || die "com part_labels=false só existe a camada cut, e -l não a incluiu"
  fi
  layers="$(echo $layers)"      # tira espaços sobrando
  echo "- $model ($layers)"

  svgs=()
  for layer in $layers; do
    export_layer "$model" "$base" "$layer" svg
    export_layer "$model" "$base" "$layer" dxf
    svgs+=("svg/$base-$layer.svg")
    N_SVG=$((N_SVG + 1)); N_DXF=$((N_DXF + 1))
  done
  unify_boxes "${svgs[@]}"
  check_same_box "${svgs[@]}"
  for s in "${svgs[@]}"; do SVG_LIST+=("$s"); done

  # SVG combinado: só quando há as duas camadas
  combined=""
  has_cut=0; has_engrave=0
  for layer in $layers; do
    [ "$layer" = cut ] && has_cut=1
    [ "$layer" = engrave ] && has_engrave=1
  done
  if [ $has_cut -eq 1 ] && [ $has_engrave -eq 1 ]; then
    combined="svg/$base-combinado.svg"
    combine_svg "$combined" "svg/$base-cut.svg" "svg/$base-engrave.svg"
    [ "$(grep -c '<path' "$combined")" -eq 2 ] || die "o combinado deveria ter 2 caminhos (corte e gravação): $combined"
    check_same_box "svg/$base-cut.svg" "$combined"
    SVG_LIST+=("$combined")
    N_SVG=$((N_SVG + 1))
  fi

  if [ -n "$CONV" ]; then
    # uma prévia por camada
    for layer in $layers; do
      stem="$base-$layer"
      style_preview "svg/$stem.svg" "$TMP/$stem.styled.svg" "$layer"
      pad_svg "$TMP/$stem.styled.svg" "$TMP/$stem.svg" "$PREVIEW_PAD"
      if render_png "$TMP/$stem.svg" "previa/$stem.png" >"$TMP/$stem.png.log" 2>&1 && [ -s "previa/$stem.png" ]; then
        N_PNG=$((N_PNG + 1))
      else
        echo "  aviso: não consegui gerar previa/$stem.png" >&2
      fi
    done
    # prévia do conjunto: o combinado, ou a camada cut se for a única
    if [ -n "$combined" ]; then
      sed -e "s|$STYLE_CUT|$PREVIEW_CUT|" -e "s|$STYLE_ENGRAVE|$PREVIEW_ENGRAVE|" "$combined" > "$TMP/$base-previa.styled.svg"
    else
      style_preview "svg/$base-cut.svg" "$TMP/$base-previa.styled.svg" cut
    fi
    pad_svg "$TMP/$base-previa.styled.svg" "$TMP/$base-previa.svg" "$PREVIEW_PAD"
    if render_png "$TMP/$base-previa.svg" "previa/$base-previa.png" >"$TMP/$base-previa.png.log" 2>&1 && [ -s "previa/$base-previa.png" ]; then
      N_PNG=$((N_PNG + 1))
    else
      echo "  aviso: não consegui gerar previa/$base-previa.png" >&2
    fi
  fi
done

echo
echo "SVG gerados:"
for s in "${SVG_LIST[@]}"; do printf '  %-56s %9s bytes\n' "$s" "$(wc -c < "$s" | tr -d ' ')"; done
echo
echo "Pronto: $N_SVG SVG em svg/, $N_DXF DXF em dxf/, $N_PNG PNG em previa/."
exit 0
