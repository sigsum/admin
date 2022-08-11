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


2022-08-05 in #mailman@Libera.Chat
```
<ln5> hi all, have anyone of you experienced erroneous moderation due to
      implicit destination when posting with To: "long string with spaces, 76
      chars will do" <list address>?				        [09:05]
<ln5> i tracked it down to mailman/src/mailman/rules/implicit_dest.py and
      verified that mail.utils.getaddresses() at least doesn't get things
      wrong, so i guess it might be the msg.get_all(header, []) that's borken
								        [09:07]
<ln5> now, to debug this what's a decent option? simply editing
      /usr/lib/python3/dist-packages/mailman/rules/implicit_dest.py (i'm on
      debian11, with the mailman3 package installed) and adding print()'s? or
      what do you suggest?					        [09:10]
<ln5> to further incite you to care about this, the case is a real one: the
      dmarc mitigation strategy of rewriting the address part of From: to the
      list address and composing a fullname part indiciating whoe the sender
      is can generate a From: header which is then used as To: in a reply
```
