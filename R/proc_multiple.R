
source("R/fun.R")

dir_collection = "../collection"
to_display = sample(dir("../collection"),size = 6, replace = FALSE)

init_multi(all_names = gsub(to_display,pattern = ".bin",replacement = ""),
           dir_tamatool  = "~/.../tamatool/linux",
           xmax = 3,
           collec = paste0(dir_collection,"/",to_display))
