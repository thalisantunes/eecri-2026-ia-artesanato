# Capítulo 5. Exercícios e projeto final

Apostila do minicurso "Modelagem 3D com IA generativa para corte a laser".

São três exercícios, do mais simples ao mais livre, e um projeto final por dupla. Cada exercício usa o caminho completo: pedir ao assistente, rodar no OpenSCAD, exportar um SVG por camada, entrar na fila da laser, medir o que saiu.

## Como trabalhar

**Em duplas, com dois papéis.** Troquem de papel a cada exercício.

| Papel | O que faz |
| --- | --- |
| Piloto | Fica no computador: OpenSCAD, exportação, nome dos arquivos |
| Navegador | Fala com o assistente de IA (celular ou notebook), lê o checklist, confere as medidas, anota o que funcionou |

**A laser é uma só, e a fila é de todos.** As peças de todas as duplas entram numa mesma chapa, dividida em células numeradas. O corte acontece em lotes, enquanto as outras duplas continuam modelando. Por isso:

- cada lote **fecha num horário** que o instrutor escreve no quadro. Peça pronta depois do fechamento entra no lote seguinte;
- antes de entrar na fila, a dupla passa pela **conferência de fila** (abaixo);
- uma peça reprovada na conferência volta para a dupla sem perder a vez da próxima.

### Conferência de fila (cartão de 6 itens)

1. O console do OpenSCAD não mostra `ERROR` nem `WARNING`.
2. Os dois arquivos existem e têm o nome certo: `dNN-peca-cut.svg` e `dNN-peca-engrave.svg`.
3. A terceira linha dos dois SVG é igual (marcas de registro) e as camadas **devem alinhar**: o monitor confere as marcas na prévia. Os arquivos de apoio do repositório vêm sem marcas (`registration = false`): use os SVG já exportados ou mude `registration` para `true` antes de exportar.
4. As medidas conferem com o `echo()` e com o cabeçalho do SVG.
5. O texto está dentro da peça e as letras têm pelo menos 5 mm.
6. Só no exercício 3: contorno de corte de até 350 mm e gravação de até 6 cm² (veja o exercício).

## Exercício 1. Chaveiro com nome

| | |
| --- | --- |
| Tempo | 45 minutos de modelagem, mais 15 minutos de medição depois do corte |
| Material | MDF de 3 mm |
| Peças | 2 por dupla: um chaveiro para cada participante |
| Prompt | Prompt 1 (capítulo 3) |

**Objetivo:** percorrer o caminho inteiro pela primeira vez.

**Passo a passo:**

1. Cole o **Bloco base** numa conversa nova do assistente e espere o "entendido".
2. Cole o **Prompt 1**. Troque `label` pelo nome de um dos dois. Mantenha as medidas.
3. Copie o código e cole no OpenSCAD. Salve como `d03-chaveiro-v1.scad` (com o número da sua dupla).
4. F6. Leia o console. Olhe a peça por cima.
5. Exporte os dois SVG do **chaveiro A**: `d03-chaveiro-a-cut.svg` e `d03-chaveiro-a-engrave.svg` (capítulo 4, seção 1).
6. Troque `label` pelo nome do outro participante, confirme que o texto continua dentro da peça e exporte os dois SVG do **chaveiro B**: `d03-chaveiro-b-cut.svg` e `d03-chaveiro-b-engrave.svg`.
7. Confira o cabeçalho dos quatro SVG e passe pela conferência de fila.
8. Entregue os arquivos ao monitor. Guarde o `.scad`.

**O lote 1 é cortado sem compensação de kerf, de propósito.** O chaveiro não precisa de precisão, e a diferença entre o desenhado e o cortado é a sua lição.

**Medir o lote (15 minutos, depois do corte).** Com o paquímetro, meça o seu chaveiro cortado:

| Medida | Desenhada | Cortada | Diferença |
| --- | --- | --- | --- |
| Largura | 70 mm | | |
| Altura | 25 mm | | |
| Diâmetro do furo | 4,5 mm | | |

Diferença da largura = **kerf** aproximado (capítulo 1). O furo deve ter dado o contrário: ficou maior. Discuta com a dupla: onde essa folga atrapalharia?

**Se terminar antes:** use o Prompt 5 com três nomes (lote); ou mude `font_size` e `width` com o Prompt 6 e veja quando o texto deixa de caber.

**Critérios:** medidas, gravação legível, arquivo paramétrico salvo (tabela no fim do capítulo).

## Exercício 2. Caixa pequena

| | |
| --- | --- |
| Tempo | 45 minutos |
| Material | MDF de 3 mm |
| Peças | 1 caixa por dupla: aberta (5 peças) ou com tampa (6 peças) |
| Prompt | Prompt 2 (capítulo 3) |

**Objetivo:** fazer um encaixe que fecha, entendendo kerf e folga.

**Passo a passo:**

1. **Meça a espessura real do MDF** com o paquímetro, em três pontos da chapa, e use a média em `thickness`. MDF de 3 mm raramente mede 3,0.
2. Numa conversa nova: Bloco base, depois o **Prompt 2** com `thickness` ajustado.
3. Confira o console: `n` ímpar e a diferença entre fenda e dedo igual a `clearance`.
4. Olhe a peça por cima: 5 ou 6 peças, com os vãos de uma parede preenchendo o que a outra deixa vazio.
5. Exporte os dois SVG e passe pela conferência de fila.
6. **Se o assistente errar duas vezes no mesmo ponto**, abra `caixa-finger-joint.scad` e peça só ajustes de parâmetro (Prompt 6). O desenho dela é um pouco diferente (a base também tem dedos, e a tampa traz um miolo), mas `length`, `width`, `thickness` e `clearance` funcionam do mesmo jeito. A exceção é `height`: no arquivo pronto é a altura **total** da caixa (40 mm), e no Prompt 2 é a altura das paredes.
7. Depois do corte, **encaixe a seco** (sem cola) e depois cole os dedos com uma camada fina de cola; prenda com fita crepe e deixe secar. **Nunca force**: MDF apertado demais rompe. Se estiver apertado, lixe de leve os dedos.

**Kerf offset:** o lote 2 já sai com o valor calibrado na aula. Se o encaixe estiver apertado ou frouxo, **não mude a geometria da peça**: o kerf nunca entra no desenho. `clearance` é o **único parâmetro de folga** que você ajusta. Anote, aumente ou diminua `clearance` em passos de 0,05 mm e refaça, e avise o instrutor para ajustar o kerf offset se o problema for geral.

**Se terminar antes:** acrescente um nome gravado na tampa; ou peça `height = 50` com o Prompt 6 e confirme que a caixa continua fechando.

**Critérios:** encaixe, medidas, arquivo paramétrico.

## Exercício 3. Peça livre

| | |
| --- | --- |
| Tempo | 35 minutos |
| Material | MDF de 3 mm. Acrílico ou couro só com autorização do instrutor |
| Peças | 1 por dupla |
| Prompt | À escolha: Prompt 3, 4 ou 5, ou um pedido seu |

**Objetivo:** aplicar a receita de sete itens (capítulo 2) a uma peça que você escolhe.

**Orçamento de máquina (a laser é uma só):** a peça precisa caber em **100 x 60 mm**, ter **contorno de corte de até 350 mm** e **gravação de até 6 cm²**. O tempo estimado no software tem de ficar abaixo de **2 minutos**. Peça que passa disso entra no fim da fila, se sobrar tempo.

**Ideias:**

- placa de mesa ou de prateleira com o nome do seu negócio (Prompt 3);
- marcador de livro;
- porta-copo com um desenho gravado;
- etiqueta ou tag de produto, com furo para fio;
- um chaveiro com outro formato: largura, altura e texto diferentes (Prompt 1, ou o Prompt 6 sobre o seu arquivo);
- dobradiça viva (Prompt 4) e lote de chaveiros (Prompt 5): passam do orçamento de máquina. Modele, leve o arquivo e corte depois.

**Passo a passo:**

1. Em 5 minutos, escrevam no papel a **receita de sete itens** da peça: o que é, material, medidas, furos, texto, encaixes, saída.
2. Bloco base e o pedido numa conversa nova.
3. Ciclo do capítulo 2 até o console limpo e a peça certa na tela.
4. Exportem os dois SVG. Conferência de fila, incluindo o item 6 (orçamento).
5. Já com a peça na fila, comecem a montar o projeto final (abaixo).

## Projeto final por dupla

O projeto final **é** a peça do exercício 3. Se a laser não cortar essa peça a tempo, a dupla leva o arquivo e entrega a caixa do exercício 2 como peça do projeto.

**Cada dupla entrega, num pendrive ou na pasta da turma `dNN`:**

1. A **peça cortada**.
2. O arquivo **`dNN-livre.scad`**, com parâmetros no topo, nomes em inglês e unidades nos comentários. No comentário do topo, o **pedido que funcionou**.
3. Os **dois SVG** (`dNN-livre-cut.svg`, `dNN-livre-engrave.svg`).
4. A **ficha da peça**, em cinco linhas:

```
Peça:
Material e espessura medida:
Medidas principais (mm):
Tempo de máquina estimado:
Custo estimado (fórmula do capítulo 6):
```

## Critérios de avaliação

A avaliação serve para você aprender; ela não gera nota. O instrutor e o monitor percorrem a mesa e conversam com cada dupla sobre os quatro critérios.

| Critério | Atende plenamente | Atende em parte | Ainda não atende |
| --- | --- | --- | --- |
| **Encaixe** | As peças da caixa se encaixam à mão, sem martelar e sem folga visível; a tampa assenta | Encaixa com lixa leve ou com folga pequena | Não encaixa, ou cai sozinho |
| **Medidas** | Largura e altura, medidas com paquímetro, ficam a 0,3 mm do desenho (já com o kerf compensado) | Entre 0,3 e 0,6 mm de diferença | Mais de 0,6 mm, ou peça na escala errada |
| **Gravação legível** | Letras de pelo menos 5 mm, nítidas a 50 cm de distância, sem queimado excessivo | Legível só de perto, ou contraste fraco | Ilegível, fora da peça ou atravessada pelo corte |
| **Arquivo paramétrico salvo** | `.scad` salvo, parâmetros no topo com nomes em inglês e unidade no comentário, `layer` funcionando; trocar o texto ou uma medida gera outra peça sem mexer no resto | Salvo, mas com números soltos no código | Não salvo, ou só o SVG |

Para o lote 1 (sem kerf offset), o critério de medidas não se aplica: aqui você mede para **descobrir** o kerf.

## Resumo dos tempos

| Exercício | Tempo | Lote | Quando a peça volta |
| --- | --- | --- | --- |
| 1. Chaveiro | 45 min + 15 min de medição | Lote 1 | Durante o intervalo |
| 2. Caixa | 45 min | Lote 2 (fila contínua) | Antes da montagem |
| 3. Peça livre | 35 min | Lote 3 (se houver máquina) | No encerramento |
| Montagem e entrega | 25 min | | |

---

Capítulo anterior: [04-do-modelo-ao-corte.md](04-do-modelo-ao-corte.md)
Próximo capítulo: [06-economia-criativa.md](06-economia-criativa.md)
