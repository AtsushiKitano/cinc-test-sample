# coding: utf-8

control 'command-sample' do
  title 'テキストファイルの内容を確認できるか'
  impact 'critical'

  describe command('cat ./files/sample.txt') do
    its('stdout') { should eq 'ca-kitano-study-sanddbox' }
  end
end
