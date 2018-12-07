passphrases10.gpg: passphrases10
	gpg -er 0x1E8BF34923291265 $^
	shred -zun 13 $^
passphrases20.gpg: passphrases20
	gpg -c --cipher-algo AES256 $^
	shred -zun 13 $^
passphrases20: 
	gpg -do - passphrases20.gpg | head -1 > $@
	gpg -do - passphrases10.gpg | egrep --text '^t ' >> $@

	
