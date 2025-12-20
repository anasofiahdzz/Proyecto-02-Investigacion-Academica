-- CompiladorSimple.hs

module CompiladorSimple ( Expr(..), Op(..), Code, Stack, eval, comp, exec, correct, ejemplo) where


-- Lenguaje fuente, que solo tiene valores y sumas. Maso parecido a la definición McCarthy - Painter
data Expr
  = Val Int
  | Add Expr Expr
  deriving (Show, Eq)


-- Intérprete simple del lenguaje fuente. Se calcula el resultado directamente.
eval :: Expr -> Int
eval (Val n)   = n
eval (Add x y) = eval x + eval y


-- Lenguaje destino, que solo mete en la pila o suma.
data Op
  = PUSH Int
  | ADD
  deriving (Show, Eq)


type Code  = [Op]
type Stack = [Int]


-- Compilador que convierte el árbol de la expresión en una lista de operaciones.
comp :: Expr -> Code
comp (Val n)   = [PUSH n]
comp (Add x y) = comp x ++ comp y ++ [ADD]


-- Para ejecutar el código. Usamos Either para manejar el error de intentar sumar con una pila vacía.
exec :: Code -> Stack -> Either String Stack
exec [] s = Right s
exec (PUSH n : c) s = exec c (n : s)
-- Tomamos m y n, y volvemos a llamar exec con la suma en la pila. 
exec (ADD : c) (m : n : s) = exec c (n + m : s)
exec (ADD : _) _ = Left "Pila insuficiente para ADD"


-- Ver si el resultado de compilar y ejecutar es igual al resultado de evaluar.
correct :: Expr -> Bool
correct e = exec (comp e) [] == Right [eval e]

-- Ejemplo de programa fuente.
ejemplo :: Expr
ejemplo = Add (Val 1) (Add (Val 2) (Val 3))
