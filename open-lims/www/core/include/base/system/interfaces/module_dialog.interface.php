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
 * Module Dialog Interface
 * @package base
 */
interface ModuleDialogInterface
{
	/**
	 * @param string $dialog_type
	 * @param string $internal_array
	 * @return array
	 */
	public static function get_by_type_and_internal_name($dialog_type, $internal_name);
	
	/**
	 * @param string $dialog_type
	 * @return array
	 */
	public static function list_dialogs_by_type($dialog_type);
	
	/**
	 * @param string $dialog_type
	 * @param string $module
	 * @return array
	 */
	public static function list_dialogs_by_type_and_module($dialog_type, $module);
}
?>