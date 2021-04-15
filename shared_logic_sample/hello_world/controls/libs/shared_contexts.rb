# coding: utf-8
require 'json'
RSpec.shared_context "hello_world_context" do |file_path, expected|
  let(:actual){ (yaml(content: inspec.profile.file(file_path)).params)["name"] }

  it "file contents is expectd at shared_context" do
    expect(actual).to eq expected
  end

end


RSpec.shared_context "hello_world_command" do |expected_network, project|
  let(:actual){ JSON.parse(command("gcloud compute networks describe --project #{project} #{expected_network} --format json").stdout) }

  it "gcloudコマンドで#{expected_network}が、#{project}に作成されていることを確認する" do
    expect(actual["name"]).to eq "sample"
  end

end
