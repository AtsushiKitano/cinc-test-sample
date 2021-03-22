# coding: utf-8
network_expected_info = yaml(content: inspec.profile.file("network.yaml")).params
gce_expected_info = yaml(content: inspec.profile.file("gce.yaml")).params
project_id = ENV["TF_VAR_project"]


control "network" do
  title "vpc,subnetwork,firewallの設定"

  vpc_expected = network_expected_info["vpc"]
  subnetwork_expected = network_expected_info["subnetwork"]
  firewall_expected = network_expected_info["firewall"]

  vpc_actual = yaml(content: inspec.profile.file("vpc_actual.yaml")).params
  subnetwork_actual = yaml(content: inspec.profile.file("subnetwork_actual.yaml")).params
  firewall_actual = yaml(content: inspec.profile.file("firewall_actual.yaml")).params

  describe vpc_actual["name"] do
    it { should cmp vpc_expected["name"] }
  end

  describe subnetwork_actual["name"] do
    it { should cmp subnetwork_expected["name"] }
  end

  describe subnetwork_actual["region"] do
    it { should match subnetwork_expected["region"] }
  end

  describe subnetwork_actual["ipCidrRange"] do
    it { should cmp subnetwork_expected["cidr"] }
  end

  describe firewall_actual["name"] do
    it { should cmp firewall_expected["name"] }
  end

  describe firewall_actual["direction"] do
    it { should cmp firewall_expected["direction"]}
  end

  describe firewall_actual["priority"] do
    it { should cmp firewall_expected["priority"] }
  end

  describe firewall_actual["sourceRanges"] do
    it { should be_in firewall_expected["source_ranges"]}
  end

  firewall_actual["allowed"].each do |rule|
    describe rule["IPProtocol"] do
      it { should cmp firewall_expected["rule"]["protocol"] }
    end

    describe rule["ports"] do
      it { should be_in firewall_expected["rule"]["ports"] }
    end
  end

end

control "gce" do
  title "gce instance, diskの設定"

  instance_expected = gce_expected_info["instance"]
  disk_expected = gce_expected_info["disk"]

  instance_actual = yaml(content: inspec.profile.file("instance_actual.yaml")).params
  disk_actual = yaml(content: inspec.profile.file("disk_actual.yaml")).params

  describe instance_actual["name"] do
    it { should cmp instance_expected["name"] }
  end

  describe instance_actual["zone"] do
    it { should match instance_expected["zone"] }
  end

  describe instance_actual["machineType"] do
    it { should match instance_expected["machine_type"] }
  end

  instance_actual["networkInterfaces"].each do |nic|
    describe nic["subnetwork"] do
      it { should match instance_expected["interface"]["subnetwork"] }
    end
  end

  instance_actual["disks"].each do |disk|
    describe disk["source"] do
      it { should match instance_expected["disk_name"]}
    end
  end

  describe disk_actual["name"] do
    it { should cmp disk_expected["name"] }
  end

  describe disk_actual["zone"] do
    it { should match disk_expected["zone"] }
  end

  describe disk_actual["sourceImage"] do
    it { should match disk_expected["image"] }
  end

  describe disk_actual["sizeGb"] do
    it { should cmp disk_expected["size"]}
  end

end
