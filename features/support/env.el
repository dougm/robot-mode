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
