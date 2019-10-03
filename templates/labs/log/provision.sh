#!/bin/bash
        
    #================Variables=====================
    vagrant_dir='/vagrant'
    vagant_box=${vagrant_box_name:-} # MashineName
    vagrant_dir=${vagrant_dir} + '/' + ${vagrant_box} # /vagrant/'MashineName'


	#================Понеслася=====================

        echo $current_path
        echo "IP адрес машины: " $(ip -4 a |grep inet --color)