require_relative('libs/shared_contexts')
require_relative('libs/shared_examples')

describe "hello_world_example" do
  it_behaves_like "hello_world_example", "hello_world.yaml" , "HelloWorld"
end

describe "hello_world_shared" do
  it_behaves_like "hello_world_context", "hello_world.yaml" , "HelloWorld"
end

describe "command" do
  it_behaves_like "hello_world_command", "sample", "ca-kitano-study-sandbox"
end
