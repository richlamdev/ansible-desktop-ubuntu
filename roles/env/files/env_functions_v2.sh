###########################################################################
#                                                                         #
# Script: env_functions.sh                                                #
#                                                                         #
# Description: This script is used to set the PS1 variable for dynamic    #
#              prompt colorization and format.                            #
#                                                                         #
# Usage: Source the script in your .profile and then call the function    #
#        from the .profile to set the prompt to the one you like.         #
#        Remember to add the directory with this script and the title     #
#        script to your PATH. (If you have both bin and functions         #
#        directories, you can add the example code to you .profile after  #
#        place this script in functions and the title script in bin.)     #
#                                                                         #
# Example: PATH=$PATH:$HOME/bin:$HOME/functions                           #
#          . ~/functions/env_functions.sh                                 #
#          mixed_ps                                                       #
#                                                                         #
# Issues: The only issue that I know of is that when you do not have any  #
#         database environment variables initialized, you will not be     #
#         able to have the prompt dynamically update after you initialize #
#         the variable. Once you initialize the database variable you     #
#         will need to run the ps function on the cmd line to see the     #
#         database variable in the prompt.                                #
#                                                                         #
# Example: export ORACLE_SID=db1                                          #
#          mixed_ps                                                       #
#                                                                         #
#*************************************************************************#
#                                                                         #
# History                                                                 #
# Author              Date        Description                             #
#-------------------------------------------------------------------------#
# David ******        05/30/2007  Created/Added comments                  #
# Richard Lam         11/21/2021  Modified mixed_ps                       #
#                                 Added "dtm24Y" format                   #
#                                 Added colorgrid function to             #
#                                 display all colors at prompt            #
#                                                                         #
###########################################################################

###########################################################################
# Set the variables that are used in the script.                          #
#                                                                         #
# Note: To create the special character , use the control v and [ keys. #
#                                                                         #
###########################################################################
export NO_CLR=[0m
export CLR_GREEN_TEST=[32m
export CLR_BLACK=[30m
export CLR_GRAY=[30\;1m
export CLR_RED=[31m
export CLR_LGHTRED=[31\;1m
export CLR_GREEN=[32m
export CLR_LGHTGRN=[32\;1m
export CLR_YELLOW=[33m
export CLR_LGHTYLLW=[33\;1m
export CLR_BLUE=[34m
export CLR_LGHTBLUE=[34\;1m
export CLR_MGNT=[35m
export CLR_LGHTMGNT=[35\;1m
export CLR_CYAN=[36m
export CLR_LGHTCYAN=[36\;1m
export CLR_WHITE=[37m
export CLR_LGHTWHITE=[37\;1m
export CLR_LGHTPINK207="\[\033[01;38;5;207m\]"
export CLR_YELLOW226="\[\033[01;38;5;226m\]"
export CLR_BLUE027="\[\033[01;38;5;027m\]"

###########################################################################
# Function: dbinstance_fn                                                 #
#                                                                         #
# Description: This function determines what database variables are set   #
#              and then displays them with color depending on what        #
#              database environment it is.                                #
#                                                                         #
###########################################################################
dbinstance_fn () {
	local DBINSTNCS="$ORACLE_SID $INFORMIXSERVER"
	local WCCNT=`echo $DBINSTNCS | wc -w`
	local ITCNT=0
	for DBVAR in $DBINSTNCS
	do
      if [ `echo $DBVAR | egrep '(xa|xl|xd|dev|qa|tst|test)'` ];then
         printf "${NO_CLR}${PSDBDEVCLR} ${DBVAR}${NO_CLR}${PSDELIMCLR}"
      elif [ `echo $DBVAR | egrep '(xp|prod|madison)'` ];then
         printf "${NO_CLR}${PSDBPRDCLR} ${DBVAR}${NO_CLR}${PSDELIMCLR}"
      else
         printf "${NO_CLR}${PSDBTSTCLR} ${DBVAR}${NO_CLR}${PSDELIMCLR}"
		fi
		((ITCNT=ITCNT+1))
		if [ $WCCNT -gt 1 ] && [ $ITCNT -lt $WCCNT ];then
			printf " ${PSDELIMSEP}"
		fi
	done
}

###########################################################################
# Function: who_where_fn                                                  #
#                                                                         #
# Description: This function determines who I am and where. If I am       #
#              a special user it will use color to highlight and if I am  #
#              on a production server it will use color to highlight.     #
#                                                                         #
###########################################################################
who_where_fn () {
		WHATSERVER=`hostname`
      if [ `echo ${WHATSERVER} | egrep '(xl|xd|qa|tst|test)'` ];then
         WHATSRVCLR="${NO_CLR}${PSDBDEVCLR}${WHATSERVER}${NO_CLR}"
      elif [ `echo ${WHATSERVER} | egrep '(xp|prod)'` ] || [ ${WHATSERVER} == "madison" ];then
         WHATSRVCLR="${NO_CLR}${PSDBPRDCLR}${WHATSERVER}${NO_CLR}"
      else
         WHATSRVCLR="${NO_CLR}${WHATSERVER}${NO_CLR}"
         #WHATSRVCLR="${CLR_LGHTPINK207}${WHATSERVER}" # changed default to pink
		fi
		WHOAMI=`/usr/bin/whoami`
      if [ `echo ${WHOAMI} | egrep '(root|informix|oracle)'` ];then
         WHOAMICLR="${NO_CLR}${PSDBPRDCLR}${WHOAMI}${NO_CLR}"
      else
         #WHOAMICLR="${NO_CLR}${WHOAMI}${NO_CLR}"
         WHOAMICLR="${WHOAMI}"                 # changed default value indicated in mixed_ps
		fi
}

###########################################################################
# Function: title_fn                                                      #
#                                                                         #
# Description: This function sets the title of the window.                #
#                                                                         #
###########################################################################
title_fn () {
	#xtitle `hostname` : '`date "+%a %b %d,h %I:%M:%S%p"`'
	xtitle `hostname` : '`date "+%a %e %b %Y  %R %Z"`  ' `pwd`
}

###########################################################################
# Function: wrapper_fn                                                    #
#                                                                         #
# Description: This function wraps the appropriate color and format       #
#              around the information to be displayed.                    #
#                                                                         #
###########################################################################
wrapper_fn () {
	CMDVAR=$1
	local ITCNT=$2
	local WCCNT=$3

	if [ $WCCNT -gt 1 ] && [ $ITCNT -le $WCCNT ] && [ $ITCNT -gt 1 ] && [ $STACKED == "YES" ];then
		PS1=${PS1}${NO_CLR}${PSDELIMENDCLR}${PSDELIMLFTEND}
	fi

   PS1=${PS1}${CMDVAR}\ ${NO_CLR}${PSDELIMCLR}

	if [ "$STACKED" == "YES" ] && [ $ITCNT -lt $WCCNT ];then
		PS1=${PS1}${NO_CLR}${PSDELIMENDCLR}${PSDELIMRGHTEND}"\n"
	fi

	if [ $WCCNT -gt 1 ] && [ $ITCNT -lt $WCCNT ] && [ $STACKED == "NO" ];then
		PS1=${PS1}${NO_CLR}${PSDELIMCLR}${PSDELIMSEP}
	elif [ $ITCNT -eq $WCCNT ];then
		PS1=${PS1}${NO_CLR}${PSDELIMENDCLR}${PSDELIMRGHTEND}${NO_CLR}
	fi
}

###########################################################################
# Function: frmtps_fn                                                     #
#                                                                         #
# Description: This function is the part that determines what needs to be #
#              done and does it.                                          #
#                                                                         #
###########################################################################
frmtps_fn () {
	local WCCNT=$#
	local ITCNT=0
	#PS1=${PS1}${PSDELIMENDCLR}${PSDELIMLFTEND}${NO_CLR}`title_fn`
	PS1=${PS1}${PSDELIMENDCLR}${PSDELIMLFTEND}${NO_CLR}

	for optvalue in $@
   do
		((ITCNT=ITCNT+1))
      case "$optvalue" in
         "shrtdt")
            wrapper_fn ${NO_CLR}${PSTIMECLR}" \d" $ITCNT $WCCNT
				;;
         "lngdt")
            wrapper_fn ${NO_CLR}${PSTIMECLR}" \d, \\@" $ITCNT $WCCNT
				;;
         "24tm")
            wrapper_fn ${NO_CLR}${PSTIMECLR}" \t" $ITCNT $WCCNT
				;;
         "dtm24")
            wrapper_fn ${NO_CLR}${PSTIMECLR}" \d, \t" $ITCNT $WCCNT
				;;
         "tmap")
            wrapper_fn ${NO_CLR}${PSTIMECLR}" \\@" $ITCNT $WCCNT
				;;
         "hist")
            wrapper_fn ${NO_CLR}${PSTIMECLR}" CMD Number: \!" $ITCNT $WCCNT
				;;
         "shll")
            wrapper_fn ${NO_CLR}${PSTIMECLR}" Current Shell: \s" $ITCNT $WCCNT
				;;
         "whsrv")
				who_where_fn
            wrapper_fn " ${NO_CLR}${PSWHOCLR}${WHOAMICLR}"${NO_CLR}${PSWDCLR}@${NO_CLR}${WHATSRVCLR} $ITCNT $WCCNT
				;;
         "dbval")
				if [ $ORACLE_SID ] || [ $INFORMIXSERVER ];then
				   wrapper_fn \`dbinstance_fn\` $ITCNT $WCCNT
				fi
            ;;
         "pwdir")
            wrapper_fn " "${NO_CLR}${PSWDCLR}'$PWD' $ITCNT $WCCNT
				;;
         "dtm24Y")
            wrapper_fn ${NO_CLR}${PSTIMECLR}" '\D{%d%b%Y %R %Z}'" $ITCNT $WCCNT
				;;
         *)
            ;;
      esac
   done
	export PS1=${PS1}${NO_CLR}"\n\$ "
}

function colorgrid () {
# added to display color palette
    iter=16
    while [ $iter -lt 52 ]
    do
        second=$[$iter+36]
        third=$[$second+36]
        four=$[$third+36]
        five=$[$four+36]
        six=$[$five+36]
        seven=$[$six+36]
        if [ $seven -gt 250 ];then seven=$[$seven-251]; fi

        echo -en "\033[38;5;$(echo $iter)m█ "
        printf "%03d" $iter
        echo -en "   \033[38;5;$(echo $second)m█ "
        printf "%03d" $second
        echo -en "   \033[38;5;$(echo $third)m█ "
        printf "%03d" $third
        echo -en "   \033[38;5;$(echo $four)m█ "
        printf "%03d" $four
        echo -en "   \033[38;5;$(echo $five)m█ "
        printf "%03d" $five
        echo -en "   \033[38;5;$(echo $six)m█ "
        printf "%03d" $six
        echo -en "   \033[38;5;$(echo $seven)m█ "
        printf "%03d" $seven

        iter=$[$iter+1]
        printf '\r\n'
    done
}

###########################################################################
# Function: Various format functions                                      #
#                                                                         #
# Description: The following set of functions are used to set the color   #
#              and format of the prompt. Copy and/or edit these to create #
#              custom prompts.                                            #
#                                                                         #
# Variables: PSWHOCLR          - Whoami@servername color.                 #
#            PSTIMECLR         - Time and date color.                     #
#            PSWDCLR           - Working directory color.                 #
#            PSDELIMCLR        - Separation delimiter color.              #
#            PSDELIMENDCLR     - End delimiter color.                     #
#            PSDELIMSEP        - Separation delimiter.                    #
#            PSDELIMRGHTEND    - Delimeter for the right end of the       #
#                                prompt string.                           #
#            PSDELIMLFTEND     - Delimeter for the left end of the        #
#                                prompt string.                           #
#            PSDBDEVCLR        - Development database variable color.     #
#            PSDBTSTCLR        - Test database variable color.            #
#            PSDBPRDCLR        - Production database variable color.      #
#            STACKED           - Stack the prompt strings YES or NO.      #
#                                                                         #
# Command parameters: whsrv  - Print whoami@servername in prompt.         #
#                     dbval  - Print database variable in prompt.         #
#                     lngdt  - Print long date and time in prompt.        #
#                     shrtdt - Print only the date in prompt.             #
#                     pwdir  - Print the working directroy in prompt.     #
#                     24tm   - Print the time in 24 hour format.          #
#                     dtm24  - Print the date with time in 24hr format.   #
#                     tmap   - Print the time in am pm format.            #
#                     hist   - Print the number of current commnad.       #
#                     shll   - Print the current shell.                   #
#                                                                         #
# Usage: Command parameters can be excluded for a shorter prompt string   #
#        or included as you like. The order that the command parameters   #
#        are passed to the frmtps_fn function are the order that they     #
#        appear in the prompt string. Once this script has been sourced   #
#        you can run any of the functions from the command line to change #
#        your prompt.                                                     #
#                                                                         #
# Examples: See the ps functions below for working examples.              #
#                                                                         #
###########################################################################
#mixed_ps () {
	#export PS1=
	#export PSWHOCLR=$CLR_YLLW
	#export PSTIMECLR=$CLR_CYAN
	#export PSWDCLR=$CLR_YELLOW
	#export PSDELIMCLR=$CLR_LGHTYLLW
	#export PSDELIMENDCLR=$CLR_LGHTYLLW
	#export PSDELIMSEP=:
	#export PSDELIMRGHTEND=]
	#export PSDELIMLFTEND=[
	#export PSDBDEVCLR=$CLR_CYAN
	#export PSDBTSTCLR=$CLR_LGHTBLUE
	#export PSDBPRDCLR=$CLR_RED
	#export STACKED=NO
	#frmtps_fn whsrv dbval lngdt pwdir
#}

mixed_ps () {
	export PS1=
	export PSWHOCLR=$CLR_BLUE027
	export PSTIMECLR=$CLR_CYAN
	export PSWDCLR=$CLR_YELLOW226
	export PSDELIMCLR=$CLR_LGHTYLLW
	export PSDELIMENDCLR=$CLR_LGHTYLLW
	export PSDELIMSEP=:
	export PSDELIMRGHTEND=]
	export PSDELIMLFTEND=[
	export PSDBDEVCLR=$CLR_CYAN
	export PSDBTSTCLR=$CLR_LGHTBLUE
	export PSDBPRDCLR=$CLR_RED
	export STACKED=NO
	frmtps_fn whsrv dbval dtm24Y pwdir
}
green_ps () {
	export PS1=
	export PSWHOCLR=$CLR_GREEN
	export PSTIMECLR=$CLR_GREEN
	export PSWDCLR=$CLR_GREEN
	export PSDELIMCLR=$CLR_LGHTYLLW
	export PSDELIMSEP=:
	export PSDELIMENDCLR=$CLR_LGHTGREEN
	export PSDELIMRGHTEND=]
	export PSDELIMLFTEND=[
	export PSDBDEVCLR=$CLR_CYAN
	export PSDBTSTCLR=$CLR_LGHTBLUE
	export PSDBPRDCLR=$CLR_RED
	export STACKED=YES
	frmtps_fn whsrv dbval lngdt pwdir
}

red_ps () {
	export PS1=
	export PSWHOCLR=$CLR_RED
	export PSTIMECLR=$CLR_RED
	export PSWDCLR=$CLR_RED
	export PSDELIMCLR=$CLR_LGHTRED
	export PSDELIMENDCLR=$CLR_LGHTRED
	export PSDELIMSEP="|"
	export PSDELIMRGHTEND="-+)]"
	export PSDELIMLFTEND="[(+-"
	export PSDBDEVCLR=$CLR_CYAN
	export PSDBTSTCLR=$CLR_LGHTBLUE
	export PSDBPRDCLR=$CLR_RED
	export STACKED=NO
	frmtps_fn whsrv lngdt dbval pwdir
}

blue_ps () {
	export PS1=
	export PSWHOCLR=$CLR_BLUE
	export PSTIMECLR=$CLR_BLUE
	export PSWDCLR=$CLR_BLUE
	export PSDELIMCLR=$CLR_LGHTYLLW
	export PSDELIMENDCLR=$CLR_LGHTBLUE
	export PSDELIMSEP="*"
	export PSDELIMRGHTEND="]]"
	export PSDELIMLFTEND="[["
	export PSDBDEVCLR=$CLR_CYAN
	export PSDBTSTCLR=$CLR_LGHTBLUE
	export PSDBPRDCLR=$CLR_RED
	export STACKED=NO
	frmtps_fn whsrv dbval shrtdt pwdir
}

cyan_ps () {
	export PS1=
	export PSWHOCLR=$CLR_CYAN
	export PSTIMECLR=$CLR_CYAN
	export PSWDCLR=$CLR_CYAN
	export PSDELIMCLR=$CLR_LGHTYLLW
	export PSDELIMENDCLR=$CLR_LGHTCYAN
	export PSDELIMSEP="-"
	export PSDELIMRGHTEND="-[34;1m+[35m*"
	export PSDELIMLFTEND="[35m*[34;1m+[36m-"
	export PSDBDEVCLR=$CLR_CYAN
	export PSDBTSTCLR=$CLR_LGHTBLUE
	export PSDBPRDCLR=$CLR_RED
	export STACKED=NO
	frmtps_fn whsrv shrtdt dbval pwdir
}

function patriot_ps (){
	export PS1="[44m*****[41m        [0m\n[44m*****[47m        [0m\n[44m*****[41m        [0m\n[47m             [0m\n[41m             [0m\n"
	export PSWHOCLR=$CLR_RED
	export PSTIMECLR=$CLR_LGHTWHITE
	export PSWDCLR=$CLR_RED
	export PSDELIMCLR=$CLR_LGHTBLUE
	export PSDELIMENDCLR=$CLR_LGHTBLUE
	export PSDELIMSEP=:
	export PSDELIMRGHTEND=]
	export PSDELIMLFTEND=[
	export PSDBDEVCLR=$CLR_CYAN
	export PSDBTSTCLR=$CLR_LGHTBLUE
	export PSDBPRDCLR=$CLR_RED
	export STACKED=YES
	frmtps_fn whsrv dbval lngdt pwdir
}
