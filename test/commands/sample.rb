# coding: utf-8

control 'command-sample' do
  title 'テキストファイルの内容を確認できるか'
  impact 'critical'

  describe command('cat ./test/logs/sample.txt') do
    its('stdout') { should eq 'ca-kitano-study-sandbox' }
  end
end
