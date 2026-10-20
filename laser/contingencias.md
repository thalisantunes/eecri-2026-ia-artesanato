# Contingências: laser do I EECri

Glossário: **DSP** é um tipo de controladora de máquinas CO2 (Ruida, Trocen, Topwisdom), diferente das de G-code, como o GRBL; **raster** é a gravação por varredura de linhas, como uma impressora; **chiller** é o resfriador que faz a água circular no tubo da laser.

Matriz de situações que podem mudar ou inviabilizar a parte de laser do minicurso (07/11) e o plano B de cada uma. Os códigos C1 a C13 são citados em `ensaio-laser.md`. A maioria das situações aparece no ensaio de quarta 04/11; a decisão final sai no bloco 10 daquele roteiro.

Regra para todos os casos: o fluxo é o mesmo (OpenSCAD, SVG ou DXF, software da controladora). O que muda é o software, a tela de parâmetros e o formato de arquivo. Kerf nunca entra na geometria dos modelos: compensa-se no software de corte, ou no Inkscape se o software não tiver a função (seção "Offset de kerf no Inkscape", abaixo).

## Matriz

| Cód. | Situação | Como detectar | Plano B | Impacto no minicurso |
| --- | --- | --- | --- | --- |
| C1 | Controladora não é Ruida (Topwisdom, GRBL, M2 Nano ou outra). Improvável: a Ruida foi confirmada em 13/10/2026; o plano B fica como reserva | Bloco 2: modelo na tela inicial ou no menu do painel (conferir no painel), etiqueta da controladora, software no computador | Usar o software da própria controladora (tabela em C1). Refazer blocos 5 a 8 nesse software. Sem função de offset de kerf, fazer o offset no Inkscape (seção "Offset de kerf no Inkscape") | Telas e menus da apostila mudam. O conteúdo de OpenSCAD fica igual |
| C2 | LightBurn sem licença, ou licença de outro tipo de controladora | Bloco 2: tela de licença ao abrir o LightBurn; envio à máquina bloqueado; plano só para G-code em controladora Ruida | RDWorks (gratuito) com DXF; teste gratuito do LightBurn (conferir se ainda existe); preparar o trabalho no notebook do instrutor (detalhes em C2) | Com RDWorks a turma importa DXF, não SVG: um passo a mais |
| C3 | Laser indisponível ou insegura | Bloco 1: sem responsável, sem extintor, sem exaustão. Bloco 2: alarme do chiller, máquina não liga. Bloco 3: feixe fora e sem quem ajuste | Kit de peças pré-cortadas na laser do instrutor, para manter a parte de montagem. Tem de ser cortado antes de viajar | Sem corte ao vivo. A turma monta o kit; modelagem e exportação seguem |
| C4 | Sem internet | Bloco 2: abrir o LLM no computador do laboratório e no celular com dados móveis | Prompts e modelos pré-gerados no pendrive; a turma só edita parâmetros no OpenSCAD; o instrutor faz a demonstração ao vivo com o celular como roteador | Menos geração ao vivo. O objetivo (ver o parâmetro virar peça) continua |
| C5 | Computadores sem OpenSCAD | Bloco 2: programa não aparece, versão diferente ou sem permissão para instalar | Instalador e, se existir, a versão ZIP portátil no pendrive (conferir no site do OpenSCAD); se nada rodar, notebooks dos participantes ou o notebook do instrutor com SVGs pré-exportados | Menos prática individual. Variações exportadas pelo instrutor sob demanda |
| C6 | Exaustão fraca | Bloco 1: papel ou fita não é puxado. Bloco 5: fumaça sobe, cheiro na sala, ardência nos olhos | Só MDF. Nada de acrílico nem de couro. Cortes curtos com pausa para a fumaça sair, portas e janelas abertas. Parar se a fumaça sair para a sala | Exercícios em acrílico e couro saem. Vazão menor |
| C7 | Material diferente do previsto | Bloco 5: espessura medida e etiqueta do material diferentes de MDF, acrílico ou couro de 3 mm | Nova grade de testes (rodada 1) para o material. Refazer kerf (bloco 6) e encaixe (bloco 8) com a espessura medida em `thickness` | A tabela de parâmetros da apostila muda. Reserve um ciclo de testes por material |
| C8 | Espelhos desalinhados | Bloco 3: manchas que andam entre perto e longe, meia-lua, mancha fora do centro do bico | Não ajustar sem o responsável. Se ele ajustar, refazer o bloco 3. Se ninguém ajustar, usar só a região em que o feixe ficou centrado | Peças pequenas, perto do centro da mesa. Chapas menores nos lotes |
| C9 | Foco ou kerf instável | Bloco 4: foco que muda de lugar. Bloco 6: diferença entre posições acima de 0,05 mm | Compensar não resolve. Refazer o foco, checar a planicidade da mesa e a limpeza da lente com o responsável. Se não resolver, usar projetos sem encaixe justo (chaveiro, placa) e `clearance` maior nas caixas | Caixa finger joint vira demonstração, não exercício de encaixe |
| C10 | Importação falha ou camadas desalinhadas | Bloco 2: SVG não abre ou o DXF chega com linhas soltas. Bloco 7: texto fora do contorno | Ver C10: SVG combinado, marcas de registro (`registration=true`), DXF ou PLT pelo Inkscape | Um passo a mais de preparo na apostila |
| C11 | Menos de 3 h na quarta 04/11 | Janela menor que 3 h (pendência do instrutor) | Blocos 1, 2, 4, 5 (só MDF, rodada 1) e 6; o encaixe (bloco 8) fica para outra janela e, sem ela, vale o `clearance` do kit pré-cortado | Sem teste de encaixe na máquina do evento |
| C12 | Vazão insuficiente | Bloco 9: capacidade menor que 1,3 vez a demanda | Lote único do instrutor; só corte, sem gravação; peças menores; turnos (metade modela, metade corta); kit de C3 como complemento | Uma peça por pessoa em vez de várias |
| C13 | Chiller esquenta ou alarme de fluxo | Bloco 2: água fora da faixa ou alarme. Blocos 5 e 9: temperatura subindo | Parar. Deixar em repouso. O responsável confere nível, bomba e fluxo. Retomar com a água na faixa e fazer pausas nos lotes | Pausas no cronograma de corte |

## Detalhes dos planos B

### C1: Controladora não é Ruida

| Controladora | Software provável | Formatos e observações |
| --- | --- | --- |
| Ruida (RDC644x) | LightBurn Pro (pago; a página LaserTypes da documentação pede a Pro para controladoras DSP) ou RDWorks (gratuito) | LightBurn importa SVG e DXF, entre outros. O manual do RDWorks V8 lista DXF, AI e PLT; SVG não consta (conferir na versão instalada) |
| Topwisdom (TL-A1, TL-A3) | LightBurn (a documentação lista TopWisdom entre as DSP) ou AutoLaser, do fabricante | É a controladora da ONE 6040 do instrutor. Formatos do AutoLaser: conferir; relatos de usuários citam arquivos de Illustrator e de AutoCAD |
| GRBL | LightBurn (licença G-code) ou LaserGRBL (gratuito, para Windows) | SVG e imagens. Conferir os recursos de camada no software instalado |
| M2 Nano (K40) | K40 Whisperer ou MeerK40t, os dois gratuitos e de código aberto | O K40 Whisperer decide corte ou gravação pela cor do traço: vermelho puro corta e azul puro grava em vetor (post "Vector Colors and Text", do autor). A área útil do K40 é pequena: ajuste `sheet_width` e `sheet_height` do lote |

O `svg/<modelo>-combinado.svg` já sai com traço vermelho puro (#FF0000, corte) e azul puro (#0000FF, gravação), as cores que o K40 Whisperer espera. Atenção: nesse programa só o traço conta, então a gravação sai como o contorno das letras, sem preenchimento. Para gravação cheia, use preenchimento preto: o programa deve tratar como raster (conferir na versão instalada). Receita para a camada de gravação em preto, sem traço:

```
sed 's/stroke="black" fill="lightgray"/stroke="none" fill="black"/' svg/chaveiro-tag-engrave.svg > chaveiro-tag-engrave-raster.svg
```

O MeerK40t é uma opção para M2 Nano e GRBL. Para Ruida não conte com ele: o suporte a controladoras Ruida é incerto (conferir no projeto).

Em qualquer controladora: refaça os blocos 5 (parâmetros), 6 (kerf), 7 (gravação) e 8 (encaixe) no software que existir. Os valores do LightBurn não valem para outro programa sem teste.

### C2: LightBurn sem licença

1. RDWorks, gratuito. Gere os arquivos com `bash exportar.sh` e use os DXF da pasta `dxf/`. Camadas por cor e função de compensação de kerf: conferir os nomes na versão instalada.
2. Teste gratuito do LightBurn. A página legada da documentação (TrialAndLicenseActivation) descreve um teste de 30 dias, ativado dentro do programa, com até 3 prorrogações de 15 dias. Conferir se continua valendo (pendência do instrutor). Se o plano depender dele, ative na quarta 04/11: 30 dias a partir daí cobrem o dia 07/11.
3. Preparar o trabalho no notebook do instrutor, com o LightBurn em teste, e levar o arquivo ao controlador por pendrive (a Ruida costuma aceitar arquivo pelo pendrive; conferir o formato no painel).
4. A licença do LightBurn é por tipo de controladora. Para Ruida, a página LaserTypes da documentação pede a LightBurn Pro (a que cobre controladoras DSP); a licença só de G-code não ativa Ruida (conferir o nome do plano na loja).

### C3: kit de peças pré-cortadas

A premissa que pesa: a chegada é na quarta 04/11 à tarde, véspera da abertura, com 3 h de laser: não há tempo de máquina para o kit em Nova Porteirinha. O kit é obrigatório e sai da laser do instrutor antes da viagem. Custo: algumas horas de máquina e o material.

Onde: na laser do instrutor (CO2 de 80 W, área de 600 x 400 mm), antes da viagem. Rode lá os mesmos testes (blocos 5, 6 e 8 de `ensaio-laser.md`) antes de cortar o kit. Assim as caixas saem com o encaixe conferido. Use MDF resinado da Meraki de 3 mm comprado antes da viagem, o mesmo tipo do estoque da FAVAG (mesma cor, se der para saber antes): o kit vira referência de parâmetros e de encaixe para a quarta.

**Kit prioritário (conforme `minicurso/materiais.md`, seção 6).** MDF de 3 mm cortado com os arquivos deste repositório:

| Peça | Quantidade | Comando (dentro de `laser/modelos/`) |
| --- | --- | --- |
| Chaveiros em branco, 70 x 25 mm, furo de 4,5 mm a 3,5 mm da borda, só a camada de corte | 24 | `bash exportar.sh -n kit-chaveiros -l cut -D 'labels=[""]' -D count=24 -D sheet_width=600 -D sheet_height=400 -D tag_width=70 -D hole_diameter=4.5 -D hole_margin=3.5 chaveiros-lote` |
| Caixas abertas, 80 x 60 x 40 mm, 5 painéis cada, com o nome de cada painel gravado | 10 | `bash exportar.sh -n kit-caixa caixa-finger-joint` |

- O lote usa a mesma tag de `chaveiro-tag.scad`: `tag_width` no lote é o `width` de lá. Os 24 chaveiros cabem em uma chapa de 600 x 400 mm.
- A caixa usa os valores padrão do modelo. Se a chapa medida não tiver 3 mm, acrescente `-D thickness=2.9`, trocando pelo valor medido.
- Cada arquivo de caixa tem uma caixa (210 x 105 mm na chapa). Duplique no software da laser até 10: cabem 6 por chapa de 600 x 400 mm (2 colunas, 3 linhas).
- Corte com o kerf offset calibrado. Monte uma caixa a seco antes de viajar.
- Sobram 2 caixas e 8 chaveiros sobre o necessário para 8 duplas.

**Opcional, se sobrar tempo de máquina antes da viagem** (o kit da seção 6 é o mínimo; as peças abaixo ampliam o plano B):

| Peça | Modelo | Quantidade | Comando de exemplo |
| --- | --- | --- | --- |
| Caixa pequena de teste de encaixe, 60 x 40 x 30 mm | `caixa-finger-joint.scad` | 1 a 2 | `bash exportar.sh -n kit-caixa-pequena -D length=60 -D width=40 -D height=30 caixa-finger-joint` |
| Tiras de dobradiça viva | `dobradica-viva.scad` | 1 por dupla | `bash exportar.sh -n kit-dobradica dobradica-viva` |
| Placas | `placa-gravacao.scad` | 1 por participante | `bash exportar.sh -n kit-placa placa-gravacao` |

Vagas e peças por participante dependem da organização (pendência do instrutor).

O que a turma faz sem laser:

- monta as caixas, mede o chaveiro, confere o encaixe e discute o efeito de `thickness` e `clearance`;
- dobra a tira de dobradiça viva, se estiver no kit, e compara com os parâmetros do modelo;
- personaliza chaveiros e placas à mão;
- segue a parte digital inteira: gerar o código com o LLM, ajustar parâmetros no OpenSCAD e exportar o SVG;
- vê o corte em vídeo curto gravado na laser do instrutor (grave junto com o kit).

### C4: sem internet

Leve no pendrive:

- os prompts da apostila e a resposta do LLM de cada exercício (texto salvo), para colar no OpenSCAD;
- os `.scad` dos modelos e os SVGs pré-exportados;
- o OpenSCAD instalável.

A turma edita os parâmetros do topo do arquivo, com o painel Customizer do OpenSCAD (no 2021.01, menu Window, item Hide Customizer, que mostra ou esconde o painel; conferir na versão instalada) ou no código. O instrutor faz a demonstração ao vivo com o celular como roteador.

### C5: computadores sem OpenSCAD

1. Instalar o OpenSCAD 2021.01 do pendrive, se o laboratório permitir.
2. Sem instalar, rodar a versão ZIP portátil do pendrive, se existir e se o computador deixar executar programa do pendrive (conferir no site do OpenSCAD e no laboratório).
3. Sem nada disso, usar os notebooks dos participantes ou o do instrutor.
4. O instrutor exporta as variações que a turma pedir: `bash exportar.sh -n NOME -D parametro=valor MODELO`.

### C6: exaustão fraca

- Só MDF. Nada de acrílico nem de couro.
- Cortes curtos, com pausa para a fumaça sair. Portas e janelas abertas.
- Pare se a fumaça sair para a sala, se arderem os olhos ou se o cheiro ficar forte.
- Prefira peças pequenas. Gravar área grande queima mais material e gera mais fumaça.

### C7: material diferente do previsto

1. Medir a espessura em 3 pontos e anotar a média.
2. Conferir que o material não está na lista de proibidos (bloco 1 de `ensaio-laser.md`).
3. Refazer a rodada 1 do bloco 5, depois o kerf (bloco 6) e o encaixe (bloco 8) com `thickness` igual à espessura medida.
4. Se o material for mais grosso (por exemplo 6 mm), espere velocidade menor ou 2 passes, e `finger_width` maior (2 a 3 vezes a espessura).
5. Atualizar a tabela "parâmetros adotados" do `resultados.md` e a apostila.

### C8: espelhos desalinhados

- Não ajuste sem o responsável.
- Anote o canto em que a mancha sai do centro e use só a região segura (em cm a partir da origem).
- Nos lotes, reduza `sheet_width` e `sheet_height` para caber na região segura.
- Se o responsável ajustar, refaça o bloco 3 inteiro.

### C9: foco ou kerf instável

- Causas comuns: lente suja ou ao contrário, mesa desnivelada, chapa empenada, feixe fora do centro.
- Meça o kerf só depois de o foco repetir (bloco 4).
- Se não resolver: use `clearance` maior (0,15 a 0,2) e prefira chaveiro e placa, que não dependem de encaixe justo.

### C10: importação falha ou camadas desalinhadas

O OpenSCAD 2021.01 grava, em cada SVG, uma caixa (viewBox) que acompanha a geometria do arquivo. O `exportar.sh` iguala a caixa de todas as camadas de um modelo, mas o software da laser pode ignorar a caixa e posicionar cada arquivo por conta própria. Não está confirmado como o LightBurn ou o RDWorks se comportam (pendência do instrutor). Tente nesta ordem:

1. `svg/<modelo>-combinado.svg`: um arquivo só, com corte em vermelho (#FF0000) e gravação em azul (#0000FF). O LightBurn separa as camadas por cor na importação (conferir na versão instalada). As duas camadas nascem alinhadas, porque estão no mesmo arquivo. Confira o registro (o texto cai dentro do contorno).
2. Se o software não separar por cor, ou se for preciso um arquivo por camada, exporte com marcas de registro: `bash exportar.sh -n NOME -D registration=true MODELO`. Cada camada ganha duas marcas de 0,6 mm, iguais nas duas e fora da peça. Importe os dois SVGs e sobreponha as marcas. Os DXF, que têm coordenadas absolutas, também servem (conferir).
3. DXF do OpenSCAD. Ele sai como segmentos de reta soltos (entidades LINE), não como polilinhas. O Inkscape 1.2.2 também exporta DXF como LINE (testado). Se o software não juntar os segmentos, as formas chegam abertas e o corte para e anda a cada segmento. Selecione o contorno e veja se é um objeto só. No LightBurn há função de juntar formas (conferir o nome). Relatos de usuários do RDWorks citam falha de importação de DXF com vetores abertos.
4. PLT (HPGL) pelo Inkscape, para o RDWorks (o manual do V8 lista PLT): abra o SVG, Salvar como, HPGL. Atenção: o Inkscape 1.2.2 traz opções de plotadora de vinil ligadas por padrão e elas desfiguram o desenho para laser. Em teste, a saída padrão traz uma linha extra na origem (Precut). Desmarque "Precut", ponha 0 em "Overcut (mm)" e em "Tool (Knife) offset correction (mm)" e reduza "Curve flatness" (padrão 1,2; menor é mais fino). Confira os nomes na sua versão e abra o resultado antes de cortar.
5. Se o SVG chegar em uma forma só (todos os quadrados da grade juntos), separe antes de atribuir camadas (LightBurn: Arrange, Break Apart; Inkscape: Caminho, Separar; conferir).

### C11: menos de 3 h na quarta 04/11

Rode só os blocos 1, 2, 4, 5 (só MDF, rodada 1) e 6 de `ensaio-laser.md`; o encaixe (bloco 8) fica para outra janela em 05 ou 06/11 e, sem ela, vale o `clearance` do kit pré-cortado. O caminho curto completo deixa sem teste o acrílico, o couro, a gravação, a vazão e o tempo da caixa; o registro das camadas é conferido na importação do bloco 2. Use o tempo de corte estimado pelo software para dimensionar a fila.

### C12: vazão insuficiente

- Lote único do instrutor: os participantes mandam o nome, o instrutor monta a lista em `chaveiros-lote.scad` e corta tudo em uma chapa por rodada.
- Só corte, sem gravação do nome (caneta no lugar). A gravação costuma ser a parte mais lenta.
- Peças menores e com menos contornos.
- Turnos: metade da turma modela enquanto a outra metade espera o corte.
- Kit pré-cortado de C3 como complemento.

### C13: chiller

- Parar a laser. Não dispare com alarme de fluxo.
- O responsável confere nível, bomba e circulação.
- Retome com a água na faixa do tubo (bloco 2).
- Nos lotes longos, anote a temperatura no início e no fim de cada chapa e faça pausas.

## Offset de kerf no Inkscape

Use quando o software da laser não tem offset de kerf (conferir) ou quando você prefere fazer a compensação antes. O kerf continua fora do `.scad`. Esta receita não foi testada na interface: esta máquina só tem o Inkscape pela linha de comando. Os nomes de menu em português vêm do catálogo de tradução do Inkscape 1.2.2; confira no menu.

1. Abra `svg/<modelo>-cut.svg` no Inkscape e selecione todos os contornos de corte.
2. Caminho, Deslocamento dinâmico (Dynamic Offset). No Inkscape 1.2 em português o item se chama "Expansão/Compressão Dinâmica". O "Deslocamento vinculado" (Linked Offset) é "Expansão/Compressão Vinculada".
3. Dê o valor numérico do deslocamento: abra o Editor XML (Ctrl+Shift+X), escolha o objeto de deslocamento e digite no atributo `inkscape:radius` o valor `kerf / 2`, em mm (positivo aumenta a peça e diminui os furos). O SVG do OpenSCAD tem 1 unidade igual a 1 mm, então o número vai direto.
4. Caminho, Converter em Caminho (Object to Path), para fixar a forma.
5. Salve com o valor no nome do arquivo, por exemplo `chaveiro-tag-cut-kerf0.10.svg` para um kerf de 0,20 mm.
6. No software da laser, deixe o kerf offset em zero para este arquivo. Se ficar ligado, a compensação se repete.
7. Feche o ciclo como no bloco 6: corte o quadrado de 20 mm já compensado e meça. Deve dar 20,00 mm, com erro de até 0,05.

Alternativa: Preferências, Comportamento, Passos, campo "Comprimir/expandir por" (Inset/Outset by) igual a `kerf / 2` em mm, e depois Caminho, Expandir (Outset) com tudo selecionado.

## Para levar nos planos B

| Item | Serve para |
| --- | --- |
| Pendrive com `laser/` (modelos, `svg/`, `dxf/`) | C1, C2, C4, C5, C10 |
| Instalador do OpenSCAD 2021.01 e, se existir, a versão ZIP portátil | C5 |
| Prompts da apostila e respostas do LLM salvas em texto | C4 |
| Kit pré-cortado e vídeo do corte na laser do instrutor | C3 |
| Notebook do instrutor com OpenSCAD, Inkscape e, se possível, LightBurn em teste | C1, C2, C5 |
| Celular com dados móveis (roteador) | C4 |
| Paquímetro, fita crepe, trena | todos |

## Fontes consultadas

Consulta por busca na web em 13/10/2026. São a base das afirmações marcadas como verificadas nestes documentos. Tudo que está escrito "conferir" continua sem confirmação na máquina.

| Assunto | Fonte |
| --- | --- |
| LightBurn: campo Kerf Offset, sentido, só formas fechadas, modo Line | https://docs.lightburnsoftware.com/2.0/Reference/CutSettingsEditor/LineMode/ |
| LightBurn: teste de kerf com escala vernier e uso do resultado como offset | https://docs.lightburnsoftware.com/2.0/Guides/Test-KerfOffset/ |
| LightBurn: gerador Material Test no menu Laser Tools | https://docs.lightburnsoftware.com/2.0/Reference/MaterialTest |
| LightBurn: teste de 30 dias, ativação no programa e prorrogações (página legada da documentação) | https://docs.lightburnsoftware.com/TrialAndLicenseActivation |
| LightBurn: tipos de licença por controladora (DSP: Ruida, Trocen, TopWisdom) | https://docs.lightburnsoftware.com/2.0/Explainers/LaserTypes/ |
| LightBurn: opção de cortar formas internas primeiro | https://docs.lightburnsoftware.com/2.0/Reference/OptimizationSettings/ |
| RDWorks V8: formatos de importação (DXF, AI, PLT, DST, DSB) | https://cdn.thunderlaser.com/download/down/Thunder%20Laser%20Software%20RDWorksV8.0%20USER%20MANUAL.pdf |
| K40 Whisperer: cores do traço (vermelho corta, azul grava em vetor) | https://scorchworks.com/Blog/?p=894 |
| MeerK40t: controladoras suportadas | https://github.com/meerk40t/meerk40t |
| Teste de espelhos com fita e pulso curto | https://help.omtechlaser.com/hc/en-us/articles/32755275789081-Laser-Engraver-Mirror-Alignment-How-to-Align-a-CO2-Laser-Beam |
| Teste de foco em rampa (potência e velocidade de partida) | https://omtechlaser.com/blogs/knowledge/ramp-tests-for-laser-engravers e https://fslaser.com/support/design-issues-tricks-tips/co2-focus-ramp-test |
| Materiais que não se corta (PVC, policarbonato, ABS, couro ao cromo, entre outros) | https://snapmaker.com/blog/materials-cannot-be-laser-cut e https://fixme.ch/w/images/9/90/Never_cut_list.pdf |
| OpenSCAD: página de downloads (conferir se há ZIP portátil) | https://openscad.org/downloads |

Testado nesta máquina (Inkscape 1.2.2 e OpenSCAD 2021.01): o DXF dos dois programas sai como segmentos LINE; a saída HPGL do Inkscape traz "Precut", "Overcut" e "Tool (Knife) offset correction" ligados por padrão.
