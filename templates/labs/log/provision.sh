#!/bin/bash
        
        current_path="${current_path:-}"

        echo $current_path
        ip -4 a |grep inet --color