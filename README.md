# Compilar y ejecutar
## ejemplos
Abrir terminal en:
/Proyecto-02-Investigacion-Academica/src
>> ghci MiniCompilador.hs

1. Lenguaje fuente AST
>> let e1 = Add (Const 2) (Const 3)
>> e1
SALIDA: Add (Const 2) (Const 3)

2. Intérprete del AST
>> evalExpr [] (Add (Const 2) (Const 3))
SALIDA: 5

>> let prog = [Assign "x" (Add (Const 2) (Const 3)), Assign "y" (Add (Var "x") (Const 4))]
>> runProgramAST prog
SALIDA: [("x",5), ("y",9)]

3. Bytecode y máquina
>> let codigo = [PUSH 2, PUSH 3, ADD, STORE "x"]
>> exec codigo [] []
SALIDA: ([("x",5)], [])

4. Compilador AST a Code
>> let code = compilaPrograma prog
>> code
SALIDA: [PUSH 2,PUSH 3,ADD,STORE "x",LOAD "x",PUSH 4,ADD,STORE "y"]

5. Verificacion de correctitud
>> verificarCorrectitud prog
SALIDA: True



