import sys
import os
file_item_path= os.path.join(os.path.dirname(__file__),"Lib\site-packages") # con esta linea de codigo realizamos el import de la libreria
print(file_item_path)
sys.path.append(file_item_path)
