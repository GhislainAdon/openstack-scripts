source install-parameters.sh
source admin_openrc.sh

if [ $# -lt 1 ]
	then
		echo "Correct syntax: $0 <external-interface>"
		exit 1;
fi


crudini --set /etc/neutron/l3_agent.ini DEFAULT external_network_bridge br-ex
ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex $1
ovs-vsctl show
