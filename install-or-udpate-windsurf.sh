#!/bin/bash
set -e

DOWNLOADS_DIR="$HOME/Descargas"
DESKTOP_ENTRY="$HOME/.local/share/applications/windsurf.desktop"

echo "Searching for newest Windsurf tarball in $DOWNLOADS_DIR..."
tarball=$(ls -t "$DOWNLOADS_DIR"/Windsurf*.tar* 2 >/dev/null | head -n1)
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
if [ -d "$HOME/windsurf" ]; then
    mv "$HOME/windsurf" "$HOME/windsurf_old"
    echo "Existing folder moved to windsurf_old."
fi

echo ""

echo "Moving new Windsurf folder to HOME..."
mv "$extracted_dir" "$HOME/windsurf"
rm -rf "$HOME/windsurf_old"
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
Exec=${HOME}/windsurf/windsurf
Icon=${HOME}/windsurf/resources/app/resources/linux/code.png
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

echo "Adding Windsurf to PATH..."
export PATH=$PATH:$HOME/windsurf/bin

echo ""
echo "Installation/update complete."