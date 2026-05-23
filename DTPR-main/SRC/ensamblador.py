import sys
import re

# ==========================================
# 1. DICCIONARIOS DE MIPS (Basados en tu Fase 1, 2 y 3)
# ==========================================
registros = {
    "$zero": "00000", "$at": "00001", "$v0": "00010", "$v1": "00011",
    "$a0": "00100", "$a1": "00101", "$a2": "00110", "$a3": "00111",
    "$t0": "01000", "$t1": "01001", "$t2": "01010", "$t3": "01011",
    "$t4": "01100", "$t5": "01101", "$t6": "01110", "$t7": "01111",
    "$s0": "10000", "$s1": "10001", "$s2": "10010", "$s3": "10011",
    "$s4": "10100", "$s5": "10101", "$s6": "10110", "$s7": "10111"
}

# Formato: "instruccion": ("Tipo", "Opcode", "Funct(si aplica)")
opcodes = {
    "add":  ("R", "000000", "100000"),
    "sub":  ("R", "000000", "100010"),
    "and":  ("R", "000000", "100100"),
    "or":   ("R", "000000", "100101"),
    "slt":  ("R", "000000", "101010"),
    "nop":  ("R", "000000", "000000"),
    "addi": ("I", "001000"),
    "lw":   ("I", "100011"),
    "sw":   ("I", "101011"),
    "beq":  ("I", "000100"),
    "bne":  ("I", "000101"),
    "j":    ("J", "000010")
}

# Convierte un número a binario complemento a 2
def to_bin(value, bits):
    if value < 0:
        value = (1 << bits) + value
    return format(value, f'0{bits}b')

# ==========================================
# 2. LÓGICA DEL ENSAMBLADOR
# ==========================================
def ensamblar(archivo_entrada, archivo_salida):
    try:
        with open(archivo_entrada, 'r') as f:
            lineas = f.readlines()
    except FileNotFoundError:
        print(f"Error: No se encontro el archivo {archivo_entrada}")
        return

    instrucciones = []
    etiquetas = {}
    
    # PRIMERA PASADA: Limpiar código y registrar etiquetas
    for linea in lineas:
        linea = linea.split('#')[0].strip() # Quitar comentarios
        if not linea: continue
        
        if ':' in linea:
            partes = linea.split(':')
            nombre_etiqueta = partes[0].strip()
            etiquetas[nombre_etiqueta] = len(instrucciones) # Guardar en qué número de instrucción va
            instruccion = partes[1].strip()
            if instruccion:
                instrucciones.append(instruccion)
        else:
            instrucciones.append(linea)

    codigo_maquina = []

    # SEGUNDA PASADA: Traducir a binario de 32 bits
    for i, inst in enumerate(instrucciones):
        # Separar mnemónico de los operandos
        partes = inst.replace(',', ' ').split()
        mnemonico = partes[0].lower()
        
        if mnemonico not in opcodes:
            print(f"Error: Instruccion '{mnemonico}' no soportada.")
            continue
            
        tipo = opcodes[mnemonico][0]
        opcode = opcodes[mnemonico][1]

        if tipo == "R":
            if mnemonico == "nop":
                codigo_maquina.append("00000000000000000000000000000000")
            else:
                rd = registros[partes[1]]
                rs = registros[partes[2]]
                rt = registros[partes[3]]
                funct = opcodes[mnemonico][2]
                shamt = "00000"
                codigo_maquina.append(f"{opcode}{rs}{rt}{rd}{shamt}{funct}")
                
        elif tipo == "I":
            if mnemonico in ["beq", "bne"]:
                rs = registros[partes[1]]
                rt = registros[partes[2]]
                etiqueta = partes[3]
                # Salto relativo: (Destino - Actual - 1)
                offset = etiquetas[etiqueta] - i - 1
                inmediato = to_bin(offset, 16)
                codigo_maquina.append(f"{opcode}{rs}{rt}{inmediato}")
            elif mnemonico in ["lw", "sw"]:
                rt = registros[partes[1]]
                # Parsear el formato: offset($rs)
                match = re.match(r"(-?\d+)\((\$\w+)\)", partes[2])
                inmediato = to_bin(int(match.group(1)), 16)
                rs = registros[match.group(2)]
                codigo_maquina.append(f"{opcode}{rs}{rt}{inmediato}")
            else: # addi
                rt = registros[partes[1]]
                rs = registros[partes[2]]
                inmediato = to_bin(int(partes[3]), 16)
                codigo_maquina.append(f"{opcode}{rs}{rt}{inmediato}")
                
        elif tipo == "J":
            etiqueta = partes[1]
            # Dirección absoluta de salto
            target = to_bin(etiquetas[etiqueta], 26)
            codigo_maquina.append(f"{opcode}{target}")

    # Guardar archivo binario
    with open(archivo_salida, 'w') as f:
        for binario in codigo_maquina:
            f.write(binario + '\n')
            
    print(f"¡Exito! Se decodificaron {len(codigo_maquina)} instrucciones.")
    print(f"Archivo generado: {archivo_salida}")

# Ejecución
if __name__ == "__main__":
    ensamblar("mcd.asm", "memoria.txt")