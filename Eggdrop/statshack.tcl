######################
# StatsMod Hack v1.0 #
######################
# THIS IS NOT WORKING AS EXPECTED! USE AT YOUR OWN RISK! YOU HAVE BEEN WARNED!!!
#
# This script is a way to provide tracking stats by nickname, while that function isn't on the module itself.
# I've done it to personal use, so don't expect it to be a super script! :D :P
# It's advisable to edit it to fit your needs
# In order to use this script you have to do a few changes on your stats.conf. They're the following:
#
## set autoadd -1
## set use-eggdrop-userfile 1
## set anti-autoadd-flags "mnofvb-|mnofvb-"
## set anti-stats-flag "b|b"
#
# Enjoy!

### Configuration ###
# How many minutes between each add user check?
set checktime "2"
set hostfixtime "5"

# List of badnicks that shouldn't be added
set badnicks {ChanServ}

### End of configuration ###

### Binds ###
# Adding users to the userfile
bind cron - "*/$checktime * * * *" addstats
bind cron - "*/$hostfixtime * * * *" hostfix

# Fixing user hosts (only for non global mno)


# Adding new nicks upon nick change to userfile
bind nick - "*" addnew
### End of Binds ###

### Procedures ###
# Proc off adding nicks
proc addstats {minute hour day month weekday} {
	global badnicks botnick
	foreach chan [channels] {
		foreach user [chanlist $chan] {
			if {![validuser $user]} {
				set isnick 0
				foreach check $badnicks {
					if {![string match -nocase "$check" $user]} {
						continue
					}
					if {[string match -nocase "$check" $user] || [string match -nocase $botnick $user]} {
						set isnick 1
						break
					}
				}
				if {!$isnick} {
					adduser $user ${user}!*@*
				}
			}
		}
	}
}

# Proc off adding new nicks
proc addnew {nick uhost hand chan newnick} {
	global badnicks botnick
	if {![validuser $newnick]} {
		set isnick 0
		foreach check $badnicks {
			if {![string match -nocase "$check" $newnick]} {
				continue
			}
			if {[string match -nocase "$check" $newnick] || [string match -nocase $botnick $newnick]} {
				set isnick 1
				break
			}
		}
		if {!$isnick} {
			adduser $newnick ${newnick}!*@*
		}
	}
}

# Proc of fixing hosts
proc hostfix {minute hour day month weekday} {
	foreach fix [userlist] {
		if {![matchattr [nick2hand $fix] mno]} {
			setuser $fix HOSTS ${fix}!*@*
		}
	}
	return 0
}

### End of procedures ###

putlog "StatsMod Hack 27/07/2019 loaded"

#################
# End of Script #
#################
