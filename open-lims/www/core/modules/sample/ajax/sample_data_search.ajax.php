<?php
/**
 * @package sample
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
 * Sample Search AJAX IO Class
 * @package sample
 */
class SampleDataSearchAjax
{
	/**
	 * @param string $json_column_array
	 * @param string $json_argument_array
	 * @param string $css_page_id
	 * @param string $css_row_sort_id
	 * @param string $entries_per_page
	 * @param string $page
	 * @param string $sortvalue
	 * @param string $sortmethod
	 * @return string
	 * @throws BaseAjaxArgumentMissingException
	 */
	public static function list_samples($json_column_array, $json_argument_array, $css_page_id, $css_row_sort_id, $entries_per_page, $page, $sortvalue, $sortmethod)
	{
		$argument_array = json_decode($json_argument_array);
		
		if (is_array($argument_array))
		{
			$string = $argument_array[0][1];
			$sample_id_array = $argument_array[1][1];
			$item_type_array = $argument_array[2][1];
			
			$list_request = new ListRequest_IO();
			$list_request->set_column_array($json_column_array);
		
			if (!is_numeric($entries_per_page) or $entries_per_page < 1)
			{
				$entries_per_page = 20;
			}
						
			$list_array = Sample_Wrapper::list_data_search($string, $sample_id_array, $item_type_array, $sortvalue, $sortmethod, ($page*$entries_per_page)-$entries_per_page, ($page*$entries_per_page));
			
			if (is_array($list_array) and count($list_array) >= 1)
			{
				$item_type_array = Item::list_types();
				
				foreach($list_array as $key => $value)
				{
					$datetime_handler = new DatetimeHandler($list_array[$key]['datetime']);
					$list_array[$key]['datetime'] = $datetime_handler->get_datetime(false);
					
					$sample_paramquery = array();
					$sample_paramquery['username'] = $_GET['username'];
					$sample_paramquery['session_id'] = $_GET['session_id'];
					$sample_paramquery['nav'] = "sample";
					$sample_paramquery['run'] = "detail";
					$sample_paramquery['sample_id'] = $value['holder_sample_id'];
					$sample_params = http_build_query($sample_paramquery, '', '&#38;');
					
					
					$tmp_sample_name = $list_array[$key]['holder_sample_name'];
					unset($list_array[$key]['holder_sample_name']);
					$list_array[$key]['sample_name']['content'] = $tmp_sample_name;
					$list_array[$key]['sample_name']['link'] = $sample_params;
					
					if (is_array($item_type_array) and count($item_type_array) >= 1)
					{
						foreach($item_type_array as $item_key => $item_value)
						{
							if($value[$item_key."_id"] != null)
							{
								$list_array[$key]['type'] = $item_value::get_generic_name($item_key, null);
								
								$tmp_item_name = $list_array[$key]['name'];
								unset($list_array[$key]['name']);
								$list_array[$key]['name']['content'] = $tmp_item_name;
								$list_array[$key]['name']['link'] = $item_value::get_generic_link($item_key, $value[$item_key."_id"]);
								
								$list_array[$key]['symbol']['content'] = $item_value::get_generic_symbol($item_key, $value[$item_key."_id"]);
								$list_array[$key]['symbol']['link'] = $item_value::get_generic_link($item_key, $value[$item_key."_id"]);
							}
						}
					}
				}
			}
			else
			{
				$list_request->empty_message("<span class='italic'>No results found!</span>");
			}
			
			$list_request->set_array($list_array);
			
			return $list_request->get_page($page);
		}
		else
		{
			throw new BaseAjaxArgumentMissingException();
		}
	}
	
	/**
	 * @param string $json_argument_array
	 * @return integer
	 * @throws BaseAjaxArgumentMissingException
	 */
	public static function count_samples($json_argument_array)
	{
		$argument_array = json_decode($json_argument_array);
		
		if (is_array($argument_array))
		{
			$string = $argument_array[0][1];
			$sample_id_array = $argument_array[1][1];
			$item_type_array = $argument_array[2][1];
			
			return Sample_Wrapper::count_data_search($string, $sample_id_array, $item_type_array);
		}
		else
		{
			throw new BaseAjaxArgumentMissingException();
		}
	}
}
?>