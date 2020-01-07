(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
	(powershell xahk-mode dashboard auto-package-update use-package speed-type nyan-mode)))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(setq-default mode-line-format
 (list
  ;; modified, read-only, or neither
  "[%*]"
  ;; file name
  "[%f]"
  ;; mode name
  "[%m]"
  ;; current column:line
  "[%c:%l]"))
(force-mode-line-update t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; settings
;; (global-display-line-numbers-mode) ;; line numbers
(setq-default inhibit-splash-screen t) ;; no startup stuff
(setq x-select-enable-clipboard t) ;; enable clipboard
(setq-default tab-width 4) ;; start 4 space tab
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq-default indent-tabs-mode t)
(setq backward-delete-char-untabify-method 'nil) ;; end 4 space tab
(defalias 'yes-or-no-p 'y-or-n-p) ;; yes/no -> y/n
(global-hl-line-mode t)
(setq use-package-always-defer t)
(load-theme 'Witchmacs t) ;; witchmacs theme
(add-to-list 'auto-mode-alist '("\\.ahk\\'" . xahk-mode)) ;; autohotkey mode upon loading *.ahk* file
(add-to-list 'auto-mode-alist '("\\.ps1\\'" . powershell-mode)) ;; powershell mode upon loading *.ps1* file

;; packages
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(use-package auto-package-update
  :defer nil
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; dashboard -- witchmacs
(use-package dashboard
  :ensure t
  :defer nil
  :preface
  (defun create-scratch-buffer ()
    "Create a scratch buffer"
    (interactive)
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (lisp-interaction-mode))
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 5)))
  (setq dashboard-banner-logo-title "vallEyMACS - The cutest ripoff of an Emacs distribution!")
  (setq dashboard-startup-banner "~/.emacs.d/marivector.png")
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts nil)
  (setq dashboard-set-init-info t)
  (setq dashboard-init-info (format "%d packages loaded in %s"
                                    (length package-activated-list) (emacs-init-time)))
  (setq dashboard-set-footer nil)
  (setq dashboard-set-navigator t)
  (setq dashboard-navigator-buttons
        `(((,nil
            "Open scratch buffer"
            "Switch to the scratch buffer"
            (lambda (&rest _) (create-scratch-buffer))
            'default)))))
