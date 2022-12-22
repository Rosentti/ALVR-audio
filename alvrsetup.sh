#!/bin/bash

pactl list cards | sed -n -e 's/^.*Name: //p' > ~/.alvraudio_disabled
pactl list cards | sed -n -e 's/^.*Active Profile: //p' > ~/.alvraudio_disabled_profiles
# output:analog-stereo+input:analog-stereo
defaultdev=$(pactl get-default-sink)

cat ~/.alvraudio_disabled | while read line
do
    echo "Disabling $line"
    pactl set-card-profile $line off
done

echo "Creating VirtMain"
virtsink=$(pactl load-module module-null-sink sink_name=VirtMain channels=2)

echo "Creating VirtMic (Sink)"
virtmicsink=$(pactl load-module module-null-sink sink_name=VirtMic channels=2)
echo "Creating VirtMic (Remap)"
virtmicremap=$(pactl load-module module-remap-source master=VirtMic.monitor source_name=VirtMic source_properties=device.description=Virtual_microphone)

echo "Setting VirtMain default"
pactl set-default-sink VirtMain

echo "Opening QJackCtl, close when done"
echo "### Make sure patchbay persistence is active with the alvr.xml profile. "
echo "### If you want to use Oculus's own microphone, you'll need to manually unwire it from the VirtMain input so you don't hear yourself. "
echo "After QJackCtl connects, it is safe to open alvr."

qjackctl -a "$(realpath alvr.xml)"

echo "Shutting down ALVRAUDIO"

INDEX=0
cat ~/.alvraudio_disabled | while read line
do
    readarray -t profiles < ~/.alvraudio_disabled_profiles
    echo "Enabling $line with profile ${profiles[$INDEX]}"
    pactl set-card-profile $line ${profiles[$INDEX]}
    ((INDEX++))
done

echo "Restoring default sink $defaultdev"
pactl set-default-sink $defaultdev

echo "Deleting VirtMain $virtsink"
pactl unload-module $virtsink
if [ $? -eq 0 ]; then
    echo "VirtMain deleted."
  else
    echo "Failed to delete VirtMain: $?"
fi

echo "Deleting VirtMic Sink $virtmicsink"
pactl unload-module $virtmicsink
if [ $? -eq 0 ]; then
    echo "VirtMic (Sink) deleted."
  else
    echo "Failed to delete VirtMic (Sink): $?"
fi

echo "Deleting VirtMic Remap $virtmicremap"
pactl unload-module $virtmicremap
if [ $? -eq 0 ]; then
    echo "VirtMic (Remap) deleted."
  else
    echo "Failed to delete VirtMic (Remap): $?"
fi
