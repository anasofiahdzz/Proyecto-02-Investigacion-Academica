-- Pequeño ejemplo: expresiones con sumas y una máquina de pila

-- 1. Lenguaje fuente: expresiones
data Expr
  = Val Int           -- número
  | Add Expr Expr     -- suma
  deriving (Show, Eq)

-- 2. Intérprete del lenguaje fuente
eval :: Expr -> Int
eval (Val n)     = n
eval (Add x y)   = eval x + eval y

-- 3. Lenguaje destino: operaciones de la máquina de pila
data Op
  = PUSH Int      -- meter un número a la pila
  | ADD           -- sumar los dos de arriba
  deriving (Show, Eq)

type Code  = [Op]   -- programa compilado
type Stack = [Int]  -- pila de enteros

-- 4. Compilador: Expr -> Code
comp :: Expr -> Code
comp (Val n)   = [PUSH n]
comp (Add x y) = comp x ++ comp y ++ [ADD]

-- 5. Máquina de pila: ejecuta el Code
exec :: Code -> Stack -> Stack
exec [] s = s

exec (PUSH n : c) s =
  exec c (n : s)

exec (ADD : c) (m : n : s) =
  exec c (n + m : s)

exec _ _ =
  error "Programa o pila inválidos"

-- 6. Propiedad de correctitud (para probar en GHCi)
correct :: Expr -> Bool
correct e =
  exec (comp e) [] == [eval e]
