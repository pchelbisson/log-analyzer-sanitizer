#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
    echo "usage: $0 <log_file> <output_dir> <--sanitize (optional)>"
    exit 1
fi

LOG_FILE=$1
OUTPUT_DIR=$(realpath "$2")
SANITIZE_MODE=false


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

# Check --sanitize option
if [ -n "$3" ]; then           # If 3 arg excist
    if [ "$3" == "--sanitize" ]; then
        SANITIZE_MODE=true
        echo "Sanitizing enabled"

    else
        echo "Ошибка: Неизвестная опция '$3'. Возможно, вы имели в виду --sanitize?"
        exit 1
    fi
fi

RESULT_FILE="$OUTPUT_DIR/$newname"

# --- Text processing with sed ---

# 1. Replace all tabs with spaces
# 2. Remove spaces at the beginning and end of each line.
# 3. We collapse several spaces in a row into one
# 4. Removing empty lines
# 5. We remove comments (lines with #), but we SKIP the first line if it contains #!
sed -E '
    # Replace tabs with spaces
    s/\t/ /g;
    # Remove spaces at the beginning and end
    s/^[[:space:]]+//;
    s/[[:space:]]+$//;
    # Replace multiple spaces with single spaces
    s/[[:space:]]+/ /g;
    # Remove empty lines (after clearing spaces)
    /^$/d;
    # Remove comments except the first line with #!
    1!{ /^#/d; }
' "$LOG_FILE" > "$RESULT_FILE"
if [ "$SANITIZE_MODE" = true ]; then
    # Sanitize IPv4
    sed -Ei 's/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/xxx.xxx.xxx.xxx/g' "$RESULT_FILE"
    # Sanitize EMAIL
    sed -Ei '2,$s/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/xxxxx@xxxxx.xx/g' "$RESULT_FILE"
fi

echo "Checks passed. File created: $RESULT_FILE"

