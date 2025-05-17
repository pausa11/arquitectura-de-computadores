'''
Este primer programa calcula el checksum de un mensaje pero toma los dos últimos bits 
de la suma de byes exclusivamente en HEXADECIMAL.

NOTA: Usar este programa solo cuando el checksum normal no este en dos bits, sino en 3.

'''

# Cálculo del complemento A2 de un número hexadecimal de 1 byte
def a2ComplementHEX(numHexa):
    # Convertimos a entero
    num = int(numHexa, 16)
    complement = (256 - num) & 0xFF  
    # Retornamos el resultado en hexadecimal con 2 dígitos
    return f"{complement:02X}"

# Cálculo del checksum de un mensaje en formato Intel Hex
def checkSumHEX(expressionHexa):
    # Dividimos la expresión en partes de 2 caracteres (1 byte cada una)
    expressionHexa = [expressionHexa[i:i+2] for i in range(0, len(expressionHexa), 2)]
    # Sumar los valores de los bytes
    total = sum(int(byte, 16) for byte in expressionHexa)
    # Tomar solo los últimos 8 bits de la suma
    total = total & 0xFF  # Aseguramos que sea un byte (8 bits)
    # Calcular el complemento a 2
    return a2ComplementHEX(f"{total:02X}")


'''
Este primer programa calcula el checksum de un mensaje pero toma los dos últimos bits 
de la suma de byes exclusivamente en BINARIO.

NOTA: Puede usar este programa, pero debe tener cuidado cuando le genere un checksum de 3 bits.

'''

#Cálculo del complemento A2 de un número hexadecimal de 1 byte
def a2ComplementBIN(numHexa):
    num = bin(int(numHexa, 16))[2:]
    num = num.zfill(8)
    
    num = list(num)

    for i in range(len(num)):
        if num[i] == '0':
            num[i] = '1'
        else:
            num[i] = '0'
    
    num = ''.join(num) 
    num = bin(int(num, 2) + 1)[2:]
    num = num.zfill(8)
    num = hex(int(num, 2))[2:].upper()

    return num

#Cálculo del checksum de un mensaje
def checkSumBIN(expressionHexa):
    #Se divide la expresion en partes de 2 caracteres
    expressionHexa = [expressionHexa[i:i+2] for i in range(0, len(expressionHexa), 2)]
    #Sumar los valores de los bytes
    sum = 0
    for i in expressionHexa:
        sum += int(i, 16)
    
    #Convertir la suma a hexadecimal
    sum = hex(sum)[2:].upper()

    #Tomar solo los últimos 8 bits
    sum = sum[-2:]

    return a2ComplementBIN(sum)


if __name__ == "__main__":
    operation = input("Ingrese la operación a realizar (HEX o BIN): ")
    expression = input("Ingrese la expresión en hexadecimal: ")
    if operation == "HEX":
        print("Checksum: ", checkSumHEX(expression))
    else:
        print("Checksum:", checkSumBIN(expression))