# Some of the ansible pieces used on daily basis

/etc/hosts generated from inventory

ansible-inventory --list | jq -r '._meta.hostvars | select(. != null) | to_entries[] | "\(.value["ansible_host"]) \(.key)"'
