#!/bin/bash

no_of_nodes=144
linkspeed=100
cwnd=48
queuesize=333
pktsize=1500

endtime=400000 #in sec
flowsfinish=2059200000 #stop experiment after these many flows have finished
flowsstart=1000000 #stop experiment after these many flows have started

shortflowsize=1 #in bytes
longflowsize=1 #in bytes

propagationdelay=2600 #650ns per hop
remote_load=0.15
local_load=0.4
os_ratio=2
trace=$1
mkdir -p result/ndp/local_traffic

for remote_load in 0.4 0.6 0.8
do
    echo ../../datacenter/htsim_ndp_dynamic -o result/ndp/local_traffic/ndp_logfile_${trace}_${os_ratio}_${local_load}_${remote_load} -os ${os_ratio} -i trace/local_traffic/trace_${trace}_${os_ratio}_${local_load}_${remote_load}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm
    ../../datacenter/htsim_ndp_dynamic -o result/ndp/local_traffic/ndp_logfile_${trace}_${os_ratio}_${local_load}_${remote_load}  -os ${os_ratio} -i trace/local_traffic/trace_${trace}_${os_ratio}_${local_load}_${remote_load}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm > result/ndp/local_traffic/ndp_debug_${trace}_${os_ratio}_${local_load}_${remote_load}
    echo "Parsing the logfile: ../../parse_output result/ndp/local_traffic/ndp_logfile_${trace}_${os_ratio}_${local_load}_${remote_load} -ndp -show > result/ndp/local_traffic/ndp_rate_${trace}_${os_ratio}_${local_load}_${remote_load}"
    ../../parse_output result/ndp/local_traffic/ndp_logfile_${trace}_${os_ratio}_${local_load}_${remote_load} -ndp -show > result/ndp/local_traffic/ndp_rate_${trace}_${os_ratio}_${local_load}_${remote_load}
    echo "Extracting FCT and Rates: python process_data.py result/ndp/local_traffic/ndp_debug_${trace}_${os_ratio}_${local_load}_${remote_load} result/ndp/local_traffic/ndp_rate_${trace}_${os_ratio}_${local_load}_${remote_load} trace/local_traffic/trace_${trace}_${os_ratio}_${local_load}_${remote_load}.txt.csv ndp ${linkspeed}"
    python process_data.py result/ndp/local_traffic/ndp_debug_${trace}_${os_ratio}_${local_load}_${remote_load} result/ndp/local_traffic/ndp_rate_${trace}_${os_ratio}_${local_load}_${remote_load} trace/local_traffic/trace_${trace}_${os_ratio}_${local_load}_${remote_load}.txt.csv ndp ${linkspeed}

    rm -rf result/ndp/load_100Gbps/ndp_logfile_${trace}_${os_ratio}_${local_load}_${remote_load}
done
# ../../parse_output result/ndp/load/ndp_logfile_aditya_5 -ndp -show
