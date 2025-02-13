#!/bin/bash

# Find all CSV files in the current directory and store them in an array.
csv_files=($(find . -maxdepth 1 -type f -name "*.csv"))

# Check if any CSV files were found.
if [ ${#csv_files[@]} -eq 0 ]; then
  echo "No CSV files found in the current directory."
  exit 1
fi

# Get the header from the first CSV file.
head -n 1 "${csv_files[1]}" > combined.csv

# Loop through all CSV files, skipping the header line and appending to the combined file.
for file in "${csv_files[@]}"; do
  # Skip the first file (already used for the header).
  if [[ "$file" != "${csv_files[0]}" ]]; then
    tail -n +2 "$file" >> combined.csv
  fi
done

echo "CSVs combined into combined.csv"
