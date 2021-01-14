project = attribute('project')
network = yaml(content: inspec.profile.file('network.yaml'))

control 'network' do
  title 'demo network'
  impact 'critical'

  describe google_compute_network(project: project["id"], name: network["name"]) do
    it { should exist }
  end
end
