# Teste cego dos pedidos da oficina, 20/10/2026 (rodadas r1, r2, modelos externos e r4)

Registro do teste dos pedidos curtos da oficina de sábado: a folha `minicurso/cola-prompts.md` e os pedidos dos slides 12 e 13 de `minicurso/slides.md`. O teste de 13/10, dos prompts longos da apostila, está em `../README.md`.

## Método

- **Data:** 20/10/2026.
- **Modelos:** Claude Haiku, Claude Sonnet e Claude Opus. Cada um respondeu como assistente de chat, sem ferramentas: não rodou o OpenSCAD nem leu arquivos do projeto. Uma resposta por modelo e por pedido, sem repetir nem escolher entre várias.
- **O que foi enviado:** as Regras da laser ou da 3D da folha e, depois, o pedido da peça, com o texto que estava na folha e nos slides em 20/10 (antes das correções descritas no fim). No AJUSTE e no DEU ERRO, foi enviado também o código e, no DEU ERRO, a mensagem real do OpenSCAD 2021.01.
- **Render:** o código de cada resposta foi salvo sem edição (`r1/*.scad`) e exportado no OpenSCAD 2021.01: camadas `cut` e `engrave` em SVG na laser e STL na 3D.
- **Checagem por script:** medidas tiradas do SVG e do STL com scripts Python: contorno, furo, posição do texto em relação ao furo e às bordas, marcas de registro, `WARNING` e `ERROR` no console, `echo()`, recursos proibidos (`include`, `use`, `roof`, `fill`, `textmetrics`, `minkowski`), sólido único e estanque, `z_min = 0` e `echo()` igual à caixa da peça. O `../check.py` não foi usado, porque só cobre os prompts 1 a 5 da apostila. As imagens `r1/*.png` foram vistas uma a uma só em parte (ver Limites).

## Resultado do r1

19 de 24 respostas passaram. Nenhuma das 5 reprovadas mostrou erro na tela.

| Caso | Pedido testado | Haiku | Sonnet | Opus |
| --- | --- | --- | --- | --- |
| `laser-chaveiro-maria-folha` | Regras da laser + CHAVEIRO da folha | renderizou; **reprovou** | renderizou; passou | renderizou; passou |
| `laser-chaveiro-maria-slide` | Regras da laser + pedido do slide 12 | renderizou; passou | renderizou; passou | renderizou; passou |
| `laser-lote-chaveiros-acentos` | Regras da laser + LOTE da folha | renderizou; **reprovou** | renderizou; passou | renderizou; **reprovou** |
| `3d-porta-cartao-atelie-folha` | Regras da 3D + PORTA-CARTÃO da folha | renderizou; passou | renderizou; passou | renderizou; passou |
| `3d-porta-cartao-atelie-slide` | Regras da 3D + pedido antigo do slide 13 | renderizou; **reprovou** (ver nota) | renderizou; passou | renderizou; passou |
| `laser-ajuste-maria-para-jose` | AJUSTE (MARIA por JOSÉ) | renderizou; passou (ver nota) | passou (ver nota) | passou (ver nota) |
| `laser-deu-erro-ponto-e-virgula` | DEU ERRO, falta de `;` no chaveiro | renderizou; **reprovou** | renderizou; passou | renderizou; passou |
| `3d-deu-erro-modulo-desconhecido` | DEU ERRO, módulo que não existe no porta-cartão | renderizou; passou | renderizou; passou | renderizou; passou |

### Defeitos por caso

| Caso | Modelo | Defeitos | Arquivos em `r1/` |
| --- | --- | --- | --- |
| chaveiro da folha | Haiku | Letra fixa em 11 mm (`text_size = 11`), sem a redução pedida; a resposta manda o usuário diminuir à mão | `laser-chaveiro-maria-folha-haiku.scad`, `-cut.svg`, `-engrave.svg`, `-cut.png`, `-engrave.png` |
| chaveiro da folha | Sonnet | Passou. A redução da letra usa uma tabela de larguras estimada, não medida; com MARIA deu certo (47,7 mm medidos contra cerca de 49 estimados) | `laser-chaveiro-maria-folha-sonnet.*` |
| chaveiro da folha | Opus | Passou. Estimativa conservadora (1,10 x letras): MARIA ocupa 44 dos 56 mm livres | `laser-chaveiro-maria-folha-opus.*` |
| chaveiro do slide 12 | os três | Passaram sem defeito: contorno 70 x 25, furo de 4,5 mm, texto só na gravação, marcas em (-3, -3) e (73, 28). A resposta do Opus estima o texto em cerca de 33 x 7 mm; o medido é 43,4 x 9,6 mm | `laser-chaveiro-maria-slide-{haiku,sonnet,opus}.*` |
| lote | Haiku | CONCEIÇÃO vai de x 11,46 a 77,05 (limite 67; a peça acaba em 70) e invade o chaveiro vizinho. Todos os nomes ficam com letra 8; o console diz "largura estimada 53.7768 mm" e o real é 65,6 mm. A resposta afirma que o nome cabe | `laser-lote-chaveiros-acentos-haiku.*` |
| lote | Sonnet | Passou: CONCEIÇÃO com letra 6,0, de x 14,46 a 63,68 | `laser-lote-chaveiros-acentos-sonnet.*` |
| lote | Opus | CONCEIÇÃO vai de x 7,21 a 70,98: entra no furo (borda em x = 8,0) e passa da borda direita. Fator de largura 0,80 por letra (linha 16); o console diz "56 mm de 56" e o real é 63,8 mm. A resposta diz que o nome ocupa cerca de 47,5 mm | `laser-lote-chaveiros-acentos-opus.*` |
| porta-cartão da folha | Haiku | Passou. Menores: o código vem sem bloco cercado; o pé passa só 6 mm do topo do encosto | `3d-porta-cartao-atelie-folha-haiku.{scad,stl,png}` |
| porta-cartão da folha | Sonnet | Passou. Menores: números soltos no corpo do código; peça centrada em x = 0 | `3d-porta-cartao-atelie-folha-sonnet.{scad,stl,png}` |
| porta-cartão da folha | Opus | Passou. Nota: as laterais do bolso sobem 18 mm, o encosto 42 mm | `3d-porta-cartao-atelie-folha-opus.{scad,stl,png}` |
| porta-cartão do slide | Haiku | A base vai de y 0 a 23,71 mm e o topo do encosto vai a y 38,71 mm: 15 mm de balanço, com 60 mm de altura. A resposta diz que a peça fica estável. Ver nota | `3d-porta-cartao-atelie-slide-haiku.{scad,stl,png}` |
| porta-cartão do slide | Sonnet, Opus | Passaram sem defeito | `3d-porta-cartao-atelie-slide-{sonnet,opus}.{scad,stl,png}` |
| AJUSTE | os três | Os três `.scad` são idênticos byte a byte (1.406 bytes), com `name = "JOSÉ"`. Camada de gravação de x 24,69 a 53,21 e y 7,64 a 17,59, com o acento. Ver nota | `laser-ajuste-maria-para-jose-{haiku,sonnet,opus}.scad`, `j-cut.svg`, `j-engrave.svg`, `j-cut.png`, `j-engrave.png` |
| DEU ERRO laser | Haiku | Achou o `;` que faltava, mas reescreveu o arquivo inteiro e mudou o que não foi pedido: variável `clearance`, redução automática da letra, 6 `echo()` novos, comentário alterado; o `echo()` final ficou diferente do original. Usa "token" e "sintaxe" sem explicar | `laser-deu-erro-ponto-e-virgula-haiku.{scad,png}`, `-cut.svg`, `-engrave.svg` |
| DEU ERRO laser | Sonnet | Passou. Menores: entrega também o arquivo completo (diz que o resto não muda); "Syntax error" com tradução parcial | `laser-deu-erro-ponto-e-virgula-sonnet.*` |
| DEU ERRO laser | Opus | Passou. Menor: código completo junto do trecho | `laser-deu-erro-ponto-e-virgula-opus.{scad,png}` |
| DEU ERRO 3D | Haiku | Passou. Troca a chamada por `cube` (cantos retos, permitido); entrega o arquivo inteiro | `3d-deu-erro-modulo-desconhecido-haiku.*` |
| DEU ERRO 3D | Sonnet | Passou, com desvio: mudou `wall` de 2,4 para 2,8 mm sem ser pedido (largura 97,6 mm, altura 39,708 mm); a mudança é anunciada na resposta | `3d-deu-erro-modulo-desconhecido-sonnet.*` |
| DEU ERRO 3D | Opus | Passou: caixa e volume idênticos à referência | `3d-deu-erro-modulo-desconhecido-opus.*`, `-opus-semtroca.scad` (variante só para teste) |

Os arquivos `3d-deu-erro-modulo-desconhecido-*-frente.png` e `-lado.png` são vistas extras para conferir o texto e a inclinação.

### Notas sobre os critérios

- **Porta-cartão do slide, Haiku.** O critério "o topo do encosto fica dentro da base" é do avaliador: nem as Regras da 3D nem o pedido do slide o escrevem. Fica registrado como "base não cobre o topo do encosto; pode tombar", não como violação do texto entregue ao participante. O tombamento não foi medido: o centro de volume do STL fica em y = 19,58, dentro da base. O pedido da folha, com "pé atrás para não tombar", passou nos três modelos. Decisão: o slide 13 passou a usar o texto da folha; a regra não entrou nas Regras da 3D.
- **Chaveiro da folha, Haiku.** O defeito "resposta não é curta no turno 1" foi retirado: só a resposta ao pedido da peça foi guardada, e a resposta às Regras ("entendido") não é verificável em nenhum caso. O Haiku reprova só pela letra fixa.
- **AJUSTE.** O `.scad` original com MARIA não foi guardado, e a explicação em até 3 linhas, com o valor antigo e o novo, também não. O "passou" vale só para o código. Só o arquivo do Haiku foi renderizado; os outros dois são idênticos a ele.
- **DEU ERRO 3D.** O arquivo com o erro não existia em disco: foi reconstruído a partir do código do Haiku, com `rounded_plate([body_w, wall, back_h], 2)` na linha 26, e cada resposta foi aplicada a ele. As mensagens de erro foram produzidas de verdade pelo OpenSCAD 2021.01.

## Imagens usadas nos slides

| Arquivo | Origem | Onde |
| --- | --- | --- |
| `minicurso/img/teste-2026-10-20-porta-cartao-opus.png` | `r1/3d-porta-cartao-atelie-folha-opus.png`, só com a margem cortada | slide 9 da oficina |
| `minicurso/img/teste-2026-10-20-lote-haiku-reprovou.png` | `r1/laser-lote-chaveiros-acentos-haiku-cut.svg` e `-engrave.svg` sobrepostos com `combina-camadas.py` (vermelho: contorno de corte; azul: gravação; fundo cor de madeira) | slide 14 da oficina |
| `minicurso/img/teste-2026-10-20-lote-opus-reprovou.png` e `-lote-sonnet-passou.png` | o mesmo, para o Opus e o Sonnet | reserva |

Para refazer: `python3 combina-camadas.py <cut.svg> <engrave.svg> <saida.svg>` e `inkscape <saida.svg> --export-type=png -w 1600`. O código das respostas não é alterado; só as cores mudam.

## Mudanças depois do r1

- **CHAVEIRO e LOTE da folha:** "Se o nome for comprido, diminua a letra" virou uma regra explícita: tamanho da letra = o menor entre 8 e a largura livre dividida pelo número de letras, com `echo()` do tamanho.
- **DEU ERRO da folha:** ganhou "Não reescreva o arquivo inteiro e não mude mais nada além do erro."
- **Slide 13:** passou a usar o texto do PORTA-CARTÃO da folha, que passou nos três modelos no r1.
- **Folha:** ganhou o passo a passo de exportação (SVG de corte e de gravação; STL) e, na conferência final, "nome dentro da peça" e "a base cobre o topo do encosto".

## Reteste r2 (20/10/2026, textos novos)

Mesmo método do r1, com o texto da folha depois das mudanças acima, nos casos cujo pedido mudou. Arquivos em `r2/`.

| Caso | Pedido testado | Haiku | Sonnet | Opus |
| --- | --- | --- | --- | --- |
| `laser-chaveiro-maria-folha` | Regras da laser + CHAVEIRO da folha (regra da letra) | passou | passou | passou |
| `laser-lote-chaveiros-acentos` | Regras da laser + LOTE da folha (regra da letra) | passou | passou | passou |
| `laser-deu-erro-ponto-e-virgula` | DEU ERRO com "não mude mais nada" | passou | passou | **reprovou** (ver nota) |
| `3d-deu-erro-modulo-desconhecido` | DEU ERRO com "não mude mais nada" | passou | passou | passou |

11 de 12 respostas passaram.

- **DEU ERRO laser, Opus.** O código corrigido está certo. Reprovou só por uma observação opcional da resposta com conta errada: 55,25 mm em vez de 56 mm de largura livre. A observação não muda o arquivo.
- **DEU ERRO 3D, Haiku e Sonnet.** Os dois `.scad` são idênticos byte a byte.
- **Não retestados no r2:** o porta-cartão (o slide 13 agora usa o texto da folha, que passou em 3 de 3 no r1), o pedido do slide 12 (sem mudança, passou em 3 de 3) e o AJUSTE (sem mudança). O passo a passo de exportação e a conferência final são instruções para a pessoa, não para o modelo, e não entram neste teste.

Falta o teste no app gratuito antes de 07/11 (pendência do instrutor).

## Modelos externos (20/10/2026)

Mesmo método do r1 e do r2, com dois modelos de fora da Claude. O texto enviado foi o da folha depois das mudanças do r1 (regra da letra no CHAVEIRO e no LOTE e "Não reescreva o arquivo inteiro" no DEU ERRO), e o pedido antigo, curto, do slide 12. Uma resposta por modelo e por pedido. O código de cada resposta foi salvo sem edição em `ext/` e exportado no OpenSCAD 2021.01; as medidas vêm do SVG e do STL, e os PNGs foram vistos.

- **GPT:** pelo ChatGPT Plus e pelo Codex.
- **Gemini:** Gemini 4 Argon, pelo Antigravity.

Nenhum dos dois é o app gratuito que a turma vai usar.

11 de 14 respostas passaram. Todas renderizaram sem `ERROR` nem `WARNING`.

| Caso | Pedido testado | GPT | Gemini |
| --- | --- | --- | --- |
| `laser-chaveiro-maria-folha` | Regras da laser + CHAVEIRO da folha (regra da letra) | passou | passou |
| `laser-chaveiro-maria-slide12` | Regras da laser + pedido antigo do slide 12 | passou | passou |
| `laser-lote-chaveiros-acentos` | Regras da laser + LOTE da folha (regra da letra) | passou | passou |
| `3d-porta-cartao-atelie` | Regras da 3D + PORTA-CARTÃO da folha (o mesmo texto do slide 13) | passou | passou |
| `laser-ajuste-maria-para-jose` | AJUSTE (MARIA por JOSÉ) | passou | passou |
| `laser-deu-erro-ponto-e-virgula` | DEU ERRO com "Não reescreva o arquivo inteiro" | **reprovou** | **reprovou** |
| `3d-deu-erro-modulo-desconhecido` | DEU ERRO com "Não reescreva o arquivo inteiro" | passou | **reprovou** |

### Defeitos por caso

| Caso | Modelo | Defeitos | Arquivos em `ext/` |
| --- | --- | --- | --- |
| chaveiro da folha | GPT | Passou. MARIA de x 11,74 a 46,46 (34,7 x 7,6 mm), alinhado à esquerda, dentro da caixa [11; 67] x [3; 22]. Menores: só o bloco de código; variável `zero` sem uso | `laser-chaveiro-maria-folha-gpt.scad`, `-cut.svg`, `-engrave.svg`, `-cut.png`, `-engrave.png` |
| chaveiro da folha | Gemini | Passou. MARIA de x 21,96 a 56,68. Menores: resumo com fórmulas em LaTeX antes do código (as contas conferem); nome de variável pouco claro | `laser-chaveiro-maria-folha-gemini.*` |
| chaveiro do slide 12 | GPT | Passou: 70 x 25 com cantos de raio 3, furo de 4,5 mm com centro em x = 7,0, MARIA com 39,05 x 8,60 mm, marcas em (-3, -3) e (73, 28). Menores: variáveis decorativas | `laser-chaveiro-maria-slide12-gpt.*` |
| chaveiro do slide 12 | Gemini | Passou: cantos de raio 5, furo com centro em x = 8,0, MARIA com 43,39 x 9,55 mm. Menores: parágrafo e lista antes do bloco; o comentário chama `tamanho_texto` de "altura da fonte" | `laser-chaveiro-maria-slide12-gemini.*` |
| lote | GPT e Gemini | Passaram, com geometria quase idêntica: 4 peças de 70 x 25 em grade 2 x 2, lote 143 x 53, marcas só em (-3, -3) e (146, 56). CONCEIÇÃO com letra 6,22 mede 51,0 mm (x de 13,57 a 64,58 na peça); Ã e Ç presentes. Menores: `clearance = 0` sem uso; o Gemini traz prosa e LaTeX antes do código, com números que conferem | `laser-lote-chaveiros-acentos-{gpt,gemini}.*` |
| porta-cartão | GPT | Passou: 97 x 53,918 x 54 mm, estanque, 1 corpo, `z_min = 0`, 12 graus, ATELIÊ legível. Menor: a parede da frente, onde fica a gravação, sobra com 2,13 mm (mínimo pedido: 2,0) | `3d-porta-cartao-atelie-gpt.{scad,stl,png,err}`, `-frente.png`, `-lado.png` |
| porta-cartão | Gemini | Passou: 98 x 35,767 x 45 mm, estanque, 1 corpo, `z_min = 0`; parede gravada com 2,4 mm. Menor: a resposta em texto não traz o código, só diz que ele "está no campo code" | `3d-porta-cartao-atelie-gemini.{scad,stl,png,err}`, `-frente.png`, `-lado.png` |
| AJUSTE | GPT e Gemini | Passaram: só o valor de `name` mudou; geometria igual à do r1 (JOSÉ de x 24,69 a 53,21, com o acento). Explicação em 2 linhas (GPT) e 3 (Gemini). O Gemini mudou um espaço antes do comentário | `laser-ajuste-maria-para-jose-{gpt,gemini}.*` |
| DEU ERRO laser | GPT | Achou a causa (falta o `;` em `font_size = 8`), mas devolveu o arquivo inteiro, não disse onde entra a correção e realinhou os comentários das linhas 7 a 12. O render é igual ao do chaveiro original, sem o erro | `laser-deu-erro-ponto-e-virgula-gpt.*` |
| DEU ERRO laser | Gemini | Causa, linha 9 e trecho certos, com "sintaxe" explicada; reprovou por acrescentar a seção "Código OpenSCAD final completo". O código aplicado é igual byte a byte ao chaveiro original, sem o erro (esse arquivo de referência não ficou em disco) | `laser-deu-erro-ponto-e-virgula-gemini.*` |
| DEU ERRO 3D | GPT | Passou: devolveu só o módulo `rounded_plate` antes do `difference()`. Caixa 96,8 x 45,0 x 39,5758 mm (cantos arredondados); estanque, `z_min = 0` | `3d-deu-erro-modulo-desconhecido-gpt.{scad,stl,png}`, `-gpt-trecho.scad`, `-frente.png` |
| DEU ERRO 3D | Gemini | Devolveu o arquivo inteiro e um trecho de 4 linhas (`translate`, `rotate`, `translate`, `cube`) para pôr "no lugar da linha 26". Colado assim, a transformação duplica: `z_min = -3,20`, profundidade 49,1 mm em vez de 45, encosto fora do lugar, sem erro e com o mesmo `echo()`. O arquivo inteiro que ele devolveu renderiza igual à referência (96,8 x 45,0 x 39,6249 mm). Resposta longa, com títulos e termos sem explicação | `3d-deu-erro-modulo-desconhecido-gemini.{scad,stl,png,err}`, `-frente.png`, `-trecho-literal.{scad,stl,png,err}` |

O `-trecho-literal` é o arquivo de entrada com o trecho do Gemini colado no lugar da linha 26, como a resposta manda; serve só para medir o efeito.

### Notas

- O turno das Regras ("entendido") não foi guardado, como no r1 e no r2.
- O 3D foi medido com um script numpy próprio sobre o STL; o `../geom.py` só lê SVG.
- No AJUSTE, só os PNGs da camada de gravação foram vistos; a de corte foi conferida pelas medidas do SVG.

## Mudanças depois da rodada externa

- **DEU ERRO da folha:** passou a dizer "Não devolva o arquivo inteiro: mostre só as linhas corrigidas e diga quais linhas do meu código elas substituem (da linha X à linha Y)". Retestado no r4, abaixo.
- **Conferência da folha:** depois de colar uma correção, olhar se a peça continua do mesmo tamanho e no mesmo lugar, porque o `echo()` pode repetir a medida com a peça errada.
- **Slide 12 da oficina:** passou a usar o texto do CHAVEIRO da folha, que passou em 3 de 3 no r2 e em 2 de 2 aqui.
- **Folha:** ganhou o caminho do código do celular para o computador, o nome "marcas de registro" para os dois círculos e como montar a prévia com corte e gravação juntos no software da laser. São instruções para a pessoa, não para o modelo.

## Reteste r4: DEU ERRO em 5 modelos

O DEU ERRO da folha com o texto atual ("Não devolva o arquivo inteiro: mostre só as linhas corrigidas e diga quais linhas do meu código elas substituem (da linha X à linha Y)"), nos dois casos, em 5 modelos: Haiku, Sonnet e Opus; GPT pelo Codex; Gemini 4 Argon pelo Antigravity. Uma resposta por modelo e por caso. O trecho de cada resposta foi colado no arquivo com erro, nas linhas que a própria resposta indicou, e o resultado foi exportado no OpenSCAD 2021.01. Arquivos em `r4/`; pedidos e saídas brutas do GPT e do Gemini ficaram fora do repositório.

| Caso | Haiku | Sonnet | Opus | GPT | Gemini |
| --- | --- | --- | --- | --- | --- |
| `laser-deu-erro-ponto-e-virgula` | **reprovou** (linguagem) | passou | passou | passou | passou |
| `3d-deu-erro-modulo-desconhecido` | passou | passou | passou | passou (ver nota) | passou |

9 de 10 respostas passaram. Nenhum modelo devolveu o arquivo inteiro, e todos disseram as linhas que o trecho substitui. Todos os arquivos com o trecho aplicado renderizam sem `ERROR` nem `WARNING`.

### Defeitos por caso

| Caso | Modelo | Defeitos |
| --- | --- | --- |
| DEU ERRO laser | Haiku | Reprovou só pela linguagem: usa "parser" sem explicar e cita "syntax error" sem traduzir. Causa, linha 9 e motivo de o erro aparecer na linha 10 estão certos. Menor: 8 espaços antes do comentário |
| DEU ERRO laser | Sonnet | Passou. Menor: uma observação opcional diz que "falta a variável clearance", o que não vale aqui (as Regras só pedem `clearance` em encaixes, e o chaveiro não tem encaixe). As outras duas observações estão certas |
| DEU ERRO laser | Opus | Passou. Menores: mostra antes, num bloco de código, a linha errada, e só depois a correção (dois blocos podem confundir qual colar); observações extras certas, mas além do pedido |
| DEU ERRO laser | GPT | Passou: resposta curta, sem jargão, "da linha 9 à linha 9" |
| DEU ERRO laser | Gemini | Passou. Menor: resposta longa, com títulos e lista; repete a mensagem em inglês |
| DEU ERRO 3D | Haiku | Passou pelo outro caminho: define o módulo `rounded_plate` com `hull()` de 4 cilindros, sem `minkowski` nem biblioteca, no lugar da linha 18 (em branco). Volume 27599,62 contra 27603,84 da referência, pelos cantos arredondados. Menores: parágrafo fora do assunto; termos sem explicar ("hull()", "Facets", "Volumes") |
| DEU ERRO 3D | Sonnet | Passou: troca só a linha 26 por `cube([body_w, wall, back_h])` e avisa que o raio 2 some. Não mexeu em `wall` (no r1 tinha mexido). Menor: 22 espaços de recuo em vez de 20 |
| DEU ERRO 3D | Opus | Passou: mesmo `cube` na linha 26. Aponta que o `echo()` engana: sem o encosto, a peça teria 12 mm de altura. Menor: resposta mais longa; oferece um módulo opcional, não aplicado |
| DEU ERRO 3D | GPT | Passou (ver nota): mesmo `cube` na linha 26; o arquivo aplicado é igual byte a byte ao do Opus |
| DEU ERRO 3D | Gemini | Passou: `cube` na linha 26, sem repetir `translate` e `rotate` (o erro da rodada externa não voltou). Menor: repete o WARNING em inglês |

### Notas

- **Laser:** os SVGs de corte e de gravação dos 5 ficaram iguais byte a byte aos da referência `ext/laser-deu-erro-ponto-e-virgula-gemini.scad`, e o código sem comentários é igual ao dela. Os `echo()` "Peça: 70 x 25 mm" e "Furo: 4.5 mm, letra: 8 mm" saem nas duas camadas. Só o PNG combinado do Sonnet foi visto (`r4/laser-deu-erro-ponto-e-virgula-sonnet.png`).
- **3D:** nos 5, `echo()` igual ao da referência (96.8, 45, 39.1259), caixa 96,8 x 45 x 39,625 mm, `z_min = 0`, estanque. Sonnet, Opus, GPT e Gemini têm o mesmo volume da referência. Só os PNGs do Haiku e do Sonnet foram vistos.
- **GPT na 3D:** a avaliação cega reprovou porque o texto que ela recebeu não tinha o bloco de código entre "por:" e "Isso cria o encosto". A saída bruta do Codex traz o bloco (`cube([body_w, wall, back_h]);`) nesse lugar; a perda foi na captura, não na resposta. Por isso conta como passou.
- **GPT na laser:** a resposta avaliada vinha com texto do Codex em volta (comando, avisos, `tokens used`), que não é do modelo e não entrou na nota.
- Ninguém mexeu em `wall`, `back_h` ou `tilt` na 3D.
- Na rodada externa, GPT e Gemini devolveram o arquivo inteiro com o texto anterior do DEU ERRO. Com o texto atual, nesta rodada, não devolveram. É uma resposta por modelo: o aviso do slide 15 (conferir que só a linha do erro mudou e olhar a peça depois de colar) continua.

## Limites

- Uma resposta por modelo e por pedido: Claude no r1 e no r2; GPT e Gemini na rodada externa; os 5 no r4 (só o DEU ERRO), fora dos apps gratuitos. Nenhum app gratuito (claude.ai, ChatGPT, Gemini), que é o que a turma vai usar.
- O DEU ERRO novo foi retestado no r4 (9 de 10), uma resposta por modelo. O slide 12 novo não foi retestado com o texto atual (é igual ao CHAVEIRO da folha, que passou).
- A resposta ao turno das Regras ("entendido") não foi guardada em nenhum caso.
- No AJUSTE, nem o original nem a explicação foram guardados.
- Nem todos os PNGs foram vistos um a um: no chaveiro da folha, só `haiku-engrave` e `sonnet-cut`; no AJUSTE, só `j-engrave`. As medidas vêm dos SVG e dos STL.
- O teste mede o arquivo, não a peça: nada foi cortado nem impresso.
