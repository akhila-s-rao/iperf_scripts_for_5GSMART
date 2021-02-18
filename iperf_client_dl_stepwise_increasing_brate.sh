# This script is run at the client
num_steps=3
brate_per_step=10      # Mbps
time_step=60           # seconds
start_port_num=11000
pkt_len=1450           # Bytes
report_interval=0.01   # seconds

max_brate=$(($num_steps*$brate_per_step))
echo 'Bitrate will vary from ' $brate_per_step ' to ' $max_brate ' Mbps'

total_time=$(($time_step*$num_steps))
echo 'Iperf client will run for ' $total_time ' seconds'

for i in {0..2} #CHANGE THIS TO num_steps-1
do
	time_to_run=$(($total_time-$i*$time_step))
	echo 'time to run is ' $time_to_run
	port_num=$(($start_port_num+$i))
	echo 'Starting client at port_num ' $port_num
	iperf3 -c 193.10.65.35 -R -u -b ${brate_per_step}M -i $report_interval -l $pkt_len -p $port_num -B 193.10.65.7 -t $time_to_run -y C -e > iperf_client_dl_stream$i.log &
	sleep $time_step
done
echo 'DONE'
