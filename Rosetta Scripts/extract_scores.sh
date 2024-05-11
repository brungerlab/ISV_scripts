#!/bin/bash
# Output file where the results will be stored
output_file="total_scores.txt"
# Ensure the output file is empty
> "$output_file"
# Loop through each folder
for folder in {1100..1199}; do
    # Check if the folder exists
    if [ -d "$folder" ]; then
        # Extract the total_score using awk
        total_score=$(awk '/^SCORE:/ && $1 == "SCORE:" && NF > 1 {print $2}' "$folder/score_asymm.sc")
        # Check if total_score is not empty
        if [ -n "$total_score" ]; then
            # Write the folder name and total_score to the output file
            echo "$folder: $total_score" >> "$output_file"
        else
            echo "$folder: score not found" >> "$output_file"
        fi
    else
        echo "$folder does not exist" >> "$output_file"
    fi
done
echo "Extraction complete. Scores written to $output_file."
awk '{getline nextline; print $0 "," nextline}' $output_file > combined_rows.txt
