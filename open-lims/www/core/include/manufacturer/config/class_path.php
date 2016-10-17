<?php 
/**
 * @package manufacturer
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
	$classes['ManufacturerException'] 			= $path_prefix."core/include/manufacturer/exceptions/manufacturer.exception.class.php";
	$classes['ManufacturerNotFoundException'] 	= $path_prefix."core/include/manufacturer/exceptions/manufacturer_not_found.exception.class.php";
	$classes['ManufacturerIDMissingException']	= $path_prefix."core/include/manufacturer/exceptions/manufacturer_id_missing.exception.class.php";
	
	$classes['Manufacturer'] 					= $path_prefix."core/include/manufacturer/manufacturer.class.php";
	$classes['Manufacturer_Wrapper'] 			= $path_prefix."core/include/manufacturer/manufacturer.wrapper.class.php";
?>