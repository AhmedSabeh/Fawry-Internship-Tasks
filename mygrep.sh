#!/bin/bash

show_line_numbers=0
invert_match=0

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)
            echo "Usage: $0 [OPTIONS] PATTERN FILE"
            echo "Options:"
            echo "  -n          Show line numbers"
            echo "  -v          Invert match (non-matching lines)"
            echo "  --help      Display this help message"
            exit 0
            ;;
        -*)
            options="${1#-}"
            for ((i=0; i<${#options}; i++)); do
                opt="${options:$i:1}"
                case "$opt" in
                    n) show_line_numbers=1 ;;
                    v) invert_match=1 ;;
                    *)
                        echo "Error: Invalid option -$opt" >&2
                        exit 1
                        ;;
                esac
            done
            shift
            ;;
        *)
            break
            ;;
    esac
done

# Check remaining arguments
if [[ $# -ne 2 ]]; then
    if [[ $# -eq 1 ]]; then
        echo "Error: Missing search string or file." >&2
    else
        echo "Error: Incorrect number of arguments." >&2
    fi
    exit 1
fi

pattern="$1"
file="$2"

# Check if file exists
if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found." >&2
    exit 1
fi

# Process each line
line_number=0
while IFS= read -r line; do
    line_number=$((line_number + 1))
    line_lower=$(echo "$line" | tr '[:upper:]' '[:lower:]')
    pattern_lower=$(echo "$pattern" | tr '[:upper:]' '[:lower:]')
    if [[ "$line_lower" == *"$pattern_lower"* ]]; then
        matched=1
    else
        matched=0
    fi

    # Invert match if -v is set
    if [[ $invert_match -eq 1 ]]; then
        matched=$((1 - matched))
    fi

    if [[ $matched -eq 1 ]]; then
        if [[ $show_line_numbers -eq 1 ]]; then
            echo "$line_number:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"

exit 0
