
source("R/fun.R")

args = (commandArgs(TRUE))
for(i in 1:length(args)) eval(parse(text = args[[i]]))

clock(dir_tamatool = dir_tam,
      Time = Time,
      speed = speed,
      gen   = gen,
      filename = paste0(name,".bin"))



