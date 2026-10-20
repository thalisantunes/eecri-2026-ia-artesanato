// ===== Parâmetros de entrada (mm) =====
layer = "cut";            // "cut" = contornos e furos | "engrave" = texto gravado
nome = "MARIA";           // texto a gravar
largura = 70;             // largura da peça
altura = 25;              // altura da peça
raio_canto = 4;           // raio dos cantos
furo_d = 4.5;             // diâmetro do furo da argola
furo_borda_esq = 3.5;     // distância da borda esquerda até a borda do furo
margem_min = 3;           // distância mínima do texto ao furo e às bordas
tamanho_max = 8;          // tamanho máximo da letra
clearance = 0;            // folga: só em encaixes (esta peça não tem encaixe)
marca_d = 0.6;            // diâmetro dos círculos de referência
marca_afast = 3;          // afastamento dos centros dos círculos em relação aos cantos
metade = 2;               // divisor para obter o raio e o centro
fonte = "Liberation Sans:style=Bold";
fn = 64;                  // resolução dos arcos
fn_marca = 24;            // resolução dos círculos de referência

// ===== Cálculos derivados =====
furo_r = furo_d / metade;
furo_cx = furo_borda_esq + furo_r;        // centro do furo em x
furo_cy = altura / metade;                // centro do furo em y
furo_dir = furo_borda_esq + furo_d;       // borda direita do furo
texto_x0 = furo_dir + margem_min;         // início do texto
texto_x1 = largura - margem_min;          // limite direito do texto
largura_livre = texto_x1 - texto_x0;      // largura livre para o nome
n_letras = len(nome);
tamanho_letra = min(tamanho_max, largura_livre / n_letras);

// ===== Módulos 2D =====
module contorno() {
  hull()
    for (x = [raio_canto, largura - raio_canto], y = [raio_canto, altura - raio_canto])
      translate([x, y]) circle(r = raio_canto, $fn = fn);
}

module furo() {
  translate([furo_cx, furo_cy]) circle(d = furo_d, $fn = fn);
}

module texto() {
  translate([texto_x0, furo_cy])
    text(nome, size = tamanho_letra, font = fonte, halign = "left", valign = "center");
}

module marcas() {
  translate([-marca_afast, -marca_afast]) circle(d = marca_d, $fn = fn_marca);
  translate([largura + marca_afast, altura + marca_afast]) circle(d = marca_d, $fn = fn_marca);
}

// ===== Saída por camada =====
if (layer == "cut") {
  difference() {
    contorno();
    furo();
  }
  marcas();
} else if (layer == "engrave") {
  texto();
  marcas();
} else {
  echo("layer invalida, use cut ou engrave");
}

// ===== Medidas finais =====
echo("Peca (mm)", largura, altura, "raio", raio_canto);
echo("Furo centro x, y", furo_cx, furo_cy, "diametro", furo_d);
echo("Borda direita do furo", furo_dir);
echo("Texto inicio x", texto_x0, "limite direito", texto_x1);
echo("Largura livre para o nome", largura_livre);
echo("Tamanho da letra", tamanho_letra);
echo("Marcas centro inferior", -marca_afast, -marca_afast, "superior", largura + marca_afast, altura + marca_afast);
