num_steps=3
start_port_num=11000
report_interval=0.01   # seconds

for i in {0..2} # CHANGE THIS TO num_steps-1
do
	echo $i
	port_num=$(($start_port_num+$i))
	echo 'Starting server at port_num ' $port_num
	iperf3 -s -i $report_interval -p $port_num -e -y C > iperf_server_dl_stream$i.log &
	sleep 0.1
done
