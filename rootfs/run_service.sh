#!/bin/bash

#
# Boot script.
#
# @verions 1.0
# @fecha 05/05/2020
# @author Javier Pastor
# @license GPL 3.0
#

PORT=${HTTP_PORT:-80}

# User and Group for the data WWW
WWW_U="www-data"
WWW_G="www-data"

# Global Paths
PATH_DEFAULT=/data_default
PATH_DATA=/data
PATH_WWW=/var/www/html

# Paths Files Config.php
PATH_WWW_CONF=$PATH_WWW/config.php
PATH_WWW_CONF_DATA=$PATH_DATA/config.php

# Apache Site Default
APACHE_SITE_DEFAULT="/etc/apache2/sites-enabled/000-default.conf"
APACHE_SITE_DEFAULT_DATA=$PATH_DATA/000-default.conf
APACHE_SITE_DEFAULT_DEFAULT=$PATH_DEFAULT/000-default.conf

# Apache Module RemoteIP
APACHE_MOD_REMOTEIP="/etc/apache2/conf-enabled/remoteip.conf"
APACHE_MOD_REMOTEIP_DATA=$PATH_DATA/remoteip.conf
APACHE_MOD_REMOTEIP_DEFAULT=$PATH_DEFAULT/remoteip.conf

# App SMTP Send
APP_SMTP="/etc/msmtprc"
APP_SMTP_DATA=$PATH_DATA/msmtprc.conf
APP_SMTP_DEFAULT=$PATH_DEFAULT/msmtprc.conf

# Timezone PHP
PHP_TZ=${TZ:-"America/Los_Angeles"}
PHP_TZ_FILE="/usr/local/etc/php/conf.d/timezone.ini"



EXEC_EXTERNAL=$PATH_DATA/run_service_external.sh

RUN_ENTRYPOINT="docker-php-entrypoint"
RUN_CMD="apache2-foreground"

fun_check_path_data() {
	if [[ ! -d $PATH_DATA ]]; then
		mkdir -p $PATH_DATA
		[[ $? -gt 0 ]] && return 1 || return 0
	fi
}

fun_check_file_conf() {
	if [[ ! -f $PATH_WWW_CONF_DATA ]]; then
		touch $PATH_WWW_CONF_DATA
		[[ $? -gt 0 ]] && return 1 || return 0
	fi
}

fun_check_file_apache_site_default() {
	if [[ ! -f $APACHE_SITE_DEFAULT_DATA ]]; then
		cp $APACHE_SITE_DEFAULT_DEFAULT $APACHE_SITE_DEFAULT_DATA
		[[ $? -gt 0 ]] && return 1 || return 0
	fi
}

fun_check_file_apache_mod_remoteip() {
	if [[ ! -f $APACHE_MOD_REMOTEIP_DATA ]]; then
		cp $APACHE_MOD_REMOTEIP_DEFAULT $APACHE_MOD_REMOTEIP_DATA
		[[ $? -gt 0 ]] && return 1 || return 0
	fi
}

fun_check_file_smtp() {
	if [[ ! -f $APP_SMTP_DATA ]]; then
		cp $APP_SMTP_DEFAULT $APP_SMTP_DATA
		[[ $? -gt 0 ]] && return 1 || return 0
	fi
}


fun_check_chown() {
	#if [[ ! -d $PATH_DATA ]]; then
	#	chown ${WWW_U}:${WWW_G} $PATH_DATA -R
	#fi

	# /var/www
	if [[ ! -d $PATH_WWW ]]; then
		chown $WWW_U:$WWW_G $PATH_WWW -R
	fi

	# Config.php
	if [[ ! -f $PATH_WWW_CONF_DATA ]]; then
		chown $WWW_U:$WWW_G $PATH_WWW_CONF_DATA
		chmod 644 $PATH_WWW_CONF_DATA
	fi

	# Apache Site Default
	if [[ ! -f $APACHE_SITE_DEFAULT_DATA ]]; then
		chown root:root $APACHE_SITE_DEFAULT_DATA
		chmod 644 $APACHE_SITE_DEFAULT_DATA
	fi

	# Apache Mod RemoteIP
	if [[ ! -f $APACHE_MOD_REMOTEIP_DATA ]]; then
		chown root:root $APACHE_MOD_REMOTEIP_DATA
		chmod 644 $APACHE_MOD_REMOTEIP_DATA
	fi

	# SMTP
	if [[ ! -f $APP_SMTP_DATA ]]; then
		chown root:root $APP_SMTP_DATA
		chmod 644 $APP_SMTP_DATA
	fi
}

fun_check_link() {
	ln -sf $PATH_WWW_CONF_DATA $PATH_WWW_CONF
	ln -sf $APACHE_SITE_DEFAULT_DATA $APACHE_SITE_DEFAULT
	ln -sf $APACHE_MOD_REMOTEIP_DATA $APACHE_MOD_REMOTEIP
	ln -sf $APP_SMTP_DATA $APP_SMTP
}

fun_php_tz_update() {
	echo "date.timezone = $PHP_TZ" > $PHP_TZ_FILE
	chown root:staff $PHP_TZ_FILE
	chmod 644 $PHP_TZ_FILE
}


if [[ -f $EXEC_EXTERNAL ]]; then
	echo "*** RUN EXTERNAL ***"
	sh $EXEC_EXTERNAL
else
	echo "Starting service..."
	echo " - Listen port: $PORT"
	echo ""
	fun_check_path_data
	fun_check_file_conf
	fun_check_file_apache_site_default
	fun_check_file_apache_mod_remoteip
	fun_check_file_smtp
	fun_check_link
	fun_check_chown

	fun_php_tz_update

	$RUN_ENTRYPOINT $RUN_CMD
fi
