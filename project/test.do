vlib work

vlog finalproject.v
vlog ../lab7/bouncer/vga_adapter/*.v
vlog background.v
vlog PS2_Controller/*.v
vlog star.v
vlog draw.v


#vlog vga_adapter/*.v




vsim -L altera_mf_ver part2




#vsim part2




log -r {/*}




add wave {/*}




force {clk} 0 0, 1 1ns -r 2ns













force {color} 10#7



force {start} 0

force {reset} 0
run 10 ns
force {start} 1

run 10 ns
force {start} 0




run 200000000ns