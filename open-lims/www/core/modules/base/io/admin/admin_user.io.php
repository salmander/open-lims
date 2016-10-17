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
 * User Admin IO Class
 * @package base
 */
class AdminUserIO
{
	public static function home()
	{		
		$list = new List_IO("UserAdministration", "ajax.php?nav=base.admin", "admin_list_users", "admin_count_users", null, "UserAdministration");
		
		$list->add_column("","symbol",false,"16px");
		$list->add_column(Language::get_message("BaseGeneralListColumnUsername", "general"),"username",true,null);
		$list->add_column(Language::get_message("BaseGeneralListColumnName", "general"),"fullname",true,null);
		$list->add_column(Language::get_message("BaseGeneralListColumnGroups", "general"),"groups",false,null);
		$list->add_column(Language::get_message("BaseGeneralListColumnD", "general"),"delete",false,"16px");
		
		$template = new HTMLTemplate("base/user/admin/user/list.html");
		
		$paramquery = $_GET;
		$paramquery['action'] = "add";
		unset($paramquery['nextpage']);
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("add_params", $params);
		
		$template->set_var("list", $list->get_list());
		
		$template->output();	
	}
	
	public static function create()
	{
		if ($_GET['nextpage'] == 1)
		{
			$page_1_passed = true;
			
			if ($_POST['username'])
			{
				if (User::exist_username($_POST['username']) == true)
				{
					$page_1_passed = false;
					$error0 = "This username already exists";
				}
			}
			else
			{
				$page_1_passed = false;
				$error0 = "You must enter a username";
			}
			
			if (!$_POST['forename'])
			{
				$page_1_passed = false;
				$error1 = "You must enter a forename";
			}
			
			if (!$_POST['surname'])
			{
				$page_1_passed = false;
				$error1 = "You must enter a surname";
			}
			
			if (!$_POST['mail'])
			{
				$page_1_passed = false;
				$error2 = "You must enter an e-mail address";
			}
		}
		else
		{
			$page_1_passed = false;
			$error = "";
		}

		if ($page_1_passed == false)
		{
			$template = new HTMLTemplate("base/user/admin/user/add.html");
			
			$paramquery = $_GET;
			$paramquery['nextpage'] = "1";
			$params = http_build_query($paramquery,'','&#38;');
			
			$template->set_var("params",$params);
			
			if ($error0)
			{
				$template->set_var("error0", $error0);
			}
			else
			{
				$template->set_var("error0", "");	
			}
			
			if ($error1)
			{
				$template->set_var("error1", $error1);
			}
			else
			{
				$template->set_var("error1", "");	
			}
			
			if ($error2)
			{
				$template->set_var("error2", $error2);
			}
			else
			{
				$template->set_var("error2", "");	
			}
			
			if ($_POST['username'])
			{
				$template->set_var("username", $_POST['username']);
			}
			else
			{
				$template->set_var("username", "");
			}
			
			if ($_POST['gender'])
			{
				if ($_POST['gender'] == "m")
				{
					$template->set_var("male_checked", "checked='checked'");
					$template->set_var("female_checked", "");
				}
				else
				{
					$template->set_var("female_checked", "checked='checked'");
					$template->set_var("male_checked", "");
				}
			}
			else
			{
				$template->set_var("male_checked", "checked='checked'");
				$template->set_var("female_checked", "");
			}
			
			if ($_POST['title'])
			{
				$template->set_var("title", $_POST['title']);
			}
			else
			{
				$template->set_var("title", "");
			}
			
			if ($_POST['forename'])
			{
				$template->set_var("forename", $_POST['forename']);
			}
			else
			{
				$template->set_var("forename", "");
			}
			
			if ($_POST['surname'])
			{
				$template->set_var("surname", $_POST['surname']);
			}
			else
			{
				$template->set_var("surname", "");
			}
			
			if ($_POST['mail'])
			{
				$template->set_var("mail", $_POST['mail']);
			}
			else
			{
				$template->set_var("mail", "");
			}
			
			if ($_POST['can_change_password'])
			{
				if ($_POST['can_change_password'] == "true")
				{
					$template->set_var("can_change_password_checked", "checked='checked'");
				}
				else
				{
					$template->set_var("can_change_password_checked", "");
				}
			}
			else
			{
				$template->set_var("can_change_password_checked", "checked='checked'");
			}
			
			if ($_POST['must_change_password'])
			{
				if ($_POST['must_change_password'] == "true")
				{
					$template->set_var("must_change_password_checked", "checked='checked'");
				}
				else
				{
					$template->set_var("must_change_password_checked", "");
				}
			}
			else
			{
				$template->set_var("must_change_password_checked", "checked='checked'");
			}
			
			if ($_POST['disabled'])
			{
				if ($_POST['disabled'] == "true")
				{
					$template->set_var("disabled_checked", "");
				}
				else
				{
					$template->set_var("disabled_checked", "checked='checked'");
				}
			}
			else
			{
				$template->set_var("disabled_checked", "");
			}
			
			$template->output();
		}
		else
		{
			$paramquery = $_GET;
			unset($paramquery['nextpage']);
			unset($paramquery['action']);
			$params = http_build_query($paramquery);

			$user = new User(null);
			$new_password = $user->create($_POST['username'], 
								$_POST['gender'], 
								$_POST['title'], 
								$_POST['forename'], 
								$_POST['surname'], 
								$_POST['mail'], 
								$_POST['can_change_password'], 
								$_POST['must_change_password'], 
								$_POST['disabled']);
			
			
			$template = new HTMLTemplate("base/user/admin/user/add_proceed.html");
			
			$template->set_var("params", $params);
			$template->set_var("new_password", $new_password);
			
			$template->output();
		}
	}
	
	/**
	 * @throws UserIDMissingException
	 * @throws UserDeleteException
	 */
	public static function delete()
	{
		if ($_GET['id'])
		{
			$user_id = $_GET['id'];
			$user = new User($user_id);
			
			if ($user->check_delete_dependencies() == true)
			{
				if ($_GET['sure'] != "true")
				{
					$template = new HTMLTemplate("base/user/admin/user/delete.html");
					
					$paramquery = $_GET;
					$paramquery['sure'] = "true";
					$params = http_build_query($paramquery);
					
					$template->set_var("yes_params", $params);
							
					$paramquery = $_GET;
					unset($paramquery['sure']);
					unset($paramquery['action']);
					unset($paramquery['id']);
					$params = http_build_query($paramquery,'','&#38;');
					
					$template->set_var("no_params", $params);
					
					$template->output();
				}
				else
				{
					$paramquery = $_GET;
					unset($paramquery['sure']);
					unset($paramquery['action']);
					unset($paramquery['id']);
					$params = http_build_query($paramquery,'','&#38;');
					
					if ($user->delete())
					{							
						Common_IO::step_proceed($params, "Delete User", "Operation Successful" ,null);
					}
					else
					{							
						Common_IO::step_proceed($params, "Delete User", "Operation Failed" ,null);
					}		
				}
			}
			else
			{
				throw new UserDeleteException();
			}
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	/**
	 * @throws BaseModuleDialogMethodNotFoundException
	 * @throws BaseModuleDialogClassNotFoundException
	 * @throws BaseModuleDialogFileNotFoundException
	 * @throws UserIDMissingException
	 */
	public static function detail()
	{
		if ($_GET['id'])
		{
			$tab_io = new Tab_IO();
	
			$paramquery = $_GET;
			unset($paramquery['tab']);
			$params = http_build_query($paramquery,'','&#38;');
			
			$tab_io->add("detail", "User Details", $params, false);
			
			
			$paramquery = $_GET;
			$paramquery['tab'] = "groups";
			$params = http_build_query($paramquery,'','&#38;');
			
			$tab_io->add("groups", "Groups", $params, false);
			
			
			$module_dialog_array = ModuleDialog::list_dialogs_by_type("user_admin_detail");
			
			if (is_array($module_dialog_array) and count($module_dialog_array) >= 1)
			{
				foreach ($module_dialog_array as $key => $value)
				{
					$paramquery = $_GET;
					$paramquery['tab']			= "dialog";
					$paramquery['sub_dialog']	= $value['internal_name'];
					$params 					= http_build_query($paramquery,'','&#38;');
					
					$tab_io->add($value['internal_name'], Language::get_message($value['language_address'], "dialog"), $params, false);
				}
			}
			
			switch($_GET['tab']):
				
				case "groups":
					$tab_io->activate("groups");
				break;
			
				case "dialog":
					$tab_io->activate($_GET['sub_dialog']);
				break;
				
				default:
					$tab_io->activate("detail");
				break;
			
			endswitch;
				
			$tab_io->output();
			
			
			switch($_GET['tab']):

				case "groups":
					self::detail_groups();
				break;
				
				case "dialog":
					$module_dialog = ModuleDialog::get_by_type_and_internal_name("user_admin_detail", $_GET['sub_dialog']);
						
					if (file_exists($module_dialog['class_path']))
					{
						require_once($module_dialog['class_path']);
						
						if (class_exists($module_dialog['class']))
						{
							if (method_exists($module_dialog['class'], $module_dialog['method']))
							{
								$module_dialog['class']::$module_dialog['method']($_GET['id']);
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
				break;
				
				default:
					self::detail_home();
				break;
				
			endswitch;
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	private static function detail_home()
	{
		global $user;
		
		$user_id = $_GET['id'];
		
		$template = new HTMLTemplate("base/user/admin/user/detail.html");
					
		$current_user = new User($user_id);
		$current_user_regional = new Regional($user_id);
		
		// General
		
		if ($user_id == $user->get_user_id())
		{
			$template->set_var("change_username", false);
			if ($user_id == 1)
			{
				$template->set_var("is_not_system", false);
			}
			else
			{
				$template->set_var("is_not_system", true);
			}
		}
		else
		{
			if ($user_id == 1)
			{
				$template->set_var("change_username", false);
				$template->set_var("is_not_system", false);
			}
			else
			{
				$template->set_var("change_username", true);
				$template->set_var("is_not_system", true);
			}
		}

		$paramquery = $_GET;
		$paramquery['action'] = "rename";
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("username", $current_user->get_username());
		$template->set_var("rename_params", $params);
		
		
		$template->set_var("fullname", $current_user->get_full_name(false));
		
		
		$paramquery = $_GET;
		$paramquery['action'] = "change_mail";
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("mail", $current_user->get_profile("mail"));
		$template->set_var("change_mail_params", $params);
		
		
		$paramquery = $_GET;
		$paramquery['action'] = "change_password";
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("change_password_params", $params);
		
		
		// Administrative Settings
		
		$paramquery = $_GET;
		$paramquery['action'] = "change_boolean_entry";
		$paramquery['aspect'] = "mc_password";
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("mc_password_params", $params);
		
		if ($current_user->get_boolean_user_entry("must_change_password") == true)
		{
			$template->set_var("mc_password", "yes");
		}
		else
		{
			$template->set_var("mc_password", "no");
		}


		$paramquery = $_GET;
		$paramquery['action'] = "change_boolean_entry";
		$paramquery['aspect'] = "cc_password";
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("cc_password_params", $params);
		
		if ($current_user->get_boolean_user_entry("can_change_password") == true)
		{
			$template->set_var("cc_password", "yes");
		}
		else
		{
			$template->set_var("cc_password", "no");
		}
		
		
		$paramquery = $_GET;
		$paramquery['action'] = "change_boolean_entry";
		$paramquery['aspect'] = "secure_password";
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("secure_password_params", $params);
		
		if ($current_user->get_boolean_user_entry("secure_password") == true)
		{
			$template->set_var("secure_password", "yes");
		}
		else
		{
			$template->set_var("secure_password", "no");
		}
		
		
		$paramquery = $_GET;
		$paramquery['action'] = "change_boolean_entry";
		$paramquery['aspect'] = "block_write";
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("block_write_params", $params);
		
		if ($current_user->get_boolean_user_entry("block_write") == true)
		{
			$template->set_var("block_write", "yes");
		}
		else
		{
			$template->set_var("block_write", "no");
		}
		
		
		$paramquery = $_GET;
		$paramquery['action'] = "change_boolean_entry";
		$paramquery['aspect'] = "create_folder";
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("create_folder_params", $params);
		
		if ($current_user->get_boolean_user_entry("create_folder") == true)
		{
			$template->set_var("create_folder", "yes");
		}
		else
		{
			$template->set_var("create_folder", "no");
		}
		
		
		$paramquery = $_GET;
		$paramquery['action'] = "change_boolean_entry";
		$paramquery['aspect'] = "user_locked";
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("locked_params", $params);
		
		if ($current_user->get_boolean_user_entry("user_locked") == true)
		{
			$template->set_var("locked", "yes");
		}
		else
		{
			$template->set_var("locked", "no");
		}
		
		
		$paramquery = $_GET;
		$paramquery['action'] = "change_boolean_entry";
		$paramquery['aspect'] = "user_inactive";
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("inactive_params", $params);
		
		if ($current_user->get_boolean_user_entry("user_inactive") == true)
		{
			$template->set_var("inactive", "yes");
		}
		else
		{
			$template->set_var("inactive", "no");
		}
		
		
		// Module Settings
		
		$user_module_settings_dialog_array = ModuleDialog::list_dialogs_by_type("user_module_detail_setting");
	
		if (is_array($user_module_settings_dialog_array) and count($user_module_settings_dialog_array) >= 1)
		{
			$module_settings_array = array();
			$module_settings_counter = 0;
			
			foreach ($user_module_settings_dialog_array as $key => $value)
			{
				if (file_exists($value['class_path']))
				{
					require_once($value['class_path']);
					$module_settings_return = $value['class']::$value['method']($user_id);
					$module_settings_array[$module_settings_counter]['title'] = Language::get_message($value['language_address'], "dialog");
					$module_settings_array[$module_settings_counter]['value'] = $module_settings_return['value'];
					$module_settings_array[$module_settings_counter]['params'] = $module_settings_return['params'];
					$module_settings_counter++;
				}
			}
			
			$template->set_var("module_settings_array", $module_settings_array);
			$template->set_var("module_settings", true);
		}
		else
		{
			$template->set_var("module_settings", false);
		}
		
		// User Settings
		
		$paramquery = $_GET;
		$paramquery['action'] = "change_language";
		$params = http_build_query($paramquery,'','&#38;');
		
		$language = new Language($current_user_regional->get_language_id());
	
		$template->set_var("language", $language->get_full_name());
		$template->set_var("language_params", $params);
		
		
		$paramquery = $_GET;
		$paramquery['action'] = "change_timezone";
		$params = http_build_query($paramquery,'','&#38;');
		
		$timezone = new Timezone($current_user_regional->get_timezone_id());
		
		$template->set_var("timezone", $timezone->get_name());
		$template->set_var("timezone_params", $params);
				
		$template->output();
	}
	
	/**
	 * @todo rebuild with List and JS operations
	 */
	private static function detail_groups()
	{
		$user_id = $_GET['id'];
		
		$template = new HTMLTemplate("base/user/admin/user/detail_group.html");
					
		$current_user = new User($user_id);
		$template->set_var("username", $current_user->get_username());
		$template->set_var("fullname", $current_user->get_full_name(false));
		
		$paramquery = $_GET;
		$paramquery['action'] = "add_group";
		$params = http_build_query($paramquery,'','&#38;');
		
		$template->set_var("add_group_params", $params);
		
		$group_array = Group::list_user_releated_groups($user_id);
		$group_content_array = array();
		
		$counter = 0;
		
		if (is_array($group_array) and count($group_array) >= 1)
		{
			foreach($group_array as $key => $value) {
				
				$group = new Group($value);
				
				$paramquery = $_GET;
				$paramquery['action'] = "delete_group";
				$paramquery['key'] = $value;
				$params = http_build_query($paramquery,'','&#38;');
				
				$group_content_array[$counter]['name'] = $group->get_name();
				$group_content_array[$counter]['delete_params'] = $params;
				
				$counter++;
			}
			$template->set_var("no_group", false);
		}
		else
		{
			$template->set_var("no_group", true);
		}
		
		$template->set_var("group", $group_content_array);
		
		$template->output();
	}
	
	/**
	 * @throws UserIDMissingException
	 */
	public static function add_group()
	{
		if ($_GET['id'])
		{		
			if ($_GET['nextpage'] == 1)
			{
				if (is_numeric($_POST['group']))
				{
					$group = new Group($_POST['group']);
					if ($group->is_user_in_group($_GET['id']) == true)
					{
						$page_1_passed = false;
						$error = "The user is already member of this group.";
					}
					else
					{
						$page_1_passed = true;
					}
				}
				else
				{
					$page_1_passed = false;
					$error = "You must select a group.";
				}
			}
			elseif($_GET['nextpage'] > 1)
			{
				$page_1_passed = true;
			}
			else
			{
				$page_1_passed = false;
				$error = "";
			}
			
			if ($page_1_passed == false)
			{
				$template = new HTMLTemplate("base/user/admin/user/add_group.html");
				
				$paramquery = $_GET;
				$paramquery['nextpage'] = "1";
				$params = http_build_query($paramquery,'','&#38;');
				
				$template->set_var("params",$params);
				
				$template->set_var("error",$error);
				
				$group_array = Group::list_groups();
					
				$result = array();
				$counter = 0;
				
				foreach($group_array as $key => $value)
				{
					$group = new Group($value);
					$result[$counter]['value'] = $value;
					$result[$counter]['content'] = $group->get_name();
					$counter++;
				}
				
				$template->set_var("option",$result);
				
				$template->output();
			}
			else
			{
				$group = new Group($_POST['group']);
				
				$paramquery = $_GET;
				$paramquery['action'] = "detail";
				unset($paramquery['nextpage']);
				$params = http_build_query($paramquery,'','&#38;');
				
				if ($group->create_user_in_group($_GET['id']))
				{
					Common_IO::step_proceed($params, "Add Group", "Operation Successful", null);
				}
				else
				{
					Common_IO::step_proceed($params, "Add Group", "Operation Failed" ,null);	
				}
			}
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	/**
	 * @todo new exception for missing key (or rebuild)
	 * @throws UserIDMissingException
	 */
	public static function delete_group()
	{
		if ($_GET['id'])
		{
			if ($_GET['key'])
			{
				if ($_GET['sure'] != "true")
				{
					$template = new HTMLTemplate("base/user/admin/user/delete_group.html");
					
					$paramquery = $_GET;
					$paramquery['sure'] = "true";
					$params = http_build_query($paramquery);
					
					$template->set_var("yes_params", $params);
							
					$paramquery = $_GET;
					unset($paramquery['key']);
					$paramquery['action'] = "detail";
					$params = http_build_query($paramquery);
					
					$template->set_var("no_params", $params);
					
					$template->output();
				}
				else
				{
					$paramquery = $_GET;
					unset($paramquery['key']);
					unset($paramquery['sure']);
					$paramquery['action'] = "detail";
					$params = http_build_query($paramquery);
					
					$group = new Group($_GET['key']);		
							
					if ($group->delete_user_from_group($_GET['id']))
					{							
						Common_IO::step_proceed($params, "Delete Group", "Operation Successful" ,null);
					}
					else
					{							
						Common_IO::step_proceed($params, "Delete Group", "Operation Failed" ,null);
					}			
				}
			}
			else
			{
				// Error
			}
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	/**
	 * @todo IMPORTANT: remove bad dependency, replace with JS
	 * @throws UserIDMissingException
	 */
	public static function add_organisation_unit()
	{
		if ($_GET['id'])
		{			
			if ($_GET['nextpage'] == 1)
			{
				if (is_numeric($_POST['ou']))
				{
					$organisation_unit = new OrganisationUnit($_POST['ou']);
					if ($organisation_unit->is_user_in_organisation_unit($_GET['id']) == true)
					{
						$page_1_passed = false;
						$error = "The user is already member of this organisation unit.";
					}
					else
					{
						$page_1_passed = true;
					}
				}
				else
				{
					$page_1_passed = false;
					$error = "You must select an organisation unit.";
				}
			}
			elseif($_GET['nextpage'] > 1)
			{
				$page_1_passed = true;
			}
			else
			{
				$page_1_passed = false;
				$error = "";
			}
			
			if ($page_1_passed == false)
			{
				$template = new HTMLTemplate("base/user/admin/user/add_organisation_unit.html");
				
				$paramquery = $_GET;
				$paramquery['nextpage'] = "1";
				$params = http_build_query($paramquery,'','&#38;');
				
				$template->set_var("params",$params);
				
				$template->set_var("error",$error);
				
				$organisation_unit_array = OrganisationUnit::list_entries();
					
				$result = array();
				$counter = 0;
				
				foreach($organisation_unit_array as $key => $value)
				{
					$organisation_unit = new OrganisationUnit($value);
					$result[$counter]['value'] = $value;
					$result[$counter]['content'] = $organisation_unit->get_name();
					$counter++;
				}
				
				$template->set_var("option",$result);
				
				$template->output();
			}
			else
			{
				$organisation_unit = new OrganisationUnit($_POST['ou']);
				
				$paramquery = $_GET;
				$paramquery['action'] = "detail";
				unset($paramquery['nextpage']);
				$params = http_build_query($paramquery,'','&#38;');
				
				if ($organisation_unit->create_user_in_organisation_unit($_GET['id']))
				{
					Common_IO::step_proceed($params, "Add Organisation Unit", "Operation Successful", null);
				}
				else
				{
					Common_IO::step_proceed($params, "Add Organisation Unit", "Operation Failed" ,null);	
				}
			}
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	/**
	 * @todo IMPORTANT: bad dependency, replace with JS
	 * @throws UserIDMissingException
	 */
	public static function delete_organisation_unit()
	{
		if ($_GET['id'])
		{
			if ($_GET['key'])
			{
				if ($_GET['sure'] != "true")
				{
					$template = new HTMLTemplate("base/user/admin/user/delete_organisation_unit.html");
					
					$paramquery = $_GET;
					$paramquery['sure'] = "true";
					$params = http_build_query($paramquery);
					
					$template->set_var("yes_params", $params);
							
					$paramquery = $_GET;
					unset($paramquery['key']);
					$paramquery['action'] = "detail";
					$params = http_build_query($paramquery);
					
					$template->set_var("no_params", $params);
					
					$template->output();
				}
				else
				{
					$paramquery = $_GET;
					unset($paramquery['key']);
					unset($paramquery['sure']);
					$paramquery['action'] = "detail";
					$params = http_build_query($paramquery);
					
					$organisation_unit = new OrganisationUnit($_GET['key']);	
							
					if ($organisation_unit->delete_user_from_organisation_unit($_GET['id']))
					{							
						Common_IO::step_proceed($params, "Delete Organisation Unit", "Operation Successful" ,null);
					}
					else
					{							
						Common_IO::step_proceed($params, "Delete Organisation Unit", "Operation Failed" ,null);
					}			
				}
			}
			else
			{
				// Error
			}
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	/**
	 * @throws UserIDMissingException
	 */
	public static function rename()
	{
		if ($_GET['id'])
		{
			$user = new User($_GET['id']);
						
			if ($_GET['nextpage'] == 1)
			{
				if ($_POST['username'])
				{
					if ((User::exist_username($_POST['username']) == true) and ($_POST['username'] != $user->get_username()))
					{
						$page_1_passed = false;
						$error = "This username is already allocated.";
					}
					else
					{
						$page_1_passed = true;
					}
				}
				else
				{
					$page_1_passed = false;
					$error = "You must enter a username.";
				}
			}
			elseif($_GET['nextpage'] > 1)
			{
				$page_1_passed = true;
			}
			else
			{
				$page_1_passed = false;
				$error = "";
			}
			
			if ($page_1_passed == false)
			{
				$template = new HTMLTemplate("base/user/admin/user/rename.html");
				
				$paramquery = $_GET;
				$paramquery['nextpage'] = "1";
				$params = http_build_query($paramquery,'','&#38;');
				
				$template->set_var("params",$params);
				$template->set_var("error",$error);
				
				if ($_POST['username'])
				{
					$template->set_var("username", $_POST['username']);
				}
				else
				{
					$template->set_var("username", $user->get_username());
				}
				$template->output();
			}
			else
			{
				$paramquery = $_GET;
				$paramquery['action'] = "detail";
				unset($paramquery['nextpage']);
				$params = http_build_query($paramquery,'','&#38;');
				
				if ($user->set_username($_POST['username']))
				{
					Common_IO::step_proceed($params, "Rename User", "Operation Successful", null);
				}
				else
				{
					Common_IO::step_proceed($params, "Rename User", "Operation Failed" ,null);	
				}
			}
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	/**
	 * @throws UserIDMissingException
	 */
	public static function change_mail()
	{
		if ($_GET['id'])
		{
			$user = new User($_GET['id']);
						
			if ($_GET['nextpage'] == 1)
			{
				if ($_POST['mail'])
				{
					$page_1_passed = true;
				}
				else
				{
					$page_1_passed = false;
					$error = "You must enter a mail-address.";
				}
			}
			elseif($_GET['nextpage'] > 1)
			{
				$page_1_passed = true;
			}
			else
			{
				$page_1_passed = false;
				$error = "";
			}
			
			if ($page_1_passed == false)
			{
				$template = new HTMLTemplate("base/user/admin/user/change_mail.html");
				
				$paramquery = $_GET;
				$paramquery['nextpage'] = "1";
				$params = http_build_query($paramquery,'','&#38;');
				
				$template->set_var("params",$params);
				$template->set_var("error",$error);
				
				if ($_POST['mail'])
				{
					$template->set_var("mail", $_POST['mail']);
				}
				else
				{
					$template->set_var("mail", $user->get_profile("mail"));
				}
				$template->output();
			}
			else
			{
				$paramquery = $_GET;
				$paramquery['action'] = "detail";
				unset($paramquery['nextpage']);
				$params = http_build_query($paramquery,'','&#38;');
				
				if ($user->set_profile("mail", $_POST['mail']))
				{
					Common_IO::step_proceed($params, "Change Mail", "Operation Successful", null);
				}
				else
				{
					Common_IO::step_proceed($params, "Change Mail", "Operation Failed" ,null);	
				}
			}
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	/**
	 * @throws UserIDMissingException
	 */
	public static function change_password()
	{
		if ($_GET['id'])
		{		
			if ($_GET['nextpage'] == 1)
			{
				if ($_POST['password'])
				{
					$page_1_passed = true;
				}
				else
				{
					$page_1_passed = false;
					$error = "You must enter a new password.";
				}
			}
			elseif($_GET['nextpage'] > 1)
			{
				$page_1_passed = true;
			}
			else
			{
				$page_1_passed = false;
				$error = "";
			}
			
			if ($page_1_passed == false)
			{
				$template = new HTMLTemplate("base/user/admin/user/change_password.html");
				
				$paramquery = $_GET;
				$paramquery['nextpage'] = "1";
				$params = http_build_query($paramquery,'','&#38;');
				
				$template->set_var("params",$params);
				$template->set_var("error",$error);				
				
				$template->output();
			}
			else
			{
				$user = new User($_GET['id']);
				
				$paramquery = $_GET;
				$paramquery['action'] = "detail";
				unset($paramquery['nextpage']);
				$params = http_build_query($paramquery,'','&#38;');
				
				if ($user->set_password($_POST['password']))
				{
					Common_IO::step_proceed($params, "Set New Password", "Operation Successful", null);
				}
				else
				{
					Common_IO::step_proceed($params, "Set New Password", "Operation Failed" ,null);	
				}
			}
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	/**
	 * @throws UserIDMissingException
	 */
	public static function change_boolean_entry()
	{
		if ($_GET['id'])
		{
			$user = new User($_GET['id']);
		
			switch($_GET['aspect']):
			
				case "mc_password":
					if ($user->get_boolean_user_entry("must_change_password") == true) {
						$return = $user->set_boolean_user_entry("must_change_password", false);
					}else{
						$return = $user->set_boolean_user_entry("must_change_password", true);
					}
				break;
				
				case "cc_password":
					if ($user->get_boolean_user_entry("can_change_password") == true) {
						$return = $user->set_boolean_user_entry("can_change_password", false);
					}else{
						$return = $user->set_boolean_user_entry("can_change_password", true);
					}
				break;
			
				case "secure_password":
					if ($user->get_boolean_user_entry("secure_password") == true) {
						$return = $user->set_boolean_user_entry("secure_password", false);
					}else{
						$return = $user->set_boolean_user_entry("secure_password", true);
					}
				break;
				
				case "block_write":
					if ($user->get_boolean_user_entry("block_write") == true) {
						$return = $user->set_boolean_user_entry("block_write", false);
					}else{
						$return = $user->set_boolean_user_entry("block_write", true);
					}
				break;
				
				case "create_folder":
					if ($user->get_boolean_user_entry("create_folder") == true) {
						$return = $user->set_boolean_user_entry("create_folder", false);
					}else{
						$return = $user->set_boolean_user_entry("create_folder", true);
					}
				break;
				
				case "user_locked":
					if ($user->get_boolean_user_entry("user_locked") == true) {
						$return = $user->set_boolean_user_entry("user_locked", false);
					}else{
						$return = $user->set_boolean_user_entry("user_locked", true);
					}
				break;
				
				case "user_inactive":
					if ($user->get_boolean_user_entry("user_inactive") == true) {
						$return = $user->set_boolean_user_entry("user_inactive", false);
					}else{
						$return = $user->set_boolean_user_entry("user_inactive", true);
					}
				break;
			
			endswitch;
		
			$paramquery = $_GET;
			$paramquery['action'] = "detail";
			$params = http_build_query($paramquery,'','&#38;');
		
			if ($return == true)
			{
				Common_IO::step_proceed($params, "Change Value", "Operation Successful", null);
			}
			else
			{
				Common_IO::step_proceed($params, "Change Value", "Operation Failed" ,null);	
			}
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	/**
	 * @throws UserIDMissingException
	 */
	public static function change_language()
	{
		if ($_GET['id'])
		{
			$user = new User($_GET['id']);
			$regional = new Regional($_GET['id']);
						
			if ($_GET['nextpage'] == 1)
			{
				$page_1_passed = true;
			}
			else
			{
				$page_1_passed = false;
			}
			
			if ($page_1_passed == false)
			{
				$template = new HTMLTemplate("base/user/admin/user/change_language.html");
				
				$paramquery = $_GET;
				$paramquery['nextpage'] = "1";
				$params = http_build_query($paramquery,'','&#38;');
				
				$template->set_var("params",$params);
				
				$language_array = Language::list_languages();
				
				$result = array();
				$counter = 0;
				
				if (is_array($language_array))
				{
					foreach($language_array as $key => $value)
					{
						$language = new Language($value);
						
						$result[$counter]['value'] = $value;
						$result[$counter]['content'] = $language->get_full_name();
						
						if ($value == $regional->get_language_id())
						{
							$result[$counter]['selected'] = "selected='selected'";
						}
						else
						{
							$result[$counter]['selected'] = "";
						}
						$counter++;		
					}
				}
				
				$template->set_var("option",$result);
								
				$template->output();
			}
			else
			{
				$paramquery = $_GET;
				$paramquery['action'] = "detail";
				unset($paramquery['nextpage']);
				$params = http_build_query($paramquery,'','&#38;');
				
				if ($user->set_language_id($_POST['language']))
				{
					Common_IO::step_proceed($params, "Change Language", "Operation Successful", null);
				}
				else
				{
					Common_IO::step_proceed($params, "Change Language", "Operation Failed" ,null);	
				}
			}
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	/**
	 * @throws UserIDMissingException
	 */
	public static function change_timezone()
	{
		if ($_GET['id'])
		{
			$user = new User($_GET['id']);
			$regional = new Regional($_GET['id']);
						
			if ($_GET['nextpage'] == 1)
			{
				$page_1_passed = true;
			}
			else
			{
				$page_1_passed = false;
			}
			
			if ($page_1_passed == false)
			{
				$template = new HTMLTemplate("base/user/admin/user/change_timezone.html");
				
				$paramquery = $_GET;
				$paramquery['nextpage'] = "1";
				$params = http_build_query($paramquery,'','&#38;');
				
				$template->set_var("params",$params);
				
				$timezone_array = Timezone::list_timezones();
				
				$result = array();
				$counter = 0;
				
				if (is_array($timezone_array))
				{
					foreach($timezone_array as $key => $value)
					{
						$timezone = new Timezone($value);
						
						$result[$counter]['value'] = $value;
						$result[$counter]['content'] = $timezone->get_name();
						
						if ($value == $regional->get_timezone_id())
						{
							$result[$counter]['selected'] = "selected='selected'";
						}
						else
						{
							$result[$counter]['selected'] = "";
						}
						$counter++;
					}
				}
				$template->set_var("option",$result);			
				$template->output();
			}
			else
			{
				$paramquery = $_GET;
				$paramquery['action'] = "detail";
				unset($paramquery['nextpage']);
				$params = http_build_query($paramquery,'','&#38;');
				
				if ($user->set_timezone_id($_POST['timezone']))
				{
					Common_IO::step_proceed($params, "Change Timezone", "Operation Successful", null);
				}
				else
				{
					Common_IO::step_proceed($params, "Change Timezone", "Operation Failed" ,null);	
				}
			}
		}
		else
		{
			throw new UserIDMissingException();
		}
	}
	
	public static function handler()
	{			
		switch($_GET['action']):
			case "add":
				self::create();
			break;
			
			case "delete":
				self::delete();
			break;
			
			case "detail":
				self::detail();
			break;
			
			case "add_group":
				self::add_group();
			break;
			
			case "delete_group":
				self::delete_group();
			break;
			
			case "add_organisation_unit":
				self::add_organisation_unit();
			break;
			
			case "delete_organisation_unit":
				self::delete_organisation_unit();
			break;
			
			case "rename":
				self::rename();
			break;
			
			case "change_mail":
				self::change_mail();
			break;
			
			case "change_password":
				self::change_password();
			break;
			
			case "change_user_quota":
			case "change_project_quota":
				self::change_quota();
			break;
			
			case "change_boolean_entry":
				self::change_boolean_entry();
			break;
			
			case "change_language":
				self::change_language();
			break;
			
			case "change_timezone":
				self::change_timezone();
			break;
			
			default:
				self::home();
			break;
		endswitch;
	}
	
	public static function home_dialog()
	{
		$template = new HTMLTemplate("base/user/admin/user/home_dialog.html");
		
		$paramquery 				= array();
		$paramquery['username'] 	= $_GET['username'];
		$paramquery['session_id'] 	= $_GET['session_id'];
		$paramquery['nav'] 			= $_GET['nav'];
		$paramquery['run'] 			= "organisation";
		$paramquery['dialog'] 		= "users";
		$paramquery['action'] 		= "add";
		$params = http_build_query($paramquery, '', '&#38;');
		
		$template->set_var("user_add_params", $params);
		$template->set_var("user_amount", User::count_users());
		$template->set_var("user_administrators", User::count_administrators());
		
		return $template->get_string();
	}
	
	public static function get_icon()
	{
		return "users.png";
	}
}

?>