;; -*- Emacs-Lisp -*-

;; Have nnimap log more (to buffer named by imap-log-buffer)
;(setq imap-log t)

;; Set to nil if you don't want 'g' to read incoming mail.  Nice when
;; we're testing dangerous things like upgrading gnus.
(setq nnml-get-new-mail t)

(require 'starttls)
(require 'smtpmail)

;; Select backend
(setq gnus-select-method '(nnml ""))
;; For gods sake, don't forget to snarf ssl.el (from the w3 package)
;; if you're trying (nnimap-stream ssl), or you'll be a sorry bastard.
;; Don't expect imap-ssl-open to give you *any* hint at all of what's
;; being wrong.

;; Login info
;(setq nnimap-authinfo-file "~/.priv/nnimap-authinfo" )

;; Flyspell.
(add-hook 'message-mode-hook
	  (lambda ()
	    (ispell-change-dictionary "svenska") ;"british"
	    (flyspell-mode 1)))

;; Interaction with planner-el
;(require 'planner-gnus)
;(planner-gnus-insinuate)

;; C-x m runs gnus.
(setq mail-user-agent 'gnus-user-agent)

;; We don't like text/html.
(add-to-list 'mm-discouraged-alternatives "text/html")

;; (Delayed Articles)
(gnus-delay-initialize)

(setq gnus-treat-hide-boring-headers t)

;; With `gnus-read-active-file' set to some, 'g' in Summary buffer
;; will increase the unread count for *all* nnimap (all foreign?)
;; groups when we get mail in one of them.
;(setq gnus-read-active-file t)

;; check mail every X minutes (if 3rd param is t: only if emacs is idle)
(gnus-demon-add-handler 'gnus-demon-scan-news 1 t)

;; Switch to group buffer on `C-x C-m C-m'.  See ~/elisp/misc.el for a
;; more elaborate trial.
(defun ln-gnus-group-buffer ()
  (interactive)
  (switch-to-buffer "*Group*"))
(global-set-key (kbd "C-x C-m C-m") 'ln-gnus-group-buffer)

(setq message-yank-prefix "| "
      message-yank-empty-prefix message-yank-prefix
      message-yank-cited-prefix message-yank-prefix)

(setq gnus-use-long-file-name nil
      nnmail-use-long-file-names nil)

(setq gnus-use-full-window nil)
(setq nnml-directory "~/Mail/"
      mail-source-directory (concat nnml-directory "Incoming/")
      mail-source-delete-incoming t)

(setq gnus-ignored-from-addresses
      '("linus@\\(swox\\|nordberg\\|dfri\\).se"
	"linus@swox.com"
	"linus@\\(nordu\\|dfri\\).net"
        "linus@torproject.org"
        "linus.nordberg@.*"))
(setq gnus-extra-headers '(Keywords To Newsgroups)
      nnmail-extra-headers '(Keywords To Newsgroups))
;try some day: (setq gnus-fetch-old-headers 'some)
(setq gnus-thread-indent-level 2)
(setq gnus-simplify-subject-functions '(gnus-simplify-subject-re))
(setq mail-sources '((file)))

;; Citation line
;; FIXME: Strip the date string some.
;; 2010-05-19: Not used, see message-citation-line-function.
(defun my-message-insert-citation-line ()
  "My own function that inserts a citation line."
  (when message-reply-headers
    (insert (mail-header-from message-reply-headers)
	        " wrote\n"
		(mail-header-date message-reply-headers)
		":\n\n")))
(setq message-citation-line-function 'my-message-insert-citation-line)

;; Have a random fortune cookie from ~/.cookies in the sig.
;(setq message-signature '(cookie-insert "~/.cookies"))
;(setq message-signature "linus")

;; add cookie. mail-insert-cookie is defined in
;; ~linus/lisp/linus-misc.el.
;(add-hook 'message-setup-hook 'mail-insert-cookie)

;; Posting styles
;; Use (signature-file "~/.signature") for whole file.
(setq gnus-posting-styles
      '((".*" (organization nil) ;("^nnimap\\+adb-centralen" (organization nil)
	 ("From" "Linus Nordberg <linus@nordberg.se>")
	 (eval
	  (setq smtpmail-smtp-server "smtp.nordberg.se"
		smtpmail-smtp-service 587)
	  (set (make-local-variable 'message-sendmail-envelope-from)
	       "linus@nordberg.se")))
	("lists.tor.assistants"
	 ("Reply-To" "tor-assistants@lists.torproject.org")
	 ("From" "Linus Nordberg <linus@torproject.org>"))
	("lists.tor.internal" ("Reply-To" "tor-internal@lists.torproject.org"))
        ("lists.tor..*" ("From" "Linus Nordberg <linus@torproject.org>"))
	("lists.pmacct..*"
	 ("From" "Linus Nordberg <linus+pmacct@nordberg.se>")
	 (organization "NORDUnet A/S"))
	("ndn:\\|gmane.comp.encryption.kerberos"
	 (organization "NORDUnet A/S")
	 ("From" "Linus Nordberg <linus@nordu.net>")
	 (eval
	  (setq smtpmail-smtp-server "smtp.nordu.net"
		smtpmail-smtp-service 587)
	  (set (make-local-variable 'message-sendmail-envelope-from)
	       "linus@nordu.net")))))

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.nordberg.se" 587 nil nil))
      ;; '(("smtp.nordberg.se" 587 "~/.priv/maatuska.nordberg.se.key" "~/.priv/maatuska.nordberg.se.pem"))
      smtpmail-auth-credentials '(("smtp.nordu.net" 587 "linus" "tothuh6A")
                                  ("smtp.nordberg.se" 587 "linus" "ohL0gime"))
      ;;i'd like to use nnimap-authinfo-file instead
      smtpmail-debug-info nil
      )

;; Archiving
(setq gnus-message-archive-group
      '(lambda (group)
	 "Return name of mailbox to store archive copy in.  Use GROUP, default to ADB-Centralen."
	 (if (and nil message-news-p)	;disabled for now
	     "misc-news"
	   (format "%s:INBOX.sent-mail.%s"
		   (car (split-string
			 (if (or (string= group "")
				 (compare-strings group nil (length "nntp") "nntp" nil nil))
			     "nnimap+adb-centralen"
			   group)
			 (make-string 1 ?:)))
		   (format-time-string "%Y-%m" (current-time))))))
;; Drafts
;(setq nndraft-directory (concat nnml-directory 
(setq nndraft-directory nnml-directory)

;; Nice summary-line
(setq gnus-summary-line-format "%U%R%z%I %d %(%[%4L: %-15,15f%]%) %s\n")

;; Disabled 2002-09-04: (setq gnus-show-mime t)
;; (setq gnus-read-active-file 'some)
;;(setq gnus-read-active-file t)

;(setq gnus-group-highlight
;      '(((> unread 200) . my-group-face-1)
;	((and (< level 3) (zerop unread)) . my-group-face-2)
;	((< level 3) . my-group-face-3)
;	((zerop unread) . my-group-face-4)
;	(t . my-group-face-5)))

;; Offline reading.  Yum!  `J j' toggles plugged/unplugged mode.  
;; `J s' downloads stuff, `J S' empties the outgoing queue.
;; `J c' changes categories, determining what to download.
(gnus-agentize)

;; Type `C-c C-a' in dired-mode to send file under point as an attachment.
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)

;; Mailing lists with Reply-To headers are a pain.  List them here.
(setq gnus-parameters
      '(("lists\\.\\(live\\|misc\\)\\|comp.mail.spam.antispam\\|comp.os.bus"
	 (broken-reply-to . t))))

;; FIXME: Does this make any difference?
;(add-hook 'gnus-article-mode-hook 'turn-on-font-lock)

;; Avoid race conditions with IMAP group closing.
(setq nnimap-close-asynchronous nil)
