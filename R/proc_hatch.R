
source("R/fun.R")

args = (commandArgs(TRUE))
for(i in 1:length(args)) eval(parse(text = args[[i]]))

init(name = name,
     dir  = dir,
     x    = 0,
     y    = 0,
     filename = paste0(name,".bin"))

hatch(name = name,
      speed = speed,
      filename = paste0(name,".bin"),
      dir = dir,
      and_kill = T)



