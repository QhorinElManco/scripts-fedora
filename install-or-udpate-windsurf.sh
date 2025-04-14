#!/bin/bash
set -e

DOWNLOADS_DIR="$HOME/Descargas"
INSTALL_DIR="$HOME/.local/share/windsurf"
DESKTOP_ENTRY="$HOME/.local/share/applications/windsurf.desktop"

echo "Searching for newest Windsurf tarball in $DOWNLOADS_DIR..."
tarball=$(ls -t "$DOWNLOADS_DIR"/Windsurf*.tar* 2>/dev/null | head -n1)
if [ -z "$tarball" ]; then
    echo "No Windsurf tarball found in $DOWNLOADS_DIR."
    exit 1
fi
echo "Found newest Windsurf tarball: $tarball"

echo ""

echo "Creating temporary directory and extracting Windsurf tarball..."
temp_dir=$(mktemp -d)
tar -xf "$tarball" -C "$temp_dir"
echo "Extraction complete."

echo ""

echo "Identifying extracted folder..."
if [ -d "$temp_dir/windsurf" ]; then
    extracted_dir="$temp_dir/windsurf"
    echo "Folder named 'windsurf' found."
else
    folder=$(find "$temp_dir" -mindepth 1 -maxdepth 1 -type d | head -n1)
    mv "$folder" "$temp_dir/windsurf"
    extracted_dir="$temp_dir/windsurf"
    echo "Renamed extracted folder to 'windsurf'."
fi

echo ""

echo "Checking for nested 'Windsurf' folder..."
if [ -d "$extracted_dir/Windsurf" ]; then
    mv "$extracted_dir/Windsurf/"* "$extracted_dir/"
    rmdir "$extracted_dir/Windsurf"
    echo "Moved contents from nested 'Windsurf' folder up."
fi

echo ""

echo "Moving existing Windsurf folder to windsurf_old for later deletion..."
if [ -d "$INSTALL_DIR" ]; then
    mv "$INSTALL_DIR" "${INSTALL_DIR}_old"
    echo "Existing folder moved to windsurf_old."
fi

echo ""

echo "Moving new Windsurf folder to HOME..."
mv "$extracted_dir" "$INSTALL_DIR"
rm -rf "${INSTALL_DIR}_old"
echo "Windsurf folder updated."

echo ""

echo "Removing tarball from Downloads..."
rm -f "$tarball"
echo "Tarball deleted."

echo ""

echo "Checking for existing desktop entry..."
if [ -f "$DESKTOP_ENTRY" ]; then
    echo "Desktop entry exists; skipping creation."
else
    echo "No desktop entry found; configuring desktop entry."
    mkdir -p "$(dirname "$DESKTOP_ENTRY")"
    cat >"$DESKTOP_ENTRY" <<EOF
[Desktop Entry]
Type=Application
Name=Windsurf
Exec=$INSTALL_DIR/windsurf
Icon=$INSTALL_DIR/resources/app/resources/linux/code.png
Terminal=false
Categories=Utility;
EOF
    echo "Desktop entry configured."
fi

echo ""

echo "Cleaning up temporary files..."
rm -rf "$temp_dir"

echo "Updating desktop database..."
update-desktop-database ~/.local/share/applications/

echo ""
read -p "Do you want to add Windsurf to the path to run it from anywhere? (y/n):" add_to_path

if [[ "$add_to_path" =~ ^[Yy]$ ]]; then
    echo 'export PATH=$PATH:$HOME/.local/share/windsurf/bin' >> ~/.bashrc
    source ~/.bashrc
    echo "Windsurf has been added to the path. Restart your terminal to apply the changes."
else
    echo "Windsurf did not add to the path. You can do it manually later if you wish."
fi

echo ""
echo "Installation/update complete."