"""  ejemplo de subprocess ejecuta script R
import subprocess
# Define command and arguments
command = 'Rscript'
path2script = 'C:/Users/MIGUEL/Documents/Sublime/R/Luis/MaxR.R'
# Variable number of args in a list
args = ['11', '3', '9', '42']
# Build subprocess command
cmd = [command, path2script] + args
print(cmd)
# check_output will run the command and store to result
x = subprocess.check_output(cmd, universal_newlines=True)
print('The maximum of the numbers is:', x)
"""
import os, sys
file_item_path= os.path.join(os.path.dirname(__file__),"codeR\Lib\site-packages") 
sys.path.append(file_item_path)
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__),'..')))             
import time


""" ejemplo 2 usa rpy2
import rpy2.robjects as robjects

r = robjects.r
x = robjects.IntVector(range(10))
y = r.rnorm(10)
print(x)
print(y)

r.X11()
r.layout(r.matrix(robjects.IntVector([1,2,3,2]), nrow=2, ncol=2))
r.plot(r.runif(10), y, xlab="runif", ylab="foo/bar", col="red")

"""
""" ejemplo 3 usa rpy2
from rpy2 import robjects
from rpy2.robjects import Formula, Environment
from rpy2.robjects.vectors import IntVector, FloatVector
from rpy2.robjects.lib import grid
from rpy2.robjects.packages import importr, data
from rpy2.rinterface import RRuntimeError
import warnings

import time


# The R 'print' function
rprint = robjects.globalenv.get("print")
stats = importr('stats')
grdevices = importr('grDevices')
base = importr('base')
datasets = importr('datasets')

grid.activate()


lattice = importr('lattice')
xyplot = lattice.xyplot

datasets = importr('datasets')
s=123232
print(type(datasets))
mtcars = data(datasets).fetch('mtcars')['mtcars']
print(type(mtcars))

formula = Formula('mpg ~ wt') #columnas del dataset
print(type(formula))
formula.getenvironment()['mpg'] = mtcars.rx2('mpg')
print(type(formula.getenvironment()['mpg']))
formula.getenvironment()['wt'] = mtcars.rx2('wt')
print(type(formula.getenvironment()['wt']))


p = lattice.xyplot(formula)
print(type(p))

rprint(p)


print("something")
wait = input("PRESS ENTER TO CONTINUE.")
print("something")"""


from rpy2.robjects import r

a=r("""	
	function (abc)
for(i in 1:10){
	print(i)
              }

	""");

b=r("""
	ll <- list(c(rnorm(3)), c(rnorm(3)))
	""")


ggplotRegression = r("""
    function (fit) {

        require(ggplot2)

        ggplot(fit$model,
               aes_string(x = names(fit$model)[2],
                          y = names(fit$model)[1])) + 
            geom_point() +
            stat_smooth(method = "lm", col = "red") +
            labs(title = paste("Adj R2 = ",
                               signif(summary(fit)$adj.r.squared, 5),
                               "Intercept =",
                               signif(fit$coef[[1]],5 ),
                               " Slope =",signif(fit$coef[[2]], 5),
                               " P =",signif(summary(fit)$coef[2,4],         
                               5)))
    }""")


from rpy2.robjects.packages import importr
graphics = importr('graphics')
grdevices = importr('grDevices')
base = importr('base')
stats = importr('stats')

import array

x = array.array('i', range(10))
y = stats.rnorm(10)

print(x,y,type(x),type(y))

grdevices.X11()
graphics.par(mfrow = array.array('i', [2,2]))
graphics.plot(x, y, ylab = "foo/bar", col = "red")

kwargs = {'ylab':"foo/bar", 'type':"b", 'col':"blue", 'log':"x"}
graphics.plot(x, y, **kwargs)

m = base.matrix(stats.rnorm(100), ncol=5)
print(m)
pca = stats.princomp(m)
graphics.plot(pca, main="Eigen values")
stats.biplot(pca, main="biplot")
"""	

"""
print("something")
time.sleep(10)    # pause 5.5 seconds
print("something")

