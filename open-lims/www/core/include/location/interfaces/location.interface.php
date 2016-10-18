<?php
/**
 * @package location
 * @version 0.4.0.0
 * @author Roman Konertz <konertz@open-lims.org>
 * @copyright (c) 2008-2016 by Roman Konertz
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
 * Location Interface
 * @package location
 */ 
interface LocationInterface
{
	/**
	 * @param integer $location_id
	 */
	function __construct($location_id);
	
	/**
	 * @param integer $toid
	 * @param integer $type_id
	 * @param string $name
	 * @param string $additional_name
	 * @param bool $show_prefix
	 * @return integer
	 */
	public function create($toid, $type_id, $name, $additional_name, $show_prefix);
	
	/**
	 * @return bool
	 */
	public function delete();
	
	/**
	 * @param bool $show_additional_name
	 * @return string
	 */
	public function get_name($show_additional_name);
	
	/**
	 * @return integer
	 */
	public function get_type_id();
	
	/**
	 * @return string
	 */
	public function get_db_name();
	
	/**
	 * @return string
	 */
	public function get_additional_name();
	
	/**
	 * @return bool
	 */
	public function get_prefix();
	
	/**
	 * @return array
	 */
	public function get_children();
	
	/**
	 * @param integer $type_id
	 * @return bool
	 */
	public function set_type_id($type_id);
	
	/**
	 * @param string $name
	 * @return bool
	 */
	public function set_db_name($name);
	
	/**
	 * @param string $additional_name
	 * @return bool
	 */
	public function set_additional_name($additional_name);
	
	/**
	 * @param bool $prefix
	 * @return bool
	 */
	public function set_prefix($prefix);
	
	/**
	 * @param integer $id
	 * @return bool
	 */
	public static function exist_id($id);
	
	/**
	 * @return array
	 */
	public static function list_root_entries();
	
	/**
	 * @return array
	 */
	public static function list_entries();
	
	/**
	 * @return array
	 */
	public static function list_types();
}
?>
