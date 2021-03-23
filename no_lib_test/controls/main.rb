# coding: utf-8

network_expected_info = yaml(content: inspec.profile.file("network.yaml")).params
gce_expected_info = yaml(content: inspec.profile.file("gce.yaml")).params
project_id = ENV["TF_VAR_project"]


control "network" do
  title "vpc,subnetwork,firewallの設定"

  vpc_expected = network_expected_info["vpc"]
  subnetwork_expected = network_expected_info["subnetwork"]
  firewall_expected = network_expected_info["firewall"]

  vpc_actual = yaml(content: inspec.profile.file("vpc_actual.yaml"))
  subnetwork_actual = yaml(content: inspec.profile.file("subnetwork_actual.yaml"))
  firewall_actual = yaml(content: inspec.profile.file("firewall_actual.yaml"))

  firewall_actual.allowed.each do |rule|
    p rule.class
    p rule.inspect
  end

  describe vpc_actual do
    its(:name) { should cmp vpc_expected["name"] }
  end

  describe subnetwork_actual do
    its(:name) { should cmp subnetwork_expected["name"] }
    its(:region) { should match subnetwork_expected["region"] }
    its(:ipCidrRange) { should cmp subnetwork_expected["cidr"] }
  end

  describe firewall_actual do
    its(:name) { should cmp firewall_expected["name"] }
    its(:direction) { should cmp firewall_expected["direction"]}
    its(:priority) { should cmp firewall_expected["priority"] }
    its(:sourceRanges) { should be_in firewall_expected["source_ranges"]}
  end

  firewall_actual.allowed.each do |rule|
    describe "allowedRule" do
      it 'プロトコルがtcpであること' do
        expect(rule["IPProtocol"]).to eq firewall_expected["rule"]["protocol"]
      end

      it '許可ポートが80であること' do
        expect(rule["ports"]).to eq firewall_expected["rule"]["ports"]
      end
    end
  end

end

control "gce" do
  title "gce instance, diskの設定"

  instance_expected = gce_expected_info["instance"]
  disk_expected = gce_expected_info["disk"]

  instance_actual = yaml(content: inspec.profile.file("instance_actual.yaml"))
  disk_actual = yaml(content: inspec.profile.file("disk_actual.yaml"))

  describe instance_actual do
    its(:name) { should cmp instance_expected["name"] }
    its(:zone) { should match instance_expected["zone"] }
    its(:machineType) { should match instance_expected["machine_type"] }
  end

  instance_actual.networkInterfaces.each do |nic|
    describe "interfaces" do
      it 'GCEのサブネットワークの所属がsampleであること' do
        expect(nic["subnetwork"]).to match instance_expected["interface"]["subnetwork"]
      end
    end
  end

  instance_actual.disks.each do |disk|
    describe "disk" do
      it 'GCEのディスク名がsampleであること' do
        expect(disk["source"]).to match match instance_expected["disk_name"]
      end
    end
  end

  describe disk_actual do
    its(:name) { should cmp disk_expected["name"] }
    its(:zone) { should match disk_expected["zone"] }
    its(:sourceImage) { should match disk_expected["image"] }
    its(:sizeGb) { should cmp disk_expected["size"]}
  end
end
