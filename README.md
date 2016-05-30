docker-xmltv-sd-json
======
 [![Docker Hub; huxy/xmltv-sd-json](https://img.shields.io/badge/dockerhub-xmltv--sd--json-blue.svg)](https://registry.hub.docker.com/h/huxy/xmltv-sd-json)

A Docker image with a JSON Schedules Direct enabled script, allowing access to all regions.

#Supported tags and respective Dockerfile links

* [Jessie](https://github.com/iuuuuan/xmltv/blob/master/Dockerfile)


#What is XMLTV?

XMLTV is a set of programs to process TV (tvguide) listings and manage your TV viewing, storing listings in an XML format. There are backends to download TV listings for several countries, filter programs and Perl libraries to process listings.

For more information visit [XMLTV SourceForge page](http://sourceforge.net/projects/xmltv/).

#Docker image information

XMLTV utilities are provided courtesy of the Debian repository. At the time of writing **[0.5.63-2]** is the latest version included with Debian Jessie. The image will not work correctly unless the grabber being used is configured. This can be done via the command line or an existing config file dropped in to the config persistent mount point. 

#Mounts
    /config : This is where XMLTV will store its cache and configuration.
    /data   : This is the output directory for the EPG data that has been scrapped.
    
#Features
1. Auto runs grab on startup. Specify number of days using STARTUPDAYS environment variable.
2. Days to grab can be configured with DAYS environment variable.
3. Grabber to use can be specified with GRABBER environment variable. 
4. Customisable cron job support.
5. Logging support.
5. Plus others, that I can't remember. 

#Grabbers
Image contains the following TV grabbers:

| Grabber       				        | Region        													                              |
| ----------------------------- |:---------------------------------------------------------------------:|
| /usr/bin/tv_grab_ar      		  | Argentina 															                              |
| /usr/bin/tv_grab_ch_search	  | Switzerland (tv.search.ch)      										                  |
| /usr/bin/tv_grab_combiner 	  | Combine data from several other grabbers     						            	|
| /usr/bin/tv_grab_dk_dr		    | TV Oversigten fra Danmarks Radios (2012)							              	|
| /usr/bin/tv_grab_es_laguiatv	| Spain (laguiatv.com)											                          	|
| /usr/bin/tv_grab_eu_egon		  | German speaking area (Egon zappt)										                  |
| /usr/bin/tv_grab_eu_epgdata	  | Parts of Europe (commercial) (www.epgdata.com)					            	|
| /usr/bin/tv_grab_fi			      | Finland (foxtv.fi, mtv3.fi, telkku.com, telvis.fi, tv.hs.fi, yle.fi)	|
| /usr/bin/tv_grab_fr			      | France															                                	|
| /usr/bin/tv_grab_fr_kazer		  | France (Kazer)														                            |
| /usr/bin/tv_grab_hr		      	| Croatia															                                  |
| /usr/bin/tv_grab_huro			    | Hungary/Romania													                            	|
| /usr/bin/tv_grab_il			      | Israel (tv.walla.co.il)												                        |
| /usr/bin/tv_grab_is			      | Iceland																                                |
| /usr/bin/tv_grab_is			      | India (WhatsOn)														                            |
| /usr/bin/tv_grab_it			      | Italy																	                                |
| /usr/bin/tv_grab_na_dtv		    | North America using www.directv.com									                  |
| /usr/bin/tv_grab_no_gfeed		  | Norway (beta)														  	                          |
| /usr/bin/tv_grab_pt_meo		    | Portugal (MEO)														                            |
| /usr/bin/tv_grab_se_swedb		  | Sweden (tv.swedb.se)													                        |
| /usr/bin/tv_grab_se_tvzon		  | Sweden (TVZon)														                            |
| /usr/bin/tv_grab_uk_bleb		  | United Kingdom (bleb.org)												                      |
| /usr/bin/tv_grab_uk_rt		    | United Kingdom/Republic of Ireland (Radio Times)						          |
| /usr/bin/tv_grab_za			      | South Africa															                            |
| /usr/bin/tv_it_dvb			      | Italy (DVB-S)															                            |
| /usr/bin/tv_na_dd				      | North America 														                            |
| /usr/bin/tv_na_dd				      | North America (Schedules Direct)										                  |
| /usr/local/bin/tv_grab_sd_json| Schedules Direct (JSON)												                        |

#Cronjobs
On boot if no existing crontab is available, the image will create one for you. This can then be further customised by editing the crontabs.txt file stored in the config mount point. 
```shell
30 */12 * * * /usr/local/bin/grabber >> /var/log/cron.log 2>&1
#
```

or expert configuration
```shell
SHELL=/bin/bash
15 */4 * * * /usr/local/bin/grabber >> /var/log/cron.log 2>&1
30 */4 * * * DAYS=2 GRABBER='/usr/bin/tv_grab_uk_rt' bash -c '/usr/local/bin/grabber >> /var/log/cron.log 2>&1'
55 */2 * * * DAYS=1 OFFSET='1' bash -c '/usr/local/bin/grabber >> /var/log/cron.log 2>&1'
#
```
#How to use this image

##Configure grabber
    sudo docker run -ti --rm huxy/xmltv-sd-json /usr/local/bin/tv_grab_sd_json --configure
  
##Launch Docker container
    sudo docker run -ti --rm huxy/xmltv-sd-json 

##Base image for custom xmltv configuration
Create your own Dockerfile and use this image for base image

    FROM huxy/xmltv-sd-json
