# Capítulo 3. Biblioteca de prompts

Apostila do minicurso "Modelagem 3D com IA generativa para corte a laser".

Um **prompt** é o texto que você manda para o assistente de IA. Este capítulo reúne prompts prontos, um por peça, mais um de ajuste e um de diagnóstico. Copie, troque os valores que quiser e envie.

**Texto impresso não dá para copiar no celular.** O instrutor distribui estes textos em formato digital (grupo da turma, QR code ou pendrive). Se estiver só com o papel, peça o arquivo `03-prompts.md`.

## Como usar

1. **Abra uma conversa nova** no assistente de IA (claude.ai ou equivalente).
2. **Cole o Bloco base** (abaixo) como primeira mensagem. Ele fixa as regras do projeto. O assistente responde "entendido".
3. **Cole o prompt da peça.** Os valores já estão preenchidos; troque os que quiser.
4. **Copie o código** da resposta e siga o ciclo do capítulo 2 (colar no OpenSCAD, F6, ler o console, olhar, medir).
5. **Para mudar algo**, use o prompt de ajuste. **Para um erro**, use o prompt de diagnóstico.

Se o assistente ignorar uma regra, escreva: "Releia as regras 1 a 11 do Bloco base e refaça o arquivo".

## Bloco base (primeira mensagem de toda conversa)

```text
Você vai escrever código OpenSCAD para peças que serão cortadas e gravadas numa máquina a laser. Siga estas regras em todas as respostas desta conversa.

1. Versão: OpenSCAD 2021.01. Use só a linguagem básica. Nada de bibliotecas (nenhum include nem use). Estes recursos NÃO existem nesta versão e não podem aparecer: roof(), fill(), textmetrics(). Não use minkowski(); para cantos arredondados use offset().
2. Unidade: tudo em milímetros. Nunca use centímetros nem polegadas.
3. Só 2D no topo: o que o arquivo gera no nível mais alto deve ser geometria 2D (square, circle, polygon, text, offset, difference, union, translate, rotate). Não use cube, cylinder, linear_extrude, rotate_extrude nem nenhum objeto 3D no topo do arquivo, nem para pré-visualização.
4. Parâmetros: todos os números ficam no começo do arquivo, como variáveis com nome em inglês e um comentário em português, sem acento, com a unidade. Nada de número solto no meio do código, exceto constantes óbvias (0, 1, 2).
5. Camadas: o arquivo tem a variável layer = "cut"; // [cut, engrave]. Quando layer for "cut", o topo gera só o que deve ser CORTADO (contornos e furos). Quando layer for "engrave", gera só o que deve ser GRAVADO (texto e desenhos). O arquivo será exportado duas vezes, uma por camada.
6. Marcas de registro: inclua a variável registration = true; e, quando for true, desenhe nas DUAS camadas dois círculos de 0.6 mm de diâmetro (com $fn = 16). O centro de um fica 3 mm abaixo e 3 mm à esquerda do canto inferior esquerdo da área ocupada pelas peças (3 mm em X e 3 mm em Y); o centro do outro fica 3 mm acima e 3 mm à direita do canto superior direito. Elas fazem os dois arquivos terem o mesmo quadro.
7. Kerf: NÃO compense o kerf na geometria. A compensação é feita no software de corte. A única folga permitida é o parâmetro clearance, usado só em encaixes.
8. Texto: use a fonte Liberation Sans, com o parâmetro bold (true = negrito, o padrão): font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans". O texto deve caber dentro da peça.
9. Círculos: use $fn = 64.
10. Conferência: use echo() para escrever no console as dimensões finais (largura e altura totais da peça ou do conjunto de peças e outros números que eu possa conferir).
11. Resposta: devolva o arquivo COMPLETO num único bloco de código, sem reticências nem trechos omitidos. Depois do código, explique em até 5 linhas o que cada parâmetro faz. Se algo no meu pedido for ambíguo, pergunte antes de escrever o código.

Responda só "entendido" e espere o pedido da peça.
```

---

## Prompt 1. Chaveiro com texto gravado

Exercício 1. Peça plana, a mais simples da aula.

```text
Peça: chaveiro retangular de cantos arredondados, com furo para argola e nome gravado.
Material: MDF de 3 mm. A peça é plana, a espessura não entra no desenho.

Use estes nomes de parâmetros e estes valores iniciais:
- width = 70 (largura da peça, mm)
- height = 25 (altura da peça, mm)
- corner_radius = 4 (raio dos cantos, mm)
- hole_diameter = 4.5 (diâmetro do furo da argola, mm)
- hole_margin = 3.5 (distância da borda esquerda da peça até a borda do furo, mm)
- label = "MARIA" (texto gravado)
- font_size = 8 (tamanho desejado das letras, o size do OpenSCAD, mm)
- bold = true (negrito)
- text_margin = 3 (folga entre o texto e as bordas ou o furo, mm)

Camada "cut": o contorno com cantos arredondados MENOS o furo. O furo deve ser um furo de verdade (use difference()) e fica centralizado na altura.
Camada "engrave": só o texto (mais as marcas de registro), centralizado na altura e na área livre à direita do furo. Essa área começa em hole_margin + hole_diameter + text_margin, contado a partir da borda esquerda, e termina text_margin antes da borda direita. Chame a largura dessa área de text_w.
Se o nome tiver letras demais, reduza o tamanho: tamanho final = min(font_size, text_w / len(label)).
Mostre com echo() a largura e a altura da peça e o tamanho final do texto.
```

**Parâmetros esperados:** `width`, `height`, `corner_radius`, `hole_diameter`, `hole_margin`, `label`, `font_size`, `bold`, `text_margin`, mais `layer` e `registration`.

**O que conferir no resultado:**

- Console com algo como `ECHO: "peca: 70 x 25 mm; texto com tamanho 8"` e nenhum `WARNING`.
- Vista de cima: o furo mostra o fundo; o texto está dentro da peça, longe do furo e das bordas.
- Troque `label` por um nome de 9 letras ("ALEXANDRE"): o tamanho do texto cai (para cerca de 6,2) e o nome continua dentro da peça.
- Teste uma letra acentuada ("JOÃO", "ÉRICA").
- Cabeçalho dos dois SVG com o mesmo `viewBox` e cerca de `width="78mm" height="33mm"` (peça de 70 x 25 mais as marcas).

**Armadilhas:**

- O furo desenhado por cima da peça, sem `difference()`: aparece um círculo, mas a peça continua inteira por baixo.
- Texto deslocado para a esquerda, em cima do furo.
- Texto de menos de 5 mm de altura: não fica legível na gravação.
- **Nome com mais de 10 letras:** o tamanho do texto cai para perto de 5 mm ou menos. Use só o primeiro nome ou peça `width = 80` (com 80 mm, cabem 13 letras com tamanho 5 ou mais).
- Marcas de registro esquecidas numa das camadas: as camadas deixam de se alinhar.

---

## Prompt 2. Caixa com encaixe tipo finger joint

Exercício 2. A peça mais difícil do minicurso. **Finger joint** (encaixe de dedos, também chamado *box joint*) é o canto em que as duas peças têm "dedos" que entram nas "fendas" da outra. Cole o prompt inteiro: a receita dos dedos é o que evita a maior parte dos erros.

```text
Peça: caixa pequena de MDF com cantos de encaixe tipo finger joint e tampa lisa opcional.
Material: MDF de 3 mm. Eu vou medir a espessura real com paquímetro e colocar o valor em thickness.

Use estes nomes de parâmetros e estes valores iniciais:
- length = 80, width = 60, height = 40 (medidas EXTERNAS da caixa: comprimento em X, largura em Y e altura das paredes, mm)
- thickness = 3 (espessura do material, mm)
- finger_width = 8 (largura-alvo de cada dedo, mm)
- clearance = 0.1 (folga total entre dedo e fenda, mm)
- with_lid = true (se true, inclui uma tampa lisa de length x width; se false, a caixa fica aberta)
- spacing = 4 (espaço entre as peças no desenho, mm)
- label = "CAIXA" e font_size = 8 (texto gravado no centro da tampa, tamanho desejado das letras, o size do OpenSCAD, mm; só vale se with_lid for true)
- bold = true

Peças: 4 paredes (frente e trás com length x height; duas laterais com width x height), um fundo liso length x width (será colado por baixo das paredes) e a tampa lisa length x width. Total de 6 peças com tampa e 5 sem. Os dedos existem só nos 4 cantos verticais das paredes. O fundo e a tampa não têm dedos.

Receita dos dedos (siga exatamente):
1. Calcule n, o número de dedos ao longo da altura, como número ÍMPAR: n = 2 * round((height / finger_width - 1) / 2) + 1. A largura nominal de cada dedo é fh = height / n.
2. Divida a altura de cada parede em n faixas de largura fh, numeradas de 0 a n - 1, de baixo para cima.
3. Em cada ponta de cada parede existe uma zona de encaixe com largura igual a thickness. Nessa zona, frente e trás têm material nas faixas PARES (0, 2, 4...) e ficam vazados nas ÍMPARES. As duas laterais fazem o contrário: material nas faixas ÍMPARES e vazado nas PARES. Assim, em cada canto, uma peça preenche o que a outra deixa vazio.
4. A folga clearance só afeta a largura das faixas ao longo da altura: o dedo fica clearance/2 mais estreito que fh e a fenda fica clearance/2 mais larga, de modo que a fenda seja clearance mais larga que o dedo. Não mexa na profundidade dos encaixes nem nas bordas externas.
5. Mostre com echo(): n, a largura do dedo, a largura da fenda e a folga.

Disposição das peças no desenho 2D (camada "cut"), com spacing entre todas: primeira linha, fundo e tampa lado a lado; segunda linha, frente e trás (length x height); terceira linha, as duas laterais (width x height).
Camada "engrave": só o texto no centro da tampa (se with_lid for true), mais as marcas de registro.
Mostre com echo() as medidas totais do desenho.
```

**Parâmetros esperados:** `length`, `width`, `height`, `thickness`, `finger_width`, `clearance`, `with_lid`, `spacing`, `label`, `font_size`, `bold`, mais `layer` e `registration`.

**O que conferir no resultado:**

- Console: `n` **ímpar** (com as medidas iniciais, 5 dedos de 8 mm) e `largura da fenda - largura do dedo = clearance`.
- Vista de cima, 6 peças em 3 linhas: duas lisas, duas paredes largas com 2 vãos em cada ponta, duas paredes estreitas com 3 vãos em cada ponta. Os vãos das paredes largas e das estreitas ficam em faixas diferentes (uma preenche o que a outra deixa).
- Largura e altura totais do desenho: cerca de 164 x 148 mm (172 x 156 mm no cabeçalho do SVG, com as marcas).
- A altura da caixa montada é `height` mais `thickness` (43 mm com os valores iniciais), porque o fundo é colado **por baixo** das paredes; `height` é a altura das paredes.
- Altere `height` para 50: `n` passa a 7 (dedos de cerca de 7,1 mm), continua ímpar e a caixa continua fechando.
- Exporte as duas camadas e confira o quadro igual nos dois arquivos.

**Armadilhas:**

- **Número par de dedos:** nos cantos, as duas peças ficam com material ou as duas ficam vazias. O `echo()` denuncia.
- **Paridade igual nas quatro paredes:** os cantos não se complementam. Frente e trás precisam ter a paridade oposta à das laterais.
- **Fundo ou tampa com dedos:** não precisam.
- **Peça 3D "para pré-visualizar":** o assistente monta a caixa em 3D no fim do arquivo. Isso mistura 2D e 3D: com o 3D depois do 2D, o OpenSCAD 2021.01 só avisa e exporta o SVG sem ele; com o 3D antes, não exporta. Nos dois casos o console deixa de ficar limpo. O Bloco base proíbe, mas confira.
- **Espessura errada:** os vãos usam `thickness`. Se o MDF real mede 2,8 mm e o arquivo diz 3, o canto fica frouxo.
- **Medida interna no lugar de externa:** confira com a conta: parede interna = `length - 2 * thickness`.
- **Dois erros seguidos no mesmo ponto:** pare e use o arquivo pronto `caixa-finger-joint.scad` com o prompt de ajuste. Ele tem um desenho um pouco diferente deste prompt (a base também tem dedos, e a tampa traz um miolo que entra na abertura), mas `length`, `width`, `thickness` e `clearance` funcionam do mesmo jeito. A exceção é `height`: no arquivo pronto é a altura **total** externa da caixa (40 mm); neste prompt é a altura das paredes, e a caixa montada tem `height` mais `thickness`.

---

## Prompt 3. Placa com gravação

Exercício 3 (opção) e projeto final. Placa de identificação de produto, de mesa ou de porta.

```text
Peça: placa retangular de cantos arredondados, com furos de fixação opcionais e texto gravado em duas linhas (título e subtítulo).
Material: MDF de 3 mm ou acrílico de 3 mm. A peça é plana.

Use estes nomes de parâmetros e estes valores iniciais:
- width = 120 e height = 50 (largura e altura da placa, mm)
- corner_radius = 3 (raio dos cantos, mm)
- margin = 6 (margem entre os textos e a borda, mm)
- holes = 2 (0 = sem furos, 2 = furos nos dois cantos de cima, 4 = nos quatro cantos)
- hole_diameter = 4 (diâmetro dos furos, mm)
- hole_margin = 4 (distância da borda da placa até a borda do furo, mm)
- title = "CASA DA ANA" e title_size = 9 (primeira linha e tamanho desejado das letras, o size do OpenSCAD, mm)
- subtitle = "Artesanato em couro" e subtitle_size = 5.5 (segunda linha, mm)
- line_gap = 5 (espaço livre entre a base do título e o topo do subtítulo, mm)
- bold = true
- border = false (moldura gravada; ligue só se quiser), border_width = 0.8 e border_inset = 2.5 (mm)

Camada "cut": contorno arredondado MENOS os furos.
Camada "engrave": as duas linhas de texto (mais as marcas de registro), centralizadas na horizontal, o título logo acima do centro da placa e o subtítulo logo abaixo, separados por line_gap. Se border for true, inclua também um filete retangular de largura border_width, a border_inset da borda.
Cada linha precisa caber na largura livre = width - 2 * margin. Tamanho final de cada linha = min(tamanho desejado, largura livre / len(texto)).
Mostre com echo() a largura livre e os tamanhos finais das linhas.
```

**Parâmetros esperados:** `width`, `height`, `corner_radius`, `margin`, `holes`, `hole_diameter`, `hole_margin`, `title`, `title_size`, `subtitle`, `subtitle_size`, `line_gap`, `bold`, `border`, `border_width`, `border_inset`.

**O que conferir no resultado:**

- Console com a largura livre (108 mm com os valores iniciais) e os tamanhos finais.
- As duas linhas estão centralizadas e dentro da largura livre; com `holes = 2`, os furos de cima não encostam no texto.
- Troque as linhas pelo seu texto, com acentos ("Doçaria", "Açaí"), e confira que os acentos aparecem.
- Ligue `border` e veja a moldura: ela fica a 2,5 mm da borda e não toca os furos.

**Armadilhas:**

- **Moldura em modo de preenchimento é cara.** Na gravação por preenchimento o cabeçote varre a placa inteira para desenhar um filete. Com `border = true` a gravação pode passar de segundos para alguns minutos. Deixe `border = false`, ou grave a moldura em modo de linha numa camada à parte.
- Letras minúsculas em texto longo ficam pequenas e perdem legibilidade à distância.
- Texto encostando nos furos.
- Acentos que não aparecem: confira a fonte.

---

## Prompt 4. Tira com dobradiça viva

Opção avançada para quem terminar cedo. **Dobradiça viva** (*living hinge*) é uma região do material cortada com muitas fendas finas e paralelas, que deixam o MDF curvar sem quebrar. A receita abaixo reproduz o padrão do arquivo pronto `dobradica-viva.scad`: nas fileiras ímpares, as fendas das pontas chegam à borda da tira (como no gerador FlexEdge do `boxes.py`), e a tira dobra em toda a largura.

```text
Peça: tira de MDF de 3 mm com dobradiça viva: uma região cortada com fendas finas e paralelas, que deixam o MDF curvar.
Material: MDF de 3 mm.
Exceção às regras 5 e 6 do Bloco base: esta peça tem só a camada cut. Declare layer = "cut"; // [cut], sem camada engrave e sem marcas de registro.

Use estes nomes de parâmetros e estes valores iniciais:
- length = 80 (comprimento da tira, mm, no sentido da dobra: eixo X)
- width = 50 (largura da tira, mm, no sentido das fendas: eixo Y)
- slot_length = 15 (comprimento de cada fenda, mm)
- slot_gap = 3 (ponte de material inteiro entre duas fendas da mesma fileira, mm)
- row_spacing = 2.5 (distância entre fileiras de fendas, centro a centro, mm)
- rigid_end = 10 (trecho rígido em cada ponta, sem fendas, mm)
- edge_margin = 4 (borda sem fenda nas fileiras pares, mm)
- slot_width = 0.1 (largura desenhada de cada fenda, mm)
- overshoot = 1 (quanto as fendas das pontas passam da borda nas fileiras ímpares, mm)

Receita (siga exatamente):
1. A tira é o retângulo length x width, com um canto em (0, 0), MENOS todas as fendas (difference). Cada fenda é um retângulo fino: slot_width no eixo X, centrado na posição da sua fileira, e o comprimento no eixo Y.
2. Fileiras: n_rows = floor((length - 2 * rigid_end) / row_spacing) + 1. A fileira r (r = 0, 1, ... n_rows - 1) fica em x = x0 + r * row_spacing, com x0 = (length - (n_rows - 1) * row_spacing) / 2.
3. Medidas auxiliares: period = slot_length + slot_gap; inner_w = width - 2 * edge_margin; n_even = floor((inner_w + slot_gap) / period); y0 = edge_margin + (inner_w - (n_even * period - slot_gap)) / 2.
4. Fileira par (r = 0, 2, 4...): n_even fendas inteiras. A fenda k (k = 0 ... n_even - 1) vai de y = y0 + k * period até y = y0 + k * period + slot_length.
5. Fileira ímpar (r = 1, 3, 5...): deslocada em meio período, com n_even + 1 fendas. Para k = 0 ... n_even, seja a0 = y0 - period / 2 + k * period. A fenda k vai de a0 até a0 + slot_length, EXCETO a primeira (k = 0), que começa em y = -overshoot, e a última (k = n_even), que termina em y = width + overshoot. Assim as fileiras ímpares abrem a borda da tira, e ela dobra em toda a largura; as fileiras pares mantêm a borda inteira, e a tira não se solta.
Mostre com echo(): n_rows, n_even e o número de fendas de uma fileira par e de uma ímpar.
```

**Parâmetros esperados:** `length`, `width`, `slot_length`, `slot_gap`, `row_spacing`, `rigid_end`, `edge_margin`, `slot_width`, `overshoot`, mais `layer`. Este prompt não tem `corner_radius` nem `registration`.

**O que conferir no resultado:**

- Console: `n_rows` igual a 25 e `n_even` igual a 2, ou seja, 2 fendas nas fileiras pares e 3 nas ímpares (62 fendas no total, com os valores iniciais).
- Vista de cima (dê zoom): fileiras alternadas. As pares têm duas fendas inteiras, longe das bordas. As ímpares têm três, e a primeira e a última chegam à borda da tira (viram entalhes finos no contorno). Nada nos 10 mm de cada ponta.
- Cabeçalho do SVG com `width="80mm" height="50mm"` e uma só camada (sem marcas de registro).
- A peça tem dezenas de fendas, então o corte demora mais que o de uma caixa pequena. Veja o tempo estimado no software antes de mandar para a fila.
- O arquivo pronto `dobradica-viva.scad` usa o mesmo padrão com outros valores iniciais (100 x 50 mm, fendas de 20 mm, ponte de 4 mm, fileiras a 3 mm).

**Armadilhas:**

- **Kerf offset e fendas finas não combinam.** Se o software encolher um retângulo de 0,1 mm, pode apagar ou deformar a fenda. Para esta peça, teste em retalho e, se preciso, deixe o kerf offset em zero.
- **A laser percorre o contorno de cada retângulo fino:** são duas passadas coladas na mesma linha. É assim que o OpenSCAD 2021.01 desenha, porque ele só exporta áreas, não linhas.
- **Borda que não abre:** se todas as fendas ficarem longe da borda, ela vira um trilho rígido e a tira dobra mal. Dê zoom na borda das fileiras ímpares.
- **O MDF rompe** se for dobrado depressa ou além do raio que o padrão permite. Teste a flexão num retalho, devagar.
- O padrão depende do material e da espessura. Valores de outro material não valem.

---

## Prompt 5. Lote de chaveiros com nomes

Personalização em lote: um arquivo, vários nomes, uma só chapa. É a base do capítulo 6.

```text
Peça: lote de chaveiros com nomes, para cortar e gravar todos numa mesma chapa.
Material: MDF de 3 mm, acrílico de 3 mm ou couro.

Use estes nomes de parâmetros e estes valores iniciais:
- labels = ["ANA", "BRUNO", "CARLA", "DANIEL", "ELISA", "FELIPE", "GABRIELA", "HUGO"] (um nome por chaveiro; eu vou trocar pelos nomes da turma)
- columns = 2 (quantos chaveiros por linha)
- tag_gap = 3 (espaço entre chaveiros, mm)
- tag_width = 70, tag_height = 25, corner_radius = 4, hole_diameter = 4.5 e hole_margin = 3.5 (o mesmo chaveiro do exercício 1, mm)
- font_size = 8 (tamanho desejado das letras, o size do OpenSCAD), bold = true e text_margin = 3 (mm)

Regras:
- Crie um module para UM chaveiro (contorno e furo) e um module para o texto de UM nome. Repita os dois com um laço for e uma função pos(i) que devolve a posição de cada chaveiro na grade.
- A primeira linha da grade é a de cima: o primeiro nome fica no canto superior esquerdo.
- Camada "cut": o contorno de cada chaveiro, cada um com o seu furo subtraído (o furo é cortado). Camada "engrave": todos os nomes (mais as marcas de registro).
- O texto de cada chaveiro fica na área livre à direita do furo, como no exercício 1: começa em hole_margin + hole_diameter + text_margin e termina text_margin antes da borda direita. Cada nome reduz o próprio tamanho se for longo: min(font_size, largura da área / len(nome)).
- As marcas de registro entram uma vez só, nos cantos do lote inteiro, não em cada chaveiro.
- Mostre com echo() quantos chaveiros há e a largura e altura do lote.
```

**Parâmetros esperados:** `labels`, `columns`, `tag_gap`, `tag_width`, `tag_height`, `corner_radius`, `hole_diameter`, `hole_margin`, `font_size`, `bold`, `text_margin`.

**O que conferir no resultado:**

- Console: 8 chaveiros e um lote de 143 x 109 mm com os valores iniciais.
- Vista de cima: grade de 2 colunas, nomes na ordem da lista, todos dentro dos chaveiros, o mais longo ("GABRIELA") com letra menor.
- Troque a lista por 3 nomes, depois por 12: a grade se reorganiza.
- Abra o arquivo `chaveiros-lote.scad` do pendrive e compare com o que o assistente escreveu.

**Armadilhas:**

- **Aspas curvas** na lista de nomes (vindas de WhatsApp ou Word): erro de sintaxe.
- Nomes repetidos ou com espaço no fim: o texto sai descentralizado.
- Lote maior que a área livre da chapa: confira a largura e a altura do `echo()` contra o espaço da sua célula.
- Cada chaveiro leva menos de um minuto de máquina (cerca de 50 segundos, valor de planejamento até o teste da máquina real). Um lote de 16 leva perto de 14 minutos.

---

## Prompt 6. Ajuste (mudar um parâmetro)

Use sempre que quiser mudar algo num arquivo que já funciona, inclusive nos arquivos prontos do pendrive. Descreva a mudança com as palavras do código; se não souber o nome da variável, descreva pelo que ela faz.

```text
Abaixo está o meu código OpenSCAD atual. Faça só esta mudança, sem mexer em mais nada:
no chaveiro, troque o texto gravado de "MARIA" para "JOSÉ CARLOS" e aumente a largura da peça de 70 para 80 mm.

Regras: mantenha o resto igual (nomes dos parâmetros, ordem, comentários); devolva o arquivo completo num único bloco de código; depois do código, liste em até 3 linhas o que mudou, com o valor antigo e o novo; não acrescente recursos que eu não pedi. Se a mudança deixar alguma conta do arquivo incoerente (por exemplo, texto que não cabe mais), avise antes do código.

O código atual está logo abaixo desta linha. Cole o arquivo inteiro ali.
```

**Parâmetros esperados:** nenhum fixo. O que você informa é a mudança pedida e o código atual; os nomes dos parâmetros do seu arquivo continuam os mesmos.

**O que conferir no resultado:** só mudou o que você pediu; os nomes dos parâmetros são os mesmos; o `echo()` mostra as novas medidas; o arquivo continua exportando as duas camadas.

**Armadilhas:** o assistente "melhora" o código por conta própria; pede mais de uma mudança por vez e uma delas se perde; esquece uma conta ligada ao parâmetro (largura nova e texto fora do centro). Peça **uma mudança por vez**.

---

## Prompt 7. Diagnóstico (por que não exportou?)

Use quando o OpenSCAD acusar erro, quando o arquivo não sair ou quando a peça sair diferente do esperado.

```text
O OpenSCAD 2021.01 não exportou o SVG da camada "engrave" do meu código (ou: a peça saiu diferente do que eu pedi). A mensagem do console está abaixo.
Explique em linguagem simples, sem jargão, o que a mensagem quer dizer. Aponte a linha ou o trecho provável do problema e devolva só o trecho corrigido, dizendo onde ele entra. Se a causa for de outra natureza (versão do OpenSCAD, fonte, camada vazia, 2D misturado com 3D), diga qual.
Lembretes: a versão é a 2021.01; roof(), fill() e textmetrics() não existem nela; o topo do arquivo precisa ser 2D; quando uma camada fica sem nenhuma geometria, o OpenSCAD 2021.01 responde "Current top level object is not a 2D object".

Console e código estão logo abaixo desta linha. Cole primeiro a mensagem do console e depois o arquivo inteiro.
```

**Parâmetros esperados:** nenhum. O que você informa é a mensagem completa do console e o código.

**O que conferir no resultado:** a explicação faz sentido com a mensagem; a correção é um trecho pequeno (e não um arquivo reescrito); depois de aplicar, o console fica sem `WARNING` e o SVG sai.

**Armadilhas:** o assistente "adivinha" a causa sem a mensagem completa (cole **toda** a mensagem); sugere trocar de versão do OpenSCAD (não dá, o computador do laboratório é fixo); reescreve o arquivo todo e introduz erros novos.

### Dicionário das mensagens mais comuns (OpenSCAD 2021.01)

Todas foram observadas na versão 2021.01.

| Mensagem no console | O que significa | O que fazer |
| --- | --- | --- |
| `Current top level object is not a 2D object.` | Há algo 3D **antes** do 2D no arquivo (um `cube` na primeira linha, por exemplo), **ou** a camada exportada não tem nenhuma geometria. Nenhum arquivo é gerado | Tirar o 3D. Se for só numa camada, conferir se há algo para aquela camada |
| `ERROR: Parser error: syntax error in file X, line N` e `Can't parse file` | Erro de escrita no código. O OpenSCAD aponta a linha onde percebeu o problema, que costuma ser **depois** do erro | Olhar a linha N e a anterior: falta `;`, `)`, `}` ou há aspas curvas |
| `WARNING: Ignoring unknown variable 'x'` | O código usa um nome que não existe (erro de digitação ou ordem). O arquivo **ainda é exportado**, com um valor padrão no lugar | Corrigir o nome antes de exportar |
| `WARNING: Unable to convert square(size=[undef, 10], ...)` | Consequência do aviso anterior: o valor ficou indefinido | Corrigir a variável |
| `WARNING: Ignoring unknown module 'roof'` (ou `fill`) | Recurso que não existe na 2021.01 | Reescrever sem esse recurso |
| `WARNING: Ignoring unknown function 'textmetrics'` | Função que não existe na 2021.01 | Reescrever sem ela |
| `WARNING: Mixing 2D and 3D objects is not supported` e `Ignoring 3D child object for 2D operation` | 2D e 3D misturados, com o 3D **depois** do 2D: o 3D é ignorado e o SVG sai sem ele | Remover todo o 3D |
| `WARNING: Mixing 2D and 3D objects is not supported` e `Ignoring 2D child object for 3D operation`, seguidos de `Current top level object is not a 2D object.` | 2D e 3D misturados, com o 3D **antes** do 2D: o 2D é ignorado e a exportação falha | Remover todo o 3D |
| `WARNING: Can't open include file '...'` | O arquivo usa uma biblioteca que não existe neste computador | Reescrever sem biblioteca |

O que **não** gera mensagem: uma fonte que não existe. O OpenSCAD troca por outra fonte, em silêncio. O sinal é a letra com aparência diferente. Para ver as fontes instaladas, use o menu Help, opção Font List.

---

## Arquivos de apoio

Estão no pendrive e no repositório do minicurso, na pasta `laser/modelos/`. Servem de ponto de partida, de comparação e de plano B quando o assistente erra. Os nomes dos parâmetros dos prompts acima seguem os destes arquivos sempre que possível; mesmo assim, **leia o começo do arquivo antes de pedir ajustes**: os valores padrão são outros (o chaveiro do prompt 1 tem 70 x 25 mm; o do arquivo pronto, 60 x 25 mm).

**Marcas de registro.** O código que a IA escreve com o Bloco base usa `registration = true` por padrão (as marcas ficam ligadas). Os modelos de duas camadas desta pasta usam `registration = false`; a `dobradica-viva.scad` tem só a camada de corte.

| Arquivo | O que é | Parâmetros principais (valor padrão) |
| --- | --- | --- |
| `teste-potencia-velocidade.scad` | Grade de quadrados de corte para o teste de potência x velocidade (capítulo 1) | `speeds` (10 a 50 mm/s), `powers` (40 a 80%), `square_size` (10), `registration` (false) |
| `teste-kerf.scad` | Pente de ranhuras e um quadrado de 20 mm, para medir o kerf (capítulo 1) | `slot_widths`, `tooth_width` (6), `square_size` (20), `registration` (false) |
| `chaveiro-tag.scad` | Chaveiro com nome; o texto se ajusta sozinho à largura (prompt 1) | `label`, `font_size` (6), `bold`, `width` (60), `height` (25), `corner_radius` (4), `hole_diameter` (4), `hole_margin` (3), `text_margin` (3), `registration` (false). **A aula usa 70, 8, 4,5 e 3,5** para `width`, `font_size`, `hole_diameter` e `hole_margin`: `-D width=70 -D font_size=8 -D hole_diameter=4.5 -D hole_margin=3.5`, ou o Customizer |
| `caixa-finger-joint.scad` | Caixa aberta em cima, com 5 painéis e tampa opcional (prompt 2) | `length` (80), `width` (60), `height` (40, altura total externa), `thickness` (3), `finger_width` (9), `clearance` (0,1), `with_lid` (false), `part_labels` (true), `spacing` (5), `registration` (false) |
| `placa-gravacao.scad` | Placa com título e subtítulo, furos opcionais e amostras de preenchimento (prompt 3) | `title`, `subtitle`, `title_size` (9), `subtitle_size` (5), `width` (100), `height` (60), `holes` (0), `margin` (6), `registration` (false) |
| `dobradica-viva.scad` | Tira com padrão de dobradiça viva; só camada de corte, sem marcas de registro (prompt 4) | `length` (100), `width` (50), `slot_length` (20), `slot_gap` (4), `row_spacing` (3), `rigid_end` (10), `edge_margin` (4), `slot_width` (0,1) |
| `chaveiros-lote.scad` | Lote de chaveiros em grade, um por nome da lista `labels` (prompt 5). **Precisa de `chaveiro-tag.scad` na mesma pasta** | `labels`, `sheet_width` (300), `sheet_height` (200), `tag_gap` (4), `registration` (false), mais os parâmetros do chaveiro |

**Camadas dos arquivos de apoio.** Para não ter problema de alinhamento, o repositório traz os arquivos **já exportados** pelo script `exportar.sh`:

- `svg/`: um SVG por camada, com o quadro igualado entre as camadas, e um `-combinado.svg` com o corte em vermelho e a gravação em azul. **O combinado é o arquivo principal para o LightBurn**, que separa as camadas por cor (confira na versão instalada);
- `dxf/`: um DXF por camada, com coordenadas absolutas;
- `previa/`: imagens PNG de cada camada.

Se você exportar pela interface do OpenSCAD, mude `registration` para `true` antes de exportar, porque o quadro do SVG é calculado arquivo a arquivo. As camadas **devem alinhar**: confira as marcas de registro na prévia do software. O resultado do ensaio de 04/11 diz como o programa do laboratório se comporta (capítulo 4, seção 1).

---

Capítulo anterior: [02-ia-generativa-para-cad.md](02-ia-generativa-para-cad.md)
Próximo capítulo: [04-do-modelo-ao-corte.md](04-do-modelo-ao-corte.md)
