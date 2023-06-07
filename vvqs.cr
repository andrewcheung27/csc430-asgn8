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
    @if_true : ExprC
    @test : ExprC
    @if_false : ExprC
    getter if_true
    getter test
    getter if_false
    def initialize(if_true : ExprC, test : ExprC, if_false : ExprC)
        @if_true = if_true
        @test = test
        @if_false = if_false
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
        return NumV.new(exp.num)

    when StrC
        return StrV.new(exp.str)

    when IfC
        test_interped = interp(exp.test, env)
        if !exp.is_a?(BoolV)
            raise Exception.new("VVQS: test was not a boolean at conditional " + exp)
        elsif test_interped
            return interp(exp.if_true, env)
        else
            return interp(exp.if_false, env)
        end

    when LamC
        return CloV.new(exp.args, exp.body, env)

    else
        raise Exception.new("VVQS: could not interp " + exp)
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
