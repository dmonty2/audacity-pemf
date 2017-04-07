# audacity-pemf
Audacity - Pulsed Electromagnetic Field (PEMF) waveform generator.  These plugins help create various wave forms and frequencies in order to drive an electromagnet.
https://en.wikipedia.org/wiki/Pulsed_electromagnetic_field_therapy

Disclaimer:  These plugins are not intended for the diagnosis, treatment or cure of any physical or medical condition. If you are experiencing symptoms of a physical or medical condition, you should seek the advice of your medical professional immediately.  There may be opinions expressed about PEMF, however they should not be interpreted as medical advice.

Use Google Scholar to find peer reviewed double-blind papers what PEMF is used for.  These plugins are for the purpose of finding optimal ways to generate electormagnetic pulses.

I was introduced to a PEMF machine that helped several family ailments.  The machine was very expensive so I decided to build an ammeture one.  General idea is to find several wave forms + frequencies to drive the magnet and at the same time pulse that frequency on/off at a low rate.   I have no post-secondary training in electromagnets or biology.

pemf-v1.ny - Is for generating and testing single freqencies.  Used this to test the amp and magnetic coil.

pemf-list.ny - Is for generating and testing multiple frequencies.   Pasting lists of freqencies to create a longer varied PEMF session.
 - Run the magnet at a higher frequency and pulse the magnet at a low frequency.
 - Wave Form - Bassett,Bemer,Square,Sine.  This is the wave form of a single magnetic pulse that will be repeated at the higher frequency.
 - frequency@pluserate:minutes,frequency2@pulserate2:minutes2,... comma seperated sets.  frequency the magnet runs at, [ optional @pulserate for magnet on/off Hz], [ optional :minutes to run ].  Can also invert the wave with -freq e.g. -120@8.
 - Default pulse Hz - when @pulserate is not specified.   See wiki page for some example pulserates.
 - Default time - minutes to run each set when :minutes is not specified.
 - Pulse duty cycle - % of the low-frequency pulse that's in the ON state. Default is 50%.

pemf-v3.ny - Has less options and is overall easier to operate.
 - magnet pulserate is fixed at 120Hz in a semi sawtooth DC pulse.
 - Pulse Frequency - is the magnet's  on/off cycle.  The list of frequencies are divisible into the base 120Hz of the magnet.  Frequencies have **** ratings in order to try out a few known-to-work frequencies.
 - Duration - best to generate 3-5 different frequencies and combine them to make up a 15-30 minute session.
 

Parts:
 - Deguasser coil from old CRT Monitor/TV.  Make sure you discharge the capacitor before working on the TV.
 - Amplifier - home stereo/receiver.
 - Microphone is used to record magnetic induction field (wave-form & intensity). i.e. Find a frequency that generates optimal magnetic pulse with the given equipment.
 - The Audacity pemf v1 plugin was built to test various frequencies and duty cycle for my amp/magnet.  Note your magnet/amplifier may have different optimizations.  Found high-end stereos have allot less distortion and can drive a stronger magnetic field at all frequencies.  Battery powered amplifiers do not drive the magnet very well.
 - Use Audacity to generate a pulse, and play it back while recording the result on another track in audacity.  This will show you the quality/intensity of the pulse.  I was aiming for High (+)pulse one direction with least amount (-)pulse below the line.  Too much volume or wrong stereo settings will distor the pulse.
 - When recording - make sure Audacity's Preferences=>Recording=>Software Playthrough is unchecked.
 - Once the magnet frequency is optimized then it is pulsed at low frequencies like 12Hz, 4Hz, 8Hz, 20Hz, 2Hz, 1Hz...
 - Finally generate 3-4 sets of frequencies to make a 30 minute session total. e.g. 125Hz@12Hz:10min, 125Hz@4Hz:10min, 125Hz@8Hz:10min = 30min.
 
 
 See wiki for more info https://github.com/dmonty2/audacity-pemf/wiki
 
