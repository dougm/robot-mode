;;; robot-mode.el --- Major mode for editing and running Robot tests

;; Author: Doug MacEachern
;; URL: https://github.com/dougm/robot-mode
;; Version: 0.1.0
;; Keywords: robot, tests

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

;;; Code:

(require 'subr-x)

(defvar robot-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c a") 'robot-run-all)
    (define-key map (kbd "C-c m") 'robot-run-current-file)
    (define-key map (kbd "C-c .") 'robot-run-current-test)
    map)
  "Keymap used in Robot mode.")

;; robot-font-lock-keywords as defined in the original robot-mode.el
(defvar robot-font-lock-keywords
  '(
    ;;normal comment
    ("#.*" . font-lock-comment-face)
    ;;Section headers
    ("\\*\\*\\* [^\\*]+ \\*\\*\\*" . font-lock-keyword-face)
    ;;keyword definitions
    ("^[^ \t\n].+" . font-lock-function-name-face)
    ;;Variables
    ("\\(\\$\\|@\\){\\( ?[^ }$]\\)+}" 0 font-lock-variable-name-face t)
    ;;tags etc
    ("\\[[^\]]+\\]+" . font-lock-constant-face)
    ;;comment kw
    ("comment  .*" . font-lock-comment-face)
    ))

;; (setq robot-program (concat (projectile-project-root) "tests/local-integration-test.sh"))
(defvar robot-program "pybot"
  "Default robot program.")

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
  "Run robot-program FILE.
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
  (set (make-local-variable 'comment-start) "#")
  (set (make-local-variable 'comment-start-skip) "#")
  (set (make-local-variable 'font-lock-defaults) '((robot-font-lock-keywords))))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.robot\\'" . robot-mode))

(provide 'robot-mode)

;;; robot-mode.el ends here
