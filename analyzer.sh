#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
    echo "usage: $0 <log_file> <output_dir>"
    exit 1
fi

LOG_FILE=$1
OUTPUT_DIR=$2

# ---  Checking the input file ---

# Check if an argument is passed
if [[ -z "$LOG_FILE" ]]; then
    echo "Error: File path not specified."
    exit 1
fi

# Check if a file exists and is a regular file
if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: File '$LOG_FILE' not found."
    exit 1
else 
    filename=$(basename "$LOG_FILE" .log)
    newname="clean_${filename}.log"
fi

# Check if you have permission to read the file
if [[ ! -r "$LOG_FILE" ]]; then
    echo "Error: No permission to read the file '$LOG_FILE'."
    exit 1
fi

# ---  Checking / creating the output directory ---

if [[ -z "$OUTPUT_DIR" ]]; then
    echo "Error: Output directory not specified."
    exit 1
fi

# If the directory does not exist, create it.
if [[ ! -d "$OUTPUT_DIR" ]]; then
    echo "Directory '$OUTPUT_DIR' not found. Creating..."
    mkdir -p "$OUTPUT_DIR"
fi

# Let's check if we can write files to it.
if [[ ! -w "$OUTPUT_DIR" ]]; then
    echo "Error: No permission to write to directory '$OUTPUT_DIR'."
    exit 1
fi

RESULT_FILE="$OUTPUT_DIR/$newname"

grep "Test" "$LOG_FILE" > "$RESULT_FILE"
echo "Checks passed. File created: $RESULT_FILE"

