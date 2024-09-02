--[[ 
  @description This script sends fragmented IP packets to a target with stealth techniques applied, 
  such as random fragment sizes and delays, to evade firewalls that may not correctly handle fragmented and obfuscated traffic.
  @usage nmap --script firewall-frag --script-args random_data_length=<length> -p <port> <target>
  @categories stealth, discovery, firewall-bypass
--]]

local nmap = require "nmap"
local shortport = require "shortport"
local stdnse = require "stdnse"
local packet = require "packet"
local ipOps = require "ipOps"
local math = require "math"

description = [[
This script sends fragmented IP packets to a target with stealth techniques applied, 
such as random fragment sizes and delays, to evade firewalls that may not correctly handle fragmented and obfuscated traffic.
]]

author = "cykovit & db"
license = "Same as Nmap--See https://nmap.org/book/man-legal.html"
categories = {"stealth", "discovery", "firewall-bypass"}

portrule = shortport.port_or_service({80, 443}, "http")

-- generate random data with a random length between 0 and a specified maximum 
local function random_data(max_length)
  local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:',.<>/?`~"
  local random_length = math.random(0, max_length) -- random length between 0 and max_length (1024 by default)
  local random_data = {}

  for i = 1, random_length do
    local rand_index = math.random(1, #chars)
    table.insert(random_data, chars:sub(rand_index, rand_index))
  end

  return table.concat(random_data)
end

-- add random delays between packet fragments
local function random_delay(min_delay, max_delay)
  local delay = math.random(min_delay, max_delay)
  stdnse.sleep(delay)
end

-- send fragmented packets with stealth tactics
local function send_fragmented_packets(host, port, max_random_data_length)
  local ip_src = nmap.get_interface_info().address
  local ip_dst = host.ip
  local port_dst = port.number
  local proto = "tcp"
  local packet_data = "GET / HTTP/1.1\r\nHost: " .. host.ip .. "\r\n\r\n"

  -- append random data 
  if max_random_data_length > 0 then
    packet_data = packet_data .. random_data(max_random_data_length)
  end

  -- random fragment size within a range
  local min_frag_size = 8
  local max_frag_size = 16 -- mimic more natural traffic
  local fragments = {}
  local current_index = 1

  -- generate fragments with random sizes
  while current_index <= #packet_data do
    local frag_size = math.random(min_frag_size, max_frag_size)
    table.insert(fragments, packet_data:sub(current_index, current_index + frag_size - 1))
    current_index = current_index + frag_size
  end

  local socket = nmap.new_dnet()

  -- send each fragment as a separate IP packet
  for frag_index, fragment in ipairs(fragments) do
    local ip_packet = packet.Packet:new()
    ip_packet.ip_bin_src = ipOps.ip_to_bin(ip_src)
    ip_packet.ip_bin_dst = ipOps.ip_to_bin(ip_dst)
    ip_packet.ip_offset = (frag_index - 1) * min_frag_size / 8 -- Calculate offset based on minimum fragment size
    ip_packet.ip_more_fragments = frag_index ~= #fragments
    ip_packet.ip_proto = proto
    ip_packet.payload = fragment

    -- randomize TTL to avoid pattern detection
    ip_packet.ip_ttl = math.random(64, 128)  -- mimic typical TTL ranges

    local raw_ip_packet = ip_packet:build()
    socket:ip_send(raw_ip_packet)

    stdnse.print_debug(1, "Sent fragment %d of %d to %s:%d with random data length %d", frag_index, #fragments, host.ip, port.number, max_random_data_length)

    -- random delay between fragments to mimic natural traffic (range 0.5 to 2 seconds)
    random_delay(0.5, 2.0) 
  end

  socket:close()
end

-- option to specify maximum random data length via command line argument (random_data_length)
action = function(host, port)
  -- read maximum random data length from script arguments, default to 1024 if not provided
  local max_random_data_length = tonumber(nmap.registry.args.random_data_length) or 1024

  stdnse.print_debug(1, "Starting firewall-frag against %s:%d with data length %d", host.ip, port.number, max_random_data_length)
  
  send_fragmented_packets(host, port, max_random_data_length)
  
  return string.format("Job completed. Maximum random data length: %d. Check if the target responded.", max_random_data_length)
end
