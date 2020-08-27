(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(fringe-mode 1 nil (fringe))
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(company lsp-metals scala-mode nim-mode esup yaml-mode elcord csharp-mode gitignore-mode yasnippet lsp-mode flycheck-rust flycheck crystal-mode async wallpaper exwm engine-mode emojify lua-mode centaur-tabs cargo rust-mode auto-package-update use-package speed-type))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))

;; Packages
(load-file "~/.emacs.d/packages.el")

;; EXWM
;; (load-file "~/.emacs.d/exwm.el")

;; Functions
(load-file "~/.emacs.d/functions.el")

;; Settings
(load-file "~/.emacs.d/settings.el")

;; sxhkdrc-mode
(load-file "~/projects/sr.ht/sxhkdrc-mode/sxhkdrc-mode.el")

;; cue-mode
(load-file "~/.emacs.d/cue-mode.el")
(add-to-list 'auto-mode-alist '("\\.cue\\'" . cue-mode))
