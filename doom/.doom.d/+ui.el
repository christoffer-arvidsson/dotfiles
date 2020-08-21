;;; ~/.doom.d/+ui.el -*- lexical-binding: t; -*-

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-horizon
      doom-themes-enable-bold t
      doom-themes-enable-italic t)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "iosevka" :size 14))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Configure centaur tabs
;; (after! tabs
;;   (setq centaur-tabs-style "bar"
;;         centaur-tabs-set-bar 'under
;;         centaur-tabs-set-icons t
;;         centaur-tabs-height 102
;;         centaur-tabs-cycle-scope 'tabs
;;         centaur-tabs-set-modified-marker t
;;         centaur-tabs-plain-icons t))
