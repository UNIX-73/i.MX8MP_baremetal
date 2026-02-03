set architecture aarch64
target remote localhost:2331
monitor halt

load
set $pc = 0x40200000
add-symbol-file /home/unab/files/master/tfm/imx8mp/project/bin/kernel.elf 0x40200000



hbreak *(_reloc_cfg_end + 0xffff800000000000)
commands
  silent
  add-symbol-file /home/unab/files/master/tfm/imx8mp/project/bin/kernel.elf 0xffff800040200000
end

hbreak kernel_entry

layout split