(load "lol.lisp")
(load "agenda.lisp")
(load "logic-op.lisp")
(load "schematic.lisp")

(defun test-gate (a-input a-output)
  (add-action a-input
	      (let ((output a-output))
		(lambda (sig) 
		  (let ((new-value (xsignal-value sig)))
		    (after-delay 
			5
			(lambda ()
			  (set-xsignal output new-value))))))))

#|
(setf i (make-xsignal :value 1))
(setf o (make-xsignal))
(test-gate i o)
(probe "i" i)
(probe "o" o)

(propagate 20)
(set-xsignal i 0)

(propagate 4)
(set-xsignal i 1)
(propagate 4)

(propagate 4)
(set-xsignal i 0)
(propagate 4)
|#

(setf c (make-xsignal :value 0))
(setf i0 (make-xsignal :value 0))
(setf o0 (make-xsignal :value 1))
(setf i1 (make-xsignal :value 1))
(setf o1 (make-xsignal :value 0))
(clk-ff-gate i0 c o0)
(clk-ff-gate i1 c o1)
(probe "i0" i0)
(probe "o0" o0)
(probe "i1" i1)
(probe "o1" o1)
(probe "clk" c)

(propagate 5)
(set-xsignal c 1)
(propagate 5)
(set-xsignal c 0)
(propagate 5)
(set-xsignal c 1)
(propagate 2)
(set-xsignal i0 (xsignal-value o1))
(set-xsignal i1 (xsignal-value o0))
(propagate 3)
(set-xsignal c 0)
(propagate 5)
(set-xsignal c 1)
(propagate 5)
(set-xsignal c 0)
