require "spec"
require "./vvqs"


describe "Interp" do
    describe "Interpreting NumC" do
        it "returns the NumV with the correct value" do
            num = NumC.new(72)
            env = Environment.new([] of Binding)
            result = interp(num, env)
            result.should eq(NumV.new(72))
    end
end

    describe "Interpreting StrC" do
        it "interprets a StrC expression" do 
            env = Environment.new([] of Binding)
            exp = StrC.new("Hello, world!")
            result = interp(exp, env)
            result.should eq(StrV.new("Hello, world!"))
        end
    end
end

  describe "Serializer" do
    describe "serialize" do
      it "serializes a NumV" do
        value = NumV.new(10)
        result = serialize(value)
        result.should eq("10")
      end
    end
    it "serializes a StrV" do
        value = StrV.new("Cat")
        result = serialize(value)
        result.should eq("Cat")
    end
    it "serializes a BoolV" do
        value = BoolV.new(true)
        result = serialize(value)
        result.should eq("true")
    end
end
