#!/bin/sh

# Need to define VCS_VPI so that the appropriate changes for VCS get baked in.
# TODO: pass this in from VCS
cat <<EOF > jtag_vpi_vcs.c
// TODO: pass this in from VCS
#define VCS_VPI
EOF
cat jtag_vpi/jtag_vpi.c >> jtag_vpi_vcs.c

# Rocket makes extensive use of uninitialized registers and memories, so avoid
# unwanted X pollution.
# +vcs+vcdpluson turns on vpd for capturing waveforms.
# +define+RANDOMIZE_REG_INIT +define+RANDOMIZE_MEM_INIT randomizes uninitialized registers and memories
vcs -full64 +vcs+vcdpluson -debug_pp +v2k +vpi +define+VCS_VPI \
  +define+RANDOMIZE_REG_INIT +define+RANDOMIZE_MEM_INIT \
  +lint=all,noVCDE \
  -top vsim_top vsim_top.v \
  jtag_vpi.v jtag_vpi_vcs.c -P jtag_vpi.tab \
  ../integration.v ../rocket-chip/vsim/generated-src/ee194.E300ArtyDevKitConfig.behav_srams.v
