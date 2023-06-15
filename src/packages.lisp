(in-package :cl-user)

(defpackage :lambda-schematic
  (:use :cl)
  (:nicknames :schematic)
  (:export

    #:make-xsignal
    #:xsignal-value ; setf されると action をすり抜けるから提供しないほうがいい
    #:set-xsignal
    #:get-xsignal

    #:the-agenda ; 必要？ローカルに持たせたほうがいいのでは？
    #:add-action

    #:probe

    #:get-current-time 
    #:propagate
    #:after-delay

    #:make-clock

    #:clk-ff-gate
  ))

