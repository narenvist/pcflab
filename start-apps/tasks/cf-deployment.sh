#!/usr/bin/env bash
set -x
COUNT=5

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

restart_fun(){
        echo "cf $CF_SUB_COMMAND $app"
        }

for app in $applications
        do
                eval "cf $CF_SUB_COMMAND $app"
                status=$(cf app $app  | grep 'requested state:'| awk '{print $3}')

        if [ "$STATUS" = "started" ]
        then
                echo "$app is started"
                break
        else
                echo "$STATUS"
                echo "App not started, trying to restatrt. Attmept $i" | mailx -s "Restart APP $app" ravanaiah.m@cognizant.com
                for ((i=0;i<$COUNT;i++))
                {
                restart_fun
                }
        fi
