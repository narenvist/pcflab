#!/usr/bin/env bash

set -x


target="cf api $API_ENDPOINT --skip-ssl-validation"
#echo $target
eval $target

echo "Login....."
login="cf auth $USERNAME $PASSWORD"
#echo $login
eval $login

echo "Target Org and Space"
org_space="cf target -o $ORG -s $SPACE"
eval $org_space

applications=`cat pcflab/start-apps/app-list.json | jq -r '.[].application'`

echo "$CF_SUB_COMMAND the app"

for app in $applications
do
	cf $CF_SUB_COMMAND $app &
done

for app in $applications
do
	STATUS=`cf app $app | tail -n 1 | awk '{print $2}'`
    	i=1
	while [ $i -le $COUNT ] 
	do			
		if [ $STATUS != "running" ]
		then
			echo -e "App is down\n"
			if [ $i == $COUNT ]
			then
				echo "Triggering a mail to :EIAP Alerts (ITEIAPALERTS@pepsico.com)"
				#mail -s "CRITICAL: Automation to bring up app failed for $app app" ITEIAPALERTS@pepsico.com  <<< "automation to bring up this $app app got failed"
				break
			else
				#mail -s "Warning Attempt:$iteration to start $app app failed"  ITEIAPALERTS@pepsico.com  <<< "automation to bring up this $app app got failed"
				echo "For Iteration:$i restarting app $app"
				cf $CF_SUB_COMMAND $app
				#continue
			fi
		else
			echo "$app is up and running"
			break
		fi
		i=$(( $i+1 ))
	done
done
