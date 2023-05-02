Role Name
=========

Corosync + pacemaker installation in two node HA config.

Designed to keep VIP's on prefered nodes, and vips are tied down to service (still to come)


General description from GPT how to setup service
=================================================

Create a BIND9 resource agent: Pacemaker doesn't come with a built-in BIND9 resource agent, so you need to create a custom resource agent to monitor the availability of BIND9. You can use the following script as a starting point:

bash

#!/bin/bash

# Check if named is running
if ps aux | grep -v grep | grep named > /dev/null
then
    exit 0
else
    exit 1
fi

Save this script as /usr/local/bin/bind.sh and make it executable:

bash

sudo chmod +x /usr/local/bin/bind.sh

Create a BIND9 resource: Now you can create a resource for BIND9 using the resource agent you just created.

sql

sudo pcs resource create bind ocf:heartbeat:script \
    op monitor interval=10s \
    op start timeout=60s \
    op stop timeout=60s \
    user="bind" \
    group="bind" \
    script="/usr/local/bin/bind.sh"

This command creates a resource named bind using the ocf:heartbeat:script resource agent. The op monitor command specifies that the resource should be monitored every 10 seconds, and the op start and op stop commands specify the timeouts for starting and stopping the resource. The user and group options specify the user and group that should be used to run the resource agent, and the script option specifies the path to the BIND9 resource agent script.

Create a virtual IP resource: Now you can create a virtual IP resource that will be moved between nodes as needed.

sql

sudo pcs resource create bind-vip ocf:heartbeat:IPaddr2 \
    ip=192.168.1.100 \
    cidr_netmask=24 \
    op monitor interval=10s

This command creates a virtual IP resource named bind-vip using the ocf:heartbeat:IPaddr2 resource agent. The ip and cidr_netmask options specify the IP address and subnet mask for the virtual IP address, and the op monitor command specifies that the resource should be monitored every 10 seconds.

Create a resource group: Now you can create a resource group that includes the BIND9 resource and the virtual IP resource.

csharp

sudo pcs resource group add bind-group bind bind-vip

Configure colocation constraints: Now you can create a colocation constraint that specifies that the BIND9 resource and the virtual IP resource must be on the same node.

sql

sudo pcs constraint colocation add bind-group with bind-vip

Configure order constraints: Now you can create an order constraint that specifies that the BIND9 resource must start before the virtual IP resource.

sql

sudo pcs constraint order start bind then start bind-vip

Configure monitoring and migration: Finally, you should configure the BIND9 resource to monitor the availability of BIND9 and to automatically move the virtual IP address to another node if BIND9 becomes unavailable. You can use the following commands:
