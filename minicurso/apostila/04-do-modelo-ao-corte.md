# Capítulo 4. Do modelo ao corte

Apostila do minicurso "Modelagem 3D com IA generativa para corte a laser".

Este capítulo leva o arquivo `.scad` até a peça cortada. Os nomes de menus e botões abaixo vêm da documentação dos programas (LightBurn e manual do RDWorks V8, em inglês). **A versão e o idioma do laboratório podem mudar os nomes.** Onde a dúvida é real, está escrito "conferir". As fontes estão no fim do capítulo.

## O caminho dos arquivos

```
peca.scad  --F6-->  d03-chaveiro-a-cut.svg       --\
                    d03-chaveiro-a-engrave.svg   ---+--> software da laser (uma camada por arquivo) --> máquina
```

**Nome dos arquivos na aula:** `dNN-peca-cut.svg` e `dNN-peca-engrave.svg`, em que NN é o número da sua dupla (`d03`) e `peca` é `chaveiro-a`, `chaveiro-b`, `caixa` ou `livre`. Exemplos: `d03-chaveiro-a-cut.svg` e `d03-caixa-engrave.svg`. Sem acento, sem espaço.

## 1. OpenSCAD: renderizar e exportar

### Renderizar

Aperte **F6**. Leia o console: ele não pode ter `ERROR` nem `WARNING` (capítulo 2). Olhe a peça por cima (menu View, opção Top).

### Exportar o SVG, uma camada por vez

O OpenSCAD 2021.01 exporta SVG numa cor só. Por isso, para o código que o assistente escreve, cada camada vira um arquivo. Nos arquivos de apoio do repositório, o script `exportar.sh` também junta as duas camadas num SVG **combinado**, com o corte em vermelho e a gravação em azul. Esse é o arquivo principal para o LightBurn, que separa as camadas por cor (conferir na versão instalada).

**Método do editor (use este na aula):**

1. No topo do arquivo, confirme `layer = "cut";`. Aperte F6.
2. Menu File, Export, **Export as SVG...**. Salve como `d03-chaveiro-a-cut.svg`.
3. Mude a linha para `layer = "engrave";`. Aperte F6.
4. File, Export, Export as SVG... Salve como `d03-chaveiro-a-engrave.svg`.
5. Volte a linha para `layer = "cut";` e salve o `.scad` (Ctrl+S).

**Painel Customizer (opcional):** no menu Window, desmarque "Hide customizer" (o recurso exige a versão 2019.05 ou mais nova). A variável `layer` aparece como uma lista com `cut` e `engrave`; escolha, aperte F6 e exporte.

**Linha de comando (para o instrutor e para quem já usa terminal):**

```bash
openscad -D 'layer="cut"'     -o d03-chaveiro-a-cut.svg     chaveiro.scad
openscad -D 'layer="engrave"' -o d03-chaveiro-a-engrave.svg chaveiro.scad
```

A opção `-D` troca o valor de uma variável sem editar o arquivo. No Windows as aspas mudam e erram com facilidade; use o método do editor.

**Com o mcp-openscad (demonstração do instrutor):** a ferramenta `export_svg` recebe o código e as variáveis, por exemplo `{"layer": "cut"}` e depois `{"layer": "engrave"}`.

### E o DXF?

**DXF** é outro formato de desenho técnico. Em File, Export, **Export as DXF...** o OpenSCAD gera um DXF a partir da mesma geometria 2D, também uma vez por camada. Use quando o software da laser **não abre SVG** (é o caso a conferir no RDWorks).

O DXF do OpenSCAD 2021.01 tem quatro particularidades:

- cada segmento do contorno é uma **linha solta**, não uma figura fechada: o software precisa unir as linhas;
- o arquivo **não declara a unidade**: confira a escala depois de importar;
- tudo fica numa camada só ("0");
- as coordenadas são **absolutas**: a peça fica onde o `.scad` a desenhou, então os DXF das duas camadas **devem alinhar** mesmo sem marcas de registro. Confira na prévia do software.

### Conferir os arquivos exportados

Abra os dois `.svg` no Bloco de Notas. A terceira linha dos dois arquivos deve ser **igual**, por causa das marcas de registro. Para o chaveiro:

```
<svg width="78mm" height="33mm" viewBox="-4 -29 78 33" xmlns="http://www.w3.org/2000/svg" version="1.1">
```

- `width` e `height` estão em milímetros, arredondados para cima. Aqui: 70 x 25 mm de peça mais as marcas.
- Os números negativos do `viewBox` são normais: o eixo vertical do SVG é de cima para baixo.
- Se as duas linhas forem diferentes, as marcas de registro faltam em um dos arquivos. Veja o capítulo 2. Os modelos de apoio do repositório vêm com `registration = false` (sem marcas). Para eles, use os SVG e DXF já exportados do repositório, com o quadro igualado, e o SVG combinado (capítulo 3, "Arquivos de apoio"); se for exportar pela interface, mude `registration` para `true` antes. Nos dois casos, as camadas devem alinhar: confira as marcas na prévia do software.
- No Inkscape, o desenho aparece com preenchimento cinza e contorno grosso. É só aparência: o software da laser usa as linhas de contorno.

## 2. Inkscape, só quando necessário

O **Inkscape** é um programa gratuito de desenho vetorial. Na aula ele **não faz parte do caminho normal**. Use em três casos:

1. **Ver o SVG e conferir a escala.** Menu File, Document Properties (unidade em mm).
2. **Corrigir a escala** de um desenho que entrou errado: selecione tudo e use a janela de transformação (menu Object, Transform) para multiplicar pelo fator da seção 7.
3. **Converter o formato** quando o software da laser não abre SVG. Cuidado: num teste com o Inkscape 1.2.2 (saída DXF R12, por linha de comando) e o `chaveiro-tag.scad` do repositório (60 x 25 mm, texto "EECri 2026"), o DXF gerado a partir de cada SVG do OpenSCAD saiu com o tamanho certo, mas **deslocado na vertical** pela altura do quadro daquele arquivo: 25 mm no arquivo de corte e 7 mm no de gravação. As duas camadas ficaram 18 mm fora de lugar. Com os SVG de quadro igualado da pasta `svg/`, as duas camadas sobem o mesmo tanto (25 mm) e ficam alinhadas entre si, mas a peça sai deslocada da origem. **Prefira o DXF direto do OpenSCAD** e sempre confira a posição e a medida depois.

Em outros programas de corte, o Inkscape serve para **trocar a cor do traço**. Exemplo: o K40 Whisperer trata traço vermelho como corte e traço azul como gravação de linha, e trata preto como gravação por varredura. O SVG do OpenSCAD é preto: o arquivo de corte precisa de traço vermelho e sem preenchimento (menu Object, Fill and Stroke).

## 3. LightBurn (pago, com teste gratuito)

O **LightBurn** é um programa pago de preparação de corte e gravação. Ele conversa com a **controladora**, que é a placa eletrônica da máquina: ela comanda os motores e liga o laser. Controladoras do tipo **DSP** (placas com processador próprio, comuns em máquinas CO2, como a Ruida) pedem a licença **LightBurn Pro** (a que cobre DSP; confira o nome e o preço no site do fabricante e se a licença do laboratório é esta). Há um **teste gratuito de 30 dias** (confira as condições atuais no site do fabricante).

### Importar

1. Menu File, **Import** (Ctrl+I). Escolha primeiro o SVG de corte, depois o de gravação.
2. **Onde o arquivo cai:** por padrão o LightBurn centraliza cada arquivo importado na tela. Segundo o suporte do fabricante, segurar a tecla **Shift** ao importar usa a posição original do arquivo (conferir na sua versão). Se os dois SVG têm o mesmo quadro, eles devem cair no mesmo lugar nos dois casos; confira no passo 3.
3. **Confira o alinhamento na prévia:** as duas marcas de registro do arquivo de corte e as do arquivo de gravação devem coincidir. O nome tem de estar centralizado dentro do chaveiro. Se você importou o `-combinado.svg`, as duas camadas já vêm juntas, em duas cores (conferir na versão instalada).
4. **Confira a escala:** selecione só o chaveiro e olhe a largura e a altura (70 x 25 mm). Com as marcas, o conjunto inteiro mede cerca de 76,6 x 31,6 mm. Se der outra medida, veja a seção 7.

Se for importar DXF: selecione as linhas e use o menu Edit, **Auto-join selected shapes** (Alt+J) para formar figuras fechadas (a tolerância padrão é de 0,05 mm; conferir). O menu Edit também tem **Select open shapes**, que ajuda a achar o que ficou aberto (conferir os nomes na versão instalada).

### Camadas por cor

No LightBurn cada **camada** é uma cor da paleta (na parte de baixo da tela). Cada camada tem seus próprios ajustes.

1. Selecione as formas do SVG de corte e clique numa cor da paleta.
2. Selecione as formas do SVG de gravação e clique em **outra** cor.
3. **Convenção da turma:** gravação na cor azul, corte na cor vermelha. Se a sua paleta for diferente, escolha duas cores e mantenha a regra: **a camada de gravação fica acima da de corte** na lista.
4. Dê **duplo clique** na camada (janela *Cuts / Layers*) para abrir o *Cut Settings Editor*.

| | Camada de gravação | Camada de corte |
| --- | --- | --- |
| Mode | **Fill** (preenche as letras) | **Line** (percorre o contorno) |
| Speed | da folha de parâmetros, em mm/s | da folha de parâmetros, em mm/s |
| Power | da folha de parâmetros | da folha de parâmetros |
| Passes | 1 | 1 (veja o capítulo 1) |
| Intervalo | *Line Interval* da folha (valor pequeno, como 0,1 mm, grava mais escuro) | não se aplica |
| *Kerf Offset* | não se aplica | valor calibrado no teste de kerf |

**Cuidado com a unidade da velocidade:** confirme se o programa mostra mm/s ou mm/min. A diferença é de 60 vezes.

### Kerf Offset

O campo *Kerf Offset* fica no *Cut Settings Editor* das camadas em modo *Line*. Valor positivo expande o contorno; negativo encolhe. Só funciona em formas fechadas. O programa escreve "Inward" ou "Outward" ao lado do campo para mostrar a direção (conferir na versão instalada). A documentação do fabricante não deixa claro se o campo recebe o kerf inteiro ou a metade dele; por isso **o valor se calibra com o teste de kerf (capítulo 1)**, medindo o quadrado de 20 mm. Uma peça com fendas muito finas (como a dobradiça viva) não combina com o kerf offset: teste em retalho.

### Ordem de corte

O LightBurn executa as camadas de cima para baixo (a opção *Order by Layer* nas configurações de otimização, que em geral vem ligada; conferir). Deixe a **gravação em cima e o corte embaixo**. A opção *Cut inner shapes first* corta os furos antes do contorno externo (conferir se vem ligada).

### Posição, Frame e Start

- **Start From** define de onde o trabalho conta. **Absolute Coords**: a peça sai onde está na tela, e o canto de origem da tela é o canto de origem da máquina. **User Origin**: a origem é um ponto que você marca no painel da máquina. **Current Position**: o trabalho começa onde o cabeçote está. O quadro de 9 pontos (*Job Origin*) escolhe qual ponto do desenho fica na origem (ele só vale em User Origin e Current Position).
- *Cut Selected Graphics* manda para a máquina só o que está selecionado. É como o monitor corta uma dupla de cada vez.
- **Frame** percorre o contorno do trabalho para você ver se cabe na chapa. Confira com o monitor se, nesta máquina, o laser fica desligado durante o Frame.
- **Preview** mostra o caminho e o tempo estimado (conferir). Olhe antes de mandar.
- **Start** inicia o corte.

## 4. RDWorks (gratuito)

O **RDWorks** (versão V8, para Windows) é o programa gratuito da fabricante das controladoras Ruida. O manual é em inglês. Na aula, o monitor opera o RDWorks se o laboratório não tiver LightBurn.

### Importar

1. Menu File, **Import**. O manual lista DXF, AI, PLT, DST e DSB. **SVG não aparece na lista:** pode funcionar em algumas versões, mas confira antes. Se não abrir, **use o DXF do OpenSCAD**.
2. Antes de abrir o DXF, ligue as opções de importação **Auto-close curves** e **Combine lines** (juntam as linhas soltas em figuras fechadas). Depois da importação, o menu Handle, **Combine Curve** faz o mesmo (conferir os nomes na versão instalada; são os do manual V8).
3. Confira a escala (seção 7) e o alinhamento das marcas entre os dois arquivos.
4. Para juntar o par de arquivos de uma dupla, use o menu Edit, **Group**.

### Camadas por cor

1. Selecione as formas e clique numa cor da **Layer Bar** (a barra de camadas). Isso muda a camada das formas selecionadas.
2. Dê duplo clique na camada para abrir os parâmetros.

| | Camada de gravação | Camada de corte |
| --- | --- | --- |
| *Processing Mode* | **Scan** (gravação por varredura) | **Cut** |
| Speed | da folha de parâmetros (a unidade pode ser mm/s ou m/min; confira) | idem |
| Power (mínima e máxima) | da folha de parâmetros | da folha de parâmetros |
| *Interval (mm)* | 0,1 ou menos para camadas vetoriais, segundo o manual | não se aplica |
| *Is Output* | Yes | Yes |
| Compensação do corte | não se aplica | no botão avançado, ao lado do modo (veja abaixo) |

**Compensação do corte (kerf):** nos parâmetros avançados da camada de corte, o manual descreve *Enable sew compensation*, *Sew Direction* e *Sew width*. Ela só vale para figuras fechadas. Para manter o tamanho da **peça**, a direção é para fora; para manter o tamanho do **furo**, para dentro. Se o programa aceitar uma direção por camada, separe furos e contornos em camadas diferentes. Calibre com o teste do capítulo 1. O RDWorks também tem o menu Handle, **Offset poly**, que gera uma cópia paralela do contorno.

### Ordem, tempo e saída

- **Ordem:** menu Handle, **Path optimize**, opção "according to layer order". Suba a camada de gravação na lista com os botões Up e Down.
- **Preview:** menu Edit, **Preview**. Mostra o caminho, o tempo estimado e a distância.
- **Coordenadas absolutas:** no menu Config, System Setting, a caixa *Absolute Coordinates* faz o desenho sair onde está na tela, a partir da origem da máquina (conferir).
- **Go Scale** percorre o retângulo do trabalho sem cortar (é o *frame*). **Atenção:** **Cut Scale** *corta* o retângulo. Não os confunda.
- **Start** envia e executa. **Download** envia o arquivo à memória da controladora, para iniciar pelo painel da máquina. **Save To UFile** grava um arquivo RD para levar em pendrive.

## 5. O painel da Ruida: origem, frame e start

Controladoras Ruida têm teclas parecidas, mas **o nome e a posição variam por modelo. Confira no painel da máquina do laboratório.** O básico é sempre o mesmo:

1. Exaustão, ar assistido e água ligados. Chapa plana e presa na mesa.
2. **Mova o cabeçote** com as setas até o ponto de partida do trabalho (o canto da chapa ou da célula). Só é preciso se o software estiver em User Origin ou Current Position.
3. **Origem:** a tecla de origem (em geral escrita *Origin*) grava o ponto atual como origem do trabalho. Com *Absolute Coords* no software, a origem é o canto da máquina e não é preciso marcar.
4. **Arquivo:** se você usou *Download*, a tecla de arquivos (em geral *File*) abre a lista de trabalhos da controladora. Escolha o seu.
5. **Frame:** a tecla de frame faz o cabeçote percorrer o retângulo do trabalho. **Confira que o retângulo está dentro da chapa, dentro da sua célula e longe de peças já cortadas.**
6. **Start:** a tecla *Start/Pause* inicia o trabalho. A mesma tecla pausa. A tecla de parar (em geral *Stop/Reset*) interrompe.
7. **Tampa fechada, alguém olhando.** O botão de emergência fica ao alcance da mão do monitor.

**Qual é o canto de origem?** Em algumas máquinas a origem é o canto da frente à esquerda; em outras, o de trás à esquerda. Isso muda onde cada peça aparece na tela. O monitor confere antes da aula.

## 6. Corte em retalho: o teste antes da peça

Peça nova, material novo ou ajuste novo passam por um **retalho** do mesmo material e da mesma espessura.

1. Coloque o retalho na mesa, no mesmo ponto de foco.
2. Corte um conjunto pequeno: um quadrado de 20 mm, um furo de 10 mm e um pouco de texto, com os ajustes da folha.
3. Confira: o corte atravessa? O texto está legível? A borda está limpa?
4. **Meça** o quadrado e o furo com o paquímetro. Ajuste o kerf offset se a medida estiver fora (capítulo 1).
5. Só então corte a peça.

Para um encaixe novo (a caixa), corte antes **duas placas** que se encontram em um canto e teste o encaixe. Peças apertadas demais quebram o MDF: nunca force.

## 7. Escala errada ao importar

Depois de importar, compare a medida mostrada com a medida do desenho. Se não bater, calcule o fator **medido dividido pelo esperado**:

| Fator | Causa provável |
| --- | --- |
| 0,75 ou 1,33 | Confusão entre 72 e 96 dpi |
| 0,94 ou 1,07 | Confusão entre 90 e 96 dpi |
| 25,4 ou 0,039 | Polegada lida como milímetro (ou o contrário) |
| 3,78 ou 0,26 | Pixel a 96 dpi lido como milímetro (ou o contrário) |
| 2,83 ou 0,35 | Ponto a 72 dpi lido como milímetro (ou o contrário) |

**O que fazer:** o SVG do OpenSCAD já declara milímetros, então o problema costuma estar na configuração de importação do programa (resolução usada para arquivos sem unidade) ou num arquivo que passou por outro programa. Corrija a configuração e importe de novo; ou multiplique o desenho por 1/fator. **Sempre confirme com o paquímetro** na peça de teste.

## 8. Se a laser for outra

| Controladora ou software | O que muda |
| --- | --- |
| Ruida com LightBurn ou RDWorks | O que está neste capítulo |
| Topwisdom, com o AutoLaser | O AutoLaser tem plugin para o Inkscape (exige Inkscape 1.0 ou mais novo, no Windows) e importa formatos como DXF e PLT. Para o kerf, tem uma ferramenta de **deslocamento de forma** (interno, externo ou ambos) que gera uma cópia do contorno compensada. Origem: o manual descreve origem da máquina, origem do usuário e posição atual. Conferir o manual em português |
| GRBL (LaserGRBL, ou LightBurn com licença G-code) | **GRBL** é um programa livre que controla máquinas simples de laser e CNC; ele recebe **G-code**, a lista de comandos de movimento (ir para X e Y, ligar o laser). O LightBurn funciona como na seção 3. O LaserGRBL, em geral, aplica um único ajuste a cada arquivo importado (conferir). Como o seu modelo exporta **um arquivo por camada**, isso já está resolvido: rode o de gravação e depois o de corte, **sem tirar a chapa do lugar** |
| M2 Nano (K40 Whisperer) | A **M2 Nano** é a placa de lasers CO2 pequenos, como o K40; o K40 Whisperer é um programa livre que a controla. Ele lê a cor do traço: vermelho é corte, azul é gravação de linha, preto é gravação por varredura. Recolora o SVG no Inkscape (seção 2). No DXF, tudo entra como corte, a menos que a camada tenha "engrave" no nome |

Em qualquer software, valem as mesmas ideias: um arquivo por camada, origem conferida com *frame*, ajustes vindos do teste, kerf calibrado com paquímetro, teste em retalho.

## 9. Lista de verificação antes de apertar Start

O monitor confere com você. Ela também explica por que cada passo existe.

- [ ] Exaustão, ar assistido e água ligados.
- [ ] Material certo, plano e preso. Foco ajustado para a espessura.
- [ ] Gravação acima do corte na lista de camadas.
- [ ] Ajustes do material (da folha de parâmetros) e kerf offset conforme a calibração.
- [ ] Origem conferida; o *frame* não sai da chapa nem da célula.
- [ ] Tempo estimado coerente com o tamanho da peça.
- [ ] Alguém olhando a máquina do começo ao fim; extintor ao alcance; tampa fechada.

## Fontes consultadas

Consulta por busca na web em 13/10/2026. Os nomes de menus mudam com a versão do programa; onde o capítulo escreve "conferir", a conferência é na máquina do laboratório.

| Assunto | Fonte |
| --- | --- |
| LightBurn: campo Kerf Offset, sentido, só formas fechadas, modo Line | https://docs.lightburnsoftware.com/2.0/Reference/CutSettingsEditor/LineMode/ |
| LightBurn: teste de kerf e uso do resultado como offset | https://docs.lightburnsoftware.com/2.0/Guides/Test-KerfOffset/ |
| LightBurn: gerador Material Test, no menu Laser Tools | https://docs.lightburnsoftware.com/2.0/Reference/MaterialTest |
| LightBurn: teste de 30 dias e ativação | https://docs.lightburnsoftware.com/TrialAndLicenseActivation |
| LightBurn: tipos de licença por controladora (DSP: Ruida, Trocen, TopWisdom) | https://docs.lightburnsoftware.com/2.0/Explainers/LaserTypes/ |
| LightBurn: cortar formas internas primeiro e ordem de corte | https://docs.lightburnsoftware.com/2.0/Reference/OptimizationSettings/ |
| LightBurn: Auto-join selected shapes | https://docs.lightburnsoftware.com/2.1/Reference/AutoJoinSelectedShapes/ |
| LightBurn: coordenadas e origem | https://docs.lightburnsoftware.com/2.1/Reference/CoordinatesOrigin/ |
| RDWorks V8: manual (importação, camadas, compensação, preview) | https://cdn.thunderlaser.com/download/down/Thunder%20Laser%20Software%20RDWorksV8.0%20USER%20MANUAL.pdf |
| K40 Whisperer: cores do traço | https://scorchworks.com/Blog/?p=894 |
| MeerK40t: alternativa livre para placas M2 Nano | https://github.com/meerk40t/meerk40t |
| OpenSCAD: painel Customizer | https://files.openscad.org/documentation/manual/Customizer.html |
| Materiais que não se corta | https://snapmaker.com/blog/materials-cannot-be-laser-cut e https://fixme.ch/w/images/9/90/Never_cut_list.pdf |

---

Capítulo anterior: [03-prompts.md](03-prompts.md)
Próximo capítulo: [05-exercicios.md](05-exercicios.md)
