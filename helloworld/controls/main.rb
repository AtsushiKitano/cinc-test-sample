actual = yaml(content: inspec.profile.file("hello_world.yaml"))

describe actual do
  its(:name) { should eq "HelloWorld" }
end
