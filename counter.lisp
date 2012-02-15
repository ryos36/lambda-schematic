(load "lol.lisp")
(load "agenda.lisp")
(load "logic-op.lisp")
(load "schematic.lisp")
(load "addr.lisp")

(defun clk-ff-gate-rst (a-input a-clk a-output a-rst a-rst-value &key (edge-op #'rising-edge-p ))
  (let (reg-value (output a-output))
    (add-action a-clk
		(lambda (sig) 
		  (when (funcall edge-op a-clk)
		    (setf reg-value (xsignal-value a-input))
		    (after-delay 
		      clk-ff-delay-time
		      (lambda ()
			(set-xsignal output reg-value))))))
    (add-action a-rst
		(lambda (sig) 
		  (when (logic= (xsignal-value a-rst) 1)
		    (setf reg-value (xsignal-value a-rst-value))
		    (after-delay 
		      clk-ff-delay-time
		      (lambda ()
			(set-xsignal output reg-value))))))))

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

(setf const-0 (make-xsignal :value 0))
(setf const-1 (make-xsignal :value 1))

(setf t1 (make-xsignal))
(setf t2 (make-xsignal))

(setf t3 (make-xsignal))
(setf t4 (make-xsignal))
(setf t5 (make-xsignal))
(setf t6 (make-xsignal))
(setf t7 (make-xsignal))

(setf not-t2 (make-xsignal))
(setf not-o2 (make-xsignal))
(setf not-t4 (make-xsignal))
(setf not-t5 (make-xsignal))
(setf not-t6 (make-xsignal))
(setf not-o0 (make-xsignal))

(inverter-gate o0 not-o0)
(clk-ff-gate-rst not-o0 clk o0 rst const-0)

(xor-gate o0 o1 t1)
(clk-ff-gate-rst t1 clk o1 rst const-0)

(and-gate o0 o1 t2)
(inverter-gate t2 not-t2)
(and-gate not-t2 not-o2 t3)
(or-gate not-t2 not-o2 t4)
(inverter-gate t4 not-t4)
(or-gate t3 not-t4 t5)
(inverter-gate t5 not-t5)

(clk-ff-gate-rst not-t5 clk o2 rst const-0)
(inverter-gate o2 not-o2)

(or-gate not-t2 not-o2 t6)
(inverter-gate t6 not-t6)
(xor-gate o3 not-t6 t7)

(clk-ff-gate-rst t7 clk o3 rst const-0)

(probe "clk" clk)
(probe "rst" clk)
(probe "o0" o0)
(probe "o1" o1)
(probe "o2" o2)
(probe "o3" o3)

(set-xsignal rst 1)
(propagate 20)
(set-xsignal rst 0)
(set-xsignal clk 0)

(propagate 20)
(set-xsignal clk 1)

(propagate 20)
(set-xsignal clk 0)

(propagate 20)
(set-xsignal clk 1)

(propagate 20)
(set-xsignal clk 0)

(propagate 20)
(set-xsignal clk 1)

(propagate 20)
(set-xsignal clk 0)

(propagate 20)
(set-xsignal clk 1)

(propagate 20)
(set-xsignal clk 0)

