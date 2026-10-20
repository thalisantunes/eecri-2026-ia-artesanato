// =========================================================
// Parâmetros e variáveis (todas as medidas em milímetros)
// =========================================================

$fn = 64; // Resolução dos arcos e círculos
zero = 0; // Coordenada de origem (mm)
divisor_metade = 2; // Divisor para cálculo de centro e metade

espessura_material = 3; // Espessura do MDF (mm)
clearance = 0.0; // Folga exclusiva para encaixes (mm)

largura_chaveiro = 70; // Largura total do chaveiro (mm)
altura_chaveiro = 25; // Altura total do chaveiro (mm)
raio_canto = 5; // Raio de arredondamento dos cantos (mm)

diametro_furo = 4.5; // Diâmetro do furo para a argola (mm)
pos_x_furo = 8; // Distância do centro do furo até a borda esquerda (mm)

tamanho_texto = 10; // Altura da fonte do texto gravado (mm)
pos_x_texto = 39; // Posição horizontal do centro do texto (mm)

diametro_registro = 0.6; // Diâmetro dos círculos de alinhamento/registro (mm)
afastamento_registro = 3; // Distância dos círculos de registro para fora dos cantos (mm)

layer = "cut"; // Camada ativa: "cut" para corte ou "engrave" para gravação
texto_gravado = "MARIA"; // Nome a ser gravado no chaveiro
fonte_texto = "Liberation Sans:style=Bold"; // Fonte exigida para a gravação

// =========================================================
// Cálculo de coordenadas derivadas
// =========================================================

pos_y_centro = altura_chaveiro / divisor_metade;
 largura_total_com_registro = largura_chaveiro + (afastamento_registro * divisor_metade);
altura_total_com_registro = altura_chaveiro + (afastamento_registro * divisor_metade);

// =========================================================
// Exibição das medidas finais no console
// =========================================================

echo("Largura final do chaveiro (mm):", largura_chaveiro);
echo("Altura final do chaveiro (mm):", altura_chaveiro);
echo("Espessura do MDF (mm):", espessura_material);
echo("Raio dos cantos arredondados (mm):", raio_canto);
echo("Diâmetro do furo da argola (mm):", diametro_furo);
echo("Diâmetro das marcas de registro (mm):", diametro_registro);
echo("Afastamento das marcas de registro (mm):", afastamento_registro);
echo("Largura total entre centros de registro (mm):", largura_total_com_registro);
echo("Altura total entre centros de registro (mm):", altura_total_com_registro);

// =========================================================
// Módulos geométricos 2D
// =========================================================

module contorno_chaveiro() {
    hull() {
        translate([raio_canto, raio_canto])
            circle(r = raio_canto);
        translate([largura_chaveiro - raio_canto, raio_canto])
            circle(r = raio_canto);
        translate([raio_canto, altura_chaveiro - raio_canto])
            circle(r = raio_canto);
        translate([largura_chaveiro - raio_canto, altura_chaveiro - raio_canto])
            circle(r = raio_canto);
    }
}

module furo_argola() {
    translate([pos_x_furo, pos_y_centro])
        circle(d = diametro_furo);
}

module marcas_registro() {
    translate([zero - afastamento_registro, zero - afastamento_registro])
        circle(d = diametro_registro);
    translate([largura_chaveiro + afastamento_registro, altura_chaveiro + afastamento_registro])
        circle(d = diametro_registro);
}

module camada_corte() {
    difference() {
        contorno_chaveiro();
        furo_argola();
    }
}

module camada_gravacao() {
    translate([pos_x_texto, pos_y_centro])
        text(
            text = texto_gravado,
            size = tamanho_texto,
            font = fonte_texto,
            halign = "center",
            valign = "center"
        );
}

// =========================================================
// Geração da camada selecionada
// =========================================================

if (layer == "cut") {
    camada_corte();
    marcas_registro();
}

if (layer == "engrave") {
    camada_gravacao();
    marcas_registro();
}
