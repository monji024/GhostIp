# GhostIp

Ruby-based Tor identity rotator. Spins up/reloads the Tor daemon on an interval, confirms the new exit IP against multiple fallback endpoints, and optionally locks down all non-Tor traffic with an iptables kill switch.

## Features

- Multi-endpoint IP verification with retry/backoff (no single point of failure)
- Optional geo lookup on the current exit node
- YAML config file, overridable via CLI flags
- iptables kill switch (`-k`) to block leaks if Tor drops
- Session stats: rotation count, failures, unique IP count, uptime
- Logs to `/tmp/ghostip.log` by default

## Install

```
git clone https://github.com/monji024/GhostIp.git
cd GhostIp
chmod +x install.sh
sudo ./install.sh
```

## Run

```
sudo ruby main.rb
```

Non-interactive:

```
sudo ruby main.rb -i 30 -n 10 -y
```

With kill switch:

```
sudo ruby main.rb -k
```

## Options

```
-c, --config PATH     path to config.yml
-i, --interval SEC    rotation interval
-n, --count N         number of rotations, 0 = infinite
-k, --kill-switch     block non-tor traffic while running
-q, --quiet           suppress console logging
-y, --yes             skip prompts, use flags/defaults
```

## Port 9050 already in use

```
sudo fuser -k 9050/tcp
```

## License

MIT © monji
