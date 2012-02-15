;(load "packages.lisp")

;(in-package :lambda-schematic)
;(load "lol.lisp")
;(load "agenda.lisp")
;(load "logic-op.lisp")

(defstruct xsignal value actions)

(defun set-xsignal (sig set-v)
  (let ((sig-v (xsignal-value sig)))
    (if (logic= sig-v set-v)
      'done
      (prog1
	(setf (xsignal-value sig) set-v)
	(mapc (lambda (act)
		  (funcall act sig))
	      (xsignal-actions sig))))))

(defun get-xsignal (sig)
  (xsignal-value sig))

(defun add-action (sig act)
  (funcall act sig)
  (setf (xsignal-actions sig) (cons act (xsignal-actions sig))))

(defvar inverter-delay-time 2)
(defvar and-gate-delay-time 3)
(defvar nand-gate-delay-time 4)
(defvar or-gate-delay-time 5)
(defvar nor-gate-delay-time 6)
(defvar xor-gate-delay-time 7)

(defun inverter-gate (a-input a-output)
  (add-action a-input
	      (let ((output a-output))
		(lambda (sig) 
		  (let ((new-value (xsignal-value sig)))
		    (after-delay 
		      inverter-delay-time
		      (lambda ()
			(set-xsignal output (logic-not new-value)))))))))

(defmacro! in2-out1-gate (a-input0 a-input1 a-output delay-time logic-func)
  `(let ((g!input0 ,a-input0)
	 (g!input1 ,a-input1)
	 (g!output ,a-output))
     (flet ((gate-inner-func (g!sig)
			     (let ((g!v0 (get-xsignal g!input0))
				   (g!v1 (get-xsignal g!input1)))
			       (after-delay ,delay-time
					    (lambda ()
					      (set-xsignal g!output (,logic-func g!v0 g!v1)))))))
       (add-action g!input0 #'gate-inner-func)
       (add-action g!input1 #'gate-inner-func))))

(defun and-gate (a-input0 a-input1 a-output)
  (in2-out1-gate a-input0 a-input1 a-output and-gate-delay-time logic-and))

(defun nand-gate (a-input0 a-input1 a-output)
  (in2-out1-gate a-input0 a-input1 a-output nand-gate-delay-time logic-nand))

(defun or-gate (a-input0 a-input1 a-output)
  (in2-out1-gate a-input0 a-input1 a-output or-gate-delay-time logic-or))

(defun nor-gate (a-input0 a-input1 a-output)
  (in2-out1-gate a-input0 a-input1 a-output nor-gate-delay-time logic-nor))

(defun xor-gate (a-input0 a-input1 a-output)
  (in2-out1-gate a-input0 a-input1 a-output xor-gate-delay-time logic-xor))


(defun probe (name i-sig)
  (let ((my-name name))
     (add-action 
       i-sig 
       (lambda (sig)
	 (format t "~a: ~a ==> ~a ~%" (get-current-time the-agenda) my-name 
		 (get-xsignal sig))))))

;

(defmacro! in3-out1-gate (a-input0 a-input1 a-input2 a-output delay-time logic-func)
  `(let ((g!input0 ,a-input0)
	 (g!input1 ,a-input1)
	 (g!input2 ,a-input2)
	 (g!output ,a-output))
     (flet ((gate-inner-func (g!sig)
			     (let ((g!v0 (get-xsignal g!input0))
				   (g!v1 (get-xsignal g!input1))
				   (g!v2 (get-xsignal g!input2)))
			       (after-delay ,delay-time
					    (lambda ()
					      (set-xsignal g!output (,logic-func g!v0 g!v1 g!v2)))))))
       (add-action g!input0 #'gate-inner-func)
       (add-action g!input1 #'gate-inner-func)
       (add-action g!input2 #'gate-inner-func))))

(defun logic-or3 (v0 v1 v2)
  (cond 
    ((and (numberp v0) (= v0 1)) 1)
    ((and (numberp v1) (= v1 1)) 1)
    ((and (numberp v2) (= v2 1)) 1)
    ((not (and (numberp v0) (numberp v1))) nil)
    ((and (= 0 v0) (= 0 v1) (= 0 v2)) 0)
    (t nil)))

(defun or3-gate (a-input0 a-input1 a-input2 a-output)
  (in3-out1-gate a-input0 a-input1 a-input2 a-output or-gate-delay-time logic-or3))

(defvar clk-ff-delay-time 0)

(defun rising-edge-p (a-clk)
  (logic= (xsignal-value a-clk) 1))

(defun clk-ff-gate (a-input a-clk a-output &key (edge-op #'rising-edge-p ))
  (add-action a-clk
	      (let ((output a-output))
		(lambda (sig) 
		  (if (funcall edge-op a-clk)
		    (let ((new-value (xsignal-value a-input)))
		      (after-delay 
			clk-ff-delay-time
			(lambda ()
			  (set-xsignal output new-value)))))))))
