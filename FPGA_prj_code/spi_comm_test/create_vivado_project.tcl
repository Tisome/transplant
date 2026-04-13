set origin_dir [file normalize [file dirname [info script]]]
set proj_dir   [file join $origin_dir vivado_proj]
set proj_name  spi_comm_test
set part_name  xc7s25csga225-1

file mkdir $proj_dir

create_project $proj_name $proj_dir -part $part_name -force

add_files -fileset sources_1 [list \
    [file join $origin_dir rtl comm_spi_slave_test.v] \
    [file join $origin_dir rtl spi_comm_test_gen.v] \
    [file join $origin_dir rtl spi_comm_test_top.v] \
]

add_files -fileset constrs_1 [list \
    [file join $origin_dir xdc spi_comm_test_top_template.xdc] \
]

add_files -fileset sim_1 [list \
    [file join $origin_dir rtl comm_spi_slave_test.v] \
    [file join $origin_dir rtl spi_comm_test_gen.v] \
    [file join $origin_dir rtl spi_comm_test_top.v] \
    [file join $origin_dir tb spi_comm_test_top_tb.v] \
]

set_property top spi_comm_test_top [current_fileset]
set_property top spi_comm_test_top_tb [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "Vivado project created at: $proj_dir"
puts "Next step: fill PACKAGE_PIN values in xdc/spi_comm_test_top_template.xdc"
