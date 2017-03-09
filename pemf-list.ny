;nyquist plug-in
;version 4
;type generate
;name "PEMF List"
;preview false
;action "Generating PEMF Pulse ..."
;author "Dean Montgomery"
;copyright "Released under terms of the GNU General Public License version 2"
;control magfreqs "frequency@pulse:time" string "comma seperated list" "880@10,787@8.5=60,727,20@10"
;control dwell "Dwell time" int "default time for each freq" 60 1 900
;;control magfreq "Magnet frequency" int "Hz" 125 1 1000
;;control magduty "Magnet duty cycle" int "%" 5 1 99
;;control magamp "Magnet Amplitude" int "%" 100 80 100
;;control pulsefreq "Pulse frequency" int "Hz e.g. 12,4,8,20,2" 12 1 50
;;control pulseduty "Pulse duty cycle" int "%" 48 1 99
;;control duration "Duration 5m,8m,10m,20m" int "seconds" 600 1 3000


(print magfreqs)
;;(print (string-search "," magfreqs))

(defun str-to-list ( str del )
    (if (setq pos (string-search del str))
        (cons (subseq str 0 pos) (str-to-list (subseq str (+ pos 0 (length del))) del))
        (list str)
    )
)
(dolist ( frq (str-to-list magfreqs ","))
  ;;(setq x (string-trim " " x))
  (setq frq (subst "" " " frq))
  (cond (and (> (string-search '@' frq)) (> (string-search ':' frq)))
    (
      (setq pos-at (string-search '@' frq)) 
      (setq pos-colen (string-search ':' frq))
      (setf magfreq (float (subseq frq 0 pos-at)))
      (setf pulsefreq (float (subseq frq pos-at pos-colen)))
      (setf duration (float (subseq pos-colen)))))
  (print frq))

;;(setq magfreqs (replace-all magfreqs " " "_"))
;;(print magfreqs)
;;(loop for magfreq in (my-split #\, magfreqs)
;;  (setf pulsefreq 4)
;;  (setf magduty (* 5 0.01))
;;  (setf pulseduty (* 50 0.01))
;;  (setf magamp (* 90 0.01))

;;  (setq *mag-pulse-table* (list  
;;    (pwl 0 magamp magduty magamp magduty 0 1 0 1)
;;    (hz-to-step 1) t))
;;  (setq *pulse-table* (list  
;;    (pwl 0 1 pulseduty 1 pulseduty 0 1 0 1)
;;    (hz-to-step 1) t))
;;
;;  (seqrep ( i dur ) 
;;    (mult 
;;      (hzosc magfreq *mag-pulse-table*)
;;      (hzosc pulsefreq *pulse-table*))))
 

