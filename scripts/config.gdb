set architecture aarch64
target remote localhost:2331
set print pretty on 
monitor halt

load
set $pc = 0x40200000
add-symbol-file /home/unab/files/master/tfm/imx8mp/project/bin/kernel.elf 0x40200000

break kernel_entry

layout split


define xpage_range
  set $addr = $arg0
  set $end  = $arg1

  if ($addr > $end)
    printf "Error: addr inicial > addr final\n"
  else
    while ($addr <= $end)
      x/gx $addr
      set $addr = $addr + 0x1000
    end
  end
end