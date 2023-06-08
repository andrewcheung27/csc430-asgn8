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
require "spec"
require "./Assgn9"

  it "interprets a StrC expression" do 
    env = Environment.new([] of Binding)
    exp = StrC.new("Hello, world!")
    result = interp(exp, env)
    result.should eq(StrV.new("Hello, world!"))
  end
end
