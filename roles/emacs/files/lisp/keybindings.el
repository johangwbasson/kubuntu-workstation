;; Example custom keys
(global-set-key (kbd "C-c t") 'toggle-truncate-lines)
(global-set-key (kbd "C-c g") 'magit-status)

;; Optional: Remap "meta" to "super" for Linux
(setq x-super-keysym 'meta)

;; Enable CUA mode for standard cut/copy/paste
(cua-mode t)

;; Optional: Keep rectangle selection with CUA
(setq cua-enable-cua-keys t)

;; Make Ctrl+S save the current buffer
(global-set-key (kbd "C-s") 'save-buffer)

(global-set-key (kbd "C-f") 'isearch-forward)

(provide 'keybindings)
