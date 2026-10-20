# Roteiro do instrutor

Minicurso "Modelagem 3D com IA generativa para corte a laser". I EECri 2026, 07/11/2026, FAVAG.

Este roteiro é minuto a minuto. **0:00 é o início da aula.** As falas entre aspas são sugestões: use as suas palavras. Os blocos e os horários são os do `plano-de-aula.md`; os textos das atividades estão na apostila (`apostila/`).

## 1. Antes da aula

### Quarta 04/11 à tarde, na laser do evento (caminho curto de 3 h)

O plano completo do ensaio está em `laser/ensaio-laser.md`. A janela na laser, no dia da chegada, é de cerca de 3 h, pelo caminho curto (blocos 1, 2, 3 reduzido, 4, 5 só MDF rodada 1, 6, 8 e 10). Para o minicurso, estes resultados são obrigatórios:

**No caminho curto (obrigatórios)**

- modelo da laser, controladora, software instalado, área útil da mesa e **canto de origem**;
- exaustão, refrigeração e ar assistido funcionando; **extintor** ao lado e botão de emergência testado;
- teste de potência x velocidade (`teste-potencia-velocidade.scad`) só em MDF de 3 mm (corte e gravação), e a **folha de parâmetros** do laboratório (uma folha só, para imprimir);
- teste de kerf (`teste-kerf.scad`) em MDF: anotar o kerf e **calibrar o kerf offset** do software;
- **importar o `-combinado.svg`** de um modelo (corte e gravação em duas cores, o arquivo principal para o LightBurn) **e o par de SVG por camada** (`layer` igual a `cut` e a `engrave`) no software da laser (5 min, bloco 2); ver se a escala sai certa e, na prévia, se as marcas de registro coincidem; no RDWorks, ver se o SVG abre;
- cortar 10 quadrados de 20 mm **sem compensação** (para medir; saem no bloco 6);
- o cupom de encaixe (a caixa pequena de teste, 60 x 40 x 30 mm, do arquivo pronto; é o bloco 8 do caminho curto);
- conferir na máquina o **arquivo-modelo da turma** (canto de origem e escala), montado antes de viajar.

**Só se houver outra janela em 05 ou 06/11** (sem ela, a fila usa os valores de planejamento e as camadas são conferidas na prévia do software)

- teste em acrílico de 3 mm e em couro, e a gravação (bloco 7);
- **cronometrar**, com corte e gravação em separado, o lote de chaveiros (bloco 9 do ensaio, com `-D tag_width=70 -D font_size=8 -D hole_diameter=4.5 -D hole_margin=3.5`, que é o chaveiro da aula) e a caixa aberta de 80 x 60 x 40 mm do arquivo pronto: o tempo de cada fase dividido pelo número de chaveiros dá o **t1** de referência da regra de decisão da fila (`plano-de-aula.md`, seção 6.5). A caixa com tampa do Prompt 2 tem 1.512 mm de contorno de corte contra 1.376 mm da caixa do arquivo pronto: multiplique o tempo de corte da caixa por 1,10. O bloco 8 do caminho curto só corta a caixa pequena de encaixe; a caixa de 80 x 60 x 40 mm cronometrada fica para esta janela e, sem ela, vale o valor de planejamento de 3,6 minutos;
- a peça de demonstração.

**Sem a máquina (notebook e celular)**

- montar o **arquivo-modelo da turma** (camadas de gravação e de corte; 8 células de 300 x 200 mm numeradas, numa camada sem saída) no notebook do instrutor antes de viajar, com uma cópia no pendrive;
- rodar o Bloco base e os prompts 1 a 5 no assistente de IA que a turma vai usar (por exemplo, o plano gratuito do claude.ai), exportar as duas camadas e conferir com os mesmos critérios (seção 4);
- testar o sinal de celular e o hotspot na FAVAG.

### No dia, antes dos participantes

| Quando | Quem | O que |
| --- | --- | --- |
| 90 min antes | Monitor | Liga exaustão, refrigeração e ar. Confere nível e temperatura da água, extintor e botão de emergência. Limpa lente e espelhos, se precisar |
| 75 min antes | Monitor | Prende a **chapa da turma** (duas chapas de MDF 3 mm de 600 x 400 mm lado a lado) na referência do canto de origem e deixa a chapa de reserva ao lado. Ajusta o foco. Faz um teste de foco em retalho |
| 75 min antes | Monitor | Computador da laser: LightBurn ou RDWorks aberto com o arquivo-modelo da turma, conexão com a máquina, valores da folha de parâmetros, kerf offset do ensaio |
| 60 min antes | Instrutor | Computadores das duplas: OpenSCAD abre; menu Help, Font List mostra Liberation Sans; Inkscape instalado; pasta da turma; o pendrive da fila copia e abre nos dois lados |
| 60 min antes | Instrutor | Notebook do projetor: Claude Code com `mcp-openscad` conectado. Pasta de demonstração com um `CLAUDE.md` que contém o Bloco base |
| 60 min antes | Instrutor | Rodar a demonstração inteira uma vez. Deixar prontos o vídeo gravado da demonstração, os PNG e os SVG de exemplo |
| 45 min antes | Instrutor | **Distribuição digital:** criar o grupo da turma (ou link e QR code) e deixar prontos para colar o Bloco base e os prompts. Texto impresso não se copia no celular |
| 45 min antes | Instrutor | Em cada mesa: apostila, cartão de conferência de fila, 2 retalhos de MDF, óculos e máscara. 1 paquímetro para cada 2 duplas. Saco com o número da dupla |
| 30 min antes | Instrutor | Quadro de fila (5 colunas, 8 fichas numeradas). Faixa no chão a cerca de 1 m da laser. Horários reais de fechamento escritos: lote 1 (1:40), lote 2 (3:00), lote 3 (3:25), fim dos cortes (3:45) |
| 20 min antes | Instrutor | Mesa de materiais: amostras de MDF, acrílico e couro; quadrados de 20 mm sem compensação; grade de teste cortada; folha de parâmetros; kit pré-cortado guardado |

## 2. Minuto a minuto

### Bloco 0 (0:00 a 0:15). Abertura, segurança e preparação

- **0:00 (2 min) Boas-vindas.** "Hoje vocês não vão aprender CAD. Vão aprender a descrever uma peça com números e a conferir o que o computador desenhou. No fim, cada dupla leva uma peça cortada e o arquivo que gerou essa peça." Diga o crédito, projetado ou falado: "Parceira do minicurso: Laser One, laser1.one." Não acrescente nada sobre os termos da parceria.
- **0:02 (2 min) O plano do dia.** No quadro, o caminho em seis passos (descrever, gerar, rodar, exportar, importar, cortar) e as três peças (chaveiro, caixa, peça livre). "A laser é uma só. Por isso trabalhamos em duplas, numa chapa só, em lotes. Enquanto uma dupla espera o corte, a outra modela."
- **0:04 (5 min) Briefing de segurança** (texto abaixo).
- **0:09 (1 min) Duplas e papéis.** Piloto no computador, navegador com o assistente. "Vocês trocam de papel a cada exercício."
- **0:10 (5 min) Checagem zero.** Cada dupla abre o OpenSCAD, confere a fonte (Help, Font List), entra no assistente de IA e cola o **Bloco base** (do grupo). Espere o "entendido" em todas as mesas. Quem não conseguir: plano B da seção 6, sem parar a turma.

**Briefing de segurança (texto para falar):**

> "Antes de qualquer coisa, segurança. São oito regras.
> Um. A laser é operada só por dois de nós: o monitor e eu. Vocês entregam o arquivo, nós cortamos. Ninguém abre a tampa com a máquina trabalhando.
> Dois. O feixe do laser CO2 é invisível. Por isso a tampa fecha antes de cada trabalho e ninguém mexe no intertravamento, que é o sensor que desliga o laser quando a tampa abre.
> Três. Todo corte pode pegar fogo: MDF, acrílico e couro queimam. A máquina nunca fica sozinha. Se virem chama, gritem e se afastem. O monitor para a máquina e usa o extintor, que está ali. O botão de emergência está ali.
> Quatro. A fumaça sai pela exaustão. Ela liga antes do primeiro corte e desliga depois do último. Se ela falhar, ninguém corta.
> Cinco. Na máquina só entra o material que o monitor entregou. PVC, vinil e couro sintético nunca. Se trouxeram material de casa, mostrem agora. Só entra se for identificado.
> Seis. Cabelo preso, nada pendurado perto da máquina, calçado fechado.
> Sete. Vejam a faixa no chão. Perto da máquina ficam só as duplas que o monitor chamar, no máximo duas por vez.
> Oito. Peça recém-cortada está quente e tem farpa. Lixa e cola, com óculos e máscara. E qualquer um pode gritar 'para!'. Quem tem asma, rinite forte ou sensibilidade ao cheiro de fumaça, me avise agora ou depois, em particular, e fique longe da saída de ar."

### Bloco 1 (0:15 a 0:35). A laser, os materiais e o kerf

- **0:15 (3 min) Como corta.** "É uma luz que vocês não veem. Um tubo de gás CO2 gera o feixe, espelhos levam até o cabeçote e uma lente concentra num ponto. Ali o material esquenta e vira fumaça. Para cortar, o feixe percorre o contorno. Para gravar, o cabeçote vai e volta varrendo a área. E tem três coisas que ajudam: exaustão, ar e água."
- **0:18 (4 min) Potência, velocidade, foco e passes.** "Mais potência e menos velocidade: mais energia em cada milímetro. Quem diz qual é a combinação certa não é a internet nem o assistente de IA: é o teste." Mostre a grade cortada no ensaio de 04/11 e a folha de parâmetros.
- **0:22 (5 min) Materiais.** Passe as amostras. "MDF: borda escura e fumaça de resina. Acrílico: borda brilhante e fogo na linha de corte. Couro: o melhor para gravar, cheiro forte." Mostre a lista do que não cortar (capítulo 1, seção 4). "Se ninguém sabe o que é o material, ele não entra na máquina."
- **0:27 (5 min) Kerf ao vivo.** Distribua os quadrados de 20 mm sem compensação e os paquímetros. "Quanto deu? Quem mediu 19,8?" Anote no quadro os valores. "A diferença é o kerf: a faixa que o feixe remove. Ele come metade de cada lado da linha."
- **0:32 (3 min) Onde compensar.** "Kerf é do processo: muda com a máquina, o material e a velocidade. Folga é do projeto: é o quanto eu quero que a fenda seja mais larga que o dedo. O kerf se compensa no software da laser. A folga fica no arquivo. Nunca misturamos."
- **Checagem 1 (0:33):** cada dupla anotou o kerf do quadrado.

### Bloco 2 (0:35 a 1:00). Demonstração ao vivo

Prompts e comandos exatos na seção 4.

**Parte A, caminho do instrutor (0:35 a 0:45).**

- **0:35 (1 min)** "Primeiro o bastidor. O mesmo pedido que vocês vão fazer, do jeito que eu faço: com um assistente que roda no terminal e tem ferramentas para controlar o OpenSCAD."
- **0:36 (3 min)** Pedir o chaveiro ao Claude Code. Deixe aparecer: o arquivo, `check_syntax`, `render_to_png`. Mostre a imagem ao lado.
- **0:39 (2 min)** "Agora mudo duas coisas em português: o nome e a largura." Nova imagem em segundos. "Isto é um arquivo paramétrico: o desenho é uma lista de números."
- **0:41 (2 min)** Exportar as duas camadas com `export_svg` (`layer` igual a `cut` e a `engrave`). Abrir um SVG no editor de texto e mostrar `width`, `height` e `viewBox`. Comparar os dois arquivos: a linha `viewBox` é a mesma, efeito das marcas de registro (confira isso no ensaio de 04/11, com o arquivo que o Claude Code gerar).
- **0:43 (2 min) Reserva de tempo da parte A.** Use para repetir uma etapa que travou ou responder uma pergunta.
- **0:45** "Esse é o meu caminho. Agora o de vocês."

**Parte B, caminho das duplas (0:45 a 1:00).**

- **0:45 (2 min)** No navegador, no assistente de IA: Bloco base já colado, **Prompt 1** com o nome de alguém da plateia. Mostre o código chegando e leia só o topo: os parâmetros.
- **0:47 (2 min)** Copiar, colar no OpenSCAD, F6, ler o console. "Console limpo antes de exportar."
- **0:49 (2 min) Erro de propósito.** Acrescente `cube(5);` **na primeira linha** do arquivo, F6, tente exportar: `Current top level object is not a 2D object.` "Esta é a mensagem número um. O topo precisa ser 2D." Remova e exporte. **Só a primeira linha provoca o erro.** Com o `cube(5);` no fim do arquivo, o OpenSCAD 2021.01 apenas avisa (`Mixing 2D and 3D objects is not supported`, `Ignoring 3D child object for 2D operation`) e exporta o SVG sem o cubo. Mostre os dois casos: "o aviso não impede a exportação, o erro impede. Por isso o console limpo."
- **0:51 (2 min)** Exportar as duas camadas: `d00-chaveiro-a-cut.svg` e `d00-chaveiro-a-engrave.svg`. "Um arquivo por camada."
- **0:53 (3 min)** Software da laser (projetado, com o monitor ao lado): importar os dois, atribuir camadas, **conferir o alinhamento** das marcas na prévia (as camadas devem alinhar) e a **escala** (70 x 25), ajustes do material, kerf offset, gravação em cima e corte embaixo, *frame*, *preview* com o tempo. **0:55:** o monitor inicia o corte.
- **0:56 (4 min)** Enquanto corta (cerca de 1 minuto): "Seis etapas: descrever, gerar, rodar, exportar, importar, cortar." Entregue o cartão. **1:00:** mostre a peça cortada. "É isto que vocês fazem agora."
- **Checagem 2 (1:00):** todos viram o erro de 3D na primeira linha, o aviso do cubo no fim do arquivo e a peça pronta.

### Bloco 3 (1:00 a 1:45). Exercício 1: chaveiro com nome

- **1:00 (5 min)** Cada dupla envia o Prompt 1. Circule para ver quem travou na colagem.
- **1:05 a 1:20** Circule. Procure, nesta ordem: **aspas curvas** (código vindo de Word ou de mensagem), **3D no topo**, **nome de variável diferente** (peça de 1 mm). Diga: "Tente primeiro, pergunte depois". Olhe os consoles, não o rosto das pessoas.
- **Checagem 3 (1:20):** conte quantas duplas já exportaram. Menos da metade: avise que o chaveiro B pode ficar para a janela ociosa.
- **1:20 a 1:35** Conferência de fila e exportação do chaveiro B. Lembre dos nomes dos arquivos e da pasta no pendrive da fila.
- **1:35** "Cinco minutos para fechar o lote 1."
- **1:40** Fecha o lote 1. **Checagem 4:** quantos arquivos? Dupla atrasada vai de carona na janela ociosa.
- **1:40 a 1:45** O monitor termina de montar o lote e inicia o corte às 1:45. Você confere as fichas.

### Intervalo (1:45 a 2:00)

O monitor fica na máquina (20 chaveiros, cerca de 17 minutos). Você separa as peças por dupla, confere os horários do quadro e come alguma coisa.

### Bloco 4 (2:00 a 2:15). Medir o lote 1

- **2:00 (1 min)** Entregue as peças. "Meçam o seu chaveiro: largura, altura e furo. Anotem na folha do exercício 1."
- **2:01 (4 min)** Medição. Colete os valores no quadro. "O chaveiro foi desenhado com 70 mm. Quanto deu? A diferença é o kerf. E o furo: ficou maior ou menor?" Compare com o quadrado de 20 mm do bloco 1. "Cortamos este lote sem compensação, de propósito, para vocês verem."
- **2:05 (5 min) Mini-aula: kerf contra folga.** "Se o kerf não for compensado no software, o dedo sai mais estreito e a fenda sai mais larga: a caixa fica frouxa. Compensamos o kerf no software. Mas um encaixe de MDF precisa de uma folga mínima para entrar à mão: essa folga é decisão de projeto, e no arquivo ela se chama `clearance`. Eu uso 0,1 mm como ponto de partida." Mostre a receita dos dedos do Prompt 2 e o `echo()` esperado.
- **2:05 em paralelo:** o monitor calcula o **t1** de cada fase (tempo de corte ÷ número de chaveiros e tempo de gravação ÷ número de chaveiros; os valores de planejamento são 25 s e 26 s) e aplica a **regra de decisão** (`plano-de-aula.md`, seção 6.5): vale o pior dos dois fatores. Se o ensaio de 04/11 cronometrou a caixa do arquivo pronto (1.376 mm de contorno; sem a medida, vale o valor de planejamento); a caixa com tampa do Prompt 2 tem 1.512 mm, então o tempo de corte dela é 1,10 vez o medido. Você anuncia o resultado: "vamos de caixa completa" ou "caixa aberta".
- **Checagem 5 (2:10):** a média da turma bate com o kerf do ensaio de 04/11 (até 0,05 mm)? Se não bater, o monitor investiga foco, chapa e unidade de velocidade antes do lote 2.
- **2:10 a 2:15** Cada dupla guarda o `.scad`, abre uma conversa nova e cola o Bloco base. O monitor corta o quadrado de calibração com o kerf offset e mede.

### Bloco 5 (2:15 a 3:00). Exercício 2: caixa com encaixe de dedos

- **2:15 (5 min)** As duplas medem a espessura real do MDF (3 pontos). Prompt 2 enviado.
- **2:20 a 2:45** Circule. Destaque, nesta ordem: **`n` ímpar** no console; **paridade trocada** entre paredes largas e estreitas; **3D "para visualizar"** no fim do arquivo (só aparece como aviso no console); **espessura errada**. "Pergunta de ouro: o echo mostrou n ímpar? A fenda é 0,1 mm maior que o dedo?" Quem errou duas vezes no mesmo ponto abre `caixa-finger-joint.scad` (o desenho é um pouco diferente: a base também tem dedos) e usa o Prompt 6.
- **2:35:** o monitor corta o **cupom de encaixe** (a caixa pequena de teste, 60 x 40 x 30 mm) com o kerf offset, monta à mão e testa o encaixe. Se apertar, ajusta o offset ou lixa; se afrouxar, o contrário. Avise: "Quando o cupom aprovar, a fila rolante começa."
- **Checagem 6 (2:45):** cupom aprovado e as primeiras caixas na fila.
- **2:45 a 3:00** Conferências de fila. **2:55:** "Cinco minutos para fechar o lote 2." **Checagem 7 (3:00):** fecha o lote 2; quem não fechou fica no kit pré-cortado.

### Bloco 6 (3:00 a 3:35). Exercício 3: peça livre

- **3:00 (5 min)** "Peça livre com orçamento de máquina: 100 x 60 mm, contorno de até 350 mm, gravação de até 6 centímetros quadrados, até 2 minutos." Cada dupla escreve a receita de sete itens no papel.
- **3:05 a 3:25** Circule e confira o **orçamento** de cada peça (item 6 do cartão). Peça acima do orçamento: simplificar ou ficar só no arquivo.
- **Checagem 8 (3:25):** fecha o lote 3. Quem não fechou fica com a peça só modelada.
- **3:25 a 3:35** Duplas finalizam arquivos e a ficha da peça. Você prepara a economia criativa.

### Bloco 7 (3:35 a 4:00). Montagem, entrega e encerramento

- **3:35 (10 min) Montagem.** Duplas encaixam a caixa a seco, depois colam com camada fina e prendem com fita. Retiram as peças com o monitor. Salvam a pasta `dNN` no pendrive: `.scad`, SVG e ficha da peça.
- **Checagem 9 (3:45):** fim dos cortes (hard stop). O que não foi cortado vai para depois da aula ou para o kit.
- **3:45 (7 min) Economia criativa** (apostila, capítulo 6). "Uma peça vira produto quando você sabe quanto custa. Material, máquina, mão de obra, insumos, perdas. A máquina e a mão de obra pesam mais que o material, neste exemplo inventado. E o arquivo paramétrico é o que faz o preparo de um pedido novo cair para trocar alguns números." Mostre a família de produtos e o lote de nomes.
- **3:52 (8 min) Fechamento.** Roda: "O que funcionou? O que errou? O que você faria com a laser?" Agradeça à organização e à **Laser One** (https://laser1.one), parceira do minicurso. Três perguntas de avaliação, em papel ou no grupo: o que foi mais útil, o que faltou, que peça você faria amanhã.
- **Monitor:** exaustão ligada por pelo menos 5 minutos depois do último corte; limpa a mesa; fecha o registro de tempos.

## 3. Falas-chave

- "Descrever uma peça com números é o trabalho de vocês. O desenho é do computador."
- "O assistente de IA erra com confiança. Confiem no console, na tela e no paquímetro, não no tom da resposta."
- "Console limpo antes de exportar."
- "Uma mudança por vez, com o nome do parâmetro."
- "Kerf é do processo, folga é do projeto. Kerf no software, folga no arquivo."
- "Peça nova ou material novo: teste em retalho."
- "Se ninguém sabe o que é o material, ele não entra na máquina."
- "Máquina parada com peça pronta na fila é desperdício. Máquina cortando peça que ninguém conferiu também."
- "Errou duas vezes no mesmo ponto? Pare de insistir e abra o arquivo pronto."
- "Piloto e navegador trocam a cada exercício."

## 4. Prompts e comandos da demonstração

**Pasta de demonstração** (`~/eecri-demo`, por exemplo) com um `CLAUDE.md` que contém o texto do **Bloco base** (apostila, capítulo 3) e uma subpasta `saida/`.

**Parte A, em português para o Claude Code:**

```text
Crie o arquivo chaveiro.scad seguindo as regras do CLAUDE.md desta pasta: chaveiro de 70 x 25 mm, cantos de 4 mm, furo de 4,5 mm a 3,5 mm da borda esquerda (da borda da peça até a borda do furo), texto "DONA MARIA" em tamanho 8 (o `size` do OpenSCAD). Valide a sintaxe com check_syntax e gere uma imagem com render_to_png usando layer igual a cut. Mostre a imagem.
```

```text
Troque o texto para "ALEXANDRE" e a largura para 80 mm. Gere a imagem de novo.
```

```text
Exporte os dois SVG com export_svg, um com layer igual a cut e outro com layer igual a engrave, em ~/eecri-demo/saida/, com os nomes d00-chaveiro-a-cut.svg e d00-chaveiro-a-engrave.svg.
```

As ferramentas citadas existem no `mcp-openscad` (`check_syntax`, `render_to_png`, `export_svg`, `export_dxf`). Os geradores prontos do `mcp-openscad` aceitam um parâmetro `kerf`; na demonstração, use só os arquivos do projeto, para manter o kerf em zero no desenho.

**Parte B, no navegador:** Bloco base (já colado) e Prompt 1 da apostila (capítulo 3), trocando `label` pelo nome de alguém da plateia. Se o nome tiver mais de 10 letras, use só o primeiro nome ou peça `width = 80` ao assistente.

**Validação dos prompts (teste cego, 13/10/2026).** Os prompts foram testados em 13/10/2026 com o Bloco base, em dois modelos de IA sem acesso a nenhum arquivo do projeto (Claude Haiku 5.5 e Claude Sonnet 5.5; uma resposta de primeira de cada, sem executar o código). Os arquivos gerados, as conversas enviadas e os scripts de conferência (`check.py` e `geom.py`) estão em `minicurso/testes-prompts/`; o `README.md` da pasta diz o que foi rodado e como repetir. **Rodada 1 (prompts 1 a 5, Haiku e Sonnet):** os 10 arquivos exportaram no OpenSCAD 2021.01 sem aviso e passaram nas conferências de medidas, furos, marcas de registro, quadro igual nas duas camadas, padrão de dedos complementar na caixa (com `clearance` igual a 0 o material soma exatamente a altura) e grade do lote. A conferência apontou dois problemas, já corrigidos nos prompts: o fator de largura do texto, que deixava nomes longos sair da peça (prompts 1 e 5; agora o tamanho final é a largura livre dividida pelo número de letras), e a moldura da placa, que tocava os furos (prompt 3). **Rodada 2 (prompts 1 a 5 corrigidos, Haiku):** passou em todas as conferências. **Rodada 3 (prompt 4):** o prompt foi reescrito para seguir o modelo `dobradica-viva.scad` do repositório (as fileiras ímpares abrem a borda; sem `corner_radius`); Haiku e Sonnet passaram em todas as conferências, e o SVG de cada um é idêntico ao do modelo do repositório com os mesmos valores. **Limites:** só dois modelos, só o primeiro rascunho, uma resposta por modelo e por prompt, sem o claude.ai nem outros assistentes; os prompts 6 e 7 (ajuste e diagnóstico) não entraram no teste. Repita o teste com o assistente que a turma for usar, na quarta 04/11.

## 5. Erros comuns e como destravar

| Sintoma | Causa provável | Como destravar (1 a 2 minutos) | Como evitar |
| --- | --- | --- | --- |
| Não exporta: `Current top level object is not a 2D object` | Há 3D **antes** do 2D no arquivo (um `cube` na primeira linha, por exemplo), ou a camada exportada não tem nada. Com o 3D **depois** do 2D, o OpenSCAD 2021.01 só avisa e exporta | Procurar `cube`, `cylinder`, `linear_extrude` e remover, mesmo no fim do arquivo (o aviso some). Se for só na camada `engrave`, ver se há texto ou desenho para aquela camada | Bloco base, regra 3. Peça ao assistente "sem 3D, nem para visualizar" |
| Peça de 1 mm, ou diferente do pedido | `WARNING: Ignoring unknown variable`: nome de parâmetro trocado ou fora de ordem | Ler o console; corrigir o nome (ou pedir o Prompt 7) | Console limpo antes de exportar |
| Texto sumiu ou saiu com outra letra | Fonte inexistente: o OpenSCAD troca em silêncio (ou o texto não cabe) | Menu Help, Font List; usar `Liberation Sans:style=Bold` | Bloco base, regra 8; checagem zero |
| Peça gigante ou minúscula (unidade) | O assistente usou cm ou polegada | Cabeçalho do SVG e `echo()`; pedir "refaça em milímetros" | Bloco base, regra 2 |
| Escala errada ao importar o SVG | Resolução de importação do software (72, 90 ou 96 dpi), unidade lida errada | Medir a largura conhecida; calcular o fator (apostila, capítulo 4, seção 7); corrigir a configuração ou escalar por 1/fator | Medir sempre depois de importar |
| Peças 0,2 mm menores e caixa frouxa | **Esqueceram o kerf no software** (offset desligado ou em outra camada) | O monitor liga o kerf offset na camada de corte, com o valor calibrado, e recorta. Não mexer na geometria | Item do cartão do monitor antes do lote 2; cupom de encaixe |
| Encaixe apertado | `clearance` pequeno, kerf offset grande demais ou com sinal trocado, espessura real maior que a do arquivo, borda queimada | Lixar de leve os dedos (nunca forçar). Medir a espessura; ajustar `clearance` em +0,05 mm; conferir o sinal do offset com o quadrado de 20 mm | Medir a espessura; cupom de encaixe |
| Encaixe frouxo | Kerf sem compensação, `clearance` grande, espessura real menor | Cola e fita; depois, kerf offset ou `clearance` menor | Idem |
| `Parser error: syntax error` | Aspas curvas (código passou por Word, Docs ou mensagem), `;` ou `)` faltando | Olhar a linha apontada **e a anterior**; trocar as aspas | Copiar com o botão "copiar"; nunca passar por Word |
| Nome fora de lugar dentro da peça | As duas camadas importadas em posições diferentes (quadro diferente) | Importar o `-combinado.svg`, que é uma importação só. Se vieram dois arquivos, conferir as marcas de registro na prévia. Nos modelos do repositório o padrão é `registration = false`: mude `registration` para `true` antes de exportar pela interface do OpenSCAD (ou use `-D registration=true`) e exporte de novo | Bloco base, regra 6; conferir as marcas na prévia |
| Gravação fraca ou ilegível | Letra pequena (menos de 5 mm), potência baixa, foco errado, intervalo grande | Letra maior ou fonte mais grossa; o monitor confere foco e ajustes da folha | Teste em retalho |
| O corte não atravessa | Potência baixa ou velocidade alta, foco errado, lente suja, chapa empenada | O monitor para; **não retira a peça** antes de um segundo passe, para não perder o alinhamento; confere foco e lente | Teste de potência x velocidade |
| DXF abre como linhas soltas | O DXF do OpenSCAD 2021.01 não tem figuras fechadas | LightBurn: Auto-join (Alt+J, tolerância de 0,05 mm; conferir na versão instalada, https://docs.lightburnsoftware.com/2.1/Reference/AutoJoinSelectedShapes/). RDWorks: opções *Auto-close curves* e *Combine lines*, ou Handle, *Combine Curve* (conferir no manual do RDWorks V8) | Preferir SVG sempre que o software abrir |
| Texto passando da peça | Nome longo | Reduzir `font_size` ou usar a regra `min(...)` do Prompt 1 | Prompt 1 já traz a regra |
| O assistente reescreve tudo ou ignora o Bloco base | Conversa longa, mudança vaga | Colar de novo o Bloco base e dizer "releia as regras 1 a 11"; usar o Prompt 6 com uma mudança só | Uma mudança por vez |
| Cota do assistente de IA esgotada | Plano gratuito com limite | Trocar de assistente (o Bloco base serve em qualquer um) ou usar a conta do outro integrante da dupla, se for maior de idade; usar o arquivo pronto | Contas criadas antes; dupla com dois assistentes |
| Dupla muito atrasada | Erros seguidos | Passar ao arquivo pronto (`chaveiro-tag.scad`, `caixa-finger-joint.scad`) e só trocar parâmetros. Os padrões do `chaveiro-tag.scad` são 60 x 25 mm, fonte 6, furo 4 e margem 3: para o chaveiro da aula, mude `width`, `font_size`, `hole_diameter` e `hole_margin` para 70, 8, 4,5 e 3,5 no Customizer (menu Window) ou com `-D` | Checagens 3 e 6 |

## 6. Plano B para cada dependência

| Dependência | Sintoma | Plano B | Decide e quando |
| --- | --- | --- | --- |
| Internet da sala | Assistente não abre; Claude Code sem rede | Hotspot do celular do instrutor (ou um roteador portátil, se ele levar um). Sem rede nenhuma: modo sem assistente, com os arquivos prontos do pendrive (`chaveiro-tag.scad`, `caixa-finger-joint.scad` e demais) e troca de parâmetros à mão (os padrões do arquivo pronto são 60 x 25 mm, fonte 6, furo 4 e margem 3; o chaveiro da aula usa 70, 8, 4,5 e 3,5). Demonstração: vídeo gravado e PNG e SVG prontos | Instrutor, na checagem 0 |
| Conta e limite do assistente | Participante sem conta, ou limite do plano gratuito | Uma conta por dupla, aberta pelo adulto titular: os termos de assistentes como o claude.ai exigem 18 anos, e dividir uma conta entre duplas costuma ser proibido (conferir os termos atuais). Quem tem menos de 18 anos trabalha com um adulto titular ou acompanha a demonstração na conta do instrutor. Sem conta ou sem limite: outro assistente equivalente. O Bloco base vale em qualquer um | Instrutor, na checagem 0 |
| Claude Code ou MCP na demonstração | Ferramenta não responde; imagem não aparece no terminal | Abrir o `.scad` no OpenSCAD e usar F5; mostrar os PNG e SVG prontos. A parte A pode ser encurtada | Instrutor, ao vivo |
| Projetor | Imagem não aparece, ou não troca entre notebook e computador da laser | Cabo HDMI longo ou comutador. Alternativa: abrir LightBurn ou RDWorks no notebook do instrutor (roda sem a máquina conectada) para mostrar importação e camadas; o monitor repete na laser | Instrutor, na preparação |
| Computadores | Menos que 8, sem OpenSCAD ou sem a fonte | Três pessoas por computador, ou notebooks dos participantes com o OpenSCAD do pendrive (instaladores para Windows, macOS e Linux). Sem fonte: usar outra da lista (Help, Font List) | Instrutor, na preparação |
| Laser indisponível | Máquina parada ou sem refrigeração | **Kit de peças pré-cortadas**: montar a caixa, medir o chaveiro, discutir o encaixe; seguir modelando e exportando os SVG para corte posterior. Se a máquina voltar, entra o lote que couber | Monitor e instrutor, na hora |
| Exaustão ou refrigeração falha | Sem fluxo de ar ou de água | **Para o corte.** Sem exaustão e sem refrigeração a laser não opera. Ficam as atividades de modelagem e o kit | Monitor, imediato |
| Software sem licença | Sem a licença LightBurn Pro (a que cobre DSP) | LightBurn em teste de 30 dias (conferir as condições no site, https://docs.lightburnsoftware.com/TrialAndLicenseActivation); ou RDWorks (gratuito) | Instrutor, em 04/11 |
| RDWorks não abre SVG | Erro ao importar | Exportar DXF no OpenSCAD (File, Export, Export as DXF) e usar as opções de união de linhas | Monitor, em 04/11 |
| Controladora diferente | Não é Ruida | `plano-de-aula.md`, seção 7; apostila, capítulo 4, seção 8 | Instrutor, em 04/11 |
| Material | Falta MDF, ou a espessura não é 3 mm | Medir a espessura e ajustar `thickness` (os modelos são paramétricos). Falta de MDF: reduzir a caixa a uma por dupla e cortar o resto do kit | Monitor, na preparação |
| Transferência de arquivos | Pendrive não lê | Grupo da turma, e-mail ou WhatsApp Web; segundo pendrive | Monitor |
| Sem celular nem notebook | Dupla sem aparelho | Dividir com outra dupla; ou modo sem assistente com os arquivos prontos | Instrutor, na checagem 0 |
| Falta de energia | Computadores e laser desligam | Parar; religar com o monitor; confirmar a posição da chapa (a origem pode se perder) antes de retomar | Monitor |

## 7. Depois da aula

- Fazer backup da pasta da turma e dos pendrives (`.scad`, SVG, fichas).
- Salvar o registro do monitor: tempos dos lotes, ajustes usados, kerf medido, peças reprovadas.
- Anotar na lista de pendências do instrutor o que se confirmou.
- Recalcular a regra de decisão e o cronograma com os tempos reais.
- Guardar as respostas de avaliação.

## 8. Se o monitor não vier (ou chegar atrasado)

A laser nunca é operada por quem não conhece a máquina, e o instrutor não deixa a turma sozinha. Se o monitor não estiver:

1. **Instrutor opera a laser só em janelas calmas.** Nas outras, ninguém corta e as duplas trabalham em tarefas sem dúvida.
2. **Corta-se menos:** só o lote 1 (um chaveiro por dupla) e a caixa aberta de metade das duplas. As outras montam o kit.
3. **Conferência de fila feita pela própria dupla:** ela confere com o cartão e o instrutor só abre os arquivos no computador da laser.
4. **Peça livre só modelada.**
5. Avisar a organização na checagem 0 que o formato mudou.
