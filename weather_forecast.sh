Last login: Fri Feb 23 20:54:32 on console
cd
The default interactive shell is now zsh.
To update your account to use zsh, please run `chsh -s /bin/zsh`.
For more details, please visit https://support.apple.com/kb/HT208050.
(base) Sanjanas-MacBook-Air:~ chiku123$ ~/desktop
-bash: /Users/chiku123/desktop: is a directory
(base) Sanjanas-MacBook-Air:~ chiku123$ /~desktop
-bash: /~desktop: No such file or directory
(base) Sanjanas-MacBook-Air:~ chiku123$ cd ~/desktop
(base) Sanjanas-MacBook-Air:desktop chiku123$ cd ~/unix project
-bash: cd: /Users/chiku123/unix: Not a directory
(base) Sanjanas-MacBook-Air:desktop chiku123$ cd ~/"unix project"
-bash: cd: /Users/chiku123/unix project: No such file or directory
(base) Sanjanas-MacBook-Air:desktop chiku123$ /Users/chiku123/Desktop/unix\ project 
-bash: /Users/chiku123/Desktop/unix project: is a directory
(base) Sanjanas-MacBook-Air:desktop chiku123$ nano weather_forecast.sh






  UW PICO 5.09               File: weather_forecast.sh                Modified  

#!/bin/bash                                                    
                    
# Check if API key is set
if [ -z "$METEOMATICS_API_KEY" ]; then      
    echo "Error: Meteomatics API key not set. Please set the 
METEOMATICS_API_KEY environment variable."                               
    exit 1
fi                                                                             

# Construct the API URL                             
API_URL="https://api.meteomatics.com/2024-02-24T00:00:00Z--2024-02-29T00:00:00Z$"
                                          
# Fetch weather data using curl 
weather_data=$(curl -s "https://api.meteomatics.com/2024-02-24T00:00:00Z--2024-02-29T00:00:00Z$")
                        
# Print weather data                                                   
echo "Weather Data:"              
echo "$weather_data"


^G Get Help  ^O WriteOut  ^R Read File ^Y Prev Pg   ^K Cut Text  ^C Cur Pos   
^X Exit      ^J Justify   ^W Where is  ^V Next Pg   ^U UnCut Text^T To Spell  
