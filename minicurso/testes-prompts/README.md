# Testes dos prompts da apostila

Registro do teste cego dos prompts do capítulo 3 (`../apostila/03-prompts.md`), feito em 13/10/2026. Serve de evidência para a frase "os prompts foram testados" e para repetir o teste com outro assistente.

Os pedidos curtos da oficina (folha `../cola-prompts.md`, slides 12 e 13, AJUSTE e DEU ERRO) foram testados depois, em 20/10/2026, com Claude Haiku, Sonnet e Opus: 19 de 24 respostas passaram. Registro em `2026-10-20/README.md`.

## Como foi feito

1. Cada modelo recebeu só uma conversa pronta (pasta `entradas/`): o Bloco base, a resposta "entendido" e um dos prompts.
2. Pediu-se que respondesse como um assistente de chat, de primeira, sem executar nada. O código foi salvo sem edição (os arquivos `.scad` desta pasta).
3. O OpenSCAD 2021.01 exportou as camadas de cada arquivo e o `check.py` mediu o resultado.

- **Modelos:** Claude Haiku 5.5 (`claude-haiku-5-5`) e Claude Sonnet 5.5 (`claude-sonnet-5-5`), lançados como subagentes do Claude Code.
- **Isolamento:** pelos registros dos subagentes, cada um só leu o arquivo da conversa e devolveu o código, gravado num arquivo de saída (rodadas 1 e 2) ou no relatório final (rodada 3). Nenhum rodou o OpenSCAD nem leu outro arquivo do projeto.
- **Uma resposta por modelo e por prompt.** Nenhuma foi repetida nem escolhida entre várias.

## Rodadas

| Rodada | O que foi enviado | Modelos | Resultado |
| --- | --- | --- | --- |
| 1 | Prompts 1 a 5, versão inicial | Haiku e Sonnet (10 respostas) | Os 10 arquivos exportaram sem aviso. Seis tinham um problema, apontado pela conferência: nome longo que não encolhia e saía da peça (prompts 1 e 5, quatro arquivos) e moldura da placa que tocava os furos (prompt 3, dois arquivos). Os prompts foram corrigidos |
| 2 | Prompts 1 a 5, corrigidos | Haiku (5 respostas) | Todas passaram em todas as conferências |
| 3 | Prompt 4 reescrito para seguir `laser/modelos/dobradica-viva.scad` (fileiras ímpares abrem a borda; sem `corner_radius`) | Haiku e Sonnet (2 respostas) | As duas passaram em todas as conferências. O SVG de cada uma é idêntico ao do modelo do repositório com os mesmos valores |

O Bloco base e os prompts 1, 2, 3 e 5 que estão hoje na apostila são idênticos aos da rodada 2. O Prompt 4 é idêntico ao da rodada 3.

## Arquivos

Os arquivos sem sufixo de rodada (`prompt-4-dobradica-haiku.scad` e `prompt-4-dobradica-sonnet.scad`) são da rodada 3. O de Sonnet traz uma linha de comentário a mais no topo, com a identificação do teste; o resto é a resposta do modelo.

| Arquivo | Modelo | Rodada | Resultado do `check.py` |
| --- | --- | --- | --- |
| `prompt-1-chaveiro-haiku-rodada-1.scad` | Haiku | 1 | 1 problema: nome de 9 letras passa da área do texto |
| `prompt-1-chaveiro-sonnet-rodada-1.scad` | Sonnet | 1 | 1 problema: o mesmo |
| `prompt-1-chaveiro-haiku-rodada-2.scad` | Haiku | 2 | passou em tudo |
| `prompt-2-caixa-haiku-rodada-1.scad` | Haiku | 1 | passou em tudo |
| `prompt-2-caixa-sonnet-rodada-1.scad` | Sonnet | 1 | passou em tudo |
| `prompt-2-caixa-haiku-rodada-2.scad` | Haiku | 2 | passou em tudo |
| `prompt-3-placa-haiku-rodada-1.scad` | Haiku | 1 | 1 problema: moldura a 3,5 mm da borda, tocando os furos |
| `prompt-3-placa-sonnet-rodada-1.scad` | Sonnet | 1 | 1 problema: o mesmo |
| `prompt-3-placa-haiku-rodada-2.scad` | Haiku | 2 | passou em tudo |
| `prompt-4-dobradica-haiku-rodada-1.scad` | Haiku | 1 | receita antiga: passou em tudo |
| `prompt-4-dobradica-sonnet-rodada-1.scad` | Sonnet | 1 | receita antiga: passou em tudo |
| `prompt-4-dobradica-haiku-rodada-2.scad` | Haiku | 2 | receita antiga: passou em tudo |
| `prompt-4-dobradica-haiku.scad` | Haiku | 3 | passou em tudo |
| `prompt-4-dobradica-sonnet.scad` | Sonnet | 3 | passou em tudo |
| `prompt-5-lote-haiku-rodada-1.scad` | Haiku | 1 | 1 problema: o nome longo ("GABRIELA") tem a mesma letra do curto |
| `prompt-5-lote-sonnet-rodada-1.scad` | Sonnet | 1 | 1 problema: o mesmo |
| `prompt-5-lote-haiku-rodada-2.scad` | Haiku | 2 | passou em tudo |

## O que o check.py confere

- **Em todos:** o arquivo exporta as duas camadas (só a `cut`, no Prompt 4); o console não mostra `WARNING` nem `ERROR`; há `echo()`; não há 3D, `roof`, `fill`, `textmetrics`, `include` nem `use`; os parâmetros pedidos estão no topo; as duas camadas têm o mesmo `viewBox`.
- **Prompt 1:** peça de 70 x 25 mm; furo de 4,5 mm a 3,5 mm da borda; duas marcas de registro; texto dentro da área livre; nome de 9 letras que cabe; `width = 80` muda a peça.
- **Prompt 2:** seis peças com as medidas certas; dedos iguais nas quatro pontas de cada par de paredes e complementares entre os pares; fenda 0,1 mm maior que o dedo; com `clearance = 0` o material soma exatamente a altura; `height = 50` e `with_lid = false`.
- **Prompt 3:** placa de 120 x 50 mm; dois furos de 4 mm nos cantos de cima; linhas centralizadas e dentro da largura livre; moldura a 2,5 mm da borda; título longo; `holes = 0`.
- **Prompt 4:** tira de 80 x 50 mm; 25 fileiras e 62 fendas nas posições da receita (vazio no eixo de cada fenda, material ao lado e nas pontes, material em toda a grade fora delas); `width = 70`.
- **Prompt 5:** 8 chaveiros e 8 furos; lote de 143 x 109 mm; grade de 2 colunas por 4 linhas; um texto dentro de cada chaveiro, na ordem da lista; nome longo com letra menor; listas de 3 e de 12 nomes.

## Como repetir

Precisa do OpenSCAD 2021.01 no PATH e do Python 3. Dentro desta pasta:

```bash
python3 check.py p1 prompt-1-chaveiro-haiku-rodada-2.scad
python3 check.py p4 prompt-4-dobradica-sonnet.scad
python3 check.py p4_anterior prompt-4-dobradica-haiku-rodada-1.scad
```

`p4_anterior` confere a receita antiga do Prompt 4 (rodadas 1 e 2), que não vale mais para a apostila.

Para testar outro assistente (por exemplo, o que a turma vai usar): abra uma conversa nova, cole a mensagem 1 de um arquivo de `entradas/rodada-3/` ou `entradas/rodada-2/` (é o Bloco base), espere o "entendido", cole a mensagem 2 (o prompt), salve o código como `.scad` e rode o `check.py`.

## Limites

- Dois modelos da mesma família, só o primeiro rascunho, uma resposta por modelo e por prompt. Sem o claude.ai, o ChatGPT nem o Gemini.
- Os prompts 6 (ajuste) e 7 (diagnóstico) da apostila não foram testados aqui. As versões curtas da folha (AJUSTE e DEU ERRO) foram testadas em 20/10/2026 (`2026-10-20/README.md`).
- O `check.py` mede o que os prompts pedem. Não diz se a peça corta bem na máquina real, nem se o encaixe fecha em MDF de verdade.
- Com o `check.py` de hoje, os arquivos da rodada 1 falham nas conferências que apontaram os problemas descritos acima. É o esperado.
