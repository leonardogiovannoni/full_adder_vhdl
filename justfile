SRC_DIR := "src"
TESTBENCH_DIR := "testbench"
BUILD_DIR := "build"
DUMP_DIR := "dump"

analyze:
    #!/bin/bash
    cd {{SRC_DIR}}
    ghdl -a --std=08 --workdir=../{{BUILD_DIR}} *.vhd
    cd ..
    cd {{TESTBENCH_DIR}}
    ghdl -a --std=08 --workdir=../{{BUILD_DIR}} *.vhd
    cd ..

elaborate:
    #!/bin/bash
    cd {{TESTBENCH_DIR}}
    # iter (bash) over each file in the directory
    dump_dir={{BUILD_DIR}}/{{DUMP_DIR}}
    for tb_src in *.vhd; do
        tb_name=$(basename $tb_src .vhd)
        ghdl -e --std=08 --workdir=../{{BUILD_DIR}} 
    done
    cd ..


build:
    mkdir -p {{BUILD_DIR}}/{{DUMP_DIR}}
    just analyze
    just elaborate


__run: 
    #!/bin/bash
    cd {{TESTBENCH_DIR}}
    dump_dir=../{{BUILD_DIR}}/{{DUMP_DIR}}
    for tb_src in *.vhd; do
        tb_name=$(basename $tb_src .vhd)
        vcd_name="$(basename $tb_src .vhd)."vcd
        vcd_file="$dump_dir/$vcd_name"
        ghdl -r --std=08 --workdir=../{{BUILD_DIR}} $tb_name --vcd=$vcd_file
    done
    cd ..


__start_gtkwave:
    #!/bin/bash
    gtkwave {{BUILD_DIR}}/{{DUMP_DIR}}/*.vcd

run:
    just build
    just __run
    just __start_gtkwave


clean:
    #!/bin/bash
    rm -rf {{BUILD_DIR}}
    mkdir -p {{BUILD_DIR}}/{{DUMP_DIR}}
