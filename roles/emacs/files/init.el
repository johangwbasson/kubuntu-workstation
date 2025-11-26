;;; -*- lexical-binding: t -*-

;; Add "lisp" folder to load path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))


(require 'packages)      ;; package manager & packages
(require 'keybindings)   ;; your custom keys
(require 'ui)            ;; theme, fonts, UI tweaks
(require 'programming)   ;; general programming config
(require 'ocaml)          ;; OCaml-specific

;; Basic Emacs configuration

;; Set default font
; (set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono" :height 120)

;; Enable line numbers
; (global-display-line-numbers-mode)

;; Use spaces instead of tabs
; (setq-default indent-tabs-mode nil)

;; Welcome screen
; (setq inhibit-startup-screen t)

; (scroll-bar-mode -1)        ; Disable visible scrollbar
; (tooltip-mode -1)           ; Disable tooltips
; (tool-bar-mode -1)          ; Disable the toolbar
; (set-fringe-mode 10)        ; Give some breathing room

; (load-theme 'wombat)

; ;; Make ESC quit prompts
; (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

; ;; Initialize package sources
; (require 'package)

; (setq package-archives '(("melpa" . "https://melpa.org/packages/")
;                          ("org" . "https://orgmode.org/elpa/")
;                          ("elpa" . "https://elpa.gnu.org/packages/")))

; (package-initialize)
; (unless package-archive-contents
;   (package-refresh-contents))

; ; Only evaluate this when compiling this file
; (eval-when-compile
;   ; For each package on the list do
;   (dolist (package '(use-package diminish bind-key))
;     ; Install if not yet installed
;     (unless (package-installed-p package)
;       (package-install package))
;     ; Require package making it available on the rest of the configuration
;     (require package)))

; ;; Initialize use-package on non-Linux platforms
; (unless (package-installed-p 'use-package)
;   (package-install 'use-package))

; (require 'use-package)
; (setq use-package-always-ensure t)

; (use-package ivy
;   :diminish
;   :bind (("C-s" . swiper)
;          :map ivy-minibuffer-map
;          ("TAB" . ivy-alt-done)	
;          ("C-l" . ivy-alt-done)
;          ("C-j" . ivy-next-line)
;          ("C-k" . ivy-previous-line)
;          :map ivy-switch-buffer-map
;          ("C-k" . ivy-previous-line)
;          ("C-l" . ivy-done)
;          ("C-d" . ivy-switch-buffer-kill)
;          :map ivy-reverse-i-search-map
;          ("C-k" . ivy-previous-line)
;          ("C-d" . ivy-reverse-i-search-kill))
;   :config
;   (ivy-mode 1))

; (use-package doom-modeline
;   :ensure t
;   :init (doom-modeline-mode 1)
;   :custom ((doom-modeline-height 15)))


; ; Sidebar navigation with extras
; (use-package treemacs
;   :ensure t  
;   :config
;   (treemacs-filewatch-mode t)
;   (treemacs-git-mode 'extended)
;   (treemacs-follow-mode -1)
;   (add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1))))

; ; LSP client interface for Emacs
; (use-package lsp-mode
;   :commands (lsp lsp-deferred)
;   :ensure t
;   :hook
;   ; some examples
;   (elixir-mode . lsp-deferred)
;   (dart-mode . lsp-deferred)
;   :config
;   (setq
;    ; I will describe my Elixir setup on a next post :)
;    lsp-clients-elixir-server-executable "~/Projects/elixir-ls/release/erl21/language_server.sh"
;    lsp-auto-guess-root t) ; very useful
;   (setq lsp-file-watch-ignored ; customize this to your liking :)
;       '("[/\\\\]\\.git$"
;         "[/\\\\]\\.elixir_ls$"
;         "[/\\\\]_build$"
;         "[/\\\\]assets$"
;         "[/\\\\]cover$"
;         "[/\\\\]node_modules$"
;         "[/\\\\]submodules$"
;         )))

; ; UX/UI utilities on top of the LSP client
; (use-package lsp-ui
;   :commands lsp-ui-mode
;   :ensure t
;   :after (lsp-mode)
;   :config
;   :init
;   (setq lsp-ui-doc-enable nil ; does not work properly at the moment IMHO
;         lsp-ui-doc-use-webkit t         
;         lsp-ui-sideline-enable nil ; clutters UI too much for my taste
;         lsp-ui-peek-enable nil) ; clutters UI too much for my taste
;   :bind
;   ("M-h" . lsp-ui-doc-show)  ; toogle functionality for docs
;   ("s-h" . lsp-ui-doc-hide)) ; toogle functionality for docs
