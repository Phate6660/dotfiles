(require 'exwm)
(require 'exwm-config)
;; Set the initial number of workspaces (they can also be created later).
(setq exwm-workspace-number 10)
;; All buffers created in EXWM mode are named "*EXWM*". You may want to
;; change it in `exwm-update-class-hook' and `exwm-update-title-hook', which
;; are run when a new X window class name or title is available.  Here's
;; some advice on this topic:
;; + Always use `exwm-workspace-rename-buffer` to avoid naming conflict.
;; + For applications with multiple windows (e.g. GIMP), the class names of
;    all windows are probably the same.  Using window titles for them makes
;;   more sense.
;; In the following example, we use class names for all windows except for
;; Java applications and GIMP.
(add-hook 'exwm-update-class-hook
          (lambda ()
            (unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                        (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-class-name))))
(add-hook 'exwm-update-title-hook
          (lambda ()
            (when (or (not exwm-instance-name)
                      (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                      (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-title))))
(add-hook 'exwm-manage-finish-hook
          (lambda ()
            (when (and exwm-class-name
                       (string= exwm-class-name "UXTerm"))
              (exwm-input-set-local-simulation-keys '(([?\C-c ?\C-c] . ?\C-c))))))
;; Global keybindings can be defined with `exwm-input-global-keys'.
;; Here are a few examples:
(setq exwm-input-global-keys
      `(
		;; Bind "s-z" to exit char-mode and fullscreen mode.
        ([?\s-z] . exwm-layout-toggle-mode-line)
        ;; Bind "s-r" to exit char-mode and fullscreen mode.
        ([?\s-r] . exwm-restart)
        ;; Bind "s-`" to switch workspace interactively.
        ([?\s-`] . exwm-workspace-switch)
        ;; Bind "s-0" to "s-9" to switch to a workspace by its index.
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))
        ;; Bind "s-&" to launch applications ('M-&' also works if the output
        ;; buffer does not bother you).
        ([?\s-&] . (lambda (command)
       (interactive (list (read-shell-command "$ ")))
       (start-process-shell-command command nil command)))
        ;; xscreensaver
        ([?\s-x] . (lambda ()
      (interactive)
      (start-process "" nil "xscreensaver-command" "-lock")))
		;; ripcord
		([?\s-d] . (lambda ()
      (interactive)
      (start-process "" nil "/home/valley/downloads/Ripcord-0.4.24-x86_64.AppImage")))
        ;; palemoon
		([?\s-w] . (lambda ()
      (interactive)
      (start-process "" nil "palemoon")))
		;; tor browswer bundle
		([?\s-W] . (lambda ()
      (interactive)
      (start-process "" nil "general" "tbb")))
		;; uxterm
		([?\s-t] . (lambda ()
      (interactive)
      (start-process "" nil "general" "term")))
        ;; music notification
		([?\s-m] . (lambda ()
      (interactive)
      (start-process "" nil "general" "mus")))
		;; time/date notification
		([?\s-n] . (lambda ()
      (interactive)
      (start-process "" nil "general" "date")))
		;; ip address notification
		([?\s-i] . (lambda ()
      (interactive)
      (start-process "" nil "general" "ip")))
		;; fetch notification
		([?\s-o] . (lambda ()
      (interactive)
      (start-process "" nil "general" "fetch")))
		;; audio stats
		([?\s-A] . (lambda ()
      (interactive)
      (start-process "" nil "general" "stat")))
		;; audio devices
		([?\s-a] . (lambda ()
      (interactive)
      (start-process "" nil "general" "dev")))
		;; blender
		([?\s-b] . (lambda ()
      (interactive)
      (start-process "" nil "/home/valley/downloads/blender-2.83-04e318de3a40-linux-glibc217-x86_64/blender")))
		;; gzdoom
		([?\s-g] . (lambda ()
      (interactive)
      (start-process "" nil "gzdoom" "-file" "/home/valley/.config/gzdoom/*.pk3" "+sv_cheats" "1" "+vid_fps" "true" "+cl_capfps" "false" "+vid_maxfps" "60")))))

;; The following example demonstrates how to use simulation keys to mimic
;; the behavior of Emacs.  The value of `exwm-input-simulation-keys` is a
;; list of cons cells (SRC . DEST), where SRC is the key sequence you press
;; and DEST is what EXWM actually sends to application.  Note that both SRC
;; and DEST should be key sequences (vector or string).
(setq exwm-input-simulation-keys
      '(
        ;; movement
        ;; ([?\C-b] . [left])
        ([?\M-b] . [C-left])
        ;; ([?\C-f] . [right])
        ([?\M-f] . [C-right])
        ([?\C-p] . [up])
        ([?\C-n] . [down])
        ;; ([?\C-a] . [home])
        ;; ([?\C-e] . [end])
        ([?\M-v] . [prior])
        ([?\C-v] . [next])
        ([?\C-d] . [delete])
        ([?\C-k] . [S-end delete])
        ;; cut/paste.
        ([?\C-w] . [?\C-x])
        ([?\M-w] . [?\C-c])
        ([?\C-y] . [?\C-v])
        ;; search
        ;; ([?\C-s] . [?\C-f])
		))

;; Do not forget to enable EXWM. It will start by itself when things are
;; ready.  You can put it _anywhere_ in your configuration.
(exwm-enable)

;; transparent frame and wallpaper
(set-frame-parameter (selected-frame) 'alpha '(80 50))
(add-to-list 'default-frame-alist '(alpha . (80 . 50)))
(use-package wallpaper
  :ensure t
  :custom ((wallpaper-cycle-single t)
           (wallpaper-scaling 'max)
           (wallpaper-cycle-interval 15)
           (wallpaper-cycle-directory "/mnt/ehdd/Pictures/wallpapers/single"))) ;; Use "single" dir for one wallpaper. I couldn't figure out how to set one wallpaper on it's own...

;; set wallpaper
(wallpaper-set-wallpaper)
(setq wallpaper-cycle-mode nil)

;; ensure Xresources is merged
(add-hook 'emacs-startup-hook (lambda ()
    (start-process-shell-command "" nil "xrdb -merge ~/.Xresources")
))
