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

;;;; settings -- general
;; start server
(server-start)

;; line numbers
(global-display-line-numbers-mode)

;; no startup stuff
(setq-default inhibit-splash-screen t)

;; enable clipboard
(setq select-enable-clipboard t)

;; 4 space tabs
(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq-default indent-tabs-mode nil)
(setq backward-delete-char-untabify-method 'nil)

;; yes/no -> y/n
(defalias 'yes-or-no-p 'y-or-n-p)

;; (global-hl-line-mode t) ;; highlights line with cursor

(setq use-package-always-defer t)

;; Mouse / Cursor
(set-mouse-color "white") ;; Set mouse color
(blink-cursor-mode 0) ;; Disable cursor blinking

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Write backup files to own directory ("$HOME/.emacs.d/backups")
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))
;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Ask for sudo password if needed
(defadvice find-file (after find-file-sudo activate)
  "Find file as root if necessary."
  (unless (and buffer-file-name
               (file-writable-p buffer-file-name))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

;; Set font and size
(add-to-list 'default-frame-alist '(font . "-misc-fixed-medium-r-normal--13-120-75-75-c-70-iso8859-1" ))
(set-face-attribute 'default t :font "-misc-fixed-medium-r-normal--13-120-75-75-c-70-iso8859-1" )

;; Load Gentoo stuff
;;(require 'site-gentoo)

;;;; Keybindings and Macros
(global-set-key (kbd "<home>") 'beginning-of-buffer) ;; move to beginning of buffer
(global-set-key (kbd "<end>") 'end-of-buffer) ;; move to end of buffer
(fset 'insert-ls
   "\C-u\C-[!ls\C-m")
(global-set-key (kbd "C-c l") 'insert-ls) ;; insert ls output at cursor in buffer
(global-set-key (kbd "C-c t") 'toggle-transparency) ;; toggle transparency
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file) ;; rename current file

;;;; Required stuff
(require 'rust-mode) ;; Rust Mode
(require 'lsp-mode) ;; lsp

;; Hooks
(add-hook 'after-init-hook #'global-emojify-mode)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'scala-mode-hook #'lsp)
(add-to-list 'auto-mode-alist '("\\.zs\\'" . csharp-mode))
