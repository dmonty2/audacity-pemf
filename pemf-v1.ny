;nyquist plug-in
;version 4
;type generate
;name "PEMF v1"
;preview false
;action "Generating PEMF Pulse ..."
;author "Dean Montgomery"
;copyright "Released under terms of the GNU General Public License version 2"
;control magfreq "Magnet frequency" int "Hz" 120 1 1000
;control magduty "Magnet duty cycle" int "%" 5 1 99
;control magamp "Magnet Amplitude" int "%" 100 80 100
;control pulsefreq "Pulse frequency" int "Hz e.g. 12,4,8,20,2" 12 1 50
;control pulseduty "Pulse duty cycle" int "%" 48 1 99
;control dur "Duration 5m,8m,10m,20m" int "seconds" 600 1 3000
;;control dur "Duration" int "minutes" 10 1 20

(setf magduty (* magduty 0.01))
(setf pulseduty (* pulseduty 0.01))
(setf magamp (* magamp 0.01))
;;(setf dur (* dur 60))

(setq *mag-pulse-table* (list  
  (pwl 0 magamp magduty magamp magduty 0 1 0 1)
  (hz-to-step 1) t))
(setq *pulse-table* (list  
  (pwl 0 1 pulseduty 1 pulseduty 0 1 0 1)
  (hz-to-step 1) t))

(seqrep ( i dur ) 
  (mult 
    (hzosc magfreq *mag-pulse-table*)
    (hzosc pulsefreq *pulse-table*)))

