def procesar_archivo_hex(nombre_archivo):
    # Leer todos los bytes
    with open(nombre_archivo, 'r') as f:
        lines = [line.strip() for line in f if line.strip()]

    # Validar múltiplos de 4
    if len(lines) % 4 != 0:
        raise ValueError("El número de líneas no es múltiplo de 4")

    # Inicializar listas para los 4 archivos
    columnas = [[] for _ in range(4)]

    # Llenar columnas
    for i in range(0, len(lines), 4):
        for j in range(4):
            # Convertir a int y luego a hexadecimal de 2 dígitos
            byte_hex = format(int(lines[i + j], 16 if 'x' in lines[i + j].lower() else 10), '02X')
            columnas[j].append(byte_hex)

    # Escribir en archivos separados con cabecera
    for i in range(4):
        with open(f"{i+1}.hex", 'w') as f:
            f.write("v2.0 raw\n")
            for byte in columnas[i]:
                f.write(byte + '\n')

    print("✅ Archivos 1.hex, 2.hex, 3.hex y 4.hex generados con cabecera para Digital.")

# Ejecución
procesar_archivo_hex("instructions_hex.hex")
