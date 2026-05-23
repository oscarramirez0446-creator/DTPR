# Inicialización de variables (Ejemplo: MCD de 24 y 18, el resultado debe ser 6)
addi $s0, $zero, 24    # $s0 = a = 24
addi $s1, $zero, 18    # $s1 = b = 18

loop:
beq $s0, $s1, end      # Si a == b, terminamos, el MCD esta en $s0
slt $t0, $s1, $s0      # $t0 = 1 si (b < a)
bne $t0, $zero, a_mayor # Si b < a, saltamos a la etiqueta a_mayor

b_mayor:
sub $s1, $s1, $s0      # b = b - a
j loop                 # Repetir el ciclo

a_mayor:
sub $s0, $s0, $s1      # a = a - b
j loop                 # Repetir el ciclo

end:
sw $s0, 0($zero)       # Guardamos el resultado (MCD) en la RAM en la direccion 0
nop
nop