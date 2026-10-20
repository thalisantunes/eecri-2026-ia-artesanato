# eecri-2026-ia-artesanato: IA e laboratório maker para o artesanato no I EECri 2026

Repositório: https://github.com/thalisantunes/eecri-2026-ia-artesanato

Material aberto da palestra e da oficina de Thalis Antunes de Souza no **I EECri 2026, I Encontro de Economia Criativa da Serra Geral**, realizado na FAVAG, em Nova Porteirinha (MG), de 5 a 7 de novembro de 2026.

- **Palestra "Dá pra fazer: IA e laboratório maker para gerar renda com artesanato"** (06/11/2026): o que se vende saindo de uma laser e de uma impressora 3D, um caso real de um ateliê de bordado que precisou sair de uma plataforma que fechou e um olhar honesto sobre onde a IA ajuda e onde erra.
- **Oficina "Da frase à peça: IA para modelo 3D e corte a laser"** (07/11/2026, Laboratório Maker da FAVAG): pedir a peça a um assistente de IA gratuito, conferir o código no OpenSCAD e levar o arquivo para a laser ou para a impressora 3D.

Quer produzir? Procure o Diego no Laboratório Maker de Nova Porteirinha.

## O que tem aqui

| Caminho | O que é |
| --- | --- |
| `palestra/slides.md`, `palestra/slides.pdf` | Deck da palestra (Marp), com as falas como notas do apresentador |
| `palestra/roteiro-slides.md` | Roteiro slide a slide: texto, fala e tempo |
| `minicurso/slides.md`, `minicurso/slides.pdf` | Deck da oficina (Marp) |
| `minicurso/roteiro-slides.md` | Roteiro slide a slide da oficina |
| `minicurso/cola-prompts.md` | Folha de prompts da oficina, para copiar e colar no celular |
| `minicurso/plano-de-aula.md` | Plano de aula: premissas, papéis, cronograma de 4 horas, blocos, pontos de checagem e a estratégia de fila da laser |
| `minicurso/roteiro-instrutor.md` | Roteiro minuto a minuto do instrutor, falas-chave, erros comuns e plano B para cada dependência |
| `minicurso/materiais.md` | Lista de materiais para 16 participantes, com a conta de área de MDF, acrílico e couro e o kit pré-cortado |
| `minicurso/apostila/` | Apostila em 6 capítulos: laser e materiais, IA generativa para CAD, biblioteca de prompts, do modelo ao corte, exercícios, da peça ao produto |
| `minicurso/modelos-3d/` | Porta-cartão de mesa em OpenSCAD, com STL e prévia |
| `minicurso/img/` | Imagens dos testes de prompts usadas nos slides |
| `minicurso/testes-prompts/` | Testes cegos dos prompts: entradas, código de cada resposta sem edição, camadas exportadas, prévias e scripts de conferência |
| `laser/modelos/` | Modelos paramétricos em OpenSCAD (teste de potência e velocidade, kerf, chaveiro, lote de chaveiros, caixa com encaixe, dobradiça viva, placa), com SVG, DXF e prévias |
| `laser/ensaio-laser.md` | Roteiro de ensaio na laser do laboratório antes da oficina |
| `laser/contingencias.md` | O que fazer quando a laser, o software ou o material não colaboram |
| `laser/parametros/folha-parametros.md` | Folha de parâmetros da laser para imprimir e preencher no ensaio |
| `laser/parametros/resultados.md` | Planilha para anotar os resultados dos testes |
| `visual/` | Tema Marp do evento (`eecri.css`) e as fontes, cada uma com a sua licença OFL |

## Como gerar os PDFs

```bash
git clone https://github.com/thalisantunes/eecri-2026-ia-artesanato.git
cd eecri-2026-ia-artesanato
```

Precisa do Node.js (com `npx`) e de um navegador Chrome ou Chromium instalado, que o Marp usa para imprimir o PDF.

```bash
bash palestra/gerar-pdf.sh
bash minicurso/gerar-pdf.sh
```

Cada script roda, dentro da própria pasta:

```bash
npx -y @marp-team/marp-cli --no-stdin --allow-local-files slides.md --theme-set ../visual/eecri.css -o slides.pdf
```

O `--allow-local-files` é necessário porque o tema carrega as fontes e as imagens do próprio repositório. O tema supõe que o deck fica um nível abaixo da raiz (`palestra/`, `minicurso/`). As notas do apresentador ficam nos comentários HTML de cada slide e não aparecem no PDF.

Para gerar os arquivos dos modelos da laser (OpenSCAD 2021.01 no PATH): `bash laser/modelos/exportar.sh`. O `laser/modelos/README.md` explica cada modelo e os parâmetros.

## Como usar a folha de prompts

A folha `minicurso/cola-prompts.md` tem blocos prontos: REGRAS DA LASER, REGRAS DA 3D, CHAVEIRO COM NOME, LOTE DE CHAVEIROS, PORTA-CARTÃO, AJUSTE, DEU ERRO e a conferência ANTES DE MANDAR PARA A MÁQUINA.

1. Abra uma conversa nova num assistente de IA (claude.ai, ChatGPT ou Gemini).
2. Cole primeiro as **regras** da máquina (laser ou 3D). Elas fixam a versão do OpenSCAD, os milímetros, as camadas de corte e gravação e o que não pode aparecer no código.
3. Cole o **pedido da peça** e troque medidas e nomes pelos seus.
4. Cole o código no OpenSCAD e aperte F6. Confira no console as medidas que o pedido manda escrever com `echo()`.
5. Exporte: na laser, File, Export, Export as SVG com `layer = "cut"` e de novo com `layer = "engrave"`; na 3D, Export as STL.
6. Antes da máquina, faça a conferência do fim da folha: medidas, nome dentro da peça, acentos, furo, espessura medida do material e, na 3D, a peça inteira e apoiada.

Deu erro? Use o bloco DEU ERRO com a mensagem inteira do console e peça para corrigir só o trecho. Mudou de ideia? Use o AJUSTE, uma mudança por vez. Pedidos mais longos e explicados estão no capítulo 3 da apostila. Quem tem menos de 18 anos usa o assistente junto com um adulto dono da conta.

## Resultado dos testes cegos de prompts

**Em resumo:** os pedidos da oficina foram testados em 5 modelos de IA (Claude Haiku, Sonnet e Opus, GPT e Gemini). Na última rodada, com o texto atual do DEU ERRO, 9 de 10 respostas passaram nos 5 modelos, e nenhum devolveu o arquivo inteiro; a única reprovação foi de linguagem (termo técnico sem explicar), não de código. Nas rodadas anteriores, os defeitos encontrados (nome longo saindo da peça, arquivo inteiro devolvido no DEU ERRO) levaram à correção dos pedidos.

Cada modelo recebeu as regras e o pedido como uma conversa de chat, sem ferramentas, e deu uma resposta só, sem repetir nem escolher. O código de cada resposta foi salvo sem edição e exportado no OpenSCAD 2021.01; as medidas foram tiradas do SVG e do STL por script. Os detalhes, arquivo por arquivo, estão em `minicurso/testes-prompts/README.md` e `minicurso/testes-prompts/2026-10-20/README.md`.

| Data | O que foi testado | Modelos | Resultado |
| --- | --- | --- | --- |
| 13/10/2026, rodada 1 | 5 prompts longos da apostila | Claude Haiku e Sonnet | 10 arquivos exportaram sem aviso, mas 6 tinham defeito: nome longo que saía da peça e moldura encostando nos furos. Os prompts foram corrigidos |
| 13/10/2026, rodadas 2 e 3 | Os mesmos prompts, corrigidos | Claude Haiku e Sonnet | 7 de 7 passaram |
| 20/10/2026, r1 | 8 pedidos curtos da oficina (folha e slides) | Claude Haiku, Sonnet e Opus | 19 de 24 passaram. Nenhuma das 5 reprovadas mostrou erro na tela: o nome CONCEIÇÃO saiu da peça em 2 de 3 respostas, e o console dizia que cabia |
| 20/10/2026, r2 | Pedidos reescritos (regra explícita para o tamanho da letra; "não mude mais nada" no DEU ERRO) | Claude Haiku, Sonnet e Opus | 11 de 12 passaram; o lote com CONCEIÇÃO passou nos 3 |
| 20/10/2026, externos | Folha corrigida | GPT (ChatGPT Plus e Codex) e Gemini 4 Argon (Antigravity) | 11 de 14 passaram. Chaveiro, lote, porta-cartão e ajuste passaram nos dois. As 3 reprovações foram no DEU ERRO: os dois devolveram o arquivo inteiro em vez do trecho, e o trecho do Gemini, colado como ele mandou, duplicava a transformação e deslocava a peça sem dar erro |
| 20/10/2026, r4 | DEU ERRO reescrito ("mostre só as linhas corrigidas e diga quais linhas elas substituem"), na laser e na 3D | 5 modelos: Claude Haiku, Sonnet e Opus, GPT (Codex) e Gemini 4 Argon (Antigravity) | 9 de 10 passaram. Todos devolveram só o trecho e disseram as linhas; com o trecho aplicado, todos os arquivos renderizam sem erro nem aviso. A reprovação (Haiku, laser) foi só de linguagem: "parser" e "syntax error" sem explicar |

O que os testes ensinam:

- **A IA erra com confiança.** As respostas reprovadas renderizavam sem erro e diziam que a peça estava certa. Quem confere é você.
- **Pedido preciso muda o resultado.** Dizer onde fica o furo, a distância do nome até as bordas e como calcular a letra fez o lote passar em todos os modelos testados.
- **Uma mudança por vez.** No DEU ERRO, os modelos tendem a reescrever o arquivo inteiro; depois de colar uma correção, confira se a peça continua do mesmo tamanho e no mesmo lugar.

Limites: uma resposta por modelo e por pedido; o r4 testou só o DEU ERRO; nenhum teste nos apps gratuitos do claude.ai, do ChatGPT e do Gemini, que são os que a turma usa; o teste mede o arquivo, não a peça cortada ou impressa.

## O que ficou de fora

Esta é a versão pública do material. Ficaram fora as anotações internas de preparação, contatos pessoais, o nome do ateliê citado na palestra (aqui ele aparece só como "um ateliê de bordado"), as imagens e capturas de tela da loja dele (o slide 11 da palestra descreve a captura em texto) e os logos do I EECri e dos realizadores (o tema funciona sem eles). Os slides mantêm a mesma numeração do material apresentado.

## Licença

- **Código e modelos: MIT** (`LICENSE`). Vale para os arquivos OpenSCAD (`.scad`) e o que é gerado deles (`.svg`, `.dxf`, `.stl` e as prévias `.png`), os scripts (`.py`, `.sh`) e o tema `visual/eecri.css`.
- **Slides, roteiros, apostila, folha de prompts, plano de aula, roteiro do instrutor, lista de materiais e demais textos: CC BY 4.0** (`LICENSE-CC-BY-4.0`, resumo em https://creativecommons.org/licenses/by/4.0/deed.pt-br). Pode copiar, adaptar e usar, inclusive comercialmente, dando o crédito: "Thalis Antunes de Souza, material do I EECri 2026".
- **Fontes** (`visual/fonts/`): Archivo Black, Space Grotesk e Caveat, sob a SIL Open Font License 1.1, com o texto de cada licença ao lado (`OFL-*.txt`).

Os nomes I EECri, FAVAG, OpenSCAD, Claude, ChatGPT, Gemini e os das demais marcas citadas pertencem aos seus donos e aparecem aqui só como referência.
