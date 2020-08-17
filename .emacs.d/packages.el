;; Initialize packages
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

;; Automatically update packages
(use-package auto-package-update
  :defer nil
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; Customizable tabs
(use-package centaur-tabs
  :demand
  :config
  (setq centaur-tabs-height 16)
  (centaur-tabs-mode t)
  :bind
  ("C-<next>" . centaur-tabs-backward)
  ("C-<prior>" . centaur-tabs-forward))

;; Terminal
(use-package vterm
    :ensure t)

;; Show emojis
(use-package emojify
    :ensure t)

;; Asynchronous bytecode compilation and various other actions makes Emacs look SIGNIFICANTLY less often which is a good thing.
(use-package async
    :ensure t
    :defer t
    :init
    (dired-async-mode 1)
    (async-bytecomp-package-mode 1)
    :custom (async-bytecomp-allowed-packages '(all)))

;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; lsp-mode
(use-package lsp-mode
    :ensure t)
