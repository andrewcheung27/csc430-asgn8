#####################
##
## abstract syntax definitions
##
#####################

# ExprCs inherit from this class
class ExprC
    def initialize()
    end
end

class NumC < ExprC
    def initialize(@num : Integer)
    end
end

class IdC < ExprC
    def initialize(@id : Symbol)
    end
end

class StrC < ExprC
    def initialize(@str : String)
    end
end

class IfC < ExprC
    def initialize(@do : ExprC, @test : ExprC, @els : ExprC)
    end
end

class LamC < ExprC
    def initialize(@do : Array(IdC), @body : ExprC)
    end
end

