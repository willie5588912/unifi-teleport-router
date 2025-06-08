# Teleport Route Checker

Automatic route management for Teleport interfaces on UniFi gateways.

## Overview

This package provides a systemd service that automatically manages network routes for Teleport (tlprtX) interfaces. It monitors for new Teleport connections and adds appropriate routes to ensure proper connectivity.

## Features

- Automatic route detection and creation for teleport interfaces
- Systemd timer-based execution (every 30 seconds)
- Comprehensive logging via systemd journal
- Safe operation with dry-run testing capability
- Easy installation via debian package

## Building

```bash
make build
```

## Installation

```bash
sudo make install
```

## Testing

Test the script without making changes:
```bash
make test
```

## Management

Check service status:
```bash
make status
```

View logs:
```bash
make logs
```

Uninstall:
```bash
sudo make uninstall
```

## Manual Commands

- Start: `sudo systemctl start teleport-route-checker.timer`
- Stop: `sudo systemctl stop teleport-route-checker.timer`
- Status: `sudo systemctl status teleport-route-checker.timer`
- Logs: `sudo journalctl -u teleport-route-checker.service -f`

## Route Pattern

The service automatically creates routes following this pattern:
- tlprt0 → 192.168.3.5
- tlprt1 → 192.168.3.7
- tlprtN → 192.168.3.(5 + 2*N)

## Safety

This tool is designed for production use with minimal risk:
- Read-only operations until route addition needed
- Only adds missing routes, never removes existing ones
- Comprehensive logging for audit trails
- Can be disabled instantly if issues arise