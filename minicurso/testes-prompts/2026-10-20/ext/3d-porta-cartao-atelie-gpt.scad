// OpenSCAD 2021.01 — medidas em milímetros.
cartao_largura = 90;          // Largura dos cartões.
cartao_altura = 50;           // Altura dos cartões.
pilha = 12;                  // Espessura da pilha, perpendicular ao encosto.
folga_largura = 1;           // Folga total na largura.
folga_pilha = 1;             // Folga total na espessura.
inclinacao = 12;             // Inclinação para trás, em graus.
parede = 3;                  // Espessura horizontal das paredes.
base = 4;                    // Espessura da base.
altura_frente = 20;          // Altura total da borda frontal.
margem_frontal = 3;          // Avanço da base à frente do bolso.
recuo_bolso = 3;             // Posição frontal do bolso sobre a base.
pe_traseiro = 18;            // Extensão estabilizadora atrás do encosto.
gravacao = 0.8;              // Profundidade perpendicular da gravação.
texto_tamanho = 8;           // Tamanho nominal das letras.
texto_altura = 12;           // Altura do centro do texto sobre a mesa.
epsilon = 0.02;             // Sobreposição externa do corte.
zero = 0;                   // Constante geométrica.
um = 1;                     // Constante geométrica.
dois = 2;                   // Divisor para centralização.
angulo_reto = 90;            // Ângulo reto, em graus.
resolucao = 48;              // Resolução de curvas.

// Dimensões derivadas.
largura_interna = cartao_largura + folga_largura;
largura = largura_interna + dois * parede;
altura = base + cartao_altura;
passo = tan(inclinacao);
abertura = (pilha + folga_pilha) / cos(inclinacao);
inicio_base = -margem_frontal;
fim_base = traseira_externa(altura) + pe_traseiro;
profundidade = fim_base - inicio_base;

$fn = resolucao;

function frente_externa(z) =
    recuo_bolso + (z - base) * passo;

function frente_interna(z) =
    frente_externa(z) + parede;

function traseira_interna(z) =
    frente_interna(z) + abertura;

function traseira_externa(z) =
    traseira_interna(z) + parede;

// Extruda um perfil no plano YZ ao longo da largura X.
module perfil_lateral(pontos, extensao) {
    rotate([angulo_reto, zero, angulo_reto])
        linear_extrude(height = extensao, convexity = resolucao)
            polygon(points = pontos);
}

module corpo() {
    union() {
        // Base contínua, incluindo o pé traseiro.
        translate([zero, inicio_base, zero])
            cube([largura, profundidade, base]);

        // Volume inferior: frente, fundo e laterais do bolso.
        perfil_lateral([
            [frente_externa(base), base],
            [traseira_externa(base), base],
            [traseira_externa(altura_frente), altura_frente],
            [frente_externa(altura_frente), altura_frente]
        ], largura);

        // Encosto com inclinação constante.
        perfil_lateral([
            [traseira_interna(base), base],
            [traseira_externa(base), base],
            [traseira_externa(altura), altura],
            [traseira_interna(altura), altura]
        ], largura);
    }
}

module vazio_bolso() {
    translate([parede, zero, zero])
        perfil_lateral([
            [frente_interna(base), base],
            [traseira_interna(base), base],
            [traseira_interna(altura + epsilon), altura + epsilon],
            [frente_interna(altura + epsilon), altura + epsilon]
        ], largura_interna);
}

module letras_gravadas() {
    // O eixo local Z aponta para fora da face frontal inclinada.
    translate([
        largura / dois,
        frente_externa(texto_altura),
        texto_altura
    ])
        rotate([angulo_reto - inclinacao, zero, zero])
            translate([zero, zero, -gravacao])
                linear_extrude(
                    height = gravacao + epsilon,
                    convexity = resolucao
                )
                    text(
                        "ATELIÊ",
                        size = texto_tamanho,
                        font = "Liberation Sans:style=Bold",
                        halign = "center",
                        valign = "center"
                    );
}

echo("Largura (mm):", largura);
echo("Profundidade (mm):", profundidade);
echo("Altura (mm):", altura);

// Peça única; base plana em Z = 0.
// Paredes inclinadas têm espessura normal superior a 2 mm.
difference() {
    corpo();
    vazio_bolso();
    letras_gravadas();
}
