CINCによる自動テスト
==

# 概要

CINCによるGCPの設定をテストするコード

# ディレクトリ構成

```
.
├── README.md
├── cloudbuild
│   └── cloudbuild.yaml
├── helloworld
│   ├── controls
│   │   └── main.rb
│   ├── files
│   │   └── hello_world.yaml
│   ├── inspec.lock
│   └── inspec.yml
├── no_lib_test
│   ├── controls
│   │   └── main.rb
│   ├── files
│   │   ├── disk_actual.yaml
│   │   ├── firewall_actual.yaml
│   │   ├── gce.yaml
│   │   ├── instance_actual.yaml
│   │   ├── network.yaml
│   │   ├── subnetwork_actual.yaml
│   │   └── vpc_actual.yaml
│   ├── inspec.lock
│   ├── inspec.yml
│   └── scripts
│       └── main.sh
├── scripts
│   └── set_env.sh
├── src
│   ├── main.tf
│   ├── provider.tf
│   ├── terraform.tf
│   └── terragrunt.hcl
└── test
    ├── controls
    │   └── main.rb
    ├── files
    │   ├── gce.yaml
    │   └── network.yaml
    ├── inspec.lock
    └── inspec.yml
```
- helloworld: inspecコードのhelloworldが記述されているかのテスト
- src: nginxのGCEを作成するterraformコード
- test: nginxのGCEシステムのInspecのテストコード
- no_lib_test: nginxのGCEシステムのInspecのテストコード(gcpのライブラリを利用せずにテストを実施)
- cloudbuild: システムの構築・testを実施するcloudbuild.yamlファイル
- scripts: 実行のために必要な環境変数を設定するスクリプト


# 実行方法

- 環境構築

```
source scripts/set_env.sh
cd src
terragrunt run-all apply --terragrunt-non-interactive
```

- テスト方法

```
cinc-auditor exec ./test -t gcp://
```

- テスト方法(gcpのライブラリを使わないテスト)

```
cd no_lib_test
bash scripts/main.sh
cinc-auditor exec . -t gcp://
```

- 環境の削除方法

```
terragrunt run-all apply --terragrunt-non-interactive
```
