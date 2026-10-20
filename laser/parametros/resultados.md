# Resultados do ensaio na laser (quarta 04/11/2026)

Preencher durante o teste, bloco a bloco (`../ensaio-laser.md`). Uma linha por tentativa. Células em branco são para escrever à mão ou no notebook. Registre a unidade que o software mostra (mm/s ou mm/min).

| Campo | Valor |
| --- | --- |
| Data e hora de início | |
| Responsável do laboratório | |
| Telefone do responsável | |

## Máquina (blocos 1 e 2)

| Item | Valor lido | Observação |
| --- | --- | --- |
| Fabricante e modelo da máquina | | |
| Controladora (Ruida, confirmado em 13/10/2026; modelo no painel) | | |
| Versão de firmware | | |
| Conexão com o computador (USB, rede, pendrive) | | |
| Software e versão | | |
| Licença (tipo, vale para a controladora?) | | |
| Importa SVG? Importa DXF? Formas chegam fechadas? | | |
| Contorno da tag medido no software depois de importar o SVG e o DXF (esperado 60 x 25 mm) | | |
| Unidade que o software assumiu para o DXF (o DXF do OpenSCAD não declara unidade) | | |
| O `chaveiro-tag-combinado.svg` chegou com camadas por cor (vermelho e azul)? | | |
| Potência nominal do tubo (W) | | |
| Potência máxima de operação autorizada (%) | | |
| Lente (distância focal) | | |
| Bico (diâmetro, estado) | | |
| Área útil medida (X x Y, mm) | | |
| Mesa (tipo, planicidade, limpeza) e curso de Z | | |
| Ar assistido | | |
| Exaustão | | |
| Chiller (modelo, temperatura ao ligar, depois de 10 min) | | |
| Extintor (tipo, validade) | | |
| Computadores do laboratório (quantidade, sistema, OpenSCAD, Inkscape, internet) | | |

## Espelhos (bloco 3)

| Teste | Manchas coincidem? | Centradas? | Foto | Região segura da mesa |
| --- | --- | --- | --- | --- |
| Espelho 1 para espelho 2 (perto e longe) | | | | |
| Espelho 2 para espelho 3 (perto e longe) | | | | |
| Bico, canto frente esquerdo | | | | |
| Bico, canto frente direito | | | | |
| Bico, canto trás esquerdo | | | | |
| Bico, canto trás direito | | | | |
| Bico, centro | | | | |

## Foco (bloco 4)

| Método | Material | Distância bico-material no foco (mm) | Leitura de Z no painel | Repetiu? | Observação |
| --- | --- | --- | --- | --- | --- |
| | | | | | |
| | | | | | |

## Corte: potência x velocidade (bloco 5)

| Material | Espessura medida (mm) | Rodada | Potência % | Potência mín. % | Velocidade mm/s | Passes | Foco (mm) | Resultado | Kerf medido (mm) | Observação |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| MDF | | 1 | | | | | | | | |
| MDF | | 2 | | | | | | | | |
| MDF | | 2 | | | | | | | | |
| Acrílico | | 1 | | | | | | | | |
| Acrílico | | 2 | | | | | | | | |
| Couro | | 1 | | | | | | | | |

Resultado: escreva cortou ou não cortou, e a qualidade da borda (boa ou ruim). Para cada rodada, anote também a lista de velocidades e de potências usada no arquivo. No teste, a potência mínima é igual à máxima (nome dos campos: conferir no painel e no software).

## Kerf (bloco 6)

| Material | Espessura (mm) | Potência % | Velocidade mm/s | Posição na mesa | Quadrado X (mm) | Quadrado Y (mm) | Média dos 4 dentes (mm) | Kerf externo (mm) | Offset digitado | Quadrado depois do offset (mm) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| | | | | centro | | | | | | |
| | | | | frente esquerda | | | | | | |
| | | | | trás direita | | | | | | |
| | | | | | | | | | | |

Kerf externo = 20,00 menos a média dos lados do quadrado (conferência: 6,00 menos a média dos quatro dentes ao lado das ranhuras de 2,0 mm ou mais). Se a dispersão entre posições passar de 0,05 mm, o problema é foco ou mesa.

| Dado | Valor |
| --- | --- |
| Dispersão entre posições (maior menos menor, mm) | |
| Kerf adotado (mm) | |
| Offset digitado no software (mm, com o sinal) | |

Conferência com ranhuras (medida interna, não entra na média):

| Ranhura nominal (mm) | Largura medida (mm) | Kerf (medida menos nominal) |
| --- | --- | --- |
| 1,0 | | |
| 1,5 | | |
| 2,0 | | |
| 2,5 | | |
| 3,0 | | |

## Gravação (bloco 7)

| Material | Camada | Modo | Potência % | Velocidade mm/s | Intervalo de linha (mm) | Texto legível? | Listras? | Registro das camadas | Observação |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| MDF | Amostra 1 | preenchimento | | | | | | | |
| MDF | Amostra 2 | preenchimento | | | | | | | |
| MDF | Amostra 3 | preenchimento | | | | | | | |
| | | | | | | | | | |

| Registro das camadas | Valor |
| --- | --- |
| O SVG alinhou sozinho? | |
| Foi preciso DXF, PLT ou digitar X e Y? Qual método funcionou? | |

## Encaixe (bloco 8)

| Material | Espessura medida (mm) | Offset de kerf | `clearance` testado | Resultado (folgado, ok ou apertado) | Esquadro (diferença das diagonais, mm) | Observação |
| --- | --- | --- | --- | --- | --- | --- |
| MDF | | | | | | |
| MDF | | | | | | |
| MDF | | | | | | |

## Fila do minicurso (bloco 9)

| Chapa (mm) | Peças na chapa | T_prep (min) | T_maq (min) | T_desc (min) | Ciclo sequencial (min) | Ciclo em paralelo (min) | Peças boas | Peças por hora |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| | | | | | | | | |
| | | | | | | | | |

| Dado | Valor |
| --- | --- |
| Vagas do minicurso (organização) | |
| Peças por participante | |
| Minutos de laser reservados | |
| t1: tempo do lote ÷ número de chaveiros, em segundos (tag de 70 x 25 mm, texto de 8 mm) | |
| Tempo de corte da caixa de 80 x 60 x 40 mm (min) | |
| Tempo de gravação dos nomes da caixa de 80 x 60 x 40 mm (min) | |
| Capacidade (chapas x peças boas) | |
| Demanda (vagas x peças) | |
| Capacidade maior ou igual a 1,3 vez a demanda? | |

## Decisão go/no-go (bloco 10)

| # | Critério | Aprovado? (sim, não, parcial) | Observação |
| --- | --- | --- | --- |
| 1 | Segurança | | |
| 2 | Máquina e software | | |
| 3 | Alinhamento | | |
| 4 | Foco | | |
| 5 | MDF 3 mm: corte | | |
| 6 | Kerf e encaixe | | |
| 7 | Gravação | | |
| 8 | Vazão | | |
| 9 | Acrílico (opcional) | | |
| 10 | Couro (opcional) | | |

| Campo | Valor |
| --- | --- |
| Cenário adotado (A a F de `../ensaio-laser.md`) | |
| Decidido por | |
| Hora | |

## Parâmetros adotados no minicurso

Esta é a tabela que vai para a apostila. Preencha só com valores que passaram nos blocos 5 a 8. Depois copie os valores para `folha-parametros.md`, a folha de uma página que vai impressa para a aula.

| Material | Espessura (mm) | Operação | Potência % | Potência mín. % | Velocidade mm/s | Passes | Foco (mm) | Offset de kerf | Intervalo de linha (mm) | Observação |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| MDF | | Corte | | | | | | | | |
| MDF | | Gravação | | | | | | | | |
| Acrílico | | Corte | | | | | | | | |
| Acrílico | | Gravação | | | | | | | | |
| Couro | | Corte | | | | | | | | |
| Couro | | Gravação | | | | | | | | |

| Parâmetro dos modelos | Valor adotado |
| --- | --- |
| `thickness` (espessura medida do MDF) | |
| `clearance` | |
| `finger_width` | |
| Região segura da mesa (cm a partir da origem) | |
| Software e formato de arquivo (SVG, DXF, PLT) | |
| Tempo de ciclo por chapa de chaveiros (min) | |
