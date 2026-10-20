# Capítulo 1. A laser e os materiais

Apostila do minicurso "Modelagem 3D com IA generativa para corte a laser".
I EECri 2026, FAVAG, Nova Porteirinha (MG), 07/11/2026.
Parceira do minicurso: Laser One, laser1.one.

Este capítulo explica o que a máquina faz com o material. Quem entende isso desenha peças que cortam bem na primeira tentativa. Os valores de potência e velocidade da máquina do laboratório não estão aqui: eles saem de um teste feito na própria máquina e chegam a você numa folha à parte, no dia do minicurso.

## 1. Como a laser CO2 corta e grava

- Um tubo de vidro com gás CO2 produz um feixe de luz infravermelha. **O feixe é invisível.**
- Espelhos levam o feixe até o cabeçote. Uma lente concentra o feixe num ponto muito pequeno, o **ponto focal**.
- No ponto focal a energia é tão concentrada que o material esquenta, queima ou vaporiza.
- Três sistemas de apoio trabalham junto com o feixe:
  - a **exaustão** puxa a fumaça para fora;
  - o **ar assistido** sopra um jato de ar no ponto de corte (afasta a fumaça e reduz a chama);
  - a **refrigeração** (um *chiller*, que é uma máquina de água gelada, ou uma bomba com reservatório) esfria o tubo. Sem água circulando o tubo pode rachar.

A máquina faz três tipos de trabalho:

| Trabalho | O que o feixe faz | Como aparece no software |
| --- | --- | --- |
| Corte | Percorre o contorno e atravessa o material | Modo de linha: "Line" (LightBurn) ou "Cut" (RDWorks) |
| Gravação por preenchimento | Varre a área linha por linha e queima só a superfície | "Fill" (LightBurn) ou "Scan" (RDWorks) |
| Marcação em linha | Percorre um contorno com pouca potência, sem atravessar | Modo de linha com potência baixa |

A laser CO2 trabalha bem em madeira, MDF, acrílico, couro, papel e papelão. Ela **não corta metal**.

## 2. Os ajustes que mudam o resultado

| Ajuste | O que é | O que muda no resultado |
| --- | --- | --- |
| Potência | Porcentagem da potência máxima do tubo | Mais potência queima mais fundo e alarga o corte |
| Velocidade | Quão rápido o cabeçote anda. Em mm/s na maioria dos casos; alguns programas usam mm/min, que dá um número 60 vezes maior | Mais velocidade, menos energia em cada milímetro |
| Passes | Quantas vezes o feixe repete o mesmo caminho | Mais passes cortam mais fundo, mas exigem que a peça não se mova |
| Foco | Distância entre o bico e o material em que o ponto é o menor possível | Foco errado deixa o corte largo e fraco e a gravação borrada |
| Intervalo entre linhas | Só na gravação: distância entre uma linha de varredura e a seguinte | Intervalo menor deixa a gravação mais escura e mais demorada |
| Ar assistido | Jato de ar no ponto de corte | Menos chama e menos mancha de fumaça |

Regra prática: a energia que chega ao material em cada milímetro cresce com a potência e cai com a velocidade (energia por mm é aproximadamente potência dividida por velocidade).

**Como achar os valores certos.** Cada combinação de máquina, tubo, lente e material tem os seus. Não confie em tabelas de internet nem na resposta de um assistente de IA. Use o **teste de potência x velocidade**: uma grade de quadrados, cada um cortado com uma combinação diferente. O arquivo `teste-potencia-velocidade.scad` desenha a grade (o LightBurn também tem um gerador de teste de material, o *Material Test*, no menu Laser Tools; conferir na versão instalada). Depois do teste:

1. Escolha a combinação **mais rápida** que corta de lado a lado em um só passe, com borda limpa.
2. Some uma pequena margem de potência, para cobrir a variação da chapa.
3. Anote o par (potência, velocidade) por material e espessura.

**Foco.** Ajuste com o calço de foco da máquina ou com o foco automático, se houver. Peça ao monitor do laboratório para conferir. Chapa empenada tem foco diferente em cada ponto: segure a chapa plana.

**Passes.** Para MDF de 3 mm o ideal é um passe. Se a máquina não atravessa, primeiro confira foco, limpeza da lente e velocidade. Dois passes só se a peça não pode se mexer entre eles.

**Ordem do trabalho.** Primeiro grave, depois corte. Depois de cortada, a peça pode se mover e a gravação sairia fora do lugar.

## 3. Os materiais do minicurso

### MDF (3 mm)

MDF é chapa de fibras de madeira coladas com resina e prensadas.

- **Corte:** a borda fica escura (carbonizada) e suja a mão. A resina faz mais fumaça que a madeira maciça. A chapa pode ter densidade irregular: um ponto corta fácil e o vizinho não.
- **Gravação:** no MDF cru, marrom escuro, com bom contraste; no resinado, depende da cor da resina (a conferir no ensaio). Letras pequenas pedem fonte grossa.
- **Cuidados:** use MDF **cru** ou MDF **resinado** de fornecedor conhecido (o da turma é o resinado da Meraki; espera-se que a gravação remova a resina colorida e exponha o miolo, a conferir no ensaio de 04/11). Nunca MDF com revestimento de origem desconhecida. Fita crepe na face de cima reduz a mancha de fumaça e sai depois do corte. Chapa empenada deve ser pesada ou presa na mesa.
- **Acabamento:** lixa fina na borda. Use máscara PFF2 para lixar.

### Acrílico (3 mm)

Acrílico (PMMA) é um plástico rígido e transparente ou colorido.

- **Corte:** a borda sai lisa e brilhante. Pode haver chama na linha de corte. **Nunca deixe a máquina cortando acrílico sem alguém olhando.**
- **Gravação:** marca fosca esbranquiçada. Acrílico fundido (*cast*) costuma gravar com mais contraste que o extrudado; peça ao fornecedor para informar o tipo. Cor escura realça a marca clara.
- **Cuidados:** a película protetora fica no corte, para evitar mancha de fumaça, e sai depois. Para gravar, teste com e sem a película em um retalho. A fumaça tem cheiro adocicado forte: exaustão ligada sempre.
- **Evite:** policarbonato (parece acrílico e não é; veja a tabela da seção 4).

### Couro

- **Qual couro:** natural, curtido ao vegetal, de origem conhecida, sem acabamento plástico.
- **Corte:** couro fino corta em um ou dois passes. A borda escurece e o cheiro é forte.
- **Gravação:** marrom escuro, muito legível. É o melhor uso do couro na laser.
- **Cuidados:** couro ondula; prenda as bordas com fita ou pesos. Teste em retalho antes da peça.
- **Nunca:** couro sintético, couro "ecológico" ou qualquer couro de origem desconhecida.

## 4. O que não cortar

**Regra de ouro: material que ninguém sabe o que é não entra na máquina.** Quem decide é o monitor do laboratório. Material trazido de fora só entra depois de identificado.

| Material | Por que não |
| --- | --- |
| PVC e vinil (inclui adesivo de vinil e placas de "plástico" desconhecidas) | O cloro vira gás tóxico e ácido corrosivo que ataca a máquina e a pessoa |
| Couro sintético e "couro ecológico" | Muitos têm PVC na camada de acabamento |
| Policarbonato | Corta mal, solta fuligem e pode pegar fogo |
| ABS | Derrete em vez de vaporizar e solta fumaça tóxica |
| Isopor, EPS e espuma de poliestireno ou polipropileno | Derretem e pegam fogo com facilidade |
| Fibra de vidro, fibra de carbono, materiais com epóxi | A resina solta fumaça tóxica |
| Teflon (PTFE) | Fumaça tóxica |
| Metais | O laser CO2 não corta; superfície polida ainda reflete o feixe |
| Espelho e vidro | Não cortam; a superfície reflete ou estilhaça |
| MDF ou compensado com revestimento desconhecido | O revestimento pode conter PVC ou resinas que soltam fumaça tóxica |

## 5. Fumaça e exaustão

- A fumaça do corte tem partículas e gases irritantes. O MDF solta fumaça de resina e o acrílico solta vapores de cheiro forte.
- A exaustão liga **antes** do primeiro disparo e só desliga alguns minutos depois do último, quando a fumaça sai da máquina.
- Se a exaustão falhar, o trabalho para. Não existe corte sem exaustão.
- Quem tem asma, rinite alérgica forte ou sensibilidade a odor deve avisar o instrutor e ficar longe da saída de ar da máquina.

## 6. Kerf: o que é, como medir e onde compensar

**Kerf** é a largura da faixa de material que o feixe remove ao cortar. Em laser CO2 costuma ficar entre 0,1 e 0,3 mm, mas só o teste diz o da máquina e do material do dia. Ele muda com o material, a espessura, o foco, a potência e a velocidade. Também pode ser diferente na direção X e na direção Y.

O feixe corta ao longo da linha do desenho e remove metade do kerf de cada lado dessa linha. Resultado:

- **a peça fica menor** que o desenho (um quadrado de 20 mm sai com cerca de 20 mm menos o kerf);
- **o furo fica maior** que o desenho (um furo de 10 mm sai com cerca de 10 mm mais o kerf).

Num encaixe, isso aparece como folga: o dedo sai mais estreito, a fenda sai mais larga e a caixa fica frouxa.

### Como medir (5 minutos)

1. Corte um quadrado de 20 mm (o arquivo `teste-kerf.scad` tem quadrados e fendas para isso), **sem compensação** no software.
2. Meça o quadrado com o paquímetro, nas duas direções.
3. **Kerf = 20 mm menos a medida.** Se o quadrado saiu com 19,8 mm, o kerf é 0,2 mm.
4. Se quiser conferir, meça também um furo cortado: a medida do furo menos o tamanho desenhado deve dar um número parecido.

### Onde compensar

**No software de corte. Nunca na geometria.** Nenhum modelo desta apostila embute o kerf no desenho.

- **LightBurn:** campo *Kerf Offset*, nas configurações da camada de corte (modo de linha). Valor positivo aumenta o contorno; negativo diminui. Só vale para formas fechadas. O programa mostra "Inward" ou "Outward" ao lado do campo (conferir na versão instalada; fonte no fim do capítulo 4).
- **RDWorks:** nos parâmetros avançados da camada de corte, a compensação da largura do corte (no manual em inglês: *Enable sew compensation*, *Sew Direction* e *Sew width*; conferir na versão instalada). Também só vale para formas fechadas.

**Que valor digitar?** A documentação e os usuários divergem sobre se o campo espera o kerf inteiro ou a metade. Por isso o valor se **calibra** com o teste:

1. Comece com o valor da conta: metade do kerf medido (o deslocamento necessário de cada lado).
2. Corte o quadrado de 20 mm outra vez e meça.
3. Se saiu menor que 20 mm, aumente o valor; se saiu maior, diminua. Repita até medir 20,0 mm.
4. Confira também um furo (a direção da compensação é diferente para peças e furos).

### Por que fora da geometria

- O kerf pertence ao processo (máquina, material, velocidade), não à peça. O mesmo arquivo precisa funcionar em outra máquina.
- Se o desenho já tem o kerf e o software compensa de novo, a peça fica errada duas vezes.
- A folga que o desenho precisa ter é a do **encaixe**. Ela é uma decisão de projeto e tem nome nos modelos: `clearance`.

| | Kerf | Folga (`clearance`) |
| --- | --- | --- |
| De quem é | Do processo (máquina e material) | Do projeto (o encaixe que você quer) |
| Onde entra | No software de corte | No arquivo `.scad` |
| Como se descobre | Teste de kerf com paquímetro | Teste de encaixe em retalho |

## 7. Segurança

Valem para todo o minicurso. O instrutor repete as regras no início.

1. **Só o monitor do laboratório e o instrutor operam a máquina.** Você entrega o arquivo e retira a peça quando autorizado.
2. **Nunca deixe a laser cortando sozinha.** Todo corte pode pegar fogo: MDF, acrílico e couro. Alguém olha o corte do começo ao fim.
3. **Tampa fechada durante o trabalho.** Nunca desative o intertravamento (o sensor que desliga o laser quando a tampa abre) e nunca abra a tampa com o laser em operação.
4. **O feixe é invisível.** Não coloque a mão nem objetos na área de trabalho com a máquina ligada.
5. **Chama:** avise em voz alta. O monitor para o trabalho e usa o extintor se a chama continuar. Todos se afastam e seguem a orientação do monitor.
6. **Exaustão ligada antes do primeiro disparo** e depois do último.
7. **Material só o que o monitor entregou.** Veja a lista da seção 4.
8. **Cabelo preso, sem cordão ou pulseira solta perto da máquina, calçado fechado.**
9. **Atrás da faixa.** Perto da máquina ficam só as duplas chamadas para a conferência de fila.
10. **Peça recém-cortada está quente e com farpa.** Espere esfriar e use luvas ao tirar da mesa.
11. **Lixa e cola com óculos e máscara PFF2.** Poeira de MDF irrita as vias respiratórias. Cola instantânea em local ventilado.
12. **Qualquer pessoa pode gritar "para!".** O monitor decide como parar.

---

Próximo capítulo: [02-ia-generativa-para-cad.md](02-ia-generativa-para-cad.md)
