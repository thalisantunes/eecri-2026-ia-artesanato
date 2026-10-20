# Plano de aula

Minicurso "Modelagem 3D com IA generativa para corte a laser". I EECri 2026, 07/11/2026, laboratório maker da FAVAG. Quatro horas, 16 participantes em 8 duplas.

Os horários abaixo são **relativos ao início da aula** (0:00). O horário de início do minicurso ainda depende da organização (pendência do instrutor). Se a aula começar às 9h, o intervalo é às 10h45; se começar às 14h, às 15h45.

## 1. Premissas

- **Laser do evento: controladora Ruida confirmada em 13/10/2026.** Modelo, área útil e software ainda são hipótese: laser CO2 tipo "1490" (área útil de 1400 x 900 mm), operada por LightBurn (pago) ou RDWorks (gratuito). A seção 7 traz a alternativa para outra máquina.
- **Participantes sem experiência em CAD e possivelmente sem notebook.** Caminho das duplas: assistente de IA no celular ou no navegador, OpenSCAD nos computadores do laboratório, SVG por camada, software da laser. Caminho do instrutor (demonstração): Claude Code com `mcp-openscad` no projetor.
- **Kerf nunca entra na geometria.** A compensação é feita no software de corte. Os modelos só têm a folga `clearance`, nos encaixes.
- **Valores de planejamento.** Os tempos de máquina deste plano usam corte a 12 mm/s, gravação a 150 mm/s com linhas a 0,1 mm e 50% de sobrecarga. Eles saem das peças de referência (chaveiro 70 x 25 mm, caixa 80 x 60 x 40 mm) e só serão trocados pelos medidos se houver outra janela em 05 ou 06/11 para os blocos 8 (caixa cronometrada) e 9 (lote de chaveiros) de `laser/ensaio-laser.md`; sem ela, valem os valores de planejamento até o lote 1 do próprio minicurso.

## 2. Papéis

| Papel | O que faz | O que não faz |
| --- | --- | --- |
| **Instrutor** | Conduz os blocos 0, 1, 2, 4 e 7. Circula nos exercícios e destrava erros de modelo. Decide, com o monitor, a regra de decisão da fila. Fecha cada lote no horário | Não deixa a laser sozinha. Não opera a máquina se o monitor estiver livre |
| **Monitor do laboratório** | Opera a laser e o computador da laser. Faz a conferência de fila, posiciona as peças nas células, mantém o quadro e o registro de tempos. Garante exaustão, água, ar e extintor. Dá o "pode iniciar" de cada corte | Não corrige código das duplas (isso é do instrutor) |
| **Dupla** | Piloto (computador e OpenSCAD) e navegador (assistente de IA, checklist, medidas). Trocam de papel a cada exercício | Não opera a laser. Não abre a tampa. Não leva material de fora para a máquina |

Só o monitor e o instrutor operam a máquina, um de cada vez. Se o monitor não vier, o minicurso muda de formato (seção 8 do `roteiro-instrutor.md`).

## 3. Cronograma

| Bloco | Início | Dur. | Tema | Método |
| --- | --- | --- | --- | --- |
| 0 | 0:00 | 15 | Abertura, segurança e preparação | Exposição curta e checagem prática |
| 1 | 0:15 | 20 | A laser, os materiais e o kerf | Exposição dialogada com amostras |
| 2 | 0:35 | 25 | Demonstração ao vivo: do prompt ao corte | Demonstração em duas partes |
| 3 | 1:00 | 45 | Exercício 1: chaveiro com nome | Prática em duplas |
| | 1:45 | 15 | **Intervalo** (a laser corta o lote 1) | |
| 4 | 2:00 | 15 | Medir o lote 1: kerf, folga e encaixe | Medição guiada e mini-aula |
| 5 | 2:15 | 45 | Exercício 2: caixa com encaixe de dedos | Prática em duplas |
| 6 | 3:00 | 35 | Exercício 3 e projeto final: peça livre | Prática em duplas |
| 7 | 3:35 | 25 | Montagem, entrega e encerramento | Prática, fechamento e economia criativa |

Fechamento dos lotes: **lote 1 às 1:40**, **lote 2 às 3:00**, **lote 3 às 3:25**. Fim dos cortes (hard stop): **3:45**.

## 4. Blocos

### Bloco 0 (0:00, 15 min). Abertura, segurança e preparação

- **Objetivo:** todos seguros, em duplas, com as ferramentas funcionando.
- **Método:** exposição curta e checagem prática em cada mesa.
- **Instrutor:** boas-vindas (2 min), com o crédito "Parceira do minicurso: Laser One, laser1.one"; o plano do dia, em uma frase por exercício (2 min); **briefing de segurança** (5 min, texto no `roteiro-instrutor.md`); formar duplas e papéis (1 min); checagem zero (5 min).
- **Duplas:** escolhem piloto e navegador; abrem o OpenSCAD; entram no assistente de IA; copiam o **Bloco base** (apostila, capítulo 3) do grupo da turma, porque texto impresso não se copia no celular, colam no assistente e esperam o "entendido".
- **Monitor:** mostra extintor, botão de emergência e a faixa de segurança; liga exaustão e refrigeração; circula conferindo os computadores.
- **Checagem 0 (0:12):** todas as duplas com OpenSCAD aberto, a fonte Liberation Sans Bold na lista (menu Help, Font List) e o assistente respondendo "entendido". Quem não tem conta ou internet segue o plano B do roteiro.

**Briefing de segurança, em oito pontos:**

1. Só o monitor e o instrutor operam a máquina. Ninguém abre a tampa com o trabalho em andamento.
2. O feixe é invisível. A tampa fecha antes de cada trabalho; ninguém desativa intertravamento.
3. Todo corte pode pegar fogo. A máquina nunca fica sozinha. Chama: avisar em voz alta; o monitor para e usa o extintor; todos se afastam.
4. Exaustão antes do primeiro disparo e depois do último. Sem exaustão não há corte.
5. Material só o que o monitor entregou. PVC, vinil e couro sintético nunca. Material de fora só identificado e autorizado.
6. Cabelo preso, nada solto perto da máquina, calçado fechado.
7. Atrás da faixa: perto da máquina, no máximo duas duplas por vez, chamadas pelo monitor.
8. Peça cortada está quente e com farpa; lixa e cola com óculos e máscara PFF2. Qualquer pessoa pode gritar "para!".

### Bloco 1 (0:15, 20 min). A laser, os materiais e o kerf

- **Objetivo:** entender o que a máquina faz, o que não se corta e o que é kerf. Conteúdo: apostila, capítulo 1.
- **Método:** exposição dialogada com materiais e peças na mesa.
- **Instrutor:**
  1. Como a laser CO2 corta e grava, e o papel de exaustão, ar e refrigeração (3 min).
  2. Potência, velocidade, foco e passes; mostrar a grade de teste de potência x velocidade cortada no ensaio de 04/11 (4 min).
  3. MDF, acrílico e couro: passar as amostras; lista do que não cortar (5 min).
  4. Kerf: medir ao vivo, com paquímetro, um quadrado de 20 mm cortado **sem** compensação; pedir à turma o valor (5 min). Onde compensar e por que não na geometria (3 min).
- **Duplas:** passam as amostras, medem o quadrado de demonstração e anotam.
- **Monitor:** em paralelo, deixa pronto o computador da laser: arquivo-modelo da turma aberto (camadas de gravação e de corte, células numeradas), conexão testada.
- **Checagem 1 (0:33):** cada dupla anotou o kerf do quadrado de demonstração.

### Bloco 2 (0:35, 25 min). Demonstração ao vivo

- **Objetivo:** ver o caminho completo uma vez antes de fazer. Conteúdo: apostila, capítulos 2 a 4.
- **Método:** duas partes no projetor.
- **Parte A, caminho do instrutor (10 min):** Claude Code com `mcp-openscad`. Pedir o chaveiro em português; `check_syntax`; `render_to_png`; mudar um parâmetro e ver a peça nova; `export_svg` com `layer` igual a `cut` e a `engrave`.
- **Parte B, caminho das duplas (15 min):** o mesmo chaveiro, com o assistente no navegador: Bloco base e Prompt 1; colar no OpenSCAD; F6; **um erro de propósito**: digitar `cube(5);` na **primeira linha** do arquivo para ler `Current top level object is not a 2D object` (com o cubo no fim do arquivo o OpenSCAD 2021.01 só avisa e exporta o SVG sem ele; mostre os dois casos); corrigir; exportar as duas camadas; abrir no software da laser (com o monitor ao lado): importar, camadas, kerf offset, *frame*, *preview*; o monitor corta a peça de demonstração.
- **Duplas:** acompanham, com o cartão de seis etapas (descrever, gerar, rodar, exportar, importar, cortar).
- **Monitor:** inicia o corte da peça de demonstração por volta de 0:55, para que ela esteja pronta no fim do bloco (cerca de 1 minuto de máquina).
- **Checagem 2 (1:00):** todos viram o erro de 3D na primeira linha, o aviso do cubo no fim do arquivo e a peça pronta.

### Bloco 3 (1:00, 45 min). Exercício 1: chaveiro com nome

- **Objetivo:** percorrer o caminho completo pela primeira vez. Conteúdo: apostila, capítulo 5, exercício 1.
- **Método:** prática em duplas, com o instrutor circulando e o monitor conferindo a fila.
- **Instrutor:** circula; os erros mais prováveis são aspas curvas, topo 3D e variável com nome diferente. **Checagem 3 (1:20):** metade das duplas com o primeiro SVG exportado. Aviso de fechamento do lote aos 1:35.
- **Duplas:** Bloco base, Prompt 1, ciclo do capítulo 2, dois SVG, conferência de fila.
- **Monitor:** faz a conferência de fila das duplas que terminam (pendrive da fila), importa os arquivos e posiciona cada par na célula da dupla. Lote 1 **sem kerf offset**, de propósito.
- **Checagem 4 (1:40):** lote 1 fechado. Dupla atrasada entra de carona na janela ociosa (2:05 a 2:40).

### Intervalo (1:45, 15 min)

A laser corta o lote 1: 20 chaveiros, cerca de 17 minutos de máquina. O monitor fica na máquina. O instrutor confere as peças prontas e separa por dupla.

### Bloco 4 (2:00, 15 min). Medir o lote 1: kerf, folga e encaixe

- **Objetivo:** descobrir o kerf com o próprio chaveiro; entender a folga do encaixe. Conteúdo: apostila, capítulos 1 e 3.
- **Método:** medição guiada, discussão dos números da turma e mini-aula.
- **Instrutor:** entrega as peças; cada dupla mede largura, altura e furo e anota na folha do exercício 1; a turma compara (média das medidas = kerf da máquina). Mini-aula de 5 minutos: kerf (processo, no software) contra folga (projeto, no arquivo) e a receita dos dedos do Prompt 2.
- **Monitor:** cronometra as duas fases do lote 1 (gravação e corte) e **aplica a regra de decisão** (seção 6.5). Corta o quadrado de calibração com o kerf offset do ensaio e mede.
- **Checagem 5 (2:10):** o kerf medido pela turma bate com o do ensaio de 04/11 (diferença de até 0,05 mm)? Se não bater, investigar foco, chapa e unidade de velocidade antes do lote 2.

### Bloco 5 (2:15, 45 min). Exercício 2: caixa com encaixe de dedos

- **Objetivo:** fazer um encaixe que fecha. Conteúdo: apostila, capítulo 5, exercício 2.
- **Método:** prática em duplas, com receita escrita no prompt e o arquivo pronto como caminho seguro.
- **Instrutor:** circula; o foco é a receita dos dedos e o `echo()`. Quem erra duas vezes no mesmo ponto passa ao arquivo pronto `caixa-finger-joint.scad` e ao Prompt 6.
- **Duplas:** medem a espessura real; Bloco base e Prompt 2; console e vista de cima; dois SVG; conferência de fila.
- **Monitor:** calibra o kerf offset, corta o **cupom de encaixe** (a caixa pequena de teste do arquivo pronto, 60 x 40 x 30 mm, como no bloco 8 do ensaio), monta à mão e testa o encaixe. Com o cupom aprovado, a **fila rolante** começa por volta de 2:45.
- **Checagem 6 (2:45):** primeiras caixas na fila; cupom aprovado.
- **Fechamento do lote 2: 3:00.**

### Bloco 6 (3:00, 35 min). Exercício 3 e projeto final: peça livre

- **Objetivo:** aplicar o método a uma peça escolhida pela dupla. Conteúdo: apostila, capítulo 5, exercício 3.
- **Método:** prática autônoma em duplas, dentro de um orçamento de máquina.
- **Instrutor:** circula; verifica o **orçamento de máquina** de cada peça (100 x 60 mm, contorno de até 350 mm, gravação de até 6 cm², até 2 minutos estimados).
- **Duplas:** receita de sete itens no papel; Bloco base e pedido; ciclo; dois SVG; conferência de fila com o item 6.
- **Monitor:** conclui o lote 2 e corta o lote 3 em fila rolante.
- **Fechamento do lote 3: 3:25. Fim dos cortes: 3:45.**

### Bloco 7 (3:35, 25 min). Montagem, entrega e encerramento

- **Objetivo:** levar a peça, o arquivo e a conta. Conteúdo: apostila, capítulos 5 e 6.
- **Método:** montagem prática, exposição curta de economia criativa e roda de conversa.
- **Duplas (10 min):** montam a caixa (encaixe a seco, cola fina, fita crepe), retiram as peças com o monitor, salvam a pasta `dNN` no pendrive (`.scad`, SVG, ficha da peça).
- **Instrutor (7 min):** economia criativa em resumo: a fórmula de custo por peça, um exemplo, a ideia de família de produtos e de lote personalizado (capítulo 6).
- **Fechamento (8 min):** roda de conversa (o que funcionou, o que errou, o que você faria com a laser); créditos à organização e à Laser One; três perguntas de avaliação do minicurso.
- **Monitor:** deixa a exaustão ligada por pelo menos 5 minutos depois do último corte; limpa a mesa; registra os tempos e valores da aula.

## 5. Pontos de checagem

| # | Quando | O que verificar | Se falhar |
| --- | --- | --- | --- |
| 0 | 0:12 | OpenSCAD aberto, fonte Liberation Sans Bold, assistente respondendo "entendido" | Plano B de internet, conta ou computador |
| 1 | 0:33 | Cada dupla anotou o kerf do quadrado | Repetir a medição com a turma |
| 2 | 1:00 | Todos viram o erro de 3D na primeira linha, o aviso do cubo no fim do arquivo e a peça pronta | Repetir o erro no início do exercício 1 |
| 3 | 1:20 | Metade das duplas com o primeiro SVG | Reduzir o exercício: um chaveiro por dupla |
| 4 | 1:40 | Lote 1 fechado | Carona na janela ociosa |
| 5 | 2:10 | Kerf da turma coerente com o do ensaio | Investigar foco, chapa e unidade antes do lote 2 |
| 6 | 2:45 | Cupom de encaixe aprovado e primeiras caixas na fila | Ajustar kerf offset ou `clearance`; caixa aberta |
| 7 | 3:00 | Lote 2 fechado | Quem não fechou fica no kit pré-cortado |
| 8 | 3:25 | Lote 3 fechado | Peça livre só modelada |
| 9 | 3:45 | Fim dos cortes | O que não foi cortado vai para depois da aula ou para o kit |

**Se um bloco atrasar mais de 5 minutos:** no bloco 1, pular o couro; no bloco 2, encurtar a parte A; no bloco 4, deixar a mini-aula dos dedos para o início do bloco 5; no bloco 6, passar ao orçamento reduzido da peça livre.

## 6. Estratégia de fila da laser

### 6.1 Princípio

A laser é uma só e as duplas modelam em paralelo. A regra: **uma chapa para a turma, oito células, lotes com horário de fechamento e fila rolante entre os fechamentos.** A máquina parada com peça pronta na fila é o pior desperdício. A máquina cortando peça que ninguém conferiu é o segundo pior.

### 6.2 A chapa da turma

**Duas chapas de MDF de 3 mm de 600 x 400 mm, lado a lado** (1200 x 400 mm, com a emenda entre as colunas 2 e 3), ou uma chapa de 1200 x 600 mm se for o formato disponível. Cabe na mesa de 1400 x 900 mm da hipótese, fica presa por uma referência no canto de origem e **não sai da mesa até o fim da aula**. Ela é dividida em **8 células de 300 x 200 mm**, numeradas como as duplas, em 4 colunas e 2 linhas. Ao lado fica uma **chapa de reserva** de 600 x 400 mm: quadrado de calibração, cupom de encaixe, peça de demonstração e re-cortes.

**Mapa da célula** (cada dupla usa a sua para os três exercícios). Há duas variantes, conforme a caixa da dupla. Posição do canto da zona dentro da célula e tamanho da zona, em mm. **Os tamanhos já incluem as marcas de registro**: cada arquivo exportado com `registration` ligado tem duas marcas de 0,6 mm fora da peça, a 3 mm dela, o que soma 3,3 mm de cada lado (6,6 mm a mais na largura e na altura). O X e o Y que o monitor digita valem para o **grupo com as marcas**: o canto inferior esquerdo do grupo é a marca de baixo.

| Zona | Variante A: caixa do prompt 2 (6 placas) | Variante B: caixa do arquivo pronto, aberta (5 painéis) |
| --- | --- | --- |
| Exercício 1 (dois chaveiros, um sobre o outro; é cortado primeiro e fica no mesmo lugar nas duas variantes) | canto 182, 5; 76,6 x 67,2 | canto 182, 5; 76,6 x 67,2 |
| Exercício 2 | canto 5, 5; 170,6 x 154,6 | canto 5, 80; 216,6 x 111,6 |
| Exercício 3 (peça livre) | canto 182, 80; 106,6 x 66,6 | canto 5, 5; 106,6 x 66,6 |

O arquivo pronto da caixa **com tampa** ocupa 216,6 x 176,6 mm e não cabe na célula junto com os outros exercícios: essa caixa vai para a chapa de reserva. Um chaveiro com nome inteiro e `width = 80` (grupo de 86,6 mm) cabe na zona do exercício 1 nas duas variantes.

**Posição das células na chapa:** a célula k (1 a 8) começa em X = 300 x (resto da divisão de (k − 1) por 4) e Y = 200 x (parte inteira da divisão de (k − 1) por 4), contados a partir do canto de origem. Exemplos: a célula 1 começa em X 0 e Y 0; a 4, em X 900 e Y 0; a 5, em X 0 e Y 200; a 8, em X 900 e Y 200. **Conferir na quarta 04/11 em qual canto a máquina conta a origem** (frente ou fundo, esquerda). O monitor posiciona cada par de arquivos **digitando X e Y**, em modo de coordenadas absolutas, sem arrastar.

### 6.3 O fluxo de um trabalho

1. A dupla passa na **conferência de fila** (cartão de seis itens, apostila, capítulo 5) e copia os dois SVG para o **pendrive da fila**, com o nome `dNN-peca-cut.svg` e `dNN-peca-engrave.svg`.
2. A dupla move a **ficha da sua dupla** para a coluna "Pronta para conferir" do quadro de fila.
3. O monitor abre os arquivos no computador da laser: confere tamanho (por exemplo, 70 x 25 mm) e, na *preview*, se as marcas de registro das duas camadas coincidem (as camadas **devem alinhar**; o bloco 7 do ensaio, em `laser/ensaio-laser.md`, diz como o programa do laboratório se comporta, mas só roda se houver outra janela em 05 ou 06/11; sem ele, confira na prévia do software). Reprovado: devolve à dupla, sem perder a vez da próxima.
4. O monitor importa o par de arquivos (nos arquivos de apoio, pode importar o `-combinado.svg`, em duas cores, que o LightBurn separa por cor; conferir na versão instalada), atribui as camadas (gravação acima de corte), **agrupa** e posiciona na zona da célula, digitando X e Y do **grupo com as marcas**. Depois de alinhar, as marcas podem ser apagadas ou ficar: estão fora da peça e seriam cortadas e gravadas na sobra.
5. O monitor move a ficha para "Na fila". Quando a máquina estiver livre: *frame*, conferência visual, **"pode iniciar"** e *Start* (ou *Cut Selected Graphics* para cortar só a célula).
6. Ao fim do corte, ficha em "Retirar e montar". O monitor, com a tampa aberta e a máquina parada, retira as peças e entrega.

### 6.4 Regras da fila

- **Ordem:** quem ainda não cortou passa na frente de quem já cortou. Entre iguais, a ordem de chegada.
- **Lote fechado:** peça pronta depois do fechamento entra no lote seguinte. Entre os fechamentos a fila é rolante: o monitor inicia um corte assim que houver duas células prontas ou cinco minutos depois da primeira.
- **Orçamento de máquina:** exercício 1 até 2 minutos; exercício 2 até 5 minutos; exercício 3 até 2 minutos (estimados no *preview*).
- **Hard stop às 3:45:** o que não foi cortado até lá vai para o kit pré-cortado ou para depois da aula.
- **Nada de abrir a tampa durante o corte.** Retirada de peças só com a máquina parada.

### 6.5 O calendário da máquina e a regra de decisão

| Quando | O que a máquina faz | Tempo nominal |
| --- | --- | --- |
| 0:55 | Peça de demonstração (1 chaveiro) | 1 min |
| 1:45 | **Lote 1:** 20 chaveiros (16 das duplas e 4 de reserva), sem kerf offset | 17 min |
| 2:05 a 2:40 | **Janela ociosa:** calibração do kerf (quadrado de 20 mm), cupom de encaixe, peças de demonstração em acrílico e couro, re-cortes e caronas do lote 1 | o que couber |
| 2:45 | **Lote 2:** 8 caixas com tampa e nome, já com kerf offset, em fila rolante | 29 min |
| 3:20 | **Lote 3:** 8 peças livres, no máximo | até 14 min |
| 3:45 | Fim dos cortes | |

Fora o tempo de corte, há cerca de 5 minutos de preparo por lote.

**Regra de decisão (às 2:05).** Na máquina real, o corte e a gravação podem fugir do plano em proporções diferentes. Por isso o monitor cronometra as **duas fases** do lote 1 (a gravação roda antes do corte, por causa da ordem das camadas) e divide cada tempo pelo número de chaveiros. Os valores de planejamento são **25 s de corte** e **26 s de gravação** por chaveiro, 51 s no total (o **t1** do bloco 9 do ensaio, se ele rodar). O fator de cada fase é o tempo medido dividido pelo de planejamento. **Vale o pior dos dois fatores**: a faixa é a do maior.

| Pior fator (corte ou gravação) | t1 equivalente, se os dois forem iguais | Plano para os lotes 2 e 3 |
| --- | --- | --- |
| até 1,14 | até 58 s | **Completo:** caixa com tampa e nome; peça livre dentro do orçamento |
| 1,14 a 1,7 | 58 a 86 s | **Caixa aberta** (5 peças, sem gravação); peça livre de até 1 minuto (contorno de até 250 mm, gravação de até 3 cm²) |
| 1,7 a 2,6 | 86 a 132 s | **Caixa aberta**; a peça livre só é modelada, o corte fica para depois da aula |
| mais de 2,6 | mais de 132 s | **Só metade das duplas corta a caixa**; as outras montam a do kit pré-cortado; sem peça livre |

Se só der para cronometrar o lote inteiro, use t1 ÷ 51 s, sabendo que um fator alto de uma fase pode ficar escondido pela outra.

**Tempo da caixa.** Se houver outra janela em 05 ou 06/11, o bloco 8 do ensaio cronometra a caixa do arquivo pronto, que tem 1.376 mm de contorno de corte; sem a medida, vale o valor de planejamento de 3,6 minutos. A caixa com tampa do Prompt 2 tem 1.512 mm: multiplique o tempo de corte medido por 1,10 (1.512 ÷ 1.376). O nome da tampa grava em menos tempo que os nomes dos cinco painéis; use o mesmo tempo, a favor da segurança. O valor de planejamento de 3,6 minutos por caixa vem desta conta.

Como esta regra foi derivada: o tempo total dos lotes 2 e 3 não pode passar de 90% da janela de 65 minutos (das 2:40 às 3:45), contando 5 minutos de preparo por lote. Com as premissas da seção 1 isso vale até 1,14 vez para o plano completo. A regra será recalculada com os tempos medidos no bloco 9 do ensaio, se ele rodar; sem ele, o lote 1 do próprio minicurso é a primeira medida.

### 6.6 O quadro de fila

Quadro branco com cinco colunas e uma ficha por dupla (com o número):

| Modelando | Pronta para conferir | Na fila | Cortando | Retirar e montar |
| --- | --- | --- | --- | --- |

A dupla move a ficha até "Pronta para conferir". O monitor move para as demais. O instrutor vê o gargalo de relance.

### 6.7 O que registrar durante a aula

O monitor anota (caderno ou planilha): tempo real e número de peças de cada lote; potência, velocidade e kerf offset usados; peças reprovadas e por quê; qualquer incidente. Esses números calibram as próximas turmas.

## 7. Se a laser não for a da hipótese

| Situação | O que muda no plano |
| --- | --- |
| Mesa pequena (por exemplo 600 x 400 mm) | A chapa comporta 4 células (2 colunas e 2 linhas). Rodadas de 4 duplas, com troca de chapa entre elas (cerca de 5 minutos cada): **12 vagas** (6 duplas), caixa aberta e peça livre só se sobrar tempo |
| Controladora Topwisdom (AutoLaser) | Importar DXF ou usar o plugin do Inkscape; kerf pela ferramenta de deslocamento de forma. O fluxo de células é o mesmo. Ver capítulo 4, seção 8 |
| GRBL (LaserGRBL ou LightBurn G-code) | Rodar o arquivo de gravação e depois o de corte, sem tirar a chapa do lugar; origem pelo *frame* |
| M2 Nano (K40 Whisperer) | Recolorir o SVG no Inkscape (corte em vermelho). Mesa pequena: seguir a linha de mesa pequena |
| Sem LightBurn licenciado | RDWorks, ou LightBurn em teste de 30 dias (conferir as condições). RDWorks pode não abrir SVG: usar o DXF do OpenSCAD |
| Potência baixa (tubo fraco) | A regra de decisão usa o t1 medido; se o corte não atravessa o MDF de 3 mm em um passe, trocar o exercício 2 pelo kit pré-cortado e manter a medição e a modelagem |

## 8. Kit de peças pré-cortadas (seguro)

Cortado na laser do instrutor, antes da viagem (obrigatório), com os arquivos prontos de `laser/modelos/`: **24 chaveiros em branco** (70 x 25 mm) e **10 caixas abertas** de 80 x 60 x 40 mm (5 painéis cada, com o nome de cada painel gravado). Usos:

- **Laser indisponível:** as duplas montam a caixa do kit (a seco, sem cola), discutem o encaixe, personalizam o chaveiro à mão (marcador permanente) e seguem modelando e exportando; os SVG ficam prontos para corte posterior.
- **Dupla sem peça no fim:** recebe do kit o que faltar.
- **Conferência de folga:** as caixas do kit servem de referência de encaixe.
