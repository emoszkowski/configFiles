;; .emacs

;;;;;;;;;;;;;;;;;
;;;; USER DETAILS
;;;;;;;;;;;;;;;;;

(setq user-full-name "Erica Moszkowski")
(setq user-mail-address "erica.moszkowski@gmail.com")

;;;;;;;;;;;;;;;;;
;;;; SETUP
;;;;;;;;;;;;;;;;;


;; add to package archive so we can pull more packages
(require 'package)
;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; add use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to not show menu bar
(menu-bar-mode 0)

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
(set-face-background 'show-paren-mismatch "red") ; red

;; trailing whitespace
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "brightred") ; red
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(global-set-key (kbd "C-x w") 'delete-trailing-whitespace)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)


;; Unified line number setup
(if (boundp 'display-line-numbers)
    ;; Emacs 26+ has built-in display-line-numbers
    (progn
      ;; Pad width like "%4d "
      (setq display-line-numbers-width 4
            display-line-numbers-width-start t) ; auto widen when needed
      ;; Choose style: t = absolute, 'relative = relative, 'visual = relative by screen line
      (setq display-line-numbers-type t)
      (global-display-line-numbers-mode 1))
  ;; Fallback for older Emacs (≤25)
  (progn
    (require 'linum)
    (setq linum-format "%4d ")
    (global-linum-mode 1)))


;; Define a unified toggle command
(defun my-toggle-line-numbers ()
  "Toggle line numbers in the current buffer, works across Emacs versions."
  (interactive)
  (if (boundp 'display-line-numbers)
      (display-line-numbers-mode 'toggle)
    (linum-mode 'toggle)))

;; Bind it to C-x 1 (or another key if you prefer)
(global-set-key (kbd "C-x 1") #'my-toggle-line-numbers)


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
(set-face-foreground font-lock-comment-face "forestgreen") ; forest green
(set-face-foreground font-lock-constant-face "brightcyan")
(set-face-foreground font-lock-function-name-face "blue") ; a bright blue I can see
(set-face-foreground font-lock-keyword-face "brightblue")
(set-face-foreground font-lock-string-face "brightred") ; red
(set-face-foreground font-lock-type-face "brightcyan")
(set-face-foreground 'minibuffer-prompt "brightblue")
;; Set line number color to "brightblack", old or new Emacs
(dolist (face '(line-number linum))
  (when (facep face)
    (set-face-foreground face "brightblack")))

;; Markdown formatting
;(use-package markdown-mode
; :ensure t
; :mode ("README\\.md\\'" . gfm-mode)
; :init (setq markdown-command "multimarkdown"))
;(add-to-list 'load-path "~/.emacsconfig/markdown-mode/")
;(load "~/.emacsconfig/markdown-mode/tests/cl-lib-0.5.el")
;(require 'markdown-mode)

;(load "markdown-mode.el")
;; (autoload 'markdown-mode "markdown-mode"
;;    "Major mode for editing Markdown files" t)
;; (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
;; (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


(autoload 'gfm-mode "gfm-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
 (add-to-list 'auto-mode-alist '("\\.markdown\\'" . gfm-mode))
 (add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))

;; YAML
;(add-to-list 'load-path "~/.emacsconfig/yaml-mode")
;(require 'yaml-mode)
;(add-hook 'yaml-mode-hook
;          (lambda ()
;            (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; Julia
(add-to-list 'load-path "~/.emacsconfig/julia-emacs")
(require 'julia-mode)

;; Dependencies for Julia REPL
;(add-to-list 'load-path "~/.emacsconfig/anaphora")
;(require 'anaphora)

;; ;; Julia REPL, for a more functioning REPL within emacs
;; ;; Note: this only works with Emacs 25+
;; (add-to-list 'load-path "~/.emacsconfig/julia-repl")
;; (require 'julia-repl)
;; (add-hook 'julia-mode-hook 'julia-repl-mode) ;; always use minor mode


;; ESS, for running julia/R/etc from inside emacs
;; (use-package ess
;; :ensure t
;; :init (require 'ess-site))
;;(ess-toggle-underscore nil)



;; ;;MATLAB
;; (add-to-list 'load-path "~/.emacsconfig/matlab-emacs/")
;; (require 'matlab)
;;; (require 'matlab-load)
;;(autoload 'matlab-mode "matlab" "Enter Matlab mode." t)
;;(setq auto-mode-alist (cons '("\\.m$" . matlab-mode) auto-mode-alist))
;;(defun my-matlab-mode-hook ()
;;  "Custom MATLAB hook"
;;  (setq matlab-indent-function t) ; if you want function bodies indented
;;  (setq fill-column 80) ; where auto-fill should wrap
;;  (turn-on-auto-fill)
;;  (setq matlab-comment-region-s "% "))
;; (setq matlab-mode-hook 'my-matlab-mode-hook)
;; (autoload 'matlab-shell "matlab" "Interactive Matlab mode." t)
;; (defun my-matlab-shell-mode-hook ()
;;  '())
;; (add-hook matlab-mode-hook 'my-matlab-mode-hook)
;; (add-hook 'matlab-mode-hook (lambda () (local-set-key "\M-;" nil)))
;; (add-hook 'matlab-mode-hook (lambda () (local-set-key "\M-q" nil)))

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
;;(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 ;;'(font-latex-sectioning-5-face ((((type tty pc) (class color) (background light)) (:foreground "brightmagenta" :weight bold)))))

(custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
  ;'(default ((t (:inherit nil :stipple nil :background "lightyellow2" :foreground "gray20" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight bold :width normal :family "liberation mono"))))
  '(background "blue")
  '(font-lock-builtin-face ((((class color) (background dark)) (:foreground "Turquoise"))))
  '(font-lock-comment-face ((t (:foreground "MediumAquamarine"))))
  '(font-lock-constant-face ((((class color) (background dark)) (:bold t :foreground "DarkOrchid"))))
  '(font-lock-doc-string-face ((t (:foreground "green2"))))
  '(font-lock-function-name-face ((t (:foreground "SkyBlue"))))
  '(font-lock-keyword-face ((t (:bold t :foreground "CornflowerBlue"))))
  '(font-lock-preprocessor-face ((t (:italic nil :foreground "CornFlowerBlue"))))
  '(font-lock-reference-face ((t (:foreground "DodgerBlue"))))
  '(font-lock-string-face ((t (:foreground "LimeGreen"))))
)


;; unbind C-TAB for Mac compatibility
(global-unset-key (kbd "C-TAB"))
