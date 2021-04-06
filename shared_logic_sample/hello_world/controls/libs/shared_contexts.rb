RSpec.shared_context "hello_world_context" do |file_path, expected|
  let(:actual){ (yaml(content: inspec.profile.file(file_path)).params)["name"] }

  it "file contents is expectd at shared_context" do
    expect(actual).to eq expected
  end

end
