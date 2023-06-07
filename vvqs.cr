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
end
# identifier (symbols have to start with a colon in this language, so we're using strings instead)
class IdC < ExprC
    @id : String
    getter id
    def initialize(id : String)
        @id = id
    end
end
# string
class StrC < ExprC
    @str : String
    getter str
    def initialize(str : String)
        @str = str
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
end
# bool
class BoolV < ExprV
    @bool : Bool
    getter bool
    def initialize(bool : Bool)
        @bool = bool
    end
end
# str
class StrV < ExprV
    @str : String
    getter str
    def initialize(str : String)
        @str = str
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
end
# primitive operator
class PrimV < ExprV
    @op : String
    getter op
    def initialize(op : String)
        @op = op
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
end
# environment has a list of Bindings
class Environment
    @bindings : Array(Binding)
    getter bindings
    def initialize(bindings : Array(Binding))
        @bindings = bindings
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
    when StrC
        StrV.new(exp.str)
    else
        raise Exception.new("could not interp " + exp)
    end
end








#####################
##
## helper functions
##
#####################





#####################
##
## test cases
##
#####################


# need #to_s method to display as strings
# print(interp(NumC.new(69), top_env))
# print(interp(StrC.new("vvqs"), top_env))
