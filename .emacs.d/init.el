;; Remove the menubar
(menu-bar-mode -1)

;; Display current column number
(column-number-mode 1)

;; Add package repositories
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (elcord impatient-mode moz-controller cheat-sh centaur-tabs flycheck highlight-parentheses link treemacs rust-playground shell-pop mpv vterm company racer simple-mpc selectric-mode zone-nyan pacmacs 2048-game))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Customize nyan cat zone to add sound
(setq zone-nyan-bg-music-program "mpv"
      zone-nyan-bg-music-args
      `("--loop" "0" ,(expand-file-name "~/downloads/original.mp3")))

;; Run rustfmt whenever a buffer is saved
(setq rust-format-on-save t)

;; Activate Racer when rust-mode starts
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)

;; Rust completions
(add-hook 'racer-mode-hook #'company-mode)

(require 'rust-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)

;; Advice find-file to open file as root if needed
(defadvice find-file (after find-file-sudo activate)
  "Find file as root if necessary."
  (unless (and buffer-file-name
               (file-writable-p buffer-file-name))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

;; Rename current buffer and file
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

(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)

;; Delete current buffer and file
(defun delete-current-buffer-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (ido-kill-buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

(global-set-key (kbd "C-x C-k") 'delete-current-buffer-file)

(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;; Show/Hide treemacs
(global-set-key (kbd "C-x C-t") 'treemacs)

;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; tabs
(require 'centaur-tabs)
(centaur-tabs-mode t)
(global-set-key (kbd "C-<next>")  'centaur-tabs-backward)
(global-set-key (kbd "C-<prior>") 'centaur-tabs-forward)
(global-set-key (kbd "C-c t") 'centaur-tabs-counsel-switch-group)
(centaur-tabs-headline-match)
(centaur-tabs-mode t)
(defun centaur-tabs-buffer-groups ()
     "`centaur-tabs-buffer-groups' control buffers' group rules.

 Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
 All buffer name start with * will group to \"Emacs\".
 Other buffer group by `centaur-tabs-get-group-name' with project name."
     (list
      (cond
 ((or (string-equal "*" (substring (buffer-name) 0 1))
      (memq major-mode '(magit-process-mode
    magit-status-mode
    magit-diff-mode
    magit-log-mode
    magit-file-mode
    magit-blob-mode
    magit-blame-mode
    )))
  "Emacs")
 ((derived-mode-p 'prog-mode)
  "Editing")
 ((derived-mode-p 'dired-mode)
  "Dired")
 ((memq major-mode '(helpful-mode
       help-mode))
  "Help")
 ((memq major-mode '(org-mode
       org-agenda-clockreport-mode
       org-src-mode
       org-agenda-mode
       org-beamer-mode
       org-indent-mode
       org-bullets-mode
       org-cdlatex-mode
       org-agenda-log-mode
       diary-mode))
  "OrgMode")
 (t
  (centaur-tabs-get-group-name (current-buffer))))))

(global-set-key (kbd "C-c r") (lambda ()
                                (interactive)
                                (revert-buffer t t t)
                                (message "buffer is reverted")))

