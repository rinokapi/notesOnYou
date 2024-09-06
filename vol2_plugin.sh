#!/bin/bash

# Check if both variables are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 MEMDUMP_FILE PROFILE_NAME HOSTNAME"
    exit 1
fi

memdump_file="$1"
profile_name="$2"
hostname="$3"

mkdir volatility_$hostname

# Command function
function run_command {
    echo "running plugin: $1"

    # with output file
    time python2 ~/tools/volatility/vol.py -f "$memdump_file" --profile="$profile_name" $1 --output-file=volatility_$hostname/$1_$hostname.txt

    echo "------------------------------------------------------------"
    echo ""
}

# List of commands
commands=(
    callbacks                  # Print system#wide notification routines
    clipboard                  # Extract the contents of the windows clipboard
    cmdcheck
    cmdline                    # Display process command#line arguments
    consoles                   # Extract command history by scanning for _CONSOLE_INFORMATION
    deskscan                   # Poolscaner for tagDESKTOP (desktops)
    dlllist                    # Print list of loaded dlls for each process
    drivermodule               # Associate driver objects to kernel modules
    driverscan                 # Pool scanner for driver objects
    envars                     # Display process environment variables
    filescan                   # Pool scanner for file objects
    getsids                    # Print the SIDs owning each process
    handles                    # Print list of open handles for each process
    hashdump                   # Dumps passwords hashes (LM/NTLM) from memory
    hollowfind
    # iehistory                  # Reconstruct Internet Explorer cache / history
    joblinks                   # Print process job link information
    ldrmodules                 # Detect unlinked DLLs
    lsadump                    # Dump (decrypted) LSA secrets from the registry
    malfind                    # Find hidden and injected code
    malprocfind
    mftparser                  # Scans for and parses potential MFT entries
    modscan                    # Pool scanner for kernel modules
    modules                    # Print list of loaded modules
    mutantscan                 # Pool scanner for mutex objects
    netscan                    # Scan a Vista (or later) image for connections and sockets
    # networkpackets
    pathcheck
    psinfo
    pslist                     # Print all running processes by following the EPROCESS lists
    psscan                     # Pool scanner for process objects
    pstree                     # Print process list as a tree
    psxview                    # Find hidden processes with various process listings
    # screenshot                 # Save a pseudo#screenshot based on GDI windows
    shutdowntime               # Print ShutdownTime of machine from registry
    ssdt                       # Display SSDT entries
    svcscan                    # Scan for Windows services
    symlinkscan                # Pool scanner for symlink objects
    thrdscan                   # Pool scanner for thread objects
    threads                    # Investigate _ETHREAD and _KTHREADs
    timers                     # Print kernel timers and associated module DPCs
    triagecheck
    verinfo                    # Prints out the version information from PE images
    wintree                    # Print Z#Order Desktop Windows Tree
)

# Loop through and run each command
for cmd in "${commands[@]}"; do
    run_command "$cmd"
done
