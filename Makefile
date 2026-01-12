# ==========================================
# SV Smart Wave - Makefile (Optimized Version)
# ==========================================

BUILD_DIR = build
LOG_DIR   = logs
VCS       = vcs
VERDI     = verdi

# Default arguments (Level 1 depth for safety to prevent massive files)
DEPTH ?= 1
VIEW  ?= default
START ?= 0
END   ?= 0

# VCS Flags
# -debug_access+all is required for enabling FSDB system functions
VCS_ARGS  = -full64 -sverilog -kdb -debug_access+all
VCS_ARGS += -timescale=1ns/1ps
VCS_ARGS += -f filelist.f
VCS_ARGS += -l $(LOG_DIR)/compile.log
VCS_ARGS += -Mdir=$(BUILD_DIR)/csrc
VCS_ARGS += -o $(BUILD_DIR)/simv

# Simulation Flags
# Map Makefile variables to SV plusargs
SIM_ARGS  = +fsdb_on
SIM_ARGS += +dump_depth=$(DEPTH)
# SIM_ARGS += +dump_view=$(VIEW)
SIM_ARGS += +dump_start=$(START)
SIM_ARGS += +dump_end=$(END)
SIM_ARGS += -l $(LOG_DIR)/sim.log

.PHONY: all clean compile sim verdi

all: clean compile sim

setup:
	mkdir -p $(BUILD_DIR) $(LOG_DIR)

compile: setup
	$(VCS) $(VCS_ARGS)

# Default simulation run
sim:
	$(BUILD_DIR)/simv $(SIM_ARGS)


# Scenario 1: Full dumping (Use with caution)
sim_all:
	$(BUILD_DIR)/simv $(SIM_ARGS) +dump_view=all +dump_depth=0

# Scenario 2: Using external signal list file
sim_list:
	$(BUILD_DIR)/simv $(SIM_ARGS) +dump_view=list +dump_list=cfg/wave_list.f

verdi:
	$(VERDI) -ssf sim_wave.fsdb -dbdir $(BUILD_DIR)/simv.daidir &

clean:
	rm -rf $(BUILD_DIR) $(LOG_DIR) *.fsdb *.log csrc simv.daidir ucli.key vc_hdrs.h
