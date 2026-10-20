# Folha de parâmetros: laser do laboratório da FAVAG

I EECri 2026, minicurso "Modelagem 3D com IA generativa para corte a laser" (07/11). Uma folha, para imprimir e deixar ao lado da máquina.

Preencher no ensaio de quarta 04/11 só com valores aprovados nos blocos 5 a 9 de `../ensaio-laser.md` que rodarem; os blocos 7 e 9 só rodam se houver outra janela em 05 ou 06/11 (as medidas ficam em `resultados.md`; esta folha é o resumo que a turma e o monitor usam). Os pontos de partida do plano de testes estão nas notas abaixo da tabela: são ordem de grandeza para começar o ensaio, não valor para cortar na aula. Os valores valem só para esta máquina, com este foco, neste material e nesta espessura. Mudou um deles, meça de novo.

## Máquina

| Campo | Valor |
| --- | --- |
| Máquina (fabricante, modelo, potência do tubo) | |
| Controladora | Ruida (confirmado em 13/10/2026). Modelo no painel: |
| Software e versão (LightBurn ou RDWorks) | |
| Unidade de velocidade no software (mm/s, mm/min ou m/min) | |
| Área útil medida da mesa (X x Y, mm) e canto de origem | |
| Modo de início usado (Absolute Coords, User Origin ou Current Position) | |
| Potência máxima de operação autorizada (%) | |
| Foco: distância entre o bico e o material (mm) e altura do calço | |
| Campo do kerf offset no software e sinal (positivo desloca para fora?) | |
| Região segura da mesa (cm a partir da origem), se o bloco 3 restringiu | |
| Arquivo-modelo da turma: onde está (pendrive e pasta no computador da laser) | |
| Preenchido por, data e hora | |

## Parâmetros por material

Modo: Line é corte e Fill é gravação no LightBurn; no RDWorks, Cut e Scan. Nos testes a potência mínima fica igual à máxima; na aula, use o par que o ensaio aprovou.

| Material | Espessura medida (mm) | Operação | Modo | Potência máx. (%) | Potência mín. (%) | Velocidade | Passes | Intervalo de linha (mm) | Kerf offset |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| MDF 3 mm | | Corte | Line / Cut | | | | | não se aplica | |
| MDF 3 mm | | Gravação | Fill / Scan | | | | | | não se aplica |
| Acrílico 3 mm | | Corte | Line / Cut | | | | | não se aplica | |
| Acrílico 3 mm | | Gravação | Fill / Scan | | | | | | não se aplica |
| Couro vegetal | | Corte | Line / Cut | | | | | não se aplica | |
| Couro vegetal | | Gravação | Fill / Scan | | | | | | não se aplica |

Kerf medido (bloco 6): MDF ______ mm, acrílico ______ mm. Texto mínimo legível na gravação (bloco 5, números de 3 mm): ______ mm.

Pontos de partida do plano de testes (bloco 5 e bloco 7):

- Corte em MDF e acrílico: 80 % (ou o limite autorizado) e 10 a 50 mm/s na rodada 1 (velocidades padrão do modelo); adotar a mais rápida que cortou limpo, menos um degrau; 1 passe. Acrílico: ar assistido ligado e alguém ao lado o tempo todo.
- Corte em couro: 60 % e 20 a 60 mm/s.
- Gravação, nos três materiais: 20 a 30 %, 250 a 300 mm/s e intervalo de linha de 0,1 mm (os números da rodada 1 já usam esses valores; o bloco 7 refina só em MDF).

## Valores para os modelos e para a fila

| Parâmetro | Valor | De onde vem |
| --- | --- | --- |
| `thickness` (espessura medida do MDF, em mm) | | bloco 5 |
| `clearance` do encaixe (0 a 0,2 mm) | | bloco 8 |
| `finger_width` | | padrão do modelo (9 mm); o plano não o testa |
| Formato de arquivo que o software importa com formas fechadas (SVG combinado, SVG por camada ou DXF) | | blocos 2 e 7 |
| O software separa o `-combinado.svg` por cor (vermelho corte, azul gravação)? | | blocos 2 e 7 |
| t1 por chaveiro de 70 x 25 mm (segundos): corte ______ gravação ______ | | bloco 9 (planejamento: 25 s e 26 s) |
| Tempo da caixa aberta de 80 x 60 x 40 mm (min): corte ______ gravação ______ | | bloco 8 (o plano de aula usa 3,6 min para a caixa com tampa; para ela, multiplicar o corte medido por 1,10) |
| Ciclo por chapa de chaveiros (min) e peças boas por chapa | | bloco 9 |

## Lembretes

- Kerf nunca entra no desenho: o offset fica no software de corte, calibrado com o quadrado de 20 mm (aprovado entre 19,95 e 20,05 mm).
- Dobradiça viva: kerf offset em zero nessa camada; as ranhuras são mais finas que o kerf.
- Gravação antes do corte, e a chapa não sai do lugar entre as duas operações.
- Mudou material, espessura, foco ou lente: refaça a rodada 1 e o kerf antes de cortar a turma.
- O que não entra na máquina: PVC, vinil, couro sintético, policarbonato, ABS, isopor, couro ao cromo, material sem rótulo (lista completa no bloco 1 do plano de testes e no capítulo 1 da apostila).
