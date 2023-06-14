(load "lol.lisp")
(load "agenda.lisp")
(load "logic-op.lisp")
(load "schematic.lisp")
(load "vcd.lisp")

(setf vcd0 (make-vcd))

(setf clk (make-xsignal :value 0))
(setf i0 (make-xsignal :value 0))
(setf o0 (make-xsignal :value 1))
(setf i1 (make-xsignal :value 1))
(setf o1 (make-xsignal :value 0))
(clk-ff-gate i0 clk o0)
(clk-ff-gate i1 clk o1)
(add-action clk
  (lambda (sig)
    (let ((now-value (xsignal-value sig)))
      (after-delay
        5
        (lambda ()
          (set-xsignal sig (- 1 now-value)))))))

; 本当は make-xsignal の type に type と size が入っていて
; そこを参照するようにしたい
; そうなれば (vcd-add-vars vcd0 clk) だけでいい

(vcd-add-vars vcd0 clk "reg" 1 nil "clk")
(vcd-add-vars vcd0 i0 "reg" 1 nil "i0")
(vcd-add-vars vcd0 o0 "reg" 1 nil "o0")
(vcd-add-vars vcd0 i1 "reg" 1 nil "i1")
(vcd-add-vars vcd0 o1 "reg" 1 nil "o1")

(with-open-file (str "test3.vcd" :direction :output :if-exists :overwrite :if-does-not-exist :create)
  (setf (vcd-stream vcd0) str)
  (vcd-show-header vcd0)
  (vcd-show-module-tb vcd0)
  (vcd-show-start-dumpvars vcd0)

  (propagate 17)
  (set-xsignal i0 (xsignal-value o1))
  (set-xsignal i1 (xsignal-value o0))
  (propagate 13)
  )
