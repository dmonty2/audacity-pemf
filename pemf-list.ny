;nyquist plug-in
;version 4
;type generate
;name "PEMF List"
;preview false
;action "Generating PEMF Pulse ..."
;author "Dean Montgomery"
;copyright "Released under terms of the GNU General Public License version 2"
;control magfreqs "frequency@pulse:time,... " string "comma seperated list" "880@10,787@8.5:60,727,20@10"
;control default_pulse "Default pulse Hz" int "default Hz pulse (20)" 20 1 900
;control default_time "Default time" int "default seconds for each freq (60)" 60 1 900
;;control magduty "Magnet duty cycle" int "%" 5 1 99
;;control magamp "Magnet Amplitude" int "%" 100 80 100
;;control pulseduty "Pulse duty cycle" int "%" 48 1 99

(defun str-to-list ( str del )
    (if (setq pos (string-search del str))
        (cons (subseq str 0 pos) (str-to-list (subseq str (+ pos 0 (length del))) del))
        (list str)
    )
)

(defun str-to-int (string)
  (setf n (read (make-string-input-stream (format nil "(~a)" string))))
  (if (and (= 1 (length n)) (integerp (first n)))
    (first n) 0))

(dolist ( frq (str-to-list magfreqs ","))
  (setq frq (subst "" " " frq))
  (setq pos-at (string-search "@" frq)) 
  (setq pos-colon (string-search ":" frq))
  (if (and pos-at pos-colon)
    (progn
      (setf magfreq (str-to-int (subseq frq 0 pos-at)))
      (setf pulsefreq (str-to-int (subseq frq (+ pos-at 1) pos-colon)))
      (setf duration (str-to-int (subseq frq (+ pos-colon 1))))))
  (if (and pos-at (not pos-colon))
    (progn
      (setf magfreq (str-to-int (subseq frq 0 pos-at)))
      (setf pulsefreq (str-to-int (subseq frq (+ pos-at 1))))
      (setf duration default_time)))
  (if (and (not pos-at) pos-colon)
    (progn
      (setf magfreq (str-to-int (subseq frq 0 pos-colon)))
      (setf pulsefreq default_pulse)
      (setf duration (str-to-int (subseq frq (+ pos-colon 1))))))
  (if (and (not pos-at) (not pos-colon))
    (progn
      (setf magfreq frq)
      (setf pulsefreq default_pulse)
      (setf duration default_time)))
  ;;(print magfreq)
  ;;(print pulsefreq)
  ;;(print duration)
  (setf pulsefreq 4)
  (setf magduty (* 5 0.01))
  (setf pulseduty (* 50 0.01))
  (setf magamp (* 90 0.01))
  ;;(setf magduty (* magduty 0.01))
  ;;(setf pulseduty (* pulseduty 0.01))
  ;;(setf magamp (* magamp 0.01))
  (setq *mag-pulse-table* (list  
    (pwl 0 magamp magduty magamp magduty 0 1 0 1)
    (hz-to-step 1) t))
  (setq *pulse-table* (list  
    (pwl 0 1 pulseduty 1 pulseduty 0 1 0 1)
    (hz-to-step 1) t))
  (seqrep ( i duration ) 
    (mult 
      (hzosc magfreq *mag-pulse-table*)
      (hzosc pulsefreq *pulse-table*))))
