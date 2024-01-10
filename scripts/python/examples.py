for i in range(5):
    print("Número:", i)

def saludar(nombre, saludo="Hola"):
    print(saludo, nombre)

saludar("Carlos")
saludar("Carlos","Chau")

try:
    resultado = 10 / 0
except ZeroDivisionError:
    print("División por cero.")
