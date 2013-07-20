;; connect over tor using M-x erc (don't!)
;; to use erc-tls you'll have to torify emacs (or add socks support to gnutls-cli)
(setq 
 socks-server '("tor" "localhost" 9050 5)
 socks-noproxy '("localhost")
 erc-server-connect-function 'socks-open-network-stream
 erc-server-reconnect-timeout 300
 erc-system-name "")

;; identifyable settings
(setq
 erc-email-userid "merlin"
 erc-nick '("")
 erc-user-full-name "merlin"
 erc-pals nil
 erc-autojoin-mode nil
 erc-autojoin-channels-alist nil
 erc-notify-list nil)
