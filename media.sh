#!/bin/bash

# Install necessary packages
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository 'deb [arch=amd64] http://bd.archive.ubuntu.com/'
sudo apt install -y curl apt-transport-https gnupg


# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Add Portainer repository
sudo curl -L --fail https://downloads.portainer.io/portainer-ce/linux-amd64/latest | sudo docker load

# Install Docker and Docker Compose
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose

# Add user to Docker group
sudo usermod -aG docker $USER

# Start Docker service
sudo systemctl start docker

# Install Portainer
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

# Install Radarr
docker run -d \
  --name=radarr \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=Etc/UTC \
  -p 7878:7878 \
  -v /path/to/data/radarr:/config \
  -v /mnt/HDD/Media/Movies:/movies  \
  -v /mnt/HDD/Media/Downloads:/downloads \
  --restart unless-stopped \
lscr.io/linuxserver/radarr:latest

# Install Sonarr
docker run -d \
  --name=sonarr \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=Etc/UTC \
  -p 8989:8989 \
  -v /path/to/data/sonarr:/config \
  -v /mnt/HDD/Media/TV:/tv  \
  -v /mnt/HDD/Media/Downloads:/downloads  \
  --restart unless-stopped \
  lscr.io/linuxserver/sonarr:latest


# Install Transmission
docker run -d \
  --name=transmission \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=Etc/UTC \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v /path/to/data:/config \
  -v /mnt/HDD/Media/Downloads:/downloads \
  -v /mnt/HDD/Media/watchFolder:/watch \
  --restart unless-stopped \
  lscr.io/linuxserver/transmission:latest
  
# Install Jellyfin
docker run -d \
  --name=jellyfin \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=Etc/UTC \
  -p 8096:8096 \
  -v /path/to/data/jellyfin:/config \
  -v /mnt/HDD/Media/Movies:/Movies  \
  -v /mnt/HDD/Media/TV:/tv  \
  -v /mnt/HDD/Media/Downloads:/downloads  \
  --restart unless-stopped \
  lscr.io/linuxserver/jellyfin:latest


# Install Prowlarr
docker run -d \
  --name=prowlarr \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=Etc/UTC \
  -p 9696:9696 \
  -v /path/to/data/prowlarr:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/prowlarr:latest

# Install Heimdall 
docker run -d \
  --name=heimdall \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=Etc/UTC \
  -p 7080:80 \
  -p 7443:443 \
  -v /path/to/appdata/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/heimdall:latest

# Install Pivpn web
docker run -d -p 51821:51821 --name pivpn-web --restart=unless-stopped weejewel/pivpn-web

# Output installation completed message
echo "Installation completed."

