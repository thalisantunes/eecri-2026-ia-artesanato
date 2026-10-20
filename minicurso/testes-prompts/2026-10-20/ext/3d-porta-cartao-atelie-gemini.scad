// --- Parametros do cartao e do bolso em milimetros ---
largura_cartao = 90; // Largura nominal do cartao em milimetros
altura_cartao = 50; // Altura nominal do cartao em milimetros
espessura_pilha = 12; // Espessura da pilha de cartoes no bolso em milimetros
folga_largura = 2; // Folga lateral total para acomodar os cartoes em milimetros
folga_pilha = 1.5; // Folga na profundidade do bolso para a pilha inclinada em milimetros

// --- Parametros estruturais da peca em milimetros e graus ---
angulo_inclinacao = 12; // Inclinacao do encosto para tras em graus a partir da vertical
espessura_parede = 3; // Espessura das paredes laterais e do encosto em milimetros
espessura_parede_frontal = 3.2; // Espessura da parede frontal antes da gravacao em milimetros
espessura_base = 4; // Espessura da base e da ponta do pe traseiro em milimetros
altura_aba_frontal = 18; // Altura da aba frontal e das abas laterais do bolso em milimetros
altura_total = 45; // Altura total da peca no topo do encosto em milimetros
comprimento_pe_traseiro = 16; // Extensao do pe traseiro alem da base do encosto em milimetros
altura_reforco_pe = 16; // Altura do chanfro traseiro de estabilidade no encosto em milimetros

// --- Parametros da gravacao frontal em milimetros ---
profundidade_gravacao = 0.8; // Profundidade do texto gravado na frente em milimetros
tamanho_fonte = 8.5; // Tamanho da fonte do texto gravado em milimetros
folga_booleana = 0.1; // Folga para garantir subtracoees booleanas limpas em milimetros

// --- Constantes geometricas auxiliares ---
zero = 0; // Referencia de origem e plano da mesa de impressao
fator_metade = 0.5; // Fator para divisao ao meio e centralizacao
fator_duplo = 2; // Fator para contagem de paredes duplas nas extremidades
angulo_reto = 90; // Angulo de rotacao ortogonal em graus
resolucao_curvas = 32; // Subdivisoes para renderizacao das curvas da fonte

// --- Dimensoes calculadas ---
$fn = resolucao_curvas;
largura_interna = largura_cartao + folga_largura;
largura_total = largura_interna + fator_duplo * espessura_parede;

profundidade_bolso = espessura_pilha + folga_pilha;
espessura_encosto_horizontal = espessura_parede / cos(angulo_inclinacao);

recuo_encosto_na_aba = (altura_aba_frontal - espessura_base) * tan(angulo_inclinacao);
recuo_encosto_no_reforco = (altura_reforco_pe - espessura_base) * tan(angulo_inclinacao);
recuo_encosto_no_topo = (altura_total - espessura_base) * tan(angulo_inclinacao);

y_inicio_bolso = espessura_parede_frontal;
y_fundo_bolso = y_inicio_bolso + profundidade_bolso;
y_base_traseira_encosto = y_fundo_bolso + espessura_encosto_horizontal;

y_encosto_na_aba = y_fundo_bolso + recuo_encosto_na_aba;
y_traseira_no_reforco = y_base_traseira_encosto + recuo_encosto_no_reforco;
y_topo_frontal_encosto = y_fundo_bolso + recuo_encosto_no_topo;
y_topo_traseiro_encosto = y_base_traseira_encosto + recuo_encosto_no_topo;

profundidade_total = y_base_traseira_encosto + comprimento_pe_traseiro;

// --- Exibicao das dimensoes finais no console ---
echo("Largura (mm):", largura_total);
echo("Profundidade (mm):", profundidade_total);
echo("Altura (mm):", altura_total);

// --- Construcao do solido unico ---
difference() {
    // Corpo principal extrudado a partir do perfil lateral apoiado em z = zero
    rotate([angulo_reto, zero, angulo_reto])
        linear_extrude(height = largura_total)
            polygon(points = [
                [zero, zero],
                [profundidade_total, zero],
                [profundidade_total, espessura_base],
                [y_traseira_no_reforco, altura_reforco_pe],
                [y_topo_traseiro_encosto, altura_total],
                [y_topo_frontal_encosto, altura_total],
                [y_encosto_na_aba, altura_aba_frontal],
                [zero, altura_aba_frontal]
            ]);

    // Cavidade do bolso para a pilha de cartoes preservando as paredes laterais
    translate([espessura_parede, zero, zero])
        rotate([angulo_reto, zero, angulo_reto])
            linear_extrude(height = largura_interna)
                polygon(points = [
                    [y_inicio_bolso, espessura_base],
                    [y_fundo_bolso, espessura_base],
                    [y_encosto_na_aba, altura_aba_frontal],
                    [y_encosto_na_aba - folga_booleana, altura_aba_frontal + folga_booleana],
                    [y_inicio_bolso, altura_aba_frontal + folga_booleana]
                ]);

    // Texto gravado na parede frontal
    translate([largura_total * fator_metade, profundidade_gravacao, altura_aba_frontal * fator_metade])
        rotate([angulo_reto, zero, zero])
            linear_extrude(height = profundidade_gravacao + folga_booleana)
                text(
                    "ATELIÊ",
                    size = tamanho_fonte,
                    font = "Liberation Sans:style=Bold",
                    halign = "center",
                    valign = "center"
                );
}
