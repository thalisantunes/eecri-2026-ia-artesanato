# Modelos OpenSCAD para laser

Modelos paramétricos de teste e de exemplo do minicurso "Modelagem 3D com IA generativa para corte a laser" (I EECri, 07/11/2026). Todos em OpenSCAD 2021.01, puro (sem BOSL2), com unidades em milímetros. O topo de cada arquivo é geometria 2D, então `openscad -o saida.svg arquivo.scad` funciona direto.

Os testes são usados no ensaio de quarta 04/11 (`../ensaio-laser.md`). Cada modelo tem, no cabeçalho do `.scad`, o que é, os parâmetros, como exportar e as camadas.

## Modelos

Padrões entre parênteses. Para exportar uma camada: `openscad -D 'layer="cut"' -o NOME-cut.svg NOME.scad` e, quando houver, o mesmo comando com `layer="engrave"`.

| Arquivo | O que é | Parâmetros principais (padrão) | Camadas | Export (camada cut; repita com engrave) |
| --- | --- | --- | --- | --- |
| `teste-potencia-velocidade.scad` | Grade de quadrados de corte para achar potência x velocidade. Velocidade aumenta para a direita, potência para cima | `speeds` ([10,20,30,40,50] mm/s), `powers` ([40,50,60,70,80] %), `square_size` (10), `gap` (4), `label_size` (3), `label_gap` (2), `note` (""), `registration` (false) | cut: quadrados. engrave: números e nota | `openscad -D 'layer="cut"' -o teste-potencia-velocidade-cut.svg teste-potencia-velocidade.scad` |
| `teste-kerf.scad` | Pente de ranhuras mais quadrado de 20 mm para medir o kerf e o encaixe | `slot_widths` ([1.0,1.5,2.0,2.5,3.0] mm), `tooth_width` (6), `slot_depth` (15), `base_height` (10), `square_size` (20), `square_gap` (10), `label_size` (3), `note` (""), `registration` (false) | cut: pente e quadrado. engrave: larguras e "20" | `openscad -D 'layer="cut"' -o teste-kerf-cut.svg teste-kerf.scad` |
| `chaveiro-tag.scad` | Tag com cantos arredondados, furo de argola e texto que se ajusta sozinho à largura | `label` ("EECri 2026"), `font_size` (6), `bold` (true), `width` (60), `height` (25), `corner_radius` (4), `hole_diameter` (4), `hole_margin` (3), `text_margin` (3), `registration` (false) | cut: contorno e furo. engrave: texto | `openscad -D 'layer="cut"' -o chaveiro-tag-cut.svg chaveiro-tag.scad` |
| `caixa-finger-joint.scad` | Caixa aberta em cima, 5 painéis com finger joint, painéis lado a lado em 2D. Tampa opcional | `length` (80), `width` (60), `height` (40) externos; `thickness` (3), `finger_width` (9), `clearance` (0,1), `with_lid` (false), `part_labels` (true), `spacing` (5), `registration` (false) | cut: painéis. engrave: nomes dos painéis | `openscad -D 'layer="cut"' -o caixa-finger-joint-cut.svg caixa-finger-joint.scad` |
| `dobradica-viva.scad` | Tira com padrão de dobradiça viva: ranhuras alternadas. As das fileiras ímpares atravessam a borda, como no FlexEdge do boxes.py; as pontas ficam rígidas | `length` (100), `width` (50), `slot_length` (20), `slot_gap` (4), `row_spacing` (3), `rigid_end` (10), `edge_margin` (4, só nas fileiras pares), `slot_width` (0,1) | só cut | `openscad -o dobradica-viva-cut.svg dobradica-viva.scad` |
| `placa-gravacao.scad` | Placa com título e subtítulo gravados, contorno de corte, furos opcionais e 3 amostras de preenchimento | `title` ("I EECri 2026"), `subtitle` ("Nova Porteirinha - MG"), `title_size` (9), `subtitle_size` (5), `width` (100), `height` (60), `corner_radius` (3), `margin` (6), `holes` (0, 2 ou 4), `hole_diameter` (4), `hole_margin` (4), `patches` (3), `patch_size` (12), `registration` (false) | cut: contorno e furos. engrave: textos e amostras | `openscad -D 'layer="cut"' -o placa-gravacao-cut.svg placa-gravacao.scad` |
| `chaveiros-lote.scad` | Lote de `chaveiro-tag.scad` em grade numa chapa, um por nome | `labels` (24 nomes), `count` (0), `sheet_width` (300), `sheet_height` (200), `sheet_margin` (5), `tag_gap` (4), `sheet` (1), mais os parâmetros da tag (`tag_width` 60, `tag_height` 25...), `registration` (false) | cut: contornos e furos. engrave: nomes | `openscad -D 'layer="cut"' -o chaveiros-lote-cut.svg chaveiros-lote.scad` |

`chaveiros-lote.scad` precisa de `chaveiro-tag.scad` na mesma pasta (`use <chaveiro-tag.scad>`). Os outros modelos são independentes: dá para copiar um arquivo só.

## Exportar tudo: exportar.sh

Dentro desta pasta:

```
bash exportar.sh                        # todos os modelos, parâmetros padrão
bash exportar.sh chaveiro-tag           # só um modelo
bash exportar.sh -n pv-mdf -D 'powers=[80]' -D 'note="MDF 3 mm"' teste-potencia-velocidade
bash exportar.sh -n kit-chaveiros -l cut -D 'labels=[""]' -D count=24 chaveiros-lote   # só a camada de corte
```

O que sai:

| Pasta | Conteúdo |
| --- | --- |
| `svg/` | um SVG por camada, com a caixa (viewBox) igualada entre as camadas do mesmo modelo, e, nos seis modelos de duas camadas, `NOME-combinado.svg`: corte em vermelho (#FF0000, traço fino, sem preenchimento) e gravação em azul (#0000FF) |
| `dxf/` | um DXF por camada, coordenadas absolutas, sem unidade declarada |
| `previa/` | um PNG por camada e `NOME-previa.png` com as camadas juntas (o combinado). Só se houver rsvg-convert, inkscape ou ImageMagick |

O script falha com mensagem clara, e código diferente de zero, se um export falhar ou gerar arquivo vazio, se um nome passado em `-D` não for variável do modelo, ou se as camadas de um modelo ficarem com caixas diferentes depois de igualadas. Com `part_labels=false` na caixa, ele ignora a camada engrave. Variáveis: `OPENSCAD=/caminho/openscad` e `PNG_WIDTH=1400`. Ajuda: `bash exportar.sh -h`. Com `-n NOME`, os arquivos saem como `NOME-cut.svg`, `NOME-engrave.svg`, `NOME-combinado.svg` e a variação não sobrescreve os padrão (`-D` exige `-n`). Com `-l cut`, exporta só a camada de corte.

Variações já exportadas para o ensaio de 04/11 (comandos em `../ensaio-laser.md`, blocos 5 a 9): `pv-r1-mdf`, `pv-r1-acrilico`, `pv-r1-couro`, `kerf-mdf`, `placa-teste`, `lote-300x200` e `lote-600x400`, em `svg/` e `dxf/`, sem prévia em PNG.

## Mudar parâmetros pela linha de comando (-D)

```
openscad -D 'layer="engrave"' -D 'label="Maria"' -D 'width=70' -o maria-engrave.svg chaveiro-tag.scad
```

- Número: `-D width=70`. Booleano: `-D with_lid=true`.
- Texto: aspas duplas dentro de aspas simples, `-D 'label="Maria"'`.
- Lista: `-D 'speeds=[16,18,20,22,24]'`.
- Use os mesmos valores em todas as camadas do mesmo modelo. Se `powers` ou `labels` mudarem de uma camada para a outra, os rótulos não casam com as peças.
- No Windows, o PowerShell e o cmd tratam aspas de outro jeito. Use o Git Bash ou o WSL, ou a interface do OpenSCAD.

Pela interface do OpenSCAD: os parâmetros ficam no topo de cada arquivo e o painel Customizer (no OpenSCAD 2021.01, menu Window, item Hide Customizer, que mostra ou esconde o painel) os mostra como campos, com as descrições dos comentários. Renderize com F6 e exporte em File, Export, Export as SVG. Mude `layer` e exporte de novo para a outra camada.

## Camadas e registro entre elas

O OpenSCAD 2021.01 exporta SVG numa cor só. Por isso cada camada vira um arquivo: `cut` tem só os contornos de corte e `engrave` tem só o texto e as marcas. O `exportar.sh` junta as duas num terceiro arquivo, `svg/NOME-combinado.svg`, com o corte em vermelho puro (#FF0000, traço de 0,1 mm, sem preenchimento) e a gravação em azul puro (#0000FF). Esse é o arquivo principal para o LightBurn, que separa as camadas por cor na importação (conferir na versão instalada). No software, dê ao vermelho o modo linha (corte) e ao azul o modo preenchimento (fill). Os arquivos `-cut.svg` e `-engrave.svg` ficam para os programas que pedem um arquivo por camada.

Atenção ao registro quando as camadas vêm em arquivos separados. O OpenSCAD grava no SVG uma caixa (viewBox) que acompanha a geometria daquele arquivo. A camada de gravação (só texto) tem caixa menor que a de corte, e as duas chegam deslocadas ao Inkscape. O `exportar.sh` corrige isso: iguala a caixa de todas as camadas do modelo, confere de novo e falha se não ficarem iguais. A geometria não muda. Mas o software da laser pode ignorar a caixa. Por isso há duas saídas:

1. o `-combinado.svg`: um arquivo só, então as camadas já nascem alinhadas;
2. o parâmetro `registration` (padrão false). Com `-D registration=true`, cada camada ganha duas marcas de registro: dois círculos de 0,6 mm, idênticos nas duas camadas, nos cantos opostos da caixa que contém a peça, a 3 mm dela. As duas camadas passam a ter exatamente a mesma caixa, e as marcas servem para sobrepor as camadas à mão quando o software importa cada arquivo por conta própria. As marcas ficam fora da peça: apague-as ou deixe que sejam cortadas e gravadas na sobra.

Se for exportar à mão com `openscad`, use no lugar `bash exportar.sh -n NOME -D ... MODELO`, que já faz tudo isso, ou os DXF (coordenadas absolutas).

Não está confirmado se o LightBurn separa o combinado por cor, nem se o LightBurn e o RDWorks preservam a posição relativa de arquivos importados separadamente. Isso é testado nos blocos 2 e 7 de `../ensaio-laser.md` e registrado em a lista de pendências do instrutor (fora da versão pública).

Um SVG do OpenSCAD tem um caminho só por camada, com todas as formas. Em alguns programas as formas chegam como um objeto só e não aceitam camadas diferentes (por exemplo, os 25 quadrados da grade de potência x velocidade). Separe com Break Apart (LightBurn, menu Arrange) ou Caminho, Separar (Inkscape); conferir o nome na versão instalada.

## DXF

O DXF do OpenSCAD 2021.01 sai como segmentos de reta soltos (entidades LINE), não como polilinhas fechadas. O texto vira muitos segmentos. É o caminho para softwares que não importam SVG (o manual do RDWorks V8 lista DXF, AI e PLT). Confira, ao importar, se o contorno vem como um objeto fechado. Se não, use a função de juntar formas do software. Detalhes e alternativas (PLT pelo Inkscape) em `../contingencias.md`, item C10.

## Kerf e clearance

- **Kerf** é a largura do corte. Nunca entra na geometria. É compensado no software de corte (LightBurn: Kerf Offset por camada; RDWorks: compensação). `teste-kerf.scad` serve para medir o valor, com o offset zerado.
- **clearance** é a folga total entre dedo e vazio, em mm, só nos encaixes do `caixa-finger-joint.scad` (e no miolo da tampa). Padrão 0,1 mm. Com `clearance = 0` o encaixe é nominal. Não é o kerf.
- Para ajustar a folga de uma junta: o `clearance` muda a folga de 1 para 1. O offset de kerf muda de 4 para 1 (0,01 mm de offset por lado altera a folga em 0,04 mm). Mexa primeiro no `clearance`.
- Meça a espessura da chapa com paquímetro e use o valor em `thickness`. A espessura varia entre lotes e dentro da chapa.
- Dobradiça viva: desligue o offset de kerf na camada. As ranhuras são mais finas que o kerf.
- Sem offset de kerf no software: faça o offset no Inkscape, com o valor `kerf / 2` no nome do arquivo e o offset do software em zero (`../contingencias.md`, seção "Offset de kerf no Inkscape").

## Texto e fontes

Os textos usam Liberation Sans, que acompanha o OpenSCAD. `chaveiro-tag.scad`, `placa-gravacao.scad` e `chaveiros-lote.scad` ajustam o tamanho do texto para caber na largura livre, com as larguras do Liberation Sans (iguais às do Arial) medidas no OpenSCAD 2021.01. Quando o texto encolhe, o console mostra um aviso (`AVISO: ...`). Se a fonte faltar no computador, ou se a versão do OpenSCAD não for a 2021.01, o texto pode sair com largura um pouco diferente da estimada. Confira a prévia antes de cortar.

## O que foi conferido

- Os 13 exports de camada (SVG e DXF) e os 6 combinados terminam com código 0 e arquivo não vazio com o OpenSCAD 2021.01. Todos os SVG são XML válido e as camadas de cada modelo têm o mesmo viewBox.
- Os 5 painéis da caixa foram montados em 3D em testes de volume, em 36 conjuntos de parâmetros (12 escolhidos e 24 sorteados): sem sobreposição e, com `clearance = 0`, preenchendo a casca da caixa sem sobra. Cada painel é um contorno único, com e sem tampa.
- No SVG padrão da caixa, o dedo da frente mede 8,172 mm e o entalhe da base mede 8,272 mm: a folga medida é de 0,100 mm, igual ao `clearance`.
- Dobradiça viva: as ranhuras das fileiras ímpares cruzam a borda e a tira continua em uma peça só (teste de conectividade por rasterização, em 7 conjuntos de parâmetros).
- `registration=true`: nos seis modelos, as duas camadas ficam com a mesma caixa, as duas marcas são idênticas nas camadas e ficam fora da peça.
- Kit do minicurso: 24 chaveiros de 70 x 25 mm, furo de 4,5 mm a 3,5 mm da borda, e capacidade de 18 por chapa de 300 x 200 mm (104 por chapa de 600 x 400 mm).
- Prévias em PNG conferidas uma a uma em `previa/`.
- Não testado em máquina: importação no LightBurn e no RDWorks, corte e encaixe reais, a receita do Inkscape pela interface. É o que o ensaio mede.
