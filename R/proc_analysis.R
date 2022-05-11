
source("R/fun.R")

args = (commandArgs(TRUE))
for(i in 1:length(args)) eval(parse(text = args[[i]]))

analysis(file.in = logfile,
         file.out = paste0(name,".png"),
         speed = speed)



