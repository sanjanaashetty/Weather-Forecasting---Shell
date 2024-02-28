#!/bin/bash

# Prompt the user for location, units, and API key

LOCATION=$1
UNITS=$2

# Define the API URL with the provided inputs
API_URL="https://api.tomorrow.io/v4/weather/realtime?location=${LOCATION}&units=${UNITS}&apikey=qCPWhkjvhGcvKo4GAHzKNikqqbuFvoFU"

# Define the number of requests to make
NUM_REQUESTS=5

# Create a directory to store JSON files
mkdir -p json_files
curtime=$(date "+%H_%M_%S")
avgtemp=0
avghum=0
avgwind=0
avgprecip=0
weather_message=" "
# Make multiple GET requests to the API using cURL
for ((i=1; i<=$NUM_REQUESTS; i++)); do
    # Make the API request and save the response to a JSON file
    file_name="output_${i}_${curtime}_${LOCATION}"
    curl --request GET --url "$API_URL" --header 'accept: application/json' -o "json_files/${file_name}.json"
    # Extract temperature value from JSON output
    temperature=$(jq -r '.data.values.temperature' "json_files/${file_name}.json")
    humidity=$(jq -r '.data.values.humidity' "json_files/${file_name}.json")
    windSpeed=$(jq -r '.data.values.windSpeed' "json_files/${file_name}.json")
    precipitationProb=$(jq -r '.data.values.precipitationProbability' "json_files/${file_name}.json")
    echo "$temperature"
    # Define weather message and icon URL based on temperature value
    avgtemp=$(echo "scale=2; ($avgtemp + $temperature)" | bc)
    avghum=$(echo "scale=2; ($avghum + $humidity)" | bc)
    avgwind=$(echo "scale=2; ($avgwind + $windSpeed)" | bc)
    avgprecip=$(echo "scale=2; ($avgprecip + $precipitationProb)" | bc)

done

avgtemp=$(echo "scale=2; $avgtemp / $NUM_REQUESTS" | bc)
avghum=$(echo "scale=2; $avghum / $NUM_REQUESTS" | bc)
avgwind=$(echo "scale=2; $avgwind / $NUM_REQUESTS" | bc)
avgprecip=$(echo "scale=2; $avgprecip / $NUM_REQUESTS" | bc)

if (( $(echo "$avgtemp > 30" | bc -l) )); then
    weather_message+="It's hot"
    icon_url="https://cdn.iconscout.com/icon/premium/png-512-thumb/hot-weather-9110804-7413575.png?f=webp&w=256"
elif (( $(echo "$avgtemp > 20" | bc -l) )); then
    weather_message+="It's warm"
    icon_url="https://i.pinimg.com/564x/5b/04/93/5b0493b3a910f7ce7a737969bf3bc5d1.jpg"
else
    weather_message+="It's cold"
    icon_url="https://cdn-icons-png.flaticon.com/512/6232/6232631.png"
fi

if (( $(echo "$avghum > 60" | bc -l) )); then
    weather_message+=", with high humidity "
elif (( $(echo "$avghum > 30" | bc -l) )); then
    weather_message+=", with moderate humidity "
else
    weather_message+=", with low humidity "
fi

if (( $(echo "$avgprecip > 60" | bc -l) )); then
    weather_message+="and a high chance of rain."
elif (( $(echo "$avgprecip > 30" | bc -l) )); then
    weather_message+="and a moderate chance of rain."
else
    weather_message+="and a low chance of rain."
fi
# Output weather message and icon URL
echo "$weather_message {"
echo "$icon_url {"
echo "$avgtemp {"
echo "$avghum {"
echo "$avgwind {"
echo "$avgprecip {"



# Zip the JSON files
zip -r json_files.zip json_files

# Unzip the JSON files
unzip json_files.zip -d extracted_json_files

# Optional: Cleanup temporary files and directories
rm -rf json_files
rm json_files.zip
