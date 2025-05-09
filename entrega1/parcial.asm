# int main(void)
main:
    addi  sp, sp, -16       # Reserva 16 bytes en la pila
    sw    ra, 12(sp)        # Guarda el return address

    # int a = 89;
    li    t0, 89            # t0 = a

    # int b = 45;
    li    t1, 45            # t1 = b

    # int c = 0;    (no hace falta inicializar todavía)

    # c = a + b;
    add   t2, t0, t1        # t2 = c = a + b   (t2 = 134)

    # c = a - b;
    sub   t2, t0, t1        # t2 = c = a - b   (t2 = 44)
