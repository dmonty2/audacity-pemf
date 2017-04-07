;nyquist plug-in
;version 4
;type generate
;name "PEMF List"
;preview true
;action "Generating PEMF Pulse ..."
;author "Dean Montgomery"
;copyright "Released under terms of the GNU General Public License version 2"
;control waveform "Wave Form" choice "Bassett 1,Bassett 2 DC offset +induction,Bemer 1,Bemer 2 DC offset +induction,Square,Sine" 0
;control magfreqs "frequency@pulse:minutes,... " string "comma seperated list integers" "880@10,787@8:5,727,20@10"
;control default_pulse "Default pulse Hz" int "default @Hz(20)" 20 1 900
;control default_time "Default time" int "default :minutes for each set (10)" 10 1 30
;control pulseduty "Pulse duty cycle" int "% (50)" 50 1 99
;;control magduty "Magnet duty cycle" int "% (5)" 5 1 99
;;control magamp "Magnet Amplitude" int "% (98)" 98 80 100

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

;;; Bassett wave-form pulse table
(defun bassett-1-table (xstep)
  (list  
    (pwl
      (* 2 xstep) -0.11868
      (* 3 xstep) -0.17162
      (* 4 xstep) -0.20709
      (* 5 xstep) -0.21406
      (* 6 xstep) -0.21758
      (* 7 xstep) -0.22110
      (* 8 xstep) -0.22019
      (* 9 xstep) -0.21928
      (* 10 xstep) -0.21776
      (* 135 xstep) 0.11749
      (* 136 xstep) 0.11840
      (* 137 xstep) 0.11992
      (* 138 xstep) 0.12028
      (* 139 xstep) 0.12598
      (* 140 xstep) 0.14581
      (* 141 xstep) 0.26356
      (* 142 xstep) 0.48451
      (* 143 xstep) 0.72287
      (* 144 xstep) 0.86797
      (* 145 xstep) 0.88373
      (* 146 xstep) 0.81758
      (* 147 xstep) 0.69073
      (* 148 xstep) 0.57158
      (* 149 xstep) 0.45195
      (* 150 xstep) 0.34839
      (* 151 xstep) 0.25950
      (* 152 xstep) 0.18880
      (* 153 xstep) 0.13495
      (* 154 xstep) 0.09524
      (* 155 xstep) 0.06650
      (* 156 xstep) 0.04321
      (* 160 xstep) 0.00053
      1)
    (hz-to-step 1) t))

;;; bassett-2-table - slowly dc offset into negative as to not activate magnet then full swing positive
(defun bassett-2-table (xstep)
  (list 
    (pwl
      (* 2 xstep) -0.11868
      (* 3 xstep) -0.17162
      (* 4 xstep) -0.20709
      (* 5 xstep) -0.21406
      (* 138 xstep) -0.88373
      (* 139 xstep) -0.86797
      (* 140 xstep) -0.72287
      (* 143 xstep) 0.72287
      (* 144 xstep) 0.86797
      (* 145 xstep) 0.88373
      (* 146 xstep) 0.81758
      (* 147 xstep) 0.69073
      (* 148 xstep) 0.57158
      (* 149 xstep) 0.45195
      (* 150 xstep) 0.34839
      (* 151 xstep) 0.25950
      (* 152 xstep) 0.18880
      (* 153 xstep) 0.13495
      (* 154 xstep) 0.09524
      (* 155 xstep) 0.06650
      (* 156 xstep) 0.04321
      (* 160 xstep) 0.00053
      1)
    (hz-to-step 1) t))


;;; bemer formula caculate y as f(x) - can't sell it, however, math is free.
(defun bemer (x)
  (* x x x (power (exp 1.0) (sin (* x 3))) 1))

;;; bemer-table - duration of pulse, xmin start x axis, xmax end x axis, xstep
(defun bemer-table ( dur xmin xmax xstep )
  (setf num (truncate (* dur (float *sound-srate*))))
  (setf mlist '())
  (setf range (- xmax xmin))
  (setf sstep (/ range (1- num)))
  (setf ymax 0.0)
  (setf bemer-y 0.0)
  (dotimes (i num)
    (setf y (+ xmin (* i sstep)))
    (setf fi (* (float i) xstep))
    (push fi mlist)
    (setf bemer-y (bemer y))
    (push bemer-y mlist)
    (if (> bemer-y ymax) (setf ymax bemer-y)))
  (push (* (float (+ num 3)) xstep) mlist)
  (push (/ bemer-y 2) mlist)
  (push (* (float (+ num 6)) xstep) mlist)
  (push (/ (/ bemer-y 2) 2) mlist)
  (push (* (float (+ num 9)) xstep) mlist)
  (push 0.0 mlist)
  ;; normalize the y axis
  (dotimes (i (length mlist))
    (if (evenp i)
      (if (not (eq (nth i mlist) 0))
        (setf (nth i mlist) (* (/ 1.0 ymax) (nth i mlist))))))
  (push 1  mlist)
  (setf mlist (reverse mlist))
  (list
    (pwl-list mlist)
    (hz-to-step 1) t))

;;; bemer-table2 with -dc offset: duration of pulse, xmin start x axis, xmax end x axis, xstep
(defun bemer-table2 ( dur xmin xmax xstep )
  (setf num (truncate (* dur (float *sound-srate*))))
  (setf mlist '())
  (setf range (- xmax xmin))
  (setf sstep (/ range (1- num)))
  (setf ymax 0.0)
  (setf bemer-y 0.0)
  (setf x-start 130) ;; add x offset  slows transition to dc-offset reduces negative induction on magnet.
  (push (* (float x-start) xstep) mlist)
  (push 0.0 mlist)
  (dotimes (i num)
    (setf y (+ xmin (* i sstep)))
    (setf fi (* (float (+ i x-start)) xstep))
    (push fi mlist)
    (setf bemer-y (bemer y))
    (push bemer-y mlist)
    (if (> bemer-y ymax) (setf ymax bemer-y)))
  ;; normalize the y axis
  (dotimes (i (length mlist))
    (if (evenp i)
      (if (not (eq (nth i mlist) 0))
        (setf (nth i mlist) (* (/ 1.0 ymax) (nth i mlist))))))
  ;; dc offset y axis into the negative
  (dotimes (i (length mlist))
    (if (evenp i)
      (if (not (eq (nth i mlist) 0))
        (setf (nth i mlist) (- (* (nth i mlist) 1.98) 0.98)))))
  (push 1 mlist)
  (push -0.0 mlist)
  (setf mlist (reverse mlist))
  (list
    (pwl-list mlist)
    (hz-to-step 1) t))


;;; single-pulse-table 
(defun single-pulse-table (xstep)
  (list  
    (congen (pwl
      (* 2 xstep) 0.01
      (* 4 xstep) 1
      (* 9 xstep) 1
      (* 16 xstep) 0.5
      (* 25 xstep) 0
      1) 0.001 0.001)
    (hz-to-step 1) t))

;;; square-pulse-table returns an abrupt square pulse - for high freq.
(defun square-pulse-table (xstep)
  (list  
    (pwl
      (* 1 xstep) 0
      (* 1 xstep) 1
      (* 9 xstep) 1
      (* 9 xstep) 0
      1)
    (hz-to-step 1) t))


;;; sine-pulse-table - unused
(defun sine-pulse-table (xstep)
  (list
    (pwl
      (* 1 xstep) (sin (/ 1.0 4.0))
      (* 2 xstep) (sin (/ 2.0 4.0))
      (* 3 xstep) (sin (/ 3.0 4.0))
      (* 4 xstep) (sin (/ 4.0 4.0))
      (* 5 xstep) (sin (/ 5.0 4.0))
      (* 6 xstep) (sin (/ 6.0 4.0))
      (* 7 xstep) 0
      1)
    (hz-to-step 1) t))

;;; pulse-duty-table for pulsing magnet on/off
(defun pulse-duty-table ()
  (list  
    (pwl 0 1 pulseduty 1 pulseduty 0 1 0 1)
    (hz-to-step 1) t))



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

  (setf laststp (/ 44100.0 (float magfreq)))
  (setf xstep (/ (float magfreq) (float *sound-srate*)))

  ;; Table for pulsing magnet on/off
  (setf pulse-table (list  
    (pwl 0 1 pulseduty 1 pulseduty 0 1 0 1)
    (hz-to-step 1) t))

  ;; Combine magnet driver with pulse.
  (setf mag-freq-table
    (case waveform
      (0 (bassett-1-table xstep))
      (1 (bassett-2-table xstep))
      (2 (bemer-table 0.0025 4.0 13.8 xstep))
      (3 (bemer-table2 0.0025 4.0 13.1 xstep))
      (4 (square-pulse-table xstep))
      (5 (single-pulse-table xstep))
      (T (bassett-1-table xstep)))) 
  (seqrep ( i duration ) 
      (mult invert (mult 
        (hzosc magfreq mag-freq-table)
        (hzosc pulsefreq pulse-table)))))

;;; normalize output
(defun nrmlz (sig)
  (let ((peak (peak sig ny:all)))
    (mult (/ peak) sig)))

;;; main driver
(setf pulseduty (* pulseduty 0.01))
(setf frqs (str-to-list magfreqs ","))
(seqrep ( z (length frqs) )
  (nrmlz (pemf ( nth z frqs ))))
