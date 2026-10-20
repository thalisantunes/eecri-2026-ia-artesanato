# Capítulo 2. IA generativa para CAD

Apostila do minicurso "Modelagem 3D com IA generativa para corte a laser".

Aqui você aprende a conversar com um assistente de IA para ele escrever o desenho da peça, e a conferir o que ele escreveu antes de gastar material.

## 1. A ideia em poucas linhas

- **CAD** é desenho técnico feito no computador. O **OpenSCAD** é um CAD por código: em vez de desenhar com o mouse, você descreve a peça com texto e números, e o programa desenha. Ele é gratuito.
- Um **assistente de IA** (claude.ai, ChatGPT, Gemini ou equivalente) é um programa que escreve texto, inclusive código, a partir de um pedido em português. O nome técnico é **LLM** (modelo de linguagem grande).
- Juntando os dois: você descreve a peça, o assistente escreve o código, o OpenSCAD desenha e exporta o arquivo, e o software da laser corta.
- Um arquivo **SVG** é um desenho vetorial: guarda linhas e curvas como números, não como pontinhos de imagem. É o arquivo que o OpenSCAD entrega e que o software da laser abre.

```
descrever  ->  código  ->  desenho  ->  arquivos SVG  ->  software da laser  ->  peça
 (você)     (assistente)  (OpenSCAD)   (um por camada)   (LightBurn/RDWorks)    (laser)
```

O título fala em "modelagem 3D" porque você pensa a peça em três dimensões (uma caixa, por exemplo) e depois a desmonta em placas planas, que são o que a laser corta.

Você não precisa saber programar. Precisa saber **descrever com números** e **conferir com método**. O resto o assistente faz.

## 2. Como o assistente escreve o código, e o que ele faz bem e mal

O assistente foi treinado com muito texto e muito código público, inclusive OpenSCAD. Ele escreve o código **trecho por trecho, prevendo o que é mais provável** para o seu pedido. Ele não desenha, não mede e não roda o código (a não ser que tenha uma ferramenta que faça isso, como o Claude Code com o mcp-openscad, que o instrutor usa). Por isso o resultado é **plausível, não garantido**: quem roda, olha e mede é você.

| Faz bem | Faz mal |
| --- | --- |
| Escrever a estrutura do arquivo, com parâmetros nomeados e comentados | Contas geométricas finas: encaixes que fecham, alinhamento de dedos, folgas |
| Repetir padrões (furos em linha, lote de nomes) | Respeitar uma regra dita lá no começo da conversa, depois de muitas mensagens |
| Mudar um parâmetro quando você pede com clareza | Saber se a peça "ficou bonita" ou "ficou certa": ele não enxerga a peça, a não ser que você mande uma imagem |
| Explicar uma mensagem de erro | Conhecer a versão do seu OpenSCAD: pode usar recursos que ela não tem |
| Sugerir variações | Dizer potência e velocidade de uma máquina que ele nunca viu: ele inventa números plausíveis |

O assistente responde com confiança mesmo quando erra. **Confie no console do OpenSCAD, no desenho na tela e no paquímetro. Não confie no tom da resposta.**

## 3. Pensar em parâmetros

Um **parâmetro** é um número com nome. Uma peça é uma lista de números: mudar o número muda a peça, sem redesenhar.

Exemplo, o chaveiro:

| Parâmetro | Significado | Valor |
| --- | --- | --- |
| `width` | largura da peça | 70 mm |
| `height` | altura da peça | 25 mm |
| `hole_diameter` | diâmetro do furo da argola | 4,5 mm |
| `label` | texto gravado | "MARIA" |
| `font_size` | tamanho das letras (o `size` do OpenSCAD) | 8 mm |

Trocar `"MARIA"` por `"JOÃO"` gera outro chaveiro em segundos. Trocar `width` de 70 para 80 gera uma versão maior. É isso que torna um arquivo reutilizável (capítulo 6).

Convenções desta apostila:

- nomes dos parâmetros em **inglês** (é como o código funciona), sem acento;
- comentários em **português**, sempre com a unidade (mm);
- todos os parâmetros **no começo** do arquivo;
- tudo em **milímetros**.

## 4. Como descrever uma peça: a receita de sete itens

Um bom pedido responde a estas sete perguntas. Os itens 1 a 6 mudam a cada peça. O item 7 é fixo e vai num texto que você cola uma vez no começo da conversa (o "Bloco base", no capítulo 3).

| # | Pergunta | Exemplo |
| --- | --- | --- |
| 1 | O que é a peça e para que serve? | "Chaveiro para lembrancinha de formatura" |
| 2 | Qual material e qual espessura **medida**? | "MDF de 3 mm. Medi 2,9 mm com paquímetro" |
| 3 | Quais medidas, em milímetros? Externas ou internas? | "Caixa de 80 x 60 x 40 mm, medidas externas" |
| 4 | Quais furos e recortes? Diâmetro e posição? | "Furo de 4,5 mm, a 3,5 mm da borda esquerda (da borda da peça até a borda do furo)" |
| 5 | Qual texto ou desenho gravado? Que altura de letra? | "Nome em maiúsculas, letras de 8 mm" |
| 6 | Quais encaixes, e que folga? | "Encaixe de dedos, folga de 0,1 mm" |
| 7 | Em que formato quero a resposta? | "OpenSCAD 2021.01, só 2D, camadas cut e engrave" |

Dicas que fazem diferença:

- **Número no lugar de adjetivo.** "Pequena" não diz nada; "80 x 60 x 40 mm" diz tudo.
- **Diga se a medida é externa ou interna.** É a causa número um de caixa que não serve.
- **Uma peça por pedido.** Comece simples e vá pedindo mudanças.
- **Diga o que não fazer.** "Não compense o kerf" e "nada de 3D no topo" evitam erros clássicos.
- **Peça confirmação de dúvida.** "Se algo estiver ambíguo, pergunte antes de escrever."

## 5. A anatomia do código que você quer receber

O arquivo abaixo é um chaveiro completo. Foi renderizado no OpenSCAD 2021.01 e exportado nas duas camadas. Leia as partes: todo código bom desta aula tem esse formato.

```openscad
// Chaveiro com nome, esqueleto didatico.
// Todas as medidas em milimetros. Nenhuma compensacao de kerf aqui.

// ---- parametros ----
layer = "cut";            // [cut, engrave]
width = 70;               // largura da peca
height = 25;              // altura da peca
corner_radius = 4;        // raio dos cantos
hole_diameter = 4.5;      // diametro do furo da argola
hole_margin = 3.5;        // da borda da peca ate a borda do furo
label = "MARIA";          // texto gravado
font_size = 8;            // tamanho desejado das letras
bold = true;              // negrito: mais legivel quando gravado
text_margin = 3;          // folga entre o texto e as bordas ou o furo
registration = true;      // marcas de registro: mesmo quadro nos dois SVG
registration_offset = 3;       // distancia das marcas ate a peca
registration_diameter = 0.6;   // diametro de cada marca
registration_fn = 16;          // lados do circulo de cada marca
$fn = 64;

// ---- calculos ----
text_x0 = hole_margin + hole_diameter + text_margin;   // inicio da area do texto
text_w = width - text_x0 - text_margin;                // largura livre do texto
fit_size = min(font_size, text_w / len(label));
echo(str("peca: ", width, " x ", height, " mm; texto com tamanho ", fit_size));

// ---- formas ----
module outline() {
    offset(r = corner_radius) offset(delta = -corner_radius)
        square([width, height]);
}

module hole() {
    translate([hole_margin + hole_diameter / 2, height / 2])
        circle(d = hole_diameter);
}

module label_text() {
    translate([text_x0 + text_w / 2, height / 2])
        text(label, size = fit_size,
             font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans",
             halign = "center", valign = "center");
}

module registration_marks() {
    if (registration) {
        translate([-registration_offset, -registration_offset])
            circle(d = registration_diameter, $fn = registration_fn);
        translate([width + registration_offset, height + registration_offset])
            circle(d = registration_diameter, $fn = registration_fn);
    }
}

// ---- saida: so 2D no topo ----
if (layer == "cut") {
    difference() { outline(); hole(); }
    registration_marks();
} else if (layer == "engrave") {
    label_text();
    registration_marks();
}
```

| Parte | Para que serve |
| --- | --- |
| Bloco "parametros" | Todos os números que você pode mudar, com nome e unidade |
| `layer = "cut"; // [cut, engrave]` | Escolhe o que sai no arquivo: corte ou gravação. O comentário entre colchetes faz o painel Customizer do OpenSCAD mostrar uma lista de opções |
| `registration`, `registration_offset`, `registration_diameter`, `registration_fn` | Marcas de registro: ligadas ou não, distância até a peça, diâmetro e lados do círculo (veja abaixo) |
| Bloco "calculos" | Contas derivadas dos parâmetros, para você não repetir números |
| `module` | Uma forma com nome (`outline`, `hole`, `label_text`). Facilita ler e mudar |
| `difference()` | Subtrai uma forma da outra. É o que faz um furo ser furo de verdade |
| `offset(r = ...) offset(delta = ...)` | Arredonda os cantos de um retângulo |
| `if (layer == ...)` no fim | Decide o que vai para cada camada. Só aparece 2D |
| `echo(...)` | Escreve no console as medidas finais, para você conferir |

**Tamanho do texto.** O `size` do OpenSCAD não é exatamente a altura da letra maiúscula: com `size = 8` em Liberation Sans Bold, a maiúscula mede cerca de 7,6 mm.

**Por que duas camadas (`layer`).** A versão 2021.01 do OpenSCAD exporta SVG numa cor só. Então o arquivo vai para o OpenSCAD duas vezes: uma com `layer = "cut"` (o que corta) e outra com `layer = "engrave"` (o que grava). No software da laser, cada SVG vira uma camada com ajustes diferentes. O capítulo 4 mostra como. Os arquivos de apoio do repositório trazem também um SVG **combinado**, com o corte em vermelho e a gravação em azul: ele é o arquivo principal para o LightBurn, que separa as camadas por cor (conferir na versão instalada). O código que o assistente escreve gera um arquivo por camada.

**Por que marcas de registro.** O OpenSCAD escreve o "quadro" de cada SVG a partir do que existe naquele arquivo. O arquivo de gravação (só o nome) tem um quadro menor que o arquivo de corte (a peça inteira). Alguns programas posicionam cada arquivo importado pelo centro do quadro. Resultado: o nome aparece deslocado dentro da peça. As marcas de registro são dois pontinhos de 0,6 mm, fora da peça, **iguais nos dois arquivos**. Com elas, os dois quadros ficam idênticos e as camadas **devem alinhar**; confira as marcas na prévia do software. O instrutor confirma no ensaio de 04/11 (bloco 2 de `laser/ensaio-laser.md`, e o bloco 7 se houver outra janela) como o programa do laboratório posiciona os dois arquivos. Depois de conferir o alinhamento você pode apagar as marcas no software de corte.

Nada neste arquivo compensa o kerf. A única folga permitida é `clearance`, nos encaixes (capítulo 3).

## 6. O ciclo de trabalho: pedir, rodar, olhar, medir, ajustar

Este é o ciclo que você repete em cada exercício:

1. **Peça** ao assistente (Bloco base uma vez, depois o pedido da peça).
2. **Copie** o código (use o botão "copiar" do bloco de código; não selecione com o dedo).
3. **Cole** no editor do OpenSCAD (Ctrl+A para selecionar tudo, Ctrl+V para colar) e salve com um nome, por exemplo `chaveiro-v1.scad`.
4. **Renderize** com **F6**. Para peças 2D é rápido.
5. **Leia o console**, a janela de texto embaixo. Procure `ERROR` e `WARNING`.
6. **Olhe a peça** por cima (menu View, opção Top). Ela aparece como uma chapa fina.
7. **Meça** (veja a seção 8) e **peça um ajuste**: uma mudança por vez, com o nome do parâmetro.

| Tecla | O que faz |
| --- | --- |
| F5 | Pré-visualização rápida. Boa para olhar |
| F6 | Renderização completa. É o que o OpenSCAD usa para exportar. Use F6 antes de exportar |

**Mensagens do console.** Três tipos:

- `ECHO:` é o que o próprio código escreveu (as medidas que você pediu com `echo()`).
- `WARNING:` aviso. **Não exporte com aviso aberto**, sem entender. Um aviso pode significar que o OpenSCAD ignorou parte do seu pedido.
- `ERROR:` erro. Nada é exportado.

Um exemplo real de aviso perigoso: se o código usa uma variável que não existe, o OpenSCAD escreve `WARNING: Ignoring unknown variable` e **exporta mesmo assim**, com uma forma de 1 mm no lugar da peça. Não há erro, o arquivo sai, mas sai errado.

O capítulo 3 tem um dicionário das mensagens mais comuns e o prompt de diagnóstico.

### Como o instrutor trabalha (demonstração)

O instrutor faz o mesmo ciclo com o **Claude Code**, um assistente de IA que roda no terminal e usa ferramentas. Com o **mcp-openscad** (um servidor MCP, que é um conector que dá ao assistente ferramentas para controlar o OpenSCAD) o ciclo vira automático: o assistente escreve o arquivo, valida a sintaxe (`check_syntax`), gera uma imagem (`render_to_png`) e exporta (`export_svg`, `export_dxf`) sem copiar e colar. O resultado é o mesmo arquivo `.scad` e os mesmos SVG que você gera no seu computador. Os geradores prontos do mcp-openscad aceitam um parâmetro `kerf`; nesta aula o kerf no desenho fica sempre em zero.

## 7. Limites e erros típicos do assistente de IA

| Erro | Como aparece | Como conferir | O que pedir |
| --- | --- | --- | --- |
| Unidade errada | Peça gigante ou minúscula | Cabeçalho do SVG, `echo()`, software da laser | "Refaça tudo em milímetros" |
| Recurso que não existe na 2021.01 (`roof`, `fill`, `textmetrics`, bibliotecas) | `WARNING: Ignoring unknown module` ou erro de exportação | Console | "Reescreva sem bibliotecas e sem roof, fill e textmetrics" |
| 3D misturado ao 2D | Com o 3D **antes** do 2D (um `cube` na primeira linha): `Current top level object is not a 2D object` e nada é exportado. Com o 3D **depois** do 2D: só o aviso `Ignoring 3D child object for 2D operation`, e o SVG sai sem o 3D | Console | "Remova qualquer cube, cylinder e linear_extrude" |
| Camada sem nada | A mesma mensagem acima, só numa das camadas | Exporte as duas camadas e veja qual falha | "Com layer igual a engrave, o que será gerado?" |
| Nome de variável trocado | `WARNING: Ignoring unknown variable` e peça de 1 mm | Console | "Use exatamente estes nomes de parâmetros: ..." |
| Furo que não é furo | O círculo aparece, mas a peça continua inteira por baixo | Vista de cima: o furo precisa mostrar o fundo | "Subtraia o furo com difference()" |
| Encaixe que não fecha | Dedos fora de ordem ou em número par | `echo()` com o número de dedos; teste de encaixe em retalho | "Use um número ímpar de dedos e mostre com echo()" |
| Texto que não cabe | Letras passando da peça | Vista de cima | "Reduza o tamanho do texto pelo número de letras" |
| Fonte trocada | O nome sai com outra letra | Menu Help, opção Font List | "Use a fonte Liberation Sans, estilo Bold" |
| Código cortado | Aparecem `...` ou "o resto igual" | Leitura | "Devolva o arquivo completo, sem abreviar" |
| Parâmetros de laser inventados | "Use 80% de potência e 300 mm/s" | Teste de potência x velocidade | "Não sugira potência nem velocidade" |
| Concordância automática | O assistente concorda com tudo que você diz, inclusive com uma conta errada | Medição e conta feita por você | "Mostre a conta passo a passo" |

Se o assistente errar duas vezes no mesmo ponto, **pare de insistir**. Abra um arquivo pronto (`chaveiro-tag.scad`, `caixa-finger-joint.scad` e os demais do pendrive) e peça só ajustes de parâmetro. Leia o começo do arquivo antes: os valores padrão são outros (o `chaveiro-tag.scad` abre com 60 x 25 mm; capítulo 3, "Arquivos de apoio").

Dá para **mandar uma imagem** para o assistente: tire um print da tela do OpenSCAD e pergunte "isto está como pedi? o que está diferente?". Muitos assistentes aceitam imagem e isso melhora o diagnóstico.

## 8. Conferir as medidas antes de cortar

Quatro formas de ver o tamanho, da mais rápida à mais confiável:

1. **`echo()` no console.** Se o código foi pedido com `echo()`, as medidas aparecem em `ECHO:`.
2. **Cabeçalho do SVG.** Abra o arquivo `.svg` no Bloco de Notas. Na terceira linha estão `width` e `height` em milímetros, arredondados **para cima** em milímetros inteiros. Exemplo do chaveiro com as marcas de registro: `width="78mm" height="33mm"`. A peça tem 70 x 25 mm; o resto são as marcas.
3. **Software da laser.** Depois de importar, selecione a peça: largura e altura aparecem com casas decimais.
4. **Paquímetro.** A medida final é a da peça cortada num retalho.

Checklist antes de mandar para a fila:

- [ ] O console não mostra `ERROR` nem `WARNING`.
- [ ] O `echo()` mostra as medidas esperadas.
- [ ] A peça na tela (vista de cima) é a que você pediu.
- [ ] Os furos são furos. O texto está dentro da peça e as letras têm pelo menos 5 mm.
- [ ] Você exportou os **dois** arquivos, com `-cut` e `-engrave` no nome.
- [ ] O cabeçalho do SVG é coerente com as medidas.
- [ ] No software da laser, a peça tem as medidas do desenho (sem escala errada).
- [ ] As camadas estão alinhadas: as marcas de registro dos dois arquivos coincidem.
- [ ] O tempo estimado é razoável para uma peça deste tamanho.
- [ ] Peça nova passa por **teste em retalho**. Encaixe novo passa por **teste de encaixe** antes do lote.

## 9. Do celular para o computador

Quem não tem notebook conversa com o assistente no celular e usa o computador do laboratório para o OpenSCAD. O código precisa passar de um para o outro.

| Opção | Como | Cuidado |
| --- | --- | --- |
| WhatsApp Web | Abra o WhatsApp Web no computador e mande o código para você mesmo ou para o grupo da turma | Funciona bem com texto |
| E-mail | Envie o código para o seu e-mail e abra no computador | Cole o texto no corpo do e-mail, não em anexo formatado |
| Pendrive | Salve o `.scad` num arquivo de texto | Só se o celular tiver saída para pendrive |
| Mesma conta no computador | Abra o assistente no navegador do laboratório | Saia da conta ao terminar |

**Nunca passe o código por Word ou Google Docs.** Esses programas trocam as aspas retas por aspas curvas e o OpenSCAD responde `Parser error: syntax error`. Se o código foi parar num lugar assim, apague as aspas e digite de novo.

## 10. Boas práticas

- Salve **versões**: `chaveiro-v1.scad`, `chaveiro-v2.scad`. Assim você volta atrás quando um ajuste piora a peça.
- Escreva no comentário do topo **o pedido que funcionou**. Daqui a um mês ele explica o arquivo.
- Não cole no assistente dados pessoais nem nomes de clientes sem autorização.
- Anote a **espessura real** do material de cada compra. MDF de 3 mm raramente mede exatamente 3,0 mm.

---

Capítulo anterior: [01-laser-e-materiais.md](01-laser-e-materiais.md)
Próximo capítulo: [03-prompts.md](03-prompts.md)
