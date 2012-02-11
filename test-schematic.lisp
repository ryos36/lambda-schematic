(load "lol.lisp")
(load "agenda.lisp")
(load "logic-op.lisp")
(load "schematic.lisp")
(load "addr.lisp")
(load "ff.lisp")
(load "hazard.lisp")

;------------------------------------------------------------------------
; hazard FF

#|
(setf a (make-xsignal :value 1))
(setf b (make-xsignal :value 1))
(setf c (make-xsignal :value 1))
(setf y0 (make-xsignal))
(probe "y0" y0)
(static-hazard a b c y0)

(setf y1 (make-xsignal))
(probe "y1" y1)
(hazard-free a b c y1)

(propagate 20)
(set-xsignal b 0)

|#
;------------------------------------------------------------------------
; test FF
#|

(setf r (make-xsignal :value 0))
(setf s (make-xsignal :value 0))
(setf q (make-xsignal))
(setf not-q (make-xsignal))
(probe "q" q)
(probe "not-q" not-q)

;(rs-ff r s q not-q)
;(set-xsignal r 1)

(let ((and-gate-delay-time 1)
      (nor-gate-delay-time 1)) 
(setf clk (make-xsignal :value 0))
(rs-clk-ff r s clk q not-q)
(propagate 20)
(set-xsignal clk 1)
(propagate 20)
(set-xsignal clk 0)
(propagate 10)
(set-xsignal s 1)
(propagate 10)
(set-xsignal clk 1)
(propagate 20)
(set-xsignal s 0)
(propagate 10)
(set-xsignal clk 0)
(propagate 20)
(set-xsignal r 1)
(propagate 10)
(set-xsignal clk 1)
(propagate 20)
(propagate 30)
(set-xsignal clk 0)
(propagate 10)
(set-xsignal s 1)
(propagate 10)
(set-xsignal r 0)
(propagate 10)
(set-xsignal clk 1)
(propagate 30)
(set-xsignal clk 0)
)
|#
;------------------------------------------------------------------------
;test latch
(let ((*no-delay-mode* t))

(setf d (make-xsignal :value 0))
(setf st (make-xsignal :value 1))
(setf q (make-xsignal))
(setf not-q (make-xsignal))
(latch d st q not-q)
(probe "latch-q" q)
(probe "latch-not-q" not-q)
(propagate 200)
(set-xsignal d 1)
(propagate 100)
(set-xsignal st 0)
(propagate 100)
(set-xsignal d 0)
(propagate 200)
(set-xsignal d 1)
(propagate 100)
(set-xsignal st 1)
(propagate 100)
(set-xsignal d 0)
(propagate 200)
(set-xsignal d 1)
(propagate 300)
(set-xsignal d 0)
(propagate 100)
(set-xsignal st 0)

)
;------------------------------------------------------------------------
; test addr
#|
(setf a (make-xsignal :value 1))
(setf b (make-xsignal :value 1))
(setf c-in (make-xsignal :value 1))
(setf sum (make-xsignal))
(setf c-out (make-xsignal))
(probe "sum" sum)
(probe "c-out" c-out)
(full-addr a b c-in sum c-out)

(set-xsignal b 0)
(propagate 5)
(set-xsignal b 1)
|#
;------------------------------------------------------------------------
#|
(setf a (make-xsignal))
(probe "input" a)
(setf b (make-xsignal))
(probe "output" b)

(inverter-gate a b)
(defun test () (let ((*direct-call-after-daly* nil))
		 (set-xsignal a 1)))

(setf i0 (make-xsignal))
(setf i1 (make-xsignal))
(setf oo (make-xsignal))

(set-xsignal i0 0)
(set-xsignal i1 0)
(and-gate i1 i0 oo)
(probe "and-gate-output" oo);
;(or-gate i1 i0 oo)
;(probe "or-gate-output" oo);
|#

;------------------------------------------------------------------------
#|
;(probe "i0" i0)
(set-xsignal i0 1)
the-agenda

|#
