### `firewall-frag.nse`

## Overview

`firewall-frag.nse` is a custom Nmap Scripting Engine (NSE) script designed to test firewall evasion techniques by sending fragmented and obfuscated packets. It aims to evaluate how well a firewall handles fragmented traffic and non-standard data patterns.

## Features

- **Packet Fragmentation**: Sends fragmented IP packets to the target to assess the firewall’s handling of packet reassembly.
- **Random Data Injection**: Appends random data with a length that can vary up to a specified maximum, allowing for the testing of firewall robustness against obfuscated data.
- **Customizable Parameters**: Allows you to specify the maximum length of the random data to include in the packets, offering flexibility for different testing scenarios.

## Usage

To use this script, place it in Nmap's scripts directory and run it with Nmap using the following command:

```sh
nmap --script firewall-frag --script-args random_data_length=<length> -p <port> <target>
```

### Parameters

- **`<port>`**: The port number you want to test. Replace `<port>` with the actual port number (e.g., `80` for HTTP).
- **`<target>`**: The IP address or hostname of the target machine. Replace `<target>` with the actual IP address or hostname (e.g., `192.168.1.1`).
- **`random_data_length`**: Optional argument specifying the maximum length of random data to append to the packet payload. The value should be a positive integer. Default is `1024` if not provided.

### Example Command

```sh
nmap --script firewall-frag --script-args random_data_length=512 -p 80 192.168.1.1
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
- The script may occasionally generate network traffic that could be detected by monitoring systems or affect network performance, particularly on modern firewalls or intrusion detection systems.

## License

Same as Nmap: See [Nmap Legal](https://nmap.org/book/man-legal.html) for details.

For more information on NSE scripting and writing custom scripts, visit the [Nmap Scripting Engine documentation](https://nmap.org/book/nse.html).
