## Overview
Automates the process for signing PS scripts, has some basic check in place to prevent derps.

## Required Parameters
 - **path** - The path to the ps1 file you want to sign
 
## Notes
 - It will automatically discover and use the first code signing cert you have.
 - Currently requires an internet connection so it can reach the timestamping server, currently no way (with params) to opt out of using remote timestaming server. Can just modify the cmdlet though, it's resonably obvious whichi one it is.