(load "lol.lisp")
(load "agenda.lisp")
(load "logic-op.lisp")
(load "schematic.lisp")
(load "addr.lisp")
(defun l () (load "meta-schematic.lisp"))

(defparameter *schematic-table* (make-hash-table))
(defparameter *func-table* (make-hash-table))

(defun make-xsignal-if-not-exist (sig-name)
  (if (not (gethash sig-name *schematic-table*))
    (setf (gethash sig-name *schematic-table*) (make-xsignal))))

(setf (gethash :not *func-table*) #'inverter-gate)
(setf (gethash :and *func-table*) #'and-gate)
(setf (gethash :or *func-table*) #'or-gate)
(setf (gethash :nand *func-table*) #'nand-gate)
(setf (gethash :nor *func-table*) #'nor-gate)

(defun make-i2o1 (i0-i1-o0)
  (let ((op (gethash (car i0-i1-o0) *func-table*))
	(i0 (make-xsignal-if-not-exist (cadr i0-i1-o0)))
	(i1 (make-xsignal-if-not-exist (caddr i0-i1-o0)))
	(o0 (make-xsignal-if-not-exist (cadddr i0-i1-o0))))
    (format t "~a~a~%" (list i0 i1 o0) op)
(set-xsignal i0 0)
(set-xsignal i1 0)
    (probe "o0" o0)
    (apply op (list i0 i1 o0))))

;(make-i2o1 '(:and i0 i1 o0))

;(propagate 20)

;(defun clk-ff-gate (a-input a-clk a-output &key (edge-op #'rising-edge-p ))

(setf i0 (make-xsignal))
(setf clk0 (make-xsignal))
(setf o0 (make-xsignal))
(set-xsignal i0 0)
(set-xsignal clk0 0)
(probe "o0" o0)

(clk-ff-gate i0 clk0 o0)

(setf i1 (make-xsignal))
(setf clk1 (make-xsignal))
(setf o1 (make-xsignal))
(set-xsignal i1 0)
(set-xsignal clk1 0)
(probe "o1" o1)

(clk-ff-gate i1 clk1 o1)

(propagate 10)
(set-xsignal clk0 1)
(set-xsignal clk0 0)
(set-xsignal i0 1)
(set-xsignal clk0 1)
(set-xsignal clk1 1)
(propagate 10)
(propagate 10)
