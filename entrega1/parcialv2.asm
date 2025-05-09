# --- Inicialización de variables -------------------------
addi x5, x0, 89      # a = 89   (x5 ≡ t0)
addi x6, x0, 45      # b = 45   (x6 ≡ t1)
addi x7, x0, 0       # c = 0    (x7 ≡ t2)

# --- Operaciones -----------------------------------------
add  x7, x5, x6      # c = a + b   → 134
sub  x7, x5, x6      # c = a - b   → 44

# --- Fin del programa: bucle inactivo --------------------
beq  x0, x0, 0       # salto a sí mismo (loop), evita usar ‘ret’