require "spec"
require "./vvqs"


describe "interp" do
  it "interprets a NumC expression" do
    env = Environment.new([] of Binding)
    exp = NumC.new(42)
    result = interp(exp, env)
    result.should eq(NumV.new(42))
  end
end

  it "looks up/matches an IdC expression in the environment" do
    env = Environment.new([
      Binding.new(IdC.new("x"), NumV.new(10)),
      Binding.new(IdC.new("y"), StrV.new("Cat")), 
      Binding.new(IdC.new("z"), NumV.new(30))
    ] of Binding)
    exp = IdC.new("x")
    result = interp(exp, env)
    result.should eq(NumV.new(10))
  end

  it "interprets a StrC expression" do 
    env = Environment.new([] of Binding)
    exp = StrC.new("Hello, world!")
    result = interp(exp, env)
    result.should eq(StrV.new("Hello, world!"))
  end
end
