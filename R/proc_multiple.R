
source("R/fun.R")

dir_collection = "../collection"
to_display = dir("../collection")
gen = c("gen1","gen2")[c(1,2,1,1,1,1)]

init_multi(all_names = gsub(to_display,pattern = ".bin",replacement = ""),
           dir_tamatool  = "~/.../tamatool/linux",
           gen  = gen,
           xmax = 3,
           collec = paste0(dir_collection,"/",to_display))
