<?php
/**
 * @package base
 * @version 0.4.0.0
 * @author Roman Konertz <konertz@open-lims.org>
 * @copyright (c) 2008-2014 by Roman Konertz
 * @license GPLv3
 * 
 * This file is part of Open-LIMS
 * Available at http://www.open-lims.org
 * 
 * This program is free software;
 * you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation;
 * version 3 of the License.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with this program;
 * if not, see <http://www.gnu.org/licenses/>.
 */
 	
/**
 * 
 */
$server['main_folder']							= "/var/www/open-lims";
$server['timezone']								= "Europe/Berlin";

$database['type'] 								= "postgres";
$database['database'] 							= $_ENV["DB_NAME"];
$database['user'] 								= $_ENV["DB_USER"];
$database['password']							= $_ENV["DB_PASSWORD"];

// Primary Database Server
$database[0]['server']							= "db";
$database[0]['port'] 							= "5432";

// Secondary Database Server
// $database[1]['server']						= "localhost";
// $database[1]['port'] 						= "";


$mail['enable'] 								= true;
$mail['enable_smtp'] 							= false;
$mail['from'] 									= "roman.konertz@uni-koeln.de";

// Primary SMTP
$mail[0]['smtp']['server'] 						= "";
$mail[0]['smtp']['port'] 						= "";
$mail[0]['smtp']['username'] 					= "";
$mail[0]['smtp']['password'] 					= "";

$ldap['enable']									= false;


$server['imagick']['enable']					= true;	


$server['behaviour']['debug_mode']				= true;
$server['behaviour']['avoid_css_cache']			= true;
$server['behaviour']['avoid_js_cache']			= true;
$server['behaviour']['on_db_rollback']			= true;
$server['behaviour']['on_db_expected_rollback']	= false;
$server['behaviour']['on_db_commit']			= false;
?>
