#!/bin/sh
# Убираем ненужные lv и vg
yes | lvremove /dev/vg_tmp/lv_tmp
yes | vgremove /dev/vg_tmp
# Первое задание выполнено!

