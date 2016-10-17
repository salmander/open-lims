<?php
/**
 * @package sample
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
 * Registering Functions
 */ 
function register_sample($include_id)
{	
	if (Item::delete_holder_by_include_id($include_id))
	{
		if (Item::register_holder("sample", "Sample", $include_id) == false)
		{
			return false;
		}
	}
	else
	{
		return false;
	}
	
	if (Item::delete_type_by_include_id($include_id))
	{
		if (Item::register_type("sample", "Sample", $include_id) == false)
		{
			return false;
		}
		
		if (Item::register_type("parentsample", "Sample", $include_id) == false)
		{
			return false;
		}
	}
	else
	{
		return false;
	}
	
	if (Folder::delete_type_by_include_id($include_id))
	{
		if (Folder::register_type("sample_folder", "SampleFolder", $include_id) == false)
		{
			return false;
		}		
	}
	else
	{
		return false;
	}
	
	if (ValueVar::delete_by_include_id($include_id))
	{
		if (ValueVar::register_type("sample", "SampleValueVar", false, $include_id) == false)
		{
			return false;
		}
	}
	else
	{
		return false;
	}
	
	if (!Registry::is_value("sample_default_expiry_warning"))
	{
		$registry = new Registry(null);
		$registry->create("sample_default_expiry_warning", $include_id, "7");
	}
	
	return true;
}
$result = register_sample($key);
?>