# Proyecto 02 - Compiladores

## Compiladores (2026 - 1)
**Profesor :** Manuel Soto Romero \
**Ayudantes :** Diego Méndez Medina & José Alejandro Pérez Márquez\
**Ayudantes. Lab. :** Jose Manuel Evangelista Tiburcio & Fausto David Hernández Jasso

## Integrantes del equipo
- Ana Sofı́a Hernández Zavala
- Daniela Alejandra Sanluis Castillo 
- Vı́ctor Manuel Mendiola Montes

## Organización de Carpetas
```
Proyecto-02/
|
| - Bibliografía/
|   |
|   | - Todos los recursos con los que realizamos el trabajo...
| 
| - paper/
|   |
|   | - Todos los recursos de latex e imagenes usadas...
|
| - src/
|   | - CompiladorElaborado.hs
|   | - CompiladorSimple.hs
|
| - Trabajo/
|   | - Proyecto02 - Compilador Correcto.pdf (Nuestra investigación)
|
| - README.md (Este archivo)
```

## Ejecución de modulos
El único requerimiento es tener instalado `ghci`. \
Primero, necesitamos situarnos en la carpeta *src/* y abrir una terminal. Dentro, para ejecutar cualquier modulo
necesitamos ejecutar `ghci CompiladorSimple.hs` ó `ghci CompiladorElaborado.hs`. 

En *CompiladorSimple.hs* ya tenemos definido un ejemplo con el nombre de `ejemplo` (Lo sabemos, nos la volamos con el nombre :D). En este modulo solo tenemos tres comandos:
```
correct ejemplo
exec (comp ejemplo) []
eval ejemplo
```
Donde `correct` nos dice si el resultado (booleano) en la pila tras ejecutar el código compilado coincide con la evaluación directa. \
`exec (comp _ ) []` nos dice si el programa compilado deja un único resultado en la pila. \
`eval` nos regresa la evaluación directa en AST.

De forma análoga, en *CompiladorElaborado.hs* ya tenemos definidos dos ejemplos (`ejemplo1` y `ejemplo2`). Los comandos para este modulo son:
```
verificarCorrectitud ejemplo1
runProgramAST ejemplo1
ejecutaPrograma ejemplo1
compilaPrograma ejemplo1
```
Donde `verificarCorrectitud` nos dice si no hubo errores y si los entornos finales son iguales. \
`runProgramAST` ejecuta el programa sin compilarlo con la semántica del lenguaje fuente. \
`ejecutaPrograma` ejecuta el programa compilado. \
`compilaPrograma` imprime qué es lo que traduce el compilador y cómo se ejecuta.

Nota para ambos modulos. Si se desea definir otro ejemplo (bajo las reglas del modulo) con el mismo nombre de `ejemplo` u otro nombre, es posible hacerlo y probarlo con el programa. Si la definición del ejemplo tiene otro nombre, solo debemos sustituir el nombre por la palabra `ejemplo` en los comandos. Por ejemplo, si definimos un segundo ejemplo `prueba`, entonces debemos ejecutar `correct prueba` ó `ejecutaPrograma prueba` (por decir dos comandos).

