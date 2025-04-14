#######################################################
# Setup RPM Fusion
#######################################################
echo "Installing RPM Fusion"
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf groupupdate core -y

#######################################################
# Upgrade system
#######################################################
echo "Upgrading system"
sudo dnf upgrade -y

#######################################################
#Setting umask to 077
# No one except wheel user and root get read/write files
#######################################################
echo "Setting umask to 077"
umask 077
sudo sed -i 's/umask 022/umask 077/g' /etc/bashrc

#######################################################
# Remove unused packages
#######################################################
echo "Removing unused packages"
sudo dnf remove -y anaconda* zd1211-firmware atmel-firmware libertas-usb8388-firmware abrt* bluez-cups alsa-sof-firmware boost-date-time orca fedora-bookmarks mailcap open-vm-tools samba-client libreswan unbound-libs podman yajl mediawriter nano nano-default-editor thermald sos kpartx dos2unix sssd cyrus-sasl-plain geolite2* traceroute ModemManager tcpdump mozilla-filesystem nmap-ncat spice-vdagent adcli mtr realmd teamd vpnc openconnect openvpn ppp pptp rsync xorg-x11-drv-vmware hyperv* virtualbox-guest-additions qemu-guest-agent dragon kmines kpat dnfdragora akregator kmail korganizer elisa-player kamoso kwrite konversation kolourpaint krdc kmahjongg kmouth krfb kcalc kcharselect kde-connect kgpg kamera kfind kmag media-player-info mediawriter kmouth

#######################################################
# Run Updates
#######################################################
echo "Running updates"

sudo dnf autoremove -y
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates -y
sudo fwupdmgr update -y

#######################################################
# Setup Flathub beta and third party packages
#######################################################
echo "Setting up Flathub third party packages"
sudo fedora-third-party enable
sudo fedora-third-party refresh

#######################################################
# Install apps from flatpak
#######################################################
echo "Installing apps from flatpak"
flatpak install -y flathub com.github.wwmm.easyeffects

#######################################################
# Install apps from fedora repositories
#######################################################
echo "Installing apps from fedora repositories"
sudo dnf install -y git discord telegram-desktop piper ckb-next direnv stacer plasma-browser-integration nano kvantum poetry vlc cascadia-fonts-all

# Configure direnv
echo "eval \"\$(direnv hook bash)\"" >> ~/.bashrc

#######################################################
# Install ASDF-VM
#######################################################
echo "Installing ASDF-VM"
sudo dnf install -y go
go install github.com/asdf-vm/asdf/cmd/asdf@v0.16.0
echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.bashrc.profile
echo '. <(asdf completion bash)' >> ~/.bashrc

#######################################################
# Install vivaldi
#######################################################
echo "Installing vivaldi"
sudo dnf config-manager addrepo --from-repofile=https://repo.vivaldi.com/archive/vivaldi-fedora.repo
sudo dnf install -y vivaldi-stable
# Delete duplicate repo
if [ -f /etc/yum.repos.d/vivaldi-fedora.repo ]; then
    echo "Deleting duplicate vivaldi repo"
    sudo rm -rf /etc/yum.repos.d/vivaldi-fedora.repo
fi
 
# Install VS Code
# echo "Installing VS Code"
# sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
# sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
# dnf check-update
# sudo dnf install -y code

# Install brave repository
# echo "Installing brave repository"
# sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
# sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

#######################################################
# Install docker
#######################################################
echo "Installing docker"
# sudo dnf -y install dnf-plugins-core
sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo groupadd docker
sudo usermod -aG docker $USER

# Install portainer to docker
echo "Installing portainer to docker"
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts

#######################################################
# Install drivers nvidia
#######################################################
sudo dnf install -y akmod-nvidia
sudo dnf install -y xorg-x11-drv-nvidia-cuda

#######################################################
# Finish
#######################################################
echo "Script completed successfully."