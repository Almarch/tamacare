
source("R/fun.R")

args = (commandArgs(TRUE))
for(i in 1:length(args)) eval(parse(text = args[[i]]))

all_names =  all_names[1:max(length(dir(dir_collection)))]

init_multi(all_names = all_names,
           dir_tamatool  = dir_tam,
           xmax = 3,
           collec = paste0(dir_collection,"/",
                           sample(dir(dir_collection),length(all_names),F)))
