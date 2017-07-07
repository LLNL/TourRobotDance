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
special_file="/scratch/acsss/trd_keepgoing"

core=$(${exec_dir}/nodeattr -v hpss_core)
zone=$(${exec_dir}/nodeattr -v archive_zone)


#
##  Preflight checks
if [[ $core != "prodprim" ]]
then
    printf "\n\tThis only runs on the production core server.\n\n"
    exit 1
fi
if [[ $EUID != 0 ]]
then
    printf "\n\tYou must be root.\n\n"
    exit 1
fi


if [[ $1 == "--start" ]] || [[ $1 == "-s" ]]        #  Start the robot dance
then
    if [[ -e $special_file ]]
    then
        printf "\n\tThe robot dance is already running.\n\n"
        exit 1
    else
        touch $special_file
        ${exec_dir}/run_hpssmsg alarm warning "The B453 Tour Robot Dance (TRD) has begun.  Remember to stop it with the 'trd_dance --stop' command."
        ${exec_dir}/logger -s -t $(basename $0) -p user.info "The B453 Tour Robot Dance has begun.  Remember to eventually stop it with the 'trd_dance --stop' command."
    fi
elif [[ $1 == "--stop" ]] || [[ $1 == "-t" ]]    #  Stop the robot dance
then
    if [[ -e $special_file ]]
    then
        rm $special_file
        ${exec_dir}/run_hpssmsg alarm warning "The B453 Tour Robot Dance (TRD) will start winding down now.  It will be a few minutes before it has completely stopped."
        ${exec_dir}/logger -s -t $(basename $0) -p user.info "The B453 Tour Robot Dance (TRD) will start winding down now.  It will be a few minutes before it has completely stopped."
    else
        printf "\n\tThe robot dance isn't running.\n\n"
        exit 1
    fi
else
    printf "\n\tUsage:  $(basename $0) [--start|--stop]\n\n"
    exit 1
fi

exit 0
