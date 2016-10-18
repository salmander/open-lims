<?php
/**
 * @package base
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
 * Admin Base Include AJAX IO Class
 * @package base
 */
class AdminBaseIncludeAjax
{	
	/**
	 * @param string $json_column_array
	 * @param string $css_page_id
	 * @param string $css_row_sort_id
	 * @param string $entries_per_page
	 * @param string $page
	 * @param string $sortvalue
	 * @param string $sortmethod
	 * @return string
	 * @throws BaseUserAccessDeniedException
	 */
	public static function list_includes($json_column_array, $css_page_id, $css_row_sort_id, $entries_per_page, $page, $sortvalue, $sortmethod)
	{
		global $user;
		
		if ($user->is_admin())
		{
			$list_request = new ListRequest_IO();
			$list_request->set_column_array($json_column_array);
			
			if (!is_numeric($entries_per_page) or $entries_per_page < 1)
			{
				$entries_per_page = 20;
			}
			
			$list_array = System_Wrapper::list_base_include($sortvalue, $sortmethod, ($page*$entries_per_page)-$entries_per_page, ($page*$entries_per_page));
			
			if (is_array($list_array) and count($list_array) >= 1)
			{
				$today_end = new DatetimeHandler(date("Y-m-d")." 23:59:59");
				
				foreach($list_array as $key => $value)
				{
					
				}	
			}
			else
			{
				$list_request->empty_message("<span class='italic'>No includes found!</span>");
				// Hmm, when this message appears, something went wrong.
			}
			
			$list_request->set_array($list_array);
			
			return $list_request->get_page($page);
		}
		else
		{
			throw new BaseUserAccessDeniedException();	
		}
	}
	
	/**
	 * @return integer
	 * @throws BaseUserAccessDeniedException
	 */
	public static function count_includes()
	{
		global $user;
		
		if ($user->is_admin())
		{
			return System_Wrapper::count_base_include();
		}
		else
		{
			throw new BaseUserAccessDeniedException();	
		}
	}
}
?>