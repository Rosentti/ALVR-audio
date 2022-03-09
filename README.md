# ALVR Audio Script
Script for ALVR that helps with getting audio to play on Linux.
Note: Microphone might work out of the box, but might require some tweaking.
In the future this script may not be necessary if ALVR gets pipewire or pulseaudio support.

## Requirements
- pipewire
- pipewire-jack
- pipewire-pulse
- qjackctl

## Usage
Before starting ALVR, run this script and make sure QJackCtl has started and connected. 

## First time usage
Start this script. Once QJackCtl starts, go to "Setup -> Options -> Patchbay Persistance" and set the file to alvr.xml (which comes with this repo), then apply your changes. Close QJackCtl and restart this script.
Then, open ALVR, go to Audio, set the playback device to "jack".

## Microphone (experimental and possibly very broken)
If you want to try the microphone, set the first device to "surround21:CARD=Loopback,DEV=0", and the second device to "surround21:CARD=Loopback,DEV=1". 

Afterwards, you might need to configure pulseaudio to make the loopback device Surround 2.1 Input + Surround 2.1 Output. (Some games probably don't like surround microphones, needs a better solution)

If you find a cleaner solution to the microphone issue, please open an issue or maybe even a pull request.

