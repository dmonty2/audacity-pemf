;nyquist plug-in
;version 4
;type generate
;name "PEMF List"
;preview true
;action "Generating PEMF Pulse ..."
;author "Dean Montgomery"
;copyright "Released under terms of the GNU General Public License version 2"
;control ptable "Pulse Form" choice "Semi-Sawtooth,Square Pulse,Sine Pulse,Growing Sine2" 0
;control magfreqs "frequency@pulse:minutes,... " string "comma seperated list integers" "880@10,787@8:5,727,20@10"
;control default_pulse "Default pulse Hz" int "default @Hz(20)" 20 1 900
;control default_time "Default time" int "default :minutes for each set (10)" 10 1 30
;control pulseduty "Pulse duty cycle" int "% (49)" 49 1 99
;control magduty "Magnet duty cycle" int "% (5)" 5 1 99
;control magamp "Magnet Amplitude" int "% (98)" 98 80 100

;; Big Thanks to Steve Daulton who provides excellent Audacity Nyquist support.


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

;;; bemer frequency - can't sell it, however math is free.
(defun bemer (x)
  (* x x x (power (exp 1.0) (sin (* x 3))) 1))

;;; pemf - args: string containing frequency@pulsefreq:duration - returns sound
(defun pemf (frq)
  (setf frq (subst "" " " frq))
  (setf pos-neg (string-search "-" frq))
  (if pos-neg
      (progn
        (setf frq (subseq frq 1))
        (setf invert -1))
      (setf invert 1)) 
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
  (print "=====")
  (print pos-neg)
  (print invert)
  (print frq)
  (print magfreq)
  (print pulsefreq)
  (print duration)
  (print magduty)
  (print pulseduty)
  (print magamp)
  (setf laststp (/ 44100.0 (float magfreq)))
  (print "laststp:")
  (print laststp)
  (setf x (/ (float magfreq) 44100.0))
  (print "x:")
  (print x)
  ;;(setf x 60)
  ;; note 5 steps before magnet drops on it's own.
  (setf single-pulse-table (list  
    (congen (pwl
      (* 2 x) 0.01
      (* 4 x) 1
      (* 9 x) 1
      (* 16 x) 0.5
      (* 25 x) 0
      1) 0.001 0.001)
    (hz-to-step 1) t))

  (setf square-pulse-table (list  
    (pwl
      (* 1 x) 0
      (* 1 x) 1
      (* 9 x) 1
      (* 9 x) 0
      1)
    (hz-to-step 1) t))

   (setf sine-pulse-table (list
     (pwl
       (* 1 x) (sin (/ 1.0 4.0))
       (* 2 x) (sin (/ 2.0 4.0))
       (* 3 x) (sin (/ 3.0 4.0))
       (* 4 x) (sin (/ 4.0 4.0))
       (* 5 x) (sin (/ 5.0 4.0))
       (* 6 x) (sin (/ 6.0 4.0))
       (* 7 x) 0
       1)
     (hz-to-step 1) t))

;;  (setf bemer2-pulse-table (list
;;    (pwl
;;      (* 1 x) (TODO)

  (setf semi-sawtooth-table (list  
    ;;(pwl 0 magamp magduty magamp magduty 0 1 0 1)
    ;;(congen (pwl (* 0.0001 x) 0.1 (* 0.0002 x) magamp (* 0.00029 x) magamp (* 0.00059 x) 0.1 (* 0.00025 x) 0 1) 0.003 0.003)
    (pwl
      (* 2 x) -0.11868
      (* 3 x) -0.17162
      (* 4 x) -0.20709
      (* 5 x) -0.21406
      (* 6 x) -0.21758
      (* 7 x) -0.22110
      (* 8 x) -0.22019
      (* 9 x) -0.21928
      (* 10 x) -0.21776
      (* 135 x) 0.11749
      (* 136 x) 0.11840
      (* 137 x) 0.11992
      (* 138 x) 0.12028
      (* 139 x) 0.12598
      (* 140 x) 0.14581
      (* 141 x) 0.26356
      (* 142 x) 0.48451
      (* 143 x) 0.72287
      (* 144 x) 0.86797
      (* 145 x) 0.88373
      (* 146 x) 0.81758
      (* 147 x) 0.69073
      (* 148 x) 0.57158
      (* 149 x) 0.45195
      (* 150 x) 0.34839
      (* 151 x) 0.25950
      (* 152 x) 0.18880
      (* 153 x) 0.13495
      (* 154 x) 0.09524
      (* 155 x) 0.06650
      (* 156 x) 0.04321
      (* 160 x) 0.00053
      1)
    (hz-to-step 1) t))
  (setf pulse-table (list  
    (pwl 0 1 pulseduty 1 pulseduty 0 1 0 1)
    (hz-to-step 1) t))
  (setf mag-pulse-table
    (case ptable
      (0 semi-sawtooth-table)
      (1 square-pulse-table)
      (2 single-pulse-table)
      (3 growing-sine2-table)
      (T semi-sawtooth-table))) 
  (seqrep ( i duration ) 
      (mult invert (mult 
        (hzosc magfreq mag-pulse-table)
        (hzosc pulsefreq pulse-table)))))

;;; normalize output
(defun nrmlz (sig)
  (let ((peak (peak sig ny:all)))
    (mult (/ peak) sig)))

;;; main driver
(setf magduty (* magduty 0.01))
(setf pulseduty (* pulseduty 0.01))
(setf magamp (* magamp 0.01))
(setf frqs (str-to-list magfreqs ","))
(seqrep ( x (length frqs) )
  (nrmlz (pemf ( nth x frqs ))))
