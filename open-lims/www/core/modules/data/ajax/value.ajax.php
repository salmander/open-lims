<?php
/**
 * @package data
 * @version 0.4.0.0
 * @author Roman Quiring <quiring@open-lims.org>
 * @author Roman Konertz <konertz@open-lims.org>
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
 * Value AJAX IO Class
 * @package data
 */
class ValueAjax
{
	/**
	 * @param string $json_column_array
	 * @param string $json_argument_array
	 * @param string $get_array
	 * @param string $css_page_id
	 * @param string $css_row_sort_id
	 * @param string $entries_per_page
	 * @param string $page
	 * @param string $sortvalue
	 * @param string $sortmethod
	 * @return string
	 * @throws DataSecurityAccessDeniedException
	 * @throws ValueIDMissingException
	 */
	public static function list_versions($json_column_array, $json_argument_array, $get_array, $css_page_id, $css_row_sort_id, $entries_per_page, $page, $sortvalue, $sortmethod)
	{
		if ($get_array)
		{
			$_GET = unserialize($get_array);	
		}
		
		$argument_array = json_decode($json_argument_array);
		$value_id = $argument_array[1];
		
		if (is_numeric($value_id))
		{
			$value_obj = Value::get_instance($value_id);
			
			if ($value_obj->is_read_access())
			{
				$list_request = new ListRequest_IO();
				$list_request->set_column_array($json_column_array);
			
				if (!is_numeric($entries_per_page) or $entries_per_page < 1)
				{
					$entries_per_page = 20;
				}
							
				$list_array = Data_Wrapper::list_value_versions($value_id, $sortvalue, $sortmethod, ($page*$entries_per_page)-$entries_per_page, ($page*$entries_per_page));
			
				if (is_array($list_array) and count($list_array) >= 1)
				{
					foreach($list_array as $key => $value)
					{
						$paramquery = $_GET;
						$paramquery['action'] = "value_detail";
						$paramquery['version'] = $list_array[$key]['internal_revision'];
						$params = http_build_query($paramquery,'','&#38;');
						
						$list_array[$key]['symbol']['link']		= $params;
						$list_array[$key]['symbol']['content'] 	= "<img src='images/icons/value.png' alt='N' border='0' />";
					
						$tmp_name = $list_array[$key]['name'];
						unset($list_array[$key]['name']);
						$list_array[$key]['name']['link']		= $params;
						$list_array[$key]['name']['content'] 	= $tmp_name;
						
						$datetime_handler = new DatetimeHandler($list_array[$key]['datetime']);
						$list_array[$key]['datetime'] = $datetime_handler->get_datetime(false);
						
						$user = new User($list_array[$key]['owner_id']);
						$list_array[$key]['user'] = $user->get_full_name(false);
						
						$value_version_obj = clone $value_obj;
						$value_version_obj->open_internal_revision($value['internal_revision']);
						if ($value_version_obj->is_current() == true)
						{
							$list_array[$key]['version'] = $value_version_obj->get_version()." <span class='italic'>current</span>";
						}
						else
						{
							$list_array[$key]['version'] = $value_version_obj->get_version();
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
				throw new DataSecurityAccessDeniedException();
			}
		}
		else
		{
			throw new ValueIDMissingException();
		}
	}
	
	/**
	 * @param string $json_argument_array
	 * @throws ValueIDMissingException
	 */
	public static function count_versions($json_argument_array)
	{
		$argument_array = json_decode($json_argument_array);
		$value_id = $argument_array[1];
		
		if (is_numeric($value_id))
		{
			return Data_Wrapper::count_value_versions($value_id);
		}
		else
		{
			throw new ValueIDMissingException();
		}
	}
	
	/**
	 * @param string $action
	 * @return string
	 */
	public static function get_data_browser_link_html_and_button_handler($action) 
	{
		global $regional;
		
		$html;
		$html_caption;
		$button_handler;
		$button_handler_caption;
		$template;
		$paramquery = $_GET;	
		unset($paramquery['run']);
		switch($action):
			case "value_add":
				if(!isset($_POST['folder_id']) && !isset($_POST['value_array']))
				{ //second call (from additional script; loads template)
					require_once("core/modules/data/io/value_form.io.php");
					$value_form_io = new ValueFormIO(null, $_POST['type_id'], $_POST['folder_id']);
					$value_form_io->set_field_class("DataValueAddValues");
					return $value_form_io->get_content();
				}
				if(isset($_POST['value_array']))
				{//third call (from add button; creates value)
					return self::add_value($_POST['folder_id'], $_POST['type_id'], $_POST['value_array']);
				}

				require_once("core/include/data/value/access/value_type.access.php");
				$types = ValueType_Access::list_entries();
				$options = array();
				$counter = 0;
				foreach($types as $key => $value)
				{	
					if($value == 2)
					{
						continue;
					}
					$value_type = new ValueType($value);
					$options[$counter]['value'] = $value; 
					$options[$counter]['content'] = $value_type->get_name();		
					$options[$counter]['selected'] = "";
					$options[$counter]['disabled'] = "";
					$counter++;
				}
				
				$template = new HTMLTemplate("data/value_add_window.html");
				$template->set_var("option",$options);
				$html = $template->get_string();			
				$html_caption = "Add Value";
				
				$button_handler_template = new JSTemplate("data/js/value_add_window.js");
				$button_handler_template->set_var("session_id", $_GET['session_id']);
				$button_handler_template->set_var("folder_id", $_POST['folder_id']);
				$button_handler = $button_handler_template->get_string();
				$button_handler_caption = "Add";
				
				$additional_script_template = new JSTemplate("data/js/value_add_window_additional.js");
				$additional_script_template->set_var("decimal_separator", $regional->get_decimal_separator());
				$additional_script_template->set_var("thousand_separator", $regional->get_thousand_separator());		
				$additional_script_template->set_var("session_id", $_GET['session_id']);
				$additional_script = $additional_script_template->get_string();
				$array = array("content"=>$html , "content_caption"=>$html_caption , "handler"=>$button_handler , "handler_caption"=>$button_handler_caption, "additional_script"=>$additional_script);
				return json_encode($array);
				
			break;
			case "value_delete":
				if(isset($_POST['sure']))
				{
					self::delete_value($_POST['value_id']);
				}
				else
				{
					$template = new HTMLTemplate("data/value_delete_window.html");
					$button_handler_template = new JSTemplate("data/js/value_delete_window.js");
					$button_handler_template->set_var("session_id", $_GET['session_id']);
					$button_handler_template->set_var("value_id", $_POST['value_id']);
					$button_handler = $button_handler_template->get_string();
					$button_handler_caption = "Delete";
					$html_caption = "Delete Value";
					$html = $template->get_string();
				}
			break;
			case "permission":
				require_once("data.ajax.php");
				if(isset($_POST['permissions']))
				{
					$success = DataAjax::change_permission(json_decode($_POST['permissions']), "Value");
					return $success;
				}
				else
				{
					$permission = DataAjax::permission_window();
					$button_handler_template = new JSTemplate("data/js/value_permission_window.js");
					$button_handler_template->set_var("session_id", $_GET['session_id']);
					$button_handler_template->set_var("value_id", $_POST['value_id']);
					$button_handler = $button_handler_template->get_string();
					$button_handler_caption = "Change";
					$html_caption = "Change permission";
					$html = $permission;	
				}
			break;
		endswitch;
		$array = array("content"=>$html , "content_caption"=>$html_caption , "handler"=>$button_handler , "handler_caption"=>$button_handler_caption);
		return json_encode($array);
	}
	
	/**
	 * @todo business logic exceptions
	 * @param integer $folder_id
	 * @param integer $type_id
	 * @param string $value_array
	 * @return string
	 */
	private static function add_value($folder_id, $type_id, $value_array)
	{
		global $user;
		
		$parent_folder = Folder::get_instance($folder_id);
		if ($parent_folder->is_write_access())
		{
			$value_array = json_decode($value_array, true);
			$value = Value::get_instance(null);
			if ($value->create($folder_id, $user->get_user_id(), $type_id, $value_array) != Null)
			{
				return 1;
			}
			else
			{
				throw new BaseException();
			}
		}
		else
		{
			throw new DataSecurityAccessDeniedException();
		}
	}
	
	/**
	 * @todo business logic exceptions
	 * @param integer $folder_id
	 * @param integer $type_id
	 * @param string $value_array
	 * @param string $get_array
	 * @return string
	 */
	public static function add_as_item($folder_id, $type_id, $value_array, $get_array)
	{
		global $user, $transaction;
		
		$parent_folder = Folder::get_instance($folder_id);
		
		if ($parent_folder->is_write_access())
		{
			$transaction_id = $transaction->begin();
			
			$value_array = json_decode($value_array, true);

			$value = Value::get_instance(null);
			$value_add_successful = $value->create($folder_id, $user->get_user_id(), $type_id, $value_array);
			
			if ($value_add_successful)
			{
				$item_id = $value->get_item_id();
				
				$item_add_event = new ItemAddEvent($item_id, unserialize($get_array), null);
				$event_handler = new EventHandler($item_add_event);
				if ($event_handler->get_success() == true)
				{
					if ($transaction_id != null)
					{
						$transaction->commit($transaction_id);
					}
					return "1";
				}
				else
				{
					if ($transaction_id != null)
					{
						$transaction->rollback($transaction_id);
					}
					throw new BaseException();
				}
			}
			else
			{
				if ($transaction_id != null)
				{
					$transaction->rollback($transaction_id);
				}
				throw new BaseException();
			}
		}
		else
		{
			throw new DataSecurityAccessDeniedException();
		}
	}
	
	/**
	 * @param integer $gid
	 * @param array $link
	 * @param array $type_array
	 * @param array $category_array
	 * @param string $holder_class
	 * @param integer $holder_id
	 * @return array
	 */
	public static function add_as_item_window_init($gid, $link, $type_array, $category_array, $holder_class, $holder_id)
	{
		if ($link['parent'] and is_numeric($link['parent_id']))
		{
			$array['window_id'] = "ValueItemAddWindow".$link['parent_key']."-".$link['parent_id']."-".$gid;
			$array['click_id'] = "ValueItemAddButton".$link['parent_key']."-".$link['parent_id']."-".$gid;
		}
		else
		{
			$array['window_id'] = "ValueItemAddWindow".$gid;
			$array['click_id'] = "ValueItemAddButton".$gid;
		}
						
		if ($type_array)
		{
			$type_array_serialized = serialize($type_array);
		}
		
		if (class_exists($holder_class))
		{
			$item_holder = new $holder_class($holder_id);
			
			if ($item_holder instanceof ItemHolderInterface)
			{
				$folder_id = $item_holder->get_item_holder_value("folder_id", $gid);
			}
		}
		
		$array['window_title'] = "Add Values";
		
		$script_template = new JSTemplate("data/js/value_add_item_window_preclick.js");
		$script_template->set_var("window_id", $array['window_id']);
		$script_template->set_var("session_id", $_GET['session_id']);
		$script_template->set_var("type_array", $type_array_serialized);
		$script_template->set_var("folder_id", $folder_id);
		$script_template->set_var("get_array", serialize($link));
		$script_template->set_var("click_id", $array['click_id']);
		
		$array['script'] = $script_template->get_string();
		
		return $array;
	}
	
	/**
	 * @param string $get_array
	 * @param string $type_array
	 * @return string
	 * @throws ItemTypeRequiredException
	 */
	public static function add_as_item_window($get_array, $type_array, $folder_id)
	{
		global $regional;
		
		if ($get_array)
		{
			$_GET = unserialize($get_array);	
		}
		
		if ($type_array)
		{
			$type_array = unserialize($type_array);	
		}

		if (is_array($type_array) and count($type_array) == 1)
		{
			if (is_numeric($folder_id))
			{
				$type_id = $type_array[0];
				
				$template = new HTMLTemplate("data/value_add_item_window.html");
				
				if ($_GET['parent'] and is_numeric($_GET['parent_id']))
				{
					$array['container'] = "#ValueItemAddWindow".$_GET['parent_key']."-".$_GET['parent_id']."-".$_GET['key'];
				}
				else
				{
					$array['container'] = "#ValueItemAddWindow".$_GET['key'];
				}

				require_once("core/modules/data/io/value_form.io.php");
				$value_form_io = new ValueFormIO(null, $type_id, $folder_id);
				$value_form_io->set_field_class("DataValueAddValues");
				
				$template->set_var("value",$value_form_io->get_content());
				
				$array['continue_caption'] = "Add";
				$array['cancel_caption'] = "Cancel";
				$array['content_caption'] = "Add Values";
				$array['height'] = 350;
				$array['width'] = 400;
				$array['content'] = $template->get_string();
				
				$continue_handler_template = new JSTemplate("data/js/value_add_item_window.js");
				$continue_handler_template->set_var("session_id", $_GET['session_id']);
				$continue_handler_template->set_var("type_id", $type_id);
				$continue_handler_template->set_var("folder_id", $folder_id);
				$continue_handler_template->set_var("get_array", $get_array);
				$continue_handler_template->set_var("container_id", $array['container']);
	
				$array['continue_handler'] = $continue_handler_template->get_string();
				
				$script_template = new JSTemplate("data/js/value_add_item_window_onclick.js");		
				$script_template->set_var("decimal_separator", $regional->get_decimal_separator());
				$script_template->set_var("thousand_separator", $regional->get_thousand_separator());		
				$array['open_handler'] = $script_template->get_string();
				
				return json_encode($array);
			}
			else
			{
				throw new FolderIDMissingException();
			}
		}
		else
		{
			throw new ItemTypeRequiredException();
		}
	}
	
	/**
	 * @todo business logic exceptions
	 * @param integer $value_id
	 * @param integer $previous_version_id
	 * @param string $value_array
	 * @param string $major
	 * @return string
	 */
	public static function update($value_id, $previous_version_id, $value_array, $major)
	{		
		if (is_numeric($value_id))
		{			
			$value = Value::get_instance($value_id);
			
			if ($value->is_write_access())
			{						
				$value_array = json_decode($value_array, true);
				
				if (is_array($value_array))
				{
					if (!is_numeric($previous_version_id))
					{
						$previous_version_id = null;
					}
					
					if ($value->update($value_array, $previous_version_id, $major, true, false))
					{			
						return "1";	
					}
					else
					{
						throw new BaseException();	
					}
				}
				else
				{
					throw new BaseException();	
				}
			}
			else
			{
				throw new BaseUserAccessDeniedException();	
			}
		}
		else
		{
			throw new ValueIDMissingException();
		}
	}
	
	/**
	 * @param integer $value_id
	 * @return string
	 * @throws DataSecurityAccessDeniedException
	 */
	private static function delete_value($value_id)
	{
		$value = Value::get_instance($value_id);
		if ($value->is_delete_access())
		{
			$value->delete();
			return "1";
		}
		else
		{
			throw new DataSecurityAccessDeniedException();
		}
	}
}

?>