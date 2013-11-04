(load "lol.lisp")
(load "agenda.lisp")
(load "logic-op.lisp")
(load "schematic.lisp")
(load "addr.lisp")
()

(defun clk-ff-gate-rst (a-input a-clk a-output a-rst a-rst-value &key (edge-op #'rising-edge-p ))
  (let (reg-value ((output a-output)))
    (add-action a-clk
		(lambda (sig) 
		  (when (funcall edge-op a-clk)
		    (setf reg-value (xsignal-value a-input))
		    (after-delay 
		      clk-ff-delay-time
		      (lambda ()
			(set-xsignal output new-value))))))
    (add-action a-rst
		(lambda (sig) 
		  (when (logic= (xsignal-value a-rst) 1)
		    (setf reg-value (xsignal-value a-rst-value))
		    (after-delay 
		      clk-ff-delay-time
		      (lambda ()
			(set-xsignal output new-value))))))))

(defun selector (a-input0 a-input1 a-sel a-output)
  (let ((t0 (make-xsignal))
	(t1 (make-xsignal))
	(not-sel (make-xsignal)))
  (and-gate a-sel a-input0 t0)
  (inverter-gate a-sel not-sel)
  (and-gate not-sel a-input1 t1)
  (or-gae t0 t1 a-output))) 

(setf o0 (make-xsignal))
(setf o1 (make-xsignal))
(setf o2 (make-xsignal))
(setf o3 (make-xsignal))

(setf clk (make-xsignal))
(setf rst (make-xsignal))
(setf en (make-xsignal))

(setf const-0 (make-xsignal :value 0))
(setf const-1 (make-xsignal :value 1))

(setf i0 (make-xsignal))
(setf i1 (make-xsignal))
(setf i2 (make-xsignal))
(setf i3 (make-xsignal))

(clk-ff-gate-rst i0 clk o0 rst const-0)
(clk-ff-gate-rst i1 clk o1 rst const-0)
(clk-ff-gate-rst i2 clk o2 rst const-0)
(clk-ff-gate-rst i3 clk o3 rst const-0)

(setf t1 (make-xsignal))
(inverter-gate o1 t1)

(setf t01 (make-xsignal))
(and-gate o0 t1 t01)

(setf t23 (make-xsignal))
(and-gate o2 o3 t23)

(setf t0123 (make-xsignal))
(and-gate t01 t23 t0123)
