#!/bin/bash

pactl list cards | sed -n -e 's/^.*Name: //p' > ~/.alvraudio_disabled
pactl list cards | sed -n -e 's/^.*Active Profile: //p' > ~/.alvraudio_disabled_profiles
# output:analog-stereo+input:analog-stereo
defaultdev=$(pactl get-default-sink)

SND_ALOOP_LOADED=0
if lsmod | grep "snd_aloop" &> /dev/null ; then
  echo "snd_aloop is loaded!"
  SND_ALOOP_LOADED=1
else
  echo "snd_aloop is not loaded. Please allow me to load snd_aloop, and setup the virtual microphone."
  pkexec modprobe snd_aloop
  if [ $? -eq 0 ]; then
    echo "snd_aloop has been loaded. Waiting 2s."
    # wait a bit after snd_aloop loads to give pipewire time to detect it
    sleep 2
    SND_ALOOP_LOADED=1
  else
    echo "Permission denied or modprobe failed while loading snd_aloop. Microphone will not work. ($?)"
    SND_ALOOP_LOADED=0
  fi
fi


cat ~/.alvraudio_disabled | while read line
do
    if [[ "$line" == *"snd_aloop"* ]]; then
        # this doesn't work, why?
        echo "Setting $line (snd_aloop) to stereo duplex."
        pactl set-card-profile $line output:analog-stereo+input:analog-stereo
    else
        echo "Disabling $line"
        pactl set-card-profile $line off
    fi
done

echo "Creating VirtMain"
virtsink=$(pactl load-module module-null-sink sink_name=VirtMain)
echo "Setting VirtMain default"
pactl set-default-sink VirtMain

echo "Opening QJackCtl, close when done"
echo "QJackCtl info: Make sure patchbay persistence is active with the alvr.xml profile. "
echo "After QJackCtl connects, it is safe to open alvr."

qjackctl

echo "Shutting down ALVRAUDIO"

INDEX=0
cat ~/.alvraudio_disabled | while read line
do
    if [[ "$line" == *"snd_aloop"* ]]; then
        echo "Skipping restore $line (reason: snd_aloop)"
        pactl set-card-profile $line off
    else
        readarray -t profiles < ~/.alvraudio_disabled_profiles
        echo "Enabling $line with profile ${profiles[$INDEX]}"
        pactl set-card-profile $line ${profiles[$INDEX]}
    fi
    ((INDEX++))
done

echo "Restoring default sink $defaultdev"
pactl set-default-sink $defaultdev

echo "Deleting VirtMain $virtsink"
pactl unload-module $virtsink
if [ $? -eq 0 ]; then
    echo "VirtMain deleted."
  else
    echo "Failed to delete VirtMain ($?)"
fi

# don't unload snd_aloop if it isn't loaded
if [[ $SND_ALOOP_LOADED -eq 0 ]]; then
    echo "snd_aloop not loaded, not unloading"
  else
    echo "Unloading snd_aloop"
    # really probably shouldn't force remove, but alsa modules depend on this after loading,
    # and I can't figure out how to unload it from the other modules
    pkexec rmmod -f snd_aloop
    if [ $? -eq 0 ]; then
        echo "snd_aloop has been unloaded."
      else
        echo "Permission denied or rmmod failed while unloading snd_aloop. ($?)"
        echo "To remove snd_aloop, run sudo rmmod -f snd_aloop"
    fi
fi
