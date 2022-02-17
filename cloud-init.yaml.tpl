#cloud-config

%{if length(ssh_authorized_keys) > 0 }
ssh_authorized_keys:
%{for line in ssh_authorized_keys}
- ${line}
%{endfor}
%{endif}

package_update: true
package_upgrade: true

mounts:
- [ ${storage_server_ip}:/mnt/media, /media, "nfs", "nfsvers=4.1,hard", "0", "0" ]

runcmd:
  - 'curl https://downloads.plex.tv/plex-keys/PlexSign.key | apt-key add -'
  - 'echo deb https://downloads.plex.tv/repo/deb public main > /etc/apt/sources.list.d/plexmediaserver.list'
  - 'apt update'
  - 'DEBIAN_FRONTEND=noninteractive apt -o Dpkg::Options::=--force-confnew install --no-install-recommends -y nvidia-driver-510 nfs-common plexmediaserver qemu-guest-agent'
  - [ systemctl, daemon-reload ]
  - [ systemctl, enable, --now, plexmediaserver.service ]
  - [ systemctl, enable, --now, qemu-guest-agent.service ]
  - [ reboot ]
