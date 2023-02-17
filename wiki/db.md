# Notes about operational considerations regarding the SQL database

Sigsum uses Trillian for storing the data and Merkle tree operations.
Trillian uses an SQL database for storing everything that needs
persistent storage. This has a couple of implications with regard to
availability and data consistency.

Sigsum has an architecture with primary and secondary nodes,
replicating data in order not to lose accepted log
entries. [log-go/doc](https://git.glasklar.is/sigsum/core/log-go/-/tree/main/doc)
has more on that topic.

This document collects information about SQL database operations together with Trillian.

## Resources

 - [2023 CT mailing list thread "Mariadb HA with Trillian"](https://groups.google.com/a/chromium.org/g/ct-policy/c/CUQE2IA5wEQ)
