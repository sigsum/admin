# This was done on 2023-04-23

## Setting up YK5C-31, the nano

leguin:~% ~/.cargo/bin/age-plugin-yubikey
✨ Let's get your YubiKey set up for age! ✨

This tool can create a new age identity in a free slot of your YubiKey.
It will generate an identity file that you can use with an age client,
along with the corresponding recipient. You can also do this directly
with:
    age-plugin-yubikey --generate

If you are already using a YubiKey with age, you can select an existing
slot to recreate its corresponding identity file and recipient.

When asked below to select an option, use the up/down arrow keys to
make your choice, or press [Esc] or [q] to quit.

🔑 Select a YubiKey: Yubico YubiKey OTP+FIDO+CCID 00 00 (Serial: 16383131)
🕳️  Select a slot for your age identity: Slot 1 (Empty)
📛 Name this identity [age identity TAG_HEX]: passage
🔤 Select a PIN policy: Once   (A PIN is required once per session, if set)
👆 Select a touch policy: Always (A physical touch is required for every decryption)
Generate new identity in slot 1? yes

🎲 Generating key...

Enter PIN for YubiKey with serial 16383131 (default is 123456): [hidden]

✨ Your YubiKey is using the default PIN. Let's change it!
✨ We'll also set the PUK equal to the PIN.

🔐 The PIN can be numbers, letters, or symbols. Not just numbers!
📏 The PIN must be at least 6 and at most 8 characters in length.
❌ Your keys will be lost if the PIN and PUK are locked after 3 incorrect tries.

Enter current PUK (default is 12345678): [hidden]
Choose a new PIN/PUK: [hidden]

✨ Your YubiKey is using the default management key.
✨ We'll migrate it to a PIN-protected management key.
... Success!

🔏 Generating certificate...
👆 Please touch the YubiKey

📝 File name to write this identity to: age-yubikey-identity-1f5dda61.txt

✅ Done! This YubiKey identity is ready to go.

🔑 Here's your shiny new YubiKey recipient:
  age1yubikey1qgad8tvv2y97zflqndlnms0ajtk7my54u9299v6ep5jrgpm08rtdjt6sus7

Here are some example things you can do with it:

- Encrypt a file to this identity:
  $ cat foo.txt | age -r age1yubikey1qgad8tvv2y97zflqndlnms0ajtk7my54u9299v6ep5jrgpm08rtdjt6sus7 -o foo.txt.age

- Decrypt a file with this identity:
  $ cat foo.txt.age | age -d -i age-yubikey-identity-1f5dda61.txt > foo.txt

- Recreate the identity file:
  $ age-plugin-yubikey -i --serial 16383131 --slot 1 > age-yubikey-identity-1f5dda61.txt

- Recreate the recipient:
  $ age-plugin-yubikey -l --serial 16383131 --slot 1

## Setting up YK5C-47, the large with NFC
leguin:~% age-plugin-yubikey
✨ Let's get your YubiKey set up for age! ✨

This tool can create a new age identity in a free slot of your YubiKey.
It will generate an identity file that you can use with an age client,
along with the corresponding recipient. You can also do this directly
with:
    age-plugin-yubikey --generate

If you are already using a YubiKey with age, you can select an existing
slot to recreate its corresponding identity file and recipient.

When asked below to select an option, use the up/down arrow keys to
make your choice, or press [Esc] or [q] to quit.

🔑 Select a YubiKey: Yubico YubiKey OTP+FIDO+CCID 01 00 (Serial: 15427547)
🕳️  Select a slot for your age identity: Slot 1 (Empty)
📛 Name this identity [age identity TAG_HEX]: passage
🔤 Select a PIN policy: Once   (A PIN is required once per session, if set)
👆 Select a touch policy: Always (A physical touch is required for every decryption)
Generate new identity in slot 1? yes

🎲 Generating key...

Enter PIN for YubiKey with serial 15427547 (default is 123456): [hidden]

✨ Your YubiKey is using the default PIN. Let's change it!
✨ We'll also set the PUK equal to the PIN.

🔐 The PIN can be numbers, letters, or symbols. Not just numbers!
📏 The PIN must be at least 6 and at most 8 characters in length.
❌ Your keys will be lost if the PIN and PUK are locked after 3 incorrect tries.

Enter current PUK (default is 12345678): [hidden]
Choose a new PIN/PUK: [hidden]

✨ Your YubiKey is using the default management key.
✨ We'll migrate it to a PIN-protected management key.
... Success!

🔏 Generating certificate...
👆 Please touch the YubiKey

📝 File name to write this identity to: age-yubikey-identity-24e5dcc5.txt

✅ Done! This YubiKey identity is ready to go.

🔑 Here's your shiny new YubiKey recipient:
  age1yubikey1qfkztjuhkfjr3mssnfq8su84n3slpvltxh2f4epmxfx26jjt4gwfcwe9mss

Here are some example things you can do with it:

- Encrypt a file to this identity:
  $ cat foo.txt | rage -r age1yubikey1qfkztjuhkfjr3mssnfq8su84n3slpvltxh2f4epmxfx26jjt4gwfcwe9mss -o foo.txt.age

- Decrypt a file with this identity:
  $ cat foo.txt.age | rage -d -i age-yubikey-identity-24e5dcc5.txt > foo.txt

- Recreate the identity file:
  $ age-plugin-yubikey -i --serial 15427547 --slot 1 > age-yubikey-identity-24e5dcc5.txt

- Recreate the recipient:
  $ age-plugin-yubikey -l --serial 15427547 --slot 1

💭 Remember: everything breaks, have a backup plan for when this YubiKey does.
