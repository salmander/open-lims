<?php 
/**
 * @package data
 * @version 0.4.0.0
 * @author Roman Konertz <konertz@open-lims.org>
 * @author Roman Quiring <quiring@open-lims.org>
 * @copyright (c) 2008-2016 by Roman Konertz, Roman Quiring
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
 * Data Navigation IO Class
 * @package data
 */
class DataNavigationIO
{	
	/**
	 * @return bool
	 */
	public static function get_active() 
	{
		return true;
	}
	
	/**
	 * @return string
	 */
	public static function get_icon()
	{
		return "images/icons/folder_blue.png";
	}
	
	/**
	 * @return string
	 */
	public static function get_ajax_url()
	{
		return "ajax.php?nav=data&session_id=".$_GET['session_id']."&run=navigation_data";
	}
}

?>