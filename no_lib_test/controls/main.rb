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

  describe "VPC" do
    it "VPC名が #{vpc_expected["name"]} である" do
      expect(vpc_actual[:name]).to eq vpc_expected["name"]
    end
  end

  describe "subnetwork" do
    it "サブネットワーク名が #{subnetwork_expected["name"]} である" do
      expect(subnetwork_actual[:name]).to eq subnetwork_expected["name"]
    end

    it "リージョンが #{subnetwork_expected["region"]} である" do
      expect(subnetwork_actual[:region]).to match subnetwork_expected["region"]
    end

    it "CIDRが #{subnetwork_expected["cidr"]} であること" do
      expect(subnetwork_actual[:ipCidrRange]).to eq subnetwork_expected["cidr"]
    end
  end

  describe "firewall" do
    it "ファイアーフォール名が #{firewall_expected["name"]} である" do
      expect(firewall_actual[:name]).to eq firewall_expected["name"]
    end

    it "方向が #{firewall_expected["direction"]} である" do
      expect(firewall_actual[:direction]).to eq firewall_expected["direction"]
    end

    it "プライオリティが #{firewall_expected["priority"]} である" do
      expect(firewall_actual[:priority]).to eq firewall_expected["priority"]
    end

    it "source rangeが #{firewall_expected["source_ranges"]} である" do
      expect(firewall_actual[:sourceRanges]).to eq firewall_expected["source_ranges"]
    end

    firewall_actual.allowed.each do |rule|
      it "プロトコルが #{firewall_expected["rule"]["protocol"]} である" do
        expect(rule["IPProtocol"]).to eq firewall_expected["rule"]["protocol"]
      end

      it "許可ポートが #{firewall_expected["rule"]["ports"]} である" do
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

  describe "GCE" do
    it "インスタンス名が #{instance_expected["name"]} である" do
      expect(instance_actual[:name]).to eq instance_expected["name"]
    end

    it "zoneが #{instance_expected["zone"]} である" do
      expect(instance_actual[:zone]).to match instance_expected["zone"]
    end

    it "マシンタイプが #{instance_expected["machine_type"]} である" do
      expect(instance_actual[:machineType]).to match instance_expected["machine_type"]
    end

    instance_actual.networkInterfaces.each do |nic|
      it "サブネットワークの所属が #{instance_expected["interface"]["subnetwork"]} であること" do
        expect(nic["subnetwork"]).to match instance_expected["interface"]["subnetwork"]
      end
    end

    instance_actual.disks.each do |disk|
      it "ブートディスク名が#{instance_expected["disk_name"]}である" do
        expect(disk["source"]).to match match instance_expected["disk_name"]
      end
    end
  end

  describe "GCEDisk" do
    it "ディスク名が #{disk_expected["name"]} である" do
      expect(disk_actual[:name]).to eq disk_expected["name"]
    end

    it "ゾーンが #{disk_expected["zone"]} である" do
      expect(disk_actual[:zone]).to match disk_expected["zone"]
    end

    it "イメージが #{disk_expected["image"]} である" do
      expect(disk_actual[:sourceImage]).to match disk_expected["image"]
    end

    it "サイズが#{disk_expected["size"]}GBであること" do
      expect(disk_actual[:sizeGb]).to eq disk_expected["size"]
    end
  end
end
