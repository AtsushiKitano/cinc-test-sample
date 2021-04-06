RSpec.shared_examples "hello_world_example" do |file_path, expected|
  let(:actual){ (yaml(content: inspec.profile.file(file_path)).params)["name"] }

  it "file contents is expected at shared_example" do
    expect(actual).to eq expected
  end
end
