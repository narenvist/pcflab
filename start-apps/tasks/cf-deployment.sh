#!/usr/bin/env bash
set -x
COUNT=4

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
                for iteration in $(seq 1 $COUNT)
                do 
                         cf $CF_SUB_COMMAND $app
                         STATUS=`cf app $app|grep -e "requested state:"|awk '{print  $3}'`
                         if [[ $STATUS == "stopped" ]]
                         then
                                echo -e "App is down\n"			
                                if [[ $iteration == $COUNT ]]
                                then
                                        echo "Triggering a mail to user :ravanaiah (ravanaiahweblogic@gail.com)"
                                        #mail -s "CRITICAL: Automation to bring up app failed for $app app" kishore.ponnuru.contractor@pepsico.com <<< "automation to bring up this $app app got failed"
                                        break
                                fi
                                mail -s "Warning Attempt:$j to start $app app failed"  kishore.ponnuru.contractor@pepsico.com <<< "automation to bring up this $app app got failed"
				cf $CF_SUB_COMMAND $app
                                continue
                          else
                                echo "$app is up and running"
                                break
                          fi
                   done
          done         
                
