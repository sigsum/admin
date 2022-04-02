# Configure cgit repository to work with Go modules

Are you seeing this error?

    $ go install git.sigsum.org/testing/cmd/hola@latest
    go: git.sigsum.org/testing/cmd/hola@latest: unrecognized import path "git.sigsum.org/testing/cmd/hola": reading https://git.sigsum.org/testing/cmd/hola?go-get=1: 404 Not Found

Remember to configure the cgit repository with [Go's meta tag][].

[Go's meta tag]: https://pkg.go.dev/cmd/go#hdr-Remote_import_paths

## Backtrace

This is where to look:

    root@getuid:~# rgrep go-import ~git/repositories
    root@getuid:~# echo 'extra-head-content=<meta name="go-import" content="git.sigsum.org/testing git https://git.sigsum.org/testing">' > ~git/repositories/testing.git/cgitrc
