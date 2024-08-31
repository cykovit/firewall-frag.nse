### firewall-frag.nse

## Overview

The `firewall-frag.nse` script is a custom Nmap Scripting Engine (NSE) script designed to test firewall evasion techniques by sending fragmented and obfuscated packets.

## Features

- **Packet Fragmentation**: Sends fragmented packets to the target to test firewall handling of packet reassembly.
- **Random Data Injection**: Appends random data with a random length to the end of packets to test if the firewall can handle non-standard data patterns.
- **Customizable Parameters**: Allows specification of the length of random data to include in packets.

## Usage

To use this script, place it in Nmap's scripts directory and run it with Nmap using the following command:

```sh
nmap --script firewall-frag -p <port> <target>
```

### Parameters

- **`<port>`**: The port number you want to test. Replace `<port>` with the actual port number (e.g., `80` for HTTP).
- **`<target>`**: The IP address or hostname of the target machine. Replace `<target>` with the actual IP address or hostname (e.g., `192.168.1.1`).

### Example Command

```sh
nmap --script firewall-frag -p 80 192.168.1.1
```

## Script Location

- **Nmap Scripts Directory**:
  - **Windows**: `C:\Program Files (x86)\Nmap\scripts\`
  - **Linux/macOS**: `/usr/share/nmap/scripts/`

## Prerequisites

- Nmap must be installed on your system.
- The script must be saved with the `.nse` extension in the Nmap scripts directory.

## Notes

- This script is intended for use in controlled environments for security testing purposes. Do not use it on networks or systems without proper authorization.
- The script may occasionally generate network traffic that could be detected by monitoring systems or affect network performance (ex: on modern firewall / IDS solutions).

## License

Same as Nmap: See [Nmap Legal](https://nmap.org/book/man-legal.html) for details.

For more information on NSE scripting and writing custom scripts, visit the [Nmap Scripting Engine documentation](https://nmap.org/book/nse.html).
