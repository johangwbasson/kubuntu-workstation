;; Disable menu/tool bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Set default font
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono" :height 120)

;; Theme
(use-package doom-themes
  :config
  (load-theme 'doom-one t))

;; Line numbers
(global-display-line-numbers-mode t)

