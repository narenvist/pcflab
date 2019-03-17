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

for app in $applications
        do
                for j in 1 2 3 4 5
                do 
                         #cf start $i
                         STATUS= 'cf app $i|grep -e " requested state:"|awk '{print  $3}''
                         if [[ $STATUS =="stopped" ]]
                         then
                                echo -e "App is still down\n"
                                if [[ $j == 5 ]]
                                then
                                        echo "Triggering a mail to user :ravanaiah (ravanaiahweblogic@gail.com)"
                                        mail -s "automation to bring up app failed for $1 app" ravanaiahweblogic@gmail.com <<< "automation to bring up this $i app got failed"
                                fi
                                cf start $i
                                continue
                          else
                                echo "App is up and running"
                                break
                          fi
                   done
          done         
                #eval "cf $CF_SUB_COMMAND $app"
                #status=$(cf app $app  | grep 'requested state:'| awk '{print $3}')

        #if [ "$STATUS" = "started" ]
        #then
         #       echo "$app is started"
          #      break
        #else
         #       echo "$STATUS"
          #      echo "App not started, trying to restatrt. Attmept $i" | mailx -s "Restart APP $app" ravanaiah.m@cognizant.com
           #     for ((i=0;i<$COUNT;i++))
            #    {
             #   restart_fun
              #  }
        #fi
