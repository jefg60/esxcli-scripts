#!/bin/bash

syntax="$0 vlan_to_configure ip_to_configure netmask <gw_to_configure>
e.g. $0 101 192.168.34.1 255.255.255.0 192.168.34.1"

if [ -z $3 ]
then
  echo "Syntax: $syntax"
  exit 1
fi

#get params
desired_vlan=$1
desired_ip="$2"
desired_netmask=$3
if [ ! -z $4 ]
then
  desired_gw=$4
else
  desired_gw="none"
fi

esxcfg-vswitch vswitch0 -v "$desired_vlan" -p "Management Network"
esxcli network ip interface ipv4 set -i vmk0 -I "$desired_ip" -N "$desired_netmask" -t static

if [ "$desired_gw" != "none" ]
then
  esxcfg-route $desired_gw
fi
