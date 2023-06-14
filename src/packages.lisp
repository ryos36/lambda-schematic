(in-package :cl-user)

(defpackage :lambda-schematic
  (:use :cl)
  (:nicknames :schematic)
  (:export

    #:make-xsignal
    #:xsignal-value
    #:set-xsignal
    #:get-xsignal ; 必要？ xsignal-value でよくね？

    #:the-agenda ; 必要？ローカルに持たせたほうがいいのでは？
    #:add-action

    #:prove

    #:get-current-time 
    #:propagate
    #:after-delay

    #:make-clock

    #:clk-ff-gate
  ))

