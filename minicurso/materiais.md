# Lista de materiais

Minicurso "Modelagem 3D com IA generativa para corte a laser". Para **16 participantes em 8 duplas**, mais o instrutor e o monitor do laboratório.

**Sobre preços.** Nenhum preço consta aqui, porque nenhum tem fonte. Todo item comprado vem marcado **cotar** (o MDF já está na FAVAG), e a cotação é uma pendência do instrutor.

**Premissa de mesa.** A conta usa a hipótese de uma laser com mesa de 1400 x 900 mm. Os formatos de chapa abaixo são sugestões: o formato que o fornecedor tiver é o que vale, e a conta de área não muda.

## 1. MDF de 3 mm: a conta de área

A conta parte das peças dos exercícios (apostila, capítulo 5), com as medidas de referência. Em cada peça entra a **caixa envolvente** (o retângulo que a contém) mais o espaço entre peças. A área real das peças é um pouco menor, então a conta fica a favor da segurança.

| Peça | Medida usada | Área por peça (mm²) | Quantidade | Área (mm²) |
| --- | --- | --- | --- | --- |
| Chaveiro (exercício 1) | 70 x 25 mm, mais 3 mm de espaço: 73 x 28 | 2.044 | 20 (16 das duplas e 4 de reserva) | 40.880 |
| Caixa com tampa (exercício 2) | Desenho de 164 x 148 mm (6 placas, 4 mm de espaço) | 24.272 | 8 | 194.176 |
| Peça livre (exercício 3) | Até 100 x 60 mm, mais 3 mm: 103 x 63 | 6.489 | 8 | 51.912 |
| Peças de demonstração | Chaveiro | 2.044 | 4 | 8.176 |
| Testes e calibração | Quadrados de kerf, cupom de encaixe, teste de foco, grade de potência x velocidade | | | 50.000 |
| **Subtotal da aula** | | | | **345.144 (0,345 m²)** |

| Passo | Conta | Resultado |
| --- | --- | --- |
| Aproveitamento da chapa (bordas, referência, fixação, sobras que não servem): 75% | 0,345 ÷ 0,75 | 0,460 m² |
| Reserva para refazer peças: 30% | 0,460 x 1,30 | **0,598 m² para a aula** |

**Kit de peças pré-cortadas (seguro):** 24 chaveiros e 10 caixas abertas. A caixa é a do arquivo pronto `caixa-finger-joint.scad` (5 painéis; desenho de 210 x 105 mm com 5 mm de espaço, ou 22.050 mm²).

| Passo | Conta | Resultado |
| --- | --- | --- |
| Área das peças | 24 x 2.044 + 10 x 22.050 = 49.056 + 220.500 | 269.556 mm² (0,270 m²) |
| Aproveitamento de 75% | 0,270 ÷ 0,75 | 0,359 m² |
| Reserva de 20% | 0,359 x 1,20 | **0,431 m² para o kit** |

**Total de MDF de 3 mm: 0,598 + 0,431 = 1,029 m², cerca de 1,03 m².**

**Conversão em chapas.** A Meraki vende em 600 x 400 mm pelo site; confirmar o formato das chapas que estão na FAVAG.

| Formato | Área de cada | Chapas pela conta | Chapas a separar |
| --- | --- | --- | --- |
| **600 x 400 mm** | 0,24 m² | 4,3 | **6**: 3 para a aula, do estoque da FAVAG, e 3 para o kit, compradas e cortadas antes da viagem (uma de cada grupo é de seguro contra chapa empenada ou com defeito) |
| 1200 x 600 mm | 0,72 m² | 1,4 | 3 |

O formato de 600 x 400 mm é o preferido: cabe em qualquer mesa; **duas chapas lado a lado formam a "chapa da turma" de 1200 x 400 mm** (8 células de 300 x 200 mm, com a emenda entre as colunas 2 e 3), e a terceira fica ao lado da turma como chapa de reserva.

**Cuidados:** o MDF da turma é o **resinado** da Meraki (resina colorida; espera-se que a gravação exponha o miolo, com contraste a conferir no ensaio e dependente da cor); nada de MDF com revestimento de origem desconhecida; tudo do mesmo lote e da mesma cor; **meça a espessura real** com paquímetro ao receber (em três pontos) e anote; chapa empenada vai para a reserva. Peso aproximado: cerca de 2,25 kg por m² de MDF de 3 mm (densidade média de 750 kg/m³), então as 6 chapas de 600 x 400 mm (1,44 m²) pesam cerca de 3,2 kg.

## 2. Acrílico de 3 mm

Usos: peças de demonstração do instrutor na janela ociosa do calendário da máquina (2:05 a 2:40, `plano-de-aula.md`, seção 6.5), peça livre em acrílico para até 2 duplas, com autorização do instrutor, e testes. Não há lembranças em acrílico para a turma: nenhum horário do calendário da máquina as comporta.

| Passo | Conta | Resultado |
| --- | --- | --- |
| Chaveiros de demonstração | 3 x 2.044 | 6.132 mm² |
| Peça livre: até 2 duplas | 2 x 6.489 | 12.978 mm² |
| Testes | | 15.000 mm² |
| Soma | | 34.110 mm² |
| Aproveitamento de 75% e reserva de 30% | 34.110 ÷ 0,75 x 1,30 | 59.124 mm² (0,059 m²) |

**Compra sugerida: 0,075 m²**, uma chapa de 300 x 250 mm. Preferir acrílico **fundido** (*cast*), que costuma gravar com mais contraste; de cor **escura**, com película protetora. Peso aproximado: 0,27 kg (densidade média de 1.190 kg/m³).

## 3. Couro

Usos: peças de demonstração na janela ociosa (2:05 a 2:40) e testes. Não há lembranças em couro para a turma, pelo mesmo motivo do acrílico.

| Passo | Conta | Resultado |
| --- | --- | --- |
| Chaveiros de demonstração | 3 x 2.044 | 6.132 mm² |
| Testes | | 20.000 mm² |
| Soma | | 26.132 mm² |
| Aproveitamento de 75% e reserva de 30% | 26.132 ÷ 0,75 x 1,30 | 45.295 mm² (0,045 m²) |

**Compra sugerida: 0,05 m²**, um retalho de 250 x 200 mm. **Couro natural, curtido ao vegetal, de origem conhecida, sem acabamento plástico.** Anote a espessura do retalho. Nunca couro sintético.

## 4. Consumíveis e equipamentos

| Item | Quantidade | Conta ou uso | Preço |
| --- | --- | --- | --- |
| Argolas de chaveiro | 50 | 20 do lote, 24 do kit e 6 das demonstrações em acrílico e couro | cotar |
| Cola branca para madeira (PVA) | 1 frasco de 100 g | Cerca de 4 g por caixa; 8 caixas da aula (32 g) e reserva. O kit é montado a seco, sem cola | cotar |
| Cola instantânea em gel | 2 tubos | Fixação rápida; uso opcional, com luvas e óculos | cotar |
| Lixa de 220 e de 320 | 3 folhas de cada | Cortadas em quartos, para as duplas | cotar |
| Fita crepe | 4 rolos | Fixar a chapa e proteger a face do MDF; prender as caixas coladas | cotar |
| Óculos de proteção incolores, para laser CO2 (10.600 nm; ler a especificação no próprio óculos) | 20 | 16 participantes, instrutor, monitor e 2 de reserva; também cobrem o ensaio de 04/11 | cotar |
| Máscara PFF2 | 20 | Lixa e poeira | cotar |
| Luvas nitrílicas | 1 caixa | Cola e retirada de peças quentes | cotar |
| Pendrives | 12 | 8 das duplas, 2 da fila (um e o reserva), 1 de instaladores e modelos, 1 do instrutor. Copiar a pasta laser/modelos inteira: o chaveiros-lote.scad usa o chaveiro-tag.scad da mesma pasta | cotar |
| Apostila impressa | 18 cópias | 16 participantes, instrutor e monitor. Cerca de 45 páginas por cópia (estimativa; conferir depois da diagramação), frente e verso | cotar |
| Paquímetro digital | 5 | 1 para cada 2 duplas e 1 para o instrutor. Verificar antes se o laboratório já tem | cotar |
| Régua metálica e esquadro | 2 de cada | Conferência de peças | cotar |
| Marcadores permanentes | 4 | Plano B para nomes nos chaveiros | cotar |
| Sacos plásticos com fecho e etiquetas | 20 | 8 das duplas (um por dupla, com o número), 10 das caixas do kit (uma por saco) e 2 dos chaveiros do kit | cotar |
| Papel A4 para rascunho | 100 folhas | Receita de sete itens, anotações | cotar |
| Fichas do quadro de fila e cartões de conferência | 8 e 8 | Impressos ou escritos à mão; ímãs ou fita para o quadro | cotar |
| Estilete e tesoura | 2 de cada | Retirar a película do acrílico e cortar couro | cotar |
| Cabo HDMI longo ou comutador, filtro de linha e extensão | 1 de cada | Projetor e computador da laser | cotar |
| Roteador portátil 4G ou 5G (opcional, se o instrutor tiver) | 1 | Segunda conexão de internet | não se aplica |

Itens do **laboratório** (a confirmar): extintor adequado (CO2 ou ABC), exaustão, refrigeração, escova e pano para a mesa, computadores, projetor, quadro branco.

## 5. O que o instrutor leva e o que comprar na região

O critério: levar o que é **crítico para a qualidade ou de oferta incerta na região**, e comprar na região o que é **volumoso e corriqueiro**. Onde a disponibilidade local é desconhecida, o plano é levar.

| Item | Origem sugerida | Motivo |
| --- | --- | --- |
| Kit de peças pré-cortadas (24 chaveiros e 10 caixas abertas) | **Levar** (mala) | Peça de seguro: precisa estar pronta antes. Obrigatório: cortar na laser do instrutor, antes da viagem |
| MDF de 3 mm resinado (Meraki) | **Já na FAVAG** para a aula e o ensaio: chapas da Meraki (confirmado em 14/10/2026). Nada de MDF viaja. As 3 chapas do kit pré-cortado são compradas e cortadas antes da viagem. Conferir na quarta 04/11 quantidade, cor, formato e espessura real (pendência do instrutor) | O MDF é a base de tudo; as contas das seções 1 e 8 assumem 5 chapas de 600 x 400 mm na FAVAG e 3 compradas e cortadas antes da viagem |
| Acrílico de 3 mm, fundido | **Levar** | Tipo e espessura precisam ser conhecidos; a oferta local é incerta |
| Material do ensaio de 04/11 (seção 8) | **Levar** acrílico e couro (o MDF já está na FAVAG); o restante pode ser comprado na região | O ensaio é três dias antes da aula; sem o material, o ensaio trava |
| Couro natural | **Levar** ou **comprar na região** | Se houver fornecedor conhecido, a compra local ajuda a economia da região; confirmar que é natural e curtido ao vegetal |
| Argolas, pendrives, EPI de reserva, paquímetros | **Levar** | Leves, baratos e críticos |
| Apostila impressa | **Levar** (impressa antes do evento) | Controle de qualidade; cerca de 2 kg |
| Cola, lixa, fita crepe, papel, sacos | **Comprar na região** | Corriqueiros, e evitam peso e risco de transporte |
| Cabo HDMI, filtro de linha, roteador portátil | **Levar** | Plano B do projetor e da internet |
| Extintor, exaustão, refrigeração | **Laboratório** | Fazem parte da instalação; conferir em 04/11 |

## 6. Kit de peças pré-cortadas (seguro)

**O que é:** peças de MDF de 3 mm cortadas antes da aula com os arquivos prontos do repositório: **24 chaveiros em branco** (70 x 25 mm, furo de 4,5 mm; só a camada de corte) e **10 caixas abertas** (80 x 60 x 40 mm, 5 painéis cada, com o nome de cada painel gravado). Sobram 2 caixas e 8 chaveiros sobre o necessário para 8 duplas. A caixa do kit tem um desenho um pouco diferente da do prompt 2 (a base também tem dedos). O comprimento e a largura externos são os mesmos (80 x 60 mm); a altura muda de significado: no arquivo pronto, `height` é a altura **total** (40 mm), e no prompt 2 é a altura das paredes (a caixa montada tem 43 mm).

**Para que serve:** se a laser falhar, as duplas ainda montam a caixa, medem o chaveiro e discutem o encaixe (`roteiro-instrutor.md`, seção 6). As caixas do kit também servem de referência de folga.

**Relação com a contingência C3.** `laser/contingencias.md` (item C3) abre com o mesmo kit: 24 chaveiros em branco e 10 caixas de 80 x 60 x 40 mm. A caixa pequena de 60 x 40 x 30 mm, as tiras de dobradiça viva e as placas são opcionais no C3: se sobrar tempo de máquina antes do evento, acrescente-as.

**Como preparar:**

1. Gerar e cortar os arquivos prontos, com o kerf offset calibrado (comandos conferidos em `laser/contingencias.md`, item C3, dentro de `laser/modelos/`). Os 24 chaveiros em branco saem de uma vez e cabem em uma chapa de 600 x 400 mm: `bash exportar.sh -n kit-chaveiros -l cut -D 'labels=[""]' -D count=24 -D sheet_width=600 -D sheet_height=400 -D tag_width=70 -D hole_diameter=4.5 -D hole_margin=3.5 chaveiros-lote`. As caixas usam os valores padrão: `bash exportar.sh -n kit-caixa caixa-finger-joint`. Cada arquivo tem uma caixa de 210 x 105 mm; duplique no software da laser até 10, e cabem 6 por chapa de 600 x 400 mm (2 chapas para as 10).
2. Ensacar **uma caixa por saco**, com etiqueta; chaveiros em saco à parte.
3. **Montar uma caixa a seco antes do evento** para confirmar o encaixe.
4. Tempo de máquina com os valores de planejamento: cerca de 10 minutos para os 24 chaveiros (só corte) e cerca de 36 minutos para as 10 caixas (2,9 minutos de corte e 0,7 de gravação dos nomes por caixa), perto de 46 minutos no total.

## 7. Por dupla, na mesa

- 1 computador, 2 apostilas, 1 cartão de conferência de fila, 1 saco com o número da dupla.
- 2 retalhos de MDF para teste.
- 2 óculos de proteção e 2 máscaras PFF2.
- 1 paquímetro para cada 2 duplas.

## 8. Material do ensaio de 04/11

O ensaio de quarta 04/11 (`laser/ensaio-laser.md`) acontece três dias antes da aula e usa material próprio, que não está nas contas acima. A tabela repete o "Kit" daquele plano. As quantidades de material são estimativa da área usada nos blocos, não medida; confirmar com o laboratório o que já existe (pendência do instrutor).

| Item | Quantidade | Uso no ensaio | Preço |
| --- | --- | --- | --- |
| MDF de 3 mm resinado (Meraki), 600 x 400 mm | 2 chapas (1 e 1 de reserva), do estoque já na FAVAG | Testes de corte, gravação e encaixe (blocos 4 a 9) | já na FAVAG |
| Acrílico de 3 mm fundido, 300 x 300 mm | 1 chapa (opcional) | Teste de potência x velocidade (bloco 5) | cotar |
| Couro vegetal, retalho de 200 x 150 mm | 1 (opcional) | Teste de potência x velocidade (bloco 5) | cotar |
| Paquímetro digital (0,01 mm) | 1 (um dos 5 da seção 4) | Kerf, espessura e encaixe (blocos 6 e 8) | cotar |
| Fita crepe larga | 1 rolo (um dos 4 da seção 4) | Teste dos espelhos e fixação do material (blocos 3 e 5) | cotar |
| Trena, régua de aço e esquadro | 1 de cada (a régua e o esquadro são dos 2 da seção 4) | Área útil, foco e esquadro da caixa (blocos 2, 4 e 8) | cotar |
| Marcador permanente fino | 1 (um dos 4 da seção 4) | Marcar fitas e peças | cotar |
| Pano seco | 1 | Limpar a fuligem das peças antes de medir (bloco 6) | cotar |
| Óculos de proteção para CO2 | Um por pessoa presente | Segurança (bloco 1); os 20 da seção 4 cobrem, se forem levados ao ensaio | cotar |

O MDF do ensaio soma 0,48 m² (cerca de 1,1 kg) e sai do mesmo estoque da Meraki: com as 3 chapas da aula, são 5 chapas de 600 x 400 mm a separar na FAVAG; as 3 do kit são compradas e cortadas antes da viagem. O que sobrar do ensaio pode ser usado na aula, mas as contas das seções 1 a 3 não contam com isso.
