# Plano de ensaio na laser do I EECri (quarta 04/11/2026, à tarde)

Roteiro para validar a laser do laboratório da FAVAG (Nova Porteirinha, MG) na véspera da abertura do evento (05/11) e três dias antes do minicurso "Modelagem 3D com IA generativa para corte a laser" (07/11). Janela planejada: quarta 04/11 à tarde, depois da chegada do instrutor, por cerca de 3 h. O roteiro padrão é o caminho curto (seção "Caminho curto de 3 h", no fim); os blocos 7 (gravação) e 9 (vazão), e o bloco 5 em acrílico e couro, só entram se a organização abrir outra janela em 05 ou 06/11. Quem executa: Thalis. Tom: operacional, para ler em pé ao lado da máquina.

Glossário: **kerf** é a largura do corte, a faixa de material que o feixe queima em volta da linha; **offset de kerf** é o deslocamento que o software de corte aplica ao caminho para compensar essa faixa; **camada** é um grupo de formas com a mesma potência e velocidade no software; **chiller** é o resfriador que faz a água circular no tubo da laser; **colmeia** é a mesa de favo onde a chapa apoia.

## Premissas e como usar

- Controladora Ruida confirmada em 13/10/2026. Ainda hipótese: modelo CO2 "1490" (área útil 1400 x 900 mm), família RDC644x, software LightBurn (pago) ou RDWorks (gratuito). Cada desvio tem plano B em `contingencias.md` (códigos C1 a C13).
- Marque cada item. Anote em `parametros/resultados.md` na hora do teste, não depois.
- Os limites numéricos (por exemplo 0,05 mm de dispersão no kerf) são critérios práticos propostos neste plano. Não vêm de norma. Se o responsável do laboratório ou o fabricante indicarem outros, valem os deles.
- Potência e velocidade iniciais são ordem de grandeza, não garantia. A máquina decide.
- Kerf nunca entra na geometria. Compensa-se no software de corte. Os modelos só têm folga de encaixe (`clearance`).
- A segurança vem antes da identificação da máquina porque nada liga sem responsável, extintor e exaustão.

### Regras do dia

1. Só o responsável do laboratório mexe em espelho, lente, tubo, chiller e exaustão. Você registra; ele ajusta.
2. Nunca deixe a laser cortando sozinha. Fogo em MDF, couro e acrílico começa em segundos.
3. Offset de kerf em zero até o bloco 6.
4. Mude uma variável por vez.
5. Meça com paquímetro, não a olho. Fotografe tudo (etiquetas, fitas, peças, tela do software com os parâmetros).

## Resumo

Na quarta 04/11, pule para o caminho curto, no fim do arquivo. A tabela abaixo é o roteiro completo, de 6 h.

| Bloco | Tema | Tempo | Arquivo de teste | O que sai | Se reprovar |
| --- | --- | --- | --- | --- | --- |
| 1 | Segurança (portão) | 15 min | nenhum | liberação para ligar | não ligue a laser: C3 |
| 2 | Identificação da máquina | 25 min | nenhum | máquina e software registrados | C1, C2, C4, C5 |
| 3 | Espelhos (verificação) | 30 min | fita crepe | feixe centrado no bico | C8 |
| 4 | Foco | 20 min | ripa de MDF | altura de foco | refazer; sem foco não há corte confiável |
| 5 | Potência x velocidade | 105 min | `teste-potencia-velocidade.scad` | parâmetros por material | C6, C7 |
| 6 | Kerf | 25 min | `teste-kerf.scad` | offset de kerf | C9 |
| 7 | Gravação e registro das camadas | 30 min | `placa-gravacao.scad` | parâmetros de gravação | C10 |
| 8 | Encaixe | 30 min | `caixa-finger-joint.scad` | `clearance`, conferência do kerf e tempo da caixa 80 x 60 x 40 mm | ajustar e recortar |
| 9 | Fila do minicurso (vazão) | 35 min | `chaveiros-lote.scad` | peças por hora | C12 |
| 10 | Decisão go/no-go | 20 min | nenhum | cenário do minicurso | rever blocos |
| | Folga | 25 min | | pausas entre testes, subida de temperatura do chiller, configuração de camadas | |
| | Total | 6 h (5 h 35 de blocos mais a folga) | | | |

A tabela acima é o roteiro completo, de 6 h. Com a janela de 3 h da quarta 04/11, o que vale é o caminho curto da seção no fim: 2 h 40 (3 h com folga). Os blocos 7 (gravação) e 9 (vazão) só entram se houver outra janela.

## Preparação em casa

- [x] Rodar `bash exportar.sh` dentro de `laser/modelos/` e conferir que termina sem erro. Feito em 13/10/2026 com o OpenSCAD 2021.01: os arquivos regenerados saíram idênticos aos do repositório.
- [x] Gerar os arquivos da rodada 1 de cada material (comandos no bloco 5), para não depender do OpenSCAD no laboratório. Feito em 13/10/2026: `pv-r1-mdf`, `pv-r1-acrilico` e `pv-r1-couro`, mais `kerf-mdf` (bloco 6), `placa-teste` (bloco 7), `lote-300x200` e `lote-600x400` (bloco 9), em `svg/` e `dxf/`. Os arquivos da caixa (bloco 8) e da rodada 2 ficam para o dia, porque dependem da espessura medida e do resultado da rodada 1.
- [ ] Copiar para o pendrive: a pasta `laser/` inteira (com `svg/` e `dxf/`), o instalador do OpenSCAD 2021.01 e, se existir, a versão ZIP portátil (conferir no site do OpenSCAD).
- [ ] Levar o plano e o `resultados.md` impressos, ou abertos no notebook.
- [ ] Cortar o kit de contingência pré-cortado (C3) antes de viajar: o ensaio é no dia da chegada, então não há tempo de máquina para o kit em Nova Porteirinha. Obrigatório.
- [ ] Confirmar com a organização o horário, o responsável e os materiais (pendência do instrutor).

### Kit

| Item | Para quê | Bloco |
| --- | --- | --- |
| Paquímetro digital (0,01 mm) | kerf, espessura, encaixe | 6, 8 |
| Fita crepe larga | teste dos espelhos, fixar material | 3, 5 |
| Trena, régua de aço, esquadro | área útil, foco, esquadro da caixa | 2, 4, 8 |
| Marcador permanente fino | marcar fitas e peças | todos |
| Celular (fotos e cronômetro) | registro e tempo | todos |
| Pano seco | limpar fuligem das peças antes de medir | 6 |
| Notebook com OpenSCAD e Inkscape | gerar variações no local | 5 a 9 |
| Pendrive | arquivos e instaladores | todos |
| MDF 3 mm resinado da Meraki: 1 chapa de 600 x 400 mm mais uma de reserva, do estoque já na FAVAG (medir a espessura ao pegar; conferir no bloco 5 como a resina grava) | todos os testes de corte, gravação e encaixe | 4 a 9 |
| Acrílico 3 mm (cast, se possível): 300 x 300 mm | bloco 5 (opcional) | 5 |
| Couro vegetal: retalho de 200 x 150 mm | bloco 5 (opcional) | 5 |

As quantidades de material são estimativa da área usada em todos os blocos, não medida. Confirmar com o laboratório o que existe (pendência do instrutor).

## Bloco 1: Segurança (portão)

Tempo: 15 min. Nada liga antes de este bloco fechar.

- [ ] Anotar nome e telefone do responsável do laboratório. Ele autoriza o uso e qualquer ajuste. Sem ele, não ligue a laser.
- [ ] Extintor: localizar, ver o tipo (CO2 ou pó), a validade e o lacre. Tem que estar ao alcance sem passar na frente da máquina.
- [ ] Exaustão: ligar antes da laser. Checar o fluxo (um papel fino ou uma tira de fita perto da entrada de ar da máquina deve ser puxada). Dutos conectados, sem dobra, com saída para fora.
- [ ] Óculos de proteção para CO2 (10.600 nm; ler a especificação no próprio óculos) para todas as pessoas presentes. Visor e tampa da máquina íntegros.
- [ ] Botão de emergência: o responsável mostra onde fica e confirma que funciona. Não desative sensores de tampa.
- [ ] Interior da máquina e mesa sem restos de material (risco de fogo).
- [ ] Combinar o que não entra na máquina. Lista abaixo.

Não corte:

- PVC, vinil, "couro sintético" ou qualquer plástico desconhecido, e outros materiais com cloro. Liberam cloro e ácido que corroem a máquina e intoxicam.
- Policarbonato e ABS (soltam fuligem e gases ruins; o ABS pode liberar cianeto).
- Poliestireno e espumas plásticas (isopor): pegam fogo.
- Fibra de vidro e fibra de carbono revestida.
- Couro curtido ao cromo. Use couro curtido vegetal.
- Materiais com cola ou adesivo na face (podem sujar a lente) e qualquer coisa sem rótulo.

Aprovado: responsável presente, extintor válido ao alcance, exaustão puxando, óculos para todos, emergência localizada.

Reprovado: qualquer item acima falhou. Não ligue a laser. Vá para C3 e trate só de software e computadores (blocos 2 e 5 sem disparar a laser).

Registrar: nome e telefone do responsável, tipo e validade do extintor, fotos do extintor e da exaustão.

## Bloco 2: Identificação da máquina

Tempo: 25 min. Depois do bloco 1 aprovado.

Passos, com a máquina desligada:

- [ ] Fotografar a etiqueta da máquina (fabricante, modelo, tensão, potência) e a etiqueta do tubo, se o responsável abrir o compartimento (potência nominal em W).
- [ ] Anotar a lente (distância focal; as comuns em CO2 são 2 polegadas, 50,8 mm, mas há outras: conferir na lente ou com o responsável) e o bico (diâmetro da saída, estado, limpeza). Não toque na lente. Quem limpa é o responsável.
- [ ] Anotar o tipo de mesa (colmeia, lâminas ou fixa), a limpeza da colmeia e se ela é plana (régua de aço sobre a mesa, olhar contra a luz).

Ligue com o responsável: primeiro o chiller (a água precisa circular antes de a laser disparar), depois a exaustão e o compressor, depois a máquina e a controladora. A laser só dispara a partir do bloco 3.

- [ ] Controladora: modelo na tela inicial ou no menu de informações do painel (conferir no painel). Anotar também a versão de firmware se aparecer. A controladora é Ruida (confirmado em 13/10/2026): anotar o modelo exato (RDC644x ou outro). Se o painel mostrar outra marca, C1.
- [ ] Como o computador fala com a máquina: USB, rede (cabo) ou só pendrive.
- [ ] Software no computador do laboratório: nome e versão. LightBurn: abrir e ver a tela de licença. A licença do LightBurn é por tipo de controladora; para Ruida, a página LaserTypes da documentação pede a LightBurn Pro, que cobre controladoras DSP (conferir o nome do plano na loja). RDWorks: versão e se abre arquivos.
- [ ] Teste de importação no software: abrir `svg/chaveiro-tag-cut.svg`, `dxf/chaveiro-tag-cut.dxf` e `svg/chaveiro-tag-combinado.svg`; depois, juntos, o par `svg/chaveiro-tag-cut.svg` e `svg/chaveiro-tag-engrave.svg`. Importa SVG? Importa DXF? As formas chegam fechadas (selecione o contorno e veja se é um objeto só)? O combinado chega com duas camadas por cor, vermelho (corte) e azul (gravação)? O par importado em separado chega alinhado (o texto dentro do contorno)? Conferir na versão instalada. Este passo responde, já na quarta, se as camadas alinham.
- [ ] Depois de importar o SVG e o DXF, medir o contorno no software: deve dar 60 x 25 mm (ou o tamanho do modelo, se você mudou a tag). O DXF do OpenSCAD não declara unidade: o software pode ler em mm, em polegada ou em outra. Registrar o tamanho medido e a unidade que o software assumiu.
- [ ] Potência nominal do tubo (W) e a potência máxima de operação que o responsável autoriza. Registrar o limite. Nos testes, não passe dele.
- [ ] Área útil real: levar o cabeçote até o fim de X e de Y pelo painel e medir o curso com a trena. Comparar com 1400 x 900 mm (hipótese).
- [ ] Mesa e eixo Z: sobe e desce pelo painel? Curso medido.
- [ ] Ar assistido: compressor ligado, ar saindo pelo bico (sentir com a mão), pressão ou fluxo audível.
- [ ] Exaustão: modelo ou potência do exaustor, comprimento e curvas do duto.
- [ ] Chiller: modelo, nível, alarmes, temperatura da água ao ligar e depois de 10 min de máquina ligada. Referência provisória: os tubos de vidro CO2 costumam pedir água entre 15 e 25 °C. O responsável confirma a faixa do tubo instalado.
- [ ] Computadores do laboratório: quantos, sistema operacional, OpenSCAD instalado (versão), Inkscape, fonte Liberation Sans, internet (abrir o LLM que a turma usará), portas USB livres, permissão para rodar programa do pendrive.

Aprovado: todos os campos preenchidos, controladora e software identificados, SVG ou DXF importa com formas fechadas, chiller dentro da faixa, sem alarme.

Reprovado e o que fazer:

| Falha | Vá para |
| --- | --- |
| Controladora não é Ruida | C1 |
| Sem licença do LightBurn ou licença do tipo errado | C2 |
| Sem internet no laboratório | C4 |
| Computadores sem OpenSCAD | C5 |
| Chiller com alarme ou água fora da faixa | C13 (não corte até resolver) |
| SVG não importa e o DXF abre com linhas soltas | C10 |

Registrar: seção "Máquina" do `resultados.md`.

## Bloco 3: Alinhamento dos espelhos (verificação, não ajuste)

Tempo: 30 min. Objetivo: saber se o feixe chega centrado ao bico em toda a mesa. Este bloco não ajusta nada. Quem ajusta é o responsável.

Antes: bloco 1 aprovado, responsável presente, óculos, exaustão ligada, tampa fechada sempre que a máquina permitir. Material: fita crepe, marcador, régua, celular.

Potência do teste: a menor que marca a fita. Comece em 5 a 10 % e suba de 2 em 2 pontos se não marcar. Pulso curto (toque rápido na tecla de teste do painel; conferir o nome da tecla no painel). Potência alta incendeia a fita.

Passos (chame de espelho 1 o que sai do tubo, espelho 2 o do portal e espelho 3 o do cabeçote):

- [ ] Espelho 1 para espelho 2: cole fita na entrada do espelho 2. Com o portal perto do espelho 1, dispare um pulso e numere a mancha (1). Leve o portal ao ponto mais longe, dispare de novo na mesma fita e numere a mancha (2). As duas manchas devem coincidir e ficar perto do centro da abertura.
- [ ] Espelho 2 para espelho 3: cole fita na entrada do espelho 3. Com o cabeçote perto do espelho 2, dispare um pulso e numere a mancha (1). Leve o cabeçote ao ponto mais longe e repita (2). As manchas devem coincidir.
- [ ] Espelho 3 para o bico: cole fita sobre a saída do bico. Leve o cabeçote aos quatro cantos da área útil e ao centro. Um pulso em cada ponto. Cada mancha deve ficar no centro do furo do bico, redonda, sem tocar na borda.
- [ ] Fotografar cada fita com régua ao lado e escrever na fita o ponto (perto, longe, canto).

Aprovado: manchas coincidentes entre perto e longe (diferença menor que cerca de 1 mm) nos dois primeiros testes e cinco manchas centradas e redondas no bico.

Reprovado: manchas que andam entre perto e longe, marca em meia-lua ou anel (feixe cortado pela borda), mancha encostada no bico ou fora do centro.

O que fazer se estiver fora:

1. Não ajuste. Fotografe, mostre ao responsável e anote qual canto e qual espelho.
2. Se o responsável quiser ajustar na hora, reserve mais 30 min e refaça o bloco inteiro depois. Se ninguém conhece o procedimento da máquina, não improvise.
3. Sem ajuste, restrinja os testes e o minicurso à região em que as cinco manchas ficaram centradas (anote em centímetros a partir da origem). Plano em C8.

Registrar: fotos das fitas, região segura da mesa.

## Bloco 4: Foco

Tempo: 20 min. Objetivo: achar a distância entre a ponta do bico e a superfície do material que dá a linha mais fina, e registrá-la.

Escolha um método:

- Gabarito de foco: se o laboratório tem, use e registre a espessura dele.
- Rampa (método principal): serve em qualquer máquina.
- Teste de foco do LightBurn: em máquinas com Z motorizado há uma ferramenta de teste de foco no menu Laser Tools (conferir na versão instalada).

Rampa:

- [ ] Pegue uma ripa reta de MDF de 300 a 400 mm. Apoie uma ponta em um calço de 10 a 15 mm e a outra na mesa. O calço não pode levantar a ripa acima do curso do cabeçote.
- [ ] Ajuste a mesa para que o meio da ripa fique perto da altura em que o responsável costuma focar.
- [ ] No software, desenhe uma linha reta de 300 mm no sentido da ripa. Grave em potência baixa e velocidade média. Ponto de partida: cerca de 25 % e 200 mm/s em tubo de 80 W (valor sugerido pela OMTech para uma máquina de 80 W; ajuste ao tubo). O objetivo é uma linha visível, não um corte.
- [ ] Olhe a linha. O trecho mais fino e mais escuro é o foco.
- [ ] Leve o cabeçote até esse trecho (setas do painel) e meça, com régua ou paquímetro, a distância entre a ponta do bico e a superfície da ripa ali.
- [ ] Repita uma vez com a ripa virada para conferir que o ponto se repete.
- [ ] Faça um calço com essa altura (chapas de 3 mm empilhadas ou um bloco) para refocar rápido. Anote a altura.

Aprovado: um trecho claramente mais fino, a altura medida se repete em duas passadas (diferença menor que 1 mm) e o calço fecha o foco em 10 s.

Reprovado: linha igualmente larga em toda a rampa, ou foco que muda de lugar a cada passada. Possíveis causas: lente suja ou instalada ao contrário, mesa desnivelada, feixe desalinhado. Avise o responsável. Sem foco repetível, o kerf do bloco 6 não vale.

Registrar: método, altura bico-material, leitura do eixo Z no painel (se houver).

## Bloco 5: Potência x velocidade

Tempo: MDF 3 mm, 40 min. Acrílico 3 mm, 40 min. Couro (se houver), 25 min.

Arquivo: `teste-potencia-velocidade.scad`. Cada coluna é uma velocidade (aumenta para a direita). Cada linha é uma potência (aumenta para cima). Os números são gravados ao lado dos quadrados.

Antes de cada material (acrílico: ar assistido ligado e presença constante, ele pega fogo):

- [ ] Medir a espessura em 3 pontos com paquímetro e anotar a média.
- [ ] Fixar a chapa (fita nos cantos, fora da área de teste).
- [ ] Ajustar o foco com o calço do bloco 4 (a superfície do material na altura de foco).
- [ ] Offset de kerf em zero. Ar assistido e exaustão ligados.
- [ ] Potência máxima de operação autorizada no bloco 2: não passar dela.
- [ ] Potência mínima igual à máxima em cada camada de teste. A Ruida varia a potência entre a mínima e a máxima conforme a velocidade real do cabeçote (ele desacelera nos cantos); no teste isso mistura potências na mesma célula. Nome dos campos: conferir no painel e no software.

### Rodada 1: varredura de velocidade (uma linha, 5 camadas)

Gere os arquivos antes (dentro de `laser/modelos/`). Cada comando grava `-cut.svg`, `-engrave.svg` e `-combinado.svg` (corte em vermelho, gravação em azul), todos com o mesmo quadro, para as camadas ficarem alinhadas.

```
bash exportar.sh -n pv-r1-mdf -D 'powers=[80]' -D 'note="MDF 3 mm R1"' teste-potencia-velocidade
bash exportar.sh -n pv-r1-acrilico -D 'powers=[80]' -D 'note="Acrílico 3 mm R1"' teste-potencia-velocidade
bash exportar.sh -n pv-r1-couro -D 'powers=[60]' -D 'speeds=[20,30,40,50,60]' -D 'note="Couro R1"' teste-potencia-velocidade
```

A potência de 80 % é um ponto de partida: use o menor entre 80 % e o limite autorizado. As velocidades padrão (10 a 50 mm/s) são uma estimativa de ordem de grandeza para tubos de 60 W a 130 W em MDF de 3 mm. A rodada 1 precisa ter pelo menos uma coluna que corta e uma que não corta. Se todas cortarem, suba as velocidades; se nenhuma cortar, desça (`-D 'speeds=[...]'`) e repita. Confirme a unidade do software: o LightBurn pode estar em mm/min.

Passos:

- [ ] Importar `svg/pv-r1-mdf-combinado.svg` (ou o do material em teste). O LightBurn separa as camadas por cor na importação: vermelho é o corte, azul são os números (conferir na versão instalada). Se o software não separar por cor, importe `-cut.svg` e `-engrave.svg` e veja C10. Conferir que os números ficaram alinhados com os quadrados.
- [ ] Se os quadrados vieram como uma forma só, separe-os (LightBurn: Arrange, Break Apart; Inkscape: Caminho, Separar; conferir o nome na versão instalada). Uma forma só fica em uma camada só.
- [ ] Gravação dos números: uma camada de preenchimento. Ponto de partida: 20 a 30 % e 250 a 300 mm/s. Ajustar até ficar legível sem marcar demais.
- [ ] Quadrados: uma camada por quadrado, modo linha (corte), com a velocidade da coluna e a potência da linha, 1 passe, ar ligado. A rodada 1 usa 5 camadas.
- [ ] Ordem: gravação primeiro, depois os cortes. Se o software tiver a opção de cortar formas internas antes das externas, ligue (no LightBurn, em Optimization Settings).
- [ ] Origem no canto do material (LightBurn: modo de início a partir da posição atual ou da origem do usuário; painel Ruida: tecla de origem; conferir). Fazer o contorno (frame) para ver se cabe na chapa.
- [ ] Rodar. Ficar ao lado.

### Rodada 2: grade fina (25 camadas)

Faça a rodada 2 só no MDF, e no acrílico se houver tempo. Use como centro a velocidade mais rápida da rodada 1 que cortou. Exemplo: se 30 mm/s foi a mais rápida que cortou:

```
bash exportar.sh -n pv-r2-mdf -D 'speeds=[26,28,30,32,34]' -D 'powers=[60,65,70,75,80]' -D 'note="MDF 3 mm R2"' teste-potencia-velocidade
```

A grade 5 x 5 usa 25 camadas. O LightBurn tem 30 camadas (conferir na versão instalada). Se o RDWorks da máquina tiver menos, use 4 x 4 (conferir o limite). O LightBurn também tem o gerador Material Test, no menu Laser Tools (conferir na versão instalada): ele monta a grade, as camadas e os rótulos sozinho e pode substituir a rodada 2 do OpenSCAD.

### Como ler o resultado

Espere esfriar. Empurre cada quadrado com o dedo. Olhe o verso.

| Marca | Significa |
| --- | --- |
| Cortou | o quadrado cai ou sai com um toque, sem ponte no verso nem nos cantos |
| Não cortou | continua preso |
| Borda boa | MDF: marrom, sem carbonizar fundo. Acrílico: translúcida e lisa. Couro: escura, sem fiapo solto |
| Borda ruim | preta e profunda, bolhas, rebarba, chama |

Como escolher: a combinação mais rápida que corta com borda boa. Depois recue um degrau (uma velocidade menor, ou 5 a 10 pontos de potência a mais) para ter margem contra variação de material. Não use a célula do limite: ela corta hoje e falha amanhã.

Se nenhuma célula corta, no limite de potência autorizado e na menor velocidade, refaça com 2 passes e registre `passes = 2`.

Os números gravados têm 3 mm em negrito. Se saíram legíveis, 3 mm é o mínimo seguro de texto para este material nos ajustes da camada de gravação.

Aprovado: existe célula que corta limpo com margem no MDF, e o resultado se repete em uma segunda chapa (corte só uma linha para confirmar).

Reprovado: nenhuma combinação corta limpo, ou o resultado não repete. Verifique foco (bloco 4) e alinhamento (bloco 3). Acrílico com chama ou borda cheia de bolhas: pare, reduza a potência, confira o ar e volte só com o responsável.

Registrar: uma linha por material e rodada na tabela "Corte" do `resultados.md`.

## Bloco 6: Kerf

Tempo: 25 min. Arquivo: `teste-kerf.scad`. Use os parâmetros do MDF achados no bloco 5.

Definição: kerf é a largura do corte. Medida pela peça que sai: lado desenhado menos lado medido.

Gere o arquivo e corte com o offset de kerf em zero:

```
bash exportar.sh -n kerf-mdf -D 'note="MDF 3 mm"' teste-kerf
```

- [ ] Cortar em 3 posições da mesa: centro, canto da frente à esquerda e canto de trás à direita (dentro da região segura do bloco 3). Se der tempo, 5 posições.
- [ ] Antes de tirar cada peça da mesa, marcar nela com o marcador a posição em que foi cortada (centro, frente esquerda, trás direita, e assim por diante). Sem a marca as medidas se misturam.
- [ ] Esperar esfriar. Limpar a fuligem com pano seco (sem lixar).
- [ ] Medir com paquímetro, por fora:
  - quadrado de 20 mm: dois lados em X e dois em Y. Média de X e média de Y, separadas. O quadrado já basta como medida principal;
  - conferência: os quatro dentes do pente que ficam ao lado das ranhuras de 2,0 mm ou mais (do 3º ao 6º, contando da esquerda; largura desenhada de 6 mm). Média dos quatro. Os dentes ao lado das ranhuras de 1,0 e 1,5 mm ficam fora da média.
- [ ] Calcular: `kerf = largura desenhada - largura medida`. Use só medidas externas (quadrado e os quatro dentes) na média.
- [ ] Conferir com as ranhuras (medida interna): `kerf = largura medida - largura nominal`. Ranhuras estreitas não aceitam o paquímetro: use lâminas de calibre, brocas ou retalhos de espessura conhecida. Confira, mas não misture na média: medida interna e externa erram para lados opostos.
- [ ] Comparar as posições. Se a diferença entre a maior e a menor ficar acima de 0,05 mm, o problema é foco ou planicidade da mesa. Compensar não resolve: volte ao bloco 4 (C9).

Onde digitar o offset:

- LightBurn: janela Cuts / Layers, duplo clique na camada de corte, Cut Settings Editor, modo Line, campo Kerf Offset. Valor positivo desloca o caminho para fora; negativo, para dentro. Só vale para formas fechadas.
- RDWorks: função de compensação de kerf (conferir o nome e o lugar na versão instalada).
- Software sem função de offset de kerf (conferir): faça o offset do contorno no Inkscape, em Caminho, Deslocamento dinâmico (ou vinculado), com valor numérico igual a `kerf / 2`, em mm. Procedimento completo em `contingencias.md`, seção "Offset de kerf no Inkscape". Ponha o valor no nome do arquivo (por exemplo `chaveiro-tag-cut-kerf0.10.svg`) e deixe o kerf offset do software da laser em zero, para não compensar duas vezes. Nunca no `.scad`.

Primeiro palpite: digite metade do kerf medido (`kerf / 2`). O offset desloca o caminho por lado, então meio kerf para cada lado fecha o tamanho.

Confirme em ciclo fechado: corte de novo o quadrado de 20 mm com o offset ligado e meça.

| Quadrado depois do offset | Diagnóstico | Ação |
| --- | --- | --- |
| entre 19,95 e 20,05 mm | calibrado | registrar |
| abaixo de 19,95 mm, com erro perto da metade do anterior | o campo espera o kerf inteiro | digitar o kerf inteiro |
| abaixo de 19,95 mm, com erro maior que o anterior | sinal trocado | trocar o sinal |
| acima de 20,05 mm | compensou demais | reduzir o valor |

A documentação do LightBurn traz um arquivo de teste de kerf com escala vernier (.lbrn2, guia "Test KerfOffset"). Corta-se com o Kerf Offset em 0, lê-se D.E na escala e, segundo o guia, o resultado (D.E)/40 vai direto no campo Kerf Offset. Serve como segunda opinião.

O kerf só vale para o material, a espessura, a potência, a velocidade e o foco usados. Mudou um deles, meça de novo.

Aprovado: dispersão entre posições de até 0,05 mm e quadrado final de 20,00 mm, com erro de até 0,05 mm.

Reprovado: dispersão acima de 0,05 mm (C9), ou offset que não fecha em três tentativas.

Registrar: tabela "Kerf" do `resultados.md`, com as medidas de cada posição.

## Bloco 7: Gravação e registro das camadas

Tempo: 30 min. Arquivo: `placa-gravacao.scad` (cut e engrave).

```
bash exportar.sh -n placa-teste placa-gravacao
```

A placa tem um título (negrito), um subtítulo e três amostras de preenchimento numeradas.

- [ ] Importar `svg/placa-teste-combinado.svg` (corte em vermelho, gravação em azul; o LightBurn separa por cor, conferir na versão instalada).
- [ ] Registro: o texto caiu dentro do contorno, centralizado? O combinado é um arquivo só, então as camadas já nascem alinhadas. Se importou `-cut.svg` e `-engrave.svg` separados e eles chegaram deslocados, refaça com marcas de registro: `bash exportar.sh -n placa-reg -D registration=true placa-gravacao`. Cada camada ganha duas marcas de 0,6 mm iguais, fora da placa: sobreponha as marcas. Os DXF (`dxf/`, coordenadas absolutas) são outra saída. Anote o que funcionou em a lista de pendências do instrutor (fora da versão pública) e em C10.
- [ ] Camada de gravação: modo preenchimento (fill). Intervalo de linha de 0,1 mm como ponto de partida. Velocidade e potência de partida: 250 a 300 mm/s e 20 a 30 % no MDF.
- [ ] As três amostras, uma em cada camada, para comparar. Ao trocar uma amostra de camada, selecione o quadrado junto com o número vazado dentro dele; sem o número, ele fica na camada antiga e a amostra sai errada:
  - amostra 1: ajuste base;
  - amostra 2: mesma velocidade e potência 10 pontos acima;
  - amostra 3: ajuste base com intervalo de linha de 0,15 mm.
- [ ] Contorno de corte com os parâmetros do MDF e o offset do bloco 6. Gravar antes de cortar. A chapa não pode sair do lugar entre as duas operações.
- [ ] Olhar o resultado de perto e a um braço de distância.

Critérios:

| Item | Aprovado se | Reprovado se |
| --- | --- | --- |
| Título e subtítulo | legíveis, sem borrão | letras fechadas ou borradas (foco, potência alta) |
| Preenchimento | uniforme, sem listras a um braço de distância | listras (reduza o intervalo de linha) ou queima funda |
| Registro | texto dentro do contorno, margem uniforme | camadas deslocadas |
| Corte | contorno e furos limpos | contorno não fecha |

Escolha a amostra que dá o melhor contraste sem queimar. Registre velocidade, potência e intervalo.

Registrar: tabela "Gravação" do `resultados.md`.

## Bloco 8: Encaixe

Tempo: 30 min. Arquivo: `caixa-finger-joint.scad`. Caixa pequena de teste, com o kerf calibrado e a espessura medida. Depois, a caixa do exercício 2 do minicurso, só para cronometrar.

Troque `2.9` pela espessura medida no bloco 5:

```
bash exportar.sh -n caixa-teste -D 'length=60' -D 'width=40' -D 'height=30' -D 'thickness=2.9' -D 'clearance=0.1' caixa-finger-joint
```

- [ ] Cortar os 5 painéis com os parâmetros do MDF e o offset de kerf do bloco 6.
- [ ] Montar a seco, sem cola, só com a mão.
- [ ] Virar a caixa de cabeça para baixo, segurando só pela base.
- [ ] Conferir o esquadro: as duas diagonais do topo iguais, com erro de até 1 mm.
- [ ] Se sobrar tempo, cortar com `-D with_lid=true` e testar a tampa (o miolo entra na abertura, a tampa assenta).
- [ ] Com o encaixe aprovado, cortar a caixa de 80 x 60 x 40 mm (valores padrão do modelo; `thickness` medida) e cronometrar o corte e a gravação dos nomes dos painéis, separados. Alimenta a regra de decisão da fila (`minicurso/roteiro-instrutor.md`, seção 1). Anotar em "Fila" do `resultados.md`.

```
bash exportar.sh -n caixa-80x60x40 -D 'thickness=2.9' caixa-finger-joint
```

| Resultado | Aprovado se | Folgado se | Apertado se |
| --- | --- | --- | --- |
| Montagem | encaixa com a mão, com leve pressão | entra sem pressão | exige martelo, lasca ou não entra |
| Caixa virada | nenhuma peça se solta | peça se solta ou balança | |

Ajuste:

- Folgado: reduzir `clearance` (0,1 para 0,05 e depois 0). Ou aumentar o offset de kerf.
- Apertado: aumentar `clearance` (0,15 e depois 0,2). Ou reduzir o offset de kerf.
- O `clearance` muda a folga de cada junta de 1 para 1. O offset muda de 4 para 1 (0,01 mm de offset por lado altera a folga em 0,04 mm). Prefira mexer no `clearance`.
- Se o encaixe só fecha com `clearance` fora de 0 a 0,2, o offset de kerf está errado: volte ao bloco 6.

Aprovado: caixa monta com a mão, sem lascar, não desmonta ao virar e fecha em esquadro, com `clearance` entre 0 e 0,2.

Reprovado: não fecha depois de dois ajustes. Meça a espessura de novo em outros pontos da chapa (varia dentro da mesma chapa) e volte ao bloco 6.

Registrar: tabela "Encaixe" do `resultados.md`, com a espessura medida, o offset e o `clearance` adotados.

## Bloco 9: Fila do minicurso (vazão)

Tempo: 35 min. Arquivo: `chaveiros-lote.scad`. Objetivo: medir quantas peças a laser entrega por hora e achar o **t1** do minicurso.

O chaveiro cronometrado é o da aula: 70 x 25 mm, texto de 8 mm, furo de 4,5 mm a 3,5 mm da borda (conforme `minicurso/roteiro-instrutor.md`, seção 1, e `minicurso/materiais.md`, seção 6). Com ele cabem 18 por chapa de 300 x 200 mm (3 colunas e 6 linhas) e 104 por chapa de 600 x 400 mm. Gere o lote do tamanho da chapa que você tem:

```
bash exportar.sh -n lote-300x200 -D count=18 -D tag_width=70 -D font_size=8 -D hole_diameter=4.5 -D hole_margin=3.5 chaveiros-lote
bash exportar.sh -n lote-600x400 -D sheet_width=600 -D sheet_height=400 -D count=100 -D tag_width=70 -D font_size=8 -D hole_diameter=4.5 -D hole_margin=3.5 chaveiros-lote
```

A lista padrão tem 24 nomes. Com os 18 primeiros, nenhum nome encolhe a 8 mm. Na lista inteira, só "Wellington" encolhe (para 7,9 mm) e o script avisa.

- [ ] Preparar o arquivo: importar o `-combinado.svg`, atribuir as camadas com os parâmetros de MDF (corte e gravação do bloco 5 e 7) e o offset de kerf. Cronometrar: `T_prep`.
- [ ] Rodar o lote completo (gravação e corte). Cronometrar do início até a máquina parar: `T_maq`. Compare com a estimativa do software.
- [ ] Retirar as peças, limpar a mesa e posicionar a próxima chapa. Cronometrar: `T_desc`.
- [ ] Contar as peças que saíram soltas e boas. Anotar defeitos (queimada, presa, texto fora do lugar).

Conta:

- Ciclo sequencial = `T_prep` + `T_maq` + `T_desc`.
- Ciclo com preparo em paralelo (a turma prepara o próximo arquivo enquanto a laser corta) = o maior entre `T_prep` e `T_maq`, mais `T_desc`.
- Peças por hora = 60 x peças boas ÷ ciclo em minutos.
- t1 = `T_maq` em segundos ÷ número de chaveiros do lote. É o número que o monitor do minicurso calcula para a regra de decisão da fila (regra e valor de planejamento em `minicurso/plano-de-aula.md`, seção 6.5).
- Capacidade do minicurso = (minutos de laser reservados ÷ ciclo em paralelo, arredondado para baixo) x peças boas por chapa.
- Demanda = vagas x peças por participante.

Exemplo da conta, com números inventados só para mostrar o cálculo: ciclo de 20 min, 18 peças boas por chapa, 90 min de laser: 4 chapas, capacidade de 72 peças. Com 16 vagas e 1 peça cada, a demanda é 16.

Aprovado: capacidade maior ou igual a 1,3 vez a demanda.

Reprovado: capacidade menor. Veja C12 (lote único do instrutor, só corte sem gravação, peças menores).

Registrar: tabela "Fila" do `resultados.md`, com o t1 e o tempo da caixa de 80 x 60 x 40 mm. Vagas, peças por participante e minutos de laser dependem da organização (pendência do instrutor).

## Bloco 10: Decisão go/no-go

Tempo: 20 min. Revise o `resultados.md` e marque cada critério.

| # | Critério | Bloco | Aprovado se | Resultado |
| --- | --- | --- | --- | --- |
| 1 | Segurança | 1 | todos os itens do portão | |
| 2 | Máquina e software | 2, 5 | controladora identificada; SVG ou DXF importa com formas fechadas | |
| 3 | Alinhamento | 3 | aprovado na mesa toda; ou aprovado só em uma região restrita, anotada (cenário E) | |
| 4 | Foco | 4 | altura registrada e repetível | |
| 5 | MDF 3 mm: corte | 5 | combinação que corta limpo com margem, repetida | |
| 6 | Kerf e encaixe | 6, 8 | quadrado de 20,00 mm (até 0,05) e caixa que fecha | |
| 7 | Gravação | 7 | texto legível e camadas alinhadas | |
| 8 | Vazão | 9 | capacidade maior ou igual a 1,3 vez a demanda | |
| 9 | Acrílico (opcional) | 5 | corta limpo e a exaustão dá conta | |
| 10 | Couro (opcional) | 5 | corta sem derreter e a exaustão dá conta | |

Cenários:

| Cenário | Quando | O que muda no minicurso |
| --- | --- | --- |
| A. Go total | 1 a 8 aprovados e pelo menos um entre 9 e 10 | corte e gravação ao vivo em MDF e no material aprovado; tire da apostila o que reprovou (por exemplo, acrílico aprovado e couro reprovado: sem couro); tabela de parâmetros adotados na apostila |
| B. Go só MDF | 1 a 8 aprovados; 9 e 10 reprovados ou sem material | tirar acrílico e couro dos exercícios; apostila só com MDF 3 mm |
| C. Go com lote do instrutor | 1 a 7 aprovados; 8 reprovado | os participantes preparam arquivos; o instrutor corta em lotes por rodada; uma peça por pessoa; só corte, gravação opcional |
| D. Go com RDWorks ou DXF | 2 aprovado só com RDWorks ou DXF | passo extra de conversão na apostila (C1, C2, C10); tempo maior de preparo |
| E. Go em região restrita | critério 3 aprovado só com região restrita | peças pequenas, perto do centro da mesa (C8) |
| F. No-go da laser | 1 reprovado, ou 3, 4, 5 ou 6 sem solução | kit pré-cortado e montagem; modelagem e exportação seguem (C3) |

No caminho curto da quarta, os critérios 7 (gravação) e 8 (vazão) ficam como "não testado": adote o cenário B (ou A, se acrílico ou couro tiverem sido testados), com a fila nos valores de planejamento e a gravação conferida na prévia do software. Se vier outra janela em 05 ou 06/11, complete os blocos 7 e 9 e refaça a decisão.

Registre a decisão na seção "Decisão go/no-go" do `resultados.md`. Atualize a lista de pendências do instrutor (fora da versão pública) e avise a organização do resultado.

## Caminho curto de 3 h: o roteiro da quarta 04/11 (2 h 40 de blocos, 3 h com folga)

| Bloco | O que fazer | Tempo |
| --- | --- | --- |
| 1 | completo | 15 min |
| 2 | completo, inclusive a importação do combinado e do par de SVG por camada | 25 min |
| 3 | só espelho 3 para o bico, nos quatro cantos | 15 min |
| 4 | rampa, uma vez | 15 min |
| 5 | só MDF, rodada 1 | 25 min |
| 6 | quadrado e dentes em 3 posições, mais 7 quadrados de 20 mm soltos (com os 3, são os 10 quadrados sem compensação que a turma mede no minicurso) | 25 min |
| 8 | caixa pequena | 25 min |
| 10 | decisão | 15 min |
| Total | | 2 h 40 (3 h com folga) |

Fica sem teste: acrílico, couro, gravação real (bloco 7), vazão e o tempo da caixa (o registro das camadas é conferido na importação do bloco 2). Risco: o minicurso começa sem saber o tempo por peça. Use o tempo de corte estimado pelo software para dimensionar a fila (a regra de decisão de `minicurso/plano-de-aula.md`, seção 6.5, parte dos valores de planejamento) e mantenha o plano de gravação como demonstração do instrutor. Se a organização abrir outra janela em 05 ou 06/11, rode nela os blocos 7 e 9 (com a caixa de 80 x 60 x 40 mm cronometrada) e, se der, o bloco 5 em acrílico e couro.

## Saídas esperadas ao fim do dia

- `parametros/resultados.md` preenchido, com "parâmetros adotados no minicurso".
- `parametros/folha-parametros.md` preenchida com os mesmos valores: é a folha de uma página que vai impressa para a aula.
- Fotos: etiquetas, painel, tubo e lente (se possível), fitas dos espelhos, cartões de teste, caixa montada, tela do software com os parâmetros.
- Linhas resolvidas na lista de pendências marcadas, e as novas registradas.
- Decisão go/no-go comunicada à organização.
