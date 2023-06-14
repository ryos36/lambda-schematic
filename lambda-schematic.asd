(defsystem "lambda-schematic"
  :version "0.1.0"
  :author "Ryos Suzuki"
  :license "MIT"
  :depends-on (:cl-ppcre)
  :serial t
  :components ((:module "src"
                :components
                ((:file "packages")
                 (:file "lol")
                 (:file "agenda")
                 (:file "logic-op")
                 (:file "schematic")
                 (:file "vcd")
                 ;(:file "meta-schematic")
                 )))

  :description ""
  :in-order-to ((test-op (test-op "lambda-schematic/tests"))))

(defsystem "lambda-schematic/tests"
  :author "Ryos Suzuki"
  :license "MIT"
  :depends-on ("lambda-schematic"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for lambda-schematic"
  :perform (test-op (op c) (symbol-call :rove :run c)))

