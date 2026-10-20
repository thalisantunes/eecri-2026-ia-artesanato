# Capítulo 6. Da peça ao produto

Apostila do minicurso "Modelagem 3D com IA generativa para corte a laser".

Uma peça que dá certo uma vez é um experimento. Para virar produto, você precisa saber quanto ela custa, em quantas versões pode existir e quantas dá para fazer. Este capítulo é curto e factual: tem a fórmula, um exemplo de conta e ideias de uso.

## 1. Quanto custa uma peça

O custo de uma peça é a soma de cinco parcelas.

| Parcela | Como calcular |
| --- | --- |
| **Material** | preço da chapa x área da peça ÷ (área da chapa x aproveitamento) |
| **Máquina** | tempo de máquina da peça (min) x custo por minuto da máquina |
| **Mão de obra** | tempo manual por peça (min) x valor do minuto de trabalho |
| **Insumos** | argola, cola, embalagem, etiqueta: o que vai junto com a peça |
| **Perdas** | percentual de peças que se estragam, aplicado sobre a soma das outras parcelas |

- **Aproveitamento** é a fração da chapa que vira peça. Peças encaixadas com folga entre si e bordas da chapa que não se usam deixam o aproveitamento em algo como 50 a 80%. Meça o seu.
- **Custo por minuto da máquina** = custo mensal da máquina ÷ minutos produtivos no mês. O custo mensal reúne energia, manutenção e peças de desgaste (tubo, lente, espelhos), depreciação e espaço. **Quanto mais a máquina trabalha, menor o custo por minuto.**
- **Tempo de máquina** vem do software (a estimativa do *Preview*) e, melhor ainda, do cronômetro: anote quanto durou o lote real.
- **Mão de obra** é o seu tempo: tirar da mesa, limpar, lixar, montar, embalar, atender o cliente. Quem esquece essa parcela trabalha de graça.

**Preço de venda = custo ÷ (1 − margem − taxas)**, com margem e taxas (cartão, plataforma de venda, impostos) como percentuais **do preço**.

### Exemplo de conta (números inventados)

**Os valores desta tabela são fictícios e foram escolhidos para ilustrar a conta. Não são preços de mercado, nem recomendação de preço.** Troque pelos seus.

Peça: chaveiro de MDF de 3 mm, 70 x 25 mm.

| Item | Valor de exemplo | Conta |
| --- | --- | --- |
| Preço da chapa 1200 x 600 mm (0,72 m²) | R$ 60,00 | (dado) |
| Aproveitamento da chapa | 60% | (dado) |
| **Material** | **R$ 0,24** | 60,00 x 0,00175 m² ÷ (0,72 x 0,60) |
| Custo mensal da máquina | R$ 1.800,00 | (dado) |
| Minutos produtivos por mês | 1.800 (30 horas) | (dado) |
| Custo por minuto da máquina | R$ 1,00 | 1.800 ÷ 1.800 |
| Tempo de máquina por chaveiro | 0,85 min (51 s) | valor de planejamento |
| **Máquina** | **R$ 0,85** | 0,85 x 1,00 |
| Valor da hora de trabalho | R$ 24,00 | (dado) |
| Tempo manual por chaveiro | 2 min | (dado) |
| **Mão de obra** | **R$ 0,80** | 2 x 24,00 ÷ 60 |
| **Insumos** (argola R$ 0,30 + embalagem R$ 0,40) | **R$ 0,70** | 0,30 + 0,40 |
| Subtotal | R$ 2,59 | 0,24 + 0,85 + 0,80 + 0,70 |
| Perdas | 5% | 2,59 x 1,05 = R$ 2,72 |
| Margem e taxas | 30% e 10% | |
| **Preço de venda** | **R$ 4,53** | 2,72 ÷ (1 − 0,30 − 0,10) = 2,72 ÷ 0,60 |

O que o exemplo mostra, **com estes números**: o material pesa menos de um décimo do custo; tempo de máquina e mão de obra pesam mais. Com os seus números pode ser diferente: faça a conta.

### Custo de preparo

Preparar o arquivo (ajustar o nome, conferir, testar em retalho) leva tempo, e esse tempo se **dilui no lote**. Com 15 minutos de preparo e a hora a R$ 24,00 do exemplo, o preparo custa R$ 6,00 por lote:

| Peças no lote | Preparo por peça |
| --- | --- |
| 3 | R$ 2,00 |
| 10 | R$ 0,60 |
| 30 | R$ 0,20 |
| 100 | R$ 0,06 |

É por isso que o **arquivo paramétrico** vale dinheiro: com ele o preparo de um pedido novo cai para o tempo de trocar alguns números.

### Quantas peças a máquina faz

Com 51 segundos por chaveiro (valor de planejamento até o teste na máquina real), são cerca de **70 chaveiros por hora de máquina**, sem contar troca de chapa e conferência. Use o tempo real do lote da aula para recalcular. Um pedido de 200 chaveiros ocupa a máquina por cerca de três horas, fora o trabalho manual.

## 2. Uma família de produtos a partir de um arquivo

Um arquivo paramétrico gera **versões** só trocando parâmetros. A mesma ideia vale para tamanho, texto, material e função.

| Arquivo | O que muda nos parâmetros | O que você vende |
| --- | --- | --- |
| Chaveiro | `width`, `height`, `label` | Chaveiros P, M e G; marcadores de livro; etiquetas |
| Chaveiro | `label` | Lembrancinha personalizada (nome de cada convidado) |
| Caixa de encaixe | `length`, `width`, `height` | Caixas P, M e G com a mesma linha visual; embalagem para o que você já produz |
| Caixa de encaixe | `with_lid`, `label` | Caixa aberta ou com tampa gravada |
| Placa | `width`, `title`, `subtitle` | Placas de mesa, de prateleira, de porta, de produto |
| Qualquer um | material (MDF, acrílico, couro) | Uma linha em três acabamentos |

O custo de material cresce com a **área** da peça. No exemplo do chaveiro, um tamanho P (50 x 20 mm) gasta 0,57 vez o material do M (70 x 25 mm), e um G (90 x 30 mm) gasta 1,54 vez. Precifique cada tamanho com a sua conta.

**Presets do Customizer.** O painel Customizer do OpenSCAD guarda conjuntos de valores com nome ("P", "M", "G") num arquivo `.json` ao lado do `.scad`. Trocar de tamanho vira escolher o preset, sem editar código.

## 3. Personalização em lote

Personalizar é o que a laser faz melhor que uma fábrica: o custo de mudar o nome é quase zero.

- O Prompt 5 e o arquivo `chaveiros-lote.scad` colocam uma **lista de nomes** (`labels`) num só arquivo e geram a grade completa, já com o texto de cada nome ajustado ao tamanho.
- Fluxo de uma encomenda: receber a lista de nomes (por escrito, com a grafia conferida pelo cliente), colocar no arquivo, conferir o `echo()`, **testar em retalho**, cortar o lote, conferir uma peça com o cliente se possível, embalar.
- **Confira a grafia antes de cortar.** Nome errado em peça cortada não tem conserto.
- Acentos funcionam na fonte Liberation Sans. Teste o "Ç", o "Ã" e o "É" da lista.

## 4. O que a laser do laboratório permite fazer

A programação do EECri fala em artesanato, souvenirs e lembrancinhas. A laser CO2 atende bem a:

- **Lembrancinhas e brindes:** chaveiros, marcadores, tags e mimos para casamento, formatura, aniversário e evento.
- **Placas:** identificação de ambientes, de produtos, de mesas, de lojas e de barracas de feira.
- **Embalagens:** caixas de encaixe de MDF para doces, velas, cosméticos, kits e presentes, sem cola nem ferramenta de marcenaria.
- **Couro:** etiquetas, chaveiros, porta-cartões e detalhes gravados em artigos de couro natural.
- **Prototipagem:** testar uma peça em MDF antes de investir em material caro.

O que ela **não** faz: cortar metal, trabalhar com PVC ou couro sintético (capítulo 1), nem produzir em escala de fábrica. Para encomendas grandes, calcule o tempo de máquina antes de prometer prazo.

## 5. Cuidados com o produto

- **Marcas e personagens de terceiros:** não reproduza logotipos, marcas ou personagens protegidos em produtos para venda sem autorização.
- **Acabamento:** borda queimada suja a mão. Lixe, escove ou sele conforme o uso (verniz, cera, vedante). Peças que vão para a boca ou para crianças merecem cuidado extra com acabamento e colas.
- **Origem do material:** compre MDF (cru ou resinado), acrílico e couro natural de fornecedor que informe o que é. É segurança sua e da máquina.
- **Guarde o arquivo:** versione (`v1`, `v2`), anote o material e os ajustes que funcionaram. A segunda encomenda vira um ajuste de parâmetro.

## 6. Para aprofundar

Precificação, formalização e venda são assuntos de negócio, não de laser. O **Sebrae** e a **Sala Mineira do Empreendedor**, apoiadores do EECri, são pontos de partida para essas conversas.

---

Capítulo anterior: [05-exercicios.md](05-exercicios.md)
