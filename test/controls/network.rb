# coding: utf-8
project = attribute('project')
network = yaml(content: inspec.profile.file('network.yaml'))
regular_perimeters = yaml(content: inspec.profile.file('perimeter_reguler_type.yaml')).params

network["subnetworks"].each do |subnet|
  control 'subnet' do
    title subnet + "test"

    describe google_compute_subnetwork(project: project["id"], region: subnet["region"], name: subnet["name"]) do
      it { should exist }
      its('ip_cidr_range') { should eq subnet["cidr"] }
    end
  end
end


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

control 'vpc-sc-regular' do

  title '標準境界にアクセスレベルと制限をかけるサービスが設定されているか'
  google_access_context_manager_access_policies(org_id: 173755487324).names.each do |policy_name|

    p policy_name
      regular_perimeters.each do | rg_pr |
        describe google_access_context_manager_service_perimeter(policy_name: policy_name, name: rg_pr["name"]) do

          it { should exist }

          # # プロジェクトIDが含まれているか
          rg_pr["projects"].each do |project_id|
            its('status.resources') { should include "projects/"+google_project(project: project_id).number }
          end

          # アクセスレベルが含まれているか
          # rg_pr["access_levels"].each do | access_level |
          #   al = "accessPolicies/" + policy_id + "/accessLevels/" + access_level
          #   its('status.access_levels') { should include al }
          # end

          # # 制限をかけるサービスが含まれているか
          # rg_pr["restricted_services"].each do | service |
          #   its('status.restricted_services') { should include service }
          # end
        end
      end
    end
end


