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
    def initialize(@num : Integer)
    end
end
# identifier (symbols have to start with a colon in this language, so we're using strings instead)
class IdC < ExprC
    def initialize(@id : String)
    end
end
# string
class StrC < ExprC
    def initialize(@str : String)
    end
end
# conditional
class IfC < ExprC
    def initialize(@do : ExprC, @test : ExprC, @els : ExprC)
    end
end
# function definition
class LamC < ExprC
    def initialize(@do : Array(IdC), @body : ExprC)
    end
end
# function application
class AppC < ExprC
    def initialize(@func : IdC, @args : Array(ExprC))
    end
end



# ExprVs inherit from this
class ExprV
    def initialize()
    end
end
# num
class NumV < ExprV
    def initialize(@num : Integer)
    end
end
# bool
class BoolV < ExprV
    def initialize(@bool : Bool)
    end
end
# str
class StrV < ExprV
    def initialize(@str : String)
    end
end
# closure
class CloV < ExprV
    def initialize(@params : Array(IdC), @body : ExprC, @env : Environment)
    end
end
# primitive operator
class PrimV < ExprV
    def initialize(@op : String)
    end
end



# binding between an identifer and an ExprV
class Binding
    def initialize(@name : IdC, @val : ExprV)
    end
end
# environment has a list of Bindings
class Environment
    def initialize(@bindings : Array(Binding))
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

def interp(exp : ExprC, env : Environment)
    case exp
    when NumC
        NumV.new(exp.num)
    else
        raise Exception.new("could not interp " + exp)
    end
end
