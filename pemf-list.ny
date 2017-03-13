;nyquist plug-in
;version 4
;type generate
;name "PEMF List"
;preview true
;action "Generating PEMF Pulse ..."
;author "Dean Montgomery"
;copyright "Released under terms of the GNU General Public License version 2"
;control magfreqs "frequency@pulse:minutes,... " string "comma seperated list integers" "880@10,787@8:5,727,20@10"
;control default_pulse "Default pulse Hz" int "default @Hz(20)" 20 1 900
;control default_time "Default time" int "default :minutes for each set (10)" 10 1 30
;control pulseduty "Pulse duty cycle" int "% (49)" 49 1 99
;control magduty "Magnet duty cycle" int "% (5)" 5 1 99
;control magamp "Magnet Amplitude" int "% (98)" 98 80 100

;;; str-to-list - args: (string delimiter) - returns list
(defun str-to-list ( str del )
    (if (setf pos (string-search del str))
        (cons (subseq str 0 pos) (str-to-list (subseq str (+ pos 0 (length del))) del))
        (list str)
    )
)

;;; str-to-int - args: string - returns integer
(defun str-to-int (str)
  (setf pos-decimal (string-search "." str))
  (if pos-decimal
    (setf str (subseq str 0 pos-decimal))) ;; round floor.
  (setf n (read (make-string-input-stream (format nil "(~a)" str))))
  (if (and (= 1 (length n)) (integerp (first n)))
    (first n) 0))

;;; pemf - args: string containing frequency@pulsefreq:duration - returns sound
(defun pemf (frq)
  (setf frq (subst "" " " frq))
  (setf pos-at (string-search "@" frq)) 
  (setf pos-colon (string-search ":" frq))
  (if (and pos-at pos-colon)
    (progn
      (setf magfreq (str-to-int (subseq frq 0 pos-at)))
      (setf pulsefreq (str-to-int (subseq frq (+ pos-at 1) pos-colon)))
      (setf duration (* 60 (str-to-int (subseq frq (+ pos-colon 1)))))))
  (if (and pos-at (not pos-colon))
    (progn
      (setf magfreq (str-to-int (subseq frq 0 pos-at)))
      (setf pulsefreq (str-to-int (subseq frq (+ pos-at 1))))
      (setf duration (* 60 default_time))))
  (if (and (not pos-at) pos-colon)
    (progn
      (setf magfreq (str-to-int (subseq frq 0 pos-colon)))
      (setf pulsefreq default_pulse)
      (setf duration (* 60 (str-to-int (subseq frq (+ pos-colon 1)))))))
  (if (and (not pos-at) (not pos-colon))
    (progn
      (setf magfreq (str-to-int frq))
      (setf pulsefreq default_pulse)
      (setf duration (* 60 default_time))))
  ;;(print "=====")
  ;;(print frq)
  ;;(print magfreq)
  ;;(print pulsefreq)
  ;;(print duration)
  ;;(print magduty)
  ;;(print pulseduty)
  ;;(print magamp)
  (setf mag-pulse-table (list  
    (pwl 0 magamp magduty magamp magduty 0 1 0 1)
    (hz-to-step 1) t))
  (setf pulse-table (list  
    (pwl 0 1 pulseduty 1 pulseduty 0 1 0 1)
    (hz-to-step 1) t))
  (seqrep ( i duration ) 
      (mult 
        (hzosc magfreq mag-pulse-table)
        (hzosc pulsefreq pulse-table))))

;;; main driver
(setf magduty (* magduty 0.01))
(setf pulseduty (* pulseduty 0.01))
(setf magamp (* magamp 0.01))
(setf frqs (str-to-list magfreqs ","))
(seqrep ( x (length frqs) )
  (pemf ( nth x frqs ) ) )
