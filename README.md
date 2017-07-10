# Robot Dance

## Motivation

Tours of high performance computer (HPC) data centers are an increasingly common activity. Most data centers aren't very dynamic: they're rows upon rows of similar racks of computing nodes and disk drawers. The most interesting visual component of these racks are either some blinking lights or large branding/logo skins applied to the outside rack row. Each cluster offers the same viewing experience. Essentially: you've seen one cluster, you've seen 'em all.

Robotic tape libraries can stand out from the crowd in an HPC data center. Unfortunately, well-tuned robotic tape libraries aren't much more active than their compute cluster counterparts. A smoothly running tape library achieves efficiency by moving its robots as little as possible.

So, for tour groups, it's desirable to put the robotic tape libraries into a tour mode. This software package is that tour mode; it makes the robots "dance" and move about. It strives to create visually interesting patterns of movement for the tour groups to observe.

## Pre-Reqs

* Oracle StorageTek SL8500 tape libraries
* Oracle StorageTek ACSLS library control software
* [Expect](http://expect.nist.gov/)

## Quick Start

There are three modules that make up this package:

* `trd_dance.bash`: The user interface. It's meant to able to run on any node, as long as it shares a filesystem (NFS, etc.) with the ACSLS server.
* `trd_cron.bash`: Run this in cron — frequently, say every five minutes — on the ACSLS server as user *acsss*. This module starts the robot dance, by spawning off individual `trd_move.exp` instances, and awaits the robot dance termination request. This module requires access to a filesystem (NFS, etc.) shared with the node used to run `trd_dance.bash`.
* `trd_move.exp`: An Expect script that is responsible for moving a pair of cartridges around an SL8500 complex to generate robotic movement. Many of instances of this script are run in parallel by `trd_cron.bash` to create the overall robot dance. This module needs access to the same filesystem used by the two bash script modules.

To run the robot dance:

    % /path/to/trd_dance.bash --start

To stop the robot dance:

    % /path/to/trd_dance.bash --stop

## Internals

`trd_dance.bash` will place a sentinel file in the filesystem shared by its host and the ACSLS server. It will log to syslog and HPSS that the robot dance is starting. `trd_cron.bash` will look for the sentinel file and start up many instances of `trd_move.exp`. `trd_move.exp` uses the ACSLS command line processor (`cmd_proc`) to issue the robotic movement commands. When stopping the robot dance, `trd_dance.bash` removes the sentinel file and logs to HPSS and syslog that the robot dance is winding down. `trd_cron.bash` and `trd_move.exp` exit when the sentinel file disappears from the shared filesystem.

## Known Issues & Limitations *(a.k.a. opportunities for pull requests and community contributions!)*

* Various external dependencies — command line tools, file system paths, etc. — are hardcoded into this package's various modules
* This package relies on a non-OSS LLNL software tool named `hpsssvc` that describes which servers provide which services
* The tape volumes used by this package are hardcoded into the `trd_cron.bash` module
* The number of tape libraries in use is hardcoded into the `trd_cron.bash` module
* This package relies on use of [genders](https://github.com/chaos/genders) and a genders schema specific to LLNL
* In addition to logging to syslog, this package attempts to log to [HPSS](http://www.hpss-collaboration.org). Usage of HPSS tools for this logging is hardcoded into `trd_dance.bash`.
