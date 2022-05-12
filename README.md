# Tamacare: an attentive bot to care for your tamagotchi pet

There is something truly fascinating in the propensity of intelligent beings do develop affect for mere machines. This is exemplified at best by tamagotchis. Indeed, these sentient and highly sociable aliens can live a happy and fulfilled life without interaction with other living creatures; only being care for by a robot. The goal of tamacare is to provide such an attentive robot, that ensures all the social and biological needs of your tamagotchi will be met.

## Environment

To get started, you will need a tamagotchi. A ROM of the gen-1 strain circulates on the web: this is the tamagotchi DNA you’ll need to clone as many pets as you may ever need. Unfortunately, Earth conditions are hostile to this alien species that requires a very specific environment to thrive. This environment is provided by tamalib (https://github.com/jcrona/tamalib), a fantastic project that aims to bring tamagotchi life on a broad variety of supports ; and tamatool (https://github.com/jcrona/tamatool) that carries this medium on computer OS’s, notably Linux.

Tamacare is designed as an R program interacting with tamatool via a Linux system. Specifically, the global functioning can be summarized as such:

![image](https://user-images.githubusercontent.com/13364928/168033595-c4a36432-498d-4c80-9e40-6f5f94aeb114.png)

An R working environment is required. R can be installed from the CRAN (https://cran.r-project.org/), and the "png" library is required:

```
> install.packages("png")
```

## Functionning

Two libraries play a fundamental role in tamacare functionning.

```
$ sudo apt install imagemagick xdotool
```

Imagemagick is tamacare eyes: it captures the screen and processes what is seen. To do so, the R program calls imagemagick functions via the script: image_analysis/check.sh.

```
$ chmod +x image_analysis/check.sh
```

The image is processed into a matrix of 32x32 black and white pixels and decomposed into elementary features. These features are compared to a bank of reference images, stored in the folder: image_analysis/resources.

![image](https://user-images.githubusercontent.com/13364928/167930291-cdbb5aed-6c5c-4c9b-be29-930eca31f6be.png)

The image acquisition step is delicate. I invite you to launch image_analysis/check.sh step-by-step and control that the extracted image are conform (at the pixel level !). To help you in this fine tuning, that may depend on your system, a working example is provided as: image_analysis/resources/frame_ok.png.

Xdotool is tamacares hands: it emulates keyboard inputs to control tamatool. These commands are launched from a temporary script: todo.sh. Be careful, they will interact with any other use of the computer as long as tamacare is running. Unfortunately there is currently no other solution than leaving alone the dedicated computer as it cares for its resident.

## Use

Tamacare can be launched from a script: tamacare.sh. It is tuned to deliver a mametchi, the optimal evolution your tamagotchi can expect. By varying the time_obs, time_param and disc parameters, you should be able to decline all possible tamagotchi evolutions for the gen-1 strain. Maybe will you also be able to discover the secret character? The parameters are listed and described as the file header. The parameter dir_tamatool is the directory of your tamatool executable file. The parameter tam_speed can take the values “one” or “ten”, both working well. The value “max” is also available but tamacare cannot follow the pace. Beware the file name “save0.bin” must be available in the tamatool/linux folder.

The shell script tamacare.sh calls R procedures that are listed in the R folder:
-	proc_clock.R sets up the time of the virtual device.
-	proc_hatch.R launches the incubation and waits the appropriate time.
-	proc_tamacare.R is the core procedure that cares for the tamagotchi. In a nutshell, this is a loop that regularly observes the screen and takes actions if needed. It can be stopped by 2 events: the closure of the tamatool window (NB: this is not instant and you may experience some xdotool interference for a few seconds/minutes) ; or the death – sorry, I meant the departure for its home planet of your beloved pet.
-	proc_multiple.R is available in the R folder but not called from the tamacare.sh launcher. Basically, once you've gathered a tamagotchi collection in a folder, you can use this procedure to quickly display your zoo. Tamacare is not able to care for more than 1 tamagotchi so you will have to assume this charge.
-	proc_analysis.R transforms the log of the proc_tamacare.R call into a graphical display, that allows studying the events that occurred all along your tamagotchi life. For instance, the first 2 days of your tamagotchi may look like this:

![image](https://user-images.githubusercontent.com/13364928/167933691-f248e14d-dbbb-4736-bbac-49fbe51404a8.png)

We can observe that the baby stage is challenging: the hunger and happiness parameters were never completely full (nor completely empty) at each check. However, after the first evolution, identified by the second time the tamagotchi felt asleep, they never dropped below 3 hearts (apart from an erroneous, nocturne observation). The second instar dropped 4 poops a day and required being disciplined 4 times in total. The tamagotchi became sick twice, once at each stage.

Hopefully, tamacare should assist xenobiologists get more insight into the tamagotchi life cycle and evolutionary pathways, for the well-being of this adorable creature as well as for our great entertainment.

Don’t hesitate support their creator Bandai: official gen-1/gen-2 tamagotchis are often available on the e-market platforms!
