#!/bin/bash

set -e

apt update
apt install -y curl sqlite3

arch=$(dpkg --print-architecture)
case $arch in
	amd64) arch="x64" ;;
	arm|armf|armhf) arch="arm" ;;
	arm64) arch="arm64" ;;
	*) echo "Unsupported architecture: $arch" && exit 1 ;;
esac

wget --content-disposition "https://services.sonarr.tv/v1/download/main/latest?version=4&os=linux&arch=$arch" -O ./Sonarr.tar.gz
tar -xvzf ./Sonarr.tar.gz -C ./

mkdir -p ./build/
mv ./Sonarr ./build/Sonarr/
mkdir -p ~/.sonarr-data

cat <<'EOF' > ./build/run.sh
#!/bin/bash

DATA_DIR=$(readlink -f "$HOME/.sonarr-data")
exec "./Sonarr/Sonarr" -nobrowser -data="$DATA_DIR"
EOF

chmod +x ./build/run.sh
rm ./Sonarr.tar.gz

echo "Build complete. Run './build/run.sh' to start Sonarr."
