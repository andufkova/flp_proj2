#!/bin/bash 

#-------------------------------------#
#----- FIT VUT ------ Tomáš Ryšavý ---#
#--- Projekt FLP ------ xrysav27 -----#
#---- Skeletons ----- 14. 04. 2021 ---#
#-------------------------------------#

# Sript will perform all the test in 
# this folder.
# To make this script working the folder 
# structure must look like this:

# project_folder/
# ├── tests/
# │   ├── run_tests.sh
# │   ├── test1.in
# │   ├── test1.out
# │   ├── test2.in
# │   ├── test2.out
# │   └── •••
# └── kry

GREEN='\033[1;32m'
CYAN='\033[0;36m'
RED='\033[1;31m'
YELLOW='\033[0;33m'
NC='\033[0;m'

APP="../flp21-log"
TESTCOUNT=`ls -l ./*.in | wc -l`
TEMPFILE="test.temp"
TESTVARIANTS=(1 2)
# percent of friedman tolerance in decimal number
FRIEDMANTOLERANCE="0.2"

PASSEDTESTS=0
FAILEDTESTS=0
for TESTNO in $(seq 1 ${TESTCOUNT}); do
	FILE="test${TESTNO}.in"
	OUTFILE="test${TESTNO}.out"
    echo -e "\n${GREEN}### TEST No. ${TESTNO} ###"
    echo -e "${NC}# Script output: ${APP} < ${FILE}${RED}"
    `time ${APP} < ${FILE} > ${TEMPFILE}`

    # LOAD FILES
    #############
	
    printf -v ESC_FILE_IN "%q\n" ${FILE}
  	IFS=$'\r\n' GLOBIGNORE='*' command eval  'ESC_FILE_IN_ARRAY=($(cat ${ESC_FILE_IN}))'

    printf -v ESC_TEMP_FILE "%q\n" ${TEMPFILE}
  	IFS=$'\r\n' GLOBIGNORE='*' command eval  'ESC_TEMP_FILE_ARRAY=($(cat ${ESC_TEMP_FILE}))'

    printf -v ESC_OUT_FILE "%q\n" ${OUTFILE}
  	IFS=$'\r\n' GLOBIGNORE='*' command eval  'ESC_OUT_FILE_ARRAY=($(cat ${ESC_OUT_FILE}))'
	
	##############################################################

	#printf "%s\n" "${ESC_OUT_FILE_ARRAY[@]}"
	#echo "##########################"

	WHOLE_FILE=""
	for LINE in "${ESC_OUT_FILE_ARRAY[@]}"
	do
		: 	
  		IFS=$' ' GLOBIGNORE='*' command eval 'EDGES=($(echo ${LINE}))'
		#IFS=$'\n' SORTED_EDGES=($(sort <<<"${EDGES[*]}")); unset IFS	
		WHOLE_LINE=""
		for EDGE in "${EDGES[@]}"
		do
			: 
			IFS=$'-' read -a POINT_ARRAY <<< "${EDGE}"
			POINTS=(${POINT_ARRAY[@]})	
			IFS=$'\n' SORTED_POINTS_ARRAY=($(sort <<<"${POINT_ARRAY[*]}")); unset IFS	
			SORTED_POINTS=""
			for POINT in "${SORTED_POINTS_ARRAY[@]}"
			do
				: 	
				SORTED_POINTS=$SORTED_POINTS$POINT
			done
			
			if [ -z "$WHOLE_LINE" ]; then
				WHOLE_LINE=$SORTED_POINTS
			else 
				WHOLE_LINE=$WHOLE_LINE"_"$SORTED_POINTS
			fi
		done

		IFS=$'_' read -a WHOLE_LINE_ARRAY <<< "${WHOLE_LINE}"
		IFS=$'\n' SORTED_POINTS_EDGES=($(sort <<<"${WHOLE_LINE_ARRAY[*]}")); unset IFS	

		SORTED_WHOLE_LINE=""
		for EDGE in "${SORTED_POINTS_EDGES[@]}"
		do
			if [ -z "$SORTED_WHOLE_LINE" ]; then
				SORTED_WHOLE_LINE=$EDGE
			else 
				SORTED_WHOLE_LINE=$SORTED_WHOLE_LINE"_"$EDGE
			fi
		done

		if [ -z "$WHOLE_FILE" ]; then
			WHOLE_FILE=$SORTED_WHOLE_LINE
		else 
			WHOLE_FILE=$WHOLE_FILE"-"$SORTED_WHOLE_LINE
		fi
	done

	IFS='-' read -r -a WHOLE_FILE_ARRAY <<< "$WHOLE_FILE"
	IFS=$'\n' SORTED_WHOLE_FILE=($(sort <<<"${WHOLE_FILE_ARRAY[*]}")); unset IFS	

	OUT_FILE_REPRESENTATION=""
	for LINE in "${SORTED_WHOLE_FILE[@]}"
	do
		: 	
		if [ -z "$OUT_FILE_REPRESENTATION" ]; then
			OUT_FILE_REPRESENTATION=$LINE
		else 
			OUT_FILE_REPRESENTATION=$OUT_FILE_REPRESENTATION"-"$LINE
		fi
	done

	#printf "%s\n" "${OUT_FILE_REPRESENTATION}"

	#############################################################
	#############################################################


	WHOLE_FILE=""
	for LINE in "${ESC_TEMP_FILE_ARRAY[@]}"
	do
		: 	
  		IFS=$' ' GLOBIGNORE='*' command eval 'EDGES=($(echo ${LINE}))'
		#IFS=$'\n' SORTED_EDGES=($(sort <<<"${EDGES[*]}")); unset IFS	
		WHOLE_LINE=""
		for EDGE in "${EDGES[@]}"
		do
			: 
			IFS=$'-' read -a POINT_ARRAY <<< "${EDGE}"
			POINTS=(${POINT_ARRAY[@]})	
			IFS=$'\n' SORTED_POINTS_ARRAY=($(sort <<<"${POINT_ARRAY[*]}")); unset IFS	
			SORTED_POINTS=""
			for POINT in "${SORTED_POINTS_ARRAY[@]}"
			do
				: 	
				SORTED_POINTS=$SORTED_POINTS$POINT
			done
			
			if [ -z "$WHOLE_LINE" ]; then
				WHOLE_LINE=$SORTED_POINTS
			else 
				WHOLE_LINE=$WHOLE_LINE"_"$SORTED_POINTS
			fi
		done

		IFS=$'_' read -a WHOLE_LINE_ARRAY <<< "${WHOLE_LINE}"
		IFS=$'\n' SORTED_POINTS_EDGES=($(sort <<<"${WHOLE_LINE_ARRAY[*]}")); unset IFS	

		SORTED_WHOLE_LINE=""
		for EDGE in "${SORTED_POINTS_EDGES[@]}"
		do
			if [ -z "$SORTED_WHOLE_LINE" ]; then
				SORTED_WHOLE_LINE=$EDGE
			else 
				SORTED_WHOLE_LINE=$SORTED_WHOLE_LINE"_"$EDGE
			fi
		done
		
		if [ -z "$WHOLE_FILE" ]; then
			WHOLE_FILE=$SORTED_WHOLE_LINE
		else 
			WHOLE_FILE=$WHOLE_FILE"-"$SORTED_WHOLE_LINE
		fi
	done

	IFS='-' read -r -a WHOLE_FILE_ARRAY <<< "$WHOLE_FILE"
	IFS=$'\n' SORTED_WHOLE_FILE=($(sort <<<"${WHOLE_FILE_ARRAY[*]}")); unset IFS	

	TEMP_FILE_REPRESENTATION=""
	for LINE in "${SORTED_WHOLE_FILE[@]}"
	do
		: 	
		if [ -z "$TEMP_FILE_REPRESENTATION" ]; then
			TEMP_FILE_REPRESENTATION=$LINE
		else 
			TEMP_FILE_REPRESENTATION=$TEMP_FILE_REPRESENTATION"-"$LINE
		fi
	done

	#printf "%s\n" "${TEMP_FILE_REPRESENTATION}"

	#############################################################################
	
	DIF=`diff <(echo ${TEMP_FILE_REPRESENTATION[@]}) <(echo ${OUT_FILE_REPRESENTATION[@]})`

	echo $DIF

    PRINT_IF_AS_EXPECTED=true # true
    ONE="1"
    ZERO="0"
    # RESULTS
	if [ -z "$DIF" ]; then
		if [ "$PRINT_IF_AS_EXPECTED" == "true" ]; then
			echo -e "${NC}TEST CASE"
			echo "-----------------"
				printf "%s\n" "${ESC_FILE_IN_ARRAY[@]}"
	    		printf "%s\n" "${ESC_OUT_FILE_ARRAY[@]}"
			echo ""
			echo "-----------------"
	    	fi

		echo -e "${NC}Result:$GREEN OK $NC"
		PASSEDTESTS=$((PASSEDTESTS+1))
	else
		echo ""
		echo -e "${NC}TEST CASE"
		echo "-----------------"
			printf "%s\n" "${ESC_FILE_IN_ARRAY[@]}"
			echo ""
		echo -e "${NC}EXPECTED"
		echo "-----------------"
	    	printf "%s\n" "${ESC_OUT_FILE_ARRAY[@]}"

		echo ""
		echo "YOUR OUTPUT"
		echo "-----------------"
	    	printf "%s\n" "${ESC_TEMP_FILE_ARRAY[@]}"
		echo ""
		echo "-----------------"
		
		FAILEDTESTS=$((FAILEDTESTS+1))
	fi
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
done
echo -e "FINAL RESULTS: $GREEN PASSED: $PASSEDTESTS $RED FAILED: ${FAILEDTESTS} $NC"
`rm test.temp`
