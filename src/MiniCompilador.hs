-- Mini compilador con variables y asignaciones

-- Expresiones:
--   - número constante
--   - variable
--   - suma de dos expresiones
data Expr
  = Const Int
  | Var String
  | Add Expr Expr
  deriving (Show, Eq)

-- Sentencias:
--   - asignación:  nombre = expresión
data Stmt
  = Assign String Expr
  deriving (Show, Eq)

-- Un programa es una lista de sentencias (líneas)
type Program = [Stmt]

-- ===============Entorno============
  -- Entorno: lista de pares (nombre, valor)
type Env = [(String, Int)]

-- Busca el valor de una variable en el entorno
buscarVariable :: String -> Env -> Int
buscarVariable x [] = error ("Variable no definida: " ++ x)
buscarVariable x ((y,v) : resto)
  | x == y    = v
  | otherwise = buscarVariable x resto

-- Actualiza (o inserta) una variable en el entorno
actualizarVariable :: String -> Int -> Env -> Env
actualizarVariable x v [] = [(x, v)]
actualizarVariable x v ((y,w) : resto)
  | x == y    = (x, v) : resto
  | otherwise = (y, w) : actualizarVariable x v resto

-- Evalúa una expresión usando el entorno
evalExpr :: Env -> Expr -> Int
evalExpr env (Const n)   = n
evalExpr env (Var x)     = buscarVariable x env
evalExpr env (Add e1 e2) =
  let v1 = evalExpr env e1
      v2 = evalExpr env e2
  in v1 + v2

-- Ejecuta una sentencia y regresa el nuevo entorno
ejecutarSentencia :: Env -> Stmt -> Env
ejecutarSentencia env (Assign x e) =
  let v = evalExpr env e
  in actualizarVariable x v env

-- Ejecuta un programa completo empezando con entorno vacío
runProgramAST :: Program -> Env
runProgramAST prog = runProgAux prog []

-- Función recursiva auxiliar
runProgAux :: Program -> Env -> Env
runProgAux [] env = env
runProgAux (s:resto) env =
  let env' = ejecutarSentencia env s
  in runProgAux resto env'

------------- 3. Bytecode y máquina-----------------

-- Instrucciones de la máquina de pila
data Op
  = PUSH Int       -- meter un número a la pila
  | LOAD String    -- cargar el valor de una variable y meterlo a la pila
  | STORE String   -- sacar de la pila y guardarlo en una variable
  | ADD            -- sumar los dos de arriba de la pila
  deriving (Show, Eq)

type Code  = [Op]
type Stack = [Int]

-- Estado de la máquina: entorno + pila
type VMEnv = Env

-- Ejecuta una instrucción sobre el estado (entorno y pila)
paso :: Op -> VMEnv -> Stack -> (VMEnv, Stack)
paso (PUSH n) env pila =
  (env, n : pila)

paso (LOAD x) env pila =
  let v = buscarVariable x env
  in (env, v : pila)

paso (STORE x) env pila =
  case pila of
    []      -> error "Pila vacía en STORE"
    (v:restoPila) ->
      let env' = actualizarVariable x v env
      in (env', restoPila)

paso ADD env pila =
  case pila of
    (m:n:restoPila) ->
      let s = n + m
      in (env, s : restoPila)
    _ ->
      error "Pila insuficiente para ADD"

-- Ejecuta un programa en bytecode
exec :: Code -> VMEnv -> Stack -> (VMEnv, Stack)
exec [] env pila = (env, pila)
exec (op:ops) env pila =
  let (env', pila') = paso op env pila
  in exec ops env' pila'

-----------------------------
-- 4. Compilador AST → Code
-----------------------------

-----------------------------
-- 5. Verificación de correctitud
-----------------------------