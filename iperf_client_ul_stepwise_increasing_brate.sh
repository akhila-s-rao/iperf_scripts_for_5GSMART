#!/bin/bash
# This script is run at the client

num_steps=11                 # This includes the 0 step as well when UE2 sends 0 bps
brate_increase_per_step=1   # Mbps
time_step=3                 # seconds
start_port_num=11000
pkt_len=1450                 # Bytes
report_interval=1         # seconds # This is the interval with which iperf prints a new measurement report line.
server_ip='127.0.0.1'        # IP address of the server we are sending packets to 
client_ip='127.0.0.1'           # IP address of the interface to bind to. This is the IP addr of the interface I want to send from


# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        sudo pkill iperf
	echo "kill iperf"
	exit 0
}


non_zero_steps=$(($num_steps-1))
max_brate=$(($non_zero_steps*$brate_increase_per_step))
echo 'Bitrate will vary from 0 to' $max_brate 'Mbps' 

total_time=$(($time_step*$num_steps))
echo 'Iperf client will run for' $total_time 'seconds'

for ((i=1;i<num_steps;i++))
do
	sleep $time_step
	time_to_run=$(($total_time-$i*$time_step))
	port_num=$(($start_port_num+$i))
	echo 'Starting client stream '$i' at port_num' $port_num 'This will run for '$time_to_run ' seconds'
	iperf -c $client_ip -u -b ${brate_increase_per_step}M -i $report_interval -l $pkt_len -p $port_num -B $server_ip -t $time_to_run -y C -e > iperf_client_ul_stream$i.log &
	#iperf -c $client_ip -u -b ${brate_increase_per_step}M -i $report_interval -l $pkt_len -p $port_num -B $server_ip -t $time_to_run > iperf_client_ul_stream$i.log &
done
sleep $(($time_step+5))
echo 'DONE'
