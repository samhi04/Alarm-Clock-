vlib work 
vdel -all 
vlib work 

vlog -f hmsv2.list +acc
vsim work.tb 
add wave -r *
#do wave.do 
run -all 