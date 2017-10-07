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
config_file="/etc/trd.conf"
lock_file="/tmp/trd_cron.running"
me=$(basename $0)
special_file="/scratch/acsss/trd_keepgoing"

/usr/bin/hpsssvc -i -s acsls
if [[ $? != 0 ]]
then
    /usr/bin/logger -t $me -p user.warning "This script only runs on the ACSLS server."
    exit 1
fi

if [[ ! -f "${config_file}" ]]; then
    /usr/bin/logger -t $me -p user.warning "Please ensure that the configuration file exists."
    exit 1
fi

. ${config_file}


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

    if [[ ${#LSM0_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM0_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM1_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM1_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM2_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM2_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM3_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM3_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM4_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM4_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM5_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM5_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM6_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM6_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM7_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM7_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM8_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM8_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM9_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM9_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM10_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM10_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM11_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM11_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM12_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM12_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM13_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM13_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM14_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM14_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LSM15_TAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LSM15_TAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LIB1_RTAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LIB1_RTAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LIB2_RTAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LIB2_RTAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LIB3_RTAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LIB3_RTAPE array is confiured correctly in ${config_file}."
        exit 1
    fi
    if [[ ${#LIB4_RTAPE[@]} -ne 2 ]]; then
        /usr/bin/logger -t $me -p user.warning "Please ensure that LIB4_RTAPE array is confiured correctly in ${config_file}."
        exit 1
    fi

    #
    ##  Move the specified cartridges around within the specified LSMs.
    ##  For example, the first line will cause two tape cartridges
    ##  to move around, at random, within LSM 0.
    # LIB 1
    ${exec_dir}/trd_move ${LSM0_TAPE[0]}  ${LSM0_TAPE[1]}  0  0  &
    ${exec_dir}/trd_move ${LSM1_TAPE[0]}  ${LSM1_TAPE[1]}  1  1  &
    ${exec_dir}/trd_move ${LSM2_TAPE[0]}  ${LSM2_TAPE[1]}  2  2  &
    ${exec_dir}/trd_move ${LSM3_TAPE[0]}  ${LSM3_TAPE[1]}  3  3  &
    # LIB 2
    ${exec_dir}/trd_move ${LSM4_TAPE[0]}  ${LSM4_TAPE[1]}  4  4  &
    ${exec_dir}/trd_move ${LSM5_TAPE[0]}  ${LSM5_TAPE[1]}  5  5  &
    ${exec_dir}/trd_move ${LSM6_TAPE[0]}  ${LSM6_TAPE[1]}  6  6  &
    ${exec_dir}/trd_move ${LSM7_TAPE[0]}  ${LSM7_TAPE[1]}  7  7  &
    # LIB 3
    ${exec_dir}/trd_move ${LSM8_TAPE[0]}  ${LSM8_TAPE[1]}  8  8  &
    ${exec_dir}/trd_move ${LSM9_TAPE[0]}  ${LSM9_TAPE[1]}  9  9  &
    ${exec_dir}/trd_move ${LSM10_TAPE[0]} ${LSM10_TAPE[1]} 10 10 &
    ${exec_dir}/trd_move ${LSM11_TAPE[0]} ${LSM11_TAPE[1]} 11 11 &
    # LIB 4
    ${exec_dir}/trd_move ${LSM12_TAPE[0]} ${LSM12_TAPE[1]} 12 12 &
    ${exec_dir}/trd_move ${LSM13_TAPE[0]} ${LSM13_TAPE[1]} 13 13 &
    ${exec_dir}/trd_move ${LSM14_TAPE[0]} ${LSM14_TAPE[1]} 14 14 &
    ${exec_dir}/trd_move ${LSM15_TAPE[0]} ${LSM15_TAPE[1]} 15 15 &

    #
    ##  Move the specified cartridges around within a library.
    ##  For example, the first line will cause Z2X184 & Z2X185
    ##  to move around, at random, within LIB 1.
    # Elevator Move LIB 1
    ${exec_dir}/trd_move ${LIB1_RTAPE[0]} ${LIB1_RTAPE[1]}  0  3  &
    # Elevator Move LIB 2
    ${exec_dir}/trd_move ${LIB2_RTAPE[0]} ${LIB2_RTAPE[1]}  4  7  &
    # Elevator Move LIB 3
    ${exec_dir}/trd_move ${LIB3_RTAPE[0]} ${LIB3_RTAPE[1]}  8  11 &
    # Elevator Move LIB 4
    ${exec_dir}/trd_move ${LIB4_RTAPE[0]} ${LIB4_RTAPE[1]}  12 15 &

    #
    ##  Keep running as long as the 'child process' move scripts are running.
    ##  In this way, we guard against accidentally starting up multiple sets of
    ##  robot dances.
    wait $!

    rm $lock_file

fi


exit 0
