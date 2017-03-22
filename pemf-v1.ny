;nyquist plug-in
;version 4
;type generate
;name "PEMF v1"
;preview true
;action "Generating PEMF Pulse ..."
;author "Dean Montgomery"
;copyright "Released under terms of the GNU General Public License version 2"
;control magfreq "Magnet frequency" int "Hz (120)" 120 1 275 
;;control magduty "Magnet duty cycle" int "% (5)" 5 1 99
;;control magamp "Magnet Amplitude" int "% (98)" 98 80 100
;control pulsefreq "Pulse frequency" int "Hz 1-10,(12),15,20,30,60" 12 1 60
;control pulseduty "Pulse duty cycle" int "% (50)" 50 1 99
;;control dur "Duration 5m,8m,10m,20m" int "seconds (60) = 1min" 60 1 3000
;control dur "Duration" int "minutes (10)" 10 1 20

;;(print (type-of magduty))
;;(setf magduty (* magduty 0.01))
;;(print (type-of magduty))
(setf pulseduty (* pulseduty 0.01))
;;(setf magamp (* magamp 0.01))
(setf dur (* dur 60))
(setf x (/ (float magfreq) 44100.0))
(setq *mag-pulse-table* (list  
;;  (congen (pwl (* 0.0001133787 x) -0.21 
;;               (* 0.0031746032 x) 0.13 
;;               (* 0.0032653061 x) 0.99 
;;               (* 0.0032879819 x) 0.95 
;;               (* 0.003446712 x) 0.018 
;;               (* 0.0036281179 x) 0.00 
;;               (* 0.0037 x) 0 1.00 
;;          ) 0.001 0.001)
  (pwl 
       (* 1 x) 0.01876
       (* 2 x) 0.11868
       (* 3 x) 0.17162
       (* 4 x) 0.20709
       (* 5 x) 0.21406
       (* 6 x) 0.21758
       (* 7 x) 0.22110
       (* 8 x) 0.22019
       (* 9 x) 0.21928
       (* 10 x) 0.21776
       (* 11 x) 0.21491
       (* 12 x) 0.21279
       (* 13 x) 0.21133
       (* 14 x) 0.20836
       (* 15 x) 0.20472
       (* 16 x) 0.20230
       (* 17 x) 0.19805
       (* 59 x) 0
       (* 135 x) -0.11749
       (* 136 x) -0.11840
       (* 137 x) -0.11992
       (* 138 x) -0.12028
       (* 139 x) -0.12598
       (* 140 x) -0.14581
       (* 141 x) -0.26356
       (* 142 x) -0.48451
       (* 143 x) -0.72287
       (* 144 x) -0.86797
       (* 145 x) -0.88373
       (* 146 x) -0.81758
       (* 147 x) -0.69073
       (* 148 x) -0.57158
       (* 149 x) -0.45195
       (* 150 x) -0.34839
       (* 151 x) -0.25950
       (* 152 x) -0.18880
       (* 153 x) -0.13495
       (* 154 x) -0.09524
       (* 155 x) -0.06650
       (* 156 x) -0.04321
       (* 157 x) -0.02472
       (* 158 x) -0.01095
       (* 159 x) 0
;;       (* 159 x) -0.00247
;;       (* 160 x) -0.00053
;;       (* 170 x) -0.00053
;;       (* 171 x) 0
       1)
  (hz-to-step 1) t))
(setq *pulse-table* (list  
  (pwl 0 1 pulseduty 1 pulseduty 0 1)
  (hz-to-step 1) t))

;;; normalize output
(defun nrmlz (sig)
  (let ((peak (peak sig ny:all)))
    (mult (/ peak) sig)))

;;; main driver
(nrmlz (seqrep ( i dur ) 
  (mult 
    (hzosc magfreq *mag-pulse-table*)
    (hzosc pulsefreq *pulse-table*))))

;;(setf dur 0.1)
;;(abs-env 
;;  (mult 0.5
;;    (sum 1 (osc (hz-to-step (/ dur)) dur *sine-table*  -90))))

;;(defun pulse (y n)
;;"n is the number of samples returned"
;;  (setf y (float y))
;;  (setf arpulse (make-array n))
;;  (let* ((ln (1- (length arpulse))) ;arrays are zero indexed
;;         (step (/ 2.0 ln))
;;         (offset (/ y))
;;         (norm (/ (- 1 offset))))
;;    (do ((x -1.0 (+ x step))
;;         (index 0 (1+ index)))
;;        ((> index ln)(snd-from-array 0 44100 arpulse))
;;      (setf val (power y (- (* x x))))
;;      (setf (aref arpulse index) (* norm (- val offset))))))

;;(pulse 1000 200)
