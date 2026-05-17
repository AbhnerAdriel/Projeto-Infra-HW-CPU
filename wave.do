onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Main/cpu/BR/Clk
add wave -noupdate /Main/cpu/BR/Reset
add wave -noupdate -radix decimal /Main/uc/currentState
add wave -noupdate -radix decimal /Main/cpu/HI/Saida
add wave -noupdate -radix decimal /Main/cpu/LO/Saida
add wave -noupdate -radix decimal /Main/uc/nextState
add wave -noupdate -radix decimal /Main/cpu/BR/Reg0
add wave -noupdate -radix decimal /Main/cpu/BR/Reg1
add wave -noupdate -radix decimal /Main/cpu/BR/Reg2
add wave -noupdate -radix decimal /Main/cpu/BR/Reg3
add wave -noupdate -radix decimal /Main/cpu/BR/Reg4
add wave -noupdate -radix decimal /Main/cpu/BR/Reg5
add wave -noupdate -radix decimal /Main/cpu/BR/Reg6
add wave -noupdate -radix decimal /Main/cpu/BR/Reg7
add wave -noupdate -radix decimal /Main/cpu/BR/Reg8
add wave -noupdate -radix decimal /Main/cpu/BR/Reg9
add wave -noupdate -radix decimal /Main/cpu/BR/Reg10
add wave -noupdate -radix decimal /Main/cpu/BR/Reg11
add wave -noupdate -radix decimal /Main/cpu/BR/Reg12
add wave -noupdate -radix decimal /Main/cpu/BR/Reg13
add wave -noupdate -radix decimal /Main/cpu/BR/Reg14
add wave -noupdate -radix decimal /Main/cpu/BR/Reg15
add wave -noupdate -radix decimal /Main/cpu/BR/Reg16
add wave -noupdate -radix decimal /Main/cpu/BR/Reg17
add wave -noupdate -radix decimal /Main/cpu/BR/Reg18
add wave -noupdate -radix decimal /Main/cpu/BR/Reg19
add wave -noupdate -radix decimal /Main/cpu/BR/Reg20
add wave -noupdate -radix decimal /Main/cpu/BR/Reg21
add wave -noupdate -radix decimal /Main/cpu/BR/Reg22
add wave -noupdate -radix decimal /Main/cpu/BR/Reg23
add wave -noupdate -radix decimal /Main/cpu/BR/Reg24
add wave -noupdate -radix decimal /Main/cpu/BR/Reg25
add wave -noupdate -radix decimal /Main/cpu/BR/Reg26
add wave -noupdate -radix decimal /Main/cpu/BR/Reg27
add wave -noupdate -radix decimal /Main/cpu/BR/Reg28
add wave -noupdate -radix decimal /Main/cpu/BR/Reg29
add wave -noupdate -radix decimal /Main/cpu/BR/Reg30
add wave -noupdate -radix decimal /Main/cpu/BR/Reg31
add wave -noupdate -radix decimal /Main/cpu/PC/Saida
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {24150 ps} {25150 ps}
