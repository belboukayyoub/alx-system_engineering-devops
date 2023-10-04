#!/bin/bash

# This script is to export data from the log file
input="text_messages.log"
count=0

echo -e "\e[32mStart Exporting...\e[0m"

echo "SENDER,RECEIVER,FLAGS" > statistics.csv

while IFS= read -r line
do
  ./100-textme.rb "$line" >> statistics.csv
  echo -ne "\r$count Records"
  count=$(( count + 1))
done < "$input"

echo -e "\e[32mDone\e[0m"