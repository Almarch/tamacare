
focus = function(name) {
  return(paste0("xdotool search --name \"",name,"\" windowfocus --sync"))
}
ABC = function(abc,name,speed) {
  if(speed == "one") delay = .03
  if(speed == "ten") delay = .003
  if(speed == "max") delay = .001
  sp = set_speed(name = name, speed = speed)
  txt = c(focus(name),
          paste0("xdotool keydown ",abc," sleep ",delay," keyup ",abc),
          paste0("sleep ",round(.5*sp$s,3)))
  return(txt)
}
A = function(name,speed="one") {
  ABC("Left",name=name,speed=speed)
}
B = function(name,speed="one") {
  ABC("Down",name=name,speed=speed)
}
C = function(name,speed="one") {
  ABC("Right",name=name,speed=speed)
}
AB5 = function(name,speed = "one"){
  txt = c()
  for(i in 1:5) {
    txt = c(txt,
            if(runif(1)>.5) A(name=name,speed=speed) else B(name=name,speed=speed),
            paste0("sleep ", 7*set_speed(speed = speed, name = name)$s))
  }
  return(txt)
}

check = function(dir){
  go = c(paste0("cd ",dir),
         paste0("./check.sh"))
  run(go)
}
run = function(sh) {
  cat(paste(sh,collapse="\n"),file = "R/todo.sh",append=F)
  system("chmod +x R/todo.sh")
  system("./R/todo.sh")
  unlink("R/todo.sh")
}
set_speed = function(speed = c("one","ten","max"),name) {
  if(speed == "one") {
    a = ""
    b = ""
    s = 1
  }
  if(speed == "ten") {
    a = c(focus(name),"xdotool key f")
    b = c(focus(name),rep("xdotool key f",2))
    s = 1/10
  }
  if(speed == "max") { # experimental ; do not use
    a = c(focus(name),rep("xdotool key f",2))
    b = c(focus(name),"xdotool key f")
    s = 1/60 # ? not stable
  }
  return(list(a=a,b=b,s=s))
}
save_as = function(name,filename,dir, and_kill= F){
  run(c(paste0("cd ",dir),
        focus("TamaTool"),
        "xdotool key b",
        if(and_kill) paste0("xdotool search --name \"",name,"\" windowkill"),
        paste0("mv save0.bin ",filename)))
}

clock = function(dir,Time = NULL,speed = "one",filename){
  
  if(is.null(Time)) Time = format(Sys.time(),"%H:%M")
  hr  = as.numeric(unlist(lapply(strsplit(Time,split=":"),function(x) return(x[[1]]))))
  min = as.numeric(unlist(lapply(strsplit(Time,split=":"),function(x) return(x[[2]]))))
  
  sp = set_speed(speed = speed, name  = name)
  
  ### launch
  go = c(paste0("cd ",dir),
         "nohup ./tamatool </dev/null >/dev/null 2>&1 &",
         "sleep 2")
  
  ### set clock
  go = c(go,
         B(speed = speed,name = name),
         "sleep 1",
         sp$a,
         rep(A(speed = speed,name = name),
             times = hr),
         rep(B(speed = speed,name = name),
             times = min),
         sp$b)
  run(go)
  
  ### save
  save_as(dir=dir, filename = filename, name = "TamaTool", and_kill = T)
  return(NULL)
}

init = function(name, dir, x , y, filename){
  # x %% 345
  # y %% 375 including 30 of header
  go = c(paste0("cd ",dir),
         paste0("nohup ./tamatool -l ",filename," </dev/null >/dev/null 2>&1 &"),
         "sleep .5",
         focus("TamaTool"),
         "xdotool key t",
         "sleep .5",
         paste0("xdotool search --name \"TamaTool\" set_window --name \"",name,"\""),
         
         # if multiple windows split init() between these lines:
         #paste0("xdotool search --name \"",name,"\" windowminimize --sync"))
         #paste0("xdotool search --name \"",name,"\" windowmap --sync"),
         
         focus(name),
         paste0("xdotool getactivewindow windowmove ",x," ",y))
  run(go)
  return(NULL)
}

hatch = function(name,speed = c("one","ten"), filename = NULL, and_kill = F, dir = NULL) {
  sp = set_speed(speed = speed,
                 name = name)
  go = c(C(speed = "one",name = name),
         "sleep .3",
         B(speed = "one",name = name),
         "sleep 3",
         sp$a,
         paste0("sleep ",round((5*60-10)*sp$s,3)),
         sp$b,
         "sleep 10")
  run(go)
  if(!is.null(filename)) save_as(dir = dir, name = name, filename = filename, and_kill = and_kill)
  return(NULL)
}

feed = function(name,dir,speed,what = "meal",prev=NULL,
                ntimes = 1, quick = F, arrow) {
  require(png)
  
  short_sleep = 5
  if(quick) short_sleep = 1
  sp = set_speed(name = name, speed = speed)
  
  run(c(A(name = name, speed = speed), # select feed
        B(name = name, speed = speed)))
  
  if(is.null(prev)){
    check(dir)
    sel = readPNG(paste0(dir,"/work/sel.png"))
    if(all(sel == arrow)) prev = "sweet" else prev = "meal"
    
    if(speed == "ten"){
      run(c(rep(C(name = name, speed = speed),2),
            paste0("sleep ", 1*sp$s),
            A(name = name, speed = speed),
            B(name = name, speed = speed)))
    }
  }
  
  go = c(if(prev != what) A(name = name, speed = speed), # select right meal
         rep(c(B(name = name, speed = speed), # select meal
               paste0("sleep ", short_sleep*sp$s)),
             times = ntimes),
         rep(C(name = name, speed = speed),2),
         paste0("sleep ", 1*sp$s))
  run(go)
  return(NULL)
}

play = function(name,speed,ntimes = 1) {
  sp = set_speed(name = name, speed = speed)
  go = c(rep(A(name = name, speed = speed),3), # select play
         B(name = name, speed = speed), # select play
         rep(c(paste0("sleep ", 3*sp$s), # intro
               AB5(name = name, speed = speed),
               paste0("sleep ", 6*sp$s)), # scores
             times = ntimes),
         paste0("sleep ", 3*sp$s), # intro again
         rep(C(name = name, speed = speed),2),
         paste0("sleep ", 1*sp$s))
  run(go)
  return(NULL)
}

clean = function(name,speed) {
  sp = set_speed(name = name, speed = speed)
  go = c(rep(A(name = name, speed = speed),5), # select clean
         B(name = name, speed = speed), # select clean
         paste0("sleep ", 7*sp$s),
         rep(C(name = name, speed = speed),2),
         paste0("sleep ", 1*sp$s))
  run(go)
  return(NULL)
}

heal = function(name,speed,dir,skull) {
  require(png)
  sp = set_speed(speed,name)
  
  go = c(rep(A(name = name, speed = speed),4), # select heal
         rep(c(B(name = name, speed = speed),
               paste0("sleep ", 6*sp$s))))
  run(go)
  check(dir)
  top = readPNG(paste0(dir,"/work/top.png"))
  
  if(speed == "one"){
    while(all(top == skull)){
      go = c(B(name = name, speed = speed),
             paste0("sleep ", 6*sp$s))
      run(go)
      check(dir)
      top = readPNG(paste0(dir,"/work/top.png"))
    }
    run(c(rep(C(name = name, speed = speed),2),
          paste0("sleep ",1*sp$s))) # exit
  }
  
  if(speed == "ten"){
    run(c(rep(C(name = name, speed = speed),2),
          paste0("sleep ",1*sp$s))) # exit
    while(all(top == skull)){
      go = c(rep(A(name = name, speed = speed),4), # select heal
             rep(c(B(name = name, speed = speed),
                   paste0("sleep ", 6*sp$s))),
             c(rep(C(name = name, speed = speed),2),
               paste0("sleep ",1*sp$s)))
      run(go)
      check(dir)
      top = readPNG(paste0(dir,"/work/top.png"))
    }
  }
  
  return(NULL)
}

ground = function(name,speed) {
  sp = set_speed(name = name, speed = speed)
  go = c(rep(A(name = name, speed = speed),7), # select ground
         B(name = name, speed = speed), # select ground
         paste0("sleep ", 5*sp$s),
         rep(C(name = name, speed = speed),2),
         paste0("sleep ", 1*sp$s))
  run(go)
  return(NULL)
}

light = function(name, speed, what = "off", prev = "on") {
  sp = set_speed(name = name, speed = speed)
  go = c(rep(A(name = name, speed = speed),2), # select light
         B(name = name, speed = speed), # select light
         if(prev != what) A(name = name, speed = speed), # select on/off
         B(name = name, speed = speed), # select on/off
         rep(C(name = name, speed = speed),2))
  run(go)
}

params = function(name, speed, dir, heart) {
  require(png)
  par = c(happy = 0,hungry = 0)
  sp = set_speed(name = name, speed = speed)
  
  go = c(rep(A(name = name, speed = speed),6), # select params
         rep(B(name = name, speed = speed),1),
         paste0("sleep ", 1*sp$s), # takes a gap
         rep(B(name = name, speed = speed),2)) # hungry
  run(go)
  
  check(dir)
  h1 = readPNG(paste0(dir,"/work/sel.png"))
  h2 = readPNG(paste0(dir,"/work/h2.png"))
  h3 = readPNG(paste0(dir,"/work/h3.png"))
  h4 = readPNG(paste0(dir,"/work/bot.png"))
  if(all(h1 == heart)) par["hungry"] = par["hungry"] + 1
  if(all(h2 == heart)) par["hungry"] = par["hungry"] + 1
  if(all(h3 == heart)) par["hungry"] = par["hungry"] + 1
  if(all(h4 == heart)) par["hungry"] = par["hungry"] + 1
  
  if(speed == "one"){
    run(B(name = name, speed = speed)) # happy
  }
  
  if(speed == "ten"){
    run(c(rep(C(name = name, speed = speed),2),
          paste0("sleep ",1*sp$s))) # exit
    go = c(rep(A(name = name, speed = speed),6), # select params
           rep(B(name = name, speed = speed),4)) # happy
    run(go)
  }
  
  check(dir)
  h1 = readPNG(paste0(dir,"/work/sel.png"))
  h2 = readPNG(paste0(dir,"/work/h2.png"))
  h3 = readPNG(paste0(dir,"/work/h3.png"))
  h4 = readPNG(paste0(dir,"/work/bot.png"))
  if(all(h1 == heart)) par["happy"] = par["happy"] + 1
  if(all(h2 == heart)) par["happy"] = par["happy"] + 1
  if(all(h3 == heart)) par["happy"] = par["happy"] + 1
  if(all(h4 == heart)) par["happy"] = par["happy"] + 1
  
  run(c(rep(C(name = name, speed = speed),2),
        paste0("sleep ",1*sp$s))) # exit
  
  return(par)
}

get_ref = function(dir){
  # get the references rasters
  refs = dir(paste0(dir,"/resources"))
  refs = gsub(x = refs,pattern = ".png",replacement="")
  
  ref = list()
  for(r in refs){
    ref[[r]] = readPNG(paste0(dir,"/resources/",r,".png"))
  }
  return(ref)
}

tamacare = function(dir_images,
                    dir_tamatool,
                    name,speed = "one",
                    x = 0, y = 0,
                    tobs,tpar,tsav,
                    disc=TRUE){
  require(png)
  sp = set_speed(speed=speed,name=name)
  ref = get_ref(dir_images)
  
  t0 <- Sys.time()
  tlastobs = t0 - max(tobs,tpar)
  tlastpar = t0 - max(tobs,tpar)
  tlastsav = t0
  tobs = tobs*sp$s
  tpar = tpar*sp$s
  tsav = tsav*sp$s
  
  run(sp$a)
  dead = F
  while(!dead){
    # check dead
    suppressWarnings(dead <- system(paste0("xdotool search --name ",name), intern = TRUE))
    dead = length(dead) == 0
    
    if(!dead) {
      check(dir_images)
      clock = readPNG(paste0(dir_images,"/work/clock.png"))
      mid   = readPNG(paste0(dir_images,"/work/middle.png"))
      bot   = readPNG(paste0(dir_images,"/work/bot.png"))
      dead = (all(bot == ref$dead2) | all(bot == ref$dead1))
      
      if(!dead) {
        bad.screen = T
        while(bad.screen) {
          bad.screen = F
          # check issue (clock mode, light off)
          if(all(clock == ref$m)){
            go = c(B(name = name,speed = speed),
                   paste0("sleep ",3*sp$s))
            run(go)
            bad.screen = T
          }
          if(all(mid == ref$black)){
            light(name = name, speed = speed, what = "on", prev = "off")
            bad.screen = T
          }
          if(bad.screen) {
            check(dir_images)
            clock = readPNG(paste0(dir_images,"/work/clock.png"))
            mid   = readPNG(paste0(dir_images,"/work/middle.png"))
          } else {
            top   = readPNG(paste0(dir_images,"/work/top.png"))
            bot   = readPNG(paste0(dir_images,"/work/bot.png"))
            need  = readPNG(paste0(dir_images,"/work/need.png"))
            mid   = readPNG(paste0(dir_images,"/work/middle.png"))
          }
        }
        
        # is it asleep ?
        is.asleep = F
        if((all(mid == ref$zzz_dark) | all(mid == ref$Z_dark))){
          is.asleep = T
        }
        
        # double poop: try to clean - or is it asleep ?
        if(all(top == ref$poop1) | all(top == ref$poop2)) {
          print(paste(Sys.time(),":","What a mess ! Poop everywhere"))
          clean(name = name, speed = speed)
          check(dir_images)
          top = readPNG(paste0(dir_images,"/work/top.png"))
          if(all(top == ref$poop1) | all(top == ref$poop2)) {
            print(paste(Sys.time(),":","It is sleep time, despite the mess"))
            light(name = name, speed = speed, what = "off", prev = "on")
            is.asleep = TRUE
          }
        }
        
        # asleep is the number 1 prio
        if(all(top == ref$zzz) | all(top == ref$Z)){
          print(paste(Sys.time(),":","It is sleep time"))
          light(name = name, speed = speed, what = "off", prev = "on")
          is.asleep = TRUE
        } else if(all(bot == ref$poop1) | all(bot == ref$poop2)) {
          print(paste(Sys.time(),":","Let's clean this poop"))
          clean(name = name, speed = speed)
        }
        
        # if not asleep (and after cleaning the poop): heal
        if(all(top == ref$skull)){
          print(paste(Sys.time(),":",name,"is sick. Let's heal it"))
          heal(name = name, speed = speed, dir = dir_images,skull = ref$skull)
        }
        
        # check param
        if(((Sys.time() > tlastpar + tpar) | all(need == ref$cry)) & !is.asleep) {
          
          # param check
          par = params(name = name, speed = speed, dir = dir_images, heart = ref$heart_full)
          print(paste(Sys.time(),":"," How is",name,"going ? Parameters:"))
          print(paste(c("Happy: ",rep("<3",times=par[["happy"]])),collapse=""))
          print(paste(c("Hungry: ",rep("<3",times=par[["hungry"]])),collapse=""))
          
          # if feed & cry: ground
          if(par[["hungry"]] > 0 & all(need == ref$cry)){
            print(paste(Sys.time(),":",name,"needs discipline"))
            if(disc) ground(name = name,speed = speed)
          }
          
          # fill hunger + happiness
          prev = NULL
          # feed
          if(par[["hungry"]] < 4){
            feed(name = name,speed = speed,
                 what = "meal",prev=prev,
                 dir = dir_images,
                 arrow=ref$arrow,
                 ntimes = 4 - par[["hungry"]])
            prev = "meal"
          }
          par[["hungry"]] = 4
          
          # happiness: sweet up to 3hearts
          if(par[["happy"]] < 3){
            feed(name = name,speed = speed,
                 what = "sweet",prev = prev,
                 dir = dir_images,
                 arrow=ref$arrow,
                 ntimes = 3 - par[["happy"]])
            prev = "sweet"
            par[["happy"]] = 3
          }
          
          # happiness: play 2 times
          if(par[["happy"]] < 4){
            play(name = name,speed = speed, ntimes = 2)
          }
          
          # ok if 8 hearts
          if(sum(par)==8) tlastpar = Sys.time()
        }
        
        # save and kill the remaining time
        tinstant = Sys.time()
        if(tinstant > tlastsav + tsav) {
          print(paste(Sys.time(),":","We had fun. Let's save this party"))
          save_as(name=name,
                  dir = dir_tamatool,
                  filename=paste0(name,"_",
                                  round((tinstant - t0) / 3600,2),
                                  ".bin"))
          tlastsav = Sys.time()
        }
        if(tinstant < tlastobs + tobs) {
          run(paste0("sleep ",(tlastobs + tobs) - tinstant))
        }
        tlastobs = Sys.time()
      } # dead 1
    } # dead 2
  } # while
} # fun

get_time = function(x,pattern){
  x = x[grep(x,pattern = pattern)]
  x = substr(x,5,23)
  x = as.POSIXct(strptime(x, "%Y-%m-%d %H:%M:%S"))
  return(x)
}
get_hearts = function(x,pattern){
  x = x[grep(x,pattern = pattern)]
  x = unlist(lapply(strsplit(x,""),function(x) length(which(x == "<"))))
  return(x)
}
analysis = function(file.in,file.out,speed){
  if(speed == "one") sp = 1
  if(speed == "ten") sp = 10
  
  txt = read.delim(file.in)
  txt = txt[,1]
  chrono = list()
  chrono$params  = get_time(txt,"Parameters")
  chrono$sick    = get_time(txt,"sick")
  chrono$poop    = get_time(txt,"this poop")
  chrono$poop2   = get_time(txt,"Poop everywhere")
  chrono$sleep   = get_time(txt,"sleep")
  chrono$disc    = get_time(txt,"discipline")
  happy   = get_hearts(txt,"Happy")
  hungry  = get_hearts(txt,"Hungry")
  
  t0 = min(unlist(chrono))
  tab = data.frame()
  for(i in 1:length(chrono)){
    tab = rbind(tab,
                data.frame(event = rep(names(chrono)[i],length(chrono[[i]])),
                           time  = sp*as.numeric(chrono[[i]]-t0)/3600,
                           stringsAsFactors = F))
  }
  tab = tab[order(tab$time,decreasing = F),]
  tx = tab$time[nrow(tab)]
  tab = rbind(tab,
              data.frame(event = "end",
                         time  = tx,
                         stringsAsFactors = F))
  
  png(file=file.out, height=10,width=15*tx/24+3,units="cm",res=300,type="cairo")
  layout(mat = matrix(c(1,2),
                      nrow = 1,
                      ncol = 2,
                      byrow = T),
         width = c(10*tx/24+1,2),height=c(1))
  par(mai = c(1,1,1,0)/2.54)
  plot(x=c(0,tx),y=c(-4,7),type="n",xlab="",ylab="",axes=F)
  box()
  abline(h = c(-4:-1,1:4))
  axis(side   = 1,
       at     = seq(from = 0, to = tx, by = 24),
       labels = seq(from = 0, to = tx, by = 24)/24)
  axis(side = 2, at = c(4:-4), labels = c(4:0,1:4))
  
  ev = which(tab$event == "params" | tab$event == "end")
  if(length(ev)>1) for(i in 1:length(ev)){
    polygon(c(rep(tab$time[ev[i]],2),rep(tab$time[ev[i+1]],2)),c(0,rep(hungry[i],2),0),col="red")
    polygon(c(rep(tab$time[ev[i]],2),rep(tab$time[ev[i+1]],2)),c(0,rep(-happy[i],2),0),col="yellow")
  }
  ev = which(tab$event == "sleep")
  if(length(ev)>1) for(i in 1:length(ev)){
    abline(v = tab$time[ev[i]], col = "black", lwd = 3)
  }
  
  evTab = data.frame(event = c("poop", "poop2","poop2","sick"  ,"disc"     ),
                     col   = c("green","green","green","purple","lightblue"),
                     pos   = c( 5     , 5     , 5.5   , 6      , 7         ),
                     stringsAsFactors = F)
  for(i.ev in 1:nrow(evTab)){
    ev = which(tab$event == evTab$event[i.ev])
    if(length(ev)>1) for(i in 1:length(ev)){
      points(tab$time[ev[i]],evTab$pos[i.ev],pch = 19, cex=2, col = evTab$col[i.ev])
      points(tab$time[ev[i]],evTab$pos[i.ev],pch = 1,  cex=2)
    }
  }
  
  par(mai=rep(0,4))
  plot(1,1,type="n",axes=F)
  legend("center",
         pch = 21,
         pt.bg = c("lightblue","purple","green","red","yellow","black"),
         legend = c("Disc.",
                    "Sick",
                    "Poop",
                    "Hungry",
                    "Happy",
                    "Sleep"),
         bty = "n")
  dev.off()
}
