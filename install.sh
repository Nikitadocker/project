#!/bin/bash
zip=terraform_1.2.8_linux_amd64.zip

wget https://hashicorp-releases.yandexcloud.net/terraform/1.2.8/terraform_1.2.8_linux_amd64.zip
apt install unzip
unzip $zip
mv ./terraform /usr/local/bin/
echo "check version"
terraform version
