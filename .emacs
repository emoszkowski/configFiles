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

;; Misc
(setq echo-keystrokes 0.1  ; Reduce time to echo keystrokes
      use-dialog-box nil   ; No dialog boxes
      visible-bell t)      ; No beeping

;; highlight matching = parentheses
(show-paren-mode t)
(setq show-paren-delay 0)
(set-face-background 'show-paren-match "brightblack")
(set-face-background 'show-paren-mismatch "color-167") ; red

;; trailing whitespace
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "color-167") ; red
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(global-set-key (kbd "C-x w") 'delete-trailing-whitespace)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

;; line numbers
(global-linum-mode t)
(global-set-key (kbd "C-x l") 'linum-mode)  ; turn off with C-x l

;; increment and decrement numbers using C-c = and C-c -
(defun my-increment-number-decimal (&optional arg)
  "Increment the number forward from point by 'arg'."
  (interactive "p*")
  (save-excursion
    (save-match-data
      (let (inc-by field-width answer)
        (setq inc-by (if arg arg 1))
        (skip-chars-backward "0123456789")
        (when (re-search-forward "[0-9]+" nil t)
          (setq field-width (- (match-end 0) (match-beginning 0)))
          (setq answer (+ (string-to-number (match-string 0) 10) inc-by))
          (when (< answer 0)
            (setq answer (+ (expt 10 field-width) answer)))
          (replace-match (format (concat "%0" (int-to-string field-width) "d")
                                 answer)))))))
(defun my-decrement-number-decimal (&optional arg)
  (interactive "p*")
  (my-increment-number-decimal (if arg (- arg) -1)))
(global-set-key (kbd "C-c =") 'my-increment-number-decimal)
(global-set-key (kbd "C-c -") 'my-decrement-number-decimal)

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

;; Julia
(add-to-list 'load-path "~/.emacsconfig/julia-emacs")
(require 'julia-mode)

;; Dependencies for Julia REPL
(add-to-list 'load-path "~/.emacsconfig/anaphora")
(require 'anaphora)


;; Julia REPL, for a more functioning REPL within emacs
(add-to-list 'load-path "~/.emacsconfig/julia-repl")
(require 'julia-repl)
(add-hook 'julia-mode-hook 'julia-repl-mode) ;; always use minor mode

;; ESS, for running julia/R/etc from inside emacs
(load "~/.emacsconfig/ESS/lisp/ess-site.el")
(setq inferior-julia-program-name "/usr/local/bin/julia-0.4.2")
(add-to-list 'load-path "~/.emacsconfig/ESS/lisp/")


;;MATLAB
(add-to-list 'load-path "~/.emacs.d/")
(load "matlab.el")

(autoload 'matlab-mode "matlab" "Enter Matlab mode." t)
(setq auto-mode-alist (cons '("\\.m$" . matlab-mode) auto-mode-alist))
(defun my-matlab-mode-hook ()
(setq matlab-indent-function t) ; if you want function bodies indented
(setq fill-column 80) ; where auto-fill should wrap
(turn-on-auto-fill))
(setq matlab-mode-hook 'my-matlab-mode-hook)
(autoload 'matlab-shell "matlab" "Interactive Matlab mode." t)
(defun my-matlab-shell-mode-hook ()
'())
(setq matlab-mode-hook 'my-matlab-mode-hook)
; let me comment things out and format nicely in matlab
(add-hook 'matlab-mode-hook (lambda () (local-set-key "\M-;" nil)))
(add-hook 'matlab-mode-hook (lambda () (local-set-key "\M-q" nil)))

;; lunate epsilon
(define-key key-translation-map (kbd "<f9> e <right>") (kbd "ϵ"))

;; uniquify buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style (quote post-forward-angle-brackets))

;; unbind C-o for tmux compatibility
(global-unset-key (kbd "C-o"))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(font-latex-sectioning-5-face ((((type tty pc) (class color) (background light)) (:foreground "brightmagenta" :weight bold)))))
