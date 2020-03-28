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
	(centaur-tabs cargo rust-mode auto-package-update use-package speed-type)))
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
(global-display-line-numbers-mode) ;; line numbers
(setq-default inhibit-splash-screen t) ;; no startup stuff
(setq x-select-enable-clipboard t) ;; enable clipboard
(setq-default tab-width 4) ;; start 4 space tab
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq-default indent-tabs-mode t)
(setq backward-delete-char-untabify-method 'nil) ;; end 4 space tab
(defalias 'yes-or-no-p 'y-or-n-p) ;; yes/no -> y/n
;; (global-hl-line-mode t) ;; highlights line with cursor
(setq use-package-always-defer t)
;; Save point position between sessions -- start
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))
;; Save point position between sessions -- end
;; Write backup files to own directory -- start
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))
;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)
;; Set font and size
(add-to-list 'default-frame-alist '(font . "-misc-fixed-medium-r-normal--13-120-75-75-c-70-iso8859-1" ))
(set-face-attribute 'default t :font "-misc-fixed-medium-r-normal--13-120-75-75-c-70-iso8859-1" )
;; Set mouse color
(set-mouse-color "white")
;; Disable cursor blinking
(blink-cursor-mode 0)

;; Packages
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

(use-package centaur-tabs
  :demand
  :config
  (setq centaur-tabs-height 16)
  (centaur-tabs-mode t)
  :bind
  ("C-<next>" . centaur-tabs-backward)
  ("C-<prior>" . centaur-tabs-forward))

;; Functions
(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

;; Keybindings and Macros
(global-set-key (kbd "<home>") 'beginning-of-buffer) ;; move to beginning of buffer
(global-set-key (kbd "<end>") 'end-of-buffer) ;; move to end of buffer
(fset 'insert-ls
   "\C-u\C-[!ls\C-m")
(global-set-key (kbd "C-c l") 'insert-ls) ;; insert ls output at cursor in buffer
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file) ;; rename current file

;; Required stuff
(require 'rust-mode) ;; Rust Mode

;; Hooks
(add-hook 'rust-mode-hook 'cargo-minor-mode)
