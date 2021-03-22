# coding: utf-8
network_expected_info = yaml(content: inspec.profile.file("network.yaml")).params
gce_expected_info = yaml(content: inspec.profile.file("gce.yaml")).params
project_id = ENV["TF_VAR_project"]


control "network" do
  title "vpc,subnetwork,firewallの設定"

  vpc_expected = network_expected_info["vpc"]
  subnetwork_expected = network_expected_info["subnetwork"]
  firewall_expected = network_expected_info["firewall"]

  vpc_actual = google_compute_network(project: project_id, name: vpc_expected["name"])
  subnetwork_actual = google_compute_subnetwork(project: project_id, region: subnetwork_expected["region"], name: subnetwork_expected["name"])
  firewall_actual = google_compute_firewall(project: project_id, name: firewall_expected["name"])

  describe vpc_actual do
    it { should exist }
    its("name") { should cmp vpc_expected["name"] }
  end

  describe subnetwork_actual do
    it { should exist }
    its("name") { should cmp subnetwork_expected["name"] }
    its("region") { should match subnetwork_expected["region"] }
    its("ip_cidr_range") { should cmp subnetwork_expected["cidr"] }
  end

  describe firewall_actual do
    it { should exist }
    its("name") { should cmp firewall_expected["name"] }
    its("direction") { should cmp firewall_expected["direction"]}
    its("priority") { should cmp firewall_expected["priority"] }
    its("source_ranges") { should be_in firewall_expected["source_ranges"]}
  end

  firewall_actual.allowed.each do |rule|
    describe rule do
      its("ip_protocol") { should cmp firewall_expected["rule"]["protocol"] }
      its("ports") { should be_in firewall_expected["rule"]["ports"] }
    end
  end
end

control "gce" do
  title "gce instance, diskの設定"

  instance_expected = gce_expected_info["instance"]
  disk_expected = gce_expected_info["disk"]

  instance_actual = google_compute_instance(project: project_id, zone: instance_expected["zone"] ,name: instance_expected["name"])
  disk_actual = google_compute_disk(project: project_id, name: instance_expected["name"], zone: instance_expected["zone"])

  describe instance_actual do
    it { should exist }
    its("name") { should cmp instance_expected["name"] }
    its("zone") { should match instance_expected["zone"] }
    its("machine_type") { should match instance_expected["machine_type"] }
  end

  instance_actual.network_interfaces.each do |nic|
    describe nic do
      its("subnetwork") { should match instance_expected["interface"]["subnetwork"] }
    end
  end

  instance_actual.disks.each do |disk|
    describe disk do
      its("source") { should match instance_expected["disk_name"]}
    end
  end

  describe disk_actual do
    it { should exist }
    its("name") { should cmp disk_expected["name"] }
    its("zone") { should match disk_expected["zone"] }
    its("source_image") { should match disk_expected["image"] }
    its("size_gb") { should cmp disk_expected["size"]}
  end

end
