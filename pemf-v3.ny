;nyquist plug-in
;version 4
;type generate
;name "PEMF v3"
;preview true
;action "Generating PEMF Pulse ..."
;author "Dean Montgomery"
;copyright "Released under terms of the GNU General Public License version 2"
;control pulsefreq "Pulse frequency Hz (*rating)" choice "1.000 ****,1.008,1.017,1.026,1.034,1.043,1.053,1.062,1.071,1.081,1.091,1.101 *,1.111,1.121,1.132,1.143,1.154,1.165,1.176,1.188,1.200 ***,1.212,1.224,1.237,1.250,1.263,1.277,1.290,1.304,1.319,1.333,1.348,1.364,1.379,1.395,1.412,1.429,1.446,1.463,1.481,1.500 *,1.519,1.538,1.558,1.579,1.600,1.622,1.644,1.667,1.690,1.714,1.739,1.765,1.791,1.818,1.846,1.875,1.905,1.935,1.967,2.000 ***,2.034,2.069,2.105,2.143,2.182,2.222,2.264,2.308,2.353,2.400,2.449,2.500 *,2.553,2.609,2.667,2.727,2.791,2.857,2.927,3.000 ***,3.077,3.158,3.243,3.333,3.429,3.529 *,3.636,3.750,3.871 *,4.000 ****,4.138,4.286,4.444,4.615,4.800 *,5.000 **,5.217,5.455 *,5.714 *,6.000 **,6.316 *,6.667,7.059 *,7.500 *,8.000 ****,8.571,9.231 *,10.000 ****,10.909,12.000 ****,13.333 *,15.000 **,17.143,20.000 ****,24.000,30.000 **,40.000 *,60.000 **" 12
;control dur "Duration" int "minutes (1)" 1 1 20

(setf pulsefreq (nth pulsefreq (list 1 1.0084033613 1.0169491525 1.0256410256 1.0344827586 1.0434782609 1.0526315789 1.0619469027 1.0714285714 1.0810810811 1.0909090909 1.1009174312 1.1111111111 1.1214953271 1.1320754717 1.1428571429 1.1538461538 1.1650485437 1.1764705882 1.1881188119 1.2 1.2121212121 1.2244897959 1.2371134021 1.25 1.2631578947 1.2765957447 1.2903225806 1.3043478261 1.3186813187 1.3333333333 1.3483146067 1.3636363636 1.3793103448 1.3953488372 1.4117647059 1.4285714286 1.4457831325 1.4634146341 1.4814814815 1.5 1.5189873418 1.5384615385 1.5584415584 1.5789473684 1.6 1.6216216216 1.6438356164 1.6666666667 1.6901408451 1.7142857143 1.7391304348 1.7647058824 1.7910447761 1.8181818182 1.8461538462 1.875 1.9047619048 1.935483871 1.9672131148 2 2.0338983051 2.0689655172 2.1052631579 2.1428571429 2.1818181818 2.2222222222 2.2641509434 2.3076923077 2.3529411765 2.4 2.4489795918 2.5 2.5531914894 2.6086956522 2.6666666667 2.7272727273 2.7906976744 2.8571428571 2.9268292683 3 3.0769230769 3.1578947368 3.2432432432 3.3333333333 3.4285714286 3.5294117647 3.6363636364 3.75 3.8709677419 4 4.1379310345 4.2857142857 4.4444444444 4.6153846154 4.8 5 5.2173913043 5.4545454545 5.7142857143 6 6.3157894737 6.6666666667 7.0588235294 7.5 8 8.5714285714 9.2307692308 10 10.9090909091 12 13.3333333333 15 17.1428571429 20 24 30 40 60)))
(setf magfreq 120.0)
(print pulsefreq)
(setf dur (* dur 60))
;;(setf pulseduty (* pulseduty 0.01))
(setf pulseduty 0.5)
(setf x (/ magfreq 44100)) ;; = 0.00272108844
(setq *mag-pulse-table* (list  
  (pwl 
       (* 1 x) -0.01876
       (* 2 x) -0.11868
       (* 3 x) -0.17162
       (* 4 x) -0.20709
       (* 5 x) -0.21406
       (* 6 x) -0.21758
       (* 7 x) -0.22110
       (* 8 x) -0.22019
       (* 9 x) -0.21928
       (* 10 x) -0.21776
       (* 11 x) -0.21491
       (* 12 x) -0.21279
       (* 13 x) -0.21133
       (* 14 x) -0.20836
       (* 15 x) -0.20472
       (* 16 x) -0.20230
       (* 17 x) -0.19805
       (* 59 x) 0.0
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
       (* 157 x) 0.02472
       (* 158 x) 0.01095
       (* 159 x) 0.00247
       (* 160 x) 0.00053
       (* 170 x) 0.00053
       (* 171 x) 0.0
       (* 241 x) -0.02797
       (* 367.5 x))
  (hz-to-step 1) t))
(setq *pulse-table* (list  
  (pwl 0 1 pulseduty 1 pulseduty 0 1)
  (hz-to-step 1) t))

(seqrep ( i dur ) 
  (mult 
    (hzosc magfreq *mag-pulse-table*)
    (hzosc pulsefreq *pulse-table*)))

