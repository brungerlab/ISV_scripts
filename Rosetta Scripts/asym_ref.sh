#!/bin/bash
source ~/.bashrc
/home/groups/brunger/kailu/compile/rosetta_bin_linux_2020.08.61146_bundle/main/source/bin/rosetta_scripts.static.linuxgccrelease \
  -database /home/groups/brunger/kailu/compile/rosetta_bin_linux_2020.08.61146_bundle/main/database/ \
  -in::file::s ../P.ATOM.pdb \
  -parser::protocol ../../asym_ref.xml \
  -parser::script_vars denswt=35 rms=1.5 reso=4.5 map=../P.mrc testmap=../P.mrc \
  -edensity::mapreso 4.5 \
  -ignore_unrecognized_res \
  -default_max_cycles 200 \
  -edensity::cryoem_scatterers \
  -beta \
  -out::suffix _asymm \
  -crystal_refine


###asym_ref.xml: put in the same directory with asym_ref.sh