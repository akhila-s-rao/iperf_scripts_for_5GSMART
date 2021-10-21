#!/bin/bash
# This script is run at the server

num_steps=11             # This includes the zero step 
time_step=50             # seconds 
start_port_num=11000
report_interval=0.01       # seconds
server_ip='127.0.0.1'   # IP address of the interface to bind to. This is the IP addr of the interface I want to recv on




# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        sudo pkill iperf
        echo "kill iperf"
	exit 0
}





total_time=$(($time_step*$num_steps))
echo 'Iperf server will run for' $total_time 'seconds'

for ((i=1;i<num_steps;i++))
do
	port_num=$(($start_port_num+$i))
	echo 'Starting server on port_num ' $port_num
	iperf -s -u -i $report_interval -p $port_num -B $server_ip -e -y C > iperf_server_ul_stream$i.log &
	#iperf -s -u -i $report_interval -p $port_num -B $server_ip > iperf_server_ul_stream$i.log &
	sleep 0.1 # A short sleepy time before starting the next server 
done
sleep $(($total_time+5))
sudo pkill iperf
echo 'DONE'
