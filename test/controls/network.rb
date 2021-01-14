project = attribute('project')
network = yaml(content: inspec.profile.file('network.yaml'))

control 'network' do
  title 'demo network'
  impact 'critical'

  describe google_compute_network(project: project["id"], name: network["name"]) do
    it { should exist }
  end

  network["subnetworks"].each do |subnet|
    describe google_compute_subnetwork(project: project["id"], region: subnet["region"], name: subnet["name"]) do
      it { should exist }
      its('ip_cidr_range') { should eq subnet["cidr"] }
    end
  end
end
