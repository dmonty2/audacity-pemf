# audacity-pemf
Audacity Pulsed Electromagnetic Field waveform generator.  This is a waveform generator for pulsing a magnet.


PEMF (Pulsed Electromagnetic Field) was found to help my wife's back pains.  The machine she used was very expensive so I decided to build one.  General idea is to find some good frequencies that drive the magnet at it's optimal rates then pulse that frequency on/off at a low rate.

Frequencies can be found here:


pemf-v1.ny - Is for generating a single freqency.  Used this to test the amp and magnetic coil.  Also created 1 minute frequencies and looped them.

pemf-list.ny - Is for pasting lists of freqencies to create a longer varied PEMF session.
 - Grab a list of frequencies http://www.electroherbalism.com/Bioelectronics/FrequenciesandAnecdotes/CAFL.htm
 - The above list does not include pulse rate - choose the lower frequencies < 50 to pulse the magnet which is running at the higher frequencies.
 - frequency@pluserate:minutes,frequency2@pulserate2:minutes2,... are comma seperated sets.  frequency the magnet runs at, [ optional @pulserate the magnet on off], [ optional :minutes to run ]
 - Default pulse Hz - when @pulserate is not specified.
 - Default time - minutes to run each set when :minutes is not specified.
 - Pulse duty cycle - % of the pulse cycle that will be in the ON state. (49-50% even on/off)
 - Magnet duty cycle - % of the magnet pulse cycle that will be in the ON state ( lower fast bursts are better ).  Faster magnet frequency means shorter duty cycle - may change this in the future to automatically pick an optimal duty cycle for all frequencies.
 - Magnet amplitude - just shy of 100% keeps waveform clean.

Parts:
 - Magnetic coil from old CRT PC monitor.
 - Amplifier is an old home stereo.
 - Microphone was used to record magnetic field wave & intensity. i.e. Find a frequency that generates optimal magnetic pulse with the given equipment.
 - The Audacity pemf v1 plugin was built to find the optimal rate (125Hz) and duty cycle(5%) for a high and clean frequency of the my magnet.  Note your magnet/amplifier may have different optimizations.  Found high-end stereos have allot less distortion and can drive a stronger magnetic field.
 - Use Audacity to generate a pulse, and play it back while recording the result on another track in audacity.  This will show you the quality/intensity of the pulse.  I was aiming for High (+)pulse one direction with least amount (-)pulse below the line.
 - Once the magnet frequency is optimized then it is pulsed at low frequencies like 12Hz, 4Hz, 8Hz, 20Hz, 2Hz...
 - Finally generate 3-4 sets of frequencies to make a 30 minute session total. e.g. 125Hz@12Hz:10min, 125Hz@4Hz:10min, 125Hz@8Hz:10min = 30min.
