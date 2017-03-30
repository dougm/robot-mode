build :
	cask exec emacs -Q --batch --eval             \
	    "(progn                                \
	      (setq byte-compile-error-on-warn t)  \
	      (batch-byte-compile))" robot-mode.el

clean :
	@rm -f *.elc

.PHONY:	all package-lint clean build
