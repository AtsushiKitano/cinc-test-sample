control 'network' do
  title 'demo network'
  impact 'critical'

  describe google_compute_network(project: 'ca-kitano-study-sandbox', name: 'default') do
    it { should exist }
  end
end
