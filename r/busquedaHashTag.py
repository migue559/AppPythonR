

import os, sys
file_item_path= os.path.join(os.path.dirname(__file__),"codeR/Lib/site-BusquedaPorHashtag") 
sys.path.append(file_item_path)
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__),'..')))             
import time


 #ejemplo de subprocess ejecuta script R
import subprocess
# Define command and arguments
command = 'Rscript'
BusquedaporHashTag = 'C:/Users/MIGUEL/Documents/Sublime/R/BusquedaPorHashtag.R'
# Variable number of args in a list

# Build subprocess command
cmd_BHT = [command, BusquedaporHashTag] 


# check_output will run the command and store to result
#x_1 = subprocess.check_output(cmd_BHT, universal_newlines=True)

print('#############################################################################')
print('################  Se ha Generando CSV #####################  Se ha Generando CSV  #######')
print('#############################################################################')

NaiveBayesTwitter = 'C:/Users/MIGUEL/Documents/Sublime/R/NaiveBayesTwitter.R'


cmd_NBT = [command, NaiveBayesTwitter] 

x_2 = subprocess.check_output(cmd_NBT, universal_newlines=True)

print('#############################################################################')
print('################  xxx message xxx #####################  xxx message xxx #######')
print('#############################################################################')


print(x_2)