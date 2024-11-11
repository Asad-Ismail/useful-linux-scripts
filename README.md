# useful-linux-scripts
Collection of useful linux scripts for smooth day to day operations


### Finding Large files and directories
```
# Show both largest files and directories (default)
./findlarge.sh

# Show only largest directories
./findlarge.sh -t dirs

# Show only largest files
./findlarge.sh -t files

# Customize number of results and search directory
./findlarge.sh -n 10 -d /home -t both

# Search for large directories with minimum size
./findlarge.sh -t dirs -s 1G
```
