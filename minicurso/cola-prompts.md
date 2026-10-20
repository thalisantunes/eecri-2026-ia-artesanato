FOLHA DE PROMPTS · Oficina de IA para 3D e laser · I EECri 2026

Como usar: abra uma conversa nova no assistente de IA (claude.ai, ChatGPT ou Gemini). Cole primeiro as REGRAS da máquina. Depois cole o pedido da peça e troque medidas e nomes pelos seus. Para levar o código do celular ao computador: entre no mesmo assistente pelo navegador do computador, com a mesma conta, e abra a conversa; ou mande o código para você mesmo por e-mail ou pelo WhatsApp Web. Cole o código no OpenSCAD e aperte F6. Laser: File, Export, Export as SVG (corte); troque layer para "engrave", aperte F6 e exporte de novo (gravação). Os dois círculos pequenos que aparecem nos dois arquivos são as marcas de registro: servem para encaixar a gravação no lugar certo do corte; ficam fora da peça e, depois de alinhar, podem ser apagados no software da laser. 3D: File, Export, Export as STL.

======== REGRAS DA LASER (cole primeiro) ========

Escreva código OpenSCAD 2021.01 para cortar e gravar numa laser. Regras: sem bibliotecas (nada de include nem use) e sem roof, fill, textmetrics ou minkowski. Tudo em milímetros. Todos os números no começo do arquivo, como variáveis com um comentário. Só 2D: nada de cube, cylinder nem extrude. NÃO compense o kerf; a única folga permitida é a variável clearance, só em encaixes. Fonte "Liberation Sans:style=Bold". Crie a variável layer = "cut": com "cut" o arquivo gera só o que é cortado (contornos e furos, com difference); com "engrave", só o que é gravado (texto). Nas duas camadas, desenhe dois círculos de 0.6 mm, um 3 mm fora do canto inferior esquerdo e outro 3 mm fora do canto superior direito das peças. Mostre as medidas finais com echo(). Devolva o arquivo completo num bloco só. Responda "entendido" e espere a peça.

======== REGRAS DA 3D (cole primeiro) ========

Escreva código OpenSCAD 2021.01 para impressão 3D. Regras: sem bibliotecas (nada de include nem use) e sem roof, fill, textmetrics ou minkowski. Tudo em milímetros. Todos os números no começo do arquivo, como variáveis com um comentário. Uma peça sólida só, apoiada em z = 0, que imprima apoiada na base sem suporte: nada solto no ar e paredes de pelo menos 2 mm. Texto em "Liberation Sans:style=Bold", gravado 0.8 mm para dentro. Mostre largura, profundidade e altura com echo(). Devolva o arquivo completo num bloco só. Responda "entendido" e espere a peça.

======== PEÇA: CHAVEIRO COM NOME (laser) ========

Peça: chaveiro de 70 x 25 mm, cantos com raio de 4 mm, furo de 4,5 mm de diâmetro para a argola, centralizado na altura, com a borda do furo a 3,5 mm da borda esquerda da peça, e o nome MARIA gravado à direita do furo, a pelo menos 3 mm do furo e das bordas. Calcule a letra no código: tamanho = o menor entre 8 e a largura livre para o nome dividida pelo número de letras. Mostre com echo() o tamanho da letra e a largura livre. Material: MDF de 3 mm.

======== PEÇA: LOTE DE CHAVEIROS (laser) ========

Peça: o mesmo chaveiro (70 x 25 mm, furo de 4,5 mm centralizado na altura, com a borda do furo a 3,5 mm da borda esquerda, nome a pelo menos 3 mm do furo e das bordas), repetido em grade de 2 colunas com 3 mm entre eles, um para cada nome desta lista: ["ANA", "JOÃO", "CONCEIÇÃO", "PEDRO"]. Calcule a letra de cada nome no código: tamanho = o menor entre 8 e a largura livre para o nome dividida pelo número de letras do nome. Mostre com echo() o tamanho da letra de cada nome. As marcas de registro entram uma vez só, nos cantos do lote. Mostre com echo() quantos chaveiros há e o tamanho do lote.

======== PEÇA: PORTA-CARTÃO (3D) ========

Peça: porta-cartão de mesa para cartões de 90 x 50 mm, com bolso para uma pilha de 12 mm, encosto inclinado 12 graus para trás, pé atrás para não tombar e a palavra ATELIÊ gravada na frente. Imprime apoiado na base, sem suporte.

======== AJUSTE (uma mudança por vez) ========

Abaixo está o meu código OpenSCAD. Faça só esta mudança, sem mexer em mais nada: troque o nome MARIA por JOSÉ. Devolva o arquivo completo e diga em até 3 linhas o que mudou, com o valor antigo e o novo.

======== DEU ERRO ========

O OpenSCAD 2021.01 mostrou a mensagem abaixo. Explique em linguagem simples o que ela quer dizer. Não devolva o arquivo inteiro: mostre só as linhas corrigidas e diga quais linhas do meu código elas substituem (da linha X à linha Y). Não mude mais nada além do erro. A mensagem inteira e o código estão logo abaixo.

======== ANTES DE MANDAR PARA A MÁQUINA ========

A medida do console é a que você pediu? Na prévia com corte e gravação juntos (no software da laser, importe os dois SVG e encaixe um no outro pelas marcas de registro), algum nome encosta no furo, passa da borda ou invade o vizinho? Se sim, peça: diminua a letra do nome X para caber. A largura do texto no console é estimativa; quem confere é a prévia. Os acentos aparecem? O furo é furo de verdade? A espessura é a do material medido? Na 3D, a peça está inteira, apoiada na mesa, e a base cobre o topo do encosto? Depois de colar uma correção, a peça continua do mesmo tamanho e no mesmo lugar? O console pode repetir a medida mesmo com a peça errada: olhe a peça na tela.

Arquivos prontos: copie a pasta laser/modelos inteira, porque o lote de chaveiros usa o chaveiro-tag.scad da mesma pasta. Caixa com encaixe: abra o arquivo pronto caixa-finger-joint.scad e use o pedido de AJUSTE. Ao exportar um arquivo pronto, troque registration = false por registration = true, para os dois SVG saírem com as marcas de registro. Pedidos longos e testados: apostila, capítulo 3.
Procure o Diego no Laboratório Maker de Nova Porteirinha: atendimento gratuito.
