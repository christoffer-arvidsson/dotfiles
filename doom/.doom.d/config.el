;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Christoffer Arvidsson"
      user-mail-address "christoffer@arvidson.nu")

;; Keybindings
(map! :leader
      "TAB" 'evil-switch-to-windows-last-buffer ; Switch to last buffer
      "v"   'er/expand-region ; Quick way to highlight blocks
      ; Bindings for workspaces
      "W n" '+workspace/new
      "W W" '+workspace/display
      "W l" '+workspace/load
      "W L" '+workspace/load-session
      "W s" '+workspace/save
      "W S" '+workspace/save-session
      "W ." '+workspace/switch-to
      "W X" '+workspace/kill-session
      "W TAB" '+workspace/other)

      ;; These bindings deal with new workspace switching

;; Configure treemacs
(after! treemacs
  (setq treemacs-use-follow-mode t
        treemacs-use-filewatch-mode t
        treemacs-use-collapsed-directories 3))
(map! "S-<backspace>" 'treemacs)

;; Configure latex
(after! latex
  (set-company-backend! 'latex-mode t)
  (setq-default TeX-master 'nil)) ; Ask for master file on latexmk

;; Completion settings
(require 'company)
(setq company-idle-delay 0.1
      company-minimum-prefix-length 3)

;; MODULES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(load! "+ui")  ; Contains ui modifications
(load! "+org")  ; Contains org modifications
;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;;
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
