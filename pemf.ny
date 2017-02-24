;nyquist plug-in
;version 4
;type generate
;name "PEMF"
;preview false
;action "Generating PEMF Pulse ..."
;author "Dean Montgomery"
;copyright "Released under terms of the GNU General Public License version 2"
;control wavform "Wave Form" choice "Pulse, Sine, Saw" 0
;control magfq "Magnet Frequency" int "Hz" 120 1 1000
;control pulsefq "Pulse Frequency" int "Hz" 12 1 50
;control duration "Duration" int "sec" 600 1 3000
;control key "MIDI key" int "" 60 0 127
;control cents "Cents" int "" 0 0 99
;control modcyc "Mod Rate" int "cycles" 1 1 100
;control modpercent "Mod Depth" int "%" 90 -100 100
;control modshape "Mod Wave" int "0-tri 1-up saw 2-down saw" 0 0 2
;control bias "Width" int "%" 0 0 100
;control amp "Amp" int "%" 100 0 100




(setq *tri*  (list (pwl 0.5 1 1)(hz-to-step 1) t)
      *usaw* (list (pwl 1 1 1)(hz-to-step 1) t)
      *dsaw* (list (pwl 0 1 1)(hz-to-step 1) t))




(setq 
 frq (step-to-hz (+ key (* 0.01 cents)))
 dur (* 0.001 durms)
 modfrq (/ modcyc (float dur))
 modamp (* 0.01 modpercent)
 modtab (cond ((= modshape 0) *tri*)
	      ((= modshape 1) *usaw*)
	      (t *dsaw*))
 width (* 0.01 bias))

(defun pwlosc (frq dur bias modamp modfrq modtab)
  (stretch dur
	   (osc-pulse frq (sum bias 
			       (scale modamp (lfo modfrq 1 modtab))))))


(scale (* 0.01 amp)
       (pwlosc frq dur width modamp modfrq modtab))
