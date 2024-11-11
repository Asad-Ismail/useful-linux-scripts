#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
DEFAULT_COUNT=20
DEFAULT_MIN_SIZE="100M"
DEFAULT_TYPE="both"

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Find the largest files and directories in your system"
    echo ""
    echo "Options:"
    echo "  -n NUMBER     Show top NUMBER entries (default: $DEFAULT_COUNT)"
    echo "  -s SIZE       Minimum size (default: $DEFAULT_MIN_SIZE)"
    echo "  -d DIRECTORY  Start search from this directory (default: current directory)"
    echo "  -t TYPE       Type of search: files, dirs, or both (default: $DEFAULT_TYPE)"
    echo "  -h           Show this help message"
    echo ""
    echo "Size can be specified with suffixes:"
    echo "  K - Kilobytes (e.g., 100K)"
    echo "  M - Megabytes (e.g., 100M)"
    echo "  G - Gigabytes (e.g., 1G)"
}

# Function to format size
format_size() {
    local size=$1
    if [[ $size -ge 1073741824 ]]; then
        printf "%.1fG" $(echo "$size/1073741824" | bc -l)
    elif [[ $size -ge 1048576 ]]; then
        printf "%.1fM" $(echo "$size/1048576" | bc -l)
    elif [[ $size -ge 1024 ]]; then
        printf "%.1fK" $(echo "$size/1024" | bc -l)
    else
        echo "${size}B"
    fi
}

# Parse command line arguments
COUNT=$DEFAULT_COUNT
MIN_SIZE=$DEFAULT_MIN_SIZE
START_DIR="$PWD"
SEARCH_TYPE=$DEFAULT_TYPE

while getopts "n:s:d:t:h" opt; do
    case $opt in
        n) COUNT="$OPTARG";;
        s) MIN_SIZE="$OPTARG";;
        d) START_DIR="$OPTARG";;
        t) SEARCH_TYPE="$OPTARG";;
        h) show_help; exit 0;;
        ?) show_help; exit 1;;
    esac
done

# Check if directory exists
if [ ! -d "$START_DIR" ]; then
    echo -e "${RED}Error: Directory $START_DIR does not exist${NC}"
    exit 1
fi

# Function to find largest files
find_largest_files() {
    echo -e "\n${YELLOW}=== Largest Files ===${NC}"
    find "$START_DIR" -type f -size "+$MIN_SIZE" -exec du -h {} + 2>/dev/null | \
        sort -rh | \
        head -n "$COUNT" | \
        awk '{printf "%-10s %s\n", $1, $2}'
}

# Function to find largest directories
find_largest_dirs() {
    echo -e "\n${YELLOW}=== Largest Directories ===${NC}"
    du -h "$START_DIR"/* 2>/dev/null | \
        sort -rh | \
        head -n "$COUNT" | \
        awk '{printf "%-10s %s\n", $1, $2}'
}

# Main execution
echo -e "${GREEN}Searching in ${BLUE}$START_DIR${NC}"
echo -e "${GREEN}This may take a while depending on the directory size...${NC}"

case $SEARCH_TYPE in
    "files")
        find_largest_files
        ;;
    "dirs")
        find_largest_dirs
        ;;
    "both")
        find_largest_files
        find_largest_dirs
        ;;
    *)
        echo -e "${RED}Error: Invalid type. Use 'files', 'dirs', or 'both'${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}Search complete!${NC}"

# Add summary
echo -e "\n${YELLOW}=== Summary ===${NC}"
echo -e "Search location: ${BLUE}$START_DIR${NC}"
echo -e "Minimum size: ${BLUE}$MIN_SIZE${NC}"
echo -e "Search type: ${BLUE}$SEARCH_TYPE${NC}"
total_size=$(du -sh "$START_DIR" 2>/dev/null | cut -f1)
echo -e "Total directory size: ${BLUE}$total_size${NC}"
