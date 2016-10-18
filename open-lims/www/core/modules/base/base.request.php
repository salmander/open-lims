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
 * Base Request Class
 * @package base
 */
class BaseRequest
{	
	/**
	 * @param string $alias
	 */
	public static function ajax_handler($alias)
	{
		switch($_GET['run']):

			case "cron":
				require_once("ajax/cron.ajax.php");
				echo CronAjax::run();
			break;
		
			case "login":
				require_once("ajax/login.ajax.php");
				echo LoginAjax::login($_POST['username'], $_POST['password'], $_POST['language']);
			break;
			
			case "forgot_password":
				require_once("ajax/login.ajax.php");
				echo LoginAjax::forgot_password($_POST['username'], $_POST['mail']);		
			break;
			
			case "logout":
				require_once("ajax/login.ajax.php");
				echo LoginAjax::logout();
			break;
			
			case "left_navigation":
				require_once("ajax/navigation/left_navigation.ajax.php");
				
				switch($_GET['action']):
					case "set_active":
						echo LeftNavigationAjax::set_active($_POST['id']);
					break;
				endswitch;
			break;
			
			
			// Lists
			
			case "list_get_page_information":
				require_once("ajax/list.ajax.php");
				echo ListAjax::get_page_information($_POST['number_of_entries'], $_POST['number_of_pages']);
			break;
			
			case "list_get_page_bar":
				require_once("ajax/list.ajax.php");
				echo ListAjax::get_page_bar($_POST['page'], $_POST['number_of_pages'], $_POST['css_page_id']);
			break;
			
			
			// Search
			
			case "search_user_list_users":
				require_once("ajax/user_search.ajax.php");
				echo UserSearchAjax::list_users(
						$_POST['column_array'], 
						$_POST['argument_array'], 
						$_POST['css_page_id'], 
						$_POST['css_row_sort_id'], 
						$_POST['entries_per_page'], 
						$_GET['page'], 
						$_GET['sortvalue'], 
						$_GET['sortmethod']
						);
			break;
			
			case "search_user_count_users":
				require_once("ajax/user_search.ajax.php");
				echo UserSearchAjax::count_users($_POST['argument_array']);
			break;
			
			case "search_user_list_groups":
				require_once("ajax/user_search.ajax.php");
				echo UserSearchAjax::list_groups(
						$_POST['column_array'], 
						$_POST['argument_array'], 
						$_POST['css_page_id'], 
						$_POST['css_row_sort_id'], 
						$_POST['entries_per_page'], 
						$_GET['page'], 
						$_GET['sortvalue'], 
						$_GET['sortmethod']
						);
			break;
			
			case "search_user_count_groups":
				require_once("ajax/user_search.ajax.php");
				echo UserSearchAjax::count_groups($_POST['argument_array']);
			break;
			
			
			// User

			case "get_users_in_option":
				require_once("common/ajax/user_common.ajax.php");
				echo UserCommonAjax::get_users_in_option($_POST['string']);
			break;
			
			case "get_groups_in_option":
				require_once("common/ajax/user_common.ajax.php");
				echo UserCommonAjax::get_groups_in_option($_POST['string']);
			break;
			
			case "user_profile_personal_data_change":
				require_once("ajax/user.ajax.php");
				echo UserAjax::profile_personal_data_change($_POST['gender'], 
						$_POST['forename'], 
						$_POST['surname'], 
						$_POST['title'], 
						$_POST['mail'], 
						$_POST['institution'], 
						$_POST['department'], 
						$_POST['street'], 
						$_POST['zip'], 
						$_POST['city'], 
						$_POST['country'], 
						$_POST['phone'], 
						$_POST['icq'], 
						$_POST['msn'], 
						$_POST['yahoo'], 
						$_POST['aim'], 
						$_POST['skype'], 
						$_POST['lync'], 
						$_POST['jabber']
						);
			break;
			
			case "user_profile_regional_settings_change":
				require_once("ajax/user.ajax.php");
				echo UserAjax::profile_regional_settings_change($_POST['language_id'], 
						$_POST['country_id'], 
						$_POST['timezone_id'], 
						$_POST['time_display'], 
						$_POST['time_enter'], 
						$_POST['date_display'], 
						$_POST['date_enter'], 
						$_POST['system_of_units'], 
						$_POST['currency_id'], 
						$_POST['currency_significant_digits'], 
						$_POST['decimal_separator'], 
						$_POST['thousand_separator'], 
						$_POST['name_display_format'], 
						$_POST['system_of_paper_format']
						);
			break;
			
			case "user_password_change":
				require_once("ajax/user.ajax.php");
				echo UserAjax::password_change($_POST['current_password'], 
						$_POST['new_password_1'], 
						$_POST['new_password_2']
						);
			break;
			
			// Batch
			
			case "batch_list_batches":
				require_once("ajax/batch.ajax.php");
				echo BatchAjax::list_batches(
						$_POST['column_array'], 
						$_POST['argument_array'], 
						$_POST['get_array'], 
						$_POST['css_page_id'], 
						$_POST['css_row_sort_id'], 
						$_POST['entries_per_page'], 
						$_GET['page'], 
						$_GET['sortvalue'], 
						$_GET['sortmethod']
						);
			break;
			
			case "batch_count_batches":
				require_once("ajax/batch.ajax.php");
				echo BatchAjax::count_batches($_POST['argument_array']);
			break;
			
			case "batch_start_test":
				require_once("ajax/batch.ajax.php");
				echo BatchAjax::start_test();
			break;
			
			case "batch_start_test_handler":
				require_once("ajax/batch.ajax.php");
				echo BatchAjax::start_test_handler($_POST['number_of_batches']);
			break;
			
		endswitch;
	}
	
	/**
	 * @param string $alias
	 * @throws BaseModuleDialogMethodNotFoundException
	 * @throws BaseModuleDialogClassNotFoundException
	 * @throws BaseModuleDialogFileNotFoundException
	 * @throws BaseModuleDialogMissingException
	 */
	public static function io_handler($alias)
	{
		global $user;
		
		if (isset($_GET['run']) and $_GET['run'] == "common_dialog" and isset($_GET['dialog']))
		{
			require_once("common.request.php");
			CommonRequest::common_dialog();
		}
		else
		{
			switch ($alias):
		
				case "search":
					
					switch($_GET['run']):
						
						case("search"):
							require_once("io/search.io.php");
							SearchIO::search($_GET['dialog']);
						break;
								
						case ("header_search"):
							require_once("io/search.io.php");
							SearchIO::header_search($_POST['string'], $_POST['current_module']);
						break;
						
						default:
							require_once("io/search.io.php");
							SearchIO::main();
						break;
						
					endswitch;
					
				break;
				
				default:
					
					if (isset($_GET['run']))
					{
						switch ($_GET['run']):
									
							// BASE
							case "sysmsg":
								require_once("io/base.io.php");
								BaseIO::list_system_messages();
							break;
							
							case "system_info":
								require_once("io/base.io.php");
								BaseIO::system_info();
							break;
							
							case "software_info":
								require_once("io/base.io.php");
								BaseIO::software_info();
							break;
							
							case "license":
								require_once("io/base.io.php");
								BaseIO::license();
							break;
							
							case "base_user_lists";
								if ($_GET['dialog'])
								{
									$module_dialog = ModuleDialog::get_by_type_and_internal_name("base_user_lists", $_GET['dialog']);
									
									if (file_exists($module_dialog['class_path']))
									{
										require_once($module_dialog['class_path']);
										
										if (class_exists($module_dialog['class']))
										{
											if(method_exists($module_dialog['class'], $module_dialog['method']))
											{
												$module_dialog['class']::$module_dialog['method']();
											}
											else
											{
												throw new BaseModuleDialogMethodNotFoundException();
											}
										}
										else
										{
											throw new BaseModuleDialogClassNotFoundException();
										}
									}
									else
									{
										throw new BaseModuleDialogFileNotFoundException();
									}
								}
								else
								{
									throw new BaseModuleDialogMissingException();
								}
							break;
							
							
							// USER
							case "user_profile":
								require_once("io/user.io.php");
								UserIO::profile();
							break;
							
							case ("user_details"):
								require_once("io/user.io.php");
								UserIO::details();
							break;
							
							case("user_change_personal"):
								require_once("io/user.io.php");
								UserIO::change_personal();
							break;
							
							case("user_change_my_settings"):
								require_once("io/user.io.php");
								UserIO::change_my_settings();
							break;
							
							case("user_change_password"):
								require_once("io/user.io.php");
								UserIO::change_password();
							break;
										
							default:
								require_once("io/home.io.php");
							break;
							
						endswitch;
					}
					else
					{
						require_once("io/home.io.php");
					}
				break;
				
			endswitch;
		}
	}
}
?>