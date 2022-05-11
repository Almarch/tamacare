
dir_tamatool=~/.../tamatool/linux # the directory that contains tamatool
new_tam=true           # do you need to launch a new tamagotchi ? => set up clock and wait up to eclosion
tam_name='Guizmo'      # the tamagotchi name
tam_speed='one'        # accepted values are "one" or "ten" (maximum speed doesn't work reliabily)
to_load='Guizmo.bin'   # the backup file to load, if starting from an existing (=> new_tam=false) 

time_obs=30       # How long (sec.) should the system wait between 2 obs of the main screen
time_param=300    # How long (sec.) should the system wait between 2 parameters control
time_save=28800   # How long (sec.) should the system wait before an automatic backup
disc=1            # Should the tamagotchi be grounded when needed ? use disc=1 for "true", disc=0 to discover the secret character

rm $dir_tamatool/save0.bin # this save name must be free

# first launch, set time
if [ "$new_tam" = true ] ; then

# set time
  Time=$(date "+%H:%M")
  R_BATCH_OPTIONS="--args dir='$dir_tamatool';Time='$Time';name='$tam_name';speed='ten'"
  R CMD BATCH --no-save "$R_BATCH_OPTIONS" $R_opt R/proc_clock.R /dev/null

# hatch
  R_BATCH_OPTIONS="--args dir='$dir_tamatool';name='$tam_name';speed='$tam_speed'"
  R CMD BATCH --no-save "$R_BATCH_OPTIONS" $R_opt R/proc_hatch.R /dev/null
# backup for tamacare
  to_load="${tam_name}.bin"
fi

# tamacare
R_BATCH_OPTIONS="--args dir='$dir_tamatool';dir_images='image_analysis';name='$tam_name';speed='$tam_speed';tobs=$time_obs;tpar=$time_param;tsav=$time_save;to_load='$to_load';disc=$disc"
R CMD BATCH --no-save "$R_BATCH_OPTIONS" $R_opt R/proc_tamacare.R log.txt

# life summary
R_BATCH_OPTIONS="--args name='$tam_name';speed='$tam_speed';logfile='log.txt'"
R CMD BATCH --no-save "$R_BATCH_OPTIONS" $R_opt R/proc_analysis.R /dev/null
