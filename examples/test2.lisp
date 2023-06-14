;(load "lol.lisp")
;(load "agenda.lisp")
;(load "logic-op.lisp")
;(load "schematic.lisp")
(require "lambda-schematic")

(defun test-gate (a-input a-output)
  (lambda-schematic:add-action a-input
              (let ((output a-output))
                (lambda (sig) 
                  (let ((new-value (lambda-schematic:xsignal-value sig)))
                    (lambda-schematic:after-delay 
                        5
                        (lambda ()
                          (lambda-schematic:set-xsignal output new-value))))))))

#|
(setf i (lambda-schematic:make-xsignal :value 1))
(setf o (lambda-schematic:make-xsignal))
(test-gate i o)
(lambda-schematic:probe "i" i)
(lambda-schematic:probe "o" o)

(lambda-schematic:propagate 20)
(lambda-schematic:set-xsignal i 0)

(lambda-schematic:propagate 4)
(lambda-schematic:set-xsignal i 1)
(lambda-schematic:propagate 4)

(lambda-schematic:propagate 4)
(lambda-schematic:set-xsignal i 0)
(lambda-schematic:propagate 4)
|#

(setf c (lambda-schematic:make-clock 5))
;(setf c (lambda-schematic:make-xsignal :value 0))
(setf i0 (lambda-schematic:make-xsignal :value 0))
(setf o0 (lambda-schematic:make-xsignal :value 1))
(setf i1 (lambda-schematic:make-xsignal :value 1))
(setf o1 (lambda-schematic:make-xsignal :value 0))
(lambda-schematic:clk-ff-gate i0 c o0)
(lambda-schematic:clk-ff-gate i1 c o1)
#|
(lambda-schematic:probe "i0" i0)
(lambda-schematic:probe "o0" o0)
(lambda-schematic:probe "i1" i1)
(lambda-schematic:probe "o1" o1)
(lambda-schematic:probe "clk" c)
|#

#|
(lambda-schematic:add-action c
  (lambda (sig)
    (let ((now-value (lambda-schematic:xsignal-value sig)))
      (lambda-schematic:after-delay
        5
        (lambda ()
          (lambda-schematic:set-xsignal sig (- 1 now-value)))))))
        |#

(defun vcd-probe (name i-sig)
  (let ((my-name name))
     (lambda-schematic:add-action
       i-sig
       (lambda (sig)
         (format t "#~a~%~a~a~%" (lambda-schematic:get-current-time lambda-schematic:the-agenda) 
                 (lambda-schematic:get-xsignal sig)
             my-name 
                 )))))

(vcd-probe #\1 i0)
(vcd-probe "2" o0)
(vcd-probe "3" i1)
(vcd-probe "4" o1)
(vcd-probe #\; c)

(lambda-schematic:propagate 17)
(lambda-schematic:set-xsignal i0 (lambda-schematic:xsignal-value o1))
(lambda-schematic:set-xsignal i1 (lambda-schematic:xsignal-value o0))
(lambda-schematic:propagate 13)
#|
(lambda-schematic:propagate 5)
(lambda-schematic:set-xsignal c 1)
(lambda-schematic:propagate 5)
(lambda-schematic:set-xsignal c 0)
(lambda-schematic:propagate 5)
(lambda-schematic:set-xsignal c 1)
(lambda-schematic:propagate 2)
(lambda-schematic:set-xsignal i0 (lambda-schematic:xsignal-value o1))
(lambda-schematic:set-xsignal i1 (lambda-schematic:xsignal-value o0))
(lambda-schematic:propagate 3)
(lambda-schematic:set-xsignal c 0)
(lambda-schematic:propagate 5)
(lambda-schematic:set-xsignal c 1)
(lambda-schematic:propagate 5)
(lambda-schematic:set-xsignal c 0)
|#
