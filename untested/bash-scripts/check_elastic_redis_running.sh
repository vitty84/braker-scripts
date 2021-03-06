#!/bin/bash
#
#
# Name: check_elastic_redis_running.sh
# Author: Steve Stonebraker
# Purpose: start elasticsearch and redis if they aren't running
#
#
#
#
#  install to cron instructions:
#  cd /root;curl -k -O "https://raw.github.com/ssstonebraker/braker-scripts/master/hardcoded_stuff/check_elastic_redis_running.sh";chmod +x check_elastic_redis_running.sh;
#  crontab -l > mycron;echo "*/10 * * * * /root/check_elastic_redis_running.sh" >> mycron;crontab mycron;/bin/rm mycron
#
function check_if_elasticsearch_running () {
        current_script=`basename $0`
        process_name="elasticsearch"
        /bin/ps aux | /bin/grep "${process_name}" | /bin/grep -v 'grep' | /bin/grep -v "$current_script"
	
		if [ $? -eq 0 ]; then
		    echo "${process_name} running"
		else
		    echo "${process_name}: not running, starting..."
		    service elasticsearch start
		fi
}
function check_if_redis_running () {
        current_script=`basename $0`
        process_name="redis-server"
        /bin/ps aux | /bin/grep "${process_name}" | /bin/grep -v 'grep' | /bin/grep -v "$current_script"
	
		if [ $? -eq 0 ]; then
		    echo "${process_name} running"
		else
		    echo "${process_name}: not running, starting..."
		    if [ -f /var/run/redis_6379.pid ] ; then
				/bin/rm -f /var/run/redis_6379.pid
			fi
		    service redis_6379 start
		fi
}

check_if_elasticsearch_running
check_if_redis_running
sleep 30
check_if_elasticsearch_running
check_if_redis_running
