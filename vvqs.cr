#####################
##
## abstract syntax definitions
##
#####################



# ExprCs inherit from this
class ExprC
    def initialize()
    end
end
# num
class NumC < ExprC
    @num : Int64
    getter num
    def initialize(num : Int64)
        @num = num
    end
    def to_s(io : IO) 
        io << "NumC(#{num})"
    end
end
# identifier (symbols have to start with a colon in this language, so we're using strings instead)
class IdC < ExprC
    @id : String
    getter id
    def initialize(id : String)
        @id = id
    end
    def to_s(io : IO) 
        io << "IdC(#{id})"
    end
end
# string
class StrC < ExprC
    @str : String
    getter str
    def initialize(str : String)
        @str = str
    end
    def to_s(io : IO) 
        io << "StrC(#{str})"
    end
end
# conditional
class IfC < ExprC
    @exp : ExprC
    @test : ExprC
    @els : ExprC
    getter exp
    getter test
    getter els
    def initialize(exp : ExprC, test : ExprC, els : ExprC)
        @exp = exp
        @test = test
        @els = els
    end
    def to_s(io : IO) 
        io << "IfC(#{exp} #{test} #{els})"
    end
end
# function definition
class LamC < ExprC
    @params : Array(IdC)
    @body : ExprC
    getter params
    getter body
    def initialize(params : Array(IdC), body : ExprC)
        @params = params
        @body = body
    end
    def to_s(io : IO) 
        io << "LamC(#{params} #{body})"
    end
end
# function application
class AppC < ExprC
    @func : IdC
    @args : Array(ExprC)
    getter func
    getter args
    def initialize(func : IdC, args : Array(ExprC))
        @func = func
        @args = args
    end
    def to_s(io : IO) 
        io << "AppC(#{func} #{args})"
    end
end



# ExprVs inherit from this
class ExprV
    def initialize()
    end
end
# num
class NumV < ExprV
    @num : Int64
    getter num
    def initialize(num : Int64)
        @num = num
    end
    def to_s(io : IO) 
        io << "NumV(#{num})"
    end
end
# bool
class BoolV < ExprV
    @bool : Bool
    getter bool
    def initialize(bool : Bool)
        @bool = bool
    end
    def to_s(io : IO) 
        io << "BoolV(#{bool})"
    end
end
# str
class StrV < ExprV
    @str : String
    getter str
    def initialize(str : String)
        @str = str
    end
    def to_s(io : IO) 
        io << "StrV(#{str})"
    end    
end
# closure
class CloV < ExprV
    @params : Array(IdC)
    @body : ExprC
    @env : Environment
    getter params
    getter body
    getter env
    def initialize(params : Array(IdC), body : ExprC, env : Environment)
        @params = params
        @body = body
        @env = env
    end
    def to_s(io : IO) 
        io << "CloV(#{params} #{body} #{env})"
    end
end
# primitive operator
class PrimV < ExprV
    @op : String
    getter op
    def initialize(op : String)
        @op = op
    end
    def to_s(io : IO) 
        io << "PrimV(#{op})"
    end
end



# binding between an identifer and an ExprV
class Binding
    @name : IdC
    @val : ExprV
    getter name
    getter val
    def initialize(name : IdC, val : ExprV)
        @name = name
        @val = val
    end
    def to_s(io : IO) 
        io << "Binding(#{name} #{val})"
    end
end
# environment has a list of Bindings
class Environment
    @bindings : Array(Binding)
    getter bindings
    def initialize(bindings : Array(Binding))
        @bindings = bindings
    end
    def to_s(io : IO) 
        io << "Environment(#{bindings})"
    end
end

# top-level environment
top_env = Environment.new([
    Binding.new(IdC.new("+"), PrimV.new("+")), 
    Binding.new(IdC.new("-"), PrimV.new("-")), 
    Binding.new(IdC.new("*"), PrimV.new("*")), 
    Binding.new(IdC.new("/"), PrimV.new("/")), 
    Binding.new(IdC.new("<="), PrimV.new("<=")), 
    Binding.new(IdC.new("equal?"), PrimV.new("equal?")), 
    Binding.new(IdC.new("true"), BoolV.new(true)), 
    Binding.new(IdC.new("false"), BoolV.new(false)), 
    Binding.new(IdC.new("error"), PrimV.new("error"))
])
# these can't be used as identifiers
restr_ids = ["where", ":=", "if", "else", "=>"]

#####################
##
## interp
##
#####################

# Interpret ExprC to an ExprV (Converts AST to a Value) 
def interp(exp : ExprC, env : Environment)
    case exp
    when NumC
        NumV.new(exp.num)
    when StrC
        StrV.new(exp.str)
    when IdC
        lookup(exp.id, env)
    else
        raise Exception.new("could not interp " + exp)
    end
end



#####################
##
## helper functions
##
#####################

# Looks up the value of an IdC in the environment 
def lookup(id : String, env : Environment) : ExprV   
    if env.bindings.size() == 0
        raise Exception.new("VVQS #{id} name not found")
    end
    index = 0
    while index < env.bindings.size()
        binding = env.bindings[index]
        if binding.name.id == id
            return binding.val
        end
        index += 1
    end
    raise Exception.new("VVQS #{id} name not found")
end

#####################
##
## test cases
##
#####################

# need #to_s method to display as strings
# print(interp(NumC.new(69), top_env))
# print(interp(StrC.new("vvqs"), top_env))
# puts interp(StrC.new("vvqs"), top_env).to_s()
# puts interp(NumC.new(10), top_env).to_s()
# puts lookup(IdC.new("+"), top_env)
# puts lookup(IdC.new("-"), top_env)
# print(interp(IdC.new("+"), top_env))