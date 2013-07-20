(setq imap-ssl-program
      '("torify openssl s_client -quiet -tls1 -connect %s:%p" "openssl s_client -quiet -ssl3 -connect %s:%p"))
