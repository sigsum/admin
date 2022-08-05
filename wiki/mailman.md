# Mailman notes

We're running Mailman 3 from Debian package version 3.3.3-1 (as of 2022-08-05).


## Implicit destination

Some emails end up in moderation when sending to a list with the
default setting of not allowing postings without the list address
explicitly set in To: or CC: ("Require Explicit Destination"). Here's
an example of a destination header which triggers this:

    To: "12 45678901234567890123456789012345678901 3456789012345678901234 678901234" <testing@lists.sigsum.org>

The following examples do _not_ trigger moderation:

    To: "spaces and parentheses (do they matter?) and whatnot      " <testing@lists.sigsum.org>
	To: 1234567890123456789012345678901234567890123456789012345678901234567890123456 <testing@lists.sigsum.org>
	To: "12345678901234567890123456789012345678901234567890123456789012345678901234" <testing@lists.sigsum.org>

Let's call the two parts "fullname" and "address". Moderation is
triggered when the fullname part is both long enough (76 characters is
enough while 60 is not) and contains space(s) (3 are enough).

This is handled in `mailman/src/mailman/rules/implicit_dest.py`:

```
        for header in ('to', 'cc', 'resent-to', 'resent-cc'):
            for fullname, address in getaddresses(msg.get_all(header, [])):
                if isinstance(address, bytes):
                    address = address.decode('ascii')
                address = address.lower()
                if address in aliases:
                    return False
                recipients.add(address)
```

At least it doesn't seem like it's getaddresses() which gets it wrong.
```
linus@madvise:~$ python3
Python 3.9.2 (default, Feb 28 2021, 17:03:44)
[GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import email.utils
>>> s='To: "12 45678901234567890123456789012345678901 3456789012345678901234 678901234" <testing@lists.sigsum.org>'
>>> email.utils.getaddresses([s])
[('12 45678901234567890123456789012345678901 3456789012345678901234 678901234', 'testing@lists.sigsum.org')]
```
