all: build test

build :
	cask exec emacs -Q --batch --eval             \
	    "(progn                                \
	      (setq byte-compile-error-on-warn t)  \
	      (batch-byte-compile))" robot-mode.el

test: build
	cask exec ecukes --tags ~@known-failure

package-lint:
	cask exec emacs -Q --batch -l "package-lint.el" -f "package-lint-batch-and-exit" robot-mode.el

clean :
	@rm -f *.elc

.PHONY:	all package-lint clean build
