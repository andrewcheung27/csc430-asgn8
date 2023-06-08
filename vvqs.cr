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
    @num : Int32
    getter num
    def initialize(num : Int32)
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
    def to_s(io : IO) 
        io << "IfC(#{if_true} #{test} #{if_false})"
    end
    def to_s(io : IO) 
        io << "IfC(#{if_true} #{test} #{if_false})"
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
    @num : Int32
    getter num
    def initialize(num : Int32)
        @num = num
    end
    def ==(other)
        other.is_a?(NumV) && other.num == @num
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
    def ==(other)
        other.is_a?(BoolV) && other.bool == @bool
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
    def ==(other)
        other.is_a?(StrV) && other.str == @str
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
    def ==(other)
        other.is_a?(CloV) &&
          other.params == @params &&
          other.body == @body &&
          other.env == @env
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
    def ==(other)
        other.is_a?(PrimV) && other.op == @op
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

# a Hash mapping strings to their operators
two_arg_primops = {
    "+" => ->(l : Int32, r : Int32) {l + r}, 
    "-" => ->(l : Int32, r : Int32) {l - r},
    "*" => ->(l : Int32, r : Int32) {l * r},
    "/" => ->(l : Int32, r : Int32) {vvqs_division(l, r)}, 
    "<=" => ->(l : Int32, r : Int32) {l <= r}}
# these can't be used as identifiers
restr_ids = ["where", ":=", "if", "else", "=>"]





#####################
##
## interp
##
#####################

# Interpret ExprC to an ExprV (Converts AST to a Value) 
def interp(exp : ExprC, env : Environment) : ExprV
    case exp
    when NumC
        return NumV.new(exp.num)
    when StrC
        return StrV.new(exp.str)
    when IdC
        lookup(exp.id, env)

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
## serialize
##
#####################

# serialize converts an ExprV to a String
def serialize(val : ExprV) : String
    case val
    when NumV
        return val.num.to_s
    when BoolV
        if val.bool
            return "true"
        else
            return "false"
        end
    when StrV
        return val.str
    when CloV
        return "#<procedure>"
    when PrimV
        return "#<primop>"
    else 
        raise Exception.new("VVQS: could not serialize " + val.to_s())
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



# vvqs_division divides two nums, converts the result to an integer, raises an error if denominator is zero
def vvqs_division(l : Int32, r : Int32) : Int32
    if r == 0
        raise Exception.new("VVQS: division by zero: " + l.to_s() + " / " + r.to_s())
    else (l / r).to_i()
    end
end



# interp-prim takes a primitive operator and its arguments, 
# returns the Value of the operator applied to the args, 
# or an error if there is the wrong number of args or an arg is the wrong type
def interp_prim(op : IdC, args : Array(ExprV)) : ExprV
    # covers +, -, *, /, and <=
    if two_arg_primops.has_key?(op.id)
        if args.size() > 2
            raise Exception.new("VVQS: " + op.id + " applied with more than two args")
        end
        if args.size() < 2
            raise Exception.new("VVQS: " + op.id + " applied with less than two args")
        end
        if !args[0].is_a?(NumV) | !args[1].is_a?(NumV)
            raise Exception.new("VVQS: " + op.id + " applied with a non-num arg")
        end
        return two_arg_primops[op.id].call(args[0].num, args[1].num)
    else
        raise Exception.new("VVQS: invalid primitive operator '" + op.id + "'")
    end

    if op.id == "equal?"
        if args.size() > 2
            raise Exception.new("VVQS: " + op.id + " applied with more than two args")
        end
        if args.size() < 2
            raise Exception.new("VVQS: " + op.id + " applied with less than two args")
        end
        # return true if neither arg is a CloV or PrimV, and they are equal
        # this line is super long, I'm not sure how to split it into two lines
        return !args[0].is_a?(CloV) & !args[1].is_a?(CloV) & !args[0].is_a?(PrimV) & !args[1].is_a?(PrimV) & args[0] == args[1]
        
    end
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

puts(serialize(interp(NumC.new(69), top_env)))
