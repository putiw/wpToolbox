#!/bin/zsh

# Enable debugging
# set -x

# Variables
BIDS_DIR="$1"
OLD_NAME="$2"
NEW_NAME="$3"

# Initialize Counters
typeset -A rename_count
typeset -A modify_count

# Check if jq is installed
if ! command -v jq &> /dev/null
then
  echo "jq is not installed. Installing jq..."
  brew install jq
fi

# Text replacement in JSON files
find "$BIDS_DIR" -type f -name "*.json" | while read -r file; do
  jq "(.. | strings) |= gsub(\"$OLD_NAME\"; \"$NEW_NAME\")" "$file" > tmp.json && mv tmp.json "$file"
  dir_name=$(dirname "$file")
  modify_count[$dir_name]=$(( ${modify_count[$dir_name]} + 1 ))
done

# Rename directories first
find "$BIDS_DIR" -type d -name "*$OLD_NAME*" | while read -r dir; do
  new_dir_name=$(echo "$dir" | sed "s/$OLD_NAME/$NEW_NAME/g")
  mv "$dir" "$new_dir_name"
  dir_name=$(dirname "$new_dir_name")
  rename_count[$dir_name]=$(( ${rename_count[$dir_name]} + 1 ))
done

# Rename files next
find "$BIDS_DIR" -type f -name "*$OLD_NAME*" | while read -r file; do
  new_file_name=$(echo "$file" | sed "s/$OLD_NAME/$NEW_NAME/g")
  mv "$file" "$new_file_name"
  dir_name=$(dirname "$new_file_name")
  rename_count[$dir_name]=$(( ${rename_count[$dir_name]} + 1 ))
done

# Report counts


echo "Finished!"

