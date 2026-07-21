#!/usr/bin/env bash
set -e

echo -e "\e[1;35minstalling GhostIp dependencies\e[0m"

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y tor ruby ruby-dev build-essential
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y tor ruby ruby-devel gcc make
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -Sy --noconfirm tor ruby base-devel
else
  echo -e "\e[1;31munsupported package manager, install tor + ruby manually\e[0m"
  exit 1
fi

if ! gem list -i socksify >/dev/null 2>&1; then
  sudo gem install socksify
fi

sudo systemctl enable tor 2>/dev/null || true
sudo service tor start 2>/dev/null || sudo systemctl start tor

echo -e "\e[1;32mdone. run with: ruby main.rb\e[0m"
