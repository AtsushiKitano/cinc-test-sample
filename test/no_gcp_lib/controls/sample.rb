# coding: utf-8

conf = yaml(content: inspec.profile.file('./conf.yaml')).params

control 'command-sample' do
  title 'テキストファイルの内容を確認できるか'
  impact 'critical'

  describe command('cat ./test/no_gcp_lib/logs/sample.txt') do
    its('stdout') { should eq conf["pj"] }
  end
end
