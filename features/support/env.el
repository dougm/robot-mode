(require 'f)

(defvar robot-mode-support-path
  (f-dirname load-file-name))

(defvar robot-mode-features-path
  (f-parent robot-mode-support-path))

(defvar robot-mode-root-path
  (f-parent robot-mode-features-path))

(add-to-list 'load-path robot-mode-root-path)

(require 'robot-mode)
(require 'espuds)
(require 'ert)

;; Don't load old byte-compiled versions!
(setq load-prefer-newer t)

(Setup
 ;; Before anything has run
 )

(Before
 ;; Before each scenario is run
 )

(After
 ;; After each scenario is run
 )

(Teardown
 ;; After when everything has been run
 )

;; This fixes an issue in emacs 25.1 where the debugger would be invoked
;; incorrectly, breaking ert.
(when (and (= emacs-major-version 25) (< emacs-minor-version 2))
  (require 'cl-preloaded)
  (setf (symbol-function 'cl--assertion-failed)
        (lambda (form &optional string sargs args)
          "This function has been modified by espuds to remove an incorrect manual call
to the debugger in emacs 25.1. The modified version should only be used for
running the espuds tests."
          (if string
              (apply #'error string (append sargs args))
            (signal 'cl-assertion-failed `(,form ,@sargs))))))
