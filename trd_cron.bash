#!/usr/bin/env bash

# Copyright (c) 2017, Lawrence Livermore National Security, LLC.
# Produced at the Lawrence Livermore National Laboratory
# Written by Geoff Cleary <gcleary@llnl.gov>.
# LLNL-CODE-734257
#
# All rights reserved.
# This file is part of Tour Robot Dance. For details, see
# https://github.com/LLNL/TourRobotDance. Licensed under the
# Apache License, Version 2.0 (the “Licensee”); you may not use
# this file except in compliance with the License. You may
# obtain a copy of the License at:
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied. See the License for the specific
# language governing permissions and limitations under the license.


exec_dir="/usr/bin"
lock_file="/tmp/trd_cron.running"
me=$(basename $0)
special_file="/scratch/acsss/trd_keepgoing"

/usr/bin/hpsssvc -i -s acsls
if [[ $? != 0 ]]
then
    /usr/bin/logger -t $me -p user.warning "This script only runs on the ACSLS server."
    exit 1
fi


if [[ -e $special_file ]]
then
    #
    ##  Check for the lock file that tells us whether there's already an
    ##  instance of this cron job running.  Is so:  exit.  If not:  create the
    ##  lock file and continue onward.
    if [[ -e $lock_file ]]
    then
        exit 0
    else
        echo "$0 on $(hostname) at $(date)" > $lock_file
    fi

    #
    ##  Move the specified cartridges around within the specified LSMs.
    ##  For example, the first line will cause two tape cartridges
    ##  to move around, at random, within LSM 0.
    # LIB 1
    ${exec_dir}/trd_move Z2X080  Z2X081  0  0  &
    ${exec_dir}/trd_move Z2X082  Z2X083  1  1  &
    ${exec_dir}/trd_move Z2X084  Z2X085  2  2  &
    ${exec_dir}/trd_move Z2X086  Z2X087  3  3  &
    # LIB 2
    ${exec_dir}/trd_move Z2X088  Z2X089  4  4  &
    ${exec_dir}/trd_move Z2X090  Z2X091  5  5  &
    ${exec_dir}/trd_move Z2X092  Z2X093  6  6  &
    ${exec_dir}/trd_move Z2X094  Z2X095  7  7  &
    # LIB 3
    ${exec_dir}/trd_move Z2X096  Z2X097  8  8  &
    ${exec_dir}/trd_move Z2X098  Z2X099  9  9  &
    ${exec_dir}/trd_move Z2X100  Z2X101  10 10 &
    ${exec_dir}/trd_move Z2X102  Z2X103  11 11 &
    # LIB 4
    ${exec_dir}/trd_move Z2X104  Z2X105  12 12 &
    ${exec_dir}/trd_move Z2X106  Z2X107  13 13 &
    ${exec_dir}/trd_move Z2X108  Z2X109  14 14 &
    ${exec_dir}/trd_move Z2X110  Z2X111  15 15 &

    #
    ##  Move the specified cartridges around within a library.
    ##  For example, the first line will cause Z2X184 & Z2X185
    ##  to move around, at random, within LIB 1.
    # Elevator Move LIB 1
    ${exec_dir}/trd_move Z2X112  Z2X113  0  3  &
    # Elevator Move LIB 2
    ${exec_dir}/trd_move Z2X114  Z2X115  4  7  &
    # Elevator Move LIB 3
    ${exec_dir}/trd_move Z2X116  Z2X117  8  11 &
    # Elevator Move LIB 4
    ${exec_dir}/trd_move Z2X118  Z2X119  12 15 &

    #
    ##  Keep running as long as the 'child process' move scripts are running.
    ##  In this way, we guard against accidentally starting up multiple sets of
    ##  robot dances.
    wait $!

    rm $lock_file

fi


exit 0
