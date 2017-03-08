# audacity-pemf
Audacity Pulsed Electromagnetic Field waveform generator.  This is a waveform generator for pulsing a magnet.


PEMF (Pulsed Electromagnetic Field) was found to help my wife's back pains.  The machine she used was very expensive so I decided to build one.  General idea is to find some good frequencies that drive the magnet at it's optimal rates then pulse that frequency on/off at a low rate.

Parts:
 - Magnetic coil from old CRT PC monitor.
 - Amplifier is an old home stereo.
 - Microphone was used to record magnetic field wave & intensity. i.e. Find a frequency that generates optimal magnetic pulse with the given equipment.
 - The Audacity pemf v1 plugin was built to find the optimal rate (125Hz) and duty cycle(5%) for a high and clean frequency of the my magnet.  Note your magnet/amplifier may have different optimizations.  Found high-end stereos have allot less distortion and can drive a stronger magnetic field.
 - Use Audacity to generate a pulse, and play it back while recording the result on another track in audacity.  This will show you the quality/intensity of the pulse.  I was aiming for High (+)pulse one direction with least amount (-)pulse below the line.
 - Once the magnet frequency is optimized then it is pulsed at low frequencies like 12Hz, 4Hz, 8Hz, 20Hz, 2Hz...
 - Finally generate 3-4 sets of frequencies to make a 30 minute session total. e.g. 10min@12Hz, 10min@4Hz, 10min@8Hz = 30min.
