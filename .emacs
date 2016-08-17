;; .emacs

;;;;;;;;;;;;;;;;;
;;;; USER DETAILS
;;;;;;;;;;;;;;;;;

(setq user-full-name "Erica Moszkowski")
(setq user-mail-address "erica.moszkowski@gmail.com")

;;;;;;;;;;;;;;;;;
;;;; SETUP
;;;;;;;;;;;;;;;;;


;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

;; line numbers
(global-linum-mode t) 

;; tabs
(setq tab-width 4) ; 4 spaces per tab
(defvaralias 'c-basic-offset 'tab-width)

;; mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] (lambda ()
                              (interactive)
                              (scroll-down 1)))
  (global-set-key [mouse-5] (lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
)

;; backup files
(setq backup-directory-alist
      `((".*" . , "~/.emacs.d/backup/")))
(setq auto-save-file-name-transforms
      `((".*" , "~/.emacs.d/backup/" t)))

;; colors

;; colors
(set-face-attribute 'region nil :inverse-video t)
(set-face-foreground font-lock-builtin-face "brightmagenta")
(set-face-foreground font-lock-comment-face "color-35") ; forest green
(set-face-foreground font-lock-constant-face "brightcyan")
(set-face-foreground font-lock-function-name-face "blue")
(set-face-foreground font-lock-keyword-face "brightblue")
(set-face-foreground font-lock-string-face "color-167") ; red
(set-face-foreground font-lock-type-face "brightcyan")
(set-face-foreground 'linum "brightblack")
(set-face-foreground 'minibuffer-prompt "brightblue")

;; Julia mode
(add-to-list 'load-path "~/.emacsconfig/julia-emacs")
(require 'julia-mode)

;; ESS, for running julia/R/etc from inside emacs 
(load "~/.emacsconfig/ESS/lisp/ess-site.el")
(setq inferior-julia-program-name "/usr/local/bin/julia-0.4.2")
(add-to-list 'load-path "~/.emacsconfig/ESS/lisp/")

;; Markdown formatting
(add-to-list 'load-path "~/.emacsconfig/markdown-mode/")
(load "~/.emacs.d/cl-lib-0.5.el")
(require 'markdown-mode)

;; (load "markdown-mode.el")
;; (autoload 'markdown-mode "markdown-mode"
;;    "Major mode for editing Markdown files" t)
;; (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
;; (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;; (autoload 'gfm-mode "gfm-mode"
;;    "Major mode for editing GitHub Flavored Markdown files" t)
;; (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))


;;MATLAB formatting
(add-to-list 'load-path "~/.emacs.d/")
(load "matlab.el")

(autoload 'matlab-mode "matlab" "Enter Matlab mode." t)
(setq auto-mode-alist (cons '("\\.m$" . matlab-mode) auto-mode-alist))
(defun my-matlab-mode-hook ()
(setq matlab-indent-function t) ; if you want function bodies indented
(setq fill-column 76) ; where auto-fill should wrap
(turn-on-auto-fill))
(setq matlab-mode-hook 'my-matlab-mode-hook)
(autoload 'matlab-shell "matlab" "Interactive Matlab mode." t)
(defun my-matlab-shell-mode-hook ()
'())
(setq matlab-mode-hook 'my-matlab-mode-hook)


;; lunate epsilon
(define-key key-translation-map (kbd "<f9> e <right>") (kbd "ϵ"))

