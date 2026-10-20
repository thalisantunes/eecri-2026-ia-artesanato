// Parametros numericos em milimetros
tag_width = 70; // Largura de cada chaveiro em mm
tag_height = 25; // Altura de cada chaveiro em mm
hole_diameter = 4.5; // Diametro do furo do chaveiro em mm
hole_margin_left = 3.5; // Distancia da borda esquerda ate a borda do furo em mm
text_margin = 3; // Margem minima do nome para o furo e para as bordas em mm
max_font_size = 8; // Tamanho maximo da letra em mm
grid_cols = 2; // Numero de colunas da grade
grid_gap = 3; // Espacamento entre chaveiros na grade em mm
reg_diameter = 0.6; // Diametro dos circulos das marcas de registro em mm
reg_offset = 3; // Distancia das marcas de registro para fora dos cantos do lote em mm
clearance = 0; // Folga para encaixes em mm
circle_segments = 64; // Quantidade de segmentos dos circulos
zero = 0; // Constante auxiliar zero
one = 1; // Constante auxiliar um
two = 2; // Constante auxiliar dois

// Configuracao de camada, fonte e dados
$fn = circle_segments;
layer = "cut"; // Camada ativa: "cut" para corte ou "engrave" para gravacao
font_name = "Liberation Sans:style=Bold"; // Fonte para gravacao
names = ["ANA", "JOÃO", "CONCEIÇÃO", "PEDRO"]; // Lista de nomes do lote

// Calculos geometricos derivados
hole_x = hole_margin_left + (hole_diameter / two);
hole_y = tag_height / two;
text_start_x = hole_margin_left + hole_diameter + text_margin;
text_free_width = tag_width - text_start_x - text_margin;
text_center_x = text_start_x + (text_free_width / two);
text_center_y = tag_height / two;

total_tags = len(names);
active_cols = min(total_tags, grid_cols);
grid_rows = ceil(total_tags / grid_cols);
batch_width = (active_cols * tag_width) + ((active_cols - one) * grid_gap);
batch_height = (grid_rows * tag_height) + ((grid_rows - one) * grid_gap);
total_width_with_reg = batch_width + (two * reg_offset) + reg_diameter;
total_height_with_reg = batch_height + (two * reg_offset) + reg_diameter;

function calc_font_size(name_str) =
    min(max_font_size, text_free_width / len(name_str));

// Exibicao das medidas finais no console
echo(quantidade_chaveiros = total_tags);
echo(chaveiro_largura_mm = tag_width, chaveiro_altura_mm = tag_height);
echo(largura_livre_texto_mm = text_free_width);
echo(lote_largura_mm = batch_width, lote_altura_mm = batch_height);
echo(
    total_com_registro_largura_mm = total_width_with_reg,
    total_com_registro_altura_mm = total_height_with_reg
);

// Geracao da grade de chaveiros e exibicao do tamanho de letra de cada nome
for (idx = [zero : one : total_tags - one]) {
    current_name = names[idx];
    current_font_size = calc_font_size(current_name);
    col = idx % grid_cols;
    row = floor(idx / grid_cols);
    pos_x = col * (tag_width + grid_gap);
    pos_y = row * (tag_height + grid_gap);

    echo(
        nome = current_name,
        numero_letras = len(current_name),
        tamanho_letra_mm = current_font_size
    );

    if (layer == "cut") {
        translate([pos_x, pos_y]) {
            difference() {
                square([tag_width, tag_height]);
                translate([hole_x, hole_y]) {
                    circle(d = hole_diameter);
                }
            }
        }
    }

    if (layer == "engrave") {
        translate([pos_x + text_center_x, pos_y + text_center_y]) {
            text(
                text = current_name,
                size = current_font_size,
                font = font_name,
                halign = "center",
                valign = "center"
            );
        }
    }
}

// Marcas de registro nos cantos do lote nas duas camadas
if (layer == "cut" || layer == "engrave") {
    translate([-reg_offset, -reg_offset]) {
        circle(d = reg_diameter);
    }
    translate([batch_width + reg_offset, batch_height + reg_offset]) {
        circle(d = reg_diameter);
    }
}
