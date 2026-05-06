#! usr/bin/env bash

user_input(){
    read -r -p "$1 [$2]:" input
    echo "${input : -$2}
}

while true;do

    echo "1. Specify Log Directory"
    echo "2. Specify Number of Days to Keep Logs"
    echo "3. Specify Number of Days to Keep Backup Archives"
    echo "4. Run Log Archiving Process"
    echo "5. Exit"
    echo ""

    read -r -p "Choose the option[1-5]" choice

    case $choice in
        1)
            log_dir=$(user_input "Enter the log directory" "/var/log")
            if [ ! -d log_dir ];then
                echo "Error: log directory not found "
            else
                echo " Log directory set to $log_dir"
            fi
            ;;
        
        2)
            days_to_keep=$(user_input "Enter the no. of days to keep" "7")
            echo "No of days to keep $days_to_keep"
            ;;
        
        3)
            days_for_backups=$(user_input "Enter the no. of days to keep backup" "20")
            echo "No of days to keep $days_for_backups"
            ;;
        
        4)
            if [ -z "$log_dir" ]; then
                echo "Error: Log directory is not set. Please set it first."
            else
                archive_dir=$log_dir/archive"
                mkdir "$achive_dir"

                timestamp=$(date +"%Y%m%d_%H%M%S")
                archive_file="$archive_dir/logs_archive_$timestamp.tar.gz"

                find "$log_dir" -type f -mtime +$days_to_keep -print0 | tar -czvf "$archive_file" --null -T

                echo "Logs archived in $archive_file on $(date)" >> "$archive_dir/archive_log.txt"

                find "$log_dir" -type f -mtime +$days_to_keep -exec rm -f {} \;

                find "$archive_dir" -type f -name "*.tar.gz" -mtime +$days_to_keep_backups -exec rm -f {} \;
                echo "Backup archives older than $days_to_keep_backups days have been deleted."
            
            fi
            ;;

        5)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please choose a number between 1 and 5."
            ;;
    esac
done

