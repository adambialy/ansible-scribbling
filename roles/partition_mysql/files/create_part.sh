#!/bin/bash

/bin/echo -e "n\np\n1\n\n\nt\n8e\nw" | sudo fdisk "{{ disk_name }}"

