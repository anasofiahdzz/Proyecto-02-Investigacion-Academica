-- CompiladorElaborado.hs

-- Para funciones avanzadas.
{-# LANGUAGE DeriveGeneric #-}


module CompiladorElaborado ( Expr(..), Stmt(..), Program, Env, Op(..), Code, Stack, buscarVariable, actualizarVariable 
  , evalExpr, ejecutarSentencia, runProgramAST, compilaExpresion, compilaSentencia, compilaPrograma, paso, exec
  , ejecutaPrograma, verificarCorrectitud, ejemplo1, ejemplo2) where


import qualified Data.Map.Strict as Map


-- Lenguaje fuente. Definimos las constantes, variables y la suma entre estas. 
data Expr
  = Const Int
  | Var String
  | Add Expr Expr
  deriving (Show, Eq)


-- Asignaciones del tipo Var = Expr.
data Stmt
  = Assign String Expr
  deriving (Show, Eq)


-- Un programa lo dejamos una lista de asignaciones.
type Program = [Stmt]
-- El entorno es un mapa que asocia nombres de variables con enteros.
type Env = Map.Map String Int


-- Buscamos una variable en el mapa. Si no existe, devolvemos un error.
buscarVariable :: String -> Env -> Either String Int
buscarVariable x env = maybe (Left ("Variable no definida: " ++ x)) Right (Map.lookup x env)


-- Agrega o actualiza el valor de una variable en el mapa.
actualizarVariable :: String -> Int -> Env -> Env
actualizarVariable = Map.insert


-- Evaluamos una expresión de forma recursiva.
evalExpr :: Env -> Expr -> Either String Int
-- Const, le ponemos el mismo n.
evalExpr _ (Const n) = Right n
-- Var, la buscamos en el entorno.
evalExpr env (Var x) = buscarVariable x env
-- Add, evaluamos ambos lados.
evalExpr env (Add e1 e2) = do
  v1 <- evalExpr env e1
  v2 <- evalExpr env e2
  -- Al final, lo sumamos.
  pure (v1 + v2)



-- Ejecutamos una asignación.
ejecutarSentencia :: Env -> Stmt -> Either String Env
ejecutarSentencia env (Assign x e) = do
-- Evaluamos la expresión de la derecha.
  v <- evalExpr env e
-- Actualiza el entorno con el nuevo valor de la varaible.
  pure (actualizarVariable x v env)


-- Ejecuta un programa completo empezando con un entorno vacío.
runProgramAST :: Program -> Either String Env
runProgramAST = go Map.empty
  where
    -- Si ya no hay más sentencias, regresamos el entorno final.
    go env [] = Right env
    -- Ejecuta la primera sentencia.
    go env (s:ss) = do
      env' <- ejecutarSentencia env s
      -- Del entorno resultante para las siguientes.
      go env' ss



-- Lenguaje destino.
data Op
  -- Metemos un número a la pila.
  = PUSH Int
  -- Cargamos el valor de una variable y lo metemos a la pila.
  | LOAD String
  -- Sacamos el tope de la pila y lo guardamos en una variable.
  | STORE String
  -- Sacamos dos valores de la pila, los suma y metemos el resultado.
  | ADD
  deriving (Show, Eq)

-- El código es una lista de operaciones secuenciales.
type Code = [Op]
-- La pila es una lista de enteros.
type Stack = [Int]


-- Definición de que hace una sola instrucción.
paso :: Op -> Env -> Stack -> Either String (Env, Stack)
-- Poner n en la pila.
paso (PUSH n) env pila = Right (env, n : pila)
-- Busca la variable y la pone el pila.
paso (LOAD x) env pila = do
  v <- buscarVariable x env
  Right (env, v : pila)
-- Guardamos y limpiamos el tope.
paso (STORE x) env pila =
  case pila of
    [] -> Left "Pila vacía en STORE"
    (v:resto) -> Right (actualizarVariable x v env, resto)
-- Suma los dos primeros y pone el resultado.
paso ADD env pila =
  case pila of
    (m:n:resto) -> Right (env, (n + m) : resto)
    _ -> Left "Pila insuficiente para ADD"


-- Recursión sobre la lista de operaciones.
exec :: Code -> Env -> Stack -> Either String (Env, Stack)
exec [] env pila = Right (env, pila)
exec (op:ops) env pila = do
  (env', pila') <- paso op env pila
  exec ops env' pila'


-- Transforma una expresión en instrucciones de pila.
compilaExpresion :: Expr -> Code
compilaExpresion (Const n) = [PUSH n]
compilaExpresion (Var x)   = [LOAD x]
compilaExpresion (Add e1 e2) = compilaExpresion e1 ++ compilaExpresion e2 ++ [ADD]


-- Transforma una asignación en instrucciones de la expresión. 
compilaSentencia :: Stmt -> Code
compilaSentencia (Assign x e) = compilaExpresion e ++ [STORE x]


-- Une el código de todas las sentencias del programa.
compilaPrograma :: Program -> Code
compilaPrograma = concatMap compilaSentencia


-- Ejecución completa. 
ejecutaPrograma :: Program -> Either String Env
ejecutaPrograma prog = do
  let codigo = compilaPrograma prog
  (envFinal, _pilaFinal) <- exec codigo Map.empty []
  pure envFinal


-- La carnita del programa. Compara si el intérprete y el compilador dan el mismo entorno final.
verificarCorrectitud :: Program -> Either String Bool
verificarCorrectitud prog = do
  envAST <- runProgramAST prog
  envBC  <- ejecutaPrograma prog
  pure (envAST == envBC)



ejemplo1 :: Program
ejemplo1 = [ Assign "x" (Const 2) , Assign "y" (Add (Var "x") (Const 3)) ]


ejemplo2 :: Program
ejemplo2 = [ Assign "x" (Const 10) , Assign "y" (Add (Var "x") (Add (Const 2) (Const 5)))
  , Assign "x" (Add (Var "y") (Var "x")) ]
