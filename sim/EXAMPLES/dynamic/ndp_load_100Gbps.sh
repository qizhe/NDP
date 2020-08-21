#!/bin/bash

no_of_nodes=144
linkspeed=100
cwnd=48
queuesize=8
pktsize=1500

endtime=400000 #in sec
flowsfinish=2059200000 #stop experiment after these many flows have finished
flowsstart=1000000 #stop experiment after these many flows have started

shortflowsize=1 #in bytes
longflowsize=1 #in bytes

propagationdelay=2600 #650ns per hop

trace=$1
mkdir -p result/ndp/load_100Gbps

for i in 5 6 7 8 9
do
    echo ../../datacenter/htsim_ndp_dynamic -o result/ndp/load_100Gbps/ndp_logfile_${trace}_${i} -i trace/load_100Gbps/trace_${trace}_${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm
    ../../datacenter/htsim_ndp_dynamic -o result/ndp/load_100Gbps/ndp_logfile_${trace}_${i} -i trace/load_100Gbps/trace_${trace}_${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm > result/ndp/load_100Gbps/ndp_debug_${trace}_${i}
    echo "Parsing the logfile: ../../parse_output result/ndp/load_100Gbps/ndp_logfile_${trace}_${i} -ndp -show > result/ndp/load_100Gbps/ndp_rate_${trace}_${i}"
    ../../parse_output result/ndp/load_100Gbps/ndp_logfile_${trace}_${i} -ndp -show > result/ndp/load_100Gbps/ndp_rate_${trace}_${i}
    echo "Extracting FCT and Rates: python process_data.py result/ndp/load_100Gbps/ndp_debug_${trace}_${i} result/ndp/load_100Gbps/ndp_rate_${trace}_${i} trace/load_100Gbps/trace_${trace}_${i}.txt.csv ndp ${linkspeed}"
    python process_data.py result/ndp/load_100Gbps/ndp_debug_${trace}_${i} result/ndp/load_100Gbps/ndp_rate_${trace}_${i} trace/load_100Gbps/trace_${trace}_${i}.txt.csv ndp ${linkspeed}

    rm -rf result/ndp/load_100Gbps/ndp_logfile_${trace}_${i}
done
# ../../parse_output result/ndp/load/ndp_logfile_aditya_5 -ndp -show
