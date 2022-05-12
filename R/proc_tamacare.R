
source("R/fun.R")

args = (commandArgs(TRUE))
for(i in 1:length(args)) eval(parse(text = args[[i]]))

init(name = name,
     dir_tamatool = dir_tam,
     x    = 0,
     y    = 0,
     filename = to_load)

tamacare(dir_images   = dir_images,
         dir_tamatool = dir_tam,
         name         = name,
         speed        = speed,
         x            = 0,
         y            = 0,
         tobs         = tobs,
         tpar         = tpar,
         tsav         = tsav,
         disc         = as.logical(disc))



