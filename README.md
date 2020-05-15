# CentOS 7 with real time kernel for vagrant and virtualbox

## Preamle
This project was based on Bento project as recomended by Hashicorp for vagrant. All scripts except rt-kernel.sh was cloned from bento project and modifyed to drop all non CentOS 7 code and ready to build updated centos 7 box with latest kernel and real time patches.

To change CentOS release, modify centos-7-rt.json in packer folder with apropriate path to centos mirror and iso name.

To change kernel verion, modify rt-kernel.sh in packer/scripts folder with apropriate kernel and rt patch version.
Latest available rt patch can be found at https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/.
All additional software for installation can be added either to ks.cfg in packer/http or to rt-kernel.sh (see line yum install ...).

Be aware! From kernel 5.x preemtible configuration was changed and not compatible with previous kernels. Path to configuration parameter for make menuconfig can be found in rt-kernel.sh.

To test on newer kernels uncomment line with make menuconfig in rt-kernel.sh and run it on standalone centos machine.

## Usage
packer build --name centos-7-rt centos-7-rt.json

Result box will be saved in packer/builds folder. All build, including rt kernel is automated.

Latest box with kernel 5.6.10 is available in VagrantCloud as a4t3rburn3r/centos-7-rt
Use:
vagrant init a4t3rburn3r/centos-7-rt to initialise it.

Sample Vagrantfile is available.

More information can be found at https://github.com/chef/bento
