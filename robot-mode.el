;;; robot-mode.el --- Major mode for editing and running Robot tests

;; Author: Doug MacEachern
;; URL: https://github.com/dougm/robot-mode
;; Version: 0.1.0
;; Package-Requires: ((emacs "24.4"))
;; Keywords: convenience, languages, processes, tools

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;; Commentary:

;; A major mode for editing and running Robot Framework tests

;;; Code:

(require 'subr-x)

(defvar robot-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c a") 'robot-run-all)
    (define-key map (kbd "C-c m") 'robot-run-current-file)
    (define-key map (kbd "C-c .") 'robot-run-current-test)
    map)
  "Keymap used in `robot-mode'.")

(defconst robot-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?# "<" table)
    (modify-syntax-entry ?\n ">" table)
    table)
  "Syntax table for `robot-mode'.")

(defvar robot-font-lock-keywords
  '(
    ;;comment kw, this takes priority over other faces
    ("^\\s-*[cC]omment  .*" . font-lock-comment-face)

    ;;Section headers
    ("\\*\\*\\* [^\\*]+ \\*\\*\\*" . font-lock-keyword-face)
    ;;keyword definitions
    ("^[^ \t\n].+" . font-lock-function-name-face)
    ;; keyword usage (keywords are terminated by multiple spaces, a
    ;;space-surrounded pipe character or end-of-line)
    ("^[ \t|]+\\(.*?\\)\\(  \\| | \\|$\\)" 1 font-lock-preprocessor-face)
    ;;Variables
    ("\\(\\$\\|@\\){\\( ?[^ }$]\\)+}" 0 font-lock-variable-name-face t)
    ;;tags etc
    ("\\[[^\]]+\\]+" . font-lock-constant-face)
    )
  "Expressions to highlight in `robot-mode'.")

;; (setq robot-program (concat (projectile-project-root) "tests/local-integration-test.sh"))
(defvar robot-program "pybot"
  "Default program to run tests with in `robot-mode'.")

(defun robot-current-test ()
  "Find current robot test."
  (let (test-name)
    (save-excursion
      (end-of-line)
      (unless (search-backward-regexp "^[A-Z]" nil t)
        (error "Unable to find a test"))
      (setq test-name (string-trim (thing-at-point 'line t))))
    test-name))

(defun robot-run (file &optional name)
  "Run `robot-program' FILE.
NAME if given is used as the robot test name."
  (let ((cmd (concat robot-program (if name (concat " -t '" name "'")) " " file)))
    (compile cmd)))

(defun robot-run-current-test ()
  "Run robot with the current test at point."
  (interactive)
  (robot-run-current-file (robot-current-test)))

(defun robot-run-current-file (&optional name)
  "Run robot with the current buffer file.
NAME if given is used as the robot test name."
  (interactive)
  (robot-run buffer-file-name name))

(defun robot-run-all ()
  "Run all robot test files in the current directory."
  (interactive)
  (robot-run (concat default-directory "*.robot")))

;;;###autoload
(define-derived-mode robot-mode prog-mode
  "robot"
  "Major mode for editing and running Robot tests.

\\{robot-mode-map}"
  :syntax-table robot-syntax-table
  (set (make-local-variable 'comment-start) "#")
  (set (make-local-variable 'comment-start-skip) "#")
  (set (make-local-variable 'font-lock-defaults) '((robot-font-lock-keywords)))

  ;; We need to set this otherwise emacs inserts tabs for alignment. It's
  ;; probably a good idea anyway because Robot Framework converts tabs to spaces
  ;; (see 2.1.4 Rules for parsing the data in the user guide).
  (setq-local indent-tabs-mode nil))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.robot\\'" . robot-mode))

;; Add alignment rules for align-current in robot-mode
(with-eval-after-load 'align
  ;; Quieten the byte-compiler
  (eval-when-compile (defvar align-rules-list))
  (add-to-list 'align-rules-list '(robot-mode-align-test-data
                                   (regexp  . "\\(  +\\)")
                                   (modes   . '(robot-mode))
                                   (repeat  . t)
                                   (spacing . 4))))

(provide 'robot-mode)

;;; robot-mode.el ends here
