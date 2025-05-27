def reordenar_hex_little_endian(entrada_path, salida_path):
    # Leer el archivo de entrada (sin la cabecera)
    with open(entrada_path, "r") as f:
        lineas = f.readlines()

    # Eliminar espacios y saltos de línea
    hex_bytes = [line.strip() for line in lineas if line.strip()]

    # Normalizar a dos dígitos hexadecimales
    hex_normalizados = [f"{int(byte, 16):02x}" for byte in hex_bytes]

    # Reordenar en grupos de 4 bytes a little-endian
    resultado = []
    for i in range(0, len(hex_normalizados), 4):
        grupo = hex_normalizados[i:i+4]
        resultado.extend(grupo[::-1])  # invertir grupo

    # Escribir archivo de salida con cabecera
    with open(salida_path, "w") as f:
        f.write("v2.0 raw\n")
        for byte in resultado:
            f.write(byte.upper() + "\n")

    print(f"Archivo guardado en: {salida_path}")

# Ejemplo de uso:
entrada = "instructions_hex.hex"         # archivo de entrada
salida = "reordenado.hex"     # archivo de salida
reordenar_hex_little_endian(entrada, salida)
