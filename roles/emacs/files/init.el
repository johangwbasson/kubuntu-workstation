;;; -*- lexical-binding: t -*-

;; Basic Emacs configuration

;; Set default font
(set-face-attribute 'default nil :font "JetBrains Mono" :height 120)

;; Enable line numbers
(global-display-line-numbers-mode)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Welcome screen
(setq inhibit-startup-screen t)
