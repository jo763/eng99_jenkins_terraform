- Install Terraform plugin on Jenkins
- Go to Manage Jenkins --> Global Tool Configuration
-

- Go to terraform.io, copy the link address for the amd64 Linux
```
sudo apt install unzip
```
- type wget <and paste the link>
`unzip` <name of zipped file>
- Adding Terraform to path
```
sudo mv terraform /usr/bin
```
- Check if terraform has been added to path
```
terraform --version
```
