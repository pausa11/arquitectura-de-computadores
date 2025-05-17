import os

class IntelHexGenerator:
    def __init__(self, output_file="insts.hex"):
        self.start_address = 0  # Dirección inicial de memoria
        self.output_file = output_file

    @staticmethod
    def a2Complement(numHexa):
        num = bin(int(numHexa, 16))[2:]
        num = num.zfill(8)
        
        num = list(num)
        for i in range(len(num)):
            num[i] = '1' if num[i] == '0' else '0'
        
        num = ''.join(num) 
        num = bin(int(num, 2) + 1)[2:]
        num = num.zfill(8)
        return hex(int(num, 2))[2:].upper().zfill(2)

    @staticmethod
    def checkSum(expressionHexa):
        expressionHexa = [expressionHexa[i:i+2] for i in range(0, len(expressionHexa), 2)]
        total_sum = sum(int(byte, 16) for byte in expressionHexa)
        total_sum = hex(total_sum)[2:].upper()[-2:]  # Últimos 8 bits
        return IntelHexGenerator.a2Complement(total_sum)

    def generate_line(self, instruction, address):
        size = "04"  # Tamaño en bytes (siempre 4 bytes en este caso)
        address_hex = hex(address)[2:].zfill(4).upper()
        record_type = "00"  # Tipo de registro de datos
        data = f"{size}{address_hex}{record_type}{instruction}"
        checksum = self.checkSum(data)
        return f":{data}{checksum}"

    def generate_hex_file(self, instructions):
        lines = []
        address = self.start_address
        for instruction in instructions:
            line = self.generate_line(instruction, address)
            lines.append(line)
            address += 16  # Incrementar dirección en 2 bytes (16 bits)
        
        # Agregar la última línea obligatoria
        lines.append(":00000001FF")
        return lines

    def save_to_file(self, instructions_block, folder_path):
        # Crear la carpeta si no existe
        os.makedirs(folder_path, exist_ok=True)

        # Construir la ruta completa al archivo
        file_path = os.path.join(folder_path, self.output_file)

        # Procesar instrucciones desde un bloque multilinea
        instructions = instructions_block.strip().split('\n')
        hex_lines = self.generate_hex_file(instructions)
        
        # Escribir en archivo
        with open(file_path, "w") as file:
            for line in hex_lines:
                file.write(line + "\n")

        #Dar color al print y que muestre el nombre del archivo
        print(f"'\033[1;32;40mArchivo {self.output_file} generado con éxito.\033[0m'")


if __name__ == "__main__":
    # Instrucciones como un bloque de texto
    instructions_block = """\
fe010113
00112e23
00812c23
02010413
00c00793
fef42623
fec42703
00100793
00e7c663
00100793
03c0006f
00100793
fef42423
0200006f
fe842703
fec42783
02f707b3
fef42423
fec42783
fff78793
fef42623
fec42703
00100793
fce7cee3
fe842783
00078513
01c12083
01812403
02010113
00008067

"""

    # Ruta de la carpeta donde se guardará el archivo
    folder_path = r"C:\Users\Asus\Documents\Universidad\Arquitectura\Procesador Monociclo"

    # Generar y guardar el archivo
    generator = IntelHexGenerator()
    generator.save_to_file(instructions_block, folder_path)
