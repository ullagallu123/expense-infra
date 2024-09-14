#!/bin/bash

# List of folders in the required order
folders=(
  "01.vpc/"
  "02.sg/"
  "02a.instances/"
  "03.db/"
  "04.internal-alb/"
  "05.acm/"
  "06.external-alb/"
  "07.backend-asg/"
  "08.frontend-asg/"
)

# Start the overall timer
overall_start=$(date +%s)

# Iterate through each folder and execute Terraform commands
for folder in "${folders[@]}"; do
  echo "Processing $folder..."

  # Start the timer for the current folder
  start=$(date +%s)

  # Change to the directory
  cd "$folder" || { echo "Cannot change directory to $folder"; exit 1; }

  # Execute Terraform commands
  terraform init || { echo "Terraform init failed in $folder"; exit 1; }
  terraform fmt -recursive || { echo "Terraform fmt failed in $folder"; exit 1; }
  terraform validate || { echo "Terraform validate failed in $folder"; exit 1; }
  terraform plan -lock=false|| { echo "Terraform plan failed in $folder"; exit 1; }
  terraform apply --auto-approve -lock=false|| { echo "Terraform apply failed in $folder"; exit 1; }

  # Calculate the time taken for this folder
  end=$(date +%s)
  duration=$((end - start))
  minutes=$((duration / 60))
  seconds=$((duration % 60))
  echo "$folder processed successfully in $minutes min $seconds sec."

  # Return to the parent directory
  cd - || { echo "Cannot return to previous directory"; exit 1; }

done

# Calculate the overall time taken
overall_end=$(date +%s)
overall_duration=$((overall_end - overall_start))
overall_minutes=$((overall_duration / 60))
overall_seconds=$((overall_duration % 60))
echo "All folders processed successfully in $overall_minutes min $overall_seconds sec."
