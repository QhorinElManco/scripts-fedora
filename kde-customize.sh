#######################################################
# Install Better Blur 
#######################################################
echo "Installing Better Blur"
echo "Installing dependencies for Better Blur"
sudo dnf install -y git cmake extra-cmake-modules gcc-g++ kf6-kwindowsystem-devel plasma-workspace-devel libplasma-devel qt6-qtbase-private-devel qt6-qtbase-devel cmake kwin-devel extra-cmake-modules kwin-devel kf6-knotifications-devel kf6-kio-devel kf6-kcrash-devel kf6-ki18n-devel kf6-kguiaddons-devel libepoxy-devel kf6-kglobalaccel-devel kf6-kcmutils-devel kf6-kconfigwidgets-devel kf6-kdeclarative-devel kdecoration-devel kf6-kglobalaccel kf6-kdeclarative libplasma kf6-kio qt6-qtbase kf6-kguiaddons kf6-ki18n wayland-devel

# Download source
echo "Downloading source for Better Blur"
git clone https://github.com/taj-ny/kwin-effects-forceblur ~/kwin-effects-forceblur
cd ~/kwin-effects-forceblur

# Build
echo "Building Better Blur"
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=/usr
make -j
sudo make install

# Delete source
cd ~
rm -rf ~/kwin-effects-forceblur

#######################################################
# Install Kustom Breeze Enhanced
#######################################################

# Install dependencies for Kustom Breeze Enhanced
echo "Installing dependencies for Kustom Breeze Enhanced"
sudo dnf install -y kf6-kiconthemes-devel qt6-qt5compat-devel

# Download source
echo "Downloading source for Kustom Breeze Enhanced"
git clone https://github.com/Rudraksh88/KustomBreezeEnhanced.git ~/kwin-effects-kustom-breeze-enhanced

# Install
echo "Installing Kustom Breeze Enhanced"
cd ~/kwin-effects-kustom-breeze-enhanced
chmod +x install.sh
./install.sh

# Delete source
echo "Deleting source for Kustom Breeze Enhanced"
cd ~
rm -rf ~/kwin-effects-kustom-breeze-enhanced

#######################################################
# Install KDE Customization
#######################################################

# Download source
echo "Downloading source for KDE Rounded Corners"
git clone https://github.com/Rudraksh88/kde-kustom.git ~/kde-kustom
cd ~/kde-kustom

# Install the Zephyr.colors (Color scheme)
echo "Installing Zephyr.colors (Color scheme)"
cp Zephyr.colors ~/.local/share/color-schemes/

# Instaall KDE Rounded Corners
echo "Installing KDE Rounded Corners"
cd KDE-Rounded-Corners-0.7.0

# Build
echo "Building KDE Rounded Corners"
mkdir build
cd build
cmake ..
cmake --build . -j
sudo make install

# Load KDE Rounded Corners
echo "Loading KDE Rounded Corners"
sh ../tools/load.sh

# Auto install after Kwin update
echo "Auto install after Kwin update"
sh ../tools/install-autorun-test.sh

# Delete source
echo "Deleting source for KDE Rounded Corners"
cd ~
rm -rf ~/kde-kustom

#######################################################
# Install Wallpaper Engine KDE Plugin
#######################################################
echo "Installing Wallpaper Engine KDE Plugin"

# Install dependencies for Wallpaper Engine KDE Plugin
sudo dnf install -y lz4-devel

# Download source
git clone --recurse-submodules https://github.com/catsout/wallpaper-engine-kde-plugin.git ~/wallpaper-engine-kde-plugin
cd ~/wallpaper-engine-kde-plugin

# Build and install
echo "Building and installing Wallpaper Engine KDE Plugin"
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make -j$(nproc)
sudo make install

# Delete source
echo "Deleting source for Wallpaper Engine KDE Plugin"
cd ~
rm -rf ~/wallpaper-engine-kde-plugin

#######################################################
# Finish
#######################################################

echo "KDE Customization complete."