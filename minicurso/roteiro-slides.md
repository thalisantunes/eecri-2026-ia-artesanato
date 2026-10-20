# Roteiro dos slides: "Da frase à peça" (versão pública)

Oficina de IA para modelo 3D e corte a laser, Laboratório Maker da FAVAG, Nova Porteirinha, MG, I EECri 2026 (07/11/2026). Instrutor: Thalis Antunes de Souza.

Turma pequena, em duplas, com rodízio nas máquinas. A fala de cada slide é o núcleo do que dizer; o tempo é estimado. A folha de prompts está em `cola-prompts.md` e a apostila em `apostila/`.

Este arquivo é gerado a partir de `slides.md` (texto do slide e notas do apresentador). As anotações internas de preparação não fazem parte da versão pública.

## Slides

### Slide 1. Da frase à peça

**Tempo:** 1 min

**Texto do slide**

### IA para modelo 3D e corte a laser

Oficina prática · Thalis Antunes de Souza

Laboratório Maker da FAVAG · Nova Porteirinha, MG · 07/11/2026

**Fala do apresentador.** Bom dia (ou boa tarde), pessoal. Esta é a oficina que o Diego pediu: turma pequena, mão na massa. Eu mostro rápido como a gente usa inteligência artificial para fazer um modelo 3D e um arquivo de corte a laser, e depois vocês praticam. A ideia é sair daqui sabendo fazer sozinho em casa e voltar ao laboratório para produzir.

### Slide 2. O combinado de hoje

**Tempo:** 2 min

**Texto do slide**

- **Eu mostro** cada passo uma vez, rápido
- **Vocês praticam** em duplas, com rodízio nas máquinas
- Cada um sai com **um arquivo seu**, pronto para levar ao laboratório
- Na laser e na impressora, **só com o responsável do laboratório**
- Laser: tampa fechada, exaustão ligada, **nada de PVC ou couro sintético**

*Sou de Janaúba, aqui do lado. Menores de 18 anos usam o assistente de IA com um adulto dono da conta.*

**Fala do apresentador.** Como vai funcionar. Eu mostro cada passo uma vez, sem enrolar. Depois vocês praticam em duplas. Tem pouca máquina, então a gente faz rodízio: enquanto uma dupla está na laser, a outra prepara o arquivo. Cada um sai daqui com um arquivo seu, que dá para levar para produzir. Na laser e na impressora, só com o responsável do laboratório do lado. Na laser, três regras: tampa fechada enquanto corta, exaustão ligada e nunca cortar PVC ou couro sintético, que soltam gás tóxico e estragam a máquina. Eu sou de Janaúba, aqui do lado, então estou em casa. E um aviso: os termos do claude.ai pedem 18 anos. Por isso a regra da oficina é esta: quem tem menos trabalha junto com um adulto que é o dono da conta.

### Slide 3. Tudo em um desenho

**Tempo:** 2 min

**Texto do slide**

Fraseo que é, medidas, material
›
IAassistente gratuito no celular
›
Códigotexto que a IA escreve
›
OpenSCADdesenha e mostra as medidas
›
ArquivoSVG ou DXF; STL no 3D
›
Máquinalaser ou impressora 3D

> **A ideia:** você não desenha. Você **descreve com números**, a IA escreve, o computador desenha e você confere.

**Fala do apresentador.** Este é o caminho inteiro, e é o mesmo para a laser e para a impressora 3D. Primeiro, uma frase: o que é a peça, as medidas em milímetros e o material. Essa frase vai para um assistente de IA gratuito, o claude.ai, o ChatGPT ou o Gemini, no celular mesmo. A IA não devolve um desenho: devolve um código, um texto. Esse texto a gente cola no OpenSCAD, um programa gratuito que transforma o código em desenho e mostra as medidas. Do OpenSCAD sai o arquivo: para a laser, um SVG ou DXF; para a impressora 3D, um STL. E o arquivo vai para a máquina. O segredo é este: você não precisa saber desenhar. Precisa saber descrever com números e conferir o que voltou.

### Slide 4. Duas saídas, o mesmo começo

**Tempo:** 3 min

**Texto do slide**

| | Corte a laser | Impressão 3D |
| --- | --- | --- |
| A peça é | plana (chapa de MDF, acrílico, couro) | um objeto com volume |
| Do OpenSCAD sai | **SVG ou DXF**, um por camada (corte e gravação) | **STL** |
| Vai para | software da laser (LightBurn ou RDWorks) | fatiador da impressora do laboratório |
| Cuidado | o **kerf** fica fora do desenho | a peça precisa ficar **de pé sem suporte** |

*Kerf é a largura que o laser queima ao cortar. Quem compensa é o software da laser, nunca o desenho.*

**Fala do apresentador.** Daqui saem dois caminhos. Na laser, a peça é plana: chaveiro, placa, as paredes de uma caixa. O OpenSCAD exporta um arquivo para o que corta e outro para o que grava, e o software da laser junta os dois. Na impressora 3D, a peça tem volume, e o arquivo é um STL, que vai para o fatiador, o programa que transforma a peça em camadas para a impressora. Um cuidado de cada lado. Na laser, o kerf, a largura que o laser queima, nunca entra no desenho: quem acerta isso é o software da máquina, com o valor medido nela. Na 3D, a peça precisa ficar de pé na mesa da impressora sem parte solta no ar, senão precisa de suporte e dá mais trabalho.

### Slide 5. Demonstração: laser

**Tempo:** 0,5 min

**Texto do slide**

Eu faço, vocês olham. Depois é com vocês.

**Fala do apresentador.** Vamos para a laser primeiro, porque é a peça mais rápida de sair. Olhem a tela.

### Slide 6. Um chaveiro com nome, depois o lote

**Tempo:** 7 min

**Texto do slide**

- Peço **um chaveiro**: 70 x 25 mm, furo para argola, nome gravado
- Confiro o console: **medida e tamanho da letra**
- Troco o nome por uma **lista**: um arquivo, uma chapa, muitos nomes
- **Vermelho corta, azul grava**
- Nome comprido: o arquivo pronto **reduz a letra**; a IA **às vezes erra**

*Imagem: arquivo pronto, não resposta da IA*

**Fala do apresentador.** Primeiro eu peço um chaveiro só: setenta por vinte e cinco milímetros, cantos arredondados, um furo para a argola e o nome gravado. Olhem o console do OpenSCAD: no código que a IA escreveu, ele mostra a medida da peça e o tamanho da letra, porque o pedido manda. Isso é o que a gente confere. Agora eu troco um nome por uma lista de nomes, e o mesmo arquivo monta a chapa inteira, com cada nome no seu chaveiro. O vermelho é o que a laser corta; o azul é o que ela grava. Reparem neste nome comprido: no arquivo pronto, a letra fica menor para caber, e o console avisa. Isso é uma regra escrita nesse arquivo. Quando é a IA que escreve o código, ela às vezes erra essa conta: no nosso teste de 20 de outubro, com três modelos de IA, o nome Conceição saiu da peça em duas das três respostas, sem nenhum erro na tela. Depois eu deixei o pedido mais preciso, e é ele que está na folha de vocês: com ele, o nome coube em todos os modelos que testei. Mesmo assim, a gente confere. Para quem vende lembrancinha, isso é o produto: o cliente manda a lista, você troca os nomes e corta.

### Slide 7. Uma caixa com encaixe

**Tempo:** 7 min

**Texto do slide**

- A IA pensa a caixa **em 3D** e entrega **as paredes planas**
- Os cantos têm **dedos** que entram uns nos outros
- Eu informo a **espessura medida** do MDF, não a da etiqueta
- A folga do encaixe é **um número** do arquivo
- Mudou o tamanho? **Troco três números** e corto de novo

*Arquivo pronto no pendrive: laser/modelos/caixa-finger-joint.scad*

**Fala do apresentador.** Agora uma peça que parece difícil: uma caixa com encaixe de dedos, sem prego e sem ferramenta de marcenaria. A caixa é um objeto 3D, mas a laser só corta chapa. Então a IA pensa a caixa em três dimensões e entrega as paredes planas, lado a lado, com os dedos nos cantos. Dois cuidados. Primeiro, a espessura do MDF: o de três milímetros às vezes mede dois e oito. Eu meço e coloco o número medido. Segundo, a folga, que é um número no arquivo: se ficar apertado, aumento a folga. E se o cliente quiser outra medida, eu troco o comprimento, a largura e a altura, e corto de novo. Essa caixa é embalagem: para doce, vela, sabonete, presente.

### Slide 8. Demonstração: 3D

**Tempo:** 0,5 min

**Texto do slide**

O mesmo caminho, só muda o arquivo do fim.

**Fala do apresentador.** Agora a impressora 3D. O começo é igual: frase, IA, código, OpenSCAD. Muda só o arquivo que sai no fim.

### Slide 9. Porta-cartão para a banca

**Tempo:** 10 min

**Texto do slide**

- Para cartão de **90 x 50 mm**, com bolso para uma pilha de 12 mm
- O nome da loja **gravado na frente**
- Imprime **apoiado na base, sem suporte**
- Do OpenSCAD sai um **STL**, que vai para o **fatiador**
- O fatiador diz **quanto tempo** e **quanto filamento**

*Imagem: resposta da IA (Claude Opus) à folha, teste de 20/10, sem edição*

**Fala do apresentador.** A peça de 3D que eu escolhi é útil para quem vende em feira: um porta-cartão de mesa. Esta imagem é a resposta de uma IA ao pedido que está na folha de vocês, sem nenhuma edição minha. Eu peço à IA para um cartão de noventa por cinquenta milímetros, que é o tamanho comum, com espaço para uma pilha de cartões, um encosto inclinado e um pé atrás para não tombar. E o nome da loja gravado na frente. Reparem: eu pedi que ela imprima apoiada na base, sem suporte, e por isso o encosto inclina pouco. O OpenSCAD exporta o STL. O STL vai para o fatiador, o programa da impressora, que mostra quanto tempo e quanto filamento a peça gasta. Filamento é o fio de plástico, em rolo, que a impressora derrete e deposita camada por camada. Esse número é o começo do preço. Vou mandar imprimir agora; o fatiador diz quanto tempo leva. Se der tempo, a gente vê a peça pronta no fim.

### Slide 10. No meu computador, a IA desenha sozinha

**Tempo:** 1,5 min

**Texto do slide**

- Eu uso o **Claude Code** com o **mcp-openscad**, um conector meu
- A IA escreve o código, **roda o OpenSCAD** e me mostra a imagem
- Vocês fazem o mesmo **à mão**: celular e computador do laboratório
- O resultado é **o mesmo arquivo**

*github.com/thalisantunes/mcp-openscad · código aberto, licença MIT*

**Fala do apresentador.** Uma explicação rápida, para ninguém achar que tem truque. No meu computador eu uso o Claude Code, com um conector que eu mesmo escrevi, o mcp-openscad. Com ele a IA escreve o código, roda o OpenSCAD e me mostra a imagem, sem eu copiar e colar. Vocês vão fazer o mesmo caminho à mão: a IA no celular, o OpenSCAD no computador do laboratório. Para passar o código do celular para o computador, o jeito mais simples é abrir o mesmo assistente no navegador do computador, com a mesma conta: a conversa está lá. Também dá para mandar o código para você mesmo por e-mail. Isso está na folha. Dá um pouco mais de trabalho, e o arquivo que sai é o mesmo. O conector é código aberto: quem quiser, o endereço está na tela.

### Slide 11. Agora é com vocês

**Tempo:** 0,5 min

**Texto do slide**

Pedir bem, conferir e levar para a máquina.

**Fala do apresentador.** Agora vocês. Antes de ir para o computador, dois minutos sobre como pedir bem e como conferir.

### Slide 12. Primeiro as regras, depois a peça

**Tempo:** 2,5 min

**Texto do slide**

**Peça:** chaveiro de 70 x 25 mm, cantos com raio de 4 mm, furo de 4,5 mm de diâmetro para a argola, centralizado na altura, com a borda do furo a 3,5 mm da borda esquerda da peça, e o nome MARIA gravado à direita do furo, a pelo menos 3 mm do furo e das bordas.

Calcule a letra no código: tamanho = o menor entre 8 e a largura livre para o nome dividida pelo número de letras. Mostre com echo() o tamanho da letra e a largura livre.

**Material:** MDF de 3 mm.

*Antes, cole as Regras da laser da folha. Para salvar: F6, File, Export, Export as SVG (corte); troque layer para "engrave", F6 e exporte de novo (gravação).*

**Fala do apresentador.** O pedido tem duas partes. Primeiro vocês colam as regras, que estão na folha de prompts: elas dizem para a IA a versão do OpenSCAD, que tudo é em milímetros, que o kerf fica fora do desenho. Isso vocês colam uma vez por conversa. Depois vem a peça: o que é, com as medidas, e o material. Este é o pedido do chaveiro, igual ao da folha. Reparem que ele diz onde fica o furo, a distância do nome até o furo e as bordas e como calcular o tamanho da letra, e pede que a IA mostre esses números com echo, que é como o OpenSCAD escreve números no console. É assim que a gente confere. Quanto mais número no pedido, menos a IA inventa. Troquem MARIA pelo nome de vocês. Com nome comprido a letra diminui, mas confiram na prévia se o nome não passou da borda: é aí que a IA mais erra. Para salvar, são dois arquivos: aperte F6 e exporte em File, Export, Export as SVG, que é o corte. Depois troque no código layer igual a cut por engrave, aperte F6 de novo e exporte outro SVG, que é a gravação.

### Slide 13. O mesmo pedido, para a 3D

**Tempo:** 1,5 min

**Texto do slide**

**Peça:** porta-cartão de mesa para cartões de 90 x 50 mm, com bolso para uma pilha de 12 mm, encosto inclinado 12 graus para trás, pé atrás para não tombar e a palavra ATELIÊ gravada na frente. Imprime apoiado na base, sem suporte.

*Antes, cole as Regras da 3D da folha. Para salvar: menu File, Export, Export as STL.*

**Fala do apresentador.** Para a 3D é a mesma receita. Cola as regras da 3D, que pedem uma peça sólida, apoiada na mesa, sem nada solto no ar. Depois a peça, com as medidas. Reparem no pé atrás: sem ele, num dos testes a IA desenhou um encosto cujo topo passava 15 milímetros além da base. E uma coisa a mais: dizer como ela vai imprimir: apoiada na base, sem suporte. Isso faz a IA desenhar uma peça que a impressora consegue fazer. Para salvar o arquivo, no OpenSCAD é F6 para desenhar e depois File, Export, Export as STL.

### Slide 14. A IA erra: confira antes

**Tempo:** 3 min

**Texto do slide**

- **Medidas:** o console mostra o que você pediu?
- **Nome:** longe do furo, da borda e do vizinho?
- **Acentos:** JOÃO, ATELIÊ, CONCEIÇÃO certos?
- **Furo é furo:** dá para ver o fundo?
- **Encaixe:** espessura do material **medido**?
- **3D:** inteira, apoiada, base sob o encosto?

> **Ao lado, teste de 20/10, antes de corrigir a folha:** a IA (Claude Haiku) pôs CONCEIÇÃO fora da peça, sem erro na tela. Com a folha corrigida, o nome coube.

**Fala do apresentador.** Agora a parte mais importante: a IA erra, e erra com confiança. Antes de qualquer arquivo ir para a máquina, conferir seis coisas. A medida: o número que o console escreve é o que você pediu? O nome dentro da peça: olhem a prévia com corte e gravação juntos. No software da laser, os dois arquivos se encaixam pelas marcas de registro, os dois circulinhos que ficam fora da peça. Vejam se algum nome encosta no furo, passa da borda ou invade o chaveiro do lado. Se passar, peçam: diminua a letra do nome tal para caber. E não confiem na largura que o console escreve para o texto: é uma estimativa da IA, e no teste ela errou. Quem confere é a prévia. Os acentos: escrevam um nome com til e com cedilha e vejam se aparece. O furo: às vezes a IA desenha um círculo por cima da peça e não abre o furo de verdade. O encaixe: a espessura no arquivo é a do material que você mediu? E na 3D: a peça está inteira, apoiada na mesa, e a base vai até debaixo do topo do encosto? Olhem esta imagem: é uma resposta de verdade, do teste que eu fiz em 20 de outubro com os pedidos desta oficina. O nome Conceição passou da peça e entrou no chaveiro do lado. O console não deu erro nenhum, e a própria IA disse que cabia. Isso foi na primeira rodada, antes de eu corrigir os pedidos: 5 de 24 respostas tinham defeito, e só a conferência pegou. Com os pedidos corrigidos, que são os da folha de vocês, o lote passou em todos os modelos que testei. Mas uma rodada boa não garante a próxima resposta, então a conferência continua. Conferir é o que separa uma peça boa de uma chapa jogada fora.

### Slide 15. Deu erro? Não apague, pergunte

**Tempo:** 1,5 min

**Texto do slide**

- Copie **a mensagem inteira** do console
- Cole na conversa e peça: **explique em linguagem simples e corrija só o trecho**
- Colou a correção? **Olhe a peça:** mesmo tamanho, mesmo lugar
- **Uma mudança por vez:** primeiro troque o nome, depois a largura
- Travou duas vezes no mesmo ponto? Use o **arquivo pronto** do pendrive e peça só o ajuste

*Pedidos de ajuste e de erro também estão na folha de prompts.*

**Fala do apresentador.** Quando o OpenSCAD mostrar um erro, não apaguem tudo. Copiem a mensagem inteira, colem na conversa e peçam para a IA explicar em linguagem simples e corrigir só aquele trecho. Mesmo assim, às vezes ela devolve o arquivo inteiro reescrito: no meu teste, uma IA consertou o erro e, de quebra, mudou outras partes do chaveiro sem ninguém pedir. Se a resposta vier com mudanças que você não pediu, não use: peça de novo só o trecho. E no meu teste o ChatGPT e o Gemini devolveram o arquivo inteiro mesmo assim; se acontecer, confiram que só a linha do erro mudou. Depois de colar a correção, olhem a peça na tela: ela tem que continuar do mesmo tamanho e no mesmo lugar. Num teste, a IA mandou trocar uma linha por quatro e, colando do jeito que ela disse, a peça saiu do lugar sem nenhum erro na tela, e o console continuou mostrando as mesmas medidas. Quando quiserem mudar algo, uma mudança por vez. E se travar duas vezes no mesmo lugar, peguem o arquivo pronto do pendrive e peçam só o ajuste. Ninguém ganha nada brigando com a IA meia hora.

### Slide 16. Pouca máquina: rodízio

**Tempo:** 2 min de explicação; a prática ocupa o resto do bloco

**Texto do slide**

| Posto | Quem | O que faz |
| --- | --- | --- |
| **Computador** | a dupla | pede à IA, confere no OpenSCAD, salva o arquivo |
| **Laser** | responsável do laboratório e uma dupla | importa, confere a prévia, corta |
| **Impressora 3D** | quem conhece a impressora e uma dupla | fatia, confere o tempo; imprime se a impressora estiver livre |

- Na dupla: **um pede** (celular), **o outro confere** (computador)
- **Só entra na fila** arquivo conferido, com o nome da dupla
- **Laser:** os chaveiros da turma vão juntos, numa chapa só
- **3D:** impressora ocupada? O STL conferido **fica na fila**

**Fala do apresentador.** Tem pouca máquina, então a gente organiza assim. Três postos. No computador, a dupla pede à IA e confere no OpenSCAD. Na laser fica o responsável do laboratório e uma dupla por vez. Na impressora 3D, quem conhece a impressora e uma dupla. Dentro da dupla, um pede pelo celular e o outro confere no computador, e depois trocam. Antes de começar, eu mostro uma vez como o código passa do celular para o computador. A fila tem uma regra só: arquivo que não foi conferido não entra. Na laser, os chaveiros da turma vão juntos numa chapa só, para não ligar a máquina toda hora. Na 3D, a impressão demora, e a impressora pode estar ocupada com a peça da demonstração. Então a dupla fatia, confere o tempo e deixa o STL conferido na fila: se a impressora estiver livre, imprime; se não, leva o arquivo para imprimir depois no laboratório. Enquanto isso, a dupla volta para o computador e faz a próxima peça.

### Slide 17. O que cada dupla faz

**Tempo:** 1 min (e a prática segue com este slide na tela)

**Texto do slide**

1. **Chaveiro com o seu nome** (laser): pedir, conferir, entrar na fila
2. **Porta-cartão com o nome da sua loja** (3D): pedir, conferir, fatiar
3. Sobrou tempo? **Caixa com encaixe** a partir do arquivo pronto

> **Ao sair:** salve o arquivo .scad **e** o pedido que você mandou. Na próxima encomenda, é só trocar os números.

**Fala do apresentador.** A tarefa de cada dupla. Primeiro, o chaveiro com o próprio nome, para a laser. Segundo, o porta-cartão com o nome da sua loja, ou do seu projeto, para a 3D. Quem terminar, pega o arquivo pronto da caixa e muda as medidas para uma embalagem sua. E no fim, salvem duas coisas: o arquivo e o pedido que vocês mandaram para a IA. O pedido é a receita: na próxima encomenda vocês trocam os números e pronto. Este slide fica na tela. Pode começar.

### Slide 18. Quanto custa uma peça

**Tempo:** 2,5 min

**Texto do slide**

- **Material:** a parte da chapa ou do filamento que a peça usa
- **Máquina:** o tempo que o software ou o fatiador mostra
- **Seu tempo:** limpar, lixar, montar, embalar, atender
- **Insumos:** argola, cola, embalagem, etiqueta
- **Perdas:** as peças que dão errado

> **Preço = custo ÷ (1 − margem − taxas).** Faça a conta com os **seus** números: material, tempo e taxa de cada um são diferentes.

**Fala do apresentador.** Peça boa vira produto quando a gente sabe quanto custa. São cinco partes. O material, que é o pedaço da chapa ou o filamento que a peça usa. A máquina, que é o tempo: o software da laser e o fatiador mostram. O seu tempo, que muita gente esquece, e aí trabalha de graça. Os insumos, argola, cola, embalagem. E as perdas, porque sempre tem peça que dá errado. O preço é o custo dividido por um menos a margem e as taxas, como a do cartão ou da plataforma. Eu não vou dar número aqui de propósito: o MDF, a hora e a taxa de cada um são diferentes. Façam a conta com os de vocês, e o Diego ajuda.

### Slide 19. Escolha a máquina

**Tempo:** 1,5 min

**Texto do slide**

| 65 unidades | 3D | Laser |
| --- | --- | --- |
| Material | 4 rolos | 2 chapas |
| Máquina ligada | cerca de 93&nbsp;h* | cerca de 2,5 h* |
| Montagem | colar | encaixar; cola nas abas |

> **Antes de ligar a máquina,** pergunte: quantas peças, em quanto tempo, em qual máquina?

*A mesma peça, desenhada para as duas. Planejado, não produzido. *Estimativas. Ao lado: 40 numa chapa.*

**Fala do apresentador.** Um exemplo de como a máquina entra no custo. Eu desenhei uma lembrancinha para um encontro de ex-alunos: uma palmeira, um sol e um broto numa base. Primeiro para a impressora 3D, em 5 peças coloridas, e depois a mesma peça para a laser, em 5 peças planas de compensado de 3 milímetros que se encaixam; só as abas da base levam um pingo de cola. Para 65 unidades, a 3D pede 4 rolos de filamento e cerca de 93 horas de máquina, mais colar as peças. A laser pede 2 chapas, porque cada uma leva 40 lembrancinhas, como nesta imagem, e cerca de duas horas e meia de corte, numa estimativa que ainda tem que ser medida na máquina. Lembram da parte "máquina" da conta? É aqui que ela pesa. A 3D dá volume e cor; o laser dá velocidade no lote. Para a peça de vocês, façam a mesma pergunta antes de ligar a máquina: quantas, em quanto tempo e em qual máquina. Isso é planejamento: nada foi produzido ainda.

### Slide 20. Um arquivo, vários produtos

**Tempo:** 1,5 min

**Texto do slide**

- **Lote:** uma lista de nomes, uma chapa, uma ligada da máquina
- **Tamanhos:** troque três números e faça P, M e G
- **Etiqueta e tag:** o mesmo caminho grava o nome da sua marca
- **Confira a grafia** com o cliente antes de cortar: nome errado não tem conserto

**Fala do apresentador.** O que faz o arquivo valer dinheiro é poder repetir. Lote: a lista de nomes da festa vira uma chapa só, e o tempo de preparar o arquivo se divide por todas as peças. Tamanhos: a mesma caixa em três tamanhos é só trocar três números. Etiqueta e tag: o nome da marca gravado em MDF ou couro sai do mesmo caminho. E um cuidado que vale ouro: conferir a grafia dos nomes com o cliente antes de cortar, porque nome errado em peça cortada não tem conserto.

### Slide 21. Depois de hoje

**Tempo:** 1 min

**Texto do slide**

- Em casa: **IA no celular** e **OpenSCAD**, os dois gratuitos
- Guarde a **folha de prompts** e o seu arquivo
- Quer produzir? Leve o arquivo **conferido** ao laboratório
- Quer vender? Faça a conta do custo **antes** de dar o preço

**Fala do apresentador.** Para continuar depois de hoje. Em casa vocês têm tudo o que precisa para fazer o arquivo: a IA no celular e o OpenSCAD no computador, os dois de graça. Guardem a folha de prompts e o arquivo de vocês. Quando quiserem produzir, levem o arquivo já conferido ao laboratório. E antes de dar preço para alguém, façam a conta do custo.

### Slide 22. Procure o Diego

**Tempo:** 1 min

**Texto do slide**

no **Laboratório Maker de Nova Porteirinha**

Ele monta com você, **de graça**, um planejamento para o seu caso,
seja você empreendedor ou estudante.

**Fala do apresentador.** E o mais importante: procurem o Diego, do Laboratório Maker. Ele monta com vocês, de graça, um planejamento para cada caso, seja de quem quer vender, seja de estudante com uma ideia. Ele fica no Laboratório Maker. Vocês já sabem fazer o arquivo; com o Diego, ele vira produção.

### Slide 23. Obrigado

**Tempo:** 1 min

**Texto do slide**

**Procure o Diego no Laboratório Maker**

github.com/thalisantunes/mcp-openscad

**Fala do apresentador.** Obrigado, pessoal. Se a impressão terminou, aqui está o porta-cartão que saiu enquanto vocês praticavam. O endereço do mcp-openscad está na tela. E o primeiro passo depois daqui é procurar o Diego.
